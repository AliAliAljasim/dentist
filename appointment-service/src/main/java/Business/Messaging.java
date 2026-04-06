package Business;

import io.kubemq.sdk.basic.ServerAddressNotSuppliedException;
import io.kubemq.sdk.event.Channel;
import io.kubemq.sdk.event.Event;
import io.kubemq.sdk.tools.Converter;

import javax.net.ssl.SSLException;
import java.io.IOException;

/**
 * Lab 5 Part 1 – KubeMQ sender.
 * Published to "appointment_channel" after an appointment is created.
 * MyAppServletContextListener subscribes and inserts the billing record.
 */
public class Messaging {

    public static void sendmessage(String message) throws IOException {
        String channelName   = "appointment_channel";
        String clientID      = "appointment-publisher";
        String kubeMQAddress = System.getenv("kubeMQAddress");

        try {
            Channel channel = new Channel(channelName, clientID, false, kubeMQAddress);
            channel.setStore(true);

            Event event = new Event();
            event.setBody(Converter.ToByteArray(message));
            event.setEventId("event-Store-");

            channel.SendEvent(event);
        } catch (SSLException e) {
            System.out.printf("SSLException: %s%n", e.getMessage());
            e.printStackTrace();
        } catch (ServerAddressNotSuppliedException e) {
            System.out.printf("ServerAddressNotSuppliedException: %s%n", e.getMessage());
            e.printStackTrace();
        }
    }
}
