package com.eventmanagement.util;

import java.util.Random;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class OTPUtil {
    
    private static Map<String, String> otpMap = new ConcurrentHashMap<>();
    private static Map<String, Long> otpExpiry = new ConcurrentHashMap<>();
    private static final long EXPIRY_TIME = 300000; // 5 minutes
    
    // Generate 6-digit OTP
    public static String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
    
    // Store OTP for email
    public static void storeOTP(String email, String otp) {
        otpMap.put(email, otp);
        otpExpiry.put(email, System.currentTimeMillis() + EXPIRY_TIME);
        System.out.println("✅ OTP stored for: " + email + " -> " + otp);
    }
    
    // Validate OTP
    public static boolean validateOTP(String email, String otp) {
        if (!otpMap.containsKey(email)) {
            System.out.println("❌ OTP not found for: " + email);
            return false;
        }
        
        Long expiry = otpExpiry.get(email);
        if (expiry == null || expiry < System.currentTimeMillis()) {
            System.out.println("❌ OTP expired for: " + email);
            otpMap.remove(email);
            otpExpiry.remove(email);
            return false;
        }
        
        String storedOTP = otpMap.get(email);
        if (storedOTP != null && storedOTP.equals(otp)) {
            System.out.println("✅ OTP validated for: " + email);
            return true;
        }
        
        System.out.println("❌ Invalid OTP for: " + email);
        return false;
    }
    
    // Remove OTP after use
    public static void removeOTP(String email) {
        otpMap.remove(email);
        otpExpiry.remove(email);
        System.out.println("🗑️ OTP removed for: " + email);
    }
}