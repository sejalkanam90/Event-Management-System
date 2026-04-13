package com.eventmanagement.servlet;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String mobile = request.getParameter("mobile");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("error", "Name is required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email is required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Password is required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        try {
            // Check if email already exists
            User existingUser = userDAO.getUserByEmail(email);
            
            if (existingUser != null) {
                request.setAttribute("error", "Email already registered! Please use a different email or login.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Create new user
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setMobile(mobile);
            user.setPassword(password);
            user.setRole("USER");
            
            boolean registered = userDAO.registerUser(user);
            
            if (registered) {
                request.setAttribute("message", "Registration successful! Your User ID: " + user.getUserId());
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed! Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            
            // Check for duplicate entry error
            String errorMsg = e.getMessage();
            if (errorMsg.contains("Duplicate entry") || errorMsg.contains("duplicate key")) {
                request.setAttribute("error", "Email already registered! Please use a different email.");
            } else {
                request.setAttribute("error", "Registration failed: " + e.getMessage());
            }
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration error: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}