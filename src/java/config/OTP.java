package config;

import enums.RedisEnum;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.UUID;
import redis.clients.jedis.Jedis;

public class OTP {

    public int createOTP(String email) {
        SecureRandom secureRandom = new SecureRandom();
        int random = 100000 + secureRandom.nextInt(900000);
        String otp = random + "";
        String script = "redis.call('SETEX', KEYS[1], ARGV[1], ARGV[2]); "
                + "redis.call('SETEX', KEYS[2], ARGV[1], '3'); ";
        try (Jedis redis = Redis.getConnection()) {
            String otpKey = "Email:" + email + ":Otp";
            String attemptsKey = "Email:" + email + ":attempts";
            int ttl = RedisEnum.TTL_OTP.getTime();

            redis.eval(script,
                    Arrays.asList(otpKey, attemptsKey),
                    Arrays.asList(String.valueOf(ttl), otp));
            return random;
        } catch (Exception e) {
            return -1;
        }
    }

    public String getOTP(String email) {
        try (Jedis redis = Redis.getConnection()) {
            String luaScript
                    = "local otp_key = 'Email:' .. KEYS[1] .. ':Otp'\n"
                    + "local attempts_key = 'Email:' .. KEYS[1] .. ':attempts'\n"
                    + "local lock_key = 'Email:' .. KEYS[1] .. ':lock'\n"
                    + "local lock_time = 180  -- Giả sử TTL_PREVENT_ENTER_OTP là 180 giây (3 phút)\n"
                    + "\n"
                    + "local otp = redis.call('GET', otp_key)\n"
                    + "local attempts = redis.call('GET', attempts_key)\n"
                    + "\n"
                    + "if redis.call('EXISTS', lock_key) == 1 then\n"
                    + "    return 'LOCKED'\n"
                    + "end\n"
                    + "\n"
                    + "if otp then\n"
                    + "    if attempts and tonumber(attempts) > 0 then\n"
                    + "        redis.call('DECR', attempts_key)\n"
                    + "    else\n"
                    + "        redis.call('SETEX', lock_key, lock_time, '1')\n"
                    + "        redis.call('SETEX', attempts_key, 180, '3')  -- Gán lại attempts là 3\n"
                    + "        return 'LOCKED'\n"
                    + "    end\n"
                    + "end\n"
                    + "\n"
                    + "return otp";

            Object result = redis.eval(luaScript, 1, email);
            return result != null ? result.toString() : null;
        } catch (Exception e) {
            return null;
        }
    }

    public String getLock(String email) {
        String key = "Email:" + email + ":lock";
        String value = null;
        try (Jedis redis = Redis.getConnection()) {
            value = redis.get(key);
        } catch (Exception e) {
            //Config Error
        }
        return value;
    }

    public void deleteOTP(String email) {
        String otpKey = "Email:" + email + ":Otp";
        String attemptsKey = "Email:" + email + ":attempts";
        String lockKey = "Email:" + email + ":lock";

        try (Jedis redis = Redis.getConnection()) {
            redis.del(otpKey, attemptsKey, lockKey);
        } catch (Exception e) {
            // Log lỗi nếu cần
        }
    }

    public String createSessionId(String email, String password, String fullname, String role , String process) {
        String sessionId = UUID.randomUUID().toString();
        try (Jedis redis = Redis.getConnection()) {
            redis.setex("Pending:" + sessionId, RedisEnum.TTL_USER_PENDING.getTime(), email + ":" + fullname + ":" + password + ":" + role +":"+process);
        } catch (Exception e) {
            //Config Error
        }
        return sessionId;
    }

    public String getSessionId(String sessionId) {
        String key = "Pending:" + sessionId;
        String value = null;
        try (Jedis redis = Redis.getConnection()) {
            value = redis.get(key);
        } catch (Exception e) {
            //Config Error
        }
        return value;
    }

    public void deleteSesssionId(String sessionId) {
        String key = "Pending:" + sessionId;
        try (Jedis redis = Redis.getConnection()) {
            redis.del(key);
        } catch (Exception e) {
            //Config Error
        }
    }

    public void createSesssionIdApprove(String sessionId, int userID, String username, String roles, String subscriptiontype) {
        try (Jedis redis = Redis.getConnection()) {
            redis.hset("session:" + sessionId, "userId", userID+"");
            redis.hset("session:" + sessionId, "username", username);
            redis.hset("session:" + sessionId, "roles", roles);
            redis.hset("session:" + sessionId, "subscriptiontype", String.valueOf(subscriptiontype));
        } catch (Exception e) {
            //Config Error
        }
    }

    public boolean checkSessionUserExists(String sessionId) {
        try (Jedis redis = Redis.getConnection()) {
            String otp = redis.hget("session:" + sessionId, "userId");
            return otp != null; 
        } catch (Exception e) {
            return false; 
        }
    }

    // tạo count  = 3 giảm dần = 0 thì locked và xóa cout 
    public String decreaseCount(String email) {
        try (Jedis redis = Redis.getConnection()) {
            String luaScript = "local count_key = KEYS[1] "
                    + "local lock_key = KEYS[2] "
                    + "if redis.call('EXISTS', lock_key) == 1 then return 'LOCKED' end "
                    + "local count = redis.call('GET', count_key) "
                    + "if not count then count = 3 end "
                    + "count = tonumber(count) - 1 "
                    + "redis.call('SET', count_key, count, 'EX',300) "
                    + "if count <= 0 then "
                    + "   redis.call('SETEX', lock_key, 300, 'LOCKED') "
                    + "   redis.call('DEL', count_key) "
                    + "   return 'LOCKED' "
                    + "end "
                    + "return count";

            String countKey = "Resend:" + email + ":count";
            String lockKey = "Resend:" + email + ":lock";

            Object result = redis.eval(luaScript, Arrays.asList(countKey, lockKey), Arrays.asList());
            return result.toString();
        }
    }

    public String getLockResend(String email) {
        String key = "Resend:" + email + ":lock";
        String value = null;
        try (Jedis redis = Redis.getConnection()) {
            value = redis.get(key);
        } catch (Exception e) {
            //Config Error
        }
        return value;
    }

    public void deleteAttempts(String email) {
        String key = "Email:" + email + ":attempts";
        try (Jedis redis = Redis.getConnection()) {
            redis.del(key);
        } catch (Exception e) {
            //Config Error
        }
    }

    public void deleteResend(String email) {
        String key = "Resend:" + email + ":count";
        try (Jedis redis = Redis.getConnection()) {
            redis.del(key);
        } catch (Exception e) {
            //Config Error
        }
    }
}
