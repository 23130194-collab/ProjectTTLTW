<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - Quản lý Đơn hàng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/adminOrders.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
</head>
<body>

<aside class="sidebar">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" style="text-decoration: none;">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
            <span class="logo-text">TechNova</span>
        </a>
    </div>
    <ul class="nav-menu">
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link active"><span class="nav-icon"><i class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-star"></i></span>Đánh giá</a></li>

    </ul>
    <div class="logout-section">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
    </div>
</aside>

<header class="header">
    <div class="header-actions">
        <button class="notification-btn" id="notificationBtn">
            <i class="fa-solid fa-bell"></i>
        </button>

        <div class="user-profile">
            <img src="https://www.shutterstock.com/image-vector/admin-icon-strategy-collection-thin-600nw-2307398667.jpg"
                 alt="User Profile">
        </div>
    </div>
</header>

<main class="main-content">
    <div class="content-area">
        <h1 class="page-title">Quản lý Đơn hàng</h1>
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/admin/adminDashboard">Trang chủ</a> / <span>Đơn hàng</span></div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="order-tools">
            <form action="${pageContext.request.contextPath}/admin/orders" method="get" class="search-form">
                <input type="text" name="keyword" placeholder="Tìm kiếm theo mã đơn..." value="${keyword}" class="search-input"/>
                <button type="submit" class="search-button">Tìm kiếm</button>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                <tr>
                    <th>Mã đơn</th>
                    <th>Ngày đặt</th>
                    <th>Thành tiền</th>
                    <th>Trạng thái</th>
                    <th style="width: 120px;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td><a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.id}" class="order-code">${order.orderCode}</a></td>
                        <td><fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy"/></td>
                        <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ"/></td>
                        <td>
                            <c:set var="statusClass" value=""/>
                            <c:choose>
                                <c:when test="${order.orderStatus == 'Chờ xác nhận'}"><c:set var="statusClass" value="status-pending"/></c:when>
                                <c:when test="${order.orderStatus == 'Đang xử lý'}"><c:set var="statusClass" value="status-processing"/></c:when>
                                <c:when test="${order.orderStatus == 'Đang giao'}"><c:set var="statusClass" value="status-shipped"/></c:when>
                                <c:when test="${order.orderStatus == 'Đã giao'}"><c:set var="statusClass" value="status-delivered"/></c:when>
                                <c:when test="${order.orderStatus == 'Đã hủy'}"><c:set var="statusClass" value="status-cancelled"/></c:when>
                            </c:choose>
                            <span class="badge ${statusClass}">${order.orderStatus}</span>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.id}" class="action-btn view" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty orders}">
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 20px;">Không tìm thấy đơn hàng nào.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/admin/orders?page=${currentPage - 1}&keyword=${keyword}" class="pagination-btn"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${pageContext.request.contextPath}/admin/orders?page=${i}&keyword=${keyword}" class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/admin/orders?page=${currentPage + 1}&keyword=${keyword}" class="pagination-btn"><i class="fa-solid fa-chevron-right"></i></a>
                </c:if>
            </div>
        </c:if>
    </div>
</main>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });
    });
</script>

<div id="logoutConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelLogout">Hủy</a>
            <a href="${contextPath}/logout" class="modal-btn modal-confirm">Đăng xuất</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
            logoutLink.addEventListener('click', function(e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });

            cancelLogoutBtn.addEventListener('click', function(e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });

            logoutConfirmModal.addEventListener('click', function(e) {
                if (e.target === logoutConfirmModal) {
                    logoutConfirmModal.classList.remove('show');
                }
            });
        }
    });
</script>
</body>
</html>