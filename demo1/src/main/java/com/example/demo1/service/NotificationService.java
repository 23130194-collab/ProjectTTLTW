package com.example.demo1.service;

import com.example.demo1.dao.NotificationDao;
import com.example.demo1.model.Notification;
import com.example.demo1.model.User;
import java.util.List;

public class NotificationService {
    private final NotificationDao notificationDao = new NotificationDao();

    public List<Notification> getNotificationsForUser(int userId) {
        return notificationDao.getByUser(userId);
    }

    public List<Notification> getNotificationsForAdmin() {
        return notificationDao.getForAdmin();
    }

    public void markAsRead(int id) {
        notificationDao.markAsRead(id);
    }

    public void insert(Notification notification) {
        notificationDao.insert(notification);
    }
}