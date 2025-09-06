# backend-rfid-iot 🛰️
A backend service for handling RFID tap events and persisting them into DynamoDB.

## 📖 Overview

This project is built with **Java (Gradle)** and integrates with **AWS DynamoDB**.  
It is designed to capture RFID events via a Lambda-style handler and store them in a table called **`rfid-log-table`**.

### 🔑 Components

- **TapHandler** ⚡  
  - AWS Lambda request handler (`RequestHandler<RfidRequest, String>`)  
  - Writes new RFID tap events into DynamoDB.

- **RfidRequest** 📦  
  - Represents the incoming payload.  
  - Fields:
    - `tagId` 🆔 – the RFID tag identifier  
    - `readerId` 📡 – the reader device identifier  
    - `timestamp` ⏱️ (long) – event timestamp in epoch milliseconds  

- **DynamoDB Table: `rfid-log-table`** 🗄️  
  - Partition key: `TagId` (String)  
  - Sort key: `CreatedAtEpoch` (Number)  

## 🧪 Running Tests

The project includes unit tests for the handler (`TapHandlerTest`) which run against a local DynamoDB instance.

```bash
docker compose up -d # This will run the DynamoDB local
chmod 777 -R ./docker # Permission for the DynamoDB volume
AWS_ENDPOINT_URL=http://<local-ip>:8000 ./gradlew test -i
````

The `AWS_ENDPOINT_URL` environment variable is used to point the code to DynamoDB Local during tests.

## ☁️ Infrastructure (Terraform)
Infrastructure is managed via **Terraform**. The project supports deploying either to AWS or to a local DynamoDB instance depending on the configuration.

### 🔧 Providers
```hcl
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "local"
  region = "us-east-1"
  endpoints {
    dynamodb = var.endpoint_url
  }
}
```

### 📦 Table Module
The `dynamodb-table` module is reused for both local and AWS environments.
Terraform decides which provider to use based on whether `endpoint_url` is set.
```hcl
module "dynamodb_table" {
  count  = var.endpoint_url != "" ? 0 : 1
  source = "./modules/dynamodb-table"
  providers = {
    aws = aws
  }
}

module "dynamodb_table_local" {
  count  = var.endpoint_url != "" ? 1 : 0
  source = "./modules/dynamodb-table"
  providers = {
    aws = aws.local
  }
}
```

### 🌍 Switching Environments

* **AWS (default):**

  ```bash
  terraform apply
  ```

* **Local DynamoDB:**
  Set `endpoint_url` in `terraform.tfvars`:

  ```hcl
  endpoint_url = "http://<local-ip>:8000"
  ```

  Then run:

  ```bash
  terraform apply
  ```

---

## 🛠️ Development Notes
* ⚙️ Gradle is used for building and testing.
* ✨ Lombok is included for boilerplate reduction.
* 📚 AWS SDK v1 for Java is used for DynamoDB integration.
* ✅ The test suite ensures integration against DynamoDB Local.

---

## 🚀 Quickstart
1. Clone the repository

   ```bash
   git clone https://github.com/your-username/backend-rfid-iot.git
   cd backend-rfid-iot
   ```

2. Run tests against DynamoDB Local

   ```bash
   docker compose up -d
   chmod 777 -R ./docker
   AWS_ENDPOINT_URL=http://localhost:8000 ./gradlew test -i
   ```

3. Deploy infrastructure with Terraform

   * For AWS:

     ```bash
     terraform apply
     ```
   * For local DynamoDB:

     ```bash
     echo 'endpoint_url = "http://localhost:8000"' > terraform.tfvars
     terraform apply
     ```
