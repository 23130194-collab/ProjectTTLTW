package com.example.demo1.service;

import com.example.demo1.dao.UserDao;
import com.example.demo1.model.User;

import java.util.List;

public class UserService {
    private UserDao userDao = new UserDao();

    public User getUserByEmail(String email) {
        return userDao.getUserByEmail(email);
    }

    public void insertUser(String name, String email, String password) {
        userDao.insertUser(name, email, password);
    }

    public void activateUser(int userId) {
        userDao.activateUser(userId);
    }

    public void updateUser(User user) {
        userDao.updateUser(user);
    }

    public void updateUserStatus(int userId, String newStatus) {
        userDao.updateUserStatus(userId, newStatus);
    }

    public String getUserStatus(int userId) {
        return userDao.getUserStatus(userId);
    }

    public int countCustomersByFilter(String status, String keyword) {
        return userDao.countCustomersByFilter(status, keyword);
    }

    public List<User> getCustomersPaging(int limit, int offset, String status, String keyword) {
        return userDao.getCustomersPaging(limit, offset, status, keyword);
    }

    public int getTotalCustomersCount() {
        return userDao.getTotalCustomersCount();
    }
}