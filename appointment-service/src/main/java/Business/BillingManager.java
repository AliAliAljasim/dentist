package Business;

import Helper.BillingInfo;
import Persistence.Billing_CRUD;
import java.util.List;

public class BillingManager {

    public static List<BillingInfo> getBillsForUser(int userId) {
        return Billing_CRUD.readAllForUser(userId);
    }
}
