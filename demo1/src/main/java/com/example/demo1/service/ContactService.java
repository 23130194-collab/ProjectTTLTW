package com.example.demo1.service;

import com.example.demo1.dao.ContactDao;
import com.example.demo1.model.Contact;

import java.util.List;

public class ContactService {
    private final ContactDao contactDao = new ContactDao();
    private final NotificationService notificationService = new NotificationService();

    public List<Contact> getContactsByPage(int currentPage, int pageSize, String keyword, String status) {
        int offset = (currentPage - 1) * pageSize;
        return contactDao.getContactsByPage(offset, pageSize, keyword, parseStatus(status));
    }

    public int getTotalContactCount(String keyword, String status) {
        return contactDao.countContacts(keyword, parseStatus(status));
    }

    public Contact getContactById(int id) {
        return contactDao.getContactById(id);
    }

    public void markAsProcessed(int id) {
        contactDao.markAsProcessed(id);
    }

    public void saveResponse(int id, String responseContent) {
        contactDao.saveResponse(id, responseContent);
    }

    public void submitContact(Contact contact) {
        int newId = contactDao.insertContact(contact);
        notificationService.notifyAdminNewContact(newId, contact.getName());
    }

    private Boolean parseStatus(String status) {
        if (status == null || status.trim().isEmpty() || "all".equalsIgnoreCase(status)) {
            return null;
        }

        if ("processed".equalsIgnoreCase(status)) {
            return Boolean.TRUE;
        }

        if ("pending".equalsIgnoreCase(status)) {
            return Boolean.FALSE;
        }

        return null;
    }
}
