<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Voucher của tôi | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
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

        <div class="search-box" style="position: relative; overflow: visible;">
            <form action="search" method="get" id="searchForm" style="display: flex; width: 100%;">
                <input type="text" name="keyword" id="searchInput" autocomplete="off" placeholder="Bạn muốn mua gì...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
            <div id="suggestion-box" class="suggestion-box"></div>
        </div>

        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="icon-btn cart-btn-wrapper" title="Giỏ hàng">
                <i class="fas fa-shopping-cart"></i>
                <c:if test="${not empty requestScope.cartItems}">
                    <span class="cart-badge">${fn:length(requestScope.cartItems)}</span>
                </c:if>
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
                <a href="${pageContext.request.contextPath}/favorites" class="menu-item">
                    <i class="fa-regular fa-heart icon"></i>
                    <span class="label">Sản phẩm yêu thích</span>
                </a>
                <a href="${pageContext.request.contextPath}/account" class="menu-item">
                    <i class="fa-regular fa-user icon"></i>
                    <span class="label">Thông tin tài khoản</span>
                </a>
                <a href="${pageContext.request.contextPath}/vouchers" class="menu-item active">
                    <i class="fa-solid fa-ticket icon"></i>
                    <span class="label">Voucher của tôi</span>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="menu-item">
                    <i class="fa-solid fa-right-from-bracket icon"></i>
                    <span class="label">Đăng xuất</span>
                </a>
            </nav>
        </aside>

        <section class="content">
            <div class="voucher-page-header">
                <h2>Voucher của tôi</h2>
            </div>

            <c:if test="${not empty sessionScope.voucherSuccess}">
                <div class="voucher-alert voucher-alert-success">
                    <span>${sessionScope.voucherSuccess}</span>
                    <button type="button" class="voucher-alert-close" aria-label="Đóng">&times;</button>
                </div>
                <c:remove var="voucherSuccess" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.voucherError}">
                <div class="voucher-alert voucher-alert-error">
                    <span>${sessionScope.voucherError}</span>
                    <button type="button" class="voucher-alert-close" aria-label="Đóng">&times;</button>
                </div>
                <c:remove var="voucherError" scope="session"/>
            </c:if>

            <div class="voucher-grid">
                <c:choose>
                    <c:when test="${empty vouchers}">
                        <div class="empty-voucher-state">
                            <i class="fa-solid fa-ticket"></i>
                            <span>Hiện chưa có voucher khả dụng.</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="voucher" items="${vouchers}">
                            <div class="voucher-card ${voucher.used ? 'is-used' : ''}">
                                <div class="voucher-main">
                                    <div class="voucher-code" style="margin-bottom: 8px;">${voucher.code} - <span style="color: #111827;">Giảm <fmt:formatNumber value="${voucher.discountValue}" pattern="#,###"/>đ</span></div>
                                    <div class="voucher-info-line" style="font-size: 14px; color: #475569; margin-bottom: 6px;">Đơn tối thiểu: <strong style="color: #111827;"><fmt:formatNumber value="${voucher.minOrderValue}" pattern="#,###"/>đ</strong></div>
                                    <div class="voucher-info-line" style="font-size: 14px; color: #475569; margin-bottom: 6px;">Số lượng: <strong style="color: #ef4444;">${voucher.quantity - voucher.usedCount} lượt</strong></div>
                                    <div class="voucher-info-line" style="font-size: 13px; color: #64748b;">Hạn dùng: <fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                                </div>
                                <div class="voucher-action">
                                    <c:choose>
                                        <c:when test="${voucher.used}">
                                            <span class="voucher-status used">Đã dùng</span>
                                        </c:when>
                                        <c:when test="${voucher.saved}">
                                            <span class="voucher-status saved">Đã lưu</span>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/vouchers" method="post">
                                                <input type="hidden" name="voucherId" value="${voucher.id}">
                                                <button type="submit" class="save-voucher-btn">Lưu</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </div>
</div>

<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/header.js"></script>
<script src="${pageContext.request.contextPath}/js/searchSuggestion.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.voucher-alert').forEach(function (alert) {
            const closeBtn = alert.querySelector('.voucher-alert-close');
            if (closeBtn) {
                closeBtn.addEventListener('click', function () {
                    alert.style.display = 'none';
                });
            }
            setTimeout(function () {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });
    });
</script>
</body>
</html>
