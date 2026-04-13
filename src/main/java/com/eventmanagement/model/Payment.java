package com.eventmanagement.model;

public class Payment {
	private String paymentId;
	private String bookingId;
	private double amount;
	private boolean success;
	private String status;
	private String paymentMethod;

	public Payment() {
	}

	public Payment(String paymentId, String bookingId, double amount, boolean success) {
		this.paymentId = paymentId;
		this.bookingId = bookingId;
		this.amount = amount;
		this.success = success;
		this.status = success ? "SUCCESS" : "FAILED";
	}

	// Getters
	public String getPaymentId() {
		return paymentId;
	}

	public String getBookingId() {
		return bookingId;
	}

	public double getAmount() {
		return amount;
	}

	public boolean isSuccess() {
		return success;
	}

	public String getStatus() {
		return status;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	// Setters
	public void setPaymentId(String paymentId) {
		this.paymentId = paymentId;
	}

	public void setBookingId(String bookingId) {
		this.bookingId = bookingId;
	}

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public void setSuccess(boolean success) {
		this.success = success;
		this.status = success ? "SUCCESS" : "FAILED";
	}

	public void setStatus(String status) {
		this.status = status;
		this.success = "SUCCESS".equals(status);
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	@Override
	public String toString() {
		return "Payment{id='" + paymentId + "', amount=" + amount + ", status=" + status + "}";
	}
}