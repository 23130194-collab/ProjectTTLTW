package com.example.demo1.service;

import java.security.SecureRandom;
import java.sql.Timestamp;
import java.time.LocalDateTime;

public class OtpService {

    private static final SecureRandom random = new SecureRandom();

    public static String generateOtp() {

        return String.format("%06d", random.nextInt(999999));
    }

    public static Timestamp getOtpExpiryTime() {

        return Timestamp.valueOf(LocalDateTime.now().plusMinutes(2));
    }
}
