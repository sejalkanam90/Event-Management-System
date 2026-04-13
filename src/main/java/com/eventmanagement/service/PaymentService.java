package com.eventmanagement.service;

import com.eventmanagement.model.Payment;
import java.util.Random;

public class PaymentService {
    
    private Random random = new Random();
    
    public Payment processPayment(double amount, String paymentMethod) {
        System.out.println("💳 Processing payment of ₹" + amount + " via " + paymentMethod);
        
        // Simulate payment processing delay
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        // 95% success rate
        boolean success = random.nextInt(100) < 95;
        String paymentId = "PAY" + System.currentTimeMillis();
        
        Payment payment = new Payment();
        payment.setPaymentId(paymentId);
        payment.setAmount(amount);
        payment.setSuccess(success);
        payment.setStatus(success ? "SUCCESS" : "FAILED");
        payment.setPaymentMethod(paymentMethod);
        
        if (success) {
            System.out.println("Payment successful! ID: " + paymentId);
        } else {
            System.out.println("Payment failed!");
        }
        
        return payment;
    }
}