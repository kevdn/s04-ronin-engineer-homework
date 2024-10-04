# HW02

## Description
This is a simple project implementing a simple cache using read-aside cache stratetis for airport information. The cache is implemented using Guava's `LoadingCache`. The cache is configured to expire after 5 minutes.

## Technologies Used
- Java 17
- Spring Boot 3.3.4
- Maven
- Lombok
- Guava

## Getting Started

### Prerequisites
- Java 17
- Maven

### Installation
1. Clone the repository:
    ```sh
    git clone https://github.com/kevdn/HW02.git
    cd HW02
    ```

2. Build the project:
    ```sh
    mvn clean install
    ```

3. Run the application:
    ```sh
    mvn spring-boot:run
    ```

### API Endpoints

#### Get Airport by Code
- **URL:** `/airports/{code}`
- **Method:** `GET`
- **Response:** Returns the airport information for the given code.

### Example Requests
You can use the `generated-requests.http` file to test the API endpoints. Here are some examples:

#### Get Airport by Code
```http
GET http://localhost:8080/airports/{code}