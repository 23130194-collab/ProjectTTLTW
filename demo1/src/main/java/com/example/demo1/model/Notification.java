package com.example.demo1.model;
import java.sql.Timestamp;


public class Notification {

        private int id;
        private Integer userId;
        private String content;
        private String link;
        private Timestamp createdAt;
        private int targetRole;
        private int isRead;

        public Notification() {}
        public Notification(Integer userId, String content, String link, int targetRole) {
            this.userId = userId;
            this.content = content;
            this.link = link;
            this.targetRole = targetRole;
        }

        public int getIsRead() { return isRead; }
        public void setIsRead(int isRead) { this.isRead = isRead; }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public Integer getUserId() {
            return userId;
        }

        public void setUserId(Integer userId) {
            this.userId = userId;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getLink() {
            return link;
        }

        public void setLink(String link) {
            this.link = link;
        }

        public Timestamp getCreatedAt() {
            return createdAt;
        }

        public void setCreatedAt(Timestamp createdAt) {
            this.createdAt = createdAt;
        }

        public int getTargetRole() { return targetRole; }
        public void setTargetRole(int targetRole) { this.targetRole = targetRole; }

}
