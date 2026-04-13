<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.Event, com.eventmanagement.model.User, java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
    
    int totalEvents = 0;
    int totalCapacity = 0;
    int totalBooked = 0;
    int totalAvailable = 0;
    double totalRevenue = 0;
    
    if(events != null && !events.isEmpty()) {
        totalEvents = events.size();
        for(Event e : events) {
            totalCapacity += e.getCapacity();
            totalBooked += e.getBookedSeats();
            totalAvailable += e.getAvailableSeats();
            totalRevenue += e.getBookedSeats() * e.getPricePerSeat();
        }
    }
    
    String todayDate = LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - Admin Panel</title>
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
        .btn {
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #1e7e34; transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; transform: translateY(-2px); }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-warning:hover { background: #e0a800; transform: translateY(-2px); }
        .btn-danger { background: #dc3545; color: white; }
        .btn-danger:hover { background: #c82333; transform: translateY(-2px); }
        .btn-sm { padding: 5px 12px; font-size: 12px; }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
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
        .search-box input:focus { outline: none; border-color: #2a5298; }
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
        .seats-high { color: #28a745; font-weight: bold; }
        .seats-low { color: #ffc107; font-weight: bold; }
        .seats-none { color: #dc3545; font-weight: bold; }
        .action-buttons { display: flex; gap: 5px; flex-wrap: wrap; }
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
            <h2><i class="fas fa-calendar-alt"></i> Manage Events</h2>
            <div>
                <a href="addEvent.jsp" class="btn btn-success"><i class="fas fa-plus"></i> Add Event</a>
                <a href="adminDashboard" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back</a>
            </div>
        </div>

        <div class="stats-container">
            <div class="stat-card"><div class="stat-value"><%= totalEvents %></div><div class="stat-label">Total Events</div></div>
            <div class="stat-card"><div class="stat-value"><%= String.format("%,d", totalCapacity) %></div><div class="stat-label">Total Capacity</div></div>
            <div class="stat-card"><div class="stat-value"><%= String.format("%,d", totalBooked) %></div><div class="stat-label">Booked Seats</div></div>
            <div class="stat-card"><div class="stat-value"><%= String.format("%,d", totalAvailable) %></div><div class="stat-label">Available Seats</div></div>
            <div class="stat-card"><div class="stat-value">₹<%= String.format("%,.0f", totalRevenue) %></div><div class="stat-label">Revenue</div></div>
        </div>

        <div class="search-bar">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="Search by event name or location..." onkeyup="searchTable()">
            </div>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr><th>ID</th><th>Event Name</th><th>Location</th><th>Date</th><th>Capacity</th><th>Booked</th><th>Available</th><th>Price</th><th>Actions</th></tr>
                </thead>
                <tbody id="tableBody">
                    <% if(events != null && !events.isEmpty()) { 
                        for(Event e : events) { 
                            int available = e.getAvailableSeats();
                            String seatClass = available > 10 ? "seats-high" : (available > 0 ? "seats-low" : "seats-none");
                    %>
                        <tr>
                            <td><strong><%= e.getEventId() %></strong></td>
                            <td><%= e.getName() %></td>
                            <td><%= e.getLocation() %></td>
                            <td><%= e.getEventDate() %></td>
                            <td><%= e.getCapacity() %></td>
                            <td><%= e.getBookedSeats() %></td>
                            <td class="<%= seatClass %>"><%= available %></td>
                            <td>₹<%= e.getPricePerSeat() %></td>
                            <td class="action-buttons">
                                <a href="${pageContext.request.contextPath}/editEvent?id=<%= e.getEventId() %>" class="btn btn-warning btn-sm"><i class="fas fa-edit"></i> Edit</a>
                                <a href="${pageContext.request.contextPath}/deleteEvent?id=<%= e.getEventId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete <%= e.getName() %>?')"><i class="fas fa-trash"></i> Delete</a>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr><td colspan="9" class="no-data">No events found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="footer">
            <p>&copy; 2026 EventHub - Admin Panel</p>
        </div>
    </div>

    <script>
        function searchTable() {
            var input = document.getElementById('searchInput');
            var filter = input.value.toLowerCase();
            var rows = document.getElementById('tableBody').getElementsByTagName('tr');
            for(var i = 0; i < rows.length; i++) {
                var name = rows[i].getElementsByTagName('td')[1];
                var location = rows[i].getElementsByTagName('td')[2];
                if(name && location) {
                    if(name.innerText.toLowerCase().indexOf(filter) > -1 || location.innerText.toLowerCase().indexOf(filter) > -1) {
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