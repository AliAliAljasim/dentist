package Helper;

public class BillingInfo {
    private int    billingId;
    private int    appointmentId;
    private double amount;

    public BillingInfo() {}

    public BillingInfo(int billingId, int appointmentId, double amount) {
        this.billingId     = billingId;
        this.appointmentId = appointmentId;
        this.amount        = amount;
    }

    public int    getBillingId()      { return billingId; }
    public int    getAppointmentId()  { return appointmentId; }
    public double getAmount()         { return amount; }

    public void setBillingId(int v)         { this.billingId = v; }
    public void setAppointmentId(int v)     { this.appointmentId = v; }
    public void setAmount(double v)         { this.amount = v; }
}
