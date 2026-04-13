<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User, com.eventmanagement.dao.BookingDAO, com.eventmanagement.dao.EventDAO, com.eventmanagement.dao.UserDAO, java.util.List, com.eventmanagement.model.Booking" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    EventDAO eventDAO = new EventDAO();
    UserDAO userDAO = new UserDAO();
    BookingDAO bookingDAO = new BookingDAO();
    
    // System Statistics
    int totalEvents = eventDAO.getAllEvents().size();
    int totalUsers = userDAO.getAllUsers().size();
    List<Booking> allBookings = bookingDAO.getAllBookings();
    int totalBookings = allBookings != null ? allBookings.size() : 0;
    double totalRevenue = 0;
    int confirmedBookings = 0;
    int cancelledBookings = 0;
    
    if (allBookings != null) {
        for (Booking b : allBookings) {
            totalRevenue += b.getTotalAmount();
            if ("CONFIRMED".equals(b.getStatus())) confirmedBookings++;
            else if ("CANCELLED".equals(b.getStatus())) cancelledBookings++;
        }
    }
    
    // Recent bookings (last 5)
    List<Booking> recentBookings = null;
    if (allBookings != null && allBookings.size() > 0) {
        recentBookings = allBookings.size() > 5 ? allBookings.subList(0, 5) : allBookings;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - EventHub</title>
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

        .shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; animation-duration: 25s; }
        .shape-2 { width: 200px; height: 200px; bottom: -50px; right: -50px; animation-duration: 20s; animation-delay: 2s; }
        .shape-3 { width: 150px; height: 150px; top: 50%; left: 80%; animation-duration: 18s; animation-delay: 4s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }

        /* Profile Container */
        .profile-container {
            max-width: 1100px;
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

        .profile-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 32px;
            overflow: hidden;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
        }

        /* Profile Header */
        .profile-header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 40px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .profile-header::before {
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

        .profile-avatar {
            width: 120px;
            height: 120px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 56px;
            font-weight: 800;
            color: #2a5298;
            position: relative;
            z-index: 1;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            transition: transform 0.3s;
        }

        .profile-avatar:hover {
            transform: scale(1.05);
        }

        .profile-name {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .profile-role {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 6px 16px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 600;
            background: rgba(255,255,255,0.2);
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 1;
        }

        /* Profile Body */
        .profile-body {
            padding: 35px;
        }

        /* Info Sections */
        .info-section {
            margin-bottom: 30px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title i {
            color: #2a5298;
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 15px;
            background: #f8f9fa;
            border-radius: 12px;
            transition: all 0.3s;
        }

        .info-row:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .info-label {
            color: #718096;
            font-weight: 500;
            font-size: 13px;
        }

        .info-value {
            color: #2d3748;
            font-weight: 600;
            font-size: 14px;
        }

        /* Admin Stats Grid */
        .admin-stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 15px;
        }

        .admin-stat-box {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 20px;
            border-radius: 16px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
        }

        .admin-stat-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .admin-stat-number {
            font-size: 32px;
            font-weight: 800;
        }

        .admin-stat-label {
            font-size: 11px;
            margin-top: 8px;
            opacity: 0.9;
            font-weight: 500;
        }

        /* Booking List */
        .booking-list {
            margin-top: 15px;
        }

        .booking-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 12px;
            margin-bottom: 10px;
            transition: all 0.3s;
            cursor: pointer;
        }

        .booking-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .booking-info {
            flex: 1;
        }

        .booking-id {
            font-weight: 700;
            color: #2a5298;
            font-size: 14px;
        }

        .booking-event {
            font-size: 13px;
            color: #718096;
            margin-top: 4px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .booking-seats {
            font-size: 12px;
            color: #718096;
            margin-top: 2px;
        }

        .booking-user {
            font-size: 11px;
            color: #a0aec0;
            margin-top: 3px;
        }

        .booking-amount {
            font-weight: 700;
            color: #28a745;
            margin-right: 15px;
            font-size: 16px;
        }

        .booking-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .status-confirmed {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .btn {
            flex: 1;
            padding: 12px 20px;
            border-radius: 12px;
            text-decoration: none;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            font-size: 14px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(30,60,114,0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .no-bookings {
            text-align: center;
            padding: 40px;
            background: #f8f9fa;
            border-radius: 16px;
            color: #718096;
        }

        .no-bookings i {
            font-size: 56px;
            margin-bottom: 15px;
            opacity: 0.5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .profile-body {
                padding: 25px;
            }
            .info-grid {
                grid-template-columns: 1fr;
            }
            .admin-stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .action-buttons {
                flex-direction: column;
            }
            .booking-item {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            .profile-header {
                padding: 30px;
            }
            .profile-avatar {
                width: 90px;
                height: 90px;
                font-size: 42px;
            }
            .profile-name {
                font-size: 22px;
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

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar">
                    <%= admin.getName().charAt(0) %>
                </div>
                <div class="profile-name"><%= admin.getName() %></div>
                <div class="profile-role">
                    <i class="fas fa-crown"></i> ADMINISTRATOR
                </div>
            </div>
            
            <div class="profile-body">
                <!-- Personal Information -->
                <div class="info-section">
                    <div class="section-title">
                        <i class="fas fa-user-circle"></i> Personal Information
                    </div>
                    <div class="info-grid">
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-id-card"></i> Admin ID</span>
                            <span class="info-value"><%= admin.getUserId() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-user"></i> Full Name</span>
                            <span class="info-value"><%= admin.getName() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-envelope"></i> Email Address</span>
                            <span class="info-value"><%= admin.getEmail() %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-phone"></i> Mobile Number</span>
                            <span class="info-value"><%= admin.getMobile() != null && !admin.getMobile().isEmpty() ? admin.getMobile() : "Not provided" %></span>
                        </div>
                        <div class="info-row">
                            <span class="info-label"><i class="fas fa-calendar-alt"></i> Member Since</span>
                            <span class="info-value"><%= admin.getCreatedAt() != null ? admin.getCreatedAt() : "N/A" %></span>
                        </div>
                    </div>
                </div>
                
                <!-- System Statistics -->
                <div class="info-section">
                    <div class="section-title">
                        <i class="fas fa-chart-line"></i> System Statistics
                    </div>
                    <div class="admin-stats-grid">
                        <div class="admin-stat-box">
                            <div class="admin-stat-number"><%= totalEvents %></div>
                            <div class="admin-stat-label">Total Events</div>
                        </div>
                        <div class="admin-stat-box">
                            <div class="admin-stat-number"><%= totalUsers %></div>
                            <div class="admin-stat-label">Total Users</div>
                        </div>
                        <div class="admin-stat-box">
                            <div class="admin-stat-number"><%= totalBookings %></div>
                            <div class="admin-stat-label">Total Bookings</div>
                        </div>
                        <div class="admin-stat-box">
                            <div class="admin-stat-number">₹<%= String.format("%,.0f", totalRevenue) %></div>
                            <div class="admin-stat-label">Total Revenue</div>
                        </div>
                        <div class="admin-stat-box">
                            <div class="admin-stat-number"><%= confirmedBookings %></div>
                            <div class="admin-stat-label">Confirmed Bookings</div>
                        </div>
                        <div class="admin-stat-box">
                            <div class="admin-stat-number"><%= cancelledBookings %></div>
                            <div class="admin-stat-label">Cancelled Bookings</div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Bookings -->
                <div class="info-section">
                    <div class="section-title">
                        <i class="fas fa-ticket-alt"></i> Recent Bookings
                    </div>
                    <% if (recentBookings != null && !recentBookings.isEmpty()) { %>
                        <div class="booking-list">
                            <% for (Booking b : recentBookings) { %>
                                <div class="booking-item">
                                    <div class="booking-info">
                                        <div class="booking-id">Booking #<%= b.getBookingId() %></div>
                                        <div class="booking-event">
                                            <i class="fas fa-calendar-alt" style="color: #2a5298;"></i> 
                                            <%= b.getEventName() != null ? b.getEventName() : "Event" %>
                                        </div>
                                        <div class="booking-seats">
                                            <i class="fas fa-chair"></i> <%= b.getSeats() %> seat(s)
                                        </div>
                                        <div class="booking-user">
                                            <i class="fas fa-user"></i> User ID: <%= b.getUserId() %>
                                        </div>
                                    </div>
                                    <div class="booking-amount">₹<%= String.format("%,.0f", b.getTotalAmount()) %></div>
                                    <div class="booking-status status-<%= b.getStatus().toLowerCase() %>">
                                        <i class="fas <%= "CONFIRMED".equals(b.getStatus()) ? "fa-check-circle" : "fa-times-circle" %>"></i>
                                        <%= b.getStatus() %>
                                    </div>
                                </div>
                            <% } %>
                        </div>
                        <% if (totalBookings > 5) { %>
                            <div style="text-align: center; margin-top: 15px;">
                                <a href="viewAllBookings" class="btn btn-secondary" style="display: inline-block; width: auto; padding: 10px 24px;">
                                    View All <%= totalBookings %> Bookings <i class="fas fa-arrow-right"></i>
                                </a>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="no-bookings">
                            <i class="fas fa-calendar-times"></i>
                            <p>No bookings yet in the system.</p>
                        </div>
                    <% } %>
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <a href="editProfile.jsp" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                    <a href="changePassword.jsp" class="btn btn-primary">
                        <i class="fas fa-key"></i> Change Password
                    </a>
                    <a href="adminDashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>