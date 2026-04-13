<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - OTP Verification | EventHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .otp-card {
            max-width: 480px;
            width: 100%;
            background: white;
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.25);
            overflow: hidden;
            animation: fadeInUp 0.5s ease-out;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .otp-header {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            padding: 35px 30px;
            text-align: center;
            color: white;
        }
        .otp-header i { font-size: 48px; margin-bottom: 15px; }
        .otp-header h2 { font-size: 28px; font-weight: 700; margin-bottom: 8px; }
        .otp-header p { font-size: 14px; opacity: 0.9; }
        .otp-body { padding: 35px 30px; }
        .form-group { margin-bottom: 24px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #1a202c; font-size: 14px; }
        
        /* Password wrapper with eye icon on RIGHT side */
        .password-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .password-wrapper i:first-child {
            position: absolute;
            left: 15px;
            color: #a0aec0;
            font-size: 16px;
            z-index: 1;
        }
        .password-wrapper input {
            flex: 1;
            padding: 14px 45px 14px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            font-size: 15px;
            font-family: inherit;
            width: 100%;
            transition: all 0.3s;
        }
        .password-wrapper input:focus {
            outline: none;
            border-color: #28a745;
            box-shadow: 0 0 0 3px rgba(40,167,69,0.1);
        }
        /* Eye icon on RIGHT side */
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
            color: #28a745;
        }
        
        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }
        .input-wrapper i {
            position: absolute;
            left: 15px;
            color: #a0aec0;
            font-size: 16px;
        }
        .input-wrapper input {
            flex: 1;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            font-size: 15px;
            font-family: inherit;
            width: 100%;
            transition: all 0.3s;
        }
        .input-wrapper input:focus {
            outline: none;
            border-color: #ffc107;
            box-shadow: 0 0 0 3px rgba(255,193,7,0.1);
        }
        
        .btn {
            width: 100%;
            padding: 14px;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            margin-top: 10px;
        }
        .btn-warning {
            background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%);
            color: white;
        }
        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(255,193,7,0.4);
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40,167,69,0.4);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            transform: translateY(-2px);
            background: #5a6268;
        }
        .otp-section {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .reset-section {
            display: none;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
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
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
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
        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }
        .timer {
            font-size: 12px;
            color: #718096;
            margin-top: 8px;
            text-align: center;
        }
        .resend-btn {
            background: none;
            border: none;
            color: #ffc107;
            cursor: pointer;
            font-size: 13px;
            margin-top: 10px;
        }
        .resend-btn:hover {
            text-decoration: underline;
        }
        .back-link { text-align: center; margin-top: 20px; }
        .back-link a { color: #ffc107; text-decoration: none; font-size: 13px; }
        @media (max-width: 480px) {
            .otp-card { border-radius: 24px; }
            .otp-header { padding: 25px 20px; }
            .otp-header h2 { font-size: 24px; }
            .otp-body { padding: 25px 20px; }
        }
    </style>
</head>
<body>
    <div class="otp-card">
        <div class="otp-header">
            <i class="fas fa-key"></i>
            <h2>Reset Password with OTP</h2>
            <p>Get OTP on your email to reset password</p>
        </div>
        <div class="otp-body">
            <div id="messageDiv"></div>
            
            <!-- Step 1: Email Section -->
            <div id="emailSection">
                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email Address</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" id="email" placeholder="Enter your registered email" required>
                    </div>
                </div>
                <button onclick="sendOTP()" class="btn btn-warning" id="sendOtpBtn">
                    <i class="fas fa-paper-plane"></i> Send OTP
                </button>
            </div>
            
            <!-- Step 2: OTP Section -->
            <div id="otpSection" class="otp-section">
                <div class="form-group">
                    <label><i class="fas fa-key"></i> Enter OTP</label>
                    <div class="input-wrapper">
                        <i class="fas fa-key"></i>
                        <input type="text" id="otp" placeholder="Enter 6-digit OTP" maxlength="6" onkeypress="if(event.keyCode==13) verifyOTP()">
                    </div>
                </div>
                <button onclick="verifyOTP()" class="btn btn-warning">
                    <i class="fas fa-check-circle"></i> Verify OTP
                </button>
                <div class="timer" id="timerText"></div>
                <div style="text-align: center;">
                    <button onclick="resendOTP()" class="resend-btn" id="resendBtn" style="display: none;">
                        <i class="fas fa-redo"></i> Resend OTP
                    </button>
                </div>
            </div>
            
            <!-- Step 3: Reset Password Section -->
            <div id="resetSection" class="reset-section">
                <div class="form-group">
                    <label><i class="fas fa-lock"></i> New Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-lock"></i>
                        <input type="password" id="newPassword" placeholder="Minimum 6 characters">
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('newPassword', this)"></i>
                    </div>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-check-circle"></i> Confirm Password</label>
                    <div class="password-wrapper">
                        <i class="fas fa-check-circle"></i>
                        <input type="password" id="confirmPassword" placeholder="Re-enter new password">
                        <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword', this)"></i>
                    </div>
                </div>
                <button onclick="resetPassword()" class="btn btn-success">
                    <i class="fas fa-save"></i> Reset Password
                </button>
            </div>
            
            <div class="back-link">
                <a href="login.jsp"><i class="fas fa-arrow-left"></i> Back to Login</a>
            </div>
        </div>
    </div>

    <script>
        let userEmail = "";
        let timerInterval;
        let timeLeft = 300; // 5 minutes = 300 seconds
        
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
        
        function showMessage(message, type) {
            const msgDiv = document.getElementById("messageDiv");
            const icon = type === "success" ? "fa-check-circle" : (type === "error" ? "fa-exclamation-circle" : "fa-info-circle");
            msgDiv.innerHTML = `<div class="alert alert-${type}"><i class="fas ${icon}"></i> ${message}</div>`;
            setTimeout(() => {
                msgDiv.innerHTML = "";
            }, 5000);
        }
        
        function startTimer() {
            timerInterval = setInterval(() => {
                if (timeLeft <= 0) {
                    clearInterval(timerInterval);
                    document.getElementById("timerText").innerHTML = "OTP expired! Please resend.";
                    document.getElementById("resendBtn").style.display = "inline-block";
                } else {
                    const minutes = Math.floor(timeLeft / 60);
                    const seconds = timeLeft % 60;
                    document.getElementById("timerText").innerHTML = `OTP valid for: ${minutes}:${seconds.toString().padStart(2, '0')}`;
                    timeLeft--;
                }
            }, 1000);
        }
        
        function stopTimer() {
            if (timerInterval) {
                clearInterval(timerInterval);
            }
        }
        
        function sendOTP() {
            const email = document.getElementById("email").value;
            
            if (!email) {
                showMessage("Please enter email address!", "error");
                return;
            }
            
            const btn = document.getElementById("sendOtpBtn");
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
            btn.disabled = true;
            
            fetch("sendOtp", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "email=" + encodeURIComponent(email)
            })
            .then(response => response.json())
            .then(data => {
                btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send OTP';
                btn.disabled = false;
                
                if (data.success) {
                    userEmail = email;
                    showMessage(data.message, "success");
                    document.getElementById("emailSection").style.display = "none";
                    document.getElementById("otpSection").style.display = "block";
                    timeLeft = 300;
                    startTimer();
                } else {
                    showMessage(data.message, "error");
                }
            })
            .catch(error => {
                btn.innerHTML = '<i class="fas fa-paper-plane"></i> Send OTP';
                btn.disabled = false;
                showMessage("Error sending OTP!", "error");
            });
        }
        
        function verifyOTP() {
            const otp = document.getElementById("otp").value;
            
            if (!otp) {
                showMessage("Please enter OTP!", "error");
                return;
            }
            
            if (otp.length !== 6) {
                showMessage("Please enter 6-digit OTP!", "error");
                return;
            }
            
            showMessage("Verifying OTP...", "info");
            
            fetch("verifyOtp", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "email=" + encodeURIComponent(userEmail) + "&otp=" + encodeURIComponent(otp)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage(data.message, "success");
                    stopTimer();
                    document.getElementById("otpSection").style.display = "none";
                    document.getElementById("resetSection").style.display = "block";
                } else {
                    showMessage(data.message, "error");
                }
            })
            .catch(error => {
                showMessage("Error verifying OTP!", "error");
            });
        }
        
        function resendOTP() {
            showMessage("Resending OTP...", "info");
            
            fetch("sendOtp", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "email=" + encodeURIComponent(userEmail)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage("OTP resent to your email!", "success");
                    timeLeft = 300;
                    stopTimer();
                    startTimer();
                    document.getElementById("resendBtn").style.display = "none";
                    document.getElementById("otp").value = "";
                } else {
                    showMessage(data.message, "error");
                }
            })
            .catch(error => {
                showMessage("Error resending OTP!", "error");
            });
        }
        
        function resetPassword() {
            const newPassword = document.getElementById("newPassword").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            
            if (!newPassword || !confirmPassword) {
                showMessage("Please enter new password!", "error");
                return;
            }
            
            if (newPassword !== confirmPassword) {
                showMessage("Passwords do not match!", "error");
                return;
            }
            
            if (newPassword.length < 6) {
                showMessage("Password must be at least 6 characters!", "error");
                return;
            }
            
            showMessage("Resetting password...", "info");
            
            fetch("resetPasswordWithOtp", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "newPassword=" + encodeURIComponent(newPassword) + "&confirmPassword=" + encodeURIComponent(confirmPassword)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage(data.message, "success");
                    setTimeout(() => {
                        window.location.href = "login.jsp";
                    }, 2000);
                } else {
                    showMessage(data.message, "error");
                }
            })
            .catch(error => {
                showMessage("Error resetting password!", "error");
            });
        }
    </script>
</body>
</html>