package com.example.demo1.service;

import com.example.demo1.dao.UserDao;
import com.example.demo1.model.User;
import com.example.demo1.util.MD5;

import java.sql.Timestamp;

public class AuthService {
    UserDao authDao = new UserDao();
    private final NotificationService notificationService = new NotificationService();

    public User checkLogin(String email, String password) {
        User u = authDao.getUserByEmail(email);

        if (u != null && u.getPassword().equals(MD5.hash(password)) && !"Locked".equalsIgnoreCase(u.getStatus())) {
            u.setPassword(null);
            return u;
        }
        return null;
    }

    public User getUserByEmail(String email) {
        return authDao.getUserByEmail(email);
    }

    public User getUserById(int userId) {
        return authDao.getUserById(userId);
    }

    public boolean emailExists(String email) {
        return authDao.getUserByEmail(email) != null;
    }

    public void register(String name, String email, String hashedPassword, String otp, Timestamp otpExpiry) {
        authDao.insertUser(name, email, hashedPassword, otp, otpExpiry);
        notificationService.notifyAdminNewUser(name);
    }

    public void activateUser(int userId) {
        authDao.activateUser(userId);
    }

    public void updateOtpForUser(String email, String otp, Timestamp otpExpiry) {
        authDao.updateOtp(email, otp, otpExpiry);
    }

    public void updateOtpForUserById(int userId, String otp, Timestamp otpExpiry) {
        authDao.updateOtpById(userId, otp, otpExpiry);
    }

    public void updatePassword(String email, String hashedPassword, Timestamp updatedAt) {
        authDao.updatePassword(email, hashedPassword, updatedAt);
    }

    public void updateUser(User user) {
        authDao.updateUser(user);
    }

    public void clearOtpForUser(int userId) {
        authDao.clearOtp(userId);
    }
}
