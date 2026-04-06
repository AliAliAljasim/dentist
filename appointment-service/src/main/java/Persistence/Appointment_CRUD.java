package Persistence;

import Helper.AppointmentInfo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Appointment_CRUD {

    public static boolean create(AppointmentInfo a) {
        try {
            Connection con = DBConnection.getConn();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO APPOINTMENT(userId, dentistId, date, time, service, amount) VALUES(?,?,?,?,?,?)");
            ps.setInt(1, a.getUserId());
            ps.setInt(2, a.getDentistId());
            ps.setString(3, a.getDate());
            ps.setString(4, a.getTime());
            ps.setString(5, a.getService());
            ps.setDouble(6, a.getAmount());
            ps.executeUpdate();
            ps.close();
            con.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static int getLastInsertedId() {
        try {
            Connection con = DBConnection.getConn();
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT MAX(appointmentId) AS id FROM APPOINTMENT");
            int id = rs.next() ? rs.getInt("id") : 0;
            rs.close(); st.close(); con.close();
            return id;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<AppointmentInfo> getAll() {
        List<AppointmentInfo> list = new ArrayList<>();
        try {
            Connection con = DBConnection.getConn();
            ResultSet rs = con.createStatement().executeQuery("SELECT * FROM APPOINTMENT");
            while (rs.next()) {
                AppointmentInfo a = new AppointmentInfo();
                a.setAppointmentId(rs.getInt("appointmentId"));
                a.setUserId(rs.getInt("userId"));
                a.setDentistId(rs.getInt("dentistId"));
                a.setDate(rs.getString("date"));
                a.setTime(rs.getString("time"));
                a.setService(rs.getString("service"));
                a.setAmount(rs.getDouble("amount"));
                list.add(a);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
