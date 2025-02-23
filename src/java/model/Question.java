package model;

import java.sql.Timestamp;
import java.util.List;
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
public class Question {

    private int questionID;
    private String content;
    private int pointPerQuestion;
    private int quizID;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Navigation property
    private Quiz quiz;
    private Course course;
    private Lesson lession;
    private List<Answer> answers;

}
