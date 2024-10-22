# Distributed Seat Booking System

This project is a distributed seat booking system built using Spring Boot, Redis, and Redisson for distributed locking. The system ensures that seats cannot be double-booked by using Redis locks.

## Prerequisites

- Java 17 or higher
- Maven 3.6.0 or higher
- Redis server

## Getting Started

### Clone the Repository

```sh
git clone https://github.com/kevdn/s04-ronin-engineer-homework
cd HW06/distributed-lock
```

### Run docker-compose to start Redis server

```sh
docker-compose up -d
```

### Build the Project

```sh
mvn clean install
```

### Run the Project

```sh
mvn spring-boot:run
```
The application will be accessible at `http://localhost:8080`.


### Book a Seat

## API Endpoint: Book a Seat

## URL
`/book`

## Method
`POST`

## Query Parameters
- `flightNumber` (required): The flight number.
- `seatNumber` (required): The seat number.

## Example Request
```bash
curl -X POST "http://<your-domain>/book?flightNumber=FA634&seatNumber=A34_S012C"
```
## Example Response

```json
{
    "message": "Seat A34_S012C has been successfully booked for flight FA634."
}
```

or 
    
```json
    {
        "message": "Seat A34_S012C is already booked or booking failed."
    }
```

### Run the Tests
You can use the provided test.sh script to send multiple booking requests simultaneously to test the Redis lock mechanism.

```sh
./test.sh
```

