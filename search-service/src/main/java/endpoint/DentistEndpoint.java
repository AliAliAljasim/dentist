package endpoint;

import Business.DentistManager;
import Helper.DentistInfo;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

/**
 * REST endpoint for the Dentist Search Microservice.
 *
 * GET /api/dentists?name=Dr+Smith        – search by name
 * GET /api/dentists?specialty=Ortho      – search by specialty
 *
 * Requires Authorization: Bearer <JWT> header (enforced by JWTFilter).
 */
@Path("/dentists")
public class DentistEndpoint {

    private final DentistManager manager = new DentistManager();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response searchDentists(
            @QueryParam("name")      String name,
            @QueryParam("specialty") String specialty) {

        List<DentistInfo> results;

        if (specialty != null && !specialty.isEmpty()) {
            System.out.println("Searching dentists by specialty: " + specialty);
            results = manager.searchBySpecialty(specialty);
        } else {
            System.out.println("Searching dentists by name: " + name);
            results = manager.searchByName(name == null ? "" : name);
        }

        return Response.ok(results).header("Access-Control-Allow-Origin", "*").build();
    }

    /** CORS pre-flight support */
    @OPTIONS
    @Path("{path: .*}")
    public Response options() {
        return Response.ok()
                .header("Access-Control-Allow-Origin", "*")
                .header("Access-Control-Allow-Methods", "GET, OPTIONS")
                .header("Access-Control-Allow-Headers", "Authorization, Content-Type")
                .build();
    }
}
