package model;

public class SocialLink {
    private int userId;
    private String xspace;
    private String youtube;
    private String facebook;
    private String linkedin;
    private String checkPrivate; 

    public SocialLink(int userId, String xspace, String youtube, String facebook, String linkedin, String checkPrivate) {
        this.userId = userId;
        this.xspace = xspace;
        this.youtube = youtube;
        this.facebook = facebook;
        this.linkedin = linkedin;
        this.checkPrivate = checkPrivate;
    }

    public SocialLink() {
    }
    
    public String getCheckPrivate() {
        return checkPrivate;
    }

    public void setCheckPrivate(String checkPrivate) {
        this.checkPrivate = checkPrivate;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getXspace() {
        return xspace;
    }
    public void setXspace(String xspace) {
        this.xspace = xspace;
    }
    public String getYoutube() {
        return youtube;
    }
    public void setYoutube(String youtube) {
        this.youtube = youtube;
    }
    public String getFacebook() {
        return facebook;
    }
    public void setFacebook(String facebook) {
        this.facebook = facebook;
    }
    public String getLinkedin() {
        return linkedin;
    }
    public void setLinkedin(String linkedin) {
        this.linkedin = linkedin;
    }
}
