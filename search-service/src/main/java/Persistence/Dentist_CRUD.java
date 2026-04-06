package Persistence;

import Helper.DentistInfo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Searches Search_Dental_DB for dentists by name or specialty.
 * Uses a JOIN across DENTIST, DENTIST_SPECIALTY, SPECIALTY tables.
 */
public class Dentist_CRUD {

    public List<DentistInfo> searchByName(String name) {
        List<DentistInfo> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConn();
            String query =
                "SELECT d.id, d.name, d.clinic, s.name AS specialty " +
                "FROM DENTIST d " +
                "LEFT JOIN DENTIST_SPECIALTY ds ON d.id = ds.dentistId " +
                "LEFT JOIN SPECIALTY s ON ds.specialtyId = s.id " +
                "WHERE d.name LIKE ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, "%" + name + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DentistInfo d = new DentistInfo();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setClinic(rs.getString("clinic"));
                d.setSpecialty(rs.getString("specialty"));
                list.add(d);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DentistInfo> searchBySpecialty(String specialty) {
        List<DentistInfo> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConn();
            String query =
                "SELECT d.id, d.name, d.clinic, s.name AS specialty " +
                "FROM DENTIST d " +
                "JOIN DENTIST_SPECIALTY ds ON d.id = ds.dentistId " +
                "JOIN SPECIALTY s ON ds.specialtyId = s.id " +
                "WHERE s.name LIKE ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, "%" + specialty + "%");
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                DentistInfo d = new DentistInfo();
                d.setId(rs.getInt("id"));
                d.setName(rs.getString("name"));
                d.setClinic(rs.getString("clinic"));
                d.setSpecialty(rs.getString("specialty"));
                list.add(d);
            }
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
