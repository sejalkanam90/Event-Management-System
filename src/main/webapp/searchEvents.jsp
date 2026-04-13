<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.eventmanagement.model.Event, com.eventmanagement.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Event> events = (List<Event>) request.getAttribute("events");
    String keyword = request.getParameter("keyword");
    if(keyword == null) keyword = "";
    
    // Calculate search stats
    int resultsCount = events != null ? events.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Events - EventHub</title>
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

        /* Search Section */
        .search-section {
            padding: 35px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-bottom: 1px solid #e9ecef;
        }

        .search-box {
            display: flex;
            gap: 15px;
            max-width: 700px;
            margin: 0 auto;
            position: relative;
        }

        .search-input {
            flex: 1;
            padding: 16px 20px;
            border: 2px solid #e2e8f0;
            border-radius: 60px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s;
            background: white;
        }

        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }

        .search-btn {
            padding: 16px 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 60px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .search-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }

        /* Popular Tags */
        .popular-tags {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .tag {
            background: white;
            padding: 6px 16px;
            border-radius: 30px;
            font-size: 12px;
            color: #667eea;
            text-decoration: none;
            transition: all 0.3s;
            border: 1px solid #e2e8f0;
        }

        .tag:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }

        /* Results Section */
        .results-section {
            padding: 35px;
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .results-header h3 {
            font-size: 20px;
            font-weight: 700;
            color: #1a202c;
        }

        .results-header h3 i {
            color: #667eea;
            margin-right: 8px;
        }

        .results-count {
            background: #f8f9fa;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            color: #667eea;
            font-weight: 500;
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
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.95);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
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

        .event-title {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 18px 20px;
            font-size: 18px;
            font-weight: 600;
        }

        .event-details {
            padding: 20px;
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

        .no-results {
            text-align: center;
            padding: 60px;
            color: #718096;
        }

        .no-results i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .no-results p {
            margin-bottom: 10px;
        }

        .suggestions {
            margin-top: 20px;
            font-size: 13px;
        }

        .suggestions a {
            color: #667eea;
            text-decoration: none;
            margin: 0 5px;
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
            .search-section {
                padding: 25px;
            }
            .search-box {
                flex-direction: column;
            }
            .results-section {
                padding: 25px;
            }
            .events-grid {
                grid-template-columns: 1fr;
            }
            .event-footer form {
                flex-direction: column;
            }
            .event-footer input {
                width: 100%;
            }
            .popular-tags {
                display: none;
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
                <h2><i class="fas fa-search"></i> Search Events</h2>
                <p>Discover events by name, location, or category</p>
            </div>
            <div class="header-buttons">
                <a href="userDashboard" class="btn btn-outline">
                    <i class="fas fa-arrow-left"></i> Dashboard
                </a>
                <a href="viewBookings" class="btn btn-white">
                    <i class="fas fa-ticket-alt"></i> My Bookings
                </a>
            </div>
        </div>
        
        <div class="search-section">
            <form action="searchEvents" method="get" class="search-box">
                <input type="text" name="keyword" class="search-input" 
                       placeholder="🔍 Search by event name, location, or category..." 
                       value="<%= keyword %>"
                       autofocus>
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i> Search
                </button>
            </form>
            
            <% if(keyword == null || keyword.isEmpty()) { %>
                <div class="popular-tags">
                    <span style="color: #718096; font-size: 12px;">Popular:</span>
                    <a href="searchEvents?keyword=music" class="tag">🎵 Music</a>
                    <a href="searchEvents?keyword=tech" class="tag">💻 Tech</a>
                    <a href="searchEvents?keyword=food" class="tag">🍕 Food</a>
                    <a href="searchEvents?keyword=art" class="tag">🎨 Art</a>
                    <a href="searchEvents?keyword=wedding" class="tag">💒 Wedding</a>
                </div>
            <% } %>
        </div>
        
        <div class="results-section">
            <div class="results-header">
                <h3>
                    <i class="fas fa-calendar-alt"></i> 
                    <%= (keyword != null && !keyword.isEmpty()) ? "Search Results" : "All Events" %>
                </h3>
                <% if(events != null && !events.isEmpty()) { %>
                    <span class="results-count">
                        <i class="fas fa-list"></i> <%= resultsCount %> event(s) found
                    </span>
                <% } %>
            </div>
            
            <% if(keyword != null && !keyword.isEmpty() && (events == null || events.isEmpty())) { %>
                <div class="no-results">
                    <i class="fas fa-search"></i>
                    <p>No events found for "<strong><%= keyword %></strong>"</p>
                    <div class="suggestions">
                        <p>Try searching with different keywords:</p>
                        <a href="searchEvents?keyword=music">Music</a> •
                        <a href="searchEvents?keyword=conference">Conference</a> •
                        <a href="searchEvents?keyword=festival">Festival</a> •
                        <a href="searchEvents?keyword=workshop">Workshop</a>
                    </div>
                </div>
            <% } else if(events != null && !events.isEmpty()) { %>
                <div class="events-grid">
                    <% for(Event e : events) { 
                        int available = e.getAvailableSeats();
                    %>
                        <div class="event-card">
                            <% if(available > 50) { %>
                                <div class="event-badge badge-trending">
                                    <i class="fas fa-fire"></i> Trending
                                </div>
                            <% } else if(available > 0 && available <= 10) { %>
                                <div class="event-badge badge-limited">
                                    <i class="fas fa-exclamation-triangle"></i> Only <%= available %> left!
                                </div>
                            <% } %>
                            
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
                                            <span style="color: #ffc107; font-size: 11px;"> (Hurry!)</span>
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
                    <% } %>
                </div>
            <% } else if(keyword == null || keyword.isEmpty()) { %>
                <div class="no-results">
                    <i class="fas fa-search"></i>
                    <p>Enter a keyword to search events</p>
                    <p style="font-size: 13px;">Search by event name, location, or category</p>
                </div>
            <% } %>
        </div>
        
        <div class="footer">
            <p>&copy; 2026 EventHub - Your Event Management Partner | Find your perfect event</p>
        </div>
    </div>

    <script>
        // Auto-focus on search input
        document.querySelector('.search-input').focus();
        
        // Add keyboard shortcut (Ctrl+K to focus search)
        document.addEventListener('keydown', function(e) {
            if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
                e.preventDefault();
                document.querySelector('.search-input').focus();
            }
        });
    </script>
</body>
</html>