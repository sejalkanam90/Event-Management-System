package com.eventmanagement.servlet;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/searchEvents")
public class SearchEventsServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    
    // ✅ ADD THIS METHOD for POST requests ✅
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // POST requests should be handled same as GET
        doGet(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String keyword = request.getParameter("keyword");
        
        try {
            List<Event> allEvents = eventDAO.getAllEvents();
            List<Event> filteredEvents = new ArrayList<>();
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchTerm = keyword.toLowerCase().trim();
                for (Event e : allEvents) {
                    if (e.getName().toLowerCase().contains(searchTerm) ||
                        e.getLocation().toLowerCase().contains(searchTerm)) {
                        filteredEvents.add(e);
                    }
                }
            } else {
                filteredEvents = allEvents;
            }
            
            request.setAttribute("events", filteredEvents);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("searchEvents.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error searching events");
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
}