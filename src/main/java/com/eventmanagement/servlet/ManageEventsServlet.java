package com.eventmanagement.servlet;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageEvents")
public class ManageEventsServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
      
        HttpSession session = request.getSession(false);
        
       
        if (session == null) {
            System.out.println("Session is null - redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        User admin = (User) session.getAttribute("user");
        
        
        if (admin == null) {
            System.out.println("User not logged in - redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        
        if (!"ADMIN".equals(admin.getRole())) {
            System.out.println("User is not admin - redirecting to userDashboard");
            response.sendRedirect("userDashboard");
            return;
        }
        
        try {
            List<Event> events = eventDAO.getAllEvents();
            request.setAttribute("events", events);
            request.getRequestDispatcher("manageEvents.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading events: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}