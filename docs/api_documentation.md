API Documentation
Overview
The API is served via AWS API Gateway, secured with Cognito authentication and WAF protection. It integrates with ECS for core banking services and Lambda for additional processing.
Endpoints
1. Health Check

Endpoint: GET /health
Description: Checks the health of the banking API.
Response:{
  "status": "healthy"
}


Authentication: None

2. Payment Processing

Endpoint: POST /payments
Description: Processes a payment transaction.
Authentication: Cognito JWT token
Request Body:{
  "amount": 100.00,
  "currency": "USD",
  "recipient": "account123"
}


Response:{
  "transactionId": "txn_123456",
  "status": "success"
}



3. Transaction History

Endpoint: GET /transactions
Description: Retrieves transaction history for a user.
Authentication: Cognito JWT token
Query Parameters:
userId: User identifier
limit: Number of transactions (default: 10)


Response:[
  {
    "transactionId": "txn_123456",
    "amount": 100.00,
    "currency": "USD",
    "date": "2025-07-11T12:00:00Z"
  }
]



Authentication

Obtain a JWT token from Cognito user pool.
Include token in the Authorization header: Bearer <token>.

Error Codes

400 Bad Request: Invalid request parameters.
401 Unauthorized: Invalid or missing JWT token.
403 Forbidden: Access denied by WAF or Cognito.
500 Internal Server Error: Server-side issue, check CloudWatch logs.

Testing

Use tools like Postman or curl to test endpoints.
Example curl command:curl -H "Authorization: Bearer <token>" https://<api-gateway-url>/payments -d '{"amount": 100.00, "currency": "USD", "recipient": "account123"}'



