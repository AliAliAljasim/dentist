package Business;

import Helper.AppointmentInfo;
import Persistence.Appointment_CRUD;
import Persistence.Billing_CRUD;
import java.util.List;

/**
 * Business layer for appointment scheduling.
 * After a successful insert, publishes a KubeMQ message so the billing
 * subscriber can create the billing record asynchronously (Lab 5 Part 1).
 */
public class SchedulingManager {

    public void createAppointment(AppointmentInfo a) {
        schedule(a);
    }

    public static boolean schedule(AppointmentInfo a) {
        boolean success = Appointment_CRUD.create(a);
        if (success) {
            try {
                int id = Appointment_CRUD.getLastInsertedId();
                double amount = getBillingAmount(a.getService(), a.getAmount());
                // Always persist the correct invoice amount first.
                Billing_CRUD.insertIfMissing(id, amount);
                // Lab 5 Part 1: async billing via KubeMQ
                Messaging.sendmessage("APPT:" + id + ":" + String.format(java.util.Locale.US, "%.2f", amount));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return success;
    }

    public List<AppointmentInfo> getAppointments() {
        return new Appointment_CRUD().getAll();
    }

    private static double getBillingAmount(String service) {
        return getBillingAmount(service, 0);
    }

    private static double getBillingAmount(String service, double explicitAmount) {
        if (explicitAmount > 0) {
            return explicitAmount;
        }

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
