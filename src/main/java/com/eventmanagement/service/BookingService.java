package com.eventmanagement.service;

import com.eventmanagement.dao.BookingDAO;
import com.eventmanagement.model.Booking;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.User;
import com.eventmanagement.util.IdGenerator;
import java.sql.SQLException;
import java.util.List;

public class BookingService {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private EventService eventService = new EventService();
    
    public Booking book(User user, Event event, int seats) {
        try {
            // Check if seats are available
            if (event.getAvailableSeats() < seats) {
                System.out.println("Not enough seats available!");
                return null;
            }
            
            // Calculate total amount
            double totalAmount = seats * event.getPricePerSeat();
            String bookingId = IdGenerator.nextBookingId();
            
            // Create booking object using setters
            Booking booking = new Booking();
            booking.setBookingId(bookingId);
            booking.setUserId(user.getUserId());
            booking.setEventId(event.getEventId());
            booking.setSeats(seats);
            booking.setTotalAmount(totalAmount);
            booking.setStatus("CONFIRMED");
            
            // Save to database
            if (bookingDAO.createBooking(booking)) {
                // Update event seats in database
                eventService.updateSeats(event.getEventId(), seats, true);
                System.out.println("✅ Booking created: " + bookingId);
                return booking;
            } else {
                System.out.println("❌ Failed to create booking!");
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public boolean cancel(Booking booking) {
        try {
            if (bookingDAO.cancelBooking(booking.getBookingId())) {
                // Update event seats (add back)
                eventService.updateSeats(booking.getEventId(), booking.getSeats(), false);
                System.out.println("✅ Booking cancelled: " + booking.getBookingId());
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<Booking> getByUserId(String userId) {
        try {
            return bookingDAO.getBookingsByUserId(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    public Booking getById(String bookingId) {
        try {
            return bookingDAO.getBookingById(bookingId);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}