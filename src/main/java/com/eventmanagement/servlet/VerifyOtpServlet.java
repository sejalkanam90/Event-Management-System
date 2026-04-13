package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.util.OTPUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/verifyOtp")
public class VerifyOtpServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String otp = request.getParameter("otp");
        
        System.out.println("=== VerifyOtpServlet ===");
        System.out.println("Email: " + email);
        System.out.println("OTP: " + otp);
        
        boolean isValid = OTPUtil.validateOTP(email, otp);
        
        if (isValid) {
            // Store email in session for password reset
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"OTP verified!\"}");
        } else {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid or expired OTP!\"}");
        }
    }
}