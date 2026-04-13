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
            ps.setInt(6, 0);
            ps.setDouble(7, event.getPricePerSeat());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    private synchronized String generateShortEventId() {
        int nextId = eventCounter.incrementAndGet();
        return "E" + String.format("%03d", nextId);
    }
    
    public void initializeCounter() throws SQLException {
        String sql = "SELECT MAX(CAST(SUBSTRING(event_id, 2) AS UNSIGNED)) as max_id FROM events WHERE event_id REGEXP '^E[0-9]+$'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                int maxId = rs.getInt("max_id");
                if (maxId > 0) {
                    eventCounter.set(maxId);
                } else {
                    eventCounter.set(100);
                }
            }
        }
    }
    
    // Get all events
    public List<Event> getAllEvents() throws SQLException {
        List<Event> events = new ArrayList<>();
        String sql = "SELECT * FROM events ORDER BY event_id ASC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Event event = new Event();
                event.setEventId(rs.getString("event_id"));
                event.setName(rs.getString("name"));
                event.setLocation(rs.getString("location"));
                event.setEventDate(rs.getDate("event_date"));
                event.setCapacity(rs.getInt("capacity"));
                event.setBookedSeats(rs.getInt("booked_seats"));
                event.setPricePerSeat(rs.getDouble("price_per_seat"));
                events.add(event);
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
                Event event = new Event();
                event.setEventId(rs.getString("event_id"));
                event.setName(rs.getString("name"));
                event.setLocation(rs.getString("location"));
                event.setEventDate(rs.getDate("event_date"));
                event.setCapacity(rs.getInt("capacity"));
                event.setBookedSeats(rs.getInt("booked_seats"));
                event.setPricePerSeat(rs.getDouble("price_per_seat"));
                return event;
            }
        }
        return null;
    }
    
    // UPDATE EVENT
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
            
            System.out.println("Updating event: " + event.getEventId());
            System.out.println("Name: " + event.getName());
            System.out.println("Location: " + event.getLocation());
            System.out.println("Date: " + event.getEventDate());
            System.out.println("Capacity: " + event.getCapacity());
            System.out.println("Price: " + event.getPricePerSeat());
            
            int result = ps.executeUpdate();
            return result > 0;
        }
    }
    
    // Update event seats
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
            if (isBooking) {
                ps.setInt(3, seats);
            }
            return ps.executeUpdate() > 0;
        }
    }
    
    // Delete event
    public boolean deleteEvent(String eventId) throws SQLException {
        String sql = "DELETE FROM events WHERE event_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, eventId);
            return ps.executeUpdate() > 0;
        }
    }
}