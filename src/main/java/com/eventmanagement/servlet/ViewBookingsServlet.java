package com.eventmanagement.servlet;

import com.eventmanagement.dao.BookingDAO;
import com.eventmanagement.model.Booking;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/viewBookings")
public class ViewBookingsServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== ViewBookingsServlet CALLED ===");
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            System.out.println("Session is null - redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            System.out.println("User not logged in");
            response.sendRedirect("login.jsp");
            return;
        }
        
        System.out.println("User ID: " + user.getUserId());
        
        try {
            List<Booking> bookings = bookingDAO.getBookingsByUserId(user.getUserId());
            
            System.out.println("Bookings found: " + (bookings != null ? bookings.size() : 0));
            
            if (bookings != null) {
                for (Booking b : bookings) {
                    System.out.println("  - " + b.getBookingId() + " | " + b.getEventName() + " | " + b.getSeats() + " seats");
                }
            }
            
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("viewBookings.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}