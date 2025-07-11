// Xử lý định tuyến yêu cầu, ví dụ gửi thông điệp đến SQS nếu hành động là process_payment.
exports.handler = async (event) => {
  try {
    const { SQS_QUEUE_URL, S3_BUCKET_NAME, AURORA_ENDPOINT, DYNAMODB_TABLE_NAME } = process.env;

    // Example: Route request based on event data
    const requestBody = JSON.parse(event.body || '{}');
    const { action, payload } = requestBody;

    // Placeholder logic for routing
    if (action === 'process_payment') {
      // Send to SQS for further processing
      const AWS = require('aws-sdk');
      const sqs = new AWS.SQS();

      await sqs.sendMessage({
        QueueUrl: SQS_QUEUE_URL,
        MessageBody: JSON.stringify(payload)
      }).promise();

      return {
        statusCode: 200,
        body: JSON.stringify({
          message: 'Request routed to processor',
          transactionId: payload.transactionId
        })
      };
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: 'Invalid action'
        })
      };
    }
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
