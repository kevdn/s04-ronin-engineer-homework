package org.example.distributedlock;

import org.redisson.api.RLock;
import org.redisson.api.RedissonClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class BookingService {

    private final RedissonClient redissonClient;
    private final RedisTemplate<String, String> redisTemplate;

    @Autowired
    public BookingService(RedissonClient redissonClient, RedisTemplate<String, String> redisTemplate) {
        this.redissonClient = redissonClient;
        this.redisTemplate = redisTemplate;
    }

    public boolean bookSeat(String flightNumber, String seatNumber) {
        String lockKey = "lock:" + flightNumber + ":" + seatNumber;
        String seatKey = "seat:" + flightNumber + ":" + seatNumber;
        RLock lock = redissonClient.getLock(lockKey);

        try {
            // Try to acquire the lock for 10 seconds
            boolean isLocked = lock.tryLock(10, 10, TimeUnit.SECONDS);
            if (isLocked) {
                // Check if the seat is already booked
                Boolean seatBooked = redisTemplate.opsForValue().setIfAbsent(seatKey, "booked", 1, TimeUnit.HOURS);
                if (Boolean.TRUE.equals(seatBooked)) {
                    // Seat was successfully booked
                    return true;
                } else {
                    // Seat was already booked
                    return false;
                }
            } else {
                // Could not acquire the lock, seat might be in the process of being booked
                return false;
            }
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return false;
        } finally {
            if (lock.isHeldByCurrentThread()) {
                lock.unlock();
            }
        }
    }
}