package model;

public class PayoutWithName {
    private ExpertPayout payout;
    private String expertName;

    public PayoutWithName(ExpertPayout payout, String expertName) {
        this.payout = payout;
        this.expertName = expertName;
    }

    public ExpertPayout getPayout() {
        return payout;
    }

    public String getExpertName() {
        return expertName;
    }
}