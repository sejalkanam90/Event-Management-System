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

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {
    
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
            int totalEvents = eventDAO.getAllEvents().size();
            int totalUsers = userDAO.getAllUsers().size();
            int totalBookings = bookingDAO.getAllBookings().size();
            double totalRevenue = bookingDAO.getTotalRevenue();
            
            request.setAttribute("totalEvents", totalEvents);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("totalBookings", totalBookings);
            request.setAttribute("totalRevenue", totalRevenue);
            
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading reports: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}