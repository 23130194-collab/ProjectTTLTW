package com.example.demo1.dao;

import com.example.demo1.model.Contact;
import org.jdbi.v3.core.Jdbi;

public class ContactDao {
    private Jdbi jdbi = DatabaseDao.get();

    public void insertContact(Contact contact) {
        jdbi.useHandle(handle ->
                handle.createUpdate("INSERT INTO contacts (name, email, content) VALUES (:name, :email, :content)")
                        .bindBean(contact)
                        .execute()
        );
    }
}
