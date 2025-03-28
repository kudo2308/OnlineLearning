package Filter;

import config.OTP;
import java.io.IOException;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Map;

@WebFilter(
        filterName = "RoleFilter",
        urlPatterns = {
            // URL cho Expert
             "/addCourse", "/addLesson", "/updateLesson", "/viewLessonForAd", "/addQuestion", "/AddQuestion", "/manageQuestion",
            "/updateQuestion", "/AddQuiz", "/quiz", "/Test", "/Review", "/Quiz",
            // URL cho Admin
            "/admin-dashboard", "/UserList"
        },
        dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD}
)
public class RoleFilter implements Filter {

    private final OTP otp = new OTP();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        Map<String, String> account = null;
        if (session == null || session.getAttribute("account") == null) {
            String sessionId = getSessionIdFromCookies(req);
            if (sessionId != null) {
                Map<String, String> sessionData = otp.getSessionData(sessionId);
                if (sessionData != null) {
                    session = req.getSession();
                    session.setAttribute("account", sessionData);
                    account = sessionData;
                }
            }
        } else {
            account = (Map<String, String>) session.getAttribute("account");
        }
        if (account == null) {
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        String role = account.get("roles");
        String requestURI = req.getRequestURI();
        boolean hasPermission = checkPermission(role, requestURI);
        if (!hasPermission) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        chain.doFilter(request, response);
    }

    private String getSessionIdFromCookies(HttpServletRequest req) {
        if (req.getCookies() != null) {
            for (Cookie cookie : req.getCookies()) {
                if ("SessionID_User".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    private boolean checkPermission(String role, String requestURI) {
        if (role == null) {
            return false;
        }
        String[] expertURLs = {
             "/addCourse", "/addLesson", "/updateLesson", "/viewLessonForAd", "/addQuestion", "/AddQuestion",
            "/manageQuestion", "/updateQuestion", "/AddQuiz", "/quiz", "/Test", "/Review", "/Quiz"
        };
        String[] adminURLs = {
            "/admin-dashboard", "/UserList"
        };
        boolean isExpertURL = false;
        for (String url : expertURLs) {
            if (requestURI.endsWith(url)) {
                isExpertURL = true;
                break;
            }
        }
        if (isExpertURL && "EXPERT".equalsIgnoreCase(role)) {
            return true;
        }
        boolean isAdminURL = false;
        for (String url : adminURLs) {
            if (requestURI.endsWith(url)) {
                isAdminURL = true;
                break;
            }
        }
        if (isAdminURL && "ADMIN".equalsIgnoreCase(role)) {
            return true;
        }
        return false;
    }
}
