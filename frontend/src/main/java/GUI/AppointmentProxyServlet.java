package GUI;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Proxies appointment requests to appointment-service.
 * GET  /frontend/api/appointments         → appointment-service/api/appointments
 * GET  /frontend/api/billing?userId=...   → appointment-service/api/billing?userId=...
 */
public class AppointmentProxyServlet extends HttpServlet {

    private String getAppointmentServiceBase() {
        String s = System.getenv("APPOINTMENT_SERVICE");
        return "http://" + (s != null && !s.isEmpty() ? s : "localhost:8081") + "/appointment-service/api";
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        proxy("GET", request, response, null);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ByteArrayOutputStream buf = new ByteArrayOutputStream();
        request.getInputStream().transferTo(buf);
        proxy("POST", request, response, buf.toByteArray());
    }

    private void proxy(String method, HttpServletRequest request,
                       HttpServletResponse response, byte[] body) throws IOException {

        // Build target path from servletPath + pathInfo
        // servletPath = e.g. /api/appointments, pathInfo = e.g. /123 or null
        String servletPath = request.getServletPath();  // e.g. /api/appointments
        String pathInfo = request.getPathInfo();        // e.g. /123 or null
        // Strip leading /api to get just /appointments or /billing[/...]
        String resourcePath = servletPath.replaceFirst("^/api", "");
        if (pathInfo != null && !pathInfo.equals("/")) resourcePath += pathInfo;
        String queryString = request.getQueryString();
        String targetUrl = getAppointmentServiceBase() + resourcePath
                + (queryString != null ? "?" + queryString : "");

        HttpURLConnection conn = (HttpURLConnection) new URL(targetUrl).openConnection();
        conn.setRequestMethod(method);

        String auth = request.getHeader("Authorization");
        if (auth != null) conn.setRequestProperty("Authorization", auth);

        if (body != null && body.length > 0) {
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body);
            }
        }

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
