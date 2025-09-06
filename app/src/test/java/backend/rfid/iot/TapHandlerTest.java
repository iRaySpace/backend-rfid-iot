package backend.rfid.iot;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import com.amazonaws.services.lambda.runtime.Context;

public class TapHandlerTest {

    @Test
    public void testHandleRequest() {
        final TapHandler tapHandler = new TapHandler();

        final RfidRequest requestData = new RfidRequest();
        requestData.setTagId("ABC123");
        requestData.setReaderId("Reader01");
        requestData.setTimestamp(System.currentTimeMillis());

        final Context mockContext = Mockito.mock(Context.class);
        final String response = tapHandler.handleRequest(requestData, mockContext);

        assertEquals("UID ABC123 received at " + requestData.getTimestamp(), response);
    }
}
