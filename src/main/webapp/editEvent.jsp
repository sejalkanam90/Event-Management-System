<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.Event, com.eventmanagement.model.User" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    Event event = (Event) request.getAttribute("event");
    if (event == null) {
        response.sendRedirect("manageEvents");
        return;
    }
    
    // Calculate seat status
    int availableSeats = event.getAvailableSeats();
    String seatStatus = availableSeats > 10 ? "Available" : (availableSeats > 0 ? "Limited" : "Sold Out");
    String seatStatusColor = availableSeats > 10 ? "#28a745" : (availableSeats > 0 ? "#ffc107" : "#dc3545");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event - Admin Panel | EventHub</title>
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

        /* Main Container */
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2);
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
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 30px;
            text-align: center;
            color: white;
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
            background: radial-gradient(circle, rgba(255,255,255,0.08) 1px, transparent 1px);
            background-size: 30px 30px;
            animation: shimmer 20s linear infinite;
        }

        @keyframes shimmer {
            0% { transform: translate(0, 0); }
            100% { transform: translate(30px, 30px); }
        }

        .header-icon {
            width: 70px;
            height: 70px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 32px;
            position: relative;
            z-index: 1;
        }

        .header h2 {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 5px;
            position: relative;
            z-index: 1;
        }

        .header p {
            font-size: 13px;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        /* Body */
        .edit-body {
            padding: 35px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1a202c;
            font-size: 13px;
        }

        .input-wrapper {
            position: relative;
            width: 100%;
        }

        .input-wrapper i {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 14px;
            z-index: 1;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px 12px 42px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #2a5298;
            box-shadow: 0 0 0 3px rgba(42, 82, 152, 0.1);
        }

        .readonly-field {
            background: #f8f9fa;
            color: #718096;
            cursor: not-allowed;
            border-color: #e2e8f0;
        }

        .readonly-field:focus {
            border-color: #e2e8f0;
            box-shadow: none;
        }

        /* Status Card */
        .status-card {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .status-item {
            text-align: center;
            flex: 1;
        }

        .status-label {
            font-size: 11px;
            color: #718096;
            margin-bottom: 5px;
        }

        .status-value {
            font-size: 18px;
            font-weight: 700;
        }

        /* Button */
        .btn {
            width: 100%;
            padding: 14px;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            margin-top: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: #333;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,193,7,0.3);
        }

        /* Back Link */
        .back-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .back-link a {
            color: #2a5298;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
        }

        .back-link a:hover {
            color: #1e3c72;
            transform: translateX(-3px);
        }

        /* Alert Messages */
        .alert {
            padding: 12px 16px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 13px;
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
            border-left: 4px solid #dc3545;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .edit-body {
                padding: 25px;
            }
            .status-card {
                flex-direction: column;
            }
            .status-item {
                width: 100%;
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
            <div class="header-icon">
                <i class="fas fa-edit"></i>
            </div>
            <h2>Edit Event</h2>
            <p>Update event details and information</p>
        </div>

        <div class="edit-body">
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

            <!-- Status Card -->
            <div class="status-card">
                <div class="status-item">
                    <div class="status-label">Total Capacity</div>
                    <div class="status-value"><%= String.format("%,d", event.getCapacity()) %></div>
                </div>
                <div class="status-item">
                    <div class="status-label">Booked Seats</div>
                    <div class="status-value" style="color: #dc3545;"><%= String.format("%,d", event.getBookedSeats()) %></div>
                </div>
                <div class="status-item">
                    <div class="status-label">Available Seats</div>
                    <div class="status-value" style="color: <%= seatStatusColor %>;"><%= String.format("%,d", availableSeats) %></div>
                </div>
                <div class="status-item">
                    <div class="status-label">Status</div>
                    <div class="status-value" style="color: <%= seatStatusColor %>;"><%= seatStatus %></div>
                </div>
            </div>
            
            <form action="editEvent" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                
                <div class="form-group">
                    <label><i class="fas fa-qrcode"></i> Event ID</label>
                    <div class="input-wrapper">
                        <i class="fas fa-qrcode"></i>
                        <input type="text" value="<%= event.getEventId() %>" class="form-control readonly-field" readonly>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Event Name</label>
                    <div class="input-wrapper">
                        <i class="fas fa-calendar-alt"></i>
                        <input type="text" name="name" id="name" value="<%= event.getName() %>" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt"></i> Location</label>
                    <div class="input-wrapper">
                        <i class="fas fa-map-marker-alt"></i>
                        <input type="text" name="location" value="<%= event.getLocation() %>" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-calendar"></i> Event Date</label>
                    <div class="input-wrapper">
                        <i class="fas fa-calendar"></i>
                        <input type="date" name="date" value="<%= event.getEventDate() %>" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-chair"></i> Capacity</label>
                    <div class="input-wrapper">
                        <i class="fas fa-users"></i>
                        <input type="number" name="capacity" id="capacity" value="<%= event.getCapacity() %>" min="1" class="form-control" required>
                    </div>
                    <div class="info-text" style="font-size: 11px; color: #718096; margin-top: 5px;">
                        <i class="fas fa-info-circle"></i> Capacity cannot be less than booked seats (<%= event.getBookedSeats() %>)
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-rupee-sign"></i> Price per Seat</label>
                    <div class="input-wrapper">
                        <i class="fas fa-rupee-sign"></i>
                        <input type="number" name="price" value="<%= event.getPricePerSeat() %>" step="1" min="1" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-ticket-alt"></i> Booked Seats</label>
                    <div class="input-wrapper">
                        <i class="fas fa-ticket-alt"></i>
                        <input type="text" value="<%= String.format("%,d", event.getBookedSeats()) %>" class="form-control readonly-field" readonly>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update Event
                </button>
            </form>
            
            <div class="back-link">
                <a href="manageEvents">
                    <i class="fas fa-arrow-left"></i> Back to Manage Events
                </a>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            var capacity = document.getElementById('capacity').value;
            var bookedSeats = <%= event.getBookedSeats() %>;
            
            if (parseInt(capacity) < bookedSeats) {
                alert('Capacity cannot be less than booked seats (' + bookedSeats + ')');
                return false;
            }
            
            // Show loading effect
            var btn = document.querySelector('.btn-primary');
            var originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';
            btn.disabled = true;
            
            setTimeout(function() {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }, 2000);
            
            return true;
        }
        
        // Auto-focus on name field
        document.getElementById('name').focus();
    </script>
</body>
</html>