package model;

public class Slider {
    private int sliderId;
    private String title;
    private String imageUrl;
    private String linkUrl;
    private int status; // 0: inactive, 1: active
    private String description;

    // Constructors
    public Slider() {}

    public Slider(int sliderId, String title, String imageUrl, String linkUrl, int status, String description) {
        this.sliderId = sliderId;
        this.title = title;
        this.imageUrl = imageUrl;
        this.linkUrl = linkUrl;
        this.status = status;
        this.description = description;
    }

    // Getters and Setters
    public int getSliderId() {
        return sliderId;
    }

    public void setSliderId(int sliderId) {
        this.sliderId = sliderId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}