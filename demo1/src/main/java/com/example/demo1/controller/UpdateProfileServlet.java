package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "UpdateProfileServlet", value = "/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String gender = request.getParameter("gender");
            String birthdayStr = request.getParameter("birthday");

            Date birthdayDate = null;


            if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {

                birthdayDate = Date.valueOf(birthdayStr);
            }


            user.setName(name);
            user.setPhone(phone);
            user.setAddress(address);
            user.setGender(gender);
            user.setBirthday(birthdayDate);


            AuthService authService = new AuthService();
            authService.updateUser(user);


            session.setAttribute("user", user);
            session.setAttribute("updateProfileSuccess", "Cập nhật thông tin thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("updateProfileError", "Đã xảy ra lỗi. Vui lòng thử lại.");
        }

        response.sendRedirect(request.getContextPath() + "/thongTinTaiKhoan.jsp");
    }
}
