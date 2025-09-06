package backend.rfid.iot;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.client.builder.AwsClientBuilder;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class TapHandler implements RequestHandler<RfidRequest, String> {

    @Override
    public String handleRequest(RfidRequest requestData, Context context) {
        final DynamoDB dynamoDB = getDynamoDB();

        final Table table = dynamoDB.getTable("rfid-log-table");
        final Item item = new Item();
        item.withString("TagId", requestData.getTagId());
        item.withString("ReaderId", requestData.getReaderId());
        item.withLong("CreatedAtEpoch", requestData.getTimestamp());
        table.putItem(item);

        return "UID " + requestData.getTagId() + " received at " + requestData.getTimestamp();
    }

    private AmazonDynamoDB buildClient() {
        final String endpointUrl = System.getenv("AWS_ENDPOINT_URL");
        final String region = Regions.US_EAST_1.name();
        final AmazonDynamoDBClientBuilder builder = AmazonDynamoDBClientBuilder.standard()
                .withClientConfiguration(new ClientConfiguration());
        return (endpointUrl == null || endpointUrl.isBlank())
                ? builder.withRegion(region).build()
                : builder.withEndpointConfiguration(new AwsClientBuilder.EndpointConfiguration(endpointUrl, region))
                        .build();
    }

    private DynamoDB getDynamoDB() {
        return new DynamoDB(buildClient());
    }

}
