package com.eventmanagement.servlet;

import com.eventmanagement.dao.BookingDAO;

import com.eventmanagement.dao.EventDAO;
import com.eventmanagement.dao.UserDAO;
import com.eventmanagement.model.Booking;
import com.eventmanagement.model.Event;
import com.eventmanagement.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/adminDashboard")
public class AdminDashboardServlet extends HttpServlet {

	private EventDAO eventDAO = new EventDAO();
	private UserDAO userDAO = new UserDAO();
	private BookingDAO bookingDAO = new BookingDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User user = (User) session.getAttribute("user");

		if (user == null) {
			response.sendRedirect("login.jsp");
			return;
		}

		// Only ADMIN role allowed
		if (user.getRole() == null || !"ADMIN".equals(user.getRole())) {
			response.sendRedirect("userDashboard");
			return;
		}

		try {
			// Get total events
			List<Event> events = eventDAO.getAllEvents();
			int totalEvents = events != null ? events.size() : 0;

			// Get total users
			List<User> users = userDAO.getAllUsers();
			int totalUsers = users != null ? users.size() : 0;

			// Get total bookings and revenue
			List<Booking> bookings = bookingDAO.getAllBookings();
			int totalBookings = bookings != null ? bookings.size() : 0;
			double totalRevenue = 0;
			if (bookings != null) {
				for (Booking b : bookings) {
					totalRevenue += b.getTotalAmount();
				}
			}

			request.setAttribute("totalEvents", totalEvents);
			request.setAttribute("totalUsers", totalUsers);
			request.setAttribute("totalBookings", totalBookings);
			request.setAttribute("totalRevenue", totalRevenue);

			request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);

		} catch (SQLException e) {
			e.printStackTrace();
			request.setAttribute("error", "Error loading dashboard: " + e.getMessage());
			request.getRequestDispatcher("error.jsp").forward(request, response);
		}
	}
}