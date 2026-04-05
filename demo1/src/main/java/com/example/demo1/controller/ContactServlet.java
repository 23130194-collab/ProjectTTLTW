package com.example.demo1.controller;

import com.example.demo1.dao.ContactDao;
import com.example.demo1.model.Contact;
import com.example.demo1.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ContactServlet", value = "/contact")
public class ContactServlet extends HttpServlet {
    private ContactDao contactDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.contactDao = new ContactDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            request.setAttribute("loggedInUser", user);
        }

        request.getRequestDispatcher("/lienHe.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String content = request.getParameter("content");

        HttpSession session = request.getSession();

        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            
            session.setAttribute("contactMessage", "Vui lòng điền đầy đủ thông tin.");
            session.setAttribute("messageType", "error");
        } else {
            try {
                Contact contact = new Contact(name, email, content);
                contactDao.insertContact(contact);
                session.setAttribute("contactMessage", "Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất có thể.");
                session.setAttribute("messageType", "success");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("contactMessage", "Đã có lỗi xảy ra. Vui lòng thử lại sau.");
                session.setAttribute("messageType", "error");
            }
        }

        response.sendRedirect(request.getContextPath() + "/contact");
    }
}
