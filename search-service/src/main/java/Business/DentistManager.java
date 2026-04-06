package Business;

import Helper.DentistInfo;
import Persistence.Dentist_CRUD;
import java.util.List;

/**
 * Business logic for the Dentist Search Microservice.
 * Delegates to the persistence layer and returns results to the endpoint.
 */
public class DentistManager {

    private final Dentist_CRUD crud = new Dentist_CRUD();

    /** Search by dentist name (default). */
    public List<DentistInfo> searchByName(String name) {
        return crud.searchByName(name);
    }

    /** Search by specialty (e.g. "Orthodontics", "General Dentistry"). */
    public List<DentistInfo> searchBySpecialty(String specialty) {
        return crud.searchBySpecialty(specialty);
    }
}
