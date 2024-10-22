#!/bin/bash

# Send a POST request to book a seat
curl -X POST "http://localhost:8080/book?flightNumber=FA634&seatNumber=A34_S012C"