package Helper;

public class UserInfo {
    private int userId;
    private String username;
    private String token; // JWT token issued at login

    public UserInfo(int userId, String username) {
        this.userId = userId;
        this.username = username;
    }

    public int getUserId()      { return userId; }
    public String getUsername() { return username; }
    public String getToken()    { return token; }
    public void setToken(String token) { this.token = token; }
}
