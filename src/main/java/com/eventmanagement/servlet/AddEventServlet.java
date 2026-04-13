package com.eventmanagement.servlet;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/addEvent")
public class AddEventServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.getRequestDispatcher("addEvent.jsp").forward(request, response);
    }
    
    // ✅ ADD THIS METHOD for POST requests ✅
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== AddEventServlet doPost CALLED ===");
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String dateStr = request.getParameter("date");
        int capacity = Integer.parseInt(request.getParameter("capacity"));
        double price = Double.parseDouble(request.getParameter("price"));
        
        try {
            Event event = new Event();
            event.setName(name);
            event.setLocation(location);
            event.setEventDate(Date.valueOf(dateStr));
            event.setCapacity(capacity);
            event.setPricePerSeat(price);
            event.setBookedSeats(0);
            
            boolean added = eventDAO.addEvent(event);
            
            if (added) {
                System.out.println("✅ Event added: " + event.getEventId());
                response.sendRedirect("adminDashboard");
            } else {
                request.setAttribute("error", "Failed to add event!");
                request.getRequestDispatcher("addEvent.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("addEvent.jsp").forward(request, response);
        }
    }
}