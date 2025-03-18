/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package mapper;

import DTOs.CreateCourseRequest;
import DTOs.UpdateCourseRequest;
import model.Course;

public class CourseMapper {

    public static Course mapCreateCoursetoCourse(CreateCourseRequest createCourseRequest) {
        Course course = new Course();
        course.setTitle(createCourseRequest.getTitle());
        course.setDescription(createCourseRequest.getDescription());
        course.setCategoryID(createCourseRequest.getCategoryID());
        course.setTotalLesson(createCourseRequest.getTotalLesson());
        course.setStatus("Draft");
        course.setPrice(createCourseRequest.getPrice());
        return course;

    }

    public static void mapUpdateCoursetoCourse(Course course,  UpdateCourseRequest updateCourseRequest) {

        course.setTitle(updateCourseRequest.getTitle());
        course.setDescription(updateCourseRequest.getDescription());
        course.setCategoryID(updateCourseRequest.getCategoryID());
        course.setTotalLesson(updateCourseRequest.getTotalLesson());
        course.setStatus(updateCourseRequest.getStatus());
        course.setPrice(updateCourseRequest.getPrice());

    }
}
