<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify OTP - EventHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #ec4899, #8b5cf6);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .otp-container {
            background: white;
            border-radius: 30px;
            padding: 40px;
            max-width: 450px;
            width: 100%;
            text-align: center;
            box-shadow: 0 25px 50px rgba(0,0,0,0.2);
            animation: fadeIn 0.5s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
        }
        .otp-icon {
            font-size: 60px;
            background: linear-gradient(135deg, #ec4899, #8b5cf6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 20px;
        }
        .otp-container h1 {
            font-size: 28px;
            color: #333;
            margin-bottom: 10px;
        }
        .otp-container p {
            color: #666;
            margin-bottom: 30px;
        }
        .otp-inputs {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-bottom: 30px;
        }
        .otp-input {
            width: 50px;
            height: 50px;
            text-align: center;
            font-size: 24px;
            font-weight: 600;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            transition: 0.3s;
        }
        .otp-input:focus {
            border-color: #ec4899;
            outline: none;
        }
        .btn-verify {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #ec4899, #8b5cf6);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-verify:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(236,72,153,0.3);
        }
        .resend-link {
            margin-top: 20px;
        }
        .resend-link a {
            color: #ec4899;
            text-decoration: none;
        }
        .error-msg {
            background: #fee;
            color: #dc2626;
            padding: 12px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .timer {
            color: #666;
            font-size: 14px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="otp-container">
        <div class="otp-icon">
            <i class="fas fa-envelope"></i>
        </div>
        <h1>Verify OTP</h1>
        <p>Enter the 6-digit code sent to your email</p>
        
        <% if(request.getParameter("error") != null) { %>
            <div class="error-msg">
                <i class="fas fa-exclamation-circle"></i> Invalid OTP! Please try again.
            </div>
        <% } %>
        
        <form action="VerifyOtpServlet" method="post" id="otpForm">
            <input type="hidden" name="email" value="<%= request.getParameter("email") %>">
            <div class="otp-inputs">
                <input type="text" class="otp-input" maxlength="1" onkeyup="moveToNext(this, 0)" id="otp1" name="otp1" required>
                <input type="text" class="otp-input" maxlength="1" onkeyup="moveToNext(this, 1)" id="otp2" name="otp2" required>
                <input type="text" class="otp-input" maxlength="1" onkeyup="moveToNext(this, 2)" id="otp3" name="otp3" required>
                <input type="text" class="otp-input" maxlength="1" onkeyup="moveToNext(this, 3)" id="otp4" name="otp4" required>
                <input type="text" class="otp-input" maxlength="1" onkeyup="moveToNext(this, 4)" id="otp5" name="otp5" required>
                <input type="text" class="otp-input" maxlength="1" onkeyup="moveToNext(this, 5)" id="otp6" name="otp6" required>
            </div>
            <input type="hidden" name="otp" id="otpValue">
            <button type="submit" class="btn-verify">Verify OTP →</button>
        </form>
        <div class="resend-link">
            <a href="ForgotPasswordServlet?resend=true&email=<%= request.getParameter("email") %>">Resend OTP</a>
        </div>
        <div class="timer" id="timer">OTP expires in 10:00</div>
    </div>
    
    <script>
        function moveToNext(current, index) {
            if (current.value.length === 1 && index < 5) {
                document.getElementById('otp' + (index + 2)).focus();
            }
            
            // Combine all OTP digits
            let otp = '';
            for (let i = 1; i <= 6; i++) {
                let val = document.getElementById('otp' + i).value;
                if (val) otp += val;
            }
            document.getElementById('otpValue').value = otp;
        }
        
        // Timer for OTP expiry
        let timeLeft = 600; // 10 minutes in seconds
        const timerElement = document.getElementById('timer');
        
        const timerInterval = setInterval(() => {
            if (timeLeft <= 0) {
                clearInterval(timerInterval);
                timerElement.innerHTML = 'OTP expired! Please request again.';
                timerElement.style.color = '#dc2626';
            } else {
                timeLeft--;
                const minutes = Math.floor(timeLeft / 60);
                const seconds = timeLeft % 60;
                timerElement.innerHTML = `OTP expires in ${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            }
        }, 1000);
    </script>
</body>
</html>