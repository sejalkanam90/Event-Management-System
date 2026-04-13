package com.eventmanagement.servlet;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/editEvent")
public class EditEventServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== EditEventServlet doGet CALLED ===");
        
        HttpSession session = request.getSession(false);
        
        if (session == null) {
            System.out.println("Session is null");
            response.sendRedirect("login.jsp");
            return;
        }
        
        User admin = (User) session.getAttribute("user");
        
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            System.out.println("User not admin");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String eventId = request.getParameter("id");
        System.out.println("Event ID to edit: " + eventId);
        
        if (eventId == null || eventId.isEmpty()) {
            System.out.println("No event ID provided");
            response.sendRedirect("manageEvents");
            return;
        }
        
        try {
            Event event = eventDAO.getEventById(eventId);
            if (event == null) {
                System.out.println("Event not found: " + eventId);
                response.sendRedirect("manageEvents");
                return;
            }
            
            System.out.println("Event found: " + event.getName());
            request.setAttribute("event", event);
            request.getRequestDispatcher("editEvent.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading event: " + e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== EditEventServlet doPost CALLED ===");
        
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
        
        String eventId = request.getParameter("eventId");
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("date");
        String capacityStr = request.getParameter("capacity");
        String priceStr = request.getParameter("price");
        
        System.out.println("Updating event: " + eventId);
        System.out.println("Name: " + name);
        System.out.println("Location: " + location);
        System.out.println("Date: " + dateStr);
        System.out.println("Capacity: " + capacityStr);
        System.out.println("Price: " + priceStr);
        
        try {
            int capacity = Integer.parseInt(capacityStr);
            double price = Double.parseDouble(priceStr);
            Date eventDate = Date.valueOf(dateStr);
            
            Event event = new Event();
            event.setEventId(eventId);
            event.setName(name);
            event.setLocation(location);
            event.setEventDate(eventDate);
            event.setCapacity(capacity);
            event.setPricePerSeat(price);
            
            boolean updated = eventDAO.updateEvent(event);
            System.out.println("Update result: " + updated);
            
            if (updated) {
                System.out.println("Event updated successfully!");
                request.setAttribute("message", "Event updated successfully!");
            } else {
                System.out.println("Failed to update event!");
                request.setAttribute("error", "Failed to update event!");
            }
            
            response.sendRedirect("manageEvents");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating event: " + e.getMessage());
            request.getRequestDispatcher("editEvent.jsp").forward(request, response);
        }
    }
}