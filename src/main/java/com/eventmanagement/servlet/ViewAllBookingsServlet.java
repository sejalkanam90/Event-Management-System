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

@WebServlet("/viewAllBookings")
public class ViewAllBookingsServlet extends HttpServlet {
    
    private BookingDAO bookingDAO = new BookingDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        try {
            List<Booking> bookings = bookingDAO.getAllBookings();
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("viewAllBookings.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}