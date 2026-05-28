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
    public void markAllAdminAsRead() {
        notificationDao.markAllAdminAsRead();
    }

    public void insert(Notification notification) {
        notificationDao.insert(notification);
    }

    public void notifyAdminNewUser( String username) {
        notificationDao.insertAdminNotification(
                "👤 Người dùng mới đăng ký: " + username,
                "/admin/customers"
        );
    }

    public void notifyAdminNewContact(int contactId, String senderName) {
        notificationDao.insertAdminNotification(
                "Liên hệ mới từ: " + senderName,
                "/admin/contacts?action=detail&id=" + contactId
        );
    }

    public void notifyAdminNewOrder(int orderId, String orderCode) {
        notificationDao.insertAdminNotification(
                "Đơn hàng mới: " + orderCode,
                "/admin/orders?action=view&id=" + orderId
        );
    }

    public void notifyAdminOrderCancelled(int orderId, String orderCode) {
        notificationDao.insertAdminNotification(
                "Đơn hàng bị hủy: " + orderCode,
                "/admin/orders?action=view&id=" + orderId
        );
    }

    public void notifyUserOrderCancelledByAdmin(int userId, int orderId, String orderCode, String reason) {
        String content = "Đơn hàng " + orderCode + " đã bị hủy. Lý do: " + reason;
        notificationDao.insertUserNotification(userId, content, "/order-detail?id=" + orderId);
    }
}