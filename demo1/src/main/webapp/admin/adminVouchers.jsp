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
    <title>TechNova Admin - Voucher</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminBrands.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminForm.css">
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
        <a href="${contextPath}/admin/dashboard"><img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo"></a>
        <a href="${contextPath}/admin/dashboard" style="text-decoration: none;"><span class="logo-text">TechNova</span></a>
    </div>
    <ul class="nav-menu">
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/vouchers" class="nav-link active"><span
                class="nav-icon"><i class="fa-solid fa-ticket"></i></span>Voucher</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>

    </ul>
    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link"><span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
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
        <div class="page-header">
            <div>
                <h1 class="page-title">Voucher</h1>
                <div class="breadcrumb"><a href="${contextPath}/admin/dashboard">Trang chủ</a><span>/</span><span>Voucher</span></div>
            </div>
        </div>

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
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                ${requestScope.errorMessage}
            </div>
        </c:if>

        <form action="${contextPath}/admin/vouchers" method="post" id="voucherForm" class="admin-form-card">
            <fmt:formatDate var="startInput" value="${voucherToEdit.startDate}" pattern="yyyy-MM-dd'T'HH:mm"/>
            <fmt:formatDate var="endInput" value="${voucherToEdit.endDate}" pattern="yyyy-MM-dd'T'HH:mm"/>
            <input type="hidden" name="id" value="${voucherToEdit.id}">
            <div class="admin-form-header">
                <div class="admin-form-header-icon"><i class="fa-solid fa-ticket"></i></div>
                <h2 class="admin-form-title-text">${not empty voucherToEdit ? 'Chỉnh sửa voucher' : 'Thêm voucher mới'}</h2>
            </div>
            <div class="admin-form-grid">
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Mã voucher <span class="required">*</span></label>
                    <input type="text" name="code" class="form-input" value="${voucherToEdit.code}" placeholder="VD: SALE100K" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Giá trị giảm <span class="required">*</span></label>
                    <input type="number" name="discountValue" class="form-input" value="${voucherToEdit.discountValue}" min="1000" step="1000" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Số lượng <span class="required">*</span></label>
                    <input type="number" name="quantity" class="form-input" value="${not empty voucherToEdit ? voucherToEdit.quantity : 100}" min="1" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Đơn tối thiểu <span class="required">*</span></label>
                    <input type="number" name="minOrderValue" class="form-input" value="${not empty voucherToEdit ? voucherToEdit.minOrderValue : 0}" min="0" step="1000" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Ngày bắt đầu <span class="required">*</span></label>
                    <input type="datetime-local" name="startDate" class="form-input" value="${startInput}" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Ngày kết thúc <span class="required">*</span></label>
                    <input type="datetime-local" name="endDate" class="form-input" value="${endInput}" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="ACTIVE" ${voucherToEdit.status == 'ACTIVE' ? 'selected' : ''}>Đang bật</option>
                        <option value="INACTIVE" ${voucherToEdit.status == 'INACTIVE' ? 'selected' : ''}>Tạm tắt</option>
                    </select>
                </div>
                <div class="form-field form-span-2">
                    <label class="admin-form-label">Mô tả</label>
                    <input type="text" name="description" class="form-input" placeholder="Nhập mô tả điều kiện sử dụng..." value="${voucherToEdit.description}">
                </div>
                <div class="form-actions">
                    <button type="submit" class="admin-btn-primary">
                        <i class="fa-solid fa-floppy-disk"></i> Lưu
                    </button>
                    <c:if test="${not empty voucherToEdit}">
                        <a href="${contextPath}/admin/vouchers" class="admin-btn-cancel"><i class="fa-solid fa-xmark"></i> Hủy</a>
                    </c:if>
                </div>
            </div>
        </form>

        <form action="${contextPath}/admin/vouchers" method="get" class="form-search-row">
            <div class="search-wrapper">
                <input type="text" name="keyword" class="search-input-brand" placeholder="Tìm kiếm mã voucher..." value="${keyword}">
                <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
        </form>

        <div class="brand-table-container">
            <table class="brand-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Mã</th>
                    <th>Giá trị</th>
                    <th>Số lượng</th>
                    <th>Bắt đầu</th>
                    <th>Kết thúc</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty vouchers}">
                        <tr><td colspan="9" class="no-results-cell">Chưa có voucher.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="voucher" items="${vouchers}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * 10 + loop.count}</td>
                                <td><c:out value="${voucher.code}"/></td>
                                <td><fmt:formatNumber value="${voucher.discountValue}" pattern="#,###"/>đ</td>
                                <td>${voucher.usedCount}/${voucher.quantity}</td>
                                <td><fmt:formatDate value="${voucher.startDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatDate value="${voucher.endDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><span class="status ${voucher.status == 'ACTIVE' ? 'status-active' : 'status-hidden'}">${voucher.status == 'ACTIVE' ? 'Đang bật' : 'Tạm tắt'}</span></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${contextPath}/admin/vouchers?action=edit&id=${voucher.id}" class="action-btn edit"><i class="fa-solid fa-pen"></i></a>
                                        <a href="${contextPath}/admin/vouchers?action=delete&id=${voucher.id}" class="action-btn delete" onclick="return confirm('Xóa voucher này?')"><i class="fa-solid fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>
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
    });
</script>
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
</body>
</html>
