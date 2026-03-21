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
    <title>${category.name} | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mucSanPham.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
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
<div class="page-header-wrapper">
    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home" class="path">Trang chủ</a>
            <span class="separator">/</span>
            <a href="list-product?id=${category.id}" class="path">${category.name}</a>
        </div>

        <div class="banners-container">

            <div class="banner-link slider-container" id="banner-left">
                <button class="slider-nav prev-btn">❮</button>
                <button class="slider-nav next-btn">❯</button>

                <div class="slides-wrapper">
                    <c:forEach items="${leftBanners}" var="banner">
                        <a href="#"><img src="${banner.image}" class="banner-img" alt="${banner.name}"></a>
                    </c:forEach>
                </div>
                <div class="dots-container"></div>
            </div>

            <div class="banner-link slider-container" id="banner-right">
                <button class="slider-nav prev-btn">❮</button>
                <button class="slider-nav next-btn">❯</button>

                <div class="slides-wrapper">
                    <c:forEach items="${rightBanners}" var="banner">
                        <a href="#"><img src="${banner.image}" class="banner-img" alt="${banner.name}"></a>
                    </c:forEach>
                </div>
                <div class="dots-container"></div>
            </div>
        </div>
    </div>
</div>

<main class="container">
    <h1 class="page-title">${category.name}</h1>

    <div class="brand-filter">
        <c:forEach items="${brandList}" var="brand">
            <c:choose>
                <c:when test="${selectedBrandId == brand.id}">
                    <a href="list-product?id=${category.id}" class="brand-logo active">
                        <img src="${brand.logo}" alt="${brand.name}">
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="list-product?id=${category.id}&brandId=${brand.id}" class="brand-logo">
                        <img src="${brand.logo}" alt="${brand.name}">
                    </a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>

    <h1 class="page-title">Chọn theo tiêu chí</h1>

    <div class="filter-toggle-container">
        <button class="filter-toggle-btn" id="filterToggleBtn">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M6 10.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5zm-2-3a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm-2-3a.5.5 0 0 1 .5-.5h11a.5.5 0 0 1 0 1h-11a.5.5 0 0 1-.5-.5z"/>
            </svg>
            Bộ lọc
        </button>
    </div>

    <form action="list-product" method="POST">
        <input type="hidden" name="id" value="${category.id}">
        <c:if test="${not empty selectedBrandId}">
            <input type="hidden" name="brandId" value="${selectedBrandId}">
        </c:if>

        <div class="filter-section">
            <c:forEach var="entry" items="${filterableAttributes}">
                <div class="option-group">
                    <h4 class="group-title">${entry.key.name}</h4>
                    <div class="options-grid">
                        <c:forEach var="value" items="${entry.value}">
                            <c:set var="isChecked" value="${false}"/>
                            <c:if test="${not empty selectedSpecs[entry.key.id]}">
                                <c:forEach var="selectedValue" items="${selectedSpecs[entry.key.id]}">
                                    <c:if test="${selectedValue eq value}">
                                        <c:set var="isChecked" value="${true}"/>
                                    </c:if>
                                </c:forEach>
                            </c:if>
                            <input type="checkbox" id="spec-${entry.key.id}-${value}" name="spec_${entry.key.id}"
                                   value="${value}" ${isChecked ? 'checked' : ''}>
                            <label for="spec-${entry.key.id}-${value}" class="option-label">${value}</label>
                        </c:forEach>
                    </div>
                </div>
            </c:forEach>

            <div class="action-bar">
                <a href="list-product?id=${category.id}&brand?id=${selectedBrandId}" class="cancel-button"
                   style="text-decoration: none;">Bỏ lọc</a>
                <button type="submit" class="confirm-button">Xem kết quả</button>
            </div>
        </div>
    </form>

    <div class="applied-filters-container">
        <c:if test="${not empty selectedSpecs}">
            <span class="page-title">Đang lọc theo:</span>
            <div class="applied-filters-list">
                <c:forEach var="specGroup" items="${selectedSpecs}">
                    <c:forEach var="specValue" items="${specGroup.value}">
                        <c:url var="removeUrl" value="list-product">
                            <c:param name="id" value="${category.id}"/>
                            <c:if test="${not empty selectedBrandId}">
                                <c:param name="brandId" value="${selectedBrandId}"/>
                            </c:if>
                            <c:forEach var="otherGroup" items="${selectedSpecs}">
                                <c:forEach var="otherValue" items="${otherGroup.value}">
                                    <c:if test="${not (otherGroup.key == specGroup.key and otherValue == specValue)}">
                                        <c:param name="spec_${otherGroup.key}" value="${otherValue}"/>
                                    </c:if>
                                </c:forEach>
                            </c:forEach>
                        </c:url>

                        <div class="applied-filter-tag">
                            <span>${specValue}</span>
                            <a href="${removeUrl}" class="remove-filter-btn">&times;</a>
                        </div>
                    </c:forEach>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <div class="sort-wrapper">
        <h1 class="page-title">Sắp xếp theo</h1>
        <div class="sort-buttons">
            <c:url var="baseUrl" value="list-product">
                <c:param name="id" value="${category.id}"/>
                <c:if test="${not empty selectedBrandId}">
                    <c:param name="brandId" value="${selectedBrandId}"/>
                </c:if>
                <c:forEach var="specGroup" items="${selectedSpecs}">
                    <c:forEach var="specValue" items="${specGroup.value}">
                        <c:param name="spec_${specGroup.key}" value="${specValue}"/>
                    </c:forEach>
                </c:forEach>
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
            <div class="product-card" data-product="Core i5" data-generation="Intel thế hệ 12" data-socket="LGA 1700"
                 data-core="6">
                <c:if test="${p.discountValue > 0}">
                    <div class="discount-tag">
                        <span class="discount-percent">-<fmt:formatNumber value="${p.discountValue}"
                                                                          pattern="#"/>%</span>
                    </div>
                </c:if>
                <a href="product-detail?id=${p.id}" class="product-link">
                    <img src="${p.image}" alt="${p.name}" class="product-image">
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
                                <div class="stars-inner" style="width: ${ (p.avgRating * 1.0 / 5) * 100 }%;"></div>
                            </div>
                        </div>
                        <span class="rating-value"><fmt:formatNumber value="${p.avgRating}" pattern="0.0"/></span>
                    </div>

                    <a href="${pageContext.request.contextPath}/toggle-favorite?id=${p.id}" class="action-item like-btn"
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

    <c:if test="${totalPages > 1}">
        <div class="pagination-container">
            <c:url var="prevUrl" value="list-product">
                <c:param name="id" value="${category.id}"/>
                <c:if test="${not empty selectedBrandId}"><c:param name="brandId" value="${selectedBrandId}"/></c:if>
                <c:if test="${not empty selectedSortOrder}"><c:param name="sort" value="${selectedSortOrder}"/></c:if>
                <c:forEach var="specGroup" items="${selectedSpecs}"><c:forEach var="specValue"
                                                                               items="${specGroup.value}"><c:param
                        name="spec_${specGroup.key}" value="${specValue}"/></c:forEach></c:forEach>
                <c:param name="page" value="${currentPage - 1}"/>
            </c:url>
            <a href="${currentPage > 1 ? prevUrl : '#'}" class="pagination-btn ${currentPage == 1 ? 'disabled' : ''}">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
                </svg>
            </a>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:url var="pageUrl" value="list-product">
                    <c:param name="id" value="${category.id}"/>
                    <c:if test="${not empty selectedBrandId}"><c:param name="brandId"
                                                                       value="${selectedBrandId}"/></c:if>
                    <c:if test="${not empty selectedSortOrder}"><c:param name="sort"
                                                                         value="${selectedSortOrder}"/></c:if>
                    <c:forEach var="specGroup" items="${selectedSpecs}"><c:forEach var="specValue"
                                                                                   items="${specGroup.value}"><c:param
                            name="spec_${specGroup.key}" value="${specValue}"/></c:forEach></c:forEach>
                    <c:param name="page" value="${i}"/>
                </c:url>
                <a href="${pageUrl}" class="page-number ${currentPage == i ? 'active' : ''}">${i}</a>
            </c:forEach>

            <c:url var="nextUrl" value="list-product">
                <c:param name="id" value="${category.id}"/>
                <c:if test="${not empty selectedBrandId}"><c:param name="brandId" value="${selectedBrandId}"/></c:if>
                <c:if test="${not empty selectedSortOrder}"><c:param name="sort" value="${selectedSortOrder}"/></c:if>
                <c:forEach var="specGroup" items="${selectedSpecs}"><c:forEach var="specValue"
                                                                               items="${specGroup.value}"><c:param
                        name="spec_${specGroup.key}" value="${specValue}"/></c:forEach></c:forEach>
                <c:param name="page" value="${currentPage + 1}"/>
            </c:url>
            <a href="${currentPage < totalPages ? nextUrl : '#'}"
               class="pagination-btn ${currentPage == totalPages ? 'disabled' : ''}">
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path fill-rule="evenodd"
                          d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z"/>
                </svg>
            </a>
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
<script src="js/boLoc.js"></script>
<script src="js/dualBannerSlideshow.js"></script>
</body>
</html>
