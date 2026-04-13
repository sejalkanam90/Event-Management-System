<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User"%>
<%
User user = (User) session.getAttribute("user");
if (user == null) {
	response.sendRedirect("login.jsp");
	return;
}

String eventId = request.getParameter("eventId");
String seatsStr = request.getParameter("seats");
int seats = Integer.parseInt(seatsStr);
double amount = seats * 500;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Secure Payment - EventHub</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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

.payment-container {
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
.payment-header {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	padding: 30px;
	text-align: center;
	color: white;
	position: relative;
	overflow: hidden;
}

.payment-header::before {
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

.payment-header i {
	font-size: 56px;
	margin-bottom: 15px;
	position: relative;
	z-index: 1;
}

.payment-header h2 {
	font-size: 26px;
	font-weight: 800;
	position: relative;
	z-index: 1;
}

.payment-header p {
	font-size: 13px;
	opacity: 0.9;
	margin-top: 5px;
	position: relative;
	z-index: 1;
}

/* Amount Box */
.amount-box {
	background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
	padding: 25px;
	text-align: center;
	border-bottom: 1px solid #e9ecef;
}

.amount-label {
	font-size: 13px;
	color: #718096;
	letter-spacing: 1px;
	font-weight: 500;
}

.amount-value {
	font-size: 48px;
	font-weight: 800;
	background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	margin: 8px 0;
}

.seats-info {
	font-size: 13px;
	color: #718096;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 8px;
}

/* Body */
.payment-body {
	padding: 30px;
}

/* Payment Methods */
.methods-title {
	font-size: 14px;
	font-weight: 700;
	color: #1a202c;
	margin-bottom: 15px;
	display: flex;
	align-items: center;
	gap: 8px;
}

.payment-methods {
	display: flex;
	gap: 12px;
	margin-bottom: 25px;
}

.method {
	flex: 1;
	text-align: center;
	padding: 14px 8px;
	border: 2px solid #e2e8f0;
	border-radius: 16px;
	cursor: pointer;
	transition: all 0.3s;
	background: white;
}

.method:hover {
	border-color: #667eea;
	transform: translateY(-3px);
	box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.method.selected {
	border-color: #28a745;
	background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
}

.method i {
	font-size: 28px;
	margin-bottom: 8px;
	display: block;
}

.method span {
	font-size: 11px;
	font-weight: 600;
}

/* Form */
.payment-details {
	display: none;
	margin-top: 20px;
	animation: fadeIn 0.3s ease;
}

.payment-details.active {
	display: block;
}

@keyframes fadeIn {
	from { opacity: 0; transform: translateY(-10px); }
	to { opacity: 1; transform: translateY(0); }
}

.form-group {
	margin-bottom: 18px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-size: 12px;
	font-weight: 600;
	color: #4a5568;
}

.form-group input, .form-group select {
	width: 100%;
	padding: 12px 14px;
	border: 2px solid #e2e8f0;
	border-radius: 12px;
	font-size: 14px;
	font-family: inherit;
	transition: all 0.3s;
	background: white;
}

.form-group input:focus, .form-group select:focus {
	outline: none;
	border-color: #667eea;
	box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.row-2 {
	display: flex;
	gap: 12px;
}

.row-2 .form-group {
	flex: 1;
}

/* Pay Button */
.pay-btn {
	width: 100%;
	padding: 16px;
	background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
	color: white;
	border: none;
	border-radius: 14px;
	font-size: 16px;
	font-weight: 700;
	cursor: pointer;
	margin-top: 25px;
	transition: all 0.3s;
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 10px;
	position: relative;
	overflow: hidden;
}

.pay-btn::before {
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

.pay-btn:hover::before {
	width: 300px;
	height: 300px;
}

.pay-btn:hover {
	transform: translateY(-2px);
	box-shadow: 0 10px 25px rgba(40, 167, 69, 0.4);
}

/* Back Link */
.back-link {
	text-align: center;
	margin-top: 20px;
	padding-top: 20px;
	border-top: 1px solid #e2e8f0;
}

.back-link a {
	color: #a0aec0;
	text-decoration: none;
	font-size: 13px;
	font-weight: 500;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	transition: all 0.3s;
}

.back-link a:hover {
	color: #667eea;
	transform: translateX(-3px);
}

/* Security Badge */
.security-badge {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 15px;
	margin-top: 20px;
	padding: 12px;
	background: #f8f9fa;
	border-radius: 12px;
	font-size: 11px;
	color: #718096;
}

.security-badge i {
	color: #28a745;
}

/* Responsive */
@media (max-width: 480px) {
	.payment-methods {
		flex-direction: column;
	}
	.row-2 {
		flex-direction: column;
	}
	.amount-value {
		font-size: 36px;
	}
	.payment-header i {
		font-size: 40px;
	}
	.payment-body {
		padding: 25px;
	}
}
</style>
<script>
        function selectMethod(method) {
            document.getElementById('paymentMethod').value = method;
            
            // Hide all details
            document.getElementById('cardDetails').classList.remove('active');
            document.getElementById('upiDetails').classList.remove('active');
            document.getElementById('netbankingDetails').classList.remove('active');
            
            // Show selected
            document.getElementById(method + 'Details').classList.add('active');
            
            // Update selected style
            document.querySelectorAll('.method').forEach(el => {
                el.classList.remove('selected');
            });
            document.getElementById(method + 'Method').classList.add('selected');
        }
        
        function validateForm() {
            var method = document.getElementById('paymentMethod').value;
            
            if (method === 'card') {
                var cardNum = document.getElementById('cardNumber').value.replace(/\s/g, '');
                if (cardNum.length === 0) {
                    alert('Please enter card number');
                    return false;
                }
                if (cardNum.length < 16) {
                    alert('Please enter valid 16-digit card number');
                    return false;
                }
                var expiry = document.getElementById('expiry').value;
                if (expiry.length === 0) {
                    alert('Please enter expiry date');
                    return false;
                }
                if (!expiry.match(/^\d{2}\/\d{2}$/)) {
                    alert('Please enter expiry date in MM/YY format');
                    return false;
                }
                var cvv = document.getElementById('cvv').value;
                if (cvv.length === 0) {
                    alert('Please enter CVV');
                    return false;
                }
                if (cvv.length !== 3) {
                    alert('Please enter valid 3-digit CVV');
                    return false;
                }
            }
            
            if (method === 'upi') {
                var upiId = document.getElementById('upiId').value;
                if (upiId.length === 0) {
                    alert('Please enter UPI ID');
                    return false;
                }
                if (!upiId.includes('@')) {
                    alert('Please enter valid UPI ID (e.g., username@okhdfcbank)');
                    return false;
                }
            }
            
            if (method === 'netbanking') {
                var bank = document.getElementById('bankName').value;
                if (bank === "") {
                    alert('Please select a bank');
                    return false;
                }
            }
            
            // Show loading effect
            const btn = document.querySelector('.pay-btn');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
            btn.disabled = true;
            
            setTimeout(() => {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }, 2000);
            
            return true;
        }
        
        // Format card number with spaces
        function formatCardNumber(input) {
            let value = input.value.replace(/\s/g, '');
            if (value.length > 16) value = value.slice(0, 16);
            let formatted = value.match(/.{1,4}/g)?.join(' ') || value;
            input.value = formatted;
        }
        
        // Restrict input to numbers only
        function restrictToNumbers(input) {
            input.value = input.value.replace(/[^0-9]/g, '');
        }
        
        // Auto-format expiry date (MM/YY)
        function formatExpiry(input) {
            let value = input.value.replace(/[^0-9]/g, '');
            if (value.length >= 2) {
                value = value.slice(0,2) + '/' + value.slice(2,4);
            }
            input.value = value;
        }
        
        // Set default values for testing
        function setTestValues() {
            document.getElementById('cardNumber').value = '1234 5678 9012 3456';
            document.getElementById('expiry').value = '12/25';
            document.getElementById('cvv').value = '123';
        }
    </script>
</head>
<body onload="setTestValues()">
	<div class="animated-bg"></div>
	<div class="floating-shapes">
		<div class="shape shape-1"></div>
		<div class="shape shape-2"></div>
		<div class="shape shape-3"></div>
	</div>

	<div class="payment-container">
		<div class="payment-header">
			<i class="fas fa-lock"></i>
			<h2>Secure Payment</h2>
			<p>Your transaction is protected with 256-bit SSL encryption</p>
		</div>

		<div class="amount-box">
			<div class="amount-label">Total Amount</div>
			<div class="amount-value">
				₹<%=String.format("%,.0f", amount)%></div>
			<div class="seats-info">
				<i class="fas fa-ticket-alt"></i>
				<%=seats%> ticket(s) × ₹500
			</div>
		</div>

		<div class="payment-body">
			<form action="${pageContext.request.contextPath}/bookEvent" method="post"
				onsubmit="return validateForm()">
				<input type="hidden" name="eventId" value="<%=eventId%>">
				<input type="hidden" name="seats" value="<%=seats%>"> 
				<input type="hidden" name="paymentMethod" id="paymentMethod" value="card">

				<div class="methods-title">
					<i class="fas fa-credit-card"></i> Choose Payment Method
				</div>
				<div class="payment-methods">
					<div class="method selected" id="cardMethod"
						onclick="selectMethod('card')">
						<i class="fab fa-cc-visa"></i> <span>Card</span>
					</div>
					<div class="method" id="upiMethod" onclick="selectMethod('upi')">
						<i class="fas fa-mobile-alt"></i> <span>UPI</span>
					</div>
					<div class="method" id="netbankingMethod"
						onclick="selectMethod('netbanking')">
						<i class="fas fa-university"></i> <span>Net Banking</span>
					</div>
				</div>

				<!-- Card Details -->
				<div id="cardDetails" class="payment-details active">
					<div class="form-group">
						<label><i class="fas fa-credit-card"></i> Card Number</label> 
						<input type="text" id="cardNumber" name="cardNumber" 
							placeholder="1234 5678 9012 3456" maxlength="19" 
							oninput="formatCardNumber(this)" autocomplete="off" required>
					</div>
					<div class="row-2">
						<div class="form-group">
							<label><i class="far fa-calendar-alt"></i> Expiry Date</label> 
							<input type="text" id="expiry" name="expiry" 
								placeholder="MM/YY" maxlength="5" 
								oninput="formatExpiry(this)" autocomplete="off" required>
						</div>
						<div class="form-group">
							<label><i class="fas fa-shield-alt"></i> CVV</label> 
							<input type="password" id="cvv" name="cvv" 
								placeholder="123" maxlength="3" 
								oninput="restrictToNumbers(this)" autocomplete="off" required>
						</div>
					</div>
					<div class="form-group">
						<label><i class="fas fa-user"></i> Card Holder Name</label> 
						<input type="text" name="cardHolder" value="<%=user.getName()%>" 
							autocomplete="off" required>
					</div>
				</div>

				<!-- UPI Details -->
				<div id="upiDetails" class="payment-details">
					<div class="form-group">
						<label><i class="fas fa-mobile-alt"></i> UPI ID</label> 
						<input type="text" id="upiId" name="upiId" 
							placeholder="username@okhdfcbank" autocomplete="off">
					</div>
				</div>

				<!-- Net Banking Details -->
				<div id="netbankingDetails" class="payment-details">
					<div class="form-group">
						<label><i class="fas fa-university"></i> Select Bank</label> 
						<select name="bankName" id="bankName">
							<option value="">-- Select Bank --</option>
							<option value="SBI">State Bank of India (SBI)</option>
							<option value="HDFC">HDFC Bank</option>
							<option value="ICICI">ICICI Bank</option>
							<option value="AXIS">Axis Bank</option>
							<option value="KOTAK">Kotak Mahindra Bank</option>
							<option value="YES">Yes Bank</option>
							<option value="PNB">Punjab National Bank</option>
							<option value="BOB">Bank of Baroda</option>
						</select>
					</div>
				</div>

				<button type="submit" class="pay-btn">
					<i class="fas fa-lock"></i> Pay ₹<%=String.format("%,.0f", amount)%>
				</button>
			</form>

			<div class="security-badge">
				<i class="fas fa-shield-alt"></i> 256-bit SSL Secure
				<i class="fas fa-lock"></i> PCI Compliant
			</div>

			<div class="back-link">
				<a href="userDashboard"><i class="fas fa-arrow-left"></i> Cancel & Back</a>
			</div>
		</div>
	</div>
</body>
</html>