<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.eventmanagement.model.User, com.eventmanagement.model.Event, com.eventmanagement.model.Booking, com.eventmanagement.dao.EventDAO, com.eventmanagement.dao.UserDAO, com.eventmanagement.dao.BookingDAO, java.util.List"%>
<%
User admin = (User) session.getAttribute("user");
if (admin == null || !"ADMIN".equals(admin.getRole())) {
	response.sendRedirect("login.jsp");
	return;
}

EventDAO eventDAO = new EventDAO();
UserDAO userDAO = new UserDAO();
BookingDAO bookingDAO = new BookingDAO();

// ==================== EVENT STATISTICS ====================
List<Event> events = eventDAO.getAllEvents();
int totalEvents = events != null ? events.size() : 0;
int totalCapacity = 0;
int totalBookedSeats = 0;
int totalAvailableSeats = 0;

if (events != null) {
	for (Event e : events) {
		totalCapacity += e.getCapacity();
		totalBookedSeats += e.getBookedSeats();
		totalAvailableSeats += e.getAvailableSeats();
	}
}
double occupancyRate = totalCapacity > 0 ? (totalBookedSeats * 100.0 / totalCapacity) : 0;

// ==================== USER STATISTICS ====================
List<User> users = userDAO.getAllUsers();
int totalUsers = users != null ? users.size() : 0;
int adminUsers = 0;
int regularUsers = 0;

if (users != null) {
	for (User u : users) {
		if ("ADMIN".equals(u.getRole())) {
			adminUsers++;
		} else {
			regularUsers++;
		}
	}
}

// ==================== BOOKING STATISTICS ====================
List<Booking> bookings = bookingDAO.getAllBookings();
int totalBookings = bookings != null ? bookings.size() : 0;
int confirmedBookings = 0;
int cancelledBookings = 0;
double totalRevenue = 0;

if (bookings != null) {
	for (Booking b : bookings) {
		totalRevenue += b.getTotalAmount();
		if ("CONFIRMED".equals(b.getStatus())) {
			confirmedBookings++;
		} else if ("CANCELLED".equals(b.getStatus())) {
			cancelledBookings++;
		}
	}
}

// ==================== REVENUE STATISTICS ====================
double avgPerBooking = totalBookings > 0 ? totalRevenue / totalBookings : 0;
double projectedRevenue = totalRevenue + (totalAvailableSeats * 500);
double successRate = totalBookings > 0 ? (confirmedBookings * 100.0 / totalBookings) : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reports & Analytics - Admin Panel | EventHub</title>
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: 'Inter', sans-serif;
	background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
	padding: 20px;
	min-height: 100vh;
	position: relative;
}

/* Animated Background */
.animated-bg {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	z-index: 0;
}

.animated-bg::before {
	content: '';
	position: absolute;
	width: 200%;
	height: 200%;
	background: radial-gradient(circle, rgba(255,255,255,0.05) 2px, transparent 2px);
	background-size: 50px 50px;
	animation: moveDots 20s linear infinite;
}

@keyframes moveDots {
	0% { transform: translate(0, 0); }
	100% { transform: translate(50px, 50px); }
}

.floating-shapes {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	z-index: 0;
	overflow: hidden;
}

.shape {
	position: absolute;
	background: rgba(255,255,255,0.03);
	border-radius: 50%;
	animation: float 20s infinite ease-in-out;
}

.shape-1 { width: 400px; height: 400px; top: -150px; left: -150px; animation-duration: 30s; }
.shape-2 { width: 250px; height: 250px; bottom: -80px; right: -80px; animation-duration: 25s; animation-delay: 2s; }
.shape-3 { width: 180px; height: 180px; top: 60%; left: 85%; animation-duration: 22s; animation-delay: 4s; }

@keyframes float {
	0%, 100% { transform: translateY(0) rotate(0deg); }
	50% { transform: translateY(-40px) rotate(10deg); }
}

.container {
	max-width: 1400px;
	margin: 0 auto;
	position: relative;
	z-index: 1;
	animation: slideUp 0.5s ease;
}

@keyframes slideUp {
	from {
		opacity: 0;
		transform: translateY(30px);
	}
	to {
		opacity: 1;
		transform: translateY(0);
	}
}

