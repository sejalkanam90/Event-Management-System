<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventmanagement.model.Booking, com.eventmanagement.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    
   
    int totalBookings = 0;
    int totalSeats = 0;
    double totalSpent = 0;
    int activeBookings = 0;
    int cancelledBookings = 0;
    
    if(bookings != null && !bookings.isEmpty()) {
        totalBookings = bookings.size();
        for(Booking b : bookings) {
            totalSeats += b.getSeats();
            if("CONFIRMED".equals(b.getStatus())) {
                activeBookings++;
                totalSpent += b.getTotalAmount(); 
            } else if("CANCELLED".equals(b.getStatus())) {
                cancelledBookings++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - EventHub</title>
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
            padding: 20px;
            position: relative;
        }

        /* Animated Background */
        .animated-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
        }

        .animated-bg::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 2px, transparent 2px);
            background-size: 50px 50px;
            animation: moveDots 20s linear infinite;
        }

        @keyframes moveDots {
            0% { transform: translate(0, 0); }
            100% { transform: translate(50px, 50px); }
        }

        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 0;
            overflow: hidden;
        }

        .shape {
            position: absolute;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
            animation: float 20s infinite ease-in-out;
        }

        .shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; animation-duration: 25s; }
        .shape-2 { width: 200px; height: 200px; bottom: -50px; right: -50px; animation-duration: 20s; animation-delay: 2s; }
        .shape-3 { width: 150px; height: 150px; top: 50%; left: 80%; animation-duration: 18s; animation-delay: 4s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }

        /* Main Container */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            overflow: hidden;
            position: relative;
            z-index: 1;
            animation: slideUp 0.5s ease;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 30px 35px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 30px 30px;
            animation: shimmer 20s linear infinite;
        }

        @keyframes shimmer {
            0% { transform: translate(0, 0); }
            100% { transform: translate(30px, 30px); }
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header h2 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .header p {
            opacity: 0.9;
            font-size: 14px;
        }

        .header-buttons {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            position: relative;
            z-index: 1;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 12px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .btn-white {
            background: white;
            color: #667eea;
        }

        .btn-white:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid white;
            color: white;
        }

        .btn-outline:hover {
            background: rgba(255,255,255,0.1);
            transform: translateY(-2px);
        }

        /* Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 25px 35px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 16px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            color: white;
            font-size: 20px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 800;
            color: #1a202c;
        }

        .stat-label {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }

        /* Table Container */
        .table-container {
            padding: 30px 35px;
            overflow-x: auto;
        }

        .bookings-table {
            width: 100%;
            border-collapse: collapse;
        }

        .bookings-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 13px;
            border-bottom: 2px solid #e9ecef;
        }

        .bookings-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            color: #2d3748;
            font-size: 14px;
        }

        .bookings-table tr {
            transition: all 0.3s;
        }

        .bookings-table tr:hover {
            background: #f8f9fa;
        }

        .booking-id {
            font-weight: 700;
            color: #667eea;
            font-size: 14px;
        }

        .event-name {
            font-weight: 600;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }

        .status-confirmed {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .amount {
            font-weight: 700;
            color: #28a745;
        }

        .btn-cancel {
            background: #dc3545;
            color: white;
            border: none;
            padding: 6px 14px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-cancel:hover {
            background: #c82333;
            transform: translateY(-1px);
        }

        .no-bookings {
            text-align: center;
            padding: 60px;
            color: #718096;
        }

        .no-bookings i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            color: #718096;
            font-size: 12px;
            border-top: 1px solid #e9ecef;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                padding: 20px;
                text-align: center;
            }
            .stats-container {
                padding: 20px;
                grid-template-columns: repeat(2, 1fr);
            }
            .table-container {
                padding: 20px;
            }
            .bookings-table th, 
            .bookings-table td {
                padding: 10px;
                font-size: 12px;
            }
            .btn-cancel {
                padding: 4px 10px;
                font-size: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="animated-bg"></div>
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
    </div>

    <div class="container">
        <div class="header">
            <div class="header-content">
                <h2><i class="fas fa-ticket-alt"></i> My Bookings</h2>
                <p>View and manage your event bookings</p>
            </div>
            <div class="header-buttons">
                <a href="userDashboard" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Dashboard
                </a>
                <a href="viewEvents" class="btn btn-white">
                    <i class="fas fa-calendar-alt"></i> Browse Events
                </a>
            </div>
        </div>

        <!-- Statistics Cards - फक्त confirmed bookings -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="stat-value"><%= totalBookings %></div>
                <div class="stat-label">Total Bookings</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-chair"></i>
                </div>
                <div class="stat-value"><%= totalSeats %></div>
                <div class="stat-label">Total Seats</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-rupee-sign"></i>
                </div>
                <div class="stat-value">₹<%= String.format("%,.0f", totalSpent) %></div>
                <div class="stat-label">Total Spent</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-value"><%= activeBookings %></div>
                <div class="stat-label">Active Bookings</div>
            </div>
        </div>

        <div class="table-container">
            <% if(bookings != null && !bookings.isEmpty()) { %>
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Event Name</th>
                            <th>Seats</th>
                            <th>Amount</th>
                            <th>Booking Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </thead>
                    <tbody>
                        <% for(Booking b : bookings) { %>
                            <tr>
                                <td class="booking-id">#<%= b.getBookingId() %></td>
                                <td class="event-name">
                                    <i class="fas fa-calendar-alt" style="color: #667eea; margin-right: 8px;"></i>
                                    <%= b.getEventName() != null ? b.getEventName() : "Event" %>
                                </td>
                                <td>
                                    <i class="fas fa-chair" style="color: #718096; margin-right: 5px;"></i>
                                    <%= b.getSeats() %>
                                </td>
                                <td class="amount">₹<%= String.format("%,.0f", b.getTotalAmount()) %></td>
                                <td>
                                    <i class="far fa-calendar-alt" style="color: #718096; margin-right: 5px;"></i>
                                    <%= b.getBookingDate() != null ? b.getBookingDate() : "N/A" %>
                                </td>
                                <td>
                                    <span class="status-badge status-<%= b.getStatus().toLowerCase() %>">
                                        <i class="fas <%= "CONFIRMED".equals(b.getStatus()) ? "fa-check-circle" : "fa-times-circle" %>"></i>
                                        <%= b.getStatus() %>
                                    </span>
                                </td>
                                <td>
                                    <% if("CONFIRMED".equals(b.getStatus())) { %>
                                        <form action="cancelBooking" method="post" style="margin:0;">
                                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                            <button type="submit" class="btn-cancel" onclick="return confirm('Are you sure you want to cancel this booking?\n\nBooking ID: <%= b.getBookingId() %>\nEvent: <%= b.getEventName() %>\nSeats: <%= b.getSeats() %>\nAmount: ₹<%= b.getTotalAmount() %>\n\nThis action cannot be undone!')">
                                                <i class="fas fa-times"></i> Cancel
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span style="color: #a0aec0; font-size: 12px;">
                                            <i class="fas fa-ban"></i> No action
                                        </span>
                                    <% } %>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <div class="no-bookings">
                    <i class="fas fa-calendar-times"></i>
                    <p>No bookings found.</p>
                    <p style="font-size: 13px;">You haven't booked any events yet.</p>
                    <a href="viewEvents" class="btn btn-white" style="display: inline-flex; margin-top: 20px;">
                        <i class="fas fa-calendar-alt"></i> Browse Events
                    </a>
                </div>
            <% } %>
        </div>

        <div class="footer">
            <p>&copy; 2026 EventHub - Your Event Management Partner | Manage your bookings easily</p>
        </div>
    </div>
</body>
</html>