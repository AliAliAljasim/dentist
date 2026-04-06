package Persistence;

import Helper.UserInfo;
import java.sql.*;

public class User_CRUD {

    public static UserInfo read(String username, String password) {
        try {
            Connection con = DBConnection.getConn();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM User WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserInfo(rs.getInt("id"), rs.getString("username"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
