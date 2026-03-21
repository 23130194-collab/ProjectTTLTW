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
    <title>TechNova Admin - Chi tiết hóa đơn</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/adminOrderDetails.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
</head>
<body>

<aside class="sidebar">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/admin/adminDashboard" style="text-decoration: none;">
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
        <a href="${pageContext.request.contextPath}/admin/orders" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty orderDetail}">
            <div class="invoice-container">
                <header class="invoice-header">
                    <div><span class="invoice-logo">TechNova</span></div>
                    <div class="invoice-header-right">
                        <h2>Chi tiết hoá đơn</h2>
                        <span class="invoice-order-id">Đơn hàng ${orderDetail.order.orderCode}</span>
                    </div>
                </header>

                <section class="invoice-meta">
                    <div class="meta-column">
                        <strong>Khách hàng:</strong>
                        <address>${orderDetail.customer.name}<br/>${orderDetail.customer.address}</address>
                    </div>
                    <div class="meta-column">
                        <strong>Thông tin người nhận:</strong>
                        <address>${orderDetail.customer.name}<br/>${orderDetail.customer.phone}<br/>${orderDetail.customer.address}</address>
                        <div>${orderDetail.customer.email}</div>
                    </div>
                    <div class="meta-column">
                        <strong>Phương thức thanh toán:</strong>
                        <div>Tiền mặt</div>
                        <br/>
                        <strong>Ngày đặt hàng:</strong>
                        <div>
                            <fmt:formatDate value="${orderDetail.order.createdAt}" pattern="HH:mm"/><br/>
                            <fmt:formatDate value="${orderDetail.order.createdAt}" pattern="dd/MM/yyyy"/>
                        </div>
                    </div>
                </section>

                <div class="current-status-badge">
                    <c:set var="statusClass" value=""/>
                    <c:choose>
                        <c:when test="${orderDetail.order.orderStatus == 'Chờ xác nhận'}"><c:set var="statusClass" value="status-pending"/></c:when>
                        <c:when test="${orderDetail.order.orderStatus == 'Đang xử lý'}"><c:set var="statusClass" value="status-processing"/></c:when>
                        <c:when test="${orderDetail.order.orderStatus == 'Đang giao'}"><c:set var="statusClass" value="status-shipped"/></c:when>
                        <c:when test="${orderDetail.order.orderStatus == 'Đã giao'}"><c:set var="statusClass" value="status-delivered"/></c:when>
                        <c:when test="${orderDetail.order.orderStatus == 'Đã hủy'}"><c:set var="statusClass" value="status-cancelled"/></c:when>
                    </c:choose>
                    Trạng thái hiện tại: <span class="badge ${statusClass}">${orderDetail.order.orderStatus}</span>
                </div>

                <section class="order-status-section">
                    <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="status-update-container" id="updateStatusForm">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="orderId" value="${orderDetail.order.id}">
                        <label for="orderStatus">Cập nhật trạng thái:</label>
                        <select id="orderStatus" name="orderStatus">
                            <option value="Chờ xác nhận" ${orderDetail.order.orderStatus == 'Chờ xác nhận' ? 'selected' : ''}>Chờ xác nhận</option>
                            <option value="Đang xử lý" ${orderDetail.order.orderStatus == 'Đang xử lý' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="Đang giao" ${orderDetail.order.orderStatus == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                            <option value="Đã giao" ${orderDetail.order.orderStatus == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                            <option value="Đã hủy" ${orderDetail.order.orderStatus == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                        <a href="#confirm-status-update-modal" class="update-status-btn open-modal-btn">Cập nhật</a>
                    </form>
                </section>

                <table class="invoice-items-table">
                    <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá gốc</th>
                        <th>% Giảm giá</th>
                        <th>Số lượng</th>
                        <th>Tổng tiền</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${orderDetail.items}" varStatus="loop">
                        <tr>
                            <td>${loop.count}</td>
                            <td><strong>${item.productName}</strong></td>
                            <td><fmt:formatNumber value="${item.originalPrice}" type="currency" currencySymbol="đ"/></td>
                            <td><fmt:formatNumber value="${item.discountPercentage / 100}" type="percent"/></td>
                            <td>${item.quantity}</td>
                            <td><fmt:formatNumber value="${item.total}" type="currency" currencySymbol="đ"/></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <section class="invoice-summary">
                    <div class="summary-details">
                        <div><span>Tổng tiền hàng</span> <span><fmt:formatNumber value="${orderDetail.order.subprice}" type="currency" currencySymbol="đ"/></span></div>
                        <div><span>Phí vận chuyển</span> <span><fmt:formatNumber value="${orderDetail.order.shippingFee}" type="currency" currencySymbol="đ"/></span></div>
                        <div><span>Giảm giá</span> <span>-<fmt:formatNumber value="${orderDetail.order.discountAmount}" type="currency" currencySymbol="đ"/></span></div>
                        <div class="summary-total">
                            <strong>Tổng thanh toán</strong>
                            <strong><fmt:formatNumber value="${orderDetail.order.totalAmount}" type="currency" currencySymbol="đ"/></strong>
                        </div>
                    </div>
                </section>

                <footer class="invoice-footer">
                    <div class="invoice-notes">
                        <strong>Ghi chú của khách hàng:</strong>
                        <p>${not empty orderDetail.order.notes ? orderDetail.order.notes : 'Không có ghi chú.'}</p>
                    </div>
                </footer>
            </div>
        </c:if>
        <c:if test="${empty orderDetail}">
            <p style="text-align: center;">Không tìm thấy thông tin chi tiết cho đơn hàng này hoặc đơn hàng đã bị xóa.</p>
        </c:if>
    </div>
</main>

<div id="confirm-status-update-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận cập nhật trạng thái</h3>
        <p>Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="updateStatusForm" class="modal-btn modal-confirm">Cập nhật</button>
        </div>
    </div>
</div>

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
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            setTimeout(function() {
                alert.style.opacity = '0';
                setTimeout(function() {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });

        document.querySelectorAll('.open-modal-btn').forEach(button => {
            button.addEventListener('click', function(event) {
                event.preventDefault();
                const modalId = this.getAttribute('href');
                document.querySelector(modalId).classList.add('show');
            });
        });

        document.querySelectorAll('.modal-cancel').forEach(button => {
            button.addEventListener('click', function(event) {
                event.preventDefault();
                this.closest('.modal-overlay').classList.remove('show');
            });
        });

        document.querySelectorAll('.modal-overlay').forEach(overlay => {
            overlay.addEventListener('click', function(event) {
                if (event.target === this) {
                    this.classList.remove('show');
                }
            });
        });

        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');
        if(logoutLink) {
            logoutLink.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });
        }
        if(cancelLogoutBtn) {
            cancelLogoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });
        }
        if(logoutConfirmModal) {
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