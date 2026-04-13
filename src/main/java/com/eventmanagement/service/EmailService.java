package com.eventmanagement.service;

import jakarta.mail.*;
import jakarta.mail.internet.*;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailService {

    private static final String SENDER_EMAIL = "sejalkanam7@gmail.com";
    private static final String PASSWORD = System.getenv("EMAIL_APP_PASSWORD");
    
    // ==================== BOOKING CONFIRMATION EMAIL ====================
    
    public static void sendBookingConfirmationEmail(String toEmail, String userName, 
                                                     String eventName, String location,
                                                     String date, int seats, double amount, 
                                                     String bookingId) {
        
        System.out.println("📧 Sending booking confirmation to: " + toEmail);
        
        if (PASSWORD == null || PASSWORD.isEmpty()) {
            System.out.println("Email not configured! Would have sent to: " + toEmail);
            printBookingEmailToConsole(toEmail, userName, eventName, location, date, seats, amount, bookingId);
            return;
        }
        
        String subject = "🎉 Booking Confirmed - " + eventName;
        
        String message = "Dear " + userName + ",\n\n" +
                        "Your booking has been successfully confirmed!\n\n" +
                        "Event Details:\n" +
                        "-------------------------\n" +
                        "Event Name: " + eventName + "\n" +
                        "Location: " + location + "\n" +
                        "Date: " + date + "\n" +
                        "Seats: " + seats + "\n" +
                        "Total Amount: ₹" + amount + "\n\n" +
                        "Booking ID: " + bookingId + "\n\n" +
                        "Thank you for choosing EventHub!\n\n" +
                        "Regards,\nEvent Management Team";
        
        sendEmail(toEmail, subject, message);
    }
    
    // ==================== OTP EMAIL ====================
    
    public static boolean sendOTPEmail(String toEmail, String userName, String otp) {
        
        System.out.println("📧 Sending OTP email to: " + toEmail);
        System.out.println("🔢 OTP: " + otp);
        
        if (PASSWORD == null || PASSWORD.isEmpty()) {
            System.out.println("Email not configured! OTP: " + otp);
            printOTPEmailToConsole(toEmail, userName, otp);
            return true;
        }
        
        String subject = "🔐 Password Reset OTP - EventHub";
        
        String message = "Dear " + userName + ",\n\n" +
                        "Your OTP for password reset is:\n\n" +
                        "🔢 OTP: " + otp + "\n\n" +
                        "This OTP is valid for 5 minutes.\n\n" +
                        "If you didn't request this, please ignore this email.\n\n" +
                        "Regards,\nEventHub Team";
        
        return sendEmailWithReturn(toEmail, subject, message);
    }
    
    // ==================== PASSWORD RESET EMAIL ====================
    
    public static void sendPasswordResetEmail(String toEmail, String userName, String resetLink) {
        
        System.out.println("📧 Sending password reset email to: " + toEmail);
        System.out.println("🔗 Reset Link: " + resetLink);
        
        if (PASSWORD == null || PASSWORD.isEmpty()) {
            System.out.println("Email not configured! Reset link: " + resetLink);
            printResetEmailToConsole(toEmail, userName, resetLink);
            return;
        }
        
        String subject = "🔐 Password Reset Request - EventHub";
        
        String message = "Dear " + userName + ",\n\n" +
                        "We received a request to reset your password.\n\n" +
                        "Click the link below to reset your password:\n" +
                        resetLink + "\n\n" +
                        "This link will expire in 1 hour.\n\n" +
                        "If you didn't request this, please ignore this email.\n\n" +
                        "Regards,\nEventHub Team";
        
        sendEmail(toEmail, subject, message);
    }
    
    // ==================== PAYMENT CONFIRMATION EMAIL ====================
    
    public static void sendPaymentConfirmationEmail(String toEmail, String userName,
                                                    String bookingId, double amount,
                                                    String paymentId) {
        
        System.out.println("📧 Sending payment confirmation to: " + toEmail);
        
        if (PASSWORD == null || PASSWORD.isEmpty()) {
            System.out.println("Email not configured! Would have sent to: " + toEmail);
            return;
        }
        
        String subject = "💰 Payment Confirmation - Booking ID: " + bookingId;
        
        String message = "Dear " + userName + ",\n\n" +
                        "Your payment has been successfully processed.\n\n" +
                        "Payment Details:\n" +
                        "-------------------------\n" +
                        "Payment ID: " + paymentId + "\n" +
                        "Booking ID: " + bookingId + "\n" +
                        "Amount: ₹" + amount + "\n" +
                        "Status: SUCCESS\n\n" +
                        "Thank you for your payment!\n\n" +
                        "Regards,\nEventHub Team";
        
        sendEmail(toEmail, subject, message);
    }
    
    // ==================== BOOKING CANCELLATION EMAIL ====================
    
    public static void sendCancellationEmail(String toEmail, String userName,
                                            String bookingId, String eventName) {
        
        System.out.println("📧 Sending cancellation email to: " + toEmail);
        
        if (PASSWORD == null || PASSWORD.isEmpty()) {
            System.out.println("Email not configured! Would have sent to: " + toEmail);
            return;
        }
        
        String subject = "Booking Cancelled - " + bookingId;
        
        String message = "Dear " + userName + ",\n\n" +
                        "Your booking has been cancelled successfully.\n\n" +
                        "Cancellation Details:\n" +
                        "-------------------------\n" +
                        "Booking ID: " + bookingId + "\n" +
                        "Event: " + eventName + "\n" +
                        "Status: CANCELLED\n\n" +
                        "If you have any questions, please contact support.\n\n" +
                        "Regards,\nEventHub Team";
        
        sendEmail(toEmail, subject, message);
    }
    
    // ==================== CORE EMAIL SENDING METHODS ====================
    
    private static void sendEmail(String to, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, PASSWORD);
                }
            });
            
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SENDER_EMAIL, "EventHub Support"));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            msg.setSubject(subject);
            msg.setText(body);
            
            Transport.send(msg);
            System.out.println("Email sent successfully to: " + to);
            
        } catch (Exception e) {
            System.out.println("Email failed to: " + to);
            System.out.println("Error: " + e.getMessage());
        }
    }
    
    private static boolean sendEmailWithReturn(String to, String subject, String body) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SENDER_EMAIL, PASSWORD);
                }
            });
            
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SENDER_EMAIL, "EventHub Support"));
            msg.setRecipient(Message.RecipientType.TO, new InternetAddress(to));
            msg.setSubject(subject);
            msg.setText(body);
            
            Transport.send(msg);
            System.out.println("Email sent successfully to: " + to);
            return true;
            
        } catch (Exception e) {
            System.out.println("Email failed to: " + to);
            System.out.println("Error: " + e.getMessage());
            return false;
        }
    }
    
    // ==================== CONSOLE PRINT METHODS (FOR TESTING) ====================
    
    private static void printBookingEmailToConsole(String toEmail, String userName, String eventName,
                                                   String location, String date, int seats, 
                                                   double amount, String bookingId) {
        System.out.println("\n📧 ========== BOOKING CONFIRMATION EMAIL ==========");
        System.out.println("To: " + toEmail);
        System.out.println("User: " + userName);
        System.out.println("Event: " + eventName);
        System.out.println("Location: " + location);
        System.out.println("Date: " + date);
        System.out.println("Seats: " + seats);
        System.out.println("Amount: ₹" + amount);
        System.out.println("Booking ID: " + bookingId);
        System.out.println("==================================================\n");
    }
    
    private static void printResetEmailToConsole(String toEmail, String userName, String resetLink) {
        System.out.println("\n📧 ========== PASSWORD RESET EMAIL ==========");
        System.out.println("To: " + toEmail);
        System.out.println("User: " + userName);
        System.out.println("Reset Link: " + resetLink);
        System.out.println("=============================================\n");
    }
    
    private static void printOTPEmailToConsole(String toEmail, String userName, String otp) {
        System.out.println("\n📧 ========== OTP EMAIL ==========");
        System.out.println("To: " + toEmail);
        System.out.println("User: " + userName);
        System.out.println("OTP: " + otp);
        System.out.println("=================================\n");
    }
    
    // ==================== TEST METHOD ====================
    
    public static void testEmailConfig() {
        System.out.println("=== Email Configuration Test ===");
        System.out.println("Sender Email: " + SENDER_EMAIL);
        System.out.println("Password configured: " + (PASSWORD != null && !PASSWORD.isEmpty()));
        
        if (PASSWORD != null && !PASSWORD.isEmpty()) {
            System.out.println("Password length: " + PASSWORD.length() + " characters");
        } else {
            System.out.println("WARNING: EMAIL_APP_PASSWORD environment variable not set!");
            System.out.println("Email will not be sent, will print to console instead.");
        }
    }
}