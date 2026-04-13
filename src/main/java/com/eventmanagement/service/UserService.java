package com.eventmanagement.service;

import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import java.sql.SQLException;

public class UserService {
    
    private UserDAO userDAO = new UserDAO();
    
    // User login
    public User login(String email, String password) {
        try {
            User user = userDAO.getUserByEmail(email);
            if (user != null && user.getPassword().equals(password)) {
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // User registration
    public boolean register(User user) {
        try {
            return userDAO.registerUser(user);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get user by email
    public User getUserByEmail(String email) {
        try {
            return userDAO.getUserByEmail(email);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}