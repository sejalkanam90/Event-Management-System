package com.eventmanagement.dao;

import com.eventmanagement.model.Event;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public class EventDAO {
    
    private static AtomicInteger eventCounter = new AtomicInteger(100);
    
    static {
        try {
            EventDAO dao = new EventDAO();
            dao.initializeCounter();
        } catch (SQLException e) {
            System.err.println("Failed to initialize event counter: " + e.getMessage());
        }
    }
    
    // Initialize counter based on existing events
    public void initializeCounter() throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(event_id, 2) AS UNSIGNED)) as max_id FROM events WHERE event_id REGEXP '^E[0-9]+$'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                if (maxId > 0) {
                    eventCounter.set(maxId);
                    System.out.println("Event counter initialized to: " + maxId);
                } else {
                    eventCounter.set(100);
                }
            }
        }
    }
    
    
    private synchronized String generateShortEventId() {
        int nextId = eventCounter.incrementAndGet();
        return "E" + String.format("%03d", nextId);
    }
    
    // ==================== CREATE ====================
    
    // Add new event
    public boolean addEvent(Event event) throws SQLException {
        String sql = "INSERT INTO events (event_id, name, location, event_date, capacity, booked_seats, price_per_seat) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String eventId = generateShortEventId();
            event.setEventId(eventId);
            
            ps.setString(1, event.getEventId());
            ps.setString(2, event.getName());
            ps.setString(3, event.getLocation());
            ps.setDate(4, event.getEventDate());
            ps.setInt(5, event.getCapacity());
            ps.setInt(6, 0); // booked_seats starts at 0
            ps.setDouble(7, event.getPricePerSeat());
            
            int result = ps.executeUpdate();
            System.out.println("✅ Event added: " + eventId);
            return result > 0;
        }
    }
    
    // ==================== READ ====================
    
    // Get all events
    public List<Event> getAllEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY event_date ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                events.add(extractEvent(rs));
            }
        }
        return events;
    }
    
    // Get event by ID
    public Event getEventById(String eventId) throws SQLException {
        String sql = "SELECT * FROM events WHERE event_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, eventId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractEvent(rs);
            }
        }
        return null;
    }
    
    // Get upcoming events (date >= today)
    public List<Event> getUpcomingEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE event_date >= CURDATE() ORDER BY event_date ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                events.add(extractEvent(rs));
            }
        }
        return events;
    }
    
    // Search events by name or location
    public List<Event> searchEvents(String keyword) throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE name LIKE ? OR location LIKE ? ORDER BY event_date ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                events.add(extractEvent(rs));
            }
        }
        return events;
    }
    
    // ==================== UPDATE ====================
    
    // Update event details
    public boolean updateEvent(Event event) throws SQLException {
        String sql = "UPDATE events SET name = ?, location = ?, event_date = ?, capacity = ?, price_per_seat = ? WHERE event_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, event.getName());
            ps.setString(2, event.getLocation());
            ps.setDate(3, event.getEventDate());
            ps.setInt(4, event.getCapacity());
            ps.setDouble(5, event.getPricePerSeat());
            ps.setString(6, event.getEventId());
            
            int result = ps.executeUpdate();
            System.out.println("Event updated: " + event.getEventId());
            return result > 0;
        }
    }
    
   
    public boolean updateEventSeats(String eventId, int seats, boolean isBooking) throws SQLException {
        String sql;
        if (isBooking) {
            
            sql = "UPDATE events SET booked_seats = booked_seats + ? WHERE event_id = ? AND (capacity - booked_seats) >= ?";
        } else {
            
            sql = "UPDATE events SET booked_seats = booked_seats - ? WHERE event_id = ? AND booked_seats >= ?";
        }
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, seats);
            ps.setString(2, eventId);
            ps.setInt(3, seats);
            
            int rows = ps.executeUpdate();
            System.out.println("updateEventSeats - Event: " + eventId + ", Seats: " + seats + ", isBooking: " + isBooking);
            System.out.println("Rows affected: " + rows);
            return rows > 0;
        }
    }
    
    // ==================== DELETE ====================
    
    // Delete event
    public boolean deleteEvent(String eventId) throws SQLException {
        // First check if event has any bookings
        String checkSql = "SELECT COUNT(*) FROM bookings WHERE event_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(checkSql)) {
            
            ps.setString(1, eventId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                System.out.println("Cannot delete event with existing bookings!");
                return false;
            }
        }
        
        String sql = "DELETE FROM events WHERE event_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, eventId);
            int rows = ps.executeUpdate();
            System.out.println("Event deleted: " + eventId);
            return rows > 0;
        }
    }
    
    // ==================== STATISTICS ====================
    
    // Get total events count
    public int getTotalEvents() throws SQLException {
        String sql = "SELECT COUNT(*) FROM events";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Get total capacity
    public int getTotalCapacity() throws SQLException {
        String sql = "SELECT SUM(capacity) FROM events";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    // Get total booked seats
    public int getTotalBookedSeats() throws SQLException {
        String sql = "SELECT SUM(booked_seats) FROM events";
        
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
    
    // Extract Event from ResultSet
    private Event extractEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setEventId(rs.getString("event_id"));
        event.setName(rs.getString("name"));
        event.setLocation(rs.getString("location"));
        event.setEventDate(rs.getDate("event_date"));
        event.setCapacity(rs.getInt("capacity"));
        event.setBookedSeats(rs.getInt("booked_seats"));
        event.setPricePerSeat(rs.getDouble("price_per_seat"));
        
        try {
            event.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            
        }
        
        return event;
    }
}