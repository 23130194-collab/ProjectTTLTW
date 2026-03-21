<%@ page import="com.example.demo1.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm: ${selectedKeyword} | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mucSanPham.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <style>
        .product-grid {
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            width: 100%;
        }

        .page-title {
            margin: 20px 0;
            font-size: 1.5rem;
            color: #333;
        }
    </style>
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
            <form action="search" method="get" style="display: flex; width: 100%;">
                <input type="text" name="keyword" value="${selectedKeyword}" placeholder="Bạn muốn mua gì hôm nay?"
                       autocomplete="off">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <div class="header-actions">
            <%
                int totalQuantity = 0;
                Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

                if (cart != null) {
                    totalQuantity = cart.size();
                }
            %>
            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="icon-btn" title="Giỏ hàng">
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
<main class="container">
    <h1 class="page-title">Kết quả tìm kiếm cho: "${selectedKeyword}"</h1>
    <div class="sort-wrapper">
        <div class="sort-buttons">
            <c:url var="baseUrl" value="search">
                <c:param name="keyword" value="${selectedKeyword}"/>
            </c:url>
            <a href="${baseUrl}&sort=popular" class="sort-btn ${selectedSortOrder == 'popular' ? 'active' : ''}">Phổ
                biến</a>
            <a href="${baseUrl}&sort=price_asc" class="sort-btn ${selectedSortOrder == 'price_asc' ? 'active' : ''}">Giá
                Thấp - Cao</a>
            <a href="${baseUrl}&sort=price_desc" class="sort-btn ${selectedSortOrder == 'price_desc' ? 'active' : ''}">Giá
                Cao - Thấp</a>
        </div>
    </div>
    <div class="product-grid">
        <c:forEach items="${productList}" var="p">
            <div class="product-card">
                <c:if test="${p.discountValue > 0}">
                    <div class="discount-tag">
                        <span class="discount-percent">-<fmt:formatNumber value="${p.discountValue}"
                                                                          pattern="#"/>%</span>
                    </div>
                </c:if>
                <a href="product-detail?id=${p.id}" class="product-link">
                    <img src="${p.image.startsWith('http') ? p.image : pageContext.request.contextPath.concat('/').concat(p.image)}"
                         class="product-image" alt="${p.name}">
                    <h3 class="product-title">${p.name}</h3>
                    <div class="price-section">
                        <div class="current-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</div>
                        <c:if test="${p.discountValue > 0}">
                            <div class="original-price"><fmt:formatNumber value="${p.oldPrice}" pattern="#,###"/>đ</div>
                        </c:if>
                    </div>
                </a>
                <div class="product-footer-interaction">
                    <div class="action-item rating">
                        <div class="stars-container">
                            <div class="stars-outer">
                                <div class="stars-inner" style="width: ${(p.avgRating / 5) * 100}%;"></div>
                            </div>
                        </div>
                        <span class="rating-value"><fmt:formatNumber value="${p.avgRating}" pattern="0.0"/></span>
                    </div>
                    <button class="action-item like-btn"><i class="fa-regular fa-heart"></i></button>
                </div>
            </div>
        </c:forEach>
    </div>
    <c:if test="${totalPages > 1}">
        <div class="pagination-container">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:url var="pageUrl" value="search">
                    <c:param name="keyword" value="${selectedKeyword}"/>
                    <c:param name="sort" value="${selectedSortOrder}"/>
                    <c:param name="page" value="${i}"/>
                </c:url>
                <a href="${pageUrl}" class="page-number ${currentPage == i ? 'active' : ''}">${i}</a>
            </c:forEach>
        </div>
    </c:if>
</main>
<footer>
    <div class="footer-container">
        <div class="footer-main-content">

            <div class="footer-col col-1">
                <h4>Tổng đài hỗ trợ miễn phí</h4>
                <ul>
                    <li>Mua hàng - bảo hành 1800.2097 (7h30 - 18h30)</li>
                    <li>Khiếu nại 1800.2063 (8h00 - 21h30)</li>
                </ul>

                <h4>Phương thức thanh toán</h4>
                <div class="payment-methods">
                    <img src="https://i.postimg.cc/FsJvZGsX/apple-Pay.png" alt="Apple Pay">
                    <img src="https://i.postimg.cc/pTTbnJ10/bidv.png" alt="BIDV">
                    <img src="https://i.postimg.cc/L6fXXmPn/momo.jpg" alt="MoMo">
                    <img src="https://i.postimg.cc/bYn803wR/Zalo-Pay.png" alt="Zalo Pay">
                </div>
            </div>

            <div class="footer-col col-2">
                <h4>Thông tin về chính sách</h4>
                <ul>
                    <li>Mua hàng và thanh toán online</li>
                    <li>Mua hàng trả góp online</li>
                    <li>Mua hàng trả góp bằng thẻ tín dụng</li>
                    <li>Chính sách giao hàng</li>
                    <li>Chính sách đổi trả</li>
                    <li>Đổi điểm</li>
                    <li>Xem ưu đãi</li>
                    <li>Tra cứu hóa đơn điện tử</li>
                    <li>Thông tin hóa đơn mua hàng</li>
                    <li>Trung tâm bảo hành chính hãng</li>
                    <li>Quy định về việc sao lưu dữ liệu</li>
                    <li>Thuế VAT</li>
                </ul>
            </div>

            <div class="footer-col col-3">
                <h4>Dịch vụ và thông tin khác</h4>
                <ul>
                    <li>Khách hàng doanh nghiệp</li>
                    <li>Ưu đãi thanh toán</li>
                    <li>Quy chế hoạt động</li>
                    <li>Chính sách bảo mật thông tin cá nhân</li>
                    <li>Chính sách bảo hành</li>
                    <li>Liên hệ hợp tác kinh doanh</li>
                    <li>Tuyển dụng</li>
                    <li>Dịch vụ bảo hành</li>
                </ul>
            </div>

            <div class="footer-col col-4">
                <h4>Kết nối với TechNova</h4>
                <div class="connect-methods">
                    <img src="https://i.postimg.cc/CLjh0my7/youtube.png" alt="Youtube">
                    <img src="https://i.postimg.cc/rsBv3Xyx/facebook.png" alt="Facebook">
                    <img src="https://i.postimg.cc/vBkYYKHS/tiktok.png" alt="TikTok">
                    <img src="https://i.postimg.cc/k55qxC26/Zalo.png" alt="Zalo">
                </div>
            </div>

        </div>
        <div class="footer-subscription"></div>
    </div>
</footer>

<script src="js/header.js"></script>
</body>
</html>