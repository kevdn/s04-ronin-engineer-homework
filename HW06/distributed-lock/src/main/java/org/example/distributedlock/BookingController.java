package org.example.distributedlock;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class BookingController {

    private final BookingService bookingService;

    @Autowired
    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping("/book")
    public String bookSeat(@RequestParam String flightNumber, @RequestParam String seatNumber) {
        boolean booked = bookingService.bookSeat(flightNumber, seatNumber);
        if (booked) {
            return "Seat " + seatNumber + " on flight " + flightNumber + " booked successfully.";
        } else {
            return "Seat " + seatNumber + " on flight " + flightNumber + " is already booked or booking failed.";
        }
    }
}