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
    <title>Change Password - EventHub</title>
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

        /* Password Card */
        .password-card {
            max-width: 500px;
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
        .password-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 30px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .password-header::before {
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

        .password-icon {
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

        .password-header h2 {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }

        .password-header p {
            font-size: 14px;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        /* Body */
        .password-body {
            padding: 35px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 24px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1a202c;
            font-size: 13px;
        }

        .password-wrapper {
            position: relative;
            width: 100%;
        }

        .password-wrapper i:first-child {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            font-size: 16px;
            z-index: 1;
        }

        .password-wrapper input {
            width: 100%;
            padding: 14px 45px 14px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            font-size: 15px;
            font-family: inherit;
            transition: all 0.3s;
            background: white;
        }

        .password-wrapper input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #a0aec0;
            font-size: 18px;
            z-index: 1;
            transition: color 0.3s;
        }

        .toggle-password:hover {
            color: #667eea;
        }

        /* Password Strength Meter */
        .password-strength {
            margin-top: 10px;
            height: 5px;
            background: #e2e8f0;
            border-radius: 5px;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
            border-radius: 5px;
        }

        .strength-text {
            font-size: 11px;
            margin-top: 6px;
            font-weight: 500;
        }

        /* Match Message */
        .match-message {
            font-size: 11px;
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

        /* Requirements Box */
        .requirements {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 14px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }

        .requirements-title {
            font-size: 13px;
            font-weight: 600;
            color: #1a202c;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .requirements-list {
            list-style: none;
            padding-left: 5px;
        }

        .requirements-list li {
            font-size: 12px;
            color: #718096;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .requirements-list li i {
            font-size: 10px;
            color: #a0aec0;
        }

        .requirements-list li.valid {
            color: #28a745;
        }

        .requirements-list li.valid i {
            color: #28a745;
        }

        .forgot-link {
            text-align: right;
            margin-top: -10px;
            margin-bottom: 15px;
        }

        .forgot-link a {
            color: #667eea;
            text-decoration: none;
            font-size: 12px;
        }

        .forgot-link a:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .password-card {
                border-radius: 24px;
            }
            .password-header {
                padding: 30px 20px;
            }
            .password-header h2 {
                font-size: 24px;
            }
            .password-body {
                padding: 25px;
            }
        }
    </style>
    <script>
        function togglePassword(inputId, iconElement) {
            var input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
                iconElement.classList.remove("fa-eye");
                iconElement.classList.add("fa-eye-slash");
            } else {
                input.type = "password";
                iconElement.classList.remove("fa-eye-slash");
                iconElement.classList.add("fa-eye");
            }
        }
        
        // Check password strength
        function checkPasswordStrength() {
            var password = document.getElementById("newPassword").value;
            var strengthBar = document.getElementById("strengthBar");
            var strengthText = document.getElementById("strengthText");
            
            var strength = 0;
            
            if (password.length >= 6) strength++;
            if (password.length >= 10) strength++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;
            
            var width = (strength / 5) * 100;
            strengthBar.style.width = width + "%";
            
            if (strength <= 1) {
                strengthBar.style.background = "#dc3545";
                strengthText.innerHTML = "Weak password";
                strengthText.style.color = "#dc3545";
            } else if (strength <= 3) {
                strengthBar.style.background = "#ffc107";
                strengthText.innerHTML = "Medium password";
                strengthText.style.color = "#ffc107";
            } else {
                strengthBar.style.background = "#28a745";
                strengthText.innerHTML = "Strong password";
                strengthText.style.color = "#28a745";
            }
            
            if (password.length === 0) {
                strengthBar.style.width = "0%";
                strengthText.innerHTML = "";
            }
            
            // Update requirements checklist
            updateRequirements(password);
            checkMatch();
        }
        
        // Update requirements checklist
        function updateRequirements(password) {
            const minLength = document.getElementById("req-length");
            const uppercase = document.getElementById("req-uppercase");
            const number = document.getElementById("req-number");
            const special = document.getElementById("req-special");
            
            if (password.length >= 6) {
                minLength.classList.add("valid");
                minLength.innerHTML = '<i class="fas fa-check-circle"></i> At least 6 characters';
            } else {
                minLength.classList.remove("valid");
                minLength.innerHTML = '<i class="fas fa-circle"></i> At least 6 characters';
            }
            
            if (password.match(/[A-Z]/)) {
                uppercase.classList.add("valid");
                uppercase.innerHTML = '<i class="fas fa-check-circle"></i> Contains uppercase letter';
            } else {
                uppercase.classList.remove("valid");
                uppercase.innerHTML = '<i class="fas fa-circle"></i> Contains uppercase letter';
            }
            
            if (password.match(/[0-9]/)) {
                number.classList.add("valid");
                number.innerHTML = '<i class="fas fa-check-circle"></i> Contains number';
            } else {
                number.classList.remove("valid");
                number.innerHTML = '<i class="fas fa-circle"></i> Contains number';
            }
            
            if (password.match(/[^a-zA-Z0-9]/)) {
                special.classList.add("valid");
                special.innerHTML = '<i class="fas fa-check-circle"></i> Contains special character';
            } else {
                special.classList.remove("valid");
                special.innerHTML = '<i class="fas fa-circle"></i> Contains special character';
            }
        }
        
        // Check if passwords match
        function checkMatch() {
            var newPwd = document.getElementById("newPassword").value;
            var confirmPwd = document.getElementById("confirmPassword").value;
            var matchMsg = document.getElementById("matchMessage");
            
            if (confirmPwd.length > 0) {
                if (newPwd === confirmPwd) {
                    matchMsg.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
                    matchMsg.style.color = "#28a745";
                } else {
                    matchMsg.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
                    matchMsg.style.color = "#dc3545";
                }
            } else {
                matchMsg.innerHTML = '';
            }
        }
        
        // Validate form before submit
        function validateForm() {
            var currentPwd = document.getElementById("currentPassword").value;
            var newPwd = document.getElementById("newPassword").value;
            var confirmPwd = document.getElementById("confirmPassword").value;
            
            if (currentPwd.length === 0) {
                alert("Please enter your current password!");
                return false;
            }
            
            if (newPwd !== confirmPwd) {
                alert("New passwords do not match!\n\nPlease make sure both passwords are identical.");
                return false;
            }
            
            if (newPwd.length < 6) {
                alert("Password too short!\n\nPassword must be at least 6 characters long.");
                return false;
            }
            
            if (!newPwd.match(/[A-Z]/)) {
                alert("Weak password!\n\nPassword must contain at least one uppercase letter.");
                return false;
            }
            
            if (currentPwd === newPwd) {
                alert("New password cannot be the same as current password!\n\nPlease choose a different password.");
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
    </script>
</head>
<body>
    <div class="animated-bg"></div>
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
    </div>

    <div class="password-card">
        <div class="password-header">
            <div class="password-icon">
                <i class="fas fa-key"></i>
            </div>
            <h2>Change Password</h2>
            <p>Keep your account secure</p>
        </div>

        <div class="password-body">
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
            
            <div class="requirements">
                <div class="requirements-title">
                    <i class="fas fa-shield-alt"></i> Password Requirements
                </div>
                <ul class="requirements-list">
                    <li id="req-length"><i class="fas fa-circle"></i> At least 6 characters</li>
                    <li id="req-uppercase"><i class="fas fa-circle"></i> Contains uppercase letter</li>
                    <li id="req-number"><i class="fas fa-circle"></i> Contains number</li>
                    <li id="req-special"><i class="fas fa-circle"></i> Contains special character</li>
                </ul>
            </div>
            
            <form action="changePassword" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label><i class="fas fa-lock"></i> Current Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="currentPassword" name="currentPassword" 
                               placeholder="Enter current password" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('currentPassword', this)"></i>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-key"></i> New Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-key"></i>
                        <input type="password" id="newPassword" name="newPassword" 
                               placeholder="Enter new password" 
                               onkeyup="checkPasswordStrength()"
                               required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('newPassword', this)"></i>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="strength-text" id="strengthText"></div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-check-circle"></i> Confirm New Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-check"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" 
                               placeholder="Re-enter new password" 
                               onkeyup="checkMatch()"
                               required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>
                    <div id="matchMessage" class="match-message"></div>
                </div>
                
                <div class="forgot-link">
                    <a href="forgotPassword.jsp"><i class="fas fa-question-circle"></i> Forgot Password?</a>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-save"></i> Update Password
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