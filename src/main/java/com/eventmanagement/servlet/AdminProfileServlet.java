package com.eventmanagement.servlet;

import com.eventmanagement.dao.BookingDAO;
import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/adminProfile")
public class AdminProfileServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    private UserDAO userDAO = new UserDAO();
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
            // System Statistics
            int totalEvents = eventDAO.getAllEvents().size();
            int totalUsers = userDAO.getAllUsers().size();
            var allBookings = bookingDAO.getAllBookings();
            int totalBookings = allBookings != null ? allBookings.size() : 0;
            double totalRevenue = 0;
            int confirmedBookings = 0;
            int cancelledBookings = 0;
            int activeEvents = 0;
            
            if (allBookings != null) {
                for (var b : allBookings) {
                    totalRevenue += b.getTotalAmount();
                    if ("CONFIRMED".equals(b.getStatus())) confirmedBookings++;
                    else if ("CANCELLED".equals(b.getStatus())) cancelledBookings++;
                }
            }
            
            var events = eventDAO.getAllEvents();
            if (events != null) {
                for (var e : events) {
                    if (e.getAvailableSeats() > 0) activeEvents++;
                }
            }
            
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("confirmedBookings", confirmedBookings);
            request.setAttribute("cancelledBookings", cancelledBookings);
            request.setAttribute("activeEvents", activeEvents);
            
            request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading profile: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}