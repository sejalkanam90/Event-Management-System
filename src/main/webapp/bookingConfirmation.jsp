<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User, com.eventmanagement.model.Booking, com.eventmanagement.model.Payment" %>
<%@ page import="com.eventmanagement.dao.EventDAO, com.eventmanagement.model.Event" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Booking booking = (Booking) request.getAttribute("booking");
    Payment payment = (Payment) request.getAttribute("payment");
    
    // Fetch event details if booking exists
    String eventName = "";
    String eventLocation = "";
    java.sql.Date eventDate = null;
    String formattedDate = "";
    
    if(booking != null && booking.getEventId() != null) {
        try {
            EventDAO eventDAO = new EventDAO();
            Event event = eventDAO.getEventById(booking.getEventId());
            if(event != null) {
                eventName = event.getName();
                eventLocation = event.getLocation();
                eventDate = event.getEventDate();
                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");
                if(eventDate != null) {
                    formattedDate = sdf.format(eventDate);
                }
            } else {
                eventName = "Event Not Found";
                eventLocation = "N/A";
            }
        } catch(Exception e) {
            eventName = "Event Details Unavailable";
            eventLocation = "N/A";
        }
    }
    
    // Generate QR Code data - Simple format for better compatibility
    String qrText = "";
    if(booking != null) {
        qrText = "Booking ID: " + booking.getBookingId() + 
                 " | Event: " + eventName + 
                 " | Venue: " + eventLocation + 
                 " | Date: " + formattedDate + 
                 " | Seats: " + booking.getSeats() + 
                 " | Amount: ₹" + String.format("%.0f", booking.getTotalAmount());
    }
    String encodedQR = URLEncoder.encode(qrText, "UTF-8");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Confirmed - EventHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
        }

        .ticket-card {
            max-width: 580px;
            width: 100%;
            background: white;
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .ticket-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            padding: 35px;
            text-align: center;
            color: white;
        }

        .ticket-header i {
            font-size: 64px;
            margin-bottom: 15px;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }

        .ticket-header h2 {
            font-size: 28px;
            font-weight: 800;
        }

        .ticket-header p {
            font-size: 13px;
            opacity: 0.9;
            margin-top: 5px;
        }

        .ticket-body {
            padding: 35px;
        }

        .ticket {
            background: white;
            border: 2px dashed #e2e8f0;
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 25px;
        }

        .ticket-title {
            text-align: center;
            font-size: 22px;
            font-weight: 800;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .ticket-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .ticket-row:last-child {
            border-bottom: none;
        }

        .ticket-label {
            color: #718096;
            font-weight: 500;
            font-size: 13px;
        }

        .ticket-value {
            color: #1a202c;
            font-weight: 600;
            font-size: 14px;
        }

        .ticket-footer {
            text-align: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px dashed #e2e8f0;
        }

        .qr-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            margin-bottom: 15px;
        }

        .qr-code-img {
            width: 150px;
            height: 150px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 8px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
        }

        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 12px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: #333;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,193,7,0.4);
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }

        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40,167,69,0.3);
        }

        @media print {
            body {
                background: white;
                padding: 0;
                margin: 0;
            }
            .no-print {
                display: none !important;
            }
            .ticket-card {
                box-shadow: none;
                border: 1px solid #ddd;
                margin: 0;
                padding: 0;
            }
            .action-buttons {
                display: none;
            }
            .qr-code-img {
                border: 1px solid #ddd;
            }
        }

        @media (max-width: 480px) {
            .ticket-card {
                border-radius: 24px;
            }
            .ticket-header {
                padding: 25px;
            }
            .ticket-body {
                padding: 25px;
            }
            .action-buttons {
                flex-direction: column;
            }
            .ticket-row {
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
    <div class="ticket-card">
        <div class="ticket-header">
            <i class="fas fa-check-circle"></i>
            <h2>Booking Confirmed!</h2>
            <p>Your ticket has been booked successfully</p>
        </div>

        <div class="ticket-body">
            <div class="ticket" id="ticketContent">
                <div class="ticket-title">
                    <i class="fas fa-ticket-alt"></i> EVENT TICKET
                </div>
                
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-qrcode"></i> Booking ID</span>
                    <span class="ticket-value"><%= booking != null ? booking.getBookingId() : "N/A" %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-calendar-alt"></i> Event Name</span>
                    <span class="ticket-value"><%= eventName %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-map-marker-alt"></i> Venue</span>
                    <span class="ticket-value"><%= eventLocation %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-calendar"></i> Date & Time</span>
                    <span class="ticket-value"><%= formattedDate %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-chair"></i> Number of Seats</span>
                    <span class="ticket-value"><%= booking != null ? booking.getSeats() : "0" %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-rupee-sign"></i> Total Amount</span>
                    <span class="ticket-value">₹<%= booking != null ? String.format("%,.0f", booking.getTotalAmount()) : "0" %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-credit-card"></i> Payment ID</span>
                    <span class="ticket-value"><%= payment != null ? payment.getPaymentId() : "N/A" %></span>
                </div>
                <div class="ticket-row">
                    <span class="ticket-label"><i class="fas fa-check-circle"></i> Status</span>
                    <span class="ticket-value" style="color: #28a745; font-weight: 700;">CONFIRMED</span>
                </div>
                
                <div class="ticket-footer">
                    <div class="qr-container">
                        <img src="https://quickchart.io/qr?text=<%= encodedQR %>&size=150&margin=2" 
                             alt="Booking QR Code" 
                             class="qr-code-img"
                             onerror="this.src='https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=<%= encodedQR %>'">
                        <small style="color: #666;">
                            <i class="fas fa-qrcode"></i> Scan QR code at venue
                        </small>
                    </div>
                    <i class="fas fa-envelope"></i> <%= user.getEmail() %><br>
                    <i class="fas fa-phone"></i> <%= user.getMobile() != null ? user.getMobile() : "Not provided" %><br>
                    <small>© 2026 EventHub - Event Management System</small>
                </div>
            </div>
            
            <div class="action-buttons no-print">
                <button onclick="window.print()" class="btn btn-warning">
                    <i class="fas fa-print"></i> Print / Save PDF
                </button>
                <a href="viewBookings" class="btn btn-primary">
                    <i class="fas fa-ticket-alt"></i> My Bookings
                </a>
                <a href="userDashboard" class="btn btn-success">
                    <i class="fas fa-calendar-alt"></i> Book More
                </a>
            </div>
        </div>
    </div>
</body>
</html>