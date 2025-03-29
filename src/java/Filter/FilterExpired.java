package Filter;

import config.OTP;
import jakarta.servlet.DispatcherType;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebFilter(
        filterName = "FilterExpired",
        urlPatterns = {""},
        dispatcherTypes = {DispatcherType.REQUEST}
)
public class FilterExpired implements Filter {

    private static final int MIN_TTL = 300;  // 5 phút
    private static final int EXTENDED_TTL = 24 * 60 * 60;  // 24 giờ

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        OTP otp = new OTP();
        String sessionId = null;
        Integer cookieTTL = null;

        if (req.getCookies() != null) {
            for (Cookie cookie : req.getCookies()) {
                if ("SessionID_User".equals(cookie.getName())) {
                    sessionId = cookie.getValue();
                    cookieTTL = cookie.getMaxAge();
                    break;
                }
            }
        }
        if (sessionId != null) {
            int sessionTTL = otp.getTTLSession(sessionId);
            if (sessionTTL < MIN_TTL || (cookieTTL != null && cookieTTL >= 0 && cookieTTL < MIN_TTL)) {
                otp.extendSessionTTL(sessionId);
                Cookie newCookie = new Cookie("SessionID_User", sessionId);
                newCookie.setMaxAge(EXTENDED_TTL);
                newCookie.setPath("/");
                newCookie.setHttpOnly(true);
                resp.addCookie(newCookie);
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
