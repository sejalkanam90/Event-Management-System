package com.eventmanagement.servlet;

import com.eventmanagement.dao.BookingDAO;
import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.model.Booking;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.Payment;
import com.eventmanagement.model.User;
import com.eventmanagement.service.PaymentService;
import com.eventmanagement.service.EmailService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/bookEvent")
public class BookEventServlet extends HttpServlet {
    
    private EventDAO eventDAO = new EventDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    private PaymentService paymentService = new PaymentService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("userDashboard");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== BookEventServlet doPost CALLED ===");
        
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            System.out.println("User not logged in - redirecting to login");
            response.sendRedirect("login.jsp");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        
        String eventId = request.getParameter("eventId");
        int seats = Integer.parseInt(request.getParameter("seats"));
        String paymentMethod = request.getParameter("paymentMethod");
        
        System.out.println("User: " + user.getUserId());
        System.out.println("Event: " + eventId);
        System.out.println("Seats: " + seats);
        System.out.println("Payment: " + paymentMethod);
        
        try {
            Event event = eventDAO.getEventById(eventId);
            
            if (event == null) {
                request.setAttribute("error", "Event not found!");
                request.getRequestDispatcher("userDashboard").forward(request, response);
                return;
            }
            
            if (event.getAvailableSeats() < seats) {
                request.setAttribute("error", "Only " + event.getAvailableSeats() + " seats available!");
                request.getRequestDispatcher("userDashboard").forward(request, response);
                return;
            }
            
            double totalAmount = seats * event.getPricePerSeat();
            
            // Process payment
            Payment payment = paymentService.processPayment(totalAmount, paymentMethod);
            
            if (payment != null && payment.isSuccess()) {
                // Update seats in database
                boolean seatsUpdated = eventDAO.updateEventSeats(eventId, seats, true);
                System.out.println("Seats updated: " + seatsUpdated);
                
                // Create booking object
                Booking booking = new Booking();
                booking.setUserId(user.getUserId());
                booking.setEventId(eventId);
                booking.setSeats(seats);
                booking.setTotalAmount(totalAmount);
                booking.setStatus("CONFIRMED");
                
                boolean bookingCreated = bookingDAO.createBooking(booking);
                System.out.println("Booking created: " + bookingCreated);
                
                if (bookingCreated) {
                    // Set event name in booking object
                    booking.setEventName(event.getName());
                    
                    System.out.println("✅ Booking created - ID: " + booking.getBookingId());
                    System.out.println("✅ Event Name set: " + booking.getEventName());
                    
                    // Send confirmation email
                    try {
                        EmailService.sendBookingConfirmationEmail(
                            user.getEmail(),
                            user.getName(),
                            event.getName(),
                            event.getLocation(),
                            event.getEventDate().toString(),
                            seats,
                            totalAmount,
                            booking.getBookingId()
                        );
                        System.out.println("✅ Email sent successfully");
                    } catch (Exception e) {
                        System.out.println("❌ Email failed: " + e.getMessage());
                    }
                    
                    // Set attributes for confirmation page
                    request.setAttribute("payment", payment);
                    request.setAttribute("booking", booking);
                    request.setAttribute("message", "Booking confirmed! ID: " + booking.getBookingId());
                    
                    // Forward to confirmation page
                    request.getRequestDispatcher("bookingConfirmation.jsp").forward(request, response);
                    
                } else {
                    // Rollback seats if booking fails
                    eventDAO.updateEventSeats(eventId, seats, false);
                    request.setAttribute("error", "Booking failed! Please try again.");
                    request.getRequestDispatcher("userDashboard").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Payment failed! Please try again.");
                request.setAttribute("eventId", eventId);
                request.setAttribute("seats", seats);
                request.getRequestDispatcher("payment.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("userDashboard").forward(request, response);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid seat count!");
            request.getRequestDispatcher("userDashboard").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("userDashboard").forward(request, response);
        }
    }
}