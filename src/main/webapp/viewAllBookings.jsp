<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.Booking, com.eventmanagement.model.User, java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    
    int totalBookings = 0;
    int confirmedCount = 0;
    int cancelledCount = 0;
    double totalRevenue = 0;  
    
    if(bookings != null && !bookings.isEmpty()) {
        totalBookings = bookings.size();
        for(Booking b : bookings) {
            if("CONFIRMED".equals(b.getStatus())) {
                confirmedCount++;
                totalRevenue += b.getTotalAmount();  
            } else if("CANCELLED".equals(b.getStatus())) {
                cancelledCount++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings - Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 25px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            color: white;
        }
        .header h2 { font-size: 24px; font-weight: 600; }
        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }
        .btn-secondary:hover { background: rgba(255,255,255,0.3); transform: translateY(-2px); }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            padding: 20px 30px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
        .stat-card {
            background: white;
            padding: 15px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .stat-value { font-size: 24px; font-weight: 700; color: #2a5298; }
        .stat-label { font-size: 11px; color: #666; margin-top: 5px; }
        .search-bar {
            padding: 15px 30px;
            background: white;
            border-bottom: 1px solid #e9ecef;
        }
        .search-box input {
            width: 100%;
            max-width: 350px;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        .table-container { padding: 20px 30px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 800px; }
        th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #e9ecef;
        }
        td { padding: 12px; border-bottom: 1px solid #e9ecef; color: #555; }
        tr:hover { background: #f8f9fa; }
        .status-confirmed {
            background: #d4edda;
            color: #155724;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 12px;
            font-weight: 500;
        }
        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
            padding: 4px 12px;
            border-radius: 20px;
            display: inline-block;
            font-size: 12px;
            font-weight: 500;
        }
        .no-data { text-align: center; padding: 40px; color: #999; }
        .footer { text-align: center; padding: 15px; background: #f8f9fa; color: #666; font-size: 12px; border-top: 1px solid #e9ecef; }
        @media (max-width: 768px) {
            .stats-container { grid-template-columns: repeat(2, 1fr); }
            .header { flex-direction: column; text-align: center; }
            .table-container { padding: 15px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2><i class="fas fa-ticket-alt"></i> All Bookings</h2>
            <a href="adminDashboard" class="btn-secondary"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>

        <!-- Statistics Cards - फक्त confirmed bookings चा revenue -->
        <div class="stats-container">
            <div class="stat-card"><div class="stat-value"><%= totalBookings %></div><div class="stat-label">Total Bookings</div></div>
            <div class="stat-card"><div class="stat-value"><%= confirmedCount %></div><div class="stat-label">Confirmed</div></div>
            <div class="stat-card"><div class="stat-value"><%= cancelledCount %></div><div class="stat-label">Cancelled</div></div>
            <div class="stat-card"><div class="stat-value">₹<%= String.format("%,.0f", totalRevenue) %></div><div class="stat-label">Revenue (Confirmed)</div></div>
        </div>

        <div class="search-bar">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by Booking ID, User ID, or Event..." onkeyup="searchTable()">
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr><th>Booking ID</th><th>User ID</th><th>Event Name</th><th>Seats</th><th>Amount</th><th>Booking Date</th><th>Status</th></tr>
                </thead>
                <tbody id="tableBody">
                    <% if(bookings != null && !bookings.isEmpty()) { 
                        for(Booking b : bookings) { 
                    %>
                        <tr>
                            <td><strong><%= b.getBookingId() %></strong></td>
                            <td><%= b.getUserId() %></td>
                            <td><%= b.getEventName() != null ? b.getEventName() : "Event" %></td>
                            <td><%= b.getSeats() %></td>
                            <td><strong>₹<%= String.format("%,.0f", b.getTotalAmount()) %></strong></td>
                            <td><%= b.getBookingDate() %></td>
                            <td><span class="status-<%= b.getStatus().toLowerCase() %>"><%= b.getStatus() %></span></td>
                        </tr>
                    <% } } else { %>
                        <tr><td colspan="7" class="no-data">No bookings found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="footer">
            <p>&copy; 2026 EventHub - Admin Panel | Total Revenue (Confirmed): ₹<%= String.format("%,.0f", totalRevenue) %></p>
        </div>
    </div>

    <script>
        function searchTable() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toLowerCase();
            var rows = document.getElementById('tableBody').getElementsByTagName('tr');
            for(var i = 0; i < rows.length; i++) {
                var bookingId = rows[i].getElementsByTagName('td')[0];
                var userId = rows[i].getElementsByTagName('td')[1];
                var eventName = rows[i].getElementsByTagName('td')[2];
                if(bookingId && userId && eventName) {
                    if(bookingId.innerText.toLowerCase().indexOf(filter) > -1 || 
                       userId.innerText.toLowerCase().indexOf(filter) > -1 ||
                       eventName.innerText.toLowerCase().indexOf(filter) > -1) {
                        rows[i].style.display = '';
                    } else {
                        rows[i].style.display = 'none';
                    }
                }
            }
        }
    </script>
</body>
</html>