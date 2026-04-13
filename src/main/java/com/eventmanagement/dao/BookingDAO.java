package com.eventmanagement.dao;

import com.eventmanagement.model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class BookingDAO {
    
    // Counter for sequential booking IDs
    private static AtomicInteger bookingCounter = new AtomicInteger(100);
    
    // Initialize counter from database
    static {
        try {
            BookingDAO dao = new BookingDAO();
            dao.initializeCounter();
        } catch (SQLException e) {
            System.err.println("Failed to initialize booking counter: " + e.getMessage());
        }
    }
    
    // Initialize counter based on existing bookings
    public void initializeCounter() throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(booking_id, 2) AS UNSIGNED)) as max_id FROM bookings WHERE booking_id REGEXP '^B[0-9]+$'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                if (maxId > 0) {
                    bookingCounter.set(maxId);
                    System.out.println("📊 Booking counter initialized to: " + maxId);
                } else {
                    bookingCounter.set(100);
                }
            }
        }
    }
    
    // Generate next booking ID (B101, B102, B103...)
    private synchronized String generateNextBookingId() {
        int nextId = bookingCounter.incrementAndGet();
        return "B" + String.format("%03d", nextId);
    }
    
    // Create new booking with auto-generated ID
    public boolean createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (booking_id, user_id, event_id, seats, total_amount, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Generate next booking ID automatically
            String bookingId = generateNextBookingId();
            booking.setBookingId(bookingId);
            
            ps.setString(1, booking.getBookingId());
            ps.setString(2, booking.getUserId());
            ps.setString(3, booking.getEventId());
            ps.setInt(4, booking.getSeats());
            ps.setDouble(5, booking.getTotalAmount());
            ps.setString(6, "CONFIRMED");
            
            int result = ps.executeUpdate();
            System.out.println("✅ Booking created: " + bookingId);
            return result > 0;
        }
    }
    
    // Get booking by ID
    public Booking getBookingById(String bookingId) throws SQLException {
        String sql = "SELECT b.*, e.name as event_name FROM bookings b " +
                     "JOIN events e ON b.event_id = e.event_id " +
                     "WHERE b.booking_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractBooking(rs);
            }
        }
        return null;
    }
    
    // Get bookings by user ID
    public List<Booking> getBookingsByUserId(String userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, e.name as event_name FROM bookings b " +
                     "JOIN events e ON b.event_id = e.event_id " +
                     "WHERE b.user_id = ? ORDER BY b.booking_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                bookings.add(extractBooking(rs));
            }
        }
        return bookings;
    }
    
    // Get all bookings
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, e.name as event_name FROM bookings b " +
                     "JOIN events e ON b.event_id = e.event_id " +
                     "ORDER BY b.booking_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bookings.add(extractBooking(rs));
            }
        }
        return bookings;
    }
    
    // Cancel booking
    public boolean cancelBooking(String bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status = 'CANCELLED' WHERE booking_id = ? AND status = 'CONFIRMED'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, bookingId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Get total revenue
    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM bookings WHERE status = 'CONFIRMED'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0;
    }
    
    // Extract booking from ResultSet
    private Booking extractBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getString("booking_id"));
        booking.setUserId(rs.getString("user_id"));
        booking.setEventId(rs.getString("event_id"));
        booking.setSeats(rs.getInt("seats"));
        booking.setTotalAmount(rs.getDouble("total_amount"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setStatus(rs.getString("status"));
        
        try {
            booking.setEventName(rs.getString("event_name"));
        } catch (SQLException e) {
            // Column doesn't exist
        }
        
        return booking;
    }
}