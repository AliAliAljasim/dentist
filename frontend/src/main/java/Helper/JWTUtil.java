package Helper;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;

import java.security.Key;
import java.util.Date;

/**
 * Lab 4 Part 3 - JWT Authentication Utility.
 *
 * Generates and validates JSON Web Tokens.
 * The secret is read from the JWT_SECRET environment variable so it can be
 * shared across all microservices in the Kubernetes cluster.
 */
public class JWTUtil {

    private static final long EXPIRATION_MS = 24 * 60 * 60 * 1000; // 24 hours

    private static Key getKey() {
        String secret = System.getenv("JWT_SECRET");
        if (secret == null || secret.isEmpty()) {
            secret = "dental-system-secret-key-2026-coe692";
        }
        return Keys.hmacShaKeyFor(secret.getBytes());
    }

    /** Generate a signed JWT token for the given username. */
    public static String generateToken(String username) {
        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_MS))
                .signWith(getKey(), SignatureAlgorithm.HS256)
                .compact();
    }

    /** Validate token; returns true if valid and not expired. */
    public static boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(getKey()).build().parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /** Extract username (subject) from a valid token. */
    public static String getUsernameFromToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject();
    }
}
