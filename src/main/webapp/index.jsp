<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHub | Professional Event Management Platform</title>
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
            background: #0f0f1a;
            overflow-x: hidden;
        }

        /* Animated Background */
        .animated-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -2;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .animated-bg::before {
            content: '';
            position: absolute;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px);
            background-size: 50px 50px;
            animation: moveDots 20s linear infinite;
            opacity: 0.5;
        }

        @keyframes moveDots {
            0% { transform: translate(0, 0); }
            100% { transform: translate(50px, 50px); }
        }

        .animated-bg::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            background: radial-gradient(ellipse at center, rgba(102,126,234,0.3) 0%, rgba(118,75,162,0.3) 100%);
            animation: pulse 4s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 0.5; }
            50% { opacity: 1; }
        }

        /* Floating Shapes */
        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }

        .shape {
            position: absolute;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            animation: float 20s infinite ease-in-out;
        }

        .shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; animation-duration: 25s; }
        .shape-2 { width: 200px; height: 200px; bottom: -50px; right: -50px; animation-duration: 20s; animation-delay: 2s; }
        .shape-3 { width: 150px; height: 150px; top: 50%; left: 80%; animation-duration: 18s; animation-delay: 4s; }
        .shape-4 { width: 250px; height: 250px; bottom: 20%; left: 10%; animation-duration: 22s; animation-delay: 1s; }
        .shape-5 { width: 100px; height: 100px; top: 20%; right: 15%; animation-duration: 15s; animation-delay: 3s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }

        /* Main Container */
        .main-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }

        /* Navigation */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 40px;
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(10px);
            border-radius: 60px;
            margin-bottom: 60px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            animation: slideDown 0.6s ease;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 26px;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .logo i {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 30px;
        }

        .nav-links {
            display: flex;
            gap: 45px;
        }

        .nav-links a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: all 0.3s;
            position: relative;
            font-size: 16px;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: -5px;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: width 0.3s;
        }

        .nav-links a:hover::after {
            width: 100%;
        }

        .nav-links a:hover {
            color: #667eea;
        }

        .nav-buttons {
            display: flex;
            gap: 15px;
        }

        .btn-nav {
            padding: 10px 28px;
            border-radius: 40px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            font-size: 14px;
        }

        .btn-login {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-login:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }

        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102,126,234,0.4);
        }

        /* Hero Section */
        .hero {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
            margin-bottom: 100px;
            padding: 50px;
            background: rgba(255,255,255,0.95);
            border-radius: 50px;
            backdrop-filter: blur(10px);
        }

        .hero-content {
            animation: fadeInLeft 0.8s ease;
        }

        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .hero-badge {
            display: inline-block;
            padding: 8px 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 40px;
            color: white;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }

        .hero-content h1 {
            font-size: 52px;
            font-weight: 800;
            color: #1a202c;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .gradient-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-content p {
            font-size: 18px;
            color: #4a5568;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .hero-stats {
            display: flex;
            gap: 40px;
            margin-bottom: 30px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 32px;
            font-weight: 800;
            color: #667eea;
        }

        .stat-label {
            font-size: 13px;
            color: #718096;
            margin-top: 5px;
        }

        .hero-buttons {
            display: flex;
            gap: 20px;
        }

        .btn-hero {
            padding: 15px 35px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 16px;
        }

        .btn-hero-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-hero-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102,126,234,0.4);
        }

        .btn-hero-secondary {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-hero-secondary:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }

        /* Hero Image */
        .hero-image {
            animation: fadeInRight 0.8s ease;
            text-align: center;
        }

        @keyframes fadeInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .hero-img {
            width: 100%;
            max-width: 550px;
            border-radius: 30px;
            box-shadow: 0 25px 45px rgba(0,0,0,0.25);
            transition: all 0.3s ease;
            border: 4px solid rgba(255,255,255,0.3);
        }

        .hero-img:hover {
            transform: scale(1.03);
            box-shadow: 0 30px 60px rgba(0,0,0,0.3);
        }

        /* Features Section */
        .features {
            padding: 70px 50px;
            background: white;
            border-radius: 50px;
            margin-bottom: 60px;
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }

        .section-title h2 {
            font-size: 42px;
            font-weight: 800;
            color: #1a202c;
            margin-bottom: 15px;
        }

        .section-title p {
            font-size: 18px;
            color: #718096;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 35px;
        }

        .feature-card {
            text-align: center;
            padding: 45px 35px;
            background: #f8f9fa;
            border-radius: 35px;
            transition: all 0.4s;
            cursor: pointer;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            background: white;
        }

        .feature-icon {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 38px;
            color: white;
            transition: all 0.3s;
        }

        .feature-card:hover .feature-icon {
            transform: scale(1.1) rotate(5deg);
        }

        .feature-card h3 {
            font-size: 24px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 15px;
        }

        .feature-card p {
            color: #718096;
            line-height: 1.6;
            font-size: 15px;
        }

        /* CTA Section */
        .cta-section {
            padding: 70px 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50px;
            text-align: center;
            margin-bottom: 60px;
            color: white;
        }

        .cta-section h2 {
            font-size: 42px;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .cta-section p {
            font-size: 18px;
            opacity: 0.9;
            margin-bottom: 35px;
        }

        .btn-cta {
            padding: 16px 45px;
            background: white;
            color: #667eea;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 700;
            font-size: 18px;
            display: inline-flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s;
        }

        .btn-cta:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }

        /* Footer */
        .footer {
            background: #1a202c;
            border-radius: 40px;
            padding: 60px 50px 35px;
            color: white;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 50px;
            margin-bottom: 45px;
        }

        .footer-section h3 {
            font-size: 20px;
            margin-bottom: 22px;
            position: relative;
            display: inline-block;
        }

        .footer-section h3::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 45px;
            height: 3px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 3px;
        }

        .footer-section p {
            color: #a0aec0;
            line-height: 1.7;
            margin-bottom: 18px;
            font-size: 14px;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 12px;
        }

        .footer-section ul li a {
            color: #a0aec0;
            text-decoration: none;
            transition: color 0.3s;
            font-size: 14px;
        }

        .footer-section ul li a:hover {
            color: #667eea;
        }

        .social-links {
            display: flex;
            gap: 18px;
            margin-top: 25px;
        }

        .social-links a {
            width: 42px;
            height: 42px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 18px;
        }

        .social-links a:hover {
            background: #667eea;
            transform: translateY(-3px);
        }

        .footer-bottom {
            text-align: center;
            padding-top: 35px;
            border-top: 1px solid rgba(255,255,255,0.1);
            color: #718096;
            font-size: 14px;
        }

        /* Responsive */
        @media (max-width: 968px) {
            .hero {
                grid-template-columns: 1fr;
                text-align: center;
                padding: 35px;
                gap: 35px;
            }
            .hero-stats {
                justify-content: center;
            }
            .hero-buttons {
                justify-content: center;
            }
            .navbar {
                flex-direction: column;
                gap: 20px;
                padding: 18px 25px;
                border-radius: 40px;
            }
            .hero-content h1 {
                font-size: 36px;
            }
            .hero-img {
                max-width: 380px;
            }
            .section-title h2 {
                font-size: 32px;
            }
            .cta-section h2 {
                font-size: 32px;
            }
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            .features-grid {
                grid-template-columns: 1fr;
            }
            .footer-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
            .footer-section h3::after {
                left: 50%;
                transform: translateX(-50%);
            }
            .hero {
                padding: 25px;
            }
            .hero-content h1 {
                font-size: 28px;
            }
            .hero-img {
                max-width: 280px;
            }
            .features {
                padding: 40px 25px;
            }
            .cta-section {
                padding: 40px 25px;
            }
            .footer {
                padding: 40px 25px 25px;
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
        <div class="shape shape-4"></div>
        <div class="shape shape-5"></div>
    </div>

    <div class="main-container">
        <!-- Navigation -->
        <nav class="navbar">
            <div class="logo">
                <i class="fas fa-calendar-alt"></i>
                <span>EventHub</span>
            </div>
            <div class="nav-links">
                <a href="#home">Home</a>
                <a href="#features">Features</a>
                <a href="#contact">Contact</a>
            </div>
            <div class="nav-buttons">
                <a href="login.jsp" class="btn-nav btn-login">
                    <i class="fas fa-sign-in-alt"></i> Sign In
                </a>
                <a href="register.jsp" class="btn-nav btn-register">
                    <i class="fas fa-user-plus"></i> Sign Up
                </a>
            </div>
        </nav>

        <!-- Hero Section -->
        <section class="hero" id="home">
            <div class="hero-content">
                <div class="hero-badge">
                    <i class="fas fa-rocket"></i> Welcome to EventHub
                </div>
                <h1>
                    Your Ultimate <span class="gradient-text">Event Management</span> Platform
                </h1>
                <p>
                    Discover, book, and manage events seamlessly. From concerts to conferences,
                    we make event planning effortless and enjoyable.
                </p>
                <div class="hero-stats">
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Events Hosted</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">10K+</div>
                        <div class="stat-label">Happy Users</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">50+</div>
                        <div class="stat-label">Cities Covered</div>
                    </div>
                </div>
                <div class="hero-buttons">
                    <a href="register.jsp" class="btn-hero btn-hero-primary">
                        <i class="fas fa-user-plus"></i> Get Started
                    </a>
                    <a href="viewEvents" class="btn-hero btn-hero-secondary">
                        <i class="fas fa-calendar-alt"></i> Browse Events
                    </a>
                </div>
            </div>
            
            <!-- Event Management Image -->
            <div class="hero-image">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKcjTxtV2-w0HzQDKJY1SIBE2oZ0Jq0GwOpQ&s" 
                     alt="Event Management" 
                     class="hero-img">
            </div>
        </section>

        <!-- Features Section -->
        <section class="features" id="features">
            <div class="section-title">
                <h2>Why Choose EventHub?</h2>
                <p>Experience the best event management platform with powerful features</p>
            </div>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-bolt"></i>
                    </div>
                    <h3>Instant Booking</h3>
                    <p>Book your favorite events instantly with our seamless booking system</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-lock"></i>
                    </div>
                    <h3>Secure Payments</h3>
                    <p>Multiple payment options with bank-grade security encryption</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-qrcode"></i>
                    </div>
                    <h3>Digital Tickets</h3>
                    <p>Get instant digital tickets with QR codes for easy entry</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h3>Real-time Analytics</h3>
                    <p>Track your bookings and event popularity in real-time</p>
                </div>
            </div>
        </section>

        <!-- CTA Section -->
        <section class="cta-section">
            <h2>Ready to Experience Amazing Events?</h2>
            <p>Join thousands of happy users who trust EventHub for their event needs</p>
            <a href="register.jsp" class="btn-cta">
                <i class="fas fa-rocket"></i> Get Started Now
            </a>
        </section>

        <!-- Footer -->
        <footer class="footer" id="contact">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>EventHub</h3>
                    <p>Your ultimate event management platform for discovering and booking amazing events.</p>
                    <div class="social-links">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="#home">Home</a></li>
                        <li><a href="#features">Features</a></li>
                        <li><a href="login.jsp">Login</a></li>
                        <li><a href="register.jsp">Register</a></li>
                        <li><a href="viewEvents">Browse Events</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Contact Info</h3>
                    <ul>
                        <li><i class="fas fa-envelope"></i> support@eventhub.com</li>
                        <li><i class="fas fa-phone"></i> +91 98765 43210</li>
                        <li><i class="fas fa-map-marker-alt"></i> Pune, Maharashtra</li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Upcoming Events</h3>
                    <ul>
                        <li>🎵 Music Night - April 10</li>
                        <li>🎨 Art Exhibition - April 25</li>
                        <li>💻 Tech Conference - May 15</li>
                        <li>🍕 Food Festival - June 12</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 EventHub. All rights reserved. | Professional Event Management System</p>
            </div>
        </footer>
    </div>
</body>
</html>