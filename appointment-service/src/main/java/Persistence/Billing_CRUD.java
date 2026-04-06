package Persistence;

import Helper.BillingInfo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Billing_CRUD {

    public static void insert(int appointmentId, double amount) {
        insertIfMissing(appointmentId, amount);
    }

    public static void insertIfMissing(int appointmentId, double amount) {
        try {
            Connection con = DBConnection.getConn();
            PreparedStatement check = con.prepareStatement(
                "SELECT billingId FROM BILLING WHERE appointmentId = ?");
            check.setInt(1, appointmentId);
            ResultSet rs = check.executeQuery();
            Integer billingId = rs.next() ? rs.getInt("billingId") : null;
            rs.close();
            check.close();

            if (billingId == null) {
                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO BILLING(appointmentId, amount) VALUES(?,?)");
                ps.setInt(1, appointmentId);
                ps.setDouble(2, amount);
                ps.executeUpdate();
                ps.close();
            } else {
                PreparedStatement ps = con.prepareStatement(
                    "UPDATE BILLING SET amount = ? WHERE billingId = ?");
                ps.setDouble(1, amount);
                ps.setInt(2, billingId);
                ps.executeUpdate();
                ps.close();
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static List<BillingInfo> readAllForUser(int userId) {
        List<BillingInfo> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConn();
            PreparedStatement ps = con.prepareStatement(
                "SELECT b.billingId, b.appointmentId, b.amount " +
                "FROM BILLING b " +
                "JOIN APPOINTMENT a ON b.appointmentId = a.appointmentId " +
                "WHERE a.userId = ?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new BillingInfo(
                    rs.getInt("billingId"),
                    rs.getInt("appointmentId"),
                    rs.getDouble("amount")));
            }
            rs.close(); ps.close(); con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
