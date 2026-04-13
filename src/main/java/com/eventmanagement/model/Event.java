package com.eventmanagement.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Event {
    
    private String eventId;
    private String name;
    private String location;
    private Date eventDate;
    private int capacity;
    private int bookedSeats;
    private double pricePerSeat;
    private String description;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Default constructor
    public Event() {
    }
    
    // Parameterized constructor
    public Event(String eventId, String name, String location, Date eventDate, 
                 int capacity, int bookedSeats, double pricePerSeat) {
        this.eventId = eventId;
        this.name = name;
        this.location = location;
        this.eventDate = eventDate;
        this.capacity = capacity;
        this.bookedSeats = bookedSeats;
        this.pricePerSeat = pricePerSeat;
    }
    
    // ==================== GETTERS ====================
    
    public String getEventId() {
        return eventId;
    }
    
    public String getName() {
        return name;
    }
    
    public String getLocation() {
        return location;
    }
    
    public Date getEventDate() {
        return eventDate;
    }
    
    public int getCapacity() {
        return capacity;
    }
    
    public int getBookedSeats() {
        return bookedSeats;
    }
    
    public double getPricePerSeat() {
        return pricePerSeat;
    }
    
    public String getDescription() {
        return description;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    // Calculate available seats
    public int getAvailableSeats() {
        return capacity - bookedSeats;
    }
    
    // Calculate total revenue from this event
    public double getTotalRevenue() {
        return bookedSeats * pricePerSeat;
    }
    
    // Check if event is sold out
    public boolean isSoldOut() {
        return bookedSeats >= capacity;
    }
    
    // Check if seats are available
    public boolean hasAvailableSeats(int requestedSeats) {
        return (capacity - bookedSeats) >= requestedSeats;
    }
    
    // ==================== SETTERS ====================
    
    public void setEventId(String eventId) {
        this.eventId = eventId;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }
    
    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
    
    public void setBookedSeats(int bookedSeats) {
        this.bookedSeats = bookedSeats;
    }
    
    public void setPricePerSeat(double pricePerSeat) {
        this.pricePerSeat = pricePerSeat;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // ==================== HELPER METHODS ====================
    
    // Increase booked seats (when booking)
    public void increaseBookedSeats(int seats) {
        this.bookedSeats += seats;
    }
    
    // Decrease booked seats (when cancellation)
    public void decreaseBookedSeats(int seats) {
        this.bookedSeats -= seats;
    }
    
    // Reset booked seats (admin use)
    public void resetBookedSeats() {
        this.bookedSeats = 0;
    }
    
    // ==================== TOSTRING ====================
    
    @Override
    public String toString() {
        return "Event{" +
                "eventId='" + eventId + '\'' +
                ", name='" + name + '\'' +
                ", location='" + location + '\'' +
                ", eventDate=" + eventDate +
                ", capacity=" + capacity +
                ", bookedSeats=" + bookedSeats +
                ", availableSeats=" + getAvailableSeats() +
                ", pricePerSeat=" + pricePerSeat +
                '}';
    }
}