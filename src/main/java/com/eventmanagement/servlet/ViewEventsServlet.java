package com.eventmanagement.servlet;

import com.eventmanagement.model.Event;
import com.eventmanagement.service.EventService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewEvents")
public class ViewEventsServlet extends HttpServlet {
    
    private EventService eventService = new EventService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Event> events = eventService.getAllEvents();
        request.setAttribute("events", events);
        request.getRequestDispatcher("viewEvents.jsp").forward(request, response);
    }
}