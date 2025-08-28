package backend.rfid.iot;

import lombok.Data;

@Data
public class RfidRequest {
    private String uid;
    private String readerId;
    private long timestamp;
}
