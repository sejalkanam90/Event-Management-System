package com.eventmanagement.model;

import java.sql.Timestamp;

public class Booking {
	private String bookingId;
	private String userId;
	private String eventId;
	private int seats;
	private double totalAmount;
	private Timestamp bookingDate;
	private String status;
	private String paymentStatus;
	private String paymentId;

	// Display fields
	private String eventName;
	private String userName;

	// Default constructor
	public Booking() {
	}

	// Parameterized constructor
	public Booking(String bookingId, String userId, String eventId, int seats, double totalAmount) {
		this.bookingId = bookingId;
		this.userId = userId;
		this.eventId = eventId;
		this.seats = seats;
		this.totalAmount = totalAmount;
		this.status = "CONFIRMED";
		this.bookingDate = new Timestamp(System.currentTimeMillis());
	}

	// Getters
	public String getBookingId() {
		return bookingId;
	}

	public String getUserId() {
		return userId;
	}

	public String getEventId() {
		return eventId;
	}

	public int getSeats() {
		return seats;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public Timestamp getBookingDate() {
		return bookingDate;
	}

	public String getStatus() {
		return status;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public String getPaymentId() {
		return paymentId;
	}

	public String getEventName() {
		return eventName;
	}

	public String getUserName() {
		return userName;
	}

	// Setters
	public void setBookingId(String bookingId) {
		this.bookingId = bookingId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setEventId(String eventId) {
		this.eventId = eventId;
	}

	public void setSeats(int seats) {
		this.seats = seats;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public void setBookingDate(Timestamp bookingDate) {
		this.bookingDate = bookingDate;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}

	public void setEventName(String eventName) {
		this.eventName = eventName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Override
	public String toString() {
		return "Booking{id='" + bookingId + "', event='" + eventName + "', seats=" + seats + "}";
	}
}