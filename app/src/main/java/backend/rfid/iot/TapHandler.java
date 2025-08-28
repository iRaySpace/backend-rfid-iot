package backend.rfid.iot;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class TapHandler implements RequestHandler<RfidRequest, String> {

    @Override
    public String handleRequest(RfidRequest requestData, Context context) {
        context.getLogger().log("Received UID: " + requestData.getUid());
        return "UID " + requestData.getUid() + " received at " + requestData.getTimestamp();
    }

}
