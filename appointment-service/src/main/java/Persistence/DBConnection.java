package Persistence;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Connects to Appointment_Dental_DB.
 * Tables: APPOINTMENT, BILLING
 * Lab 5 Part 2: DB_URL env var replaces localhost:3306.
 */
public class DBConnection {

    public static Connection getConn() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbUrl = System.getenv("DB_URL");
            if (dbUrl == null || dbUrl.isEmpty()) dbUrl = "localhost:3306";
            return DriverManager.getConnection(
                "jdbc:mysql://" + dbUrl + "/Appointment_Dental_DB" +
                "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC",
                "root", "student");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
