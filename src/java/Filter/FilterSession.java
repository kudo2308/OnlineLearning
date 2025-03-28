package Filter;

import config.OTP;
import java.io.IOException;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
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
        filterName = "FilterSession",
        urlPatterns = {"/home", "/userprofile", "/photo"},
        dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD, DispatcherType.INCLUDE}
)
public class FilterSession implements Filter {

    private final OTP otp = new OTP();

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Không cần khởi tạo gì thêm
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); // Không tạo session mới nếu chưa có
        Map<String, String> account = null;
        if (session == null || session.getAttribute("account") == null) {
            String sessionId = getSessionIdFromCookies(req);
            if (sessionId != null) {
                Map<String, String> sessionData = otp.getSessionData(sessionId);
                if (sessionData != null) {
                    session = req.getSession();
                    session.setAttribute("account", sessionData);
                }
            }
        } else {
            account = (Map<String, String>) session.getAttribute("account");
            String role = account.get("roles");
            if ("ADMIN".equalsIgnoreCase(role) && req.getRequestURI().endsWith("/home")) {
                res.sendRedirect(req.getContextPath() + "/admin-dashboard");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }

    private String getSessionIdFromCookies(HttpServletRequest req) {
        OTP otp = new OTP();
        if (req.getCookies() != null) {
            for (Cookie cookie : req.getCookies()) {
                if ("SessionID_User".equals(cookie.getName()) && otp.checkSessionUserExists(cookie.getValue())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}
