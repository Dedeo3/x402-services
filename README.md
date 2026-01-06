# Payroute API Documentation

This API provides services for registering creators, managing wrapped content, and processing payments (x402) for content access.

## Base URL

`/` (Root where the server is deployed, typically `http://localhost:3000`)

---

## Creator Endpoints

### 1. Register Creator

Registers a new creator by their wallet address.

- **URL**: `/creator/register`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "walletAddress": "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"
  }
  ```
- **Response**:
  - `200 OK`: Returns the created creator object.
  - `400 Bad Request`: Missing wallet address.
  - `409 Conflict`: Creator already exists.

### 2. Get Creator Profile

Retrieves a creator's profile by their ID.

- **URL**: `/creator/:id`
- **Method**: `GET`
- **URL Parameters**:
  - `id` (integer): The ID of the creator.
- **Response**:
  - `200 OK`: Returns the creator profile.
  - `500 Internal Server Error`

### 3. Get All Creators

Retrieves a list of all registered creators.

- **URL**: `/creator/`
- **Method**: `GET`
- **Response**:
  - `200 OK`: Returns an array of creator objects.
  - `500 Internal Server Error`

---

## Wrapped Data Endpoints

### 4. Create Wrapped Content

Creates a new wrapped content entry (gateway) for a creator.

- **URL**: `/creator/wrapped/:creatorId`
- **Method**: `POST`
- **URL Parameters**:
  - `creatorId` (integer): The ID of the creator.
- **Request Body**:
  ```json
  {
    "originalUrl": "https://api.example.com/premium-data",
    "methods": "GET,POST",
    "gatewaySlug": "my-premium-api",
    "paymentAmount": 1.5,
    "paymentReceipt": "0x742d35Cc6634C0532925a3b844Bc454e4438f44e",
    "description": "Access to premium market data"
  }
  ```
- **Response**:
  - `201 Created`: Returns success message and new URL.
  - `400 Bad Request`: Missing required fields.
  - `500 Internal Server Error`

### 5. Get Wrapped Data

Retrieves all wrapped methods for a specific creator.

- **URL**: `/creator/wrapped/:idCreator`
- **Method**: `GET`
- **URL Parameters**:
  - `idCreator` (integer): The ID of the creator.
- **Response**:
  - `200 OK`: Returns an array of wrapped data objects.
  - `404 Not Found`: No data found.
  - `500 Internal Server Error`

---

## Payroute (Gateway) Endpoints

### 6. Escrow Gateway Access

Accesses the wrapped content via the Escrow flow. This endpoint verifies payments made through the Escrow smart contract.

- **URL**: `/escrow/:gatewaySlug`
- **Method**: `GET` / `POST` / `...` (Matches `originalUrl` method)
- **URL Parameters**:
  - `gatewaySlug` (string): The slug defined when creating wrapped content.
- **Headers**:
  - `x-payment-tx` (string, optional): The transaction hash of the payment made to the Escrow contract's `createTx` function.
- **Response**:
  - `200 OK`: Proxies the response from the `originalUrl`.
  - `402 Payment Required`: If `x-payment-tx` is missing or invalid. Returns details needed to initiate the escrow payment interactively.
    ```json
    {
      "message": "Payment Required",
      "receiverAddress": "0xCreatorWalletAddress...",
      "transactionId": "0xdbTxHash...",
      "escrowAddress": "0xEscrowContractAddress...",
      "amount": 1.5,
      "currency": "MUSD",
      "chain": "MANTLE TESTNET",
      "requiredHeader": "x-payment-tx"
    }
    ```
  - `404 Not Found`: Gateway slug or Transaction not found.
  - `500 Internal Server Error`: Server configuration or upstream errors.

### 7. Direct Gateway Access

Accesses the wrapped content via Direct Payment flow. This endpoint verifies direct ERC20 transfers to the creator's wallet.

- **URL**: `/:gatewaySlug`
- **Method**: `GET` / `POST` / `...` (Matches `originalUrl` method)
- **URL Parameters**:
  - `gatewaySlug` (string): The slug defined when creating wrapped content.
- **Headers**:
  - `x-payment-tx` (string, optional): The transaction hash of the direct ERC20 transfer to the creator's wallet.
- **Response**:
  - `200 OK`: Proxies the response from the `originalUrl`.
  - `402 Payment Required`: If `x-payment-tx` is missing or invalid.
    ```json
    {
      "message": "Payment Required",
      "receiverAddress": "0xCreatorWalletAddress...",
      "transactionId": "0xdbTxHash...",
      "escrowAddress": "0xEscrowContractAddress...",
      "amount": 1.5,
      "currency": "MUSD",
      "chain": "MANTLE TESTNET",
      "requiredHeader": "x-payment-tx"
    }
    ```
  - `404 Not Found`: Gateway slug not found.
  - `500 Internal Server Error`

---

## Agent Management Endpoints

### 8. Create AI Agent

Creates a new independent AI agent for a creator.

- **URL**: `/creator/:creatorId/agents`
- **Method**: `POST`
- **URL Parameters**:
  - `creatorId` (integer): The ID of the creator.
- **Request Body**:
  ```json
  {
    "name": "Coding Assistant",
    "slug": "coding-assistant-v1",
    "description": "An AI agent specialized in writing Python code.",
    "modelProvider": "openai",
    "modelName": "gpt-4",
    "systemPrompt": "You are a helpful coding assistant.",
    "pricePerHit": 0.5,
    "isActive": true
  }
  ```
- **Response**:
  - `201 Created`: Returns the created agent.
  - `400 Bad Request`: Missing fields.
  - `409 Conflict`: Slug already exists.

### 9. List Creator Agents

Retrieves all AI agents owned by a creator.

- **URL**: `/creator/:creatorId/agents`
- **Method**: `GET`
- **URL Parameters**:
  - `creatorId` (integer): The ID of the creator.
- **Response**:
  - `200 OK`: Returns list of agents.

### 10. Get Agent Details

Retrieves details of a specific AI agent, including attached resources (if implemented).

- **URL**: `/agent/:agentId`
- **Method**: `GET`
- **URL Parameters**:
  - `agentId` (uuid): The ID of the AI Agent.
- **Response**:
  - `200 OK`: Returns agent details.
  - `404 Not Found`: Agent not found.

### 11. Create Agent Resource

Creates a new resource (Text, Link, or Smart Contract) for a creator.

- **URL**: `/creator/:creatorId/resources`
- **Method**: `POST`
- **URL Parameters**:
  - `creatorId` (integer): The ID of the creator.
- **Request Body**:
  ```json
  {
    "type": "TEXT",
    "title": "API Documentation",
    "content": "This is the documentation content...",
    "metadata": { "version": "1.0", "language": "en" }
  }
  ```
- **Response**:
  - `201 Created`: Returns the created resource.
  - `400 Bad Request`: Missing required fields.

### 12. List Creator Resources

Retrieves all resources created by a specific creator.

- **URL**: `/creator/:creatorId/resources`
- **Method**: `GET`
- **URL Parameters**:
  - `creatorId` (integer): The ID of the creator.
- **Response**:
  - `200 OK`: Returns list of resources.

### 13. Attach Resource to Agent

Links an existing resource to an AI Agent.

- **URL**: `/agent/:agentId/resources`
- **Method**: `POST`
- **URL Parameters**:
  - `agentId` (uuid): The ID of the AI Agent.
- **Request Body**:
  ```json
  {
    "resourceId": "550e8400-e29b-41d4-a716-446655440000"
  }
  ```
- **Response**:
  - `201 Created`: Returns linkage info.
  - `409 Conflict`: Resource already attached.

### 14. View Agent Resources

Retrieves all resources currently attached to a specific AI Agent.

- **URL**: `/agent/:agentId/resources`
- **Method**: `GET`
- **URL Parameters**:
  - `agentId` (uuid): The ID of the AI Agent.
- **Response**:
  - `200 OK`: Returns list of attached resources.

### 15. Detach Resource from Agent

Removes the link between a resource and an AI Agent.

- **URL**: `/agent/:agentId/resources/:resourceId`
- **Method**: `DELETE`
- **URL Parameters**:
  - `agentId` (uuid): The ID of the AI Agent.
  - `resourceId` (uuid): The ID of the Resource.
- **Response**:
  - `200 OK`: Resource detached.
  - `404 Not Found`: Linkage not found.

### 16. Chat with AI Agent (Paid)

Interacts with an AI Agent. If a `pricePerHit` is set, payment must be made via the Escrow contract before the chat is processed.

- **URL**: `/agent/:agentId/chat`
- **Method**: `POST`
- **URL Parameters**:
  - `agentId` (uuid): The ID of the AI Agent.
- **Headers**:
  - `x-payment-tx` (string, optional): The transaction hash of the payment made to the Escrow contract. Required if the agent has a price.
- **Request Body**:
  ```json
  {
    "message": "How do I implement a bubble sort in Python?"
  }
  ```
- **Response**:
  - `200 OK`: Returns the AI's response.
    ```json
    {
      "response": "Here is how you implement bubble sort..."
    }
    ```
  - `402 Payment Required`: If `x-payment-tx` is missing/invalid and the agent is not free.
    ```json
    {
      "message": "Payment Required",
      "receiverAddress": "0xCreatorWallet...",
      "transactionId": "0xdbTxHash...",
      "escrowAddress": "0xEscrowContract...",
      "amount": 0.5,
      "currency": "MUSD",
      "chain": "MANTLE TESTNET",
      "requiredHeader": "x-payment-tx"
    }
    ```
  - `404 Not Found`: Agent not found.
  - `500 Internal Server Error`: AI processing failed or server error.
