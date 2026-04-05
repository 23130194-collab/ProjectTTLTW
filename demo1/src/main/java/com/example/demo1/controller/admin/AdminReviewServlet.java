package com.example.demo1.controller.admin;

import com.example.demo1.model.Review;
import com.example.demo1.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminReviewServlet", value = "/admin/reviews")
public class AdminReviewServlet extends HttpServlet {
    private static final String SERVLET_PATH = "/admin/reviews";
    private static final String JSP_PATH = "/admin/adminReview.jsp";
    private ReviewService reviewService = new ReviewService();
    private static final int REVIEWS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            handleEditGet(request, response);
            return;
        }

        showReviewList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("update".equals(action)) {
            handleUpdatePost(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + SERVLET_PATH);
        }
    }

    private void showReviewList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("searchKeyword");
        String status = request.getParameter("status");
        String pageStr = request.getParameter("page");

        int currentPage = 1;
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        if ("all".equals(status) || status == null || status.isEmpty()) {
            status = null;
        }

        int totalReviews = reviewService.getTotalReviewCount(keyword, status);
        int totalPages = (int) Math.ceil((double) totalReviews / REVIEWS_PER_PAGE);

        List<Review> reviewList = reviewService.getReviewsByPage(currentPage, REVIEWS_PER_PAGE, keyword, status);

        request.setAttribute("reviewList", reviewList);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher(JSP_PATH).forward(request, response);
    }

    private void handleEditGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("id"));
            Review reviewToEdit = reviewService.getReviewById(reviewId);
            request.setAttribute("reviewToEdit", reviewToEdit);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đánh giá không hợp lệ.");
        }
        showReviewList(request, response);
    }

    private void handleUpdatePost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int reviewId = Integer.parseInt(request.getParameter("reviewId"));
            String status = request.getParameter("status");

            reviewService.updateReviewStatus(reviewId, status);
            request.getSession().setAttribute("successMessage", "Cập nhật trạng thái đánh giá thành công!");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID đánh giá không hợp lệ.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi cập nhật đánh giá.");
        }
        String page = request.getParameter("page") != null ? request.getParameter("page") : "1";
        String searchKeyword = request.getParameter("searchKeyword") != null ? request.getParameter("searchKeyword") : "";
        String statusFilter = request.getParameter("statusFilter") != null ? request.getParameter("statusFilter") : "all";

        response.sendRedirect(request.getContextPath() + SERVLET_PATH + "?page=" + page + "&status=" + statusFilter + "&searchKeyword=" + searchKeyword);
    }
}
