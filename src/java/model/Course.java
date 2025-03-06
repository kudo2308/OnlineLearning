package model;

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@ToString
@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter

public class Course {
    private int courseID;
    
    private String title;
    private String description;
    private int expertID;
    private float price;
    private int pricePackageID;
    private int categoryID;
    private String imageUrl;
    private int totalLesson;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Navigation properties
    private int register;
    private Account expert;
    private Category category;
    
}