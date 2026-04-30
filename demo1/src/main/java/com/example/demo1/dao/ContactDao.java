package com.example.demo1.dao;

import com.example.demo1.model.Contact;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.statement.Query;

import java.util.List;

public class ContactDao {
    private final Jdbi jdbi = DatabaseDao.get();
    private static final String BASE_SELECT = "SELECT id, name, email, content, created_at AS createdAt, " +
            "is_processed AS processed, response_content AS responseContent, responded_at AS respondedAt FROM contacts ";

    public void insertContact(Contact contact) {
        jdbi.useHandle(handle ->
                handle.createUpdate("INSERT INTO contacts (name, email, content) VALUES (:name, :email, :content)")
                        .bindBean(contact)
                        .execute()
        );
    }

    public List<Contact> getContactsByPage(int offset, int limit, String keyword, Boolean processed) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder(BASE_SELECT);
            boolean hasWhere = false;

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("WHERE name LIKE :keyword ");
                hasWhere = true;
            }

            if (processed != null) {
                sql.append(hasWhere ? "AND " : "WHERE ");
                sql.append("is_processed = :processed ");
            }

            sql.append("ORDER BY created_at DESC, id DESC LIMIT :limit OFFSET :offset");

            Query query = handle.createQuery(sql.toString())
                    .bind("limit", limit)
                    .bind("offset", offset);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }

            if (processed != null) {
                query.bind("processed", processed);
            }

            return query.mapToBean(Contact.class).list();
        });
    }

    public int countContacts(String keyword, Boolean processed) {
        return jdbi.withHandle(handle -> {
            StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM contacts ");
            boolean hasWhere = false;

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("WHERE name LIKE :keyword ");
                hasWhere = true;
            }

            if (processed != null) {
                sql.append(hasWhere ? "AND " : "WHERE ");
                sql.append("is_processed = :processed ");
            }

            Query query = handle.createQuery(sql.toString());

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.bind("keyword", "%" + keyword.trim() + "%");
            }

            if (processed != null) {
                query.bind("processed", processed);
            }

            return query.mapTo(Integer.class).one();
        });
    }

    public Contact getContactById(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery(BASE_SELECT + "WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Contact.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void markAsProcessed(int id) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE contacts SET is_processed = 1 WHERE id = :id")
                        .bind("id", id)
                        .execute()
        );
    }

    public void saveResponse(int id, String responseContent) {
        jdbi.useHandle(handle ->
                handle.createUpdate("UPDATE contacts " +
                                "SET is_processed = 1, response_content = :responseContent, responded_at = NOW() " +
                                "WHERE id = :id")
                        .bind("id", id)
                        .bind("responseContent", responseContent)
                        .execute()
        );
    }
}
