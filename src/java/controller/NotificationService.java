package controller;

import DAO.CourseDAO;
import DAO.LoginDAO;
import DAO.NotificationDAO;
import DAO.PaymentDAO;
import model.Notification;
import model.Account;
import model.Course;
import model.Registration;

import java.util.List;
import java.util.ArrayList;
import java.sql.Timestamp;
import java.util.Date;

/**
 * Service class for managing notifications across different user groups.
 * Handles sending notifications to all users, specific role groups, or
 * course-related users.
 */
public class NotificationService {

    private NotificationDAO notificationDAO;
    private LoginDAO accountDAO;
    private PaymentDAO registrationDAO;
    private CourseDAO courseDAO;

    public NotificationService(NotificationDAO notificationDAO, LoginDAO accountDAO, PaymentDAO registrationDAO, CourseDAO courseDAO) {
        this.notificationDAO = notificationDAO;
        this.accountDAO = accountDAO;
        this.registrationDAO = registrationDAO;
        this.courseDAO = courseDAO;
    }
    /**
     * Send notification to all users in the system
     *
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type (system, course, message, payment, other)
     * @param relatedID Related entity ID (optional)
     * @return Number of users notified
     */
    public int sendToAllUsers(String title, String content, String type, Integer relatedID) {
        List<Account> allUsers = accountDAO.getAllAccounts();
        int count = 0;

        for (Account user : allUsers) {
            Notification notification = createNotification(user.getUserID(), title, content, type, relatedID);
            if (notificationDAO.insertNotification(notification)) {
                count++;
            }
        }

        return count;
    }

    /**
     * Send notification to all users with a specific role
     *
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @param roleID Role ID to filter users
     * @return Number of users notified
     */
    public int sendToUsersByRole(String title, String content, String type, Integer relatedID, int roleID) {
        List<Account> users = accountDAO.getAccountsByRole(roleID);
        int count = 0;

        for (Account user : users) {
            Notification notification = createNotification(user.getUserID(), title, content, type, relatedID);
            if (notificationDAO.insertNotification(notification)) {
                count++;
            }
        }

        return count;
    }

    /**
     * Send notification to all experts
     *
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @return Number of experts notified
     */
    public int sendToAllExperts(String title, String content, String type, Integer relatedID) {
        // Assuming experts have roleID = 2
        return sendToUsersByRole(title, content, type, relatedID, 2);
    }

    /**
     * Send notification to all students
     *
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @return Number of students notified
     */
    public int sendToAllStudents(String title, String content, String type, Integer relatedID) {
        // Assuming students have roleID = 1
        return sendToUsersByRole(title, content, type, relatedID, 1);
    }

    /**
     * Send notification to all users enrolled in a specific course
     *
     * @param courseID Course ID
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional, defaults to courseID if
     * null)
     * @return Number of enrolled users notified
     */
    public int sendToCourseEnrollees(int courseID, String title, String content, String type, Integer relatedID) {
        List<Registration> registrations = registrationDAO.getRegistrationsByCourseID(courseID);
        int count = 0;

        // If relatedID is not provided, use courseID as the related ID
        if (relatedID == null) {
            relatedID = courseID;
        }

        for (Registration reg : registrations) {
            Notification notification = createNotification(reg.getUserID(), title, content, type, relatedID);
            if (notificationDAO.insertNotification(notification)) {
                count++;
            }
        }

        return count;
    }

    /**
     * Expert sends notification to all students enrolled in any of their
     * courses
     *
     * @param expertID Expert's user ID
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @return Number of students notified
     */
    public int expertSendToAllEnrollees(int expertID, String title, String content, String type, Integer relatedID) {
        List<Course> expertCourses = accountDAO.getCoursesByExpert(expertID);
        int count = 0;

        for (Course course : expertCourses) {
            count += sendToCourseEnrollees(course.getCourseID(), title, content, type, relatedID);
        }

        return count;
    }

    /**
     * Expert sends notification to all students enrolled in a specific course
     * Only proceeds if the expert is the owner of the course
     *
     * @param expertID Expert's user ID
     * @param courseID Course ID
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @return Number of students notified or -1 if unauthorized
     */
    public int expertSendToCourseEnrollees(int expertID, int courseID, String title, String content, String type, Integer relatedID) {
        Course course = courseDAO.findCourseById(courseID);

        // Verify the expert is the owner of the course
        if (course == null || course.getExpertID() != expertID) {
            return -1; // Unauthorized
        }

        return sendToCourseEnrollees(courseID, title, content, type, relatedID);
    }

    /**
     * Send notification to a specific user
     *
     * @param userID User ID to send notification to
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @return true if notification was sent successfully
     */
    public boolean sendToUser(int userID, String title, String content, String type, Integer relatedID) {
        Notification notification = createNotification(userID, title, content, type, relatedID);
        return notificationDAO.insertNotification(notification);
    }

    /**
     * Create a notification object with the given parameters
     *
     * @param userID User ID
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @return Notification object
     */
    private Notification createNotification(int userID, String title, String content, String type, Integer relatedID) {
        Notification notification = new Notification();
        notification.setUserID(userID);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setType(type);
        notification.setRelatedID(relatedID);
        notification.setIsRead(false);
        notification.setCreatedAt(new Timestamp(new Date().getTime()));
        return notification;
    }
}
