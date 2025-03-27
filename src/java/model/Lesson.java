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
public class Lesson {

    private int lessonID;
    private String title;
    private String content;
    private String lessonType;
    private String videoUrl;
    private String documentUrl;
    private int duration;
    private int orderNumber;
    private int courseID;
    private int packageID;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Navigation property
    private Course course;
    private Packages packages;

}
