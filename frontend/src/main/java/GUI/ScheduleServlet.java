package GUI;

import Helper.UserInfo;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Forwards appointment creation requests to appointment-service via REST.
 * Attaches the user's JWT in the Authorization header (Lab 4 Part 3).
 */
public class ScheduleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserInfo user = (UserInfo) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String date    = request.getParameter("date");
        String service = request.getParameter("service");
        double amount  = extractAmount(service);

        // Build JSON payload
        Map<String, Object> body = new HashMap<>();
        body.put("userId",  user.getUserId());
        body.put("dentistId", 0);
        body.put("date",    date);
        body.put("time",    "");
        body.put("service", service);
        body.put("amount",  amount);

        String json = new ObjectMapper().writeValueAsString(body);

        // Resolve appointment-service address (Lab 5 Part 2)
        String appointmentService = System.getenv("APPOINTMENT_SERVICE");
        if (appointmentService == null || appointmentService.isEmpty()) {
            appointmentService = "localhost:8081";
        }
        String apiUrl = "http://" + appointmentService + "/appointment-service/api/appointments/";

        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setRequestProperty("Authorization", "Bearer " + user.getToken());
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(json.getBytes("UTF-8"));
            }

            int code = conn.getResponseCode();
            if (code == 200 || code == 204) {
                response.sendRedirect("schedule.jsp?success=1");
            } else {
                response.sendRedirect("schedule.jsp?error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("schedule.jsp?error=1");
        }
    }

    private double extractAmount(String service) {
        if (service == null || service.isBlank()) {
            return 100.00;
        }

        int dollar = service.lastIndexOf('$');
        if (dollar >= 0 && dollar + 1 < service.length()) {
            String amountText = service.substring(dollar + 1).replace(",", "").trim();
            try {
                return Double.parseDouble(amountText);
            } catch (NumberFormatException ignored) {
            }
        }

        return 100.00;
    }
}
