<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventmanagement.model.Event, com.eventmanagement.model.User, com.eventmanagement.dao.BookingDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
    
   
    BookingDAO bookingDAO = new BookingDAO();
    int bookingCount = 0;
    try {
        List<com.eventmanagement.model.Booking> bookings = bookingDAO.getBookingsByUserId(user.getUserId());
        if(bookings != null) {
            for(com.eventmanagement.model.Booking b : bookings) {
                if("CONFIRMED".equals(b.getStatus())) {
                    bookingCount++;
                }
            }
        }
    } catch(Exception e) {
        bookingCount = 0;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - EventHub</title>
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
            max-width: 1400px;
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

        .btn-danger {
            background: #ff4757;
            color: white;
        }

        .btn-danger:hover {
            background: #e84118;
            transform: translateY(-2px);
        }

        /* Stats Section */
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px 35px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 20px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transform: scaleX(0);
            transition: transform 0.3s;
        }

        .stat-card:hover::before {
            transform: scaleX(1);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .stat-number {
            font-size: 42px;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 14px;
            color: #718096;
            font-weight: 500;
        }

        /* Quick Actions */
        .quick-actions {
            padding: 25px 35px;
            border-bottom: 1px solid #e9ecef;
            background: white;
        }

        .quick-actions h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: #1a202c;
            font-weight: 600;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .action-btn {
            padding: 10px 20px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 12px;
            text-decoration: none;
            color: #4a5568;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .action-btn:hover {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: translateY(-2px);
        }

        /* Events Section */
        .events-section {
            padding: 30px 35px;
            background: white;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .events-section h3 {
            font-size: 22px;
            font-weight: 700;
            color: #1a202c;
        }

        .events-section h3 i {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-right: 8px;
        }

        /* Events Grid */
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
        }

        .event-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 20px;
            overflow: hidden;
            transition: all 0.3s;
            position: relative;
        }

        .event-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 35px rgba(0,0,0,0.1);
            border-color: #667eea;
        }

        /* Event Image */
        .event-image {
            width: 100%;
            height: 180px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .event-card:hover .event-image {
            transform: scale(1.05);
        }

        .event-image-container {
            position: relative;
            overflow: hidden;
            height: 180px;
        }

        .event-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            z-index: 2;
        }

        .event-title {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 18px;
            font-size: 18px;
            font-weight: 600;
        }

        .event-details {
            padding: 18px;
        }

        .event-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .event-row:last-child {
            border-bottom: none;
        }

        .event-label {
            color: #718096;
            font-size: 13px;
            font-weight: 500;
        }

        .event-value {
            font-weight: 600;
            color: #2d3748;
            font-size: 13px;
        }

        .event-price {
            font-size: 24px;
            font-weight: 800;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 15px 0 10px;
            text-align: center;
        }

        .event-footer {
            padding: 15px 20px 20px;
            border-top: 1px solid #e9ecef;
            background: #fafafa;
        }

        .event-footer form {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .event-footer input {
            width: 80px;
            padding: 10px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .event-footer input:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn-book {
            flex: 1;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 10px;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-book:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40,167,69,0.3);
        }

        .sold-out {
            background: #dc3545;
            color: white;
            padding: 10px;
            text-align: center;
            border-radius: 12px;
            font-weight: 600;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .no-events {
            text-align: center;
            padding: 60px;
            color: #718096;
        }

        .no-events i {
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
            .stats {
                grid-template-columns: 1fr;
                padding: 20px;
            }
            .events-grid {
                grid-template-columns: 1fr;
            }
            .header {
                padding: 20px;
                text-align: center;
            }
            .quick-actions, .events-section {
                padding: 20px;
            }
            .event-footer form {
                flex-direction: column;
            }
            .event-footer input {
                width: 100%;
            }
            .action-buttons {
                justify-content: center;
            }
            .event-image {
                height: 150px;
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
                <h2><i class="fas fa-user-circle"></i> User Dashboard</h2>
                <p>Welcome back, <strong><%= user.getName() %></strong>! Ready to discover amazing events?</p>
            </div>
            <div class="header-buttons">
                <a href="profile.jsp" class="btn btn-outline">
                    <i class="fas fa-user"></i> My Profile
                </a>
                <a href="viewBookings" class="btn btn-white">
                    <i class="fas fa-ticket-alt"></i> My Bookings
                </a>
                <a href="logout" class="btn btn-danger">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-number"><%= events != null ? events.size() : 0 %></div>
                <div class="stat-label">Total Events</div>
            </div>
            <div class="stat-card">
                <div class="stat-number"><%= bookingCount %></div>
                <div class="stat-label">My Bookings</div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3><i class="fas fa-bolt"></i> Quick Actions</h3>
            <div class="action-buttons">
                <a href="viewEvents" class="action-btn">
                    <i class="fas fa-calendar-alt"></i> Browse All Events
                </a>
                <a href="searchEvents" class="action-btn">
                    <i class="fas fa-search"></i> Search Events
                </a>
                <a href="viewBookings" class="action-btn">
                    <i class="fas fa-history"></i> Booking History
                </a>
            </div>
        </div>
        
        <div class="events-section">
            <div class="section-header">
                <h3><i class="fas fa-calendar-alt"></i> Available Events</h3>
                <span style="color: #718096; font-size: 13px;">
                    <i class="fas fa-fire"></i> Trending events this week
                </span>
            </div>
            <div class="events-grid">
                <% if(events != null && !events.isEmpty()) {
                    for(Event e : events) { 
                        int available = e.getAvailableSeats();
                        
                        // Map event name to image
                        String eventImage = "";
                        if(e.getName().contains("Music")) {
                            eventImage = "images/music_night.jpg";
                        } else if(e.getName().contains("Art")) {
                            eventImage = "images/art_exhibition.jpg";
                        } else if(e.getName().contains("Tech")) {
                            eventImage = "images/tech_conference.jpg";
                        } else if(e.getName().contains("Wedding")) {
                            eventImage = "images/wedding_ceremony.jpg";
                        } else if(e.getName().contains("Birthday")) {
                            eventImage = "images/birthday_party.jpg";
                        } else if(e.getName().contains("Food")) {
                            eventImage = "images/food_festival.jpg";
                        } else if(e.getName().contains("Dance")) {
                            eventImage = "images/dance_competition.jpg";
                        } else {
                            eventImage = "images/music_night.jpg";
                        }
                %>
                    <div class="event-card">
                        <div class="event-image-container">
                            <img src="${pageContext.request.contextPath}/<%= eventImage %>" 
                                 alt="<%= e.getName() %>" 
                                 class="event-image">
                            <% if(available > 50) { %>
                                <div class="event-badge">🔥 Trending</div>
                            <% } else if(available < 10 && available > 0) { %>
                                <div class="event-badge" style="background: #ffc107; color: #333;">⚠️ Limited Seats</div>
                            <% } %>
                        </div>
                        <div class="event-title">
                            <i class="fas fa-calendar-check"></i> <%= e.getName() %>
                        </div>
                        <div class="event-details">
                            <div class="event-row">
                                <span class="event-label"><i class="fas fa-map-marker-alt"></i> Location</span>
                                <span class="event-value"><%= e.getLocation() %></span>
                            </div>
                            <div class="event-row">
                                <span class="event-label"><i class="fas fa-calendar"></i> Date</span>
                                <span class="event-value"><%= e.getEventDate() %></span>
                            </div>
                            <div class="event-row">
                                <span class="event-label"><i class="fas fa-chair"></i> Available Seats</span>
                                <span class="event-value">
                                    <%= available %> / <%= e.getCapacity() %>
                                    <% if(available > 0 && available <= 10) { %>
                                        <span style="color: #ffc107; font-size: 11px;"> (Hurry up!)</span>
                                    <% } %>
                                </span>
                            </div>
                            <div class="event-price">₹<%= e.getPricePerSeat() %> per seat</div>
                        </div>
                        <div class="event-footer">
                            <% if(available > 0) { %>
                                <form action="payment.jsp" method="get">
                                    <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                                    <input type="number" name="seats" min="1" max="<%= available %>" value="1" required>
                                    <button type="submit" class="btn-book">
                                        <i class="fas fa-ticket-alt"></i> Book Now
                                    </button>
                                </form>
                            <% } else { %>
                                <div class="sold-out">
                                    <i class="fas fa-times-circle"></i> Sold Out
                                </div>
                            <% } %>
                        </div>
                    </div>
                <% } } else { %>
                    <div class="no-events">
                        <i class="fas fa-calendar-times"></i>
                        <p>No events available at the moment.</p>
                        <p style="font-size: 13px; margin-top: 10px;">Check back later for amazing events!</p>
                    </div>
                <% } %>
            </div>
        </div>
        
        <div class="footer">
            <p>&copy; 2026 EventHub - Your Event Management Partner | Making events memorable</p>
        </div>
    </div>
</body>
</html>