<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - EventHub</title>
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

        /* Animated Background - Same as Login */
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
        .shape-4 { width: 100px; height: 100px; bottom: 30%; left: 10%; animation-duration: 15s; animation-delay: 1s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }

        /* Register Card */
        .register-container {
            max-width: 550px;
            width: 100%;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
            overflow: hidden;
            position: relative;
            z-index: 1;
            animation: slideUp 0.6s ease-out;
            backdrop-filter: blur(10px);
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header */
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 35px 30px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .register-header::before {
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

        .register-icon {
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
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }

        .register-header h2 {
            font-size: 32px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .register-header p {
            font-size: 14px;
            opacity: 0.9;
        }

        /* Body */
        .register-body {
            padding: 35px;
            max-height: 70vh;
            overflow-y: auto;
        }

        /* Custom Scrollbar */
        .register-body::-webkit-scrollbar {
            width: 6px;
        }

        .register-body::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        .register-body::-webkit-scrollbar-thumb {
            background: #667eea;
            border-radius: 10px;
        }

        /* Form Groups */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #1a202c;
            font-size: 13px;
        }

        .input-group {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-group i:not(.toggle-password) {
            position: absolute;
            left: 15px;
            color: #a0aec0;
            font-size: 16px;
            z-index: 1;
        }

        .input-group input, .input-group select {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
            background: white;
        }

        .input-group input:focus, .input-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        /* Password Wrapper */
        .password-wrapper {
            position: relative;
            width: 100%;
        }

        .password-wrapper input {
            width: 100%;
            padding: 12px 45px 12px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .password-wrapper input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .password-wrapper i:first-child {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            z-index: 1;
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
            margin-top: 8px;
            height: 4px;
            background: #e2e8f0;
            border-radius: 4px;
            overflow: hidden;
        }

        .strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s;
            border-radius: 4px;
        }

        .strength-text {
            font-size: 11px;
            margin-top: 5px;
            color: #718096;
        }

        /* Register Button */
        .register-btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
        }

        .register-btn::before {
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

        .register-btn:hover::before {
            width: 300px;
            height: 300px;
        }

        .register-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }

        /* Links */
        .login-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .login-link p {
            color: #718096;
            font-size: 14px;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }

        .login-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }

        .back-home {
            text-align: center;
            margin-top: 15px;
        }

        .back-home a {
            color: #a0aec0;
            text-decoration: none;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }

        .back-home a:hover {
            color: #667eea;
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
            border-left: 4px solid #c53030;
        }

        .alert-success {
            background: #c6f6d5;
            color: #276749;
            border-left: 4px solid #276749;
        }

        .alert i {
            font-size: 18px;
        }

        /* Terms */
        .terms {
            margin-top: 15px;
            text-align: center;
            font-size: 11px;
            color: #a0aec0;
        }

        .terms a {
            color: #667eea;
            text-decoration: none;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .register-container {
                border-radius: 24px;
            }
            .register-header {
                padding: 25px 20px;
            }
            .register-header h2 {
                font-size: 26px;
            }
            .register-body {
                padding: 25px;
            }
        }
    </style>
    <script>
        // Toggle password visibility
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
        
        // Password strength checker
        function checkPasswordStrength() {
            var password = document.getElementById("password").value;
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
        }
        
        // Validate form before submit
        function validateForm() {
            var name = document.getElementById("name").value;
            var email = document.getElementById("email").value;
            var mobile = document.getElementById("mobile").value;
            var pwd = document.getElementById("password").value;
            var cpwd = document.getElementById("confirmPassword").value;
            
            if (name.length < 2) {
                alert("Please enter your full name!");
                return false;
            }
            
            var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                alert("Please enter a valid email address!");
                return false;
            }
            
            if (mobile.length > 0 && mobile.length < 10) {
                alert("Please enter a valid 10-digit mobile number!");
                return false;
            }
            
            if (pwd !== cpwd) {
                alert("Passwords do not match!");
                return false;
            }
            
            if (pwd.length < 6) {
                alert("Password must be at least 6 characters!");
                return false;
            }
            
            return true;
        }
        
        // Real-time validation
        function validateEmail() {
            var email = document.getElementById("email").value;
            var emailError = document.getElementById("emailError");
            var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (email.length > 0 && !emailPattern.test(email)) {
                emailError.style.display = "block";
            } else {
                emailError.style.display = "none";
            }
        }
        
        function validateMobile() {
            var mobile = document.getElementById("mobile").value;
            var mobileError = document.getElementById("mobileError");
            
            if (mobile.length > 0 && mobile.length !== 10) {
                mobileError.style.display = "block";
            } else {
                mobileError.style.display = "none";
            }
        }
    </script>
</head>
<body>
    <div class="animated-bg"></div>
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
        <div class="shape shape-3"></div>
        <div class="shape shape-4"></div>
    </div>

    <div class="register-container">
        <div class="register-header">
            <div class="register-icon">
                <i class="fas fa-user-plus"></i>
            </div>
            <h2>Create Account</h2>
            <p>Join EventHub and discover amazing events</p>
        </div>

        <div class="register-body">
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
            
            <form action="register" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label><i class="fas fa-user"></i> Full Name</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <input type="text" id="name" name="name" placeholder="Enter your full name" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email Address</label>
                    <div class="input-group">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" name="email" placeholder="Enter your email" onkeyup="validateEmail()" required>
                    </div>
                    <div id="emailError" style="display: none; color: #dc3545; font-size: 11px; margin-top: 5px;">
                        <i class="fas fa-exclamation-circle"></i> Please enter a valid email
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-phone"></i> Mobile Number <span style="color:#999; font-weight:normal;">(Optional)</span></label>
                    <div class="input-group">
                        <i class="fas fa-phone"></i>
                        <input type="tel" id="mobile" name="mobile" placeholder="Enter 10-digit mobile number" onkeyup="validateMobile()" maxlength="10">
                    </div>
                    <div id="mobileError" style="display: none; color: #dc3545; font-size: 11px; margin-top: 5px;">
                        <i class="fas fa-exclamation-circle"></i> Mobile number must be 10 digits
                    </div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-key"></i> Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="password" name="password" placeholder="Minimum 6 characters" 
                               onkeyup="checkPasswordStrength()" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('password', this)"></i>
                    </div>
                    <div class="password-strength">
                        <div class="strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="strength-text" id="strengthText"></div>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-check-circle"></i> Confirm Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-check"></i>
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>
                </div>
                
                <button type="submit" class="register-btn">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>
            
            <div class="login-link">
                <p>Already have an account? <a href="login.jsp">Sign In</a></p>
            </div>
            
            <div class="back-home">
                <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Home</a>
            </div>
            
            <div class="terms">
                By registering, you agree to our <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
            </div>
        </div>
    </div>
</body>
</html>