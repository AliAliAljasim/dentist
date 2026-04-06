package Helper;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class BillingInfo {
    private int billingId;
    private int appointmentId;
    private double amount;

    public BillingInfo() {}

    public BillingInfo(int billingId, int appointmentId, double amount) {
        this.billingId     = billingId;
        this.appointmentId = appointmentId;
        this.amount        = amount;
    }

    public int getBillingId()      { return billingId; }
    public int getAppointmentId()  { return appointmentId; }
    public double getAmount()      { return amount; }

    public void setBillingId(int billingId)          { this.billingId = billingId; }
    public void setAppointmentId(int appointmentId)  { this.appointmentId = appointmentId; }
    public void setAmount(double amount)             { this.amount = amount; }
}
