package model;

public class RatingDistribution {
    private int stars;
    private int count;
    private double percentage;
    
    public RatingDistribution() {
    }
    
    public int getStars() {
        return stars;
    }
    
    public void setStars(int stars) {
        this.stars = stars;
    }
    
    public int getCount() {
        return count;
    }
    
    public void setCount(int count) {
        this.count = count;
    }
    
    public double getPercentage() {
        return percentage;
    }
    
    public void setPercentage(double percentage) {
        this.percentage = percentage;
    }
}
