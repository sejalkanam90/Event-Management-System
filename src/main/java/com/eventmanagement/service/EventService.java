package com.eventmanagement.service;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Event;
import java.sql.SQLException;
import java.util.List;

public class EventService {
    
    private EventDAO eventDAO = new EventDAO();
    
    // Get all events
    public List<Event> getAllEvents() {
        try {
            return eventDAO.getAllEvents();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Get event by ID
    public Event getEventById(String eventId) {
        try {
            return eventDAO.getEventById(eventId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    // Update event seats
    public boolean updateSeats(String eventId, int seats, boolean isBooking) {
        try {
            return eventDAO.updateEventSeats(eventId, seats, isBooking);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Add new event
    public boolean addEvent(Event event) {
        try {
            return eventDAO.addEvent(event);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}