<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User, com.eventmanagement.dao.EventDAO, com.eventmanagement.dao.UserDAO, com.eventmanagement.dao.BookingDAO, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    EventDAO eventDAO = new EventDAO();
    UserDAO userDAO = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();
    
    int totalEvents = eventDAO.getAllEvents().size();
    int totalUsers = userDAO.getAllUsers().size();
    List<com.eventmanagement.model.Booking> bookings = bookingDAO.getAllBookings();
    int totalBookings = bookings != null ? bookings.size() : 0;
    double totalRevenue = 0;
    int confirmedBookings = 0;
    int cancelledBookings = 0;
    
    if (bookings != null) {
        for (com.eventmanagement.model.Booking b : bookings) {
            totalRevenue += b.getTotalAmount();
            if ("CONFIRMED".equals(b.getStatus())) confirmedBookings++;
            else if ("CANCELLED".equals(b.getStatus())) cancelledBookings++;
        }
    }
    
    double occupancyRate = 0;
    int totalCapacity = 0;
    int totalBookedSeats = 0;
    List<com.eventmanagement.model.Event> events = eventDAO.getAllEvents();
    if (events != null) {
        for (com.eventmanagement.model.Event e : events) {
            totalCapacity += e.getCapacity();
            totalBookedSeats += e.getBookedSeats();
        }
    }
    occupancyRate = totalCapacity > 0 ? (totalBookedSeats * 100.0 / totalCapacity) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EventHub</title>
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
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
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
            background: radial-gradient(circle, rgba(255,255,255,0.05) 2px, transparent 2px);
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
            background: rgba(255,255,255,0.03);
            border-radius: 50%;
            animation: float 20s infinite ease-in-out;
        }

        .shape-1 { width: 350px; height: 350px; top: -120px; left: -120px; animation-duration: 28s; }
        .shape-2 { width: 250px; height: 250px; bottom: -80px; right: -80px; animation-duration: 22s; animation-delay: 2s; }
        .shape-3 { width: 180px; height: 180px; top: 60%; left: 85%; animation-duration: 20s; animation-delay: 4s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-35px) rotate(8deg); }
        }

        /* Admin Container */
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
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

        /* Admin Header */
        .admin-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            border-radius: 28px;
            padding: 30px 35px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            position: relative;
            overflow: hidden;
        }

        .admin-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.08) 1px, transparent 1px);
            background-size: 30px 30px;
            animation: shimmer 20s linear infinite;
        }

        @keyframes shimmer {
            0% { transform: translate(0, 0); }
            100% { transform: translate(30px, 30px); }
        }

        .admin-title {
            position: relative;
            z-index: 1;
        }

        .admin-title h1 {
            font-size: 30px;
            font-weight: 800;
            color: white;
            margin-bottom: 5px;
        }

        .admin-title p {
            color: rgba(255,255,255,0.85);
            font-size: 14px;
        }

        .admin-actions {
            display: flex;
            gap: 15px;
            align-items: center;
            position: relative;
            z-index: 1;
        }

        .admin-badge {
            background: rgba(255,255,255,0.2);
            padding: 8px 20px;
            border-radius: 40px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: white;
            font-weight: 500;
            backdrop-filter: blur(10px);
        }

        .btn {
            padding: 10px 22px;
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
            color: #2a5298;
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

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 24px;
            padding: 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: all 0.3s;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            position: relative;
            overflow: hidden;
            cursor: pointer;
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
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }

        .stat-info h3 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .stat-info p {
            color: #718096;
            font-size: 13px;
            font-weight: 500;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            color: white;
        }

        .stat-card.events .stat-icon { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-card.users .stat-icon { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); }
        .stat-card.bookings .stat-icon { background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%); }
        .stat-card.revenue .stat-icon { background: linear-gradient(135deg, #dc3545 0%, #c82333 100%); }
        .stat-card.events .stat-info h3 { color: #667eea; }
        .stat-card.users .stat-info h3 { color: #28a745; }
        .stat-card.bookings .stat-info h3 { color: #ffc107; }
        .stat-card.revenue .stat-info h3 { color: #dc3545; }

        /* Quick Stats Row */
        .quick-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .quick-stat-card {
            background: white;
            border-radius: 20px;
            padding: 20px;
            text-align: center;
            transition: all 0.3s;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .quick-stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
        }

        .quick-stat-value {
            font-size: 24px;
            font-weight: 800;
            color: #2a5298;
        }

        .quick-stat-label {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
        }

        /* Admin Menu */
        .admin-menu {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        .menu-card {
            background: white;
            border-radius: 24px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .menu-card::before {
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

        .menu-card:hover::before {
            transform: scaleX(1);
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 35px rgba(0,0,0,0.15);
        }

        .menu-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 36px;
            color: white;
            transition: all 0.3s;
        }

        .menu-card:hover .menu-icon {
            transform: scale(1.05) rotate(5deg);
        }

        .menu-card h3 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 10px;
            color: #1a202c;
        }

        .menu-card p {
            color: #718096;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .menu-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 10px 25px;
            border-radius: 30px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s;
            font-weight: 600;
            font-size: 13px;
        }

        .menu-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .quick-stats { grid-template-columns: repeat(2, 1fr); }
            .admin-menu { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: 1fr; }
            .quick-stats { grid-template-columns: 1fr; }
            .admin-menu { grid-template-columns: 1fr; }
            .admin-header { flex-direction: column; text-align: center; }
            .admin-actions { justify-content: center; }
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

    <div class="admin-container">
        <div class="admin-header">
            <div class="admin-title">
                <h1><i class="fas fa-crown"></i> Admin Dashboard</h1>
                <p>Welcome back, <strong><%= user.getName() %></strong>! Manage your events and users</p>
            </div>
            <div class="admin-actions">
                <div class="admin-badge">
                    <i class="fas fa-shield-alt"></i> Administrator
                </div>
                <a href="adminProfile.jsp" class="btn btn-white">
                    <i class="fas fa-user-circle"></i> My Profile
                </a>
                <a href="logout" class="btn btn-outline">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
        
        <!-- Main Statistics -->
        <div class="stats-grid">
            <div class="stat-card events">
                <div class="stat-info">
                    <h3><%= totalEvents %></h3>
                    <p>Total Events</p>
                </div>
                <div class="stat-icon"><i class="fas fa-calendar-alt"></i></div>
            </div>
            <div class="stat-card users">
                <div class="stat-info">
                    <h3><%= totalUsers %></h3>
                    <p>Total Users</p>
                </div>
                <div class="stat-icon"><i class="fas fa-users"></i></div>
            </div>
            <div class="stat-card bookings">
                <div class="stat-info">
                    <h3><%= totalBookings %></h3>
                    <p>Total Bookings</p>
                </div>
                <div class="stat-icon"><i class="fas fa-ticket-alt"></i></div>
            </div>
            <div class="stat-card revenue">
                <div class="stat-info">
                    <h3>₹<%= String.format("%,.0f", totalRevenue) %></h3>
                    <p>Total Revenue</p>
                </div>
                <div class="stat-icon"><i class="fas fa-rupee-sign"></i></div>
            </div>
        </div>

        <!-- Quick Statistics -->
        <div class="quick-stats">
            <div class="quick-stat-card">
                <div class="quick-stat-value"><%= confirmedBookings %></div>
                <div class="quick-stat-label"><i class="fas fa-check-circle" style="color: #28a745;"></i> Confirmed Bookings</div>
            </div>
            <div class="quick-stat-card">
                <div class="quick-stat-value"><%= cancelledBookings %></div>
                <div class="quick-stat-label"><i class="fas fa-times-circle" style="color: #dc3545;"></i> Cancelled Bookings</div>
            </div>
            <div class="quick-stat-card">
                <div class="quick-stat-value"><%= String.format("%.1f", occupancyRate) %>%</div>
                <div class="quick-stat-label"><i class="fas fa-chart-line" style="color: #ffc107;"></i> Occupancy Rate</div>
            </div>
        </div>
        
        <!-- Admin Menu Cards -->
        <div class="admin-menu">
            <div class="menu-card">
                <div class="menu-icon"><i class="fas fa-plus-circle"></i></div>
                <h3>Add Event</h3>
                <p>Create new events for users to discover and book</p>
                <a href="addEvent.jsp" class="menu-btn">Add Event →</a>
            </div>
            
            <div class="menu-card">
                <div class="menu-icon"><i class="fas fa-edit"></i></div>
                <h3>Manage Events</h3>
                <p>Edit, update, or delete existing events</p>
                <a href="manageEvents" class="menu-btn">Manage Events →</a>
            </div>
            
            <div class="menu-card">
                <div class="menu-icon"><i class="fas fa-users"></i></div>
                <h3>Manage Users</h3>
                <p>View and manage all registered users</p>
                <a href="manageUsers" class="menu-btn">Manage Users →</a>
            </div>
            
            <div class="menu-card">
                <div class="menu-icon"><i class="fas fa-chart-line"></i></div>
                <h3>Reports</h3>
                <p>View detailed analytics and statistics</p>
                <a href="reports" class="menu-btn">View Reports →</a>
            </div>
            
            <div class="menu-card">
                <div class="menu-icon"><i class="fas fa-ticket-alt"></i></div>
                <h3>All Bookings</h3>
                <p>View all user bookings across events</p>
                <a href="viewAllBookings" class="menu-btn">View Bookings →</a>
            </div>
            
            <div class="menu-card">
                <div class="menu-icon"><i class="fas fa-user-circle"></i></div>
                <h3>My Profile</h3>
                <p>Update your admin profile information</p>
                <a href="adminProfile.jsp" class="menu-btn">View Profile →</a>
            </div>
        </div>
    </div>
</body>
</html>