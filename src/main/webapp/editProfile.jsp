<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Determine back link based on role
    String backLink = "ADMIN".equals(user.getRole()) ? "adminProfile.jsp" : "profile.jsp";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - EventHub</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow-x: hidden;
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

        /* Edit Card */
        .edit-card {
            max-width: 520px;
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
        .edit-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .edit-header::before {
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

        .edit-icon {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 40px;
            animation: pulse 2s infinite;
            position: relative;
            z-index: 1;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .edit-header h2 {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .edit-header p {
            font-size: 14px;
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
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 16px;
            z-index: 1;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .readonly-field {
            background: #f8f9fa;
            color: #718096;
            cursor: not-allowed;
            border-color: #e2e8f0;
        }

        .info-text {
            font-size: 11px;
            color: #a0aec0;
            margin-top: 6px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Button */
        .btn {
            width: 100%;
            padding: 14px;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
            margin-top: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            position: relative;
            overflow: hidden;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
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
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        /* Back Link */
        .back-link {
            text-align: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 13px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s;
        }

        .back-link a:hover {
            color: #764ba2;
            transform: translateX(-3px);
        }

        /* Alert Messages */
        .alert {
            padding: 14px 16px;
            border-radius: 14px;
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

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background: #fed7d7;
            color: #c53030;
            border-left: 4px solid #dc3545;
        }

        .alert i {
            font-size: 18px;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .edit-card {
                border-radius: 24px;
            }
            .edit-header {
                padding: 30px 20px;
            }
            .edit-header h2 {
                font-size: 24px;
            }
            .edit-body {
                padding: 25px;
            }
        }
    </style>
    <script>
        function validateForm() {
            var name = document.getElementById('name').value;
            var mobile = document.getElementById('mobile').value;
            
            if (name.length < 2) {
                alert('Please enter a valid name (minimum 2 characters)');
                return false;
            }
            
            if (mobile.length > 0 && mobile.length !== 10) {
                alert('Please enter a valid 10-digit mobile number');
                return false;
            }
            
            if (mobile.length > 0 && !/^\d+$/.test(mobile)) {
                alert('Mobile number should contain only digits');
                return false;
            }
            
            // Show loading effect
            var btn = document.querySelector('.btn-primary');
            var originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Saving...';
            btn.disabled = true;
            
            setTimeout(function() {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }, 2000);
            
            return true;
        }
        
        // Auto-focus on name field
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('name').focus();
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

    <div class="edit-card">
        <div class="edit-header">
            <div class="edit-icon">
                <i class="fas fa-user-edit"></i>
            </div>
            <h2>Edit Profile</h2>
            <p>Update your personal information</p>
        </div>

        <div class="edit-body">
            <% if (request.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="editProfile" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label><i class="fas fa-id-card"></i> User ID</label>
                    <div class="input-wrapper">
                        <i class="fas fa-id-card"></i>
                        <input type="text" value="<%= user.getUserId() %>" class="form-control readonly-field" readonly>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Full Name</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user"></i>
                        <input type="text" name="name" id="name" value="<%= user.getName() %>" class="form-control" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email Address</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" value="<%= user.getEmail() %>" class="form-control readonly-field" readonly>
                    </div>
                    <div class="info-text">
                        <i class="fas fa-info-circle"></i> Email address cannot be changed
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-phone"></i> Mobile Number</label>
                    <div class="input-wrapper">
                        <i class="fas fa-phone"></i>
                        <input type="tel" name="mobile" id="mobile" value="<%= user.getMobile() != null ? user.getMobile() : "" %>" 
                               class="form-control" placeholder="Enter 10-digit mobile number" maxlength="10">
                    </div>
                    <div class="info-text">
                        <i class="fas fa-info-circle"></i> Optional - Enter 10-digit mobile number
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>
            
            <div class="back-link">
                <a href="<%= backLink %>">
                    <i class="fas fa-arrow-left"></i> Back to Profile
                </a>
            </div>
        </div>
    </div>
</body>
</html>