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
                    = "local otp_key = 'Email:' .. KEYS[1] .. ':Otp' "
                    + "local attempts_key = 'Email:' .. KEYS[1] .. ':attempts' "
                    + "local lock_key = 'Email:' .. KEYS[1] .. ':lock' "
                    + "local lock_time = 180 "
                    + // 3 phút
                    "local otp = redis.call('GET', otp_key) "
                    + "local attempts = redis.call('GET', attempts_key) "
                    + "if redis.call('EXISTS', lock_key) == 1 then "
                    + "    return 'LOCKED' "
                    + "end "
                    + "if otp then "
                    + "    if attempts and tonumber(attempts) > 0 then "
                    + "        redis.call('DECR', attempts_key) "
                    + "    else "
                    + "        redis.call('SETEX', lock_key, lock_time, '1') "
                    + "        redis.call('SETEX', attempts_key, lock_time, '3') "
                    + "        return 'LOCKED' "
                    + "    end "
                    + "end "
                    + "return otp";

            Object result = redis.eval(luaScript, 1, email);
            return result != null ? result.toString() : null;
        } catch (Exception e) {
            return null;
        }
    }

    public void deleteOTP(String email) {
        String key = "Email:" + email + ":Otp";
        try (Jedis redis = Redis.getConnection()) {
            redis.del(key);
        } catch (Exception e) {
            //Config Error
        }
    }

    public String createSessionId(String email, String password, String fullname) {
        String sessionId = UUID.randomUUID().toString();
        try (Jedis redis = Redis.getConnection()) {
            redis.setex("Pending:" + sessionId, RedisEnum.TTL_USER_PENDING.getTime(), email + ":" + fullname + ":" + password);
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

    public void createSesssionIdApprove(String sessionId, String userID, String username, String roles, boolean premium) {
        try (Jedis redis = Redis.getConnection()) {
            redis.hset("session:" + sessionId, "userId", userID);
            redis.hset("session:" + sessionId, "username", username);
            redis.hset("session:" + sessionId, "roles", roles);
            redis.hset("session:" + sessionId, "premium", String.valueOf(premium));
        } catch (Exception e) {
            //Config Error
        }
    }

}
