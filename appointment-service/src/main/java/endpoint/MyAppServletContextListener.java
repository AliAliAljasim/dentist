package endpoint;

import io.kubemq.sdk.basic.ServerAddressNotSuppliedException;
import io.kubemq.sdk.event.EventReceive;
import io.kubemq.sdk.event.Subscriber;
import io.kubemq.sdk.subscription.EventsStoreType;
import io.kubemq.sdk.subscription.SubscribeRequest;
import io.kubemq.sdk.subscription.SubscribeType;
import io.kubemq.sdk.tools.Converter;
import io.grpc.stub.StreamObserver;

import javax.net.ssl.SSLException;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Lab 5 Part 1 – KubeMQ subscriber (receiver side).
 *
 * Starts on application startup and listens on "appointment_channel".
 * When a message APPT:<appointmentId>:<amount> arrives, it inserts a
 * billing record into Appointment_Dental_DB.BILLING.
 *
 * Registered in web.xml via <listener>.
 */
public class MyAppServletContextListener implements ServletContextListener {

    private static final Logger logger =
            Logger.getLogger(MyAppServletContextListener.class.getName());

    @Override
    public void contextDestroyed(ServletContextEvent e) {
        System.out.println("Appointment service context destroyed.");
    }

    @Override
    public void contextInitialized(ServletContextEvent e) {
        Runnable r = () -> {
            try {
                Receiving_Events_Store("appointment_channel");
            } catch (SSLException | ServerAddressNotSuppliedException ex) {
                logger.log(Level.SEVERE, null, ex);
            }
        };
        new Thread(r).start();
    }

    public static void Receiving_Events_Store(String cname)
            throws SSLException, ServerAddressNotSuppliedException {

        String kubeMQAddress = System.getenv("kubeMQAddress");
        Subscriber subscriber = new Subscriber(kubeMQAddress);

        SubscribeRequest req = new SubscribeRequest();
        req.setChannel(cname);
        req.setClientID("billing-receiver");
        req.setSubscribeType(SubscribeType.EventsStore);
        req.setEventsStoreType(EventsStoreType.StartAtSequence);
        req.setEventsStoreTypeValue(1);

        StreamObserver<EventReceive> observer = new StreamObserver<EventReceive>() {
            @Override
            public void onNext(EventReceive value) {
                try {
                    String msg = (String) Converter.FromByteArray(value.getBody());
                    System.out.println("Billing receiver got: " + msg);

                    String[] parts = msg.split(":");
                    if (parts.length == 3 && "APPT".equals(parts[0])) {
                        int    appointmentId = Integer.parseInt(parts[1]);
                        double amount        = Double.parseDouble(parts[2]);
                        Persistence.Billing_CRUD.insertIfMissing(appointmentId, amount);
                        System.out.println("Billing inserted for appointment " + appointmentId);
                    }
                } catch (ClassNotFoundException | java.io.IOException ex) {
                    logger.log(Level.SEVERE, null, ex);
                }
            }

            @Override
            public void onError(Throwable t) {
                System.out.printf("KubeMQ onError: %s%n", t.getMessage());
            }

            @Override
            public void onCompleted() {}
        };

        subscriber.SubscribeToEvents(req, observer);
    }
}
