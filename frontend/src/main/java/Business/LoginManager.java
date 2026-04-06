package Business;

import Helper.JWTUtil;
import Helper.UserInfo;
import Persistence.User_CRUD;

public class LoginManager {

    /**
     * Validates credentials. On success, generates a JWT and attaches it to
     * the returned UserInfo so it can be stored in the HTTP session.
     */
    public static UserInfo login(String username, String password) {
        UserInfo user = User_CRUD.read(username, password);
        if (user != null) {
            String token = JWTUtil.generateToken(username);
            user.setToken(token);
        }
        return user;
    }
}
