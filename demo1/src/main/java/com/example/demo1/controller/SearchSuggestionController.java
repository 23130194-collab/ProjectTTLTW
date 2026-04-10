package com.example.demo1.controller;

import com.example.demo1.model.ProductSuggestion;
import com.example.demo1.service.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "SearchSuggestionController", value = "/search-suggestions")
public class SearchSuggestionController extends HttpServlet {
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (keyword == null || keyword.trim().length() < 2) {
            response.getWriter().write("[]");
            return;
        }

        List<ProductSuggestion> suggestions = productService.getSuggestions(keyword, 8);

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < suggestions.size(); i++) {
            ProductSuggestion s = suggestions.get(i);
            String escapedName = s.getName()
                    .replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", " ")
                    .replace("\r", " ");

            json.append("{")
                    .append("\"id\":").append(s.getId()).append(",")
                    .append("\"name\":\"").append(escapedName).append("\"")
                    .append("}");

            if (i < suggestions.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}