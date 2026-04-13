package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {
    
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
        
        String name = request.getParameter("name");
        String mobile = request.getParameter("mobile");
        
        try {
            boolean updated = userDAO.updateProfile(user.getUserId(), name, mobile);
            
            if (updated) {
                user.setName(name);
                user.setMobile(mobile);
                session.setAttribute("user", user);
                request.setAttribute("message", "Profile updated successfully!");
            } else {
                request.setAttribute("error", "Failed to update profile!");
            }
            
            
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("adminProfile.jsp");
            } else {
                response.sendRedirect("profile.jsp");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("editProfile.jsp").forward(request, response);
        }
    }
}