package com.eventmanagement.servlet;

import com.eventmanagement.dao.BookingDAO;
import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Booking;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/cancelBooking")
public class CancelBookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    private EventDAO eventDAO = new EventDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String bookingId = request.getParameter("bookingId");
        System.out.println("=== CancelBookingServlet ===");
        System.out.println("Booking ID: " + bookingId);
        System.out.println("User ID: " + user.getUserId());
        
        try {
            // Get booking details
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null) {
                System.out.println("Booking not found: " + bookingId);
                session.setAttribute("error", "Booking not found!");
                response.sendRedirect("viewBookings");
                return;
            }
            
            System.out.println("Booking found - Event ID: " + booking.getEventId());
            System.out.println("Seats: " + booking.getSeats());
            System.out.println("Current Status: " + booking.getStatus());
            
            // Check if booking belongs to current user
            if (!booking.getUserId().equals(user.getUserId())) {
                System.out.println("Unauthorized - Booking belongs to: " + booking.getUserId());
                session.setAttribute("error", "You cannot cancel this booking!");
                response.sendRedirect("viewBookings");
                return;
            }
            
            // Check if booking is already cancelled
            if ("CANCELLED".equals(booking.getStatus())) {
                System.out.println("Already cancelled");
                session.setAttribute("error", "Booking is already cancelled!");
                response.sendRedirect("viewBookings");
                return;
            }
            
            // Cancel booking
            boolean cancelled = bookingDAO.cancelBooking(bookingId);
            System.out.println("Cancel booking result: " + cancelled);
            
            if (cancelled) {
                // Return seats to event
                boolean seatsUpdated = eventDAO.updateEventSeats(booking.getEventId(), booking.getSeats(), false);
                System.out.println("Seats update result: " + seatsUpdated);
                
                System.out.println("Booking cancelled successfully: " + bookingId);
                session.setAttribute("message", "Booking cancelled successfully!");
            } else {
                System.out.println("Failed to cancel booking");
                session.setAttribute("error", "Failed to cancel booking!");
            }
            
            response.sendRedirect("viewBookings");
            
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Database error: " + e.getMessage());
            session.setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("viewBookings");
        }
    }
}