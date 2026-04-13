<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - EventHub</title>
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
        .dashboard-container {
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
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 35px 40px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            position: relative;
            overflow: hidden;
        }

        .dashboard-header::before {
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

        .welcome-section {
            position: relative;
            z-index: 1;
        }

        .welcome-section h1 {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .welcome-section p {
            opacity: 0.9;
            font-size: 14px;
        }

        .user-badge {
            display: flex;
            align-items: center;
            gap: 15px;
            background: rgba(255,255,255,0.2);
            padding: 8px 20px;
            border-radius: 50px;
            backdrop-filter: blur(10px);
            position: relative;
            z-index: 1;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 18px;
            color: #667eea;
        }

        .btn-logout {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        /* Stats Section */
        .stats-section {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            padding: 30px 40px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 20px;
            text-align: center;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
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

        /* Quick Actions */
        .quick-actions {
            padding: 30px 40px;
            background: white;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .action-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 20px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .action-card::before {
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

        .action-card:hover::before {
            transform: scaleX(1);
        }

        .action-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 35px rgba(0,0,0,0.1);
            border-color: #667eea;
        }

        .action-icon {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 32px;
            color: white;
        }

        .action-card:nth-child(1) .action-icon { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .action-card:nth-child(2) .action-icon { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); }
        .action-card:nth-child(3) .action-icon { background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%); }
        .action-card:nth-child(4) .action-icon { background: linear-gradient(135deg, #6c757d 0%, #5a6268 100%); }

        .action-card h3 {
            font-size: 20px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 10px;
        }

        .action-card p {
            color: #718096;
            font-size: 13px;
            margin-bottom: 20px;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 24px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s;
        }

        .action-card:nth-child(1) .action-btn { background: #667eea; color: white; }
        .action-card:nth-child(2) .action-btn { background: #28a745; color: white; }
        .action-card:nth-child(3) .action-btn { background: #ffc107; color: #333; }
        .action-card:nth-child(4) .action-btn { background: #6c757d; color: white; }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        /* Footer */
        .dashboard-footer {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            color: #718096;
            font-size: 12px;
            border-top: 1px solid #e9ecef;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .dashboard-header {
                padding: 25px;
                text-align: center;
                flex-direction: column;
            }
            .stats-section {
                padding: 20px;
            }
            .quick-actions {
                padding: 25px;
            }
            .actions-grid {
                grid-template-columns: 1fr;
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

    <div class="dashboard-container">
        <div class="dashboard-header">
            <div class="welcome-section">
                <h1>Welcome back, <%= user.getName() %>!</h1>
                <p><i class="fas fa-calendar-alt"></i> Ready to explore amazing events?</p>
            </div>
            <div class="user-badge">
                <div class="user-avatar">
                    <%= user.getName().charAt(0) %>
                </div>
                <div>
                    <div style="font-weight: 600;"><%= user.getEmail() %></div>
                    <div style="font-size: 11px; opacity: 0.8;"><%= user.getRole() %></div>
                </div>
                <a href="logout" class="btn-logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>

        <!-- Stats Section -->
        <div class="stats-section">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-calendar-alt"></i>
                </div>
                <div class="stat-value">50+</div>
                <div class="stat-label">Events Available</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-value">10K+</div>
                <div class="stat-label">Happy Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <div class="stat-value">500+</div>
                <div class="stat-label">Bookings Made</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-star"></i>
                </div>
                <div class="stat-value">4.8</div>
                <div class="stat-label">Rating</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="quick-actions">
            <div class="section-title">
                <i class="fas fa-bolt"></i>
                <span>Quick Actions</span>
            </div>
            <div class="actions-grid">
                <div class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-calendar-alt"></i>
                    </div>
                    <h3>Browse Events</h3>
                    <p>Discover and book amazing events near you</p>
                    <a href="viewEvents" class="action-btn">
                        Explore Events <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <div class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-ticket-alt"></i>
                    </div>
                    <h3>My Bookings</h3>
                    <p>View your booking history and manage tickets</p>
                    <a href="viewBookings" class="action-btn">
                        View Bookings <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <% if("ADMIN".equals(user.getRole())) { %>
                <div class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <h3>Add Event</h3>
                    <p>Create new events for users to discover</p>
                    <a href="addEvent.jsp" class="action-btn">
                        Add Event <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <% } %>

                <div class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h3>My Profile</h3>
                    <p>Update your personal information and settings</p>
                    <a href="profile.jsp" class="action-btn">
                        View Profile <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>

        <div class="dashboard-footer">
            <p>&copy; 2026 EventHub - Your Event Management Partner | Logged in as: <%= user.getName() %> (ID: <%= user.getUserId() %>)</p>
        </div>
    </div>
</body>
</html>