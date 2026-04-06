package Helper;

public class AppointmentInfo {
    private int    appointmentId;
    private int    userId;
    private int    dentistId;
    private String date;
    private String time;
    private String service;
    private double amount;

    public AppointmentInfo() {}

    public int    getAppointmentId()   { return appointmentId; }
    public int    getUserId()          { return userId; }
    public int    getDentistId()       { return dentistId; }
    public String getDate()            { return date; }
    public String getTime()            { return time; }
    public String getService()         { return service; }
    public double getAmount()          { return amount; }

    public void setAppointmentId(int v)  { this.appointmentId = v; }
    public void setUserId(int v)         { this.userId = v; }
    public void setDentistId(int v)      { this.dentistId = v; }
    public void setDate(String v)        { this.date = v; }
    public void setTime(String v)        { this.time = v; }
    public void setService(String v)     { this.service = v; }
    public void setAmount(double v)      { this.amount = v; }
}
