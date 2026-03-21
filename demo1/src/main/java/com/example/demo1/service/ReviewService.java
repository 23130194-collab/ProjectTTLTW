package com.example.demo1.service;

import com.example.demo1.dao.ReviewDao;
import com.example.demo1.model.Review;

import java.util.List;
import java.util.Map;

public class ReviewService {
    private ReviewDao reviewDao = new ReviewDao();

    public Review getReviewById(int id) {
        return reviewDao.getReviewById(id);
    }

    public void updateReviewStatus(int reviewId, String status) {
        reviewDao.updateReviewStatus(reviewId, status);
    }

    public Map<Integer, Integer> getReviewSummary(int productId) {
        return reviewDao.getRawStarCounts(productId);
    }

    public List<Review> getReviewsForUser(int productId, int ratingFilter, int limit, int offset) {
        return reviewDao.getReviewsWithFilterAndPagination(productId, ratingFilter, limit, offset, false);
    }

    public void addReview(int productId, int userId, int rating, String comment) {
        reviewDao.addReview(productId, userId, rating, comment);
    }

    public List<Review> getReviewsByPage(int currentPage, int reviewsPerPage, String keyword, String status) {
        int offset = (currentPage - 1) * reviewsPerPage;
        return reviewDao.getReviewsByPage(offset, reviewsPerPage, keyword, status);
    }

    public int getTotalReviewCount(String keyword, String status) {
        return reviewDao.getTotalReviewCount(keyword, status);
    }
}
