package controller;

import DAO.LoginDAO;
import DAO.ProfileDAO;
import config.OTP;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;
import java.util.regex.Pattern;
import model.Account;

@WebServlet(name = "userprofile", urlPatterns = {"/userprofile"})
public class Userprofile extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String errorprofile = request.getParameter("errorprofile");
        String success = request.getParameter("success");

        if (success != null) {
            request.setAttribute("success", success);
        }
        if (errorprofile != null) {
            request.setAttribute("errorprofile", errorprofile);
        }

        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        if (accountObj == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        request.setAttribute("fullname", acc.getFullName() != null ? acc.getFullName() : "");
        request.setAttribute("description", acc.getDescription() != null ? acc.getDescription() : "");
        request.setAttribute("phone", acc.getPhone() != null ? acc.getPhone() : "");
        request.setAttribute("address", acc.getAddress() != null ? acc.getAddress() : "");
        request.setAttribute("gender", acc.getGenderID() != null ? acc.getGenderID() : "");
        Date dob = acc.getDob();
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        String formattedDob = (dob != null) ? dateFormat.format(dob) : "";
        request.setAttribute("dob", formattedDob);

        request.getRequestDispatcher("userprofile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullname = request.getParameter("fullname");
        String description = request.getParameter("description");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");

        if (fullname == null || fullname.trim().isEmpty()) {
            response.sendRedirect("userprofile?errorprofile=FullName not empty and blank");
            return;
        }

        String phonePattern = "^[0-9]{10,11}$";
        if (!Pattern.matches(phonePattern, phone)) {
            response.sendRedirect("userprofile?errorprofile=Your phone format must digit and at least 10 digit");
            return;
        }

        // Lấy thông tin user từ session
        HttpSession session = request.getSession();
        Object accountObj = session.getAttribute("account");

        String userID = null;
        if (accountObj instanceof Map) {
            Map<String, String> accountData = (Map<String, String>) accountObj;
            userID = accountData.get("userId");
        }

        LoginDAO dao = new LoginDAO();
        Account acc = dao.getAccountByUserID(userID);

        Date dob = null;
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                formatter.setLenient(false);
                dob = formatter.parse(dobStr);

                // Không cho phép nhập ngày tương lai
                if (dob.after(new Date())) {
                    response.sendRedirect("userprofile?errorprofile=Date of birth cannot be in the future");
                    return;
                }
            } catch (ParseException e) {
                response.sendRedirect("userprofile?errorprofile=Invalid date format. Please use YYYY-MM-DD");
                return;
            }
        } else {
            dob = acc.getDob();
        }
        acc.setFullName(fullname);
        acc.setDescription(description != null ? description : "");
        acc.setPhone(phone != null ? phone : "");
        acc.setAddress(address != null ? address : "");
        acc.setGenderID(gender);
        if (dob != null) {
            acc.setDob(dob);
        }

        request.setAttribute("fullname", acc.getFullName());
        request.setAttribute("description", acc.getDescription());
        request.setAttribute("phone", acc.getPhone());
        request.setAttribute("address", acc.getAddress());
        request.setAttribute("gender", acc.getGenderID());

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String formattedDob = acc.getDob() != null ? dateFormat.format(acc.getDob()) : "";
        request.setAttribute("dob", formattedDob);

        OTP otp = new OTP();
        String sessionId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("SessionID_User".equals(cookie.getName())) {
                    sessionId = cookie.getValue();
                    break;
                }
            }
        }
        otp.updateSessionField(sessionId, "username", acc.getFullName());
        otp.updateSessionField(sessionId, "description", acc.getDescription());

        ProfileDAO d = new ProfileDAO();
        d.updateUserProfile(acc);

        response.sendRedirect("userprofile?success=You save change success");
    }
}
