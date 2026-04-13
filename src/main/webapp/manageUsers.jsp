<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.eventmanagement.model.User, java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<User> users = (List<User>) request.getAttribute("users");
    
    // Calculate statistics
    int totalUsers = 0;
    int adminCount = 0;
    int userCount = 0;
    
    if(users != null && !users.isEmpty()) {
        totalUsers = users.size();
        for(User u : users) {
            if("ADMIN".equals(u.getRole())) {
                adminCount++;
            } else {
                userCount++;
            }
        }
    }
    
    String todayDate = LocalDate.now().toString();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - Admin Panel | EventHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
            min-height: 100vh;
            padding: 20px;
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

        .shape-1 { width: 300px; height: 300px; top: -100px; left: -100px; animation-duration: 25s; }
        .shape-2 { width: 200px; height: 200px; bottom: -50px; right: -50px; animation-duration: 20s; animation-delay: 2s; }
        .shape-3 { width: 150px; height: 150px; top: 50%; left: 80%; animation-duration: 18s; animation-delay: 4s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-30px) rotate(10deg); }
        }

        /* Main Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.98);
            border-radius: 32px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15);
            overflow: hidden;
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
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 30px 35px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
            position: relative;
            overflow: hidden;
        }

        .header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255,255,255,0.08) 1px, transparent 1px);
            background-size: 30px 30px;
            animation: shimmer 20s linear infinite;
        }

        @keyframes shimmer {
            0% { transform: translate(0, 0); }
            100% { transform: translate(30px, 30px); }
        }

        .header-content {
            position: relative;
            z-index: 1;
        }

        .header h2 {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .header p {
            opacity: 0.9;
            font-size: 14px;
        }

        .btn-secondary {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 10px 22px;
            border-radius: 12px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            position: relative;
            z-index: 1;
            border: 1px solid rgba(255,255,255,0.3);
            font-weight: 500;
        }

        .btn-secondary:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }

        /* Stats Cards */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            padding: 25px 35px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }

        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 20px;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .stat-icon {
            width: 55px;
            height: 55px;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            color: white;
            font-size: 22px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 800;
            color: #1a202c;
        }

        .stat-label {
            font-size: 12px;
            color: #718096;
            margin-top: 5px;
            font-weight: 500;
        }

        /* Search Bar */
        .search-bar {
            padding: 20px 35px;
            background: white;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            flex: 1;
            max-width: 400px;
        }

        .search-box input {
            flex: 1;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 13px;
            font-family: inherit;
            transition: all 0.3s;
        }

        .search-box input:focus {
            outline: none;
            border-color: #2a5298;
        }

        .filter-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .filter-select {
            padding: 10px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 13px;
            font-family: inherit;
            cursor: pointer;
            background: white;
        }

        .filter-select:focus {
            outline: none;
            border-color: #2a5298;
        }

        .export-btn {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border: none;
            padding: 10px 18px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 13px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }

        .export-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40,167,69,0.3);
        }

        /* Table Container */
        .table-container {
            padding: 0 35px 35px 35px;
            overflow-x: auto;
            background: white;
        }

        .users-table {
            width: 100%;
            border-collapse: collapse;
        }

        .users-table th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #4a5568;
            font-size: 13px;
            border-bottom: 2px solid #e9ecef;
        }

        .users-table td {
            padding: 15px;
            border-bottom: 1px solid #e9ecef;
            color: #2d3748;
            font-size: 14px;
        }

        .users-table tr {
            transition: all 0.3s;
        }

        .users-table tr:hover {
            background: #f8f9fa;
        }

        .user-id {
            font-weight: 700;
            color: #2a5298;
            font-size: 14px;
        }

        .user-name {
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
            font-weight: 600;
        }

        .role-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .role-admin {
            background: #fff3cd;
            color: #856404;
        }

        .role-user {
            background: #d4edda;
            color: #155724;
        }

        .no-data {
            text-align: center;
            padding: 60px;
            color: #718096;
        }

        .no-data i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        /* Footer */
        .footer {
            text-align: center;
            padding: 20px;
            background: #f8f9fa;
            color: #718096;
            font-size: 12px;
            border-top: 1px solid #e9ecef;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                padding: 20px;
                text-align: center;
            }
            .stats-container {
                padding: 20px;
                grid-template-columns: 1fr;
            }
            .search-bar {
                padding: 20px;
                flex-direction: column;
            }
            .search-box {
                max-width: 100%;
            }
            .table-container {
                padding: 0 20px 20px 20px;
            }
            .users-table th,
            .users-table td {
                padding: 10px;
                font-size: 12px;
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
            <div class="header-content">
                <h2><i class="fas fa-users"></i> Manage Users</h2>
                <p>View and manage all registered users</p>
            </div>
            <a href="adminDashboard" class="btn-secondary">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <!-- Statistics Cards -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-value"><%= totalUsers %></div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-crown"></i>
                </div>
                <div class="stat-value"><%= adminCount %></div>
                <div class="stat-label">Admin Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-user"></i>
                </div>
                <div class="stat-value"><%= userCount %></div>
                <div class="stat-label">Regular Users</div>
            </div>
        </div>

        <!-- Search and Filters -->
        <div class="search-bar">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="🔍 Search by name, email, or user ID..." onkeyup="searchTable()">
            </div>
            <div class="filter-group">
                <select id="roleFilter" class="filter-select" onchange="filterByRole()">
                    <option value="all">All Roles</option>
                    <option value="admin">Admin</option>
                    <option value="user">User</option>
                </select>
                <button class="export-btn" onclick="exportToCSV()">
                    <i class="fas fa-download"></i> Export CSV
                </button>
            </div>
        </div>

        <div class="table-container">
            <table class="users-table" id="usersTable">
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Mobile</th>
                        <th>Role</th>
                        <th>Member Since</th>
                    </tr>
                </thead>
                <tbody id="tableBody">
                    <% if(users != null && !users.isEmpty()) { 
                        for(User u : users) { 
                    %>
                        <tr data-role="<%= u.getRole().toLowerCase() %>">
                            <td class="user-id"><%= u.getUserId() %></td>
                            <td class="user-name">
                                <span class="user-avatar"><%= u.getName().charAt(0) %></span>
                                <%= u.getName() %>
                            </td>
                            <td><%= u.getEmail() %></td>
                            <td><%= u.getMobile() != null && !u.getMobile().isEmpty() ? u.getMobile() : "-" %></td>
                            <td>
                                <span class="role-badge role-<%= u.getRole().toLowerCase() %>">
                                    <i class="fas <%= "ADMIN".equals(u.getRole()) ? "fa-crown" : "fa-user" %>"></i>
                                    <%= u.getRole() %>
                                </span>
                            </td>
                            <td><%= u.getCreatedAt() != null ? u.getCreatedAt() : "N/A" %></td>
                        </tr>
                    <% } 
                    } else { %>
                        <tr>
                            <td colspan="6" class="no-data">
                                <i class="fas fa-users-slash"></i>
                                <p>No users found.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="footer">
            <p>&copy; 2025 EventHub - Admin Panel | Total Users: <%= totalUsers %> | Last updated: <%= new java.util.Date() %></p>
        </div>
    </div>

    <script>
        function searchTable() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#tableBody tr');
            
            rows.forEach(row => {
                if (row.querySelector('.no-data')) return;
                
                const userId = row.cells[0]?.innerText.toLowerCase() || '';
                const userName = row.cells[1]?.innerText.toLowerCase() || '';
                const email = row.cells[2]?.innerText.toLowerCase() || '';
                const mobile = row.cells[3]?.innerText.toLowerCase() || '';
                
                if (userId.includes(searchTerm) || userName.includes(searchTerm) || 
                    email.includes(searchTerm) || mobile.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function filterByRole() {
            const roleFilter = document.getElementById('roleFilter').value;
            const rows = document.querySelectorAll('#tableBody tr');
            
            rows.forEach(row => {
                if (row.querySelector('.no-data')) return;
                
                const role = row.getAttribute('data-role');
                
                if (roleFilter === 'all' || role === roleFilter) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        }

        function exportToCSV() {
            const rows = [];
            const headers = ['User ID', 'Name', 'Email', 'Mobile', 'Role', 'Member Since'];
            rows.push(headers);
            
            const tableRows = document.querySelectorAll('#tableBody tr');
            tableRows.forEach(row => {
                if (row.querySelector('.no-data')) return;
                
                const rowData = [];
                for (let i = 0; i < 6; i++) {
                    let cell = row.cells[i]?.innerText.replace(/[#₹]/g, '').trim() || '';
                    rowData.push(cell);
                }
                rows.push(rowData);
            });
            
            const csvContent = rows.map(row => row.join(',')).join('\n');
            const blob = new Blob([csvContent], { type: 'text/csv' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'users_export_<%= todayDate %>.csv';
            a.click();
            URL.revokeObjectURL(url);
        }
    </script>
</body>
</html>