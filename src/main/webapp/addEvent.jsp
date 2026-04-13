<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Event - Admin Panel | EventHub</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
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

        /* Main Card */
        .add-event-card {
            max-width: 580px;
            width: 100%;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
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
        .add-event-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            padding: 35px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .add-event-header::before {
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
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .add-event-header h2 {
            font-size: 26px;
            font-weight: 800;
            position: relative;
            z-index: 1;
        }

        .add-event-header p {
            font-size: 13px;
            opacity: 0.9;
            margin-top: 5px;
            position: relative;
            z-index: 1;
        }

        /* Body */
        .add-event-body {
            padding: 35px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 22px;
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
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.1);
        }

        /* Button Group */
        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .btn {
            flex: 1;
            padding: 14px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .btn-primary::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn-primary:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        /* Alert Messages */
        .alert {
            padding: 14px 16px;
            border-radius: 12px;
            margin-bottom: 25px;
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

        .alert i {
            font-size: 18px;
        }

        /* Info Note */
        .info-note {
            background: #f8f9fa;
            padding: 12px 16px;
            border-radius: 12px;
            margin-top: 20px;
            font-size: 11px;
            color: #718096;
            display: flex;
            align-items: center;
            gap: 8px;
            border-left: 3px solid #28a745;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .add-event-card {
                border-radius: 24px;
            }
            .add-event-header {
                padding: 25px;
            }
            .add-event-body {
                padding: 25px;
            }
            .button-group {
                flex-direction: column;
                gap: 10px;
            }
        }
    </style>
    <script>
        function validateForm() {
            var name = document.getElementById('eventName').value;
            var location = document.getElementById('location').value;
            var date = document.getElementById('eventDate').value;
            var capacity = document.getElementById('capacity').value;
            var price = document.getElementById('price').value;
            
            if (name.length < 3) {
                alert('Event name must be at least 3 characters long!');
                return false;
            }
            
            if (location.length < 2) {
                alert('Please enter a valid location!');
                return false;
            }
            
            if (date === "") {
                alert('Please select an event date!');
                return false;
            }
            
            var today = new Date().toISOString().split('T')[0];
            if (date < today) {
                alert('Event date cannot be in the past!');
                return false;
            }
            
            if (capacity < 1) {
                alert('Capacity must be at least 1 seat!');
                return false;
            }
            
            if (price < 1) {
                alert('Price must be at least ₹1!');
                return false;
            }
            
            // Show loading effect
            var btn = document.querySelector('.btn-primary');
            var originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Adding Event...';
            btn.disabled = true;
            
            setTimeout(function() {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }, 2000);
            
            return true;
        }
        
        // Set min date to today
        document.addEventListener('DOMContentLoaded', function() {
            var today = new Date().toISOString().split('T')[0];
            document.getElementById('eventDate').setAttribute('min', today);
            document.getElementById('eventName').focus();
        });
    </script>
</head>
<body>
    <div class="animated-bg"></div>
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
    </div>

    <div class="add-event-card">
        <div class="add-event-header">
            <div class="header-icon">
                <i class="fas fa-plus-circle"></i>
            </div>
            <h2>Add New Event</h2>
            <p>Create a new event for users to discover and book</p>
        </div>

        <div class="add-event-body">
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
            
            <form action="${pageContext.request.contextPath}/addEvent" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Event Name</label>
                    <div class="input-wrapper">
                        <i class="fas fa-calendar-alt"></i>
                        <input type="text" id="eventName" name="name" class="form-control" 
                               placeholder="Enter event name (e.g., Music Night 2026)" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt"></i> Location</label>
                    <div class="input-wrapper">
                        <i class="fas fa-map-marker-alt"></i>
                        <input type="text" id="location" name="location" class="form-control" 
                               placeholder="Enter venue location (e.g., Pune, Mumbai)" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-calendar"></i> Event Date</label>
                    <div class="input-wrapper">
                        <i class="fas fa-calendar"></i>
                        <input type="date" id="eventDate" name="date" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-chair"></i> Total Capacity</label>
                    <div class="input-wrapper">
                        <i class="fas fa-users"></i>
                        <input type="number" id="capacity" name="capacity" class="form-control" 
                               placeholder="Maximum number of seats" min="1" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-rupee-sign"></i> Price per Seat</label>
                    <div class="input-wrapper">
                        <i class="fas fa-rupee-sign"></i>
                        <input type="number" id="price" name="price" class="form-control" 
                               placeholder="Enter price per seat" min="1" step="1" value="500" required>
                    </div>
                </div>
                
                <div class="button-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Add Event
                    </button>
                    <a href="${pageContext.request.contextPath}/adminDashboard" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </form>
            
            <div class="info-note">
                <i class="fas fa-info-circle"></i>
                <span>Once added, the event will be visible to all users for booking.</span>
            </div>
        </div>
    </div>
</body>
</html>