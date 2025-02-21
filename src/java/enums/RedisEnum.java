package enums;

public enum RedisEnum {
    TTL_OTP(5*60),
    TTL_USER_PENDING(30*60),
    TTL_ENTER_OTP(30),
    TTL_PREVENT_ENTER_OTP(3*60),
    TTL_PREVENT_RESEND(5*60),
    TTL_SEND_RESEND(30);
    
    private final int time;

    RedisEnum(int time) {
        this.time = time;
    }

    public int getTime() {
        return this.time;
    }
   
}
