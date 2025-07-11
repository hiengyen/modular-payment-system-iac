// Xử lý thông điệp từ SQS, lưu giao dịch vào DynamoDB và S3.
exports.handler = async (event) => {
  try {
    const { SQS_QUEUE_URL, S3_BUCKET_NAME, AURORA_ENDPOINT, DYNAMODB_TABLE_NAME } = process.env;

    // Example: Process SQS message
    for (const record of event.Records) {
      const payload = JSON.parse(record.body);

      // Placeholder logic for processing payment
      const AWS = require('aws-sdk');
      const dynamodb = new AWS.DynamoDB.DocumentClient();

      await dynamodb.put({
        TableName: DYNAMODB_TABLE_NAME,
        Item: {
          transactionId: payload.transactionId,
          amount: payload.amount,
          currency: payload.currency,
          recipient: payload.recipient,
          timestamp: new Date().toISOString()
        }
      }).promise();

      // Placeholder: Save to S3
      const s3 = new AWS.S3();
      await s3.putObject({
        Bucket: S3_BUCKET_NAME,
        Key: `transactions/${payload.transactionId}.json`,
        Body: JSON.stringify(payload)
      }).promise();
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: 'Transaction processed successfully'
      })
    };
  } catch (error) {
    console.error('Error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: 'Internal server error'
      })
    };
  }
};
