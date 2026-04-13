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
        
        try {
            // Get booking details before cancelling
            Booking booking = bookingDAO.getBookingById(bookingId);
            
            if (booking == null || !booking.getUserId().equals(user.getUserId())) {
                session.setAttribute("error", "Invalid booking!");
                response.sendRedirect("viewBookings");
                return;
            }
            
            // Update booking status to CANCELLED
            boolean cancelled = bookingDAO.cancelBooking(bookingId);
            
            if (cancelled) {
                
                boolean seatsUpdated = eventDAO.updateEventSeats(booking.getEventId(), booking.getSeats(), false);
                System.out.println("Seats returned: " + seatsUpdated);
                System.out.println("Event ID: " + booking.getEventId());
                System.out.println("Seats returned: " + booking.getSeats());
                
                session.setAttribute("message", "Booking cancelled successfully! Seats are now available.");
            } else {
                session.setAttribute("error", "Failed to cancel booking!");
            }
            
            response.sendRedirect("viewBookings");
            
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
            response.sendRedirect("viewBookings");
        }
    }
}