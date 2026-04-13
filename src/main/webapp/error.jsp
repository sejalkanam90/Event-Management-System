<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="error-message">
            <h2>Error Occurred</h2>
            <p><%= request.getAttribute("error") != null ? request.getAttribute("error") : "Something went wrong!" %></p>
            <a href="dashboard.jsp" class="btn btn-primary">Go to Dashboard</a>
            <a href="index.jsp" class="btn btn-secondary">Home</a>
        </div>
    </div>
</body>
</html>