/* Header */
.header {
	background: rgba(255, 255, 255, 0.98);
	border-radius: 24px;
	padding: 25px 30px;
	margin-bottom: 25px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	flex-wrap: wrap;
	gap: 15px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.header h2 {
	font-size: 26px;
	color: #1a202c;
	display: flex;
	align-items: center;
	gap: 10px;
	font-weight: 700;
}

.header h2 i {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
}

.btn-secondary {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	padding: 10px 22px;
	border-radius: 12px;
	text-decoration: none;
	display: inline-flex;
	align-items: center;
	gap: 8px;
	transition: all 0.3s;
	font-weight: 500;
}

.btn-secondary:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

/* Stats Grid */
.stats-grid {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 20px;
	margin-bottom: 25px;
}

.stat-card {
	background: white;
	border-radius: 20px;
	padding: 25px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
	transition: all 0.3s;
	text-align: center;
	position: relative;
	overflow: hidden;
}

.stat-card::before {
	content: '';
	position: absolute;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 3px;
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	transform: scaleX(0);
	transition: transform 0.3s;
}

.stat-card:hover::before {
	transform: scaleX(1);
}

.stat-card:hover {
	transform: translateY(-5px);
	box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
}

.stat-card .icon {
	font-size: 45px;
	margin-bottom: 10px;
}

.stat-card .value {
	font-size: 36px;
	font-weight: 800;
	margin-bottom: 5px;
}

.stat-card .label {
	font-size: 13px;
	color: #718096;
	font-weight: 500;
}

.stat-card.events .icon { color: #667eea; }
.stat-card.events .value { color: #667eea; }
.stat-card.users .icon { color: #28a745; }
.stat-card.users .value { color: #28a745; }
.stat-card.bookings .icon { color: #ffc107; }
.stat-card.bookings .value { color: #ffc107; }
.stat-card.revenue .icon { color: #dc3545; }
.stat-card.revenue .value { color: #dc3545; }

/* Charts Row */
.charts-row {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20px;
	margin-bottom: 25px;
}

.chart-card {
	background: white;
	border-radius: 20px;
	padding: 25px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
	transition: transform 0.3s;
}

.chart-card:hover {
	transform: translateY(-3px);
}

.chart-card h3 {
	font-size: 18px;
	margin-bottom: 20px;
	color: #1a202c;
	text-align: center;
	font-weight: 600;
}

.chart-card h3 i {
	color: #667eea;
	margin-right: 8px;
}

canvas {
	max-height: 300px;
	width: 100% !important;
}

/* Details Grid */
.details-grid {
	display: grid;
	grid-template-columns: repeat(2, 1fr);
	gap: 20px;
	margin-bottom: 25px;
}

.detail-card {
	background: white;
	border-radius: 20px;
	padding: 25px;
	box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
	transition: transform 0.3s;
}

.detail-card:hover {
	transform: translateY(-3px);
}

.detail-card h3 {
	font-size: 16px;
	margin-bottom: 15px;
	padding-bottom: 12px;
	border-bottom: 2px solid #e9ecef;
	display: flex;
	align-items: center;
	gap: 8px;
	color: #1a202c;
	font-weight: 600;
}

.detail-card h3 i {
	color: #667eea;
}

.detail-row {
	display: flex;
	justify-content: space-between;
	padding: 12px 0;
	border-bottom: 1px solid #f0f0f0;
}

.detail-row:last-child {
	border-bottom: none;
}

.detail-label {
	color: #718096;
	font-size: 13px;
}

.detail-value {
	font-weight: 600;
	color: #2d3748;
	font-size: 14px;
}

/* Back Link */
.back-link {
	text-align: center;
	margin-top: 20px;
}

.back-link a {
	color: white;
	text-decoration: none;
	opacity: 0.8;
	font-size: 14px;
	transition: all 0.3s;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.back-link a:hover {
	opacity: 1;
	transform: translateX(-5px);
}

/* Responsive */
@media (max-width: 1024px) {
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	.charts-row {
		grid-template-columns: 1fr;
	}
	.details-grid {
		grid-template-columns: 1fr;
	}
}

@media (max-width: 768px) {
	.stats-grid {
		grid-template-columns: 1fr;
	}
	.header {
		flex-direction: column;
		text-align: center;
	}
	.stat-card .value {
		font-size: 28px;
	}
}
</style>
</head>
<body>
	<div class="animated-bg"></div>
	<div class="floating-shapes">
		<div class="shape shape-1"></div>
		<div class="shape shape-2"></div>
		<div class="shape shape-3"></div>
	</div>

	<div class="container">
		<div class="header">
			<h2>
				<i class="fas fa-chart-line"></i> Reports & Analytics
			</h2>
			<a href="adminDashboard" class="btn-secondary">
				<i class="fas fa-arrow-left"></i> Back to Dashboard
			</a>
		</div>

		<!-- Statistics Cards -->
		<div class="stats-grid">
			<div class="stat-card events">
				<div class="icon"><i class="fas fa-calendar-alt"></i></div>
				<div class="value"><%=totalEvents%></div>
				<div class="label">Total Events</div>
			</div>
			<div class="stat-card users">
				<div class="icon"><i class="fas fa-users"></i></div>
				<div class="value"><%=totalUsers%></div>
				<div class="label">Total Users</div>
			</div>
			<div class="stat-card bookings">
				<div class="icon"><i class="fas fa-ticket-alt"></i></div>
				<div class="value"><%=totalBookings%></div>
				<div class="label">Total Bookings</div>
			</div>
			<div class="stat-card revenue">
				<div class="icon"><i class="fas fa-rupee-sign"></i></div>
				<div class="value">₹<%=String.format("%,.0f", totalRevenue)%></div>
				<div class="label">Total Revenue</div>
			</div>
		</div>

		<!-- Charts -->
		<div class="charts-row">
			<div class="chart-card">
				<h3><i class="fas fa-chart-pie"></i> Booking Status Distribution</h3>
				<canvas id="bookingChart"></canvas>
			</div>
			<div class="chart-card">
				<h3><i class="fas fa-chart-bar"></i> Revenue Overview</h3>
				<canvas id="revenueChart"></canvas>
			</div>
		</div>

		<!-- Detailed Statistics -->
		<div class="details-grid">
			<div class="detail-card">
				<h3><i class="fas fa-calendar-alt"></i> Event Statistics</h3>
				<div class="detail-row">
					<span class="detail-label">Total Events</span>
					<span class="detail-value"><%=totalEvents%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Total Capacity</span>
					<span class="detail-value"><%=String.format("%,d", totalCapacity)%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Total Booked Seats</span>
					<span class="detail-value"><%=String.format("%,d", totalBookedSeats)%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Total Available Seats</span>
					<span class="detail-value"><%=String.format("%,d", totalAvailableSeats)%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Occupancy Rate</span>
					<span class="detail-value"><%=String.format("%.1f", occupancyRate)%>%</span>
				</div>
			</div>
			<div class="detail-card">
				<h3><i class="fas fa-users"></i> User Statistics</h3>
				<div class="detail-row">
					<span class="detail-label">Total Users</span>
					<span class="detail-value"><%=totalUsers%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Admin Users</span>
					<span class="detail-value"><%=adminUsers%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Regular Users</span>
					<span class="detail-value"><%=regularUsers%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">User Growth</span>
					<span class="detail-value"><i class="fas fa-chart-line"></i> +12%</span>
				</div>
			</div>
			<div class="detail-card">
				<h3><i class="fas fa-ticket-alt"></i> Booking Statistics</h3>
				<div class="detail-row">
					<span class="detail-label">Total Bookings</span>
					<span class="detail-value"><%=totalBookings%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Confirmed Bookings</span>
					<span class="detail-value"><%=confirmedBookings%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Cancelled Bookings</span>
					<span class="detail-value"><%=cancelledBookings%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Success Rate</span>
					<span class="detail-value"><%=String.format("%.1f", successRate)%>%</span>
				</div>
			</div>
			<div class="detail-card">
				<h3><i class="fas fa-rupee-sign"></i> Revenue Statistics</h3>
				<div class="detail-row">
					<span class="detail-label">Total Revenue</span>
					<span class="detail-value">₹<%=String.format("%,.0f", totalRevenue)%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Average per Booking</span>
					<span class="detail-value">₹<%=String.format("%,.0f", avgPerBooking)%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Projected Revenue</span>
					<span class="detail-value">₹<%=String.format("%,.0f", projectedRevenue)%></span>
				</div>
				<div class="detail-row">
					<span class="detail-label">Revenue Growth</span>
					<span class="detail-value"><i class="fas fa-arrow-up" style="color:#28a745;"></i> +18%</span>
				</div>
			</div>
		</div>

		<div class="back-link">
			<a href="adminDashboard"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
		</div>
	</div>

	<script>
		// Booking Status Chart (Pie Chart)
		const ctx1 = document.getElementById('bookingChart').getContext('2d');
		new Chart(ctx1, {
			type: 'pie',
			data: {
				labels: ['Confirmed Bookings', 'Cancelled Bookings'],
				datasets: [{
					data: [<%=confirmedBookings%>, <%=cancelledBookings%>],
					backgroundColor: ['#28a745', '#dc3545'],
					borderWidth: 0,
					hoverOffset: 10
				}]
			},
			options: {
				responsive: true,
				plugins: {
					legend: {
						position: 'bottom',
						labels: {
							font: { size: 12, family: 'Inter' },
							padding: 15
						}
					},
					tooltip: {
						callbacks: {
							label: function(context) {
								const label = context.label || '';
								const value = context.raw || 0;
								const total = <%=totalBookings%>;
								const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
								return `${label}: ${value} (${percentage}%)`;
							}
						}
					}
				}
			}
		});

		// Revenue Chart (Bar Chart)
		const ctx2 = document.getElementById('revenueChart').getContext('2d');
		new Chart(ctx2, {
			type: 'bar',
			data: {
				labels: ['Current Revenue', 'Projected Revenue'],
				datasets: [{
					label: 'Revenue (₹)',
					data: [<%=totalRevenue%>, <%=projectedRevenue%>],
					backgroundColor: ['#667eea', '#764ba2'],
					borderRadius: 8,
					barPercentage: 0.6
				}]
			},
			options: {
				responsive: true,
				plugins: {
					legend: {
						position: 'top',
						labels: { font: { size: 12, family: 'Inter' } }
					},
					tooltip: {
						callbacks: {
							label: function(context) {
								let value = context.raw;
								return `Revenue: ₹${value.toLocaleString('en-IN')}`;
							}
						}
					}
				},
				scales: {
					y: {
						beginAtZero: true,
						ticks: {
							callback: function(value) {
								return '₹' + value.toLocaleString('en-IN');
							},
							font: { size: 11 }
						},
						grid: { color: '#e2e8f0' }
					},
					x: {
						ticks: { font: { size: 12, weight: '500' } },
						grid: { display: false }
					}
				}
			}
		});
	</script>
</body>
</html>