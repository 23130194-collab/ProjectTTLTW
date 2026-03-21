<%@ page import="com.example.demo1.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm | TechNova</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sanPham.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">

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
    <div class="all">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home" class="path">Trang chủ</a>
            <span class="separator">/</span>
            <a href="list-product?id=${category.id}" class="path">${category.name}</a>
            <span class="separator">/</span>
            <span>${p.name}</span>
        </div>

        <div class="product-container">

            <div class="product-left">
                <h2>${p.name}</h2>
                <div class="product-actions">
                    <a href="${pageContext.request.contextPath}/toggle-favorite?id=${p.id}" class="action-item like-btn"
                       style="text-decoration: none; border: none; background: none; color: #d70018;">
                        <c:choose>
                            <c:when test="${p.favorite}">
                                <i class="fa-solid fa-heart"></i>
                                <span class="action-label">Yêu thích</span>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-regular fa-heart"></i>
                                <span class="action-label">Yêu thích</span>
                            </c:otherwise>
                        </c:choose>
                    </a>

                    <span class="separator">|</span>

                    <button class="action-item spec-btn">
                        <i class="fa-solid fa-list"></i>
                        <span class="action-label">Thông số</span>
                    </button>

                    <span class="separator">|</span>

                    <div class="action-item rating">
                        <div class="stars-container">
                            <div class="stars-outer">
                                <div class="stars-inner" style="width: ${ (p.avgRating * 1.0 / 5) * 100 }%;"></div>
                            </div>
                        </div>
                        <span class="rating-value">${p.avgRating}</span>
                    </div>
                </div>

                <div class="product-image">
                    <img src="${p.image}" alt="${p.name}" id="main-product-img">
                </div>

                <div class="thumbnail-section slider-container" id="thumbnail-slider">
                    <button class="thumb-nav prev-btn">❮</button>
                    <button class="thumb-nav next-btn">❯</button>

                    <div class="thumbnails-wrapper slides-wrapper">
                        <img src="${p.image}" class="active" data-main-img="${p.image}">

                        <c:forEach items="${images}" var="img">
                            <img src="${img.image}" data-main-img="${img.image}">
                        </c:forEach>
                    </div>

                </div>

            </div>

            <div class="product-right">
                <div class="price-box">
                    <h4>Giá sản phẩm</h4>
                    <div class="price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</div>
                    <c:if test="${p.discountValue > 0}">
                        <div class="old-price"><fmt:formatNumber value="${p.oldPrice}" pattern="#,###"/>đ</div>
                    </c:if>
                </div>

                <div class="shipping-box">
                    <i class="fa-solid fa-truck"></i>
                    Thông tin vận chuyển: <span>Miễn phí vận chuyển đơn hàng</span>
                </div>

                <div class="buy-box">
                    <a href="AddCart?action=buyNow&id=${p.id}" class="btn-buy" role="button">MUA NGAY</a>

                    <a href="AddCart?action=add&id=${p.id}" class="btn-cart" role="button">
                        <i class="fa-solid fa-cart-shopping"></i> Thêm vào giỏ hàng
                    </a>
                </div>
            </div>
        </div>

        <div id="spec-modal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Thông số</h2>
                    <button id="close-spec-modal" class="close-btn">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="spec-section">
                        <h3>Thông số kỹ thuật</h3>
                        <div class="spec-items">
                            <c:forEach items="${specs}" var="s">
                                <div class="spec-item">
                                    <span class="spec-label">${s.attributeName}</span>
                                    <span class="spec-value">${s.specValue}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    <hr class="spec-hr">
                    <div class="spec-section">
                        <h3>Thông tin hãng</h3>
                        <div class="spec-items">
                            <div class="spec-item">
                                <span class="spec-label">Hãng sản xuất</span>
                                <span class="spec-value">${brand.name}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="product-description">
            <h3 class="section-title">Giới thiệu sản phẩm</h3>

            <div class="description-content">
                <p>${p.description}</p>
            </div>
        </div>

        <div class="related-products-section">
            <h3 class="section-title">Có thể bạn cũng thích</h3>

            <div class="product-grid">
                <c:forEach items="${relatedProducts}" var="rp">
                    <div class="product-card">
                        <c:if test="${rp.discountValue > 0}">
                            <div class="discount-tag">
                                <span class="discount-percent">-<fmt:formatNumber value="${rp.discountValue}"
                                                                                  pattern="#"/>%</span>
                            </div>
                        </c:if>

                        <a href="product-detail?id=${rp.id}" class="product-link">
                            <img src="${rp.image}" alt="${rp.name}" class="product-image">
                            <h3 class="product-title">${rp.name}</h3>
                            <div class="price-section">
                                <div class="current-price"><fmt:formatNumber value="${rp.price}" pattern="#,###"/>đ
                                </div>
                                <c:if test="${rp.discountValue > 0}">
                                    <div class="original-price"><fmt:formatNumber value="${rp.oldPrice}"
                                                                                  pattern="#,###"/>đ
                                    </div>
                                </c:if>
                            </div>
                        </a>

                        <div class="product-footer-interaction">
                            <div class="action-item rating">
                                <div class="stars-container">
                                    <div class="stars-outer">
                                        <div class="stars-inner"
                                             style="width: ${ (rp.avgRating * 1.0 / 5) * 100 }%;"></div>
                                    </div>
                                </div>
                                <span class="rating-value"><fmt:formatNumber value="${rp.avgRating}"
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
                </c:forEach>
            </div>
        </div>

        <div class="product-reviews-section">
            <div class="reviews-header">
                <h3 class="section-title">Đánh giá ${p.name}</h3>
            </div>

            <div class="reviews-summary">
                <div class="overall-rating">
                    <div class="rating-number">${p.avgRating}<span>/5</span></div>

                    <div class="rating-stars">
                        <div class="stars-outer">
                            <div class="stars-inner" style="width: ${ (p.avgRating * 1.0 / 5) * 100 }%;"></div>
                        </div>
                    </div>
                    <div class="rating-count">${reviewSummary.totalReviews} lượt đánh giá</div>

                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <button class="btn-write-review" id="btn-write-review">Viết đánh giá</button>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn-write-review">Viết đánh
                                giá</a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="rating-distribution">
                    <c:forEach var="star" begin="0" end="4">
                        <c:set var="starLevel" value="${5 - star}"/>
                        <div class="rating-bar-item">
                            <span class="star-label">${starLevel} <i class="fa-solid fa-star"></i></span>
                            <div class="bar-container">
                                <div class="bar-fill"
                                     style="width: ${reviewSummary.starPercentages[starLevel.toString()]}%"></div>
                            </div>

                            <span class="rating-count-label">
                                ${reviewSummary.starCounts[starLevel.toString()]} đánh giá
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="reviews-filter">
                <input type="radio" name="review-filter" id="filter-all" class="filter-input" value="0" checked>
                <label for="filter-all" class="filter-btn">Tất cả</label>

                <input type="radio" name="review-filter" id="filter-5star" class="filter-input" value="5">
                <label for="filter-5star" class="filter-btn">5 sao</label>

                <input type="radio" name="review-filter" id="filter-4star" class="filter-input" value="4">
                <label for="filter-4star" class="filter-btn">4 sao</label>

                <input type="radio" name="review-filter" id="filter-3star" class="filter-input" value="3">
                <label for="filter-3star" class="filter-btn">3 sao</label>

                <input type="radio" name="review-filter" id="filter-2star" class="filter-input" value="2">
                <label for="filter-2star" class="filter-btn">2 sao</label>

                <input type="radio" name="review-filter" id="filter-1star" class="filter-input" value="1">
                <label for="filter-1star" class="filter-btn">1 sao</label>
            </div>


            <div class="reviews-list">
                <c:forEach items="${reviews}" var="r">
                    <div class="review-item" data-rating="${r.rating}">
                        <div class="reviewer-avatar">
                                ${(not empty r.userName and r.userName.length() > 0) ? r.userName.substring(0, 1) : 'U'}
                        </div>

                        <div class="review-content">
                            <div class="reviewer-name">
                                    ${not empty r.userName ? r.userName : 'Người dùng ẩn danh'}
                            </div>

                            <div class="review-rating">
                                <c:forEach var="i" begin="1" end="5">
                                    <i class="fa-solid fa-star ${r.rating >= i ? 'star-active' : 'star-grey'}"></i>
                                </c:forEach>
                                <span class="rating-label-text">
                        <c:choose>
                            <c:when test="${r.rating >= 5}">Tuyệt vời</c:when>
                            <c:when test="${r.rating >= 4}">Tốt</c:when>
                            <c:when test="${r.rating >= 3}">Bình thường</c:when>
                            <c:when test="${r.rating >= 2}">Tệ</c:when>
                            <c:otherwise>Rất tệ</c:otherwise>
                        </c:choose>
                    </span>
                            </div>

                            <div class="review-text">${r.content}</div>

                            <div class="review-time">
                                <i class="fa-regular fa-clock"></i>
                                Đánh giá đã đăng vào: <fmt:formatDate value="${r.createdAt}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${reviews.size() >= 5}">
                <button class="btn-see-more">Xem thêm đánh giá <i class="fa-solid fa-chevron-down"></i></button>
            </c:if>
        </div>

        <div id="review-modal" class="modal">
            <div class="modal-content review-modal-content">
                <div class="modal-header">
                    <h2>Đánh giá & nhận xét</h2>
                    <button id="close-review-modal" class="close-btn">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="review-product-info">
                        <img src="${p.image}"
                             alt="RAM Kingston" class="review-product-img">
                        <div class="review-product-name">${p.name}</div>
                    </div>

                    <form id="form-review-product" action="submit-review" method="post">
                        <input type="hidden" name="productId" value="${p.id}">
                        <div class="review-rating-select">
                            <h4>Đánh giá chung</h4>

                            <div class="rating-options">
                                <input type="radio" name="rating" id="rate1" value="1" class="rating-input">
                                <label for="rate1" class="rating-option">
                                    <i class="fa-solid fa-star"></i>
                                    <span>Rất tệ</span>
                                </label>

                                <input type="radio" name="rating" id="rate2" value="2" class="rating-input">
                                <label for="rate2" class="rating-option">
                                    <i class="fa-solid fa-star"></i>
                                    <span>Tệ</span>
                                </label>

                                <input type="radio" name="rating" id="rate3" value="3" class="rating-input">
                                <label for="rate3" class="rating-option">
                                    <i class="fa-solid fa-star"></i>
                                    <span>Bình thường</span>
                                </label>

                                <input type="radio" name="rating" id="rate4" value="4" class="rating-input">
                                <label for="rate4" class="rating-option">
                                    <i class="fa-solid fa-star"></i>
                                    <span>Tốt</span>
                                </label>

                                <input type="radio" name="rating" id="rate5" value="5" class="rating-input" checked>
                                <label for="rate5" class="rating-option">
                                    <i class="fa-solid fa-star"></i>
                                    <span>Tuyệt vời</span>
                                </label>
                            </div>
                        </div>
                        <div class="review-comment-box">
                            <textarea name="comment"
                                      placeholder="Xin mời chia sẻ một số cảm nhận về sản phẩm"></textarea>
                        </div>
                        <button class="btn-submit-review">GỬI ĐÁNH GIÁ</button>
                    </form>

                </div>
            </div>
        </div>
    </div>

    <div class="bottom-bar">
        <div class="bottom-bar-container">
            <div class="bottom-bar-left">
                <img src="${p.image}"
                     alt="RAM Kingston" class="bottom-bar-img">
                <div class="bottom-bar-product">${p.name}</div>
            </div>
            <div class="bottom-bar-right">
                <div class="bottom-bar-price">
                    <div class="price-current"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</div>
                    <c:if test="${p.discountValue > 0}">
                        <div class="price-old"><fmt:formatNumber value="${p.oldPrice}" pattern="#,###"/>đ</div>
                    </c:if>
                </div>
                <a href="AddCart?action=buyNow&id=${p.id}"
                   class="btn-buy-now js-buy-now"
                   role="button">
                    MUA NGAY
                </a>


                <a href="AddCart?action=add&id=${p.id}"
                   class="btn-add-cart js-add-cart"
                   role="button">
                    <i class="fa-solid fa-cart-shopping"></i>
                </a>
            </div>
        </div>
    </div>

    <button class="btn-scroll-top" id="btn-scroll-top">
        Lên đầu <i class="fa-solid fa-chevron-up"></i>
    </button>
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

<script>
    const globalContextPath = "${pageContext.request.contextPath}";
</script>

<script src="${pageContext.request.contextPath}/js/header.js"></script>
<script src="${pageContext.request.contextPath}/js/sanPham.js"></script>
</body>

</html>