package model;

import java.sql.Timestamp;

public class Settings {
    private int settingID;
    private String key;
    private String value;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    public Settings() {
    }
    
    public int getSettingID() {
        return settingID;
    }
    
    public void setSettingID(int settingID) {
        this.settingID = settingID;
    }
    
    public String getKey() {
        return key;
    }
    
    public void setKey(String key) {
        this.key = key;
    }
    
    public String getValue() {
        return value;
    }
    
    public void setValue(String value) {
        this.value = value;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
