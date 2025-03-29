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
import java.sql.Timestamp;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

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
     * @param relatedLink
     * @return Number of users notified
     */
    public int sendToAllUsers(String title, String content, String type, Integer relatedID, String relatedLink) {
        List<Account> allUsers = accountDAO.getAllAccounts();
        int count = 0;

        for (Account user : allUsers) {
            Notification notification = createNotification(user.getUserID(), title, content, type, relatedID, relatedLink);
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
     * @param relatedLink
     * @return Number of users notified
     */
    public int sendToUsersByRole(String title, String content, String type, Integer relatedID, int roleID, String relatedLink) {
        List<Account> users = accountDAO.getAccountsByRole(roleID);
        int count = 0;

        for (Account user : users) {
            Notification notification = createNotification(user.getUserID(), title, content, type, relatedID, relatedLink);
            if (notificationDAO.insertNotification(notification)) {
                count++;
            }
        }

        return count;
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
     * @param relatedLink
     * @return Number of enrolled users notified
     */
    public int sendToCourseEnrollees(int courseID, String title, String content, String type, Integer relatedID, String relatedLink) {
        List<Registration> registrations = registrationDAO.getRegistrationsByCourseID(courseID);
        int count = 0;

        // If relatedID is not provided, use courseID as the related ID
        if (relatedID == null) {
            relatedID = courseID;
        }

        for (Registration reg : registrations) {
            Notification notification = createNotification(reg.getUserID(), title, content, type, relatedID, relatedLink);
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
     * @param relatedLink
     * @return Number of students notified
     */
    public int expertSendToAllEnrollees(int expertID, String title, String content, String type, Integer relatedID, String relatedLink) {
        List<Course> expertCourses = accountDAO.getCoursesByExpert(expertID);
        int count = 0;

        for (Course course : expertCourses) {
            count += sendToCourseEnrollees(course.getCourseID(), title, content, type, relatedID, relatedLink);
        }

        return count;
    }

    /**
     * Send notification to a specific user
     *
     * @param userID User ID to send notification to
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @param relatedLink
     * @return true if notification was sent successfully
     */
    public boolean sendToUser(int userID, String title, String content, String type, Integer relatedID, String relatedLink) {
        Notification notification = createNotification(userID, title, content, type, relatedID, relatedLink);
        return notificationDAO.insertNotification(notification);
    }

    public static void main(String[] args) {
        LoginDAO loginDAO = new LoginDAO();
        NotificationDAO notificationDAO = new NotificationDAO();
        CourseDAO courseDAO = new CourseDAO();
        PaymentDAO paymentDAO = new PaymentDAO();
        NotificationService service = new NotificationService(notificationDAO, loginDAO, paymentDAO, courseDAO);
        if (service.sendToCourseEnrollees(1, "ákdhfbsdfsd", "ádfasdfasdfsdf", "course", 0, "notifications") != 0) {
            System.out.println("Successfully");
        } else {
            System.out.println("Faild");
        }
    }

    /**
     * Send notifications to all users enrolled in courses belonging to a
     * specific expert
     *
     * @param expertID Expert's user ID
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @param relatedLink Related link
     * @return Number of users notified
     */
    public int sendToAllExpertCourseUsers(int expertID, String title, String content, String type, Integer relatedID, String relatedLink) {
        // Get all courses by the expert
        List<Course> expertCourses = accountDAO.getCoursesByExpert(expertID);

        // Use a set to ensure unique users across courses
        Set<Integer> uniqueUserIDs = new HashSet<>();

        for (Course course : expertCourses) {
            List<Registration> registrations = registrationDAO.getRegistrationsByCourseID(course.getCourseID());
            for (Registration reg : registrations) {
                uniqueUserIDs.add(reg.getUserID());
            }
        }

        int count = 0;
        for (Integer userID : uniqueUserIDs) {
            Notification notification = createNotification(
                    userID,
                    title,
                    content,
                    type,
                    relatedID,
                    relatedLink
            );
            if (notificationDAO.insertNotification(notification)) {
                count++;
            }
        }

        return count;
    }

    /**
     * Send notifications to users enrolled in multiple or specific courses
     *
     * @param courseIDs Array of course IDs to target
     * @param title Notification title
     * @param content Notification content
     * @param type Notification type
     * @param relatedID Related entity ID (optional)
     * @param relatedLink Related link
     * @return Number of users notified
     */
    public int sendToMultipleCoursesUsers(String[] courseIDs, String title, String content, String type, Integer relatedID, String relatedLink) {
        if (courseIDs == null || courseIDs.length == 0) {
            // If no courses specified, return 0
            return 0;
        }

        // Use a set to ensure unique users across courses
        Set<Integer> uniqueUserIDs = new HashSet<>();

        for (String courseIdStr : courseIDs) {
            int courseId = Integer.parseInt(courseIdStr);
            List<Registration> registrations = registrationDAO.getRegistrationsByCourseID(courseId);
            for (Registration reg : registrations) {
                uniqueUserIDs.add(reg.getUserID());
            }
        }

        int count = 0;
        for (Integer userID : uniqueUserIDs) {
            Notification notification = createNotification(
                    userID,
                    title,
                    content,
                    type,
                    relatedID,
                    relatedLink
            );
            if (notificationDAO.insertNotification(notification)) {
                count++;
            }
        }

        return count;
    }

    /**
     * Check if a specific user is enrolled in a given course
     *
     * @param userID User ID to check
     * @param courseID Course ID to check
     * @return true if user is enrolled, false otherwise
     */
    public boolean isUserEnrolledInCourse(int userID, int courseID) {
        List<Registration> registrations = registrationDAO.getRegistrationsByCourseID(courseID);

        return registrations.stream()
                .anyMatch(registration -> registration.getUserID() == userID);
    }

    /**
     * Get list of courses a specific user is enrolled in
     *
     * @param userID User ID
     * @return List of courses the user is enrolled in
     */
    public List<Course> getCoursesForUser(int userID) {
        return accountDAO.getRegisteredCoursesForUser(userID);
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
    private Notification createNotification(int userID, String title, String content, String type, Integer relatedID, String relatedLink) {
        Notification notification = new Notification();
        notification.setUserID(userID);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setType(type);
        notification.setRelatedID(relatedID);
        notification.setRelatedLink(relatedLink);
        notification.setIsRead(false);
        notification.setCreatedAt(new Timestamp(new Date().getTime()));

        return notification;
    }
}
    