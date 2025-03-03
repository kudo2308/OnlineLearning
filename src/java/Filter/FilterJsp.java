package Filter;

import java.io.IOException;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

@WebFilter(
    filterName = "FilterJsp",
    urlPatterns = {"*.jsp"},
    dispatcherTypes = {DispatcherType.REQUEST}
)
public class FilterJsp implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        String requestURI = req.getRequestURI();
        if (requestURI.endsWith(".jsp") && !requestURI.contains("forgetpassword.jsp") && !requestURI.contains("register.jsp")) {
            req.getRequestDispatcher("/public/404.jsp").forward(request, response);
            return;
        }
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}