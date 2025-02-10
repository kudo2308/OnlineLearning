/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mapper;

import DTOs.CreateCourseRequest;
import model.Course;

/**
 *
 * @author PC
 */
public class CourseMapper {
     public static Course mapCreateCoursetoCourse(CreateCourseRequest createCourseRequest){
        Course course = new Course();
        course.setTitle(createCourseRequest.getTitle());
        course.setDescription(createCourseRequest.getDescription());
        course.setCategoryID(createCourseRequest.getCategoryID());
        course.setTotalLesson(createCourseRequest.getTotalLesson());      
        course.setStatus(true);
        return course;
        
    }
}
