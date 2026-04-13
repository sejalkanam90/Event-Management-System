package com.eventmanagement.model;

import java.sql.Timestamp;

public class User {
	private String userId;
	private String name;
	private String email;
	private String mobile;
	private String password;
	private String role;
	private Timestamp createdAt;

	// Default constructor
	public User() {
		this.role = "USER";
	}

	
	public User(String userId, String name, String email, String mobile, String password) {
		this.userId = userId;
		this.name = name;
		this.email = email;
		this.mobile = mobile;
		this.password = password;
		this.role = "USER";
	}

	// Getters
	public String getUserId() {
		return userId;
	}

	public String getName() {
		return name;
	}

	public String getEmail() {
		return email;
	}

	public String getMobile() {
		return mobile;
	}

	public String getPassword() {
		return password;
	}

	public String getRole() {
		return role;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	// Setters
	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	// Helper method
	public boolean isAdmin() {
		return "ADMIN".equals(role);
	}

	@Override
	public String toString() {
		return userId + ": " + name + " | " + email + " | " + role;
	}
}