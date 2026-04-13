 README.md Content
markdown
# 🎪 EventHub - Complete Event Management System

![Java](https://img.shields.io/badge/Java-17%2B-orange)
![JSP](https://img.shields.io/badge/JSP-3.0-blue)
![Servlet](https://img.shields.io/badge/Servlet-6.0-red)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Tomcat](https://img.shields.io/badge/Tomcat-10.x-green)

## 📌 Project Overview

**EventHub** is a complete **Event Management System** built using **JSP, Servlet, JDBC, and MySQL**. This web application allows users to browse, book, and manage events with secure payment integration, email notifications, OTP verification, and QR code tickets.

## 🚀 Features

### 👤 User Features
- User Registration & Login
- Browse Events with Images
- Search Events by Name/Location
- Book Events with Seat Selection
- View Booking History
- Cancel Bookings
- Edit Profile
- Change Password
- Forgot Password (OTP based)

### 👑 Admin Features
- Admin Dashboard with Statistics
- Add New Events
- Manage Events (Edit/Delete)
- View All Users
- View All Bookings
- Reports & Analytics (Charts)

### 💰 Payment Features
- Card Payment
- UPI Payment
- Net Banking
- Payment Confirmation Email

### 📧 Email Features
- Booking Confirmation Email
- OTP for Password Reset
- Payment Receipt Email
- Cancellation Email

### 🎟️ Ticket Features
- Digital Ticket Generation
- QR Code for Venue Entry
- Print/Save as PDF

## 🛠️ Technology Stack

| Technology | Version |
|------------|---------|
| Java | 17+ |
| JSP | 3.0 |
| Servlet | 6.0 |
| JDBC | - |
| MySQL | 8.0+ |
| HTML5/CSS3 | - |
| JavaScript | ES6 |
| Tomcat | 10.x |
| JavaMail | 2.0 |
| Font Awesome | 6.0 |

## 🗄️ Database Schema

### Database: `event_management_system`

**Tables:** `users`, `events`, `bookings`

## 🚀 Installation Guide

### Prerequisites
- Java JDK 17+
- Apache Tomcat 10.x
- MySQL 8.0+
- Eclipse IDE

### Steps to Run

1. **Clone Repository**
```bash
git clone https://github.com/sejalkanam90/Event-Management-System.git
Import in Eclipse

File → Import → Existing Maven Projects

Create Database

sql
CREATE DATABASE event_management_system;
Update Database Connection

Open DatabaseConnection.java

Update username and password

Configure Tomcat

Add Tomcat 10.x server

Run on port 8082

Access Application

URL: http://localhost:8082/Event-Management-System/

🔐 Default Login Credentials
Admin Login
Field	Value
Email	admin@gmail.com
Password	admin123
User Login
Field	Value
Email	sejalkanam7@gmail.com
Password	Sejal@1234
📁 Project Structure
text
Event-Management-System/
├── src/main/java/com/eventmanagement/
│   ├── dao/          (Database operations)
│   ├── model/        (Entity classes)
│   ├── servlet/      (Request handlers - 20+ servlets)
│   ├── service/      (Business logic)
│   └── util/         (Utilities)
├── src/main/webapp/
│   ├── css/          (Stylesheets)
│   ├── images/       (Event images - 7)
│   ├── WEB-INF/      (Configurations)
│   └── *.jsp         (JSP pages - 25+)
└── pom.xml
📧 Email Configuration
Set environment variable:

bash
EMAIL_APP_PASSWORD = your_gmail_app_password
📱 Responsive Design
✅ Desktop

✅ Tablet

✅ Mobile

👥 Author
Sejal Kanam

Email: sejalkanam7@gmail.com

GitHub: https://github.com/SejalKanam90

📄 License
This project is for educational purposes only.

Made with ❤️ by Sejal Kanam

© 2026 EventHub. All rights reserved.

