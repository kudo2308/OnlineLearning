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
import java.util.List;
import java.util.Map;

@WebFilter(filterName = "FilterAll", urlPatterns = {"/*"}, dispatcherTypes = {DispatcherType.REQUEST, DispatcherType.FORWARD, DispatcherType.INCLUDE})
public class FilterAll implements Filter {

    private final OTP otp = new OTP();

    // Danh sách các đường dẫn không cần lọc
    private static final List<String> EXCLUDED_PATHS = List.of(
            "/login", "/register", "/changepass", "/verifyOTP", "/refeshOTP", "/Logingooglehandler", "/userprofile"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException{
        
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        String requestURI = req.getRequestURI();

        // Bỏ qua filter nếu URI nằm trong danh sách loại trừ
        if (EXCLUDED_PATHS.stream().anyMatch(requestURI::contains)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false); // Không tạo session mới nếu chưa có
        if (session == null || session.getAttribute("account") == null) {
            String sessionId = getSessionIdFromCookies(req);
            if (sessionId != null) {
                Map<String, String> sessionData = otp.getSessionData(sessionId);
                if (sessionData != null && !sessionData.isEmpty()) {
                    // Chỉ tạo session nếu dữ liệu hợp lệ
                    session = req.getSession(true);
                    session.setAttribute("account", sessionData);
                } else {
                    clearSessionCookie(res);
                    res.sendRedirect(req.getContextPath() + "/login.jsp");
                    return;
                }
            } else {
                res.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }
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
    private void clearSessionCookie(HttpServletResponse res) {
        Cookie cookie = new Cookie("SessionID_User", "");
        cookie.setMaxAge(0); // Xóa cookie
        cookie.setPath("/");
        res.addCookie(cookie);
    }
    @Override
    public void destroy(){
        
    }
}
