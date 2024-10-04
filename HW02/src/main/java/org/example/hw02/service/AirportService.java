package org.example.hw02.service;


import org.example.hw02.model.Airport;
import com.google.common.cache.Cache;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class AirportService {

    private final Cache<String, String> airportCache;

    public AirportService(Cache<String, String> airportCache) {
        this.airportCache = airportCache;
    }

    public Airport getAirport(String code) {
        try {
            String airportName = airportCache.get(code, () -> {

                System.out.println("Cache miss for " + code + ". Loading from 'database'...");
                return getAirportFromDatabase(code);
            });
            System.out.println("Returning airport from cache: " + code);
            return new Airport(code, airportName);
        } catch (ExecutionException e) {
            throw new RuntimeException("Error retrieving airport", e);
        }
    }

    private String getAirportFromDatabase(String code) {
        // Simulating a slow database call
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        List<Airport> airports = Arrays.asList(
                new Airport("JFK", "John F. Kennedy International Airport"),
                new Airport("LAX", "Los Angeles International Airport"),
                new Airport("LHR", "London Heathrow Airport"),
                new Airport("CDG", "Charles de Gaulle Airport"),
                new Airport("AMS", "Amsterdam Airport Schiphol"),
                new Airport("HND", "Tokyo Haneda Airport"),
                new Airport("PVG", "Shanghai Pudong International Airport"),
                new Airport("SYD", "Sydney Kingsford-Smith Airport"),
                new Airport("MEX", "Mexico City International Airport"),
                new Airport("JNB", "OR Tambo International Airport"),
                new Airport("DXB", "Dubai International Airport"),
                new Airport("SIN", "Singapore Changi Airport"),
                new Airport("ICN", "Incheon International Airport")
        );

        return airports.stream()
                .filter(airport -> airport.getCode().equals(code))
                .map(Airport::getName)
                .findFirst()
                .orElse(null);
    }
}