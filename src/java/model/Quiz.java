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
public class Quiz {

    private int quizID;
    private String name;
    private String description;
    private int timeLimit;
    private int duration;
    private double passRate;
    private int totalQuestion;
    private int courseID;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Navigation property
    private Course course;

}
