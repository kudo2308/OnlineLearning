package model;

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
public class Answer {
    private int answerID;
    private String content;
    private boolean isCorrect;
    private String explanation;
    private int questionID;
    
    // Navigation property
    private Question question;
}
