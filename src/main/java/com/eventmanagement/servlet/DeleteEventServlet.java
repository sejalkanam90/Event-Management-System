package com.eventmanagement.servlet;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/deleteEvent")
public class DeleteEventServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ✅ FIX: Get session with create false ✅
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String eventId = request.getParameter("id");
        
        if (eventId == null || eventId.isEmpty()) {
            response.sendRedirect("manageEvents");
            return;
        }
        
        try {
            boolean deleted = eventDAO.deleteEvent(eventId);
            if (deleted) {
                request.setAttribute("message", "Event deleted successfully!");
            } else {
                request.setAttribute("error", "Failed to delete event!");
            }
            response.sendRedirect("manageEvents");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}