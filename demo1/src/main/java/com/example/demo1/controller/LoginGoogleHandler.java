package com.example.demo1.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LoginGoogleHandler", value = "/login-google-handler")
public class LoginGoogleHandler extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String client_id = "183680477500-f523c4gkktdp6at2qf9bnhrdcapio7aa.apps.googleusercontent.com";
        String redirect_uri = "http://localhost:8080/demo1_war/login-google";
        String scope = "https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile";
        String googleURL = "https://accounts.google.com/o/oauth2/v2/auth?scope=" + scope + "&redirect_uri=" + redirect_uri
                + "&response_type=code&client_id=" + client_id;
        response.sendRedirect(googleURL);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
