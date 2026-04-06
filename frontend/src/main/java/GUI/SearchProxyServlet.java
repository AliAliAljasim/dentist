package GUI;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Proxies dentist search requests to search-service.
 * Browser calls /frontend/api/search/dentists?name=...
 * This servlet forwards to http://search-service:8080/search-service/api/dentists?name=...
 */
public class SearchProxyServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchService = System.getenv("SEARCH_SERVICE");
        if (searchService == null || searchService.isEmpty()) searchService = "localhost:8082";

        String queryString = request.getQueryString();
        String targetUrl = "http://" + searchService + "/search-service/api/dentists"
                + (queryString != null ? "?" + queryString : "");

        HttpURLConnection conn = (HttpURLConnection) new URL(targetUrl).openConnection();
        conn.setRequestMethod("GET");

        // Forward JWT from browser request
        String auth = request.getHeader("Authorization");
        if (auth != null) conn.setRequestProperty("Authorization", auth);

        response.setContentType("application/json");
        response.setHeader("Access-Control-Allow-Origin", "*");

        int status = conn.getResponseCode();
        response.setStatus(status);

        InputStream is = (status < 400) ? conn.getInputStream() : conn.getErrorStream();
        if (is != null) {
            try (OutputStream os = response.getOutputStream()) {
                is.transferTo(os);
            }
        }
    }
}
