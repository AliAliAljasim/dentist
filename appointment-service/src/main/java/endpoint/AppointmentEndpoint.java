package endpoint;

import Business.SchedulingManager;
import Helper.AppointmentInfo;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

/**
 * REST endpoint for appointments.
 *
 * GET  /api/appointments           – list all appointments
 * POST /api/appointments           – create a new appointment (triggers async billing)
 *
 * Requires Authorization: Bearer <JWT> header.
 */
@Path("/appointments")
public class AppointmentEndpoint {

    private final SchedulingManager manager = new SchedulingManager();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAppointments() {
        List<AppointmentInfo> list = manager.getAppointments();
        return Response.ok(list)
                .header("Access-Control-Allow-Origin", "*")
                .build();
    }

    @POST
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response createAppointment(AppointmentInfo info) {
        manager.createAppointment(info);
        return Response.ok("{\"status\":\"created\"}")
                .header("Access-Control-Allow-Origin", "*")
                .build();
    }

    @OPTIONS
    @Path("{path: .*}")
    public Response options() {
        return Response.ok()
                .header("Access-Control-Allow-Origin", "*")
                .header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
                .header("Access-Control-Allow-Headers", "Authorization, Content-Type")
                .build();
    }
}
