package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match!");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }
        
        if (!user.getPassword().equals(currentPassword)) {
            request.setAttribute("error", "Current password is incorrect!");
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            return;
        }
        
        try {
            boolean updated = userDAO.updatePassword(user.getUserId(), newPassword);
            
            if (updated) {
                user.setPassword(newPassword);
                session.setAttribute("user", user);
                request.setAttribute("message", "Password changed successfully!");
                
                
                if ("ADMIN".equals(user.getRole())) {
                    response.sendRedirect("adminProfile.jsp");
                } else {
                    response.sendRedirect("profile.jsp");
                }
            } else {
                request.setAttribute("error", "Failed to change password!");
                request.getRequestDispatcher("changePassword.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("changePassword.jsp").forward(request, response);
        }
    }
}