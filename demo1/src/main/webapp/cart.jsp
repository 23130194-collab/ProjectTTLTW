<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.example.demo1.model.CartItem" %>


<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
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

            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="icon-btn cart-btn-wrapper" title="Giỏ hàng">
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
                            <img src="${pageContext.request.contextPath}/${imageSrc}" class="category-icon" alt="${cat.name}">
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

<div class="app-container">
    <div class="header-cart">
        <span></span>
    </div>

    <c:if test="${not empty sessionScope.cartError}">
        <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin: 10px 15px; border: 1px solid #f5c6cb; border-radius: 5px; position: relative;">
                ${sessionScope.cartError}
            <span class="close-btn" onclick="this.parentElement.style.display='none';"
                  style="position: absolute; top: 50%; right: 15px; transform: translateY(-50%); cursor: pointer; font-weight: bold; font-size: 20px;">
                &times;
            </span>
        </div>
        <c:remove var="cartError" scope="session"/>
    </c:if>

    <div class="cart-content">

    <c:forEach items="${sessionScope.cart}" var="entry">
        <c:set var="item" value="${entry.value}"/>
        <div class="product-item">
            <img src="${item.product.image}" alt="${item.product.name}">
            <div class="info">
                <div class="info-line">
                    <span>${item.product.name}</span>
                    <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px;">
                        <a href="AddCart?action=delete&id=${item.product.id}" class="delete-icon">
                            <i class="fa fa-trash"></i>
                        </a>

                        <div class="qty">
                            <a href="AddCart?action=update&id=${item.product.id}&num=-1" style="text-decoration:none;">
                                <button>-</button>
                            </a>

                            <input type="text" value="${item.quantity}" readonly>

                            <a href="AddCart?action=update&id=${item.product.id}&num=1" style="text-decoration:none;">
                                <button>+</button>
                            </a>
                        </div>
                    </div>
                </div>
                <div>
                <span class="current-price">
                    <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>₫
                </span>
                    <c:if test="${item.product.oldPrice > item.product.price}">
                    <span class="old-price">
                        <fmt:formatNumber value="${item.product.oldPrice}" pattern="#,###"/>₫
                    </span>
                    </c:if>
                </div>
            </div>
        </div>
    </c:forEach>
    </div>
</div>

<div class="footer-bar">
    <span class="total-amount">Tạm tính: <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫</span>
    <a href="AddCart?action=checkout" class="btn-buy-link">Mua ngay</a>
</div>

<script src="js/header.js"></script>
</body>

</html>