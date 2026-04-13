package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import com.eventmanagement.util.OTPUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/resetPasswordWithOtp")
public class ResetPasswordWithOtpServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("resetEmail");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        System.out.println("=== ResetPasswordWithOtpServlet ===");
        System.out.println("Email: " + email);
        
        if (email == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Session expired! Please try again.\"}");
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Passwords do not match!\"}");
            return;
        }
        
        if (newPassword.length() < 6) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Password must be at least 6 characters!\"}");
            return;
        }
        
        try {
            User user = userDAO.getUserByEmail(email);
            
            if (user == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"User not found!\"}");
                return;
            }
            
            boolean updated = userDAO.updatePassword(user.getUserId(), newPassword);
            
            if (updated) {
                OTPUtil.removeOTP(email);
                session.removeAttribute("resetEmail");
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Password reset successful! Please login with your new password.\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to reset password!\"}");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Database error!\"}");
        }
    }
}