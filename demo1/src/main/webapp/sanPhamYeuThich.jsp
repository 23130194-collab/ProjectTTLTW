<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.example.demo1.model.CartItem" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Thông tin tài khoản | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
</head>
<body>
<header class="header">
    <div class="header-container">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
            <span class="brand-name">TechNova</span>
        </a>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="active">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/gioiThieu.jsp">Giới thiệu</a>
            <a href="#" id="category-toggle">Danh mục</a>
            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
        </nav>

        <div class="search-box">
            <form action="search" method="get" id="searchForm" style="display: flex; width: 100%;">
                <input type="text" name="keyword" id="searchInput"
                       placeholder="Bạn muốn mua gì hôm nay?" autocomplete="off">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
            <div id="suggestion-box" class="suggestion-box" style="display:none;"></div>
        </div>

        <div class="header-actions">

            <%
                int totalQuantity = 0;
                Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

                if (cart != null) {
                    totalQuantity = cart.size();
                }
            %>

            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="icon-btn cart-btn-wrapper"
               title="Giỏ hàng">
                <i class="fas fa-shopping-cart"></i>

                <% if (totalQuantity > 0) { %>
                <span class="cart-badge"><%= totalQuantity %></span>
                <% } %>
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/my-orders" class="icon-btn" title="Tài khoản của bạn">
                        <i class="fas fa-user"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="icon-btn" title="Đăng nhập">
                        <i class="fas fa-user"></i>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="category-box" id="categoryBox">
            <c:forEach items="${applicationScope.categoryList}" var="cat">
                <a href="list-product?id=${cat.id}" class="category-item">
                    <c:set var="imageSrc" value="${cat.image}"/>
                    <c:choose>
                        <c:when test="${fn:startsWith(imageSrc, 'http')}">
                            <img src="${imageSrc}" class="category-icon" alt="${cat.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/${imageSrc}" class="category-icon"
                                 alt="${cat.name}">
                        </c:otherwise>
                    </c:choose>
                        ${cat.name}
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </c:forEach>
        </div>
    </div>
</header>
<div class="overlay" id="overlay"></div>
<div class="container">
    <div class="top-card" role="region" aria-label="thông tin tài khoản">
        <div class="profile">
            <div class="summary-card">
                <div class="summary-left">
                    <div class="reviewer-avatar">${fn:substring(sessionScope.user.name, 0, 1)}</div>
                    <div class="summary-info">
                        <div class="summary-name">${sessionScope.user.name}</div>
                        <div class="summary-phone">${sessionScope.user.phone}</div>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-item">
                    <div class="summary-icon">
                        <i class="fa-solid fa-cart-shopping" style="color: #ff0000;"></i>
                    </div>
                    <div class="summary-text">
                        <div class="summary-count">${totalOrders}</div>
                        <div class="summary-label">Tổng số đơn hàng đã mua</div>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-item">
                    <div class="summary-icon">
                        <i class="fa-solid fa-sack-dollar" style="color: #74C0FC;"></i>
                    </div>
                    <div class="summary-text">
                        <div class="summary-count">
                            <fmt:formatNumber value="${totalSpent}" pattern="#,###"/>đ
                        </div>
                        <div class="summary-small">Tổng tiền tích lũy</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="main">
        <aside class="side" aria-label="menu">
            <nav class="menu" aria-label="menu chính">
                <a href="${pageContext.request.contextPath}/my-orders" class="menu-item">
                    <i class="fa-solid fa-list icon"></i>
                    <span class="label">Đơn hàng của tôi</span>
                </a>

                <a href="${pageContext.request.contextPath}/favorites" class="menu-item active">
                    <i class="fa-regular fa-heart icon"></i>
                    <span class="label">Sản phẩm yêu thích</span>
                </a>

                <a href="${pageContext.request.contextPath}/account" class="menu-item">
                    <i class="fa-regular fa-user icon"></i>
                    <span class="label">Thông tin tài khoản</span>
                </a>

                <a href="#" id="logoutLink" class="menu-item">
                    <i class="fa-solid fa-right-from-bracket icon"></i>
                    <span class="label">Đăng xuất</span>
                </a>
            </nav>
        </aside>

        <section class="content">
            <div class="section active" id="favorites">
                <h2>Sản phẩm yêu thích</h2>

                <div class="favorite-grid">
                    <c:choose>
                        <c:when test="${not empty favList}">
                            <c:forEach var="p" items="${favList}">
                                <article class="product-card-fav">
                                    <div class="product-fav-thumb">
                                        <img src="${p.image}" alt="${p.name}">
                                    </div>
                                    <div class="product-fav-details">
                                        <h4 class="product-fav-title">${p.name}</h4>
                                        <div class="product-fav-price">
                                        <span class="new-price">
                                            <fmt:formatNumber value="${p.price}" pattern="#,###"/>đ
                                        </span>
                                            <c:if test="${p.oldPrice > p.price}">
                                            <span class="old-price">
                                                <fmt:formatNumber value="${p.oldPrice}" pattern="#,###"/>đ
                                            </span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/remove-favorite?id=${p.id}"
                                       class="fav-remove-link">
                                        <i class="fa-solid fa-heart product-fav-heart"></i>
                                    </a>
                                </article>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p style="grid-column: span 2; text-align: center; color: #999; margin-top: 40px;">
                                Danh sách yêu thích của bạn đang trống.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </div>
</div>

<div id="logoutConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelLogout">Hủy</a>
            <a href="${pageContext.request.contextPath}/logout" class="modal-btn modal-confirm">Đăng xuất</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/header.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
            logoutLink.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });

            cancelLogoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });

            logoutConfirmModal.addEventListener('click', function (e) {
                if (e.target === logoutConfirmModal) {
                    logoutConfirmModal.classList.remove('show');
                }
            });
        }
    });
</script>
</body>
</html>
