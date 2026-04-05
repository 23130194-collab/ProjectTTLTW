package com.example.demo1.controller;

import com.example.demo1.model.User;
import com.example.demo1.service.UserService;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Form;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "LoginGoogle", value = "/login-google")
public class LoginGoogle extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        String client_id = "183680477500-f523c4gkktdp6at2qf9bnhrdcapio7aa.apps.googleusercontent.com";
        String client_secret = "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";
        String redirect_uri = "http://localhost:8080/demo1_war/login-google";
        String tokenURL = "https://oauth2.googleapis.com/token";

        String accessToken = getToken(code, client_id, client_secret, redirect_uri, tokenURL);

        User user = getUserInfo(accessToken);

        UserService userService = new UserService();
        User existingUser = userService.getUserByEmail(user.getEmail());

        if (existingUser == null) {
            userService.createUser(user);
            existingUser = user;
        }

        request.getSession().setAttribute("user", existingUser);
        response.sendRedirect(request.getContextPath() + "/home");
    }

    public static String getToken(String code, String client_id, String client_secret, String redirect_uri, String tokenURL) throws ClientProtocolException, IOException {
        String response = Request.Post(tokenURL)
                .bodyForm(Form.form().add("client_id", client_id)
                        .add("client_secret", client_secret)
                        .add("redirect_uri", redirect_uri).add("code", code)
                        .add("grant_type", "authorization_code").build())
                .execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");
        return accessToken;
    }

    public static User getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + accessToken;
        String response = Request.Get(link).execute().returnContent().asString();
        User user = new Gson().fromJson(response, User.class);
        return user;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
