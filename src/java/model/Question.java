package model;

import java.sql.Timestamp;

public class Question {
    private int questionID;
    private String content;
    private String answerOptions;
    private String correctAnswer;
    private String explanation;
    private int pointPerQuestion;
    private int quizID;
    private boolean status;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Navigation property
    private Quiz quiz;
    
    public Question() {
    }
    
    public int getQuestionID() {
        return questionID;
    }
    
    public void setQuestionID(int questionID) {
        this.questionID = questionID;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getAnswerOptions() {
        return answerOptions;
    }
    
    public void setAnswerOptions(String answerOptions) {
        this.answerOptions = answerOptions;
    }
    
    public String getCorrectAnswer() {
        return correctAnswer;
    }
    
    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    
    public String getExplanation() {
        return explanation;
    }
    
    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }
    
    public int getPointPerQuestion() {
        return pointPerQuestion;
    }
    
    public void setPointPerQuestion(int pointPerQuestion) {
        this.pointPerQuestion = pointPerQuestion;
    }
    
    public int getQuizID() {
        return quizID;
    }
    
    public void setQuizID(int quizID) {
        this.quizID = quizID;
    }
    
    public boolean isStatus() {
        return status;
    }
    
    public void setStatus(boolean status) {
        this.status = status;
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
    
    public Quiz getQuiz() {
        return quiz;
    }
    
    public void setQuiz(Quiz quiz) {
        this.quiz = quiz;
    }
}
