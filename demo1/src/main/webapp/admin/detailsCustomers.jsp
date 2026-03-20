<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - Chi tiết khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/customersList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/detailsCustomers.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
</head>

<body>

<aside class="sidebar">
    <div class="logo">
        <a href="${contextPath}/admin/dashboard">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
        </a>
        <a href="${contextPath}/admin/dashboard" style="text-decoration: none;">
            <span class="logo-text">TechNova</span>
        </a>
    </div>
    <ul class="nav-menu">
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>

    </ul>
    <div class="logout-section"><a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span
            class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a></div>
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
        <h1 class="page-title">Chi tiết khách hàng</h1>
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/adminDashboard">Trang chủ</a> / <a
                href="${pageContext.request.contextPath}/admin/customers">Danh sách khách hàng</a> / <span>Chi tiết khách hàng</span>
        </div>

        <c:if test="${not empty customer}">
            <section class="personal-info">
                <div class="info-card" id="infoView">
                    <div class="info-header">
                        <h2>Thông tin cá nhân</h2>
                    </div>
                    <div class="info-body">
                        <div class="info-row">
                            <span>Họ và tên:</span>
                            <p id="name">${customer.name}</p>
                            <span>Số điện thoại:</span>
                            <p id="phone">${customer.phone}</p>
                        </div>
                        <div class="info-row">
                            <span>Giới tính:</span>
                            <p id="gender">${customer.gender}</p>
                            <span>Email:</span>
                            <p id="email">${customer.email}</p>
                        </div>
                        <div class="info-row">
                            <span>Ngày sinh:</span>
                            <p id="dob">${customer.birthday}</p>
                            <span>Địa chỉ:</span>
                            <p id="address">${customer.address}</p>
                        </div>
                    </div>
                </div>
            </section>

            <div class="customer-detail">
                <div class="orders-section">
                    <div class="orders-header">
                        <h3>Lịch sử đơn hàng</h3>
                    </div>

                    <table class="orders-table">
                        <thead>
                        <tr>
                            <th>Mã đơn hàng</th>
                            <th>Ngày đặt hàng</th>
                            <th>Trạng thái</th>
                            <th>Tổng tiền</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty orderList}">
                            <tr>
                                <td colspan="4" style="text-align: center;">Khách hàng chưa có đơn hàng nào.</td>
                            </tr>
                        </c:if>

                        <c:forEach var="order" items="${orderList}">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.id}">
                                            ${order.orderCode}
                                    </a>
                                </td>

                                <td>
                                    <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 'Hoàn thành'}">
                                            <span class="status completed">${order.orderStatus}</span>
                                        </c:when>
                                        <c:when test="${order.orderStatus == 'Đã hủy'}">
                                            <span class="status canceled">${order.orderStatus}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status pending">${order.orderStatus}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ"/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
                <c:if test="${totalPages > 1}">
                    <div class="pagination-container">
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${customer.id}&page=${currentPage - 1}"
                               class="pagination-btn">
                                <i class="fa-solid fa-chevron-left"></i>
                            </a>
                        </c:if>

                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${customer.id}&page=${i}"
                               class="page-number ${i == currentPage ? 'active' : ''}">
                                    ${i}
                            </a>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${customer.id}&page=${currentPage + 1}"
                               class="pagination-btn">
                                <i class="fa-solid fa-chevron-right"></i>
                            </a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </c:if>
        <c:if test="${empty customer}">
            <p>Không tìm thấy khách hàng.</p>
        </c:if>


    </div>
</main>

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

<script src="${pageContext.request.contextPath}/admin/adminjs/adminHoaDon.js"></script>

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