package backend.rfid.iot;

import lombok.Data;

@Data
public class RfidRequest {
    private String tagId;
    private String readerId;
    private long timestamp;
}
