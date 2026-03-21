<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<%@ page import="com.example.demo1.model.CartItem" %>
<%@ page import="java.util.Map" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mucSanPham.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css">
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

<main>
    <section class="home-layout">
        <!-- Cột trái: Danh mục sản phẩm -->
        <div class="home-left">
            <div class="content-category">
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

        <div class="home-center">
            <div class="banners-container" id="banner-left">
                <div class="slider-container">
                    <div class="slides-wrapper">
                        <c:forEach var="b" items="${bannerList}">
                            <a href="#" class="slide-item">
                                <img src="${b.image.startsWith('http') ? b.image : pageContext.request.contextPath.concat('/').concat(b.image)}"
                                     class="banner-img"
                                     alt="${b.name}">
                            </a>
                        </c:forEach>

                        <c:if test="${empty bannerList}">
                            <a href="#" class="slide-item">
                                <img src="https://i.postimg.cc/QC0GXpKP/meg-ai1600pcie5-678x429.png" class="banner-img"
                                     alt="Default">
                            </a>
                        </c:if>
                    </div>
                    <button class="slider-nav prev-btn"><i class="fa-solid fa-chevron-left"></i></button>
                    <button class="slider-nav next-btn"><i class="fa-solid fa-chevron-right"></i></button>
                    <div class="dots-container"></div>
                </div>
            </div>
        </div>

        <div class="home-right">
            <div class="suggest-box">
                <div class="suggest-welcome">
                    <div class="suggest-text">
                        <h2>Chào mừng bạn đến với TechNova</h2>
                        <p>Tham gia với chúng tôi để không bỏ lỡ các ưu đãi</p>
                    </div>
                </div>

                <span id="openNotice" class="suggest-item" style="cursor:pointer;">
                        <i class="fa-solid fa-bell"></i> Thông báo của bạn
                        <i class="fa-solid fa-chevron-right"></i>
                </span>

                <a href="${pageContext.request.contextPath}/contact" class="suggest-item">
                    <i class="fa-solid fa-phone-volume"></i> Liên hệ với chúng tôi
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>

            <div class="suggest-box">
                <div class="suggest-special">Ưu đãi khách hàng</div>

                <a href="#" class="suggest-item">
                    <i class="fa-solid fa-arrow-trend-up"></i> Chính sách đổi trả
                    <i class="fa-solid fa-chevron-right"></i>
                </a>

                <a href="#" class="suggest-item">
                    <i class="fa-regular fa-clock"></i> Cam kết sản phẩm
                    <i class="fa-solid fa-chevron-right"></i>
                </a>

                <a href="#" class="suggest-item">
                    <i class="fa-solid fa-shield-halved"></i> Chính sách bảo hành
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>
        </div>

    </section>

    <section class="flash-sale">
        <div class="flash-sale-header">
            <h2>SẢN PHẨM BÁN CHẠY</h2>
        </div>

        <div class="slider-wrapper">
            <button class="arrow left"><i class="fa-solid fa-chevron-left"></i></button>
            <div class="slider" id="slider">

                <c:forEach var="p" items="${flashSaleList}">
                    <div class="slider-item">
                        <div class="product-card" style="position: relative;">
                            <c:if test="${p.discountValue > 0}">
                                <div class="discount-tag">
                                    <span class="discount-percent">-<fmt:formatNumber value="${p.discountValue}"
                                                                                      pattern="#"/>%</span>
                                </div>
                            </c:if>

                            <a href="product-detail?id=${p.id}" class="product-link"
                               style="text-decoration: none; color: inherit;">
                                <img src="${p.image.startsWith('http') ? p.image : pageContext.request.contextPath.concat('/').concat(p.image)}"
                                     class="product-image" alt="${p.name}">

                                <div class="product-title" style="font-weight: bold; margin-top: 10px;">${p.name}</div>

                                <div class="price" style="margin-top: 5px;">
                                    <strong style="color: #d70018; font-size: 1.1em;">
                                        <fmt:formatNumber value="${p.price}" pattern="#,###"/>đ
                                    </strong>
                                    <c:if test="${p.discountValue > 0}">
                                    <span class="old"
                                          style="text-decoration: line-through; color: #999; margin-left: 5px; font-size: 0.9em;">
                                        <fmt:formatNumber value="${p.oldPrice}" pattern="#,###"/>đ
                                    </span>
                                    </c:if>
                                </div>
                            </a>

                            <div class="product-footer-interaction"
                                 style="margin-top: 8px; display: flex; align-items: center; justify-content: space-between;">
                                <div class="action-item rating">
                                    <div class="stars-container">
                                        <div class="stars-outer">
                                            <div class="stars-inner" style="width: ${(p.avgRating / 5) * 100}%;"></div>
                                        </div>
                                    </div>
                                    <span class="rating-value"><fmt:formatNumber value="${p.avgRating}"
                                                                                 pattern="0.0"/></span>
                                </div>

                                <a href="${pageContext.request.contextPath}/toggle-favorite?id=${p.id}"
                                   class="action-item like-btn"
                                   style="text-decoration: none; border: none; background: none; color: #d70018;">
                                    <c:choose>
                                        <c:when test="${p.favorite}">
                                            <i class="fa-solid fa-heart"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-regular fa-heart"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            <button class="arrow right"><i class="fa-solid fa-chevron-right"></i></button>
        </div>
    </section>

    <section class="suggest-products">
        <h2 class="suggest-title">GỢI Ý SẢN PHẨM CHO BẠN</h2>

        <div class="product-grid">
            <c:forEach var="p" items="${suggestedProducts}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}" class="slider-item">
                    <div class="product-card">
                        <c:if test="${p.discountValue > 0}">
                            <div class="discount-tag">
                                <span class="discount-percent">-<fmt:formatNumber value="${p.discountValue}"
                                                                                  pattern="#"/>%</span>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${p.image != null && p.image.startsWith('http')}">
                                <img src="${p.image}" class="product-image" alt="${p.name}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/${p.image}" class="product-image"
                                     alt="${p.name}">
                            </c:otherwise>
                        </c:choose>

                        <h3 class="product-title">${p.name}</h3>

                        <div class="price-section">
                            <div class="current-price">
                                <fmt:formatNumber value="${p.price}" pattern="#,###"/>đ
                            </div>
                            <c:if test="${p.discountValue > 0}">
                                <div class="original-price">
                                    <fmt:formatNumber value="${p.oldPrice}" pattern="#,###"/>đ
                                </div>
                            </c:if>
                        </div>

                        <div class="product-footer-interaction">
                            <div class="action-item rating">
                                <div class="stars-container">
                                    <div class="stars-outer">
                                        <div class="stars-inner"
                                             style="width: ${ (p.avgRating * 1.0 / 5) * 100 }%;"></div>
                                    </div>
                                </div>
                                <span class="rating-value"><fmt:formatNumber value="${p.avgRating}"
                                                                             pattern="0.0"/></span>
                            </div>

                            <button class="action-item like-btn">
                                <i class="fa-regular fa-heart"></i>
                            </button>
                        </div>

                    </div>
                </a>
            </c:forEach>
        </div>
    </section>

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


<script src="${pageContext.request.contextPath}/js/header.js"></script>
<script src="${pageContext.request.contextPath}/js/flashSale.js"></script>
<script src="${pageContext.request.contextPath}/js/dualBannerSlideshow.js"></script>

</body>

</html>
