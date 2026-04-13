package com.eventmanagement.util;

public class IdGenerator {
    private static int eventCounter = 1;
    private static int userCounter = 1;
    private static int bookingCounter = 1;
    private static int paymentCounter = 1;
    
    public static synchronized String nextEventId() {
        return "E" + (eventCounter++);
    }
    
    public static synchronized String nextUserId() {
        return "U" + (userCounter++);
    }
    
    public static synchronized String nextBookingId() {
        return "B" + (bookingCounter++);
    }
    
    public static synchronized String nextPaymentId() {
        return "P" + (paymentCounter++);
    }
}