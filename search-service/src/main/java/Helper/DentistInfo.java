package Helper;

public class DentistInfo {
    private int id;
    private String name;
    private String clinic;
    private String specialty; // from SPECIALTY table via JOIN

    public DentistInfo() {}

    public int    getId()        { return id; }
    public String getName()      { return name; }
    public String getClinic()    { return clinic; }
    public String getSpecialty() { return specialty; }

    public void setId(int id)              { this.id = id; }
    public void setName(String name)       { this.name = name; }
    public void setClinic(String clinic)   { this.clinic = clinic; }
    public void setSpecialty(String s)     { this.specialty = s; }
}
