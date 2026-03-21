package com.example.demo1.controller;

import com.example.demo1.model.Category;
import com.example.demo1.service.CategoryService;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;

import java.util.List;

@WebServlet(name = "AppContextListenerServlet", urlPatterns = "/load-initial-data", loadOnStartup = 1)
public class CategoryServlet extends HttpServlet {

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        try{
            ServletContext context = getServletContext();
            CategoryService categoryService = new CategoryService();
            
            List<Category> categoryList = categoryService.getActiveCategories();

            context.setAttribute("categoryList", categoryList);
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
