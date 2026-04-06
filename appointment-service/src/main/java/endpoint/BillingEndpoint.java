package endpoint;

import Business.BillingManager;
import Helper.BillingInfo;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

/**
 * REST endpoint for billing records.
 *
 * GET /api/billing?userId=<id>  – get all bills for a user
 *
 * Requires Authorization: Bearer <JWT> header.
 */
@Path("/billing")
public class BillingEndpoint {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getBillingForUser(@QueryParam("userId") int userId) {
        List<BillingInfo> bills = BillingManager.getBillsForUser(userId);
        return Response.ok(bills)
                .header("Access-Control-Allow-Origin", "*")
                .build();
    }

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
