package com.example.demo1.dao;
import com.example.demo1.model.Notification;
import org.jdbi.v3.core.Jdbi;
import java.util.List;


public class NotificationDao {

    private final Jdbi jdbi = DatabaseDao.get();

        public void insert(Notification n) {
            String sql = "INSERT INTO notifications (user_id, content, link, target_role, created_at) VALUES (:uid, :content, :link, :role, NOW())";

            jdbi.useHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("uid", n.getUserId())
                            .bind("content", n.getContent())
                            .bind("link", n.getLink())
                            .bind("role", n.getTargetRole())
                            .execute()
            );
        }

        public List<Notification> getByUser(int userId) {
            String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";

            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind(0, userId)
                            .mapToBean(Notification.class)
                            .list()
            );
        }

        public List<Notification> getForAdmin() {
            String sql = "SELECT * FROM notifications WHERE target_role = 1 ORDER BY created_at DESC LIMIT 10";
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .mapToBean(Notification.class)
                            .list()
            );
        }

        public int countUnreadAdmin() {
            String sql = "SELECT COUNT(*) FROM notifications WHERE target_role = 1 AND is_read = 0";
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql).mapTo(Integer.class).one()
            );
        }

        public void markAllAdminAsRead() {
            String sql = "UPDATE notifications SET is_read = 1 WHERE target_role = 1 AND is_read = 0";
            jdbi.useHandle(handle -> handle.createUpdate(sql).execute());
        }

        public void markAsRead(int id) {
            String sql = "UPDATE notifications SET is_read = 1 WHERE id = :id";
            jdbi.useHandle(handle ->
                    handle.createUpdate(sql)
                            .bind("id", id)
                            .execute()
            );
        }

    public void insertAdminNotification(String content, String link) {
        String sql = "INSERT INTO notifications (user_id, content, link, target_role, created_at) " +
                "VALUES (NULL, :content, :link, 1, NOW())";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("content", content)
                        .bind("link", link)
                        .execute()
        );
    }

}

