package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import com.eventmanagement.service.EmailService;
import com.eventmanagement.util.OTPUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/sendOtp")
public class SendOtpServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        System.out.println("=== SendOtpServlet ===");
        System.out.println("Email: " + email);
        
        try {
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Email not found!\"}");
                return;
            }
            
            // Generate OTP
            String otp = OTPUtil.generateOTP();
            OTPUtil.storeOTP(email, otp);
            
            // Send OTP via email
            boolean emailSent = EmailService.sendOTPEmail(email, user.getName(), otp);
            
            if (emailSent) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"OTP sent to your email!\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to send OTP!\"}");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Database error!\"}");
        }
    }
}