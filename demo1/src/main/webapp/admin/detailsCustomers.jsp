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
    <style>
        .notification-btn { position: relative; }

        .notification-badge {
            position: absolute;
            top: -5px; right: -5px;
            background: red; color: white;
            border-radius: 50%;
            width: 18px; height: 18px;
            font-size: 11px;
            display: flex; align-items: center; justify-content: center;
        }

        .notification-dropdown {
            position: absolute;
            top: 60px; right: 20px;
            width: 320px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            z-index: 9999;
            max-height: 400px;
            overflow-y: auto;
        }

        .notification-header {
            padding: 12px 16px;
            font-weight: 600;
            border-bottom: 1px solid #f0f0f0;
            font-size: 15px;
        }

        .notification-item {
            display: flex;
            align-items: flex-start;
            padding: 12px 16px;
            border-bottom: 1px solid #f9f9f9;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            transition: background 0.2s;
        }

        .notification-item:hover { background: #f5f5f5; }

        .notification-item.unread { background: #eff6ff; }

        .notification-item .noti-content { flex: 1; font-size: 13px; }

        .notification-item .noti-time {
            font-size: 11px;
            color: #999;
            margin-top: 4px;
        }

        .notification-empty {
            padding: 24px;
            text-align: center;
            color: #999;
            font-size: 13px;
        }
    </style>
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
        <li class="nav-item"><a href="${contextPath}/admin/vouchers" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-ticket"></i></span>Voucher</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>
    </ul>
    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink">
            <span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất
        </a>
    </div>
</aside>

<header class="header">
    <div class="header-actions">
        <button class="notification-btn" id="notificationBtn">
            <i class="fa-solid fa-bell"></i>
            <span class="notification-badge" id="notificationBadge" style="display:none"></span>
        </button>
        <div class="notification-dropdown" id="notificationDropdown" style="display:none">
            <div class="notification-header">
                <span>Thông báo</span>
            </div>
            <div class="notification-list" id="notificationList">
                <div class="notification-empty">Không có thông báo mới</div>
            </div>
        </div>

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
            <a href="${pageContext.request.contextPath}/admin/adminDashboard">Trang chủ</a> /
            <a href="${pageContext.request.contextPath}/admin/customers">Danh sách khách hàng</a> /
            <span>Chi tiết khách hàng</span>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <span><i class="fa-solid fa-circle-check"></i> <c:out value="${sessionScope.successMessage}"
                                                                      escapeXml="false"/></span>
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <span><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${sessionScope.errorMessage}"
                                                                            escapeXml="false"/></span>
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">
                <span><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${requestScope.errorMessage}"
                                                                            escapeXml="false"/></span>
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
            </div>
        </c:if>

        <c:if test="${not empty customer}">
            <section class="personal-info">
                <div class="info-card" id="infoView">
                    <div class="info-header">
                        <h2>Thông tin cá nhân</h2>
                        <button type="button" class="update-btn" onclick="toggleEditMode()">
                             Cập nhật thông tin
                        </button>
                    </div>
                    <div class="info-body">
                        <div class="info-row">
                            <span>Họ và tên:</span>
                            <p>${customer.name}</p>
                            <span>Số điện thoại:</span>
                            <p>${customer.phone}</p>
                        </div>
                        <div class="info-row">
                            <span>Giới tính:</span>
                            <p>${customer.gender}</p>
                            <span>Email:</span>
                            <p>${customer.email}</p>
                        </div>
                        <div class="info-row">
                            <span>Ngày sinh:</span>
                            <p>${customer.birthday}</p>
                            <span>Địa chỉ:</span>
                            <p>${customer.address}</p>
                        </div>
                    </div>
                </div>

                <div class="info-card hidden" id="infoEdit">
                    <form id="customerUpdateForm" action="${pageContext.request.contextPath}/admin/customer-detail"
                          method="POST">
                        <input type="hidden" name="id" value="${customer.id}">
                        <div class="info-header">
                            <h2>Cập nhật thông tin</h2>
                        </div>
                        <div class="info-body">
                            <div class="info-row">
                                <span>Họ và tên:</span>
                                <input type="text" name="name" value="${customer.name}" required>
                                <span>Số điện thoại:</span>
                                <input type="text" name="phone" id="phoneInput" value="${customer.phone}" required>
                            </div>
                            <div class="info-row">
                                <span>Giới tính:</span>
                                <select name="gender">
                                    <option value="Nam" ${customer.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${customer.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${customer.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                                <span>Email:</span>
                                <input type="email" name="email" value="${customer.email}" required>
                            </div>
                            <div class="info-row">
                                <span>Ngày sinh:</span>
                                <input type="date" name="birthday" value="${customer.birthday}">
                                <span>Địa chỉ:</span>
                                <input type="text" name="address" value="${customer.address}">
                            </div>
                        </div>
                        <div class="info-actions">
                            <button type="button" class="cancel-btn" onclick="toggleEditMode()">Hủy</button>
                            <button type="button" class="save-btn" id="saveChangeBtn">Lưu thay đổi</button>
                        </div>
                    </form>
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
                                    <a href="${pageContext.request.contextPath}/admin/orders?action=view&id=${order.id}">${order.orderCode}</a>
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
                               class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
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

<div id="updateConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận cập nhật</h3>
        <p>Bạn có chắc chắn muốn thay đổi thông tin cá nhân của khách hàng này không?</p>
        <div class="modal-buttons">
            <button type="button" class="modal-btn modal-cancel" id="cancelUpdateBtn">Hủy</button>
            <button type="button" class="modal-btn modal-confirm" id="confirmUpdateBtn"
                    style="background-color: #3b82f6;">Xác nhận
            </button>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/admin/adminjs/adminHoaDon.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const notificationBtn = document.getElementById('notificationBtn');
        const notificationDropdown = document.getElementById('notificationDropdown');
        const notificationList = document.getElementById('notificationList');
        const notificationBadge = document.getElementById('notificationBadge');

        notificationBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            const isHidden = notificationDropdown.style.display === 'none';
            notificationDropdown.style.display = isHidden ? 'block' : 'none';
            if (isHidden) {
                loadNotifications();
            }
        });

        document.addEventListener('click', function () {
            notificationDropdown.style.display = 'none';
        });

        notificationDropdown.addEventListener('click', function (e) {
            e.stopPropagation();
        });

        function markAllAdminAsRead() {
            fetch('${contextPath}/NotificationServlet', { method: 'POST' })
                .then(() => {
                    const badge = document.getElementById('notificationBadge');
                    badge.style.display = 'none';
                    badge.textContent = '0';
                    loadNotifications();
                });
        }

        function loadNotifications() {
            fetch('${contextPath}/NotificationServlet')
                .then(res => res.json())
                .then(data => {
                    if (!data || data.length === 0) {
                        notificationList.innerHTML = '<div class="notification-empty">Không có thông báo mới</div>';
                        notificationBadge.style.display = 'none';
                        return;
                    }

                    const unreadCount = data.filter(n => n.read === false || n.isRead === 0 || n.isRead === false).length;
                    notificationBadge.textContent = unreadCount;
                    notificationBadge.style.display = unreadCount > 0 ? 'flex' : 'none';

                    notificationList.innerHTML = data.map(function(n) {
                        var isUnread = n.read === false || n.isRead === 0 || n.isRead === false;
                        var unreadClass = isUnread ? 'unread' : '';
                        var link = '${contextPath}' + n.link;

                        return '<a class="notification-item ' + unreadClass + '" href="' + link + '" onclick="markAsRead(' + n.id + ', this, \'' + link + '\', event)">'
                            + '<div class="noti-content">'
                            + '<div>' + n.content + '</div>'
                            + '<div class="noti-time">' + formatTime(n.createdAt) + '</div>'
                            + '</div>'
                            + '</a>';
                    }).join('');
                })
                .catch(err => console.error('Lỗi load notification:', err));
        }

        window.markAsRead = function(id, element, link, event) {
            event.preventDefault();

            if (element.classList.contains('unread')) {
                fetch('${contextPath}/NotificationServlet?id=' + id, { method: 'POST' })
                    .then(response => {
                        if(response.ok) {
                            element.classList.remove('unread');
                            const badge = document.getElementById('notificationBadge');
                            let count = parseInt(badge.textContent) || 0;
                            count = Math.max(0, count - 1);
                            badge.textContent = count;
                            badge.style.display = count > 0 ? 'flex' : 'none';
                        }
                    })
                    .catch(err => console.error('Lỗi khi đánh dấu đã đọc: ', err))
                    .finally(() => {
                        window.location.href = link;
                    });
            } else {
                window.location.href = link;
            }
        };

        function formatTime(timestamp) {
            if (!timestamp) return '';
            const d = new Date(timestamp);
            return d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear()
                + ' ' + d.getHours() + ':' + String(d.getMinutes()).padStart(2, '0');
        }

        fetch('${contextPath}/NotificationServlet')
            .then(res => res.json())
            .then(data => {
                if (!data || data.length === 0) return;
                const unreadCount = data.filter(n => n.read === false || n.isRead === 0 || n.isRead === false).length;
                notificationBadge.textContent = unreadCount;
                notificationBadge.style.display = unreadCount > 0 ? 'flex' : 'none';
            })
            .catch(err => console.error('Lỗi load badge:', err));
    });
</script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.alert').forEach(function (alert) {
            setTimeout(function () {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });

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
                if (e.target === logoutConfirmModal) logoutConfirmModal.classList.remove('show');
            });
        }

        const updateModal = document.getElementById('updateConfirmModal');
        const saveChangeBtn = document.getElementById('saveChangeBtn');
        const cancelUpdateBtn = document.getElementById('cancelUpdateBtn');
        const confirmUpdateBtn = document.getElementById('confirmUpdateBtn');
        const updateForm = document.getElementById('customerUpdateForm');

        if (saveChangeBtn) {
            saveChangeBtn.addEventListener('click', function () {
                const phoneInput = document.getElementById('phoneInput');
                const phoneValue = phoneInput.value.trim();
                const phonePattern = /^\d{10}$/;

                if (!phonePattern.test(phoneValue)) {
                    alert("Số điện thoại phải có đúng 10 chữ số!");
                    phoneInput.focus();
                    return;
                }

                const emailInput = document.querySelector('input[name="email"]');
                const emailValue = emailInput.value.trim();
                const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailPattern.test(emailValue)) {
                    alert("Email không đúng định dạng (Ví dụ: example@gmail.com)!");
                    emailInput.focus();
                    return;
                }

                const nameInput = document.querySelector('input[name="name"]');
                const nameValue = nameInput.value.trim();
                if (!nameValue.includes(' ')) {
                    alert("Họ và tên phải bao gồm ít nhất hai từ và có dấu cách giữa chúng!");
                    nameInput.focus();
                    return;
                }

                const dobInput = document.querySelector('input[name="birthday"]');
                if (dobInput.value) {
                    const dobValue = new Date(dobInput.value);
                    const today = new Date();
                    today.setHours(0, 0, 0, 0);

                    if (dobValue > today) {
                        alert("Ngày sinh không được lớn hơn ngày hiện tại!");
                        dobInput.focus();
                        return;
                    }
                }

                updateModal.classList.add('show');
            });
        }

        if (cancelUpdateBtn) {
            cancelUpdateBtn.addEventListener('click', function () {
                updateModal.classList.remove('show');
            });
        }

        if (confirmUpdateBtn) {
            confirmUpdateBtn.addEventListener('click', function () {
                updateForm.submit();
            });
        }

        if (updateModal) {
            updateModal.addEventListener('click', function (e) {
                if (e.target === updateModal) updateModal.classList.remove('show');
            });
        }
    });

    function toggleEditMode() {
        const viewDiv = document.getElementById('infoView');
        const editDiv = document.getElementById('infoEdit');
        if (viewDiv.classList.contains('hidden')) {
            viewDiv.classList.remove('hidden');
            editDiv.classList.add('hidden');
        } else {
            viewDiv.classList.add('hidden');
            editDiv.classList.remove('hidden');
        }
    }
</script>
</body>
</html>