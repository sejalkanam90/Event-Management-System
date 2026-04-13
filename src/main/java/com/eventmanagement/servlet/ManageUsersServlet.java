package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageUsers")
public class ManageUsersServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading users: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}