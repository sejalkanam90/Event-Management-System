package com.eventmanagement.dao;

import java.sql.*;

public class DatabaseConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/event_management_system";
    private static final String USER = "root";
    private static final String PASS = "Sejal@28";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}