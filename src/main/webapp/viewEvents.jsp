<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventmanagement.model.Event, com.eventmanagement.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Events - EventHub</title>
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

        /* Stats Bar */
        .stats-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 35px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
            flex-wrap: wrap;
            gap: 15px;
        }

        .stats-info {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .stat-chip {
            background: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 500;
            color: #4a5568;
        }

        .stat-chip i {
            color: #667eea;
            margin-right: 5px;
        }

        .search-box {
            display: flex;
            gap: 10px;
        }

        .search-box input {
            padding: 8px 15px;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            font-size: 13px;
            width: 200px;
        }

        .search-box input:focus {
            outline: none;
            border-color: #667eea;
        }

        /* Events Grid */
        .events-section {
            padding: 35px;
        }

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

        .event-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            z-index: 1;
        }

        .badge-trending {
            background: linear-gradient(135deg, #ff4757 0%, #ff6b81 100%);
            color: white;
        }

        .badge-limited {
            background: #ffc107;
            color: #333;
        }

        .event-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 20px;
        }

        .event-header h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .event-header small {
            font-size: 12px;
            opacity: 0.9;
        }

        .event-body {
            padding: 20px;
        }

        .event-info {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 15px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-label {
            color: #718096;
            font-size: 13px;
            font-weight: 500;
        }

        .info-value {
            font-weight: 600;
            color: #2d3748;
            font-size: 13px;
        }

        .price-section {
            text-align: center;
            margin: 15px 0;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 12px;
        }

        .price {
            font-size: 28px;
            font-weight: 800;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .price-label {
            font-size: 12px;
            color: #718096;
        }

        .seats-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .seats-high {
            background: #d4edda;
            color: #155724;
        }

        .seats-low {
            background: #fff3cd;
            color: #856404;
        }

        .seats-none {
            background: #f8d7da;
            color: #721c24;
        }

        .event-footer {
            padding: 15px 20px 20px;
            border-top: 1px solid #e9ecef;
            background: #fafafa;
        }

        .booking-form {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .booking-form input {
            width: 80px;
            padding: 10px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }

        .booking-form input:focus {
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

        /* Alert Messages */
        .alert {
            margin: 20px 35px;
            padding: 15px 20px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.4s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-danger {
            background: #fed7d7;
            color: #c53030;
            border-left: 4px solid #c53030;
        }

        .alert-success {
            background: #c6f6d5;
            color: #276749;
            border-left: 4px solid #276749;
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
            .events-grid {
                grid-template-columns: 1fr;
            }
            .header {
                padding: 20px;
                text-align: center;
            }
            .events-section {
                padding: 20px;
            }
            .stats-bar {
                padding: 15px 20px;
                flex-direction: column;
            }
            .booking-form {
                flex-direction: column;
            }
            .booking-form input {
                width: 100%;
            }
            .alert {
                margin: 15px 20px;
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
                <h2><i class="fas fa-calendar-alt"></i> Available Events</h2>
                <p>Discover and book amazing events near you</p>
            </div>
            <div class="header-buttons">
                <a href="userDashboard" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
                <a href="searchEvents" class="btn btn-white">
                    <i class="fas fa-search"></i> Search Events
                </a>
            </div>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("message") %>
            </div>
        <% } %>

        <div class="stats-bar">
            <div class="stats-info">
                <div class="stat-chip">
                    <i class="fas fa-calendar-alt"></i> Total Events: <%= events != null ? events.size() : 0 %>
                </div>
                <div class="stat-chip">
                    <i class="fas fa-fire"></i> Trending Now
                </div>
            </div>
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search events..." onkeyup="filterEvents()">
                <i class="fas fa-search" style="position: relative; right: 35px; top: 12px; color: #a0aec0;"></i>
            </div>
        </div>

        <div class="events-section">
            <div class="events-grid" id="eventsGrid">
                <%
                    if (events != null && !events.isEmpty()) {
                        for (Event e : events) {
                            int available = e.getAvailableSeats();
                            String seatClass = available > 10 ? "seats-high" : (available > 0 ? "seats-low" : "seats-none");
                            String seatText = available > 10 ? "Available" : (available > 0 ? "Limited" : "Sold Out");
                %>
                    <div class="event-card" data-event-name="<%= e.getName().toLowerCase() %>" data-event-location="<%= e.getLocation().toLowerCase() %>">
                        <% if(available > 50) { %>
                            <div class="event-badge badge-trending">
                                <i class="fas fa-fire"></i> Trending
                            </div>
                        <% } else if(available > 0 && available <= 10) { %>
                            <div class="event-badge badge-limited">
                                <i class="fas fa-exclamation-triangle"></i> Only <%= available %> left!
                            </div>
                        <% } %>
                        
                        <div class="event-header">
                            <h3><i class="fas fa-calendar-check"></i> <%= e.getName() %></h3>
                            <small><i class="fas fa-map-marker-alt"></i> <%= e.getLocation() %></small>
                        </div>
                        
                        <div class="event-body">
                            <div class="event-info">
                                <div class="info-row">
                                    <span class="info-label"><i class="fas fa-calendar"></i> Date</span>
                                    <span class="info-value"><%= e.getEventDate() %></span>
                                </div>
                                <div class="info-row">
                                    <span class="info-label"><i class="fas fa-chair"></i> Seats Available</span>
                                    <span class="info-value">
                                        <span class="seats-status <%= seatClass %>">
                                            <%= available %> / <%= e.getCapacity() %> (<%= seatText %>)
                                        </span>
                                    </span>
                                </div>
                            </div>
                            
                            <div class="price-section">
                                <span class="price">₹<%= e.getPricePerSeat() %></span>
                                <span class="price-label"> per seat</span>
                            </div>
                        </div>
                        
                        <div class="event-footer">
                            <% if (available > 0) { %>
                                <form action="payment.jsp" method="get" class="booking-form">
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
                <%
                        }
                    } else {
                %>
                    <div class="no-events">
                        <i class="fas fa-calendar-times"></i>
                        <p>No events available at the moment.</p>
                        <p style="font-size: 13px; margin-top: 10px;">Check back later for amazing events!</p>
                        <a href="userDashboard" class="btn btn-white" style="margin-top: 20px; display: inline-block;">
                            <i class="fas fa-arrow-left"></i> Back to Dashboard
                        </a>
                    </div>
                <%
                    }
                %>
            </div>
        </div>

        <div class="footer">
            <p>&copy; 2026 EventHub - Your Event Management Partner | Book your dream events today!</p>
        </div>
    </div>

    <script>
        function filterEvents() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const eventsGrid = document.getElementById('eventsGrid');
            const eventCards = eventsGrid.getElementsByClassName('event-card');
            
            let visibleCount = 0;
            
            for (let i = 0; i < eventCards.length; i++) {
                const card = eventCards[i];
                const eventName = card.getAttribute('data-event-name') || '';
                const eventLocation = card.getAttribute('data-event-location') || '';
                
                if (eventName.includes(filter) || eventLocation.includes(filter)) {
                    card.style.display = '';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            }
            
            // Show/hide no results message
            let noResultsMsg = document.getElementById('noResultsMsg');
            if (visibleCount === 0 && eventCards.length > 0) {
                if (!noResultsMsg) {
                    noResultsMsg = document.createElement('div');
                    noResultsMsg.id = 'noResultsMsg';
                    noResultsMsg.className = 'no-events';
                    noResultsMsg.innerHTML = `
                        <i class="fas fa-search"></i>
                        <p>No events found matching "<strong>${filter}</strong>"</p>
                        <p style="font-size: 13px; margin-top: 10px;">Try searching with different keywords</p>
                    `;
                    eventsGrid.appendChild(noResultsMsg);
                } else {
                    noResultsMsg.style.display = '';
                    noResultsMsg.innerHTML = `
                        <i class="fas fa-search"></i>
                        <p>No events found matching "<strong>${filter}</strong>"</p>
                        <p style="font-size: 13px; margin-top: 10px;">Try searching with different keywords</p>
                    `;
                }
            } else if (noResultsMsg) {
                noResultsMsg.style.display = 'none';
            }
        }
    </script>
</body>
</html>