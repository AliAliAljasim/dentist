package endpoint;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import java.security.Key;

/** Shared JWT validation logic (mirrors the one in frontend). */
public class JWTUtil {

    private static Key getKey() {
        String secret = System.getenv("JWT_SECRET");
        if (secret == null || secret.isEmpty()) secret = "dental-system-secret-key-2026-coe692";
        return Keys.hmacShaKeyFor(secret.getBytes());
    }

    public static boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(getKey()).build().parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }
}
