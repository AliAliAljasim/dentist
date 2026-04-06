package GUI;

import Helper.BillingInfo;
import Helper.UserInfo;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Collections;
import java.util.List;

/**
 * Fetches billing records for the logged-in user from appointment-service.
 * Passes the JWT token in the Authorization header (Lab 4 Part 3).
 */
public class BillingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserInfo user = (UserInfo) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Resolve appointment-service address (Lab 5 Part 2)
        String appointmentService = System.getenv("APPOINTMENT_SERVICE");
        if (appointmentService == null || appointmentService.isEmpty()) {
            appointmentService = "localhost:8081";
        }
        String apiUrl = "http://" + appointmentService +
                "/appointment-service/api/billing?userId=" + user.getUserId();

        List<BillingInfo> bills = Collections.emptyList();
        try {
            HttpURLConnection conn = (HttpURLConnection) new URL(apiUrl).openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + user.getToken());

            if (conn.getResponseCode() == 200) {
                try (InputStream is = conn.getInputStream()) {
                    bills = new ObjectMapper().readValue(is,
                            new TypeReference<List<BillingInfo>>() {});
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("bills", bills);
        request.getRequestDispatcher("billing.jsp").forward(request, response);
    }
}
