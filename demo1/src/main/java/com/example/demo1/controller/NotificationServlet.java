package com.example.demo1.controller;

import com.example.demo1.model.Notification;
import com.example.demo1.model.User;
import com.example.demo1.service.NotificationService;
import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", value = "/NotificationServlet")
public class NotificationServlet extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"message\": \"Unauthorized\"}");
            return;
        }

        List<Notification> userNotifications = (user.getRole() == 1)
                ? notificationService.getNotificationsForAdmin()
                : notificationService.getNotificationsForUser(user.getUserId());

        response.getWriter().write(gson.toJson(userNotifications));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            try {
                int notiId = Integer.parseInt(idParam);
                notificationService.markAsRead(notiId);
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"status\": \"success\"}");
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Invalid ID\"}");
            }
        } else {
            notificationService.markAllAdminAsRead();
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("{\"status\": \"success\"}");
        }
    }
}