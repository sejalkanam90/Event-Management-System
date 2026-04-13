package com.eventmanagement.model;

import java.sql.Date;

public class Event {
	private String eventId;
	private String name;
	private String location;
	private Date eventDate;
	private int capacity;
	private int bookedSeats;
	private double pricePerSeat; // Add this field
	private String description; // Optional

	public Event() {
	}

	public Event(String eventId, String name, String location, Date eventDate, int capacity, double pricePerSeat) {
		this.eventId = eventId;
		this.name = name;
		this.location = location;
		this.eventDate = eventDate;
		this.capacity = capacity;
		this.bookedSeats = 0;
		this.pricePerSeat = pricePerSeat;
	}

	// Getters and Setters
	public String getEventId() {
		return eventId;
	}

	public void setEventId(String eventId) {
		this.eventId = eventId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public Date getEventDate() {
		return eventDate;
	}

	public void setEventDate(Date eventDate) {
		this.eventDate = eventDate;
	}

	public int getCapacity() {
		return capacity;
	}

	public void setCapacity(int capacity) {
		this.capacity = capacity;
	}

	public int getBookedSeats() {
		return bookedSeats;
	}

	public void setBookedSeats(int bookedSeats) {
		this.bookedSeats = bookedSeats;
	}

	public double getPricePerSeat() {
		return pricePerSeat;
	}

	public void setPricePerSeat(double pricePerSeat) {
		this.pricePerSeat = pricePerSeat;
	} // Add this

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getAvailableSeats() {
		return capacity - bookedSeats;
	}
}