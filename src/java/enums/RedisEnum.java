package enums;

public enum RedisEnum {
    TTL_OTP(3*60),
    TTL_USER_PENDING(30*60);
    
    private int time;
    
    private RedisEnum(int time) {
    this.time = time;
    }

    public int getTime() {
        return time;
    }
   
}
