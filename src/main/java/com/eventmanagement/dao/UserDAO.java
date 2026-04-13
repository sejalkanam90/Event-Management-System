package com.eventmanagement.dao;

import com.eventmanagement.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class UserDAO {
    
    // Counter for sequential user IDs (U101, U102, U103...)
    private static AtomicInteger userCounter = new AtomicInteger(100);
    
    // Initialize counter from existing users in database
    static {
        try {
            UserDAO dao = new UserDAO();
            dao.initializeCounter();
        } catch (SQLException e) {
            System.err.println("Failed to initialize user counter: " + e.getMessage());
        }
    }
    
    // ==================== INITIALIZATION ====================
    
    public void initializeCounter() throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(user_id, 2) AS UNSIGNED)) as max_id FROM users WHERE user_id REGEXP '^U[0-9]+$'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                if (maxId > 0) {
                    userCounter.set(maxId);
                    System.out.println("📊 User counter initialized to: " + maxId);
                } else {
                    userCounter.set(100);
                }
            }
        }
    }
    
    // Generate short user ID (U101, U102, U103...)
    private synchronized String generateShortUserId() {
        int nextId = userCounter.incrementAndGet();
        return "U" + String.format("%03d", nextId);
    }
    
    // ==================== CREATE ====================
    
    // Register new user
    public boolean registerUser(User user) throws SQLException {
        // Check if email already exists
        if (getUserByEmail(user.getEmail()) != null) {
            System.out.println("Email already exists: " + user.getEmail());
            return false;
        }
        
        // Generate short user ID
        String userId = generateShortUserId();
        user.setUserId(userId);
        
        String sql = "INSERT INTO users (user_id, name, email, mobile, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUserId());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getMobile());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole() != null ? user.getRole() : "USER");
            
            int result = ps.executeUpdate();
            System.out.println("User registered with ID: " + user.getUserId());
            return result > 0;
        }
    }
    
    // ==================== READ ====================
    
    // Get user by email
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }
    
    // Get user by ID
    public User getUserById(String userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractUser(rs);
            }
        }
        return null;
    }
    
    // Get all users
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(extractUser(rs));
            }
        }
        return users;
    }
    
    // Validate user login
    public boolean validateUser(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            
            return rs.next();
        }
    }
    
    // ==================== UPDATE ====================
    
    // Update user profile
    public boolean updateProfile(String userId, String name, String mobile) throws SQLException {
        String sql = "UPDATE users SET name = ?, mobile = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, name);
            ps.setString(2, mobile);
            ps.setString(3, userId);
            
            int rows = ps.executeUpdate();
            System.out.println("✅ Profile updated for user: " + userId);
            return rows > 0;
        }
    }
    
    // Update user password
    public boolean updatePassword(String userId, String newPassword) throws SQLException {
        String sql = "UPDATE users SET password = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newPassword);
            ps.setString(2, userId);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                System.out.println("Password updated for user: " + userId);
            } else {
                System.out.println("Failed to update password for user: " + userId);
            }
            return rows > 0;
        }
    }
    
    // ==================== DELETE ====================
    
    // Delete user
    public boolean deleteUser(String userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userId);
            int rows = ps.executeUpdate();
            System.out.println("User deleted: " + userId);
            return rows > 0;
        }
    }
    
    // ==================== STATISTICS ====================
    
    // Get total users count
    public int getTotalUsers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Get admin users count
    public int getAdminCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'ADMIN'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Get regular users count
    public int getUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'USER'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // ==================== HELPER METHODS ====================
    
    // Extract User from ResultSet
    private User extractUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getString("user_id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setMobile(rs.getString("mobile"));
        user.setPassword(rs.getString("password"));
        
        try {
            user.setRole(rs.getString("role"));
        } catch (SQLException e) {
            user.setRole("USER");
        }
        
        try {
            user.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            
        }
        
        try {
            user.setCreatedAt(rs.getTimestamp("updated_at"));
        } catch (SQLException e) {
            
        }
        
        return user;
    }
}