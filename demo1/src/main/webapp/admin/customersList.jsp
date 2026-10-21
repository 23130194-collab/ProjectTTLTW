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
    <title>TechNova Admin - Danh sách khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/customersList.css?v=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/adminModal.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link active"><span
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
        <li class="nav-item"><a href="${contextPath}/admin/vouchers" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-ticket"></i></span>Voucher</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>

    </ul>
    <div class="logout-section"><a href="${contextPath}/logout" class="nav-link logout-link"
                                   id="logoutLink"><span class="nav-icon"><i
            class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a></div>
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
            <h1 class="page-title">Danh sách khách hàng</h1>
            <button class="add-customer-btn" id="openAddCustomerBtn" onclick="window.location.href='${pageContext.request.contextPath}/admin/add-customer'">
                <i class="fa-solid fa-plus"></i> Thêm khách hàng
            </button>
        </div>

        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp"
               class="breadcrumb-link">Trang chủ</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Danh sách khách hàng</span>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success" id="successAlert">
                <span class="alert-text"><c:out value="${sessionScope.successMessage}" /></span>
                <span class="close-btn" onclick="closeAlert('successAlert')">&times;</span>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                                <span class="close-btn"
                                      onclick="this.parentElement.style.display='none';">&times;</span>
                    <c:out value="${sessionScope.errorMessage}" />
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <div class="filter-section">
            <form action="${contextPath}/admin/customers" method="get" class="filter-form">

                <select name="status" id="statusSelect" onchange="this.form.submit()"
                        class="filter-select">
                    <option value="all" ${param.status=='all' || empty param.status ? 'selected' : '' }>
                        Tất cả trạng thái
                    </option>
                    <option value="active" ${param.status=='active' ? 'selected' : '' }>
                        Đang hoạt động
                    </option>
                    <option value="locked" ${param.status=='locked' ? 'selected' : '' }>
                        Đã khóa
                    </option>
                    <option value="admin" ${param.status=='admin' ? 'selected' : '' }>
                        Quản trị viên
                    </option>
                </select>

                <div class="search-wrapper">
                    <input type="text" name="keyword" class="search-input-customer"
                           placeholder="Tìm kiếm khách hàng..." value="${keyword}">
                    <button type="submit" class="search-icon-btn"><i
                            class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </form>
        </div>

        <div class="customer-list">
            <table class="customer-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Đơn hàng</th>
                    <th>Tham gia</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody id="customerTableBody">
                <c:if test="${empty customerList}">
                    <tr>
                        <td colspan="6" class="no-results-cell">
                            <i class="fa-solid fa-magnifying-glass no-results-icon"></i>
                            Không tìm thấy dữ liệu khách hàng nào phù hợp với từ khóa '<span
                                class="no-results-keyword"><c:out value="${keyword}" /></span>'.
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="u" items="${customerList}" varStatus="status">
                    <tr>
                        <td style="text-align: center;"><c:out value="${(currentPage - 1) * 5 + status.index + 1}" />
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${u.id}"
                               class="customer-link">
                                <div class="reviewer-avatar">
                                        <c:out value="${u.name != null ? u.name.substring(0, 1).toUpperCase() : '?'}" />
                                </div>
                                    <c:out value="${u.name}" />
                            </a>
                        </td>

                        <td><c:out value="${u.email}" /></td>

                        <td style="text-align: center;"><c:out value="${u.orderCount}" /></td>

                        <td>
                            <fmt:formatDate value="${u.created_at}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${contextPath}/admin/customer-detail?id=${u.id}"
                                   class="action-btn edit" title="Xem">
                                    <i class="fa-solid fa-eye"></i>
                                </a>

                                <a href="#" class="action-btn delete"
                                   style="background-color: ${u.status == 'Locked' ? '#fee2e2' : '#e0f2fe'};
                                           color: ${u.status == 'Locked' ? '#b91c1c' : '#0284c7'};"
                                   title="${u.status == 'Locked' ? 'Mở khóa' : 'Khóa tài khoản'}"
                                   onclick="openLockModal(event, '${contextPath}/admin/lock-customer?id=${u.id}', '${u.status}')">

                                    <c:choose>
                                        <c:when test="${u.status == 'Locked'}">
                                            <i class="fa-solid fa-lock"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fa-solid fa-lock-open"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </a>

                                <a href="#" class="action-btn"
                                   style="background-color: ${u.role == 1 ? '#f3e8ff' : '#fef9c3'};
                                           color: ${u.role == 1 ? '#7c3aed' : '#b45309'};"
                                   title="${u.role == 1 ? 'Hạ về quyền User' : 'Cấp quyền Admin'}"
                                   onclick="openRoleModal(event, '${contextPath}/admin/change-role?id=${u.id}', ${u.role})">
                                    <i class="fa-solid fa-user-shield"></i>
                                </a>

                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div class="pagination-container">

                    <c:if test="${currentPage > 1}">
                        <a href="${contextPath}/admin/customers?page=${currentPage - 1}&keyword=${keyword}&status=${param.status}"
                           class="pagination-btn">
                            <i class="fa-solid fa-chevron-left"></i>
                        </a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="${contextPath}/admin/customers?page=${i}&keyword=${keyword}&status=${param.status}"
                           class="page-number ${currentPage == i ? 'active' : ''}">
                                <c:out value="${i}" />
                        </a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="${contextPath}/admin/customers?page=${currentPage + 1}&keyword=${keyword}&status=${param.status}"
                           class="pagination-btn">
                            <i class="fa-solid fa-chevron-right"></i>
                        </a>
                    </c:if>

                </div>
            </c:if>
        </div>
    </div>
</main>

<div id="lockConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="lockModalTitle">Xác nhận</h3>
        <p id="lockModalMessage">Nội dung xác nhận...</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelLockBtn">Hủy</a>
            <a href="#" class="modal-btn modal-confirm" id="confirmLockBtn">Đồng ý</a>
        </div>
    </div>
</div>

<div id="roleConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3 id="roleModalTitle">Xác nhận chuyển quyền</h3>
        <p id="roleModalMessage">Nội dung xác nhận...</p>
        <div class="modal-buttons">
            <button class="modal-btn modal-cancel" id="cancelRoleBtn">Hủy</button>
            <form id="roleForm" method="post" action="" style="display:inline;">
                <button type="submit" class="modal-btn modal-confirm" id="confirmRoleBtn">Đồng ý</button>
            </form>
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
            fetch('<c:out value="${contextPath}" />/NotificationServlet', { method: 'POST' })
                .then(() => {
                    const badge = document.getElementById('notificationBadge');
                    badge.style.display = 'none';
                    badge.textContent = '0';
                    loadNotifications();
                });
        }

        function loadNotifications() {
            fetch('<c:out value="${contextPath}" />/NotificationServlet')
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
                        var link = '<c:out value="${contextPath}" />' + n.link;

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
                fetch('<c:out value="${contextPath}" />/NotificationServlet?id=' + id, { method: 'POST' })
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

        fetch('<c:out value="${contextPath}" />/NotificationServlet')
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
    function openLockModal(event, actionUrl, currentStatus) {
        event.preventDefault();

        const lockModal = document.getElementById('lockConfirmModal');
        const confirmLockBtn = document.getElementById('confirmLockBtn');
        const lockModalTitle = document.getElementById('lockModalTitle');
        const lockModalMessage = document.getElementById('lockModalMessage');

        confirmLockBtn.href = actionUrl;

        if (currentStatus === 'Locked') {
            lockModalTitle.innerText = "Xác nhận mở khóa";
            lockModalMessage.innerText = "Bạn có chắc chắn muốn mở khóa tài khoản này? Họ sẽ có thể đăng nhập lại.";
            confirmLockBtn.style.backgroundColor = "#0284c7";
            confirmLockBtn.innerText = "Mở khóa";
        } else {
            lockModalTitle.innerText = "Xác nhận khóa tài khoản";
            lockModalMessage.innerText = "Bạn có chắc chắn muốn khóa tài khoản này? Họ sẽ không thể đăng nhập hệ thống.";
            confirmLockBtn.style.backgroundColor = "#ef4444";
            confirmLockBtn.innerText = "Khóa ngay";
        }

        lockModal.classList.add('show');
    }

    function openRoleModal(event, actionUrl, currentRole) {
        event.preventDefault();

        const modal = document.getElementById('roleConfirmModal');
        const title = document.getElementById('roleModalTitle');
        const message = document.getElementById('roleModalMessage');
        const confirmBtn = document.getElementById('confirmRoleBtn');
        const form = document.getElementById('roleForm');

        form.action = actionUrl;

        if (currentRole == 1) {
            title.innerText = "Hạ quyền về User";
            message.innerText = "Tài khoản này đang là Admin. Bạn có chắc muốn hạ xuống thành User thường không?";
            confirmBtn.style.backgroundColor = "#0284c7";
            confirmBtn.innerText = "Hạ quyền";
        } else {
            title.innerText = "Nâng quyền thành Admin";
            message.innerText = "Bạn có chắc muốn cấp quyền Admin cho tài khoản này không?";
            confirmBtn.style.backgroundColor = "#ef4444";
            confirmBtn.innerText = "Cấp quyền Admin";
        }

        modal.classList.add('show');
    }

    document.addEventListener("DOMContentLoaded", function () {

        const lockModal = document.getElementById('lockConfirmModal');
        const cancelLockBtn = document.getElementById('cancelLockBtn');

        if (cancelLockBtn) {
            cancelLockBtn.addEventListener('click', function (e) {
                e.preventDefault();
                lockModal.classList.remove('show');
            });
        }

        if (lockModal) {
            lockModal.addEventListener('click', function (e) {
                if (e.target === lockModal) {
                    lockModal.classList.remove('show');
                }
            });
        }

        const roleModal = document.getElementById('roleConfirmModal');
        const cancelRoleBtn = document.getElementById('cancelRoleBtn');
        if (cancelRoleBtn) {
            cancelRoleBtn.addEventListener('click', function (e) {
                e.preventDefault();
                roleModal.classList.remove('show');
            });
        }
        if (roleModal) {
            roleModal.addEventListener('click', function (e) {
                if (e.target === roleModal) roleModal.classList.remove('show');
            });
        }
    });
</script>

<script>
    function closeAlert(alertId) {
        const alertBox = document.getElementById(alertId);
        if (alertBox) {
            alertBox.classList.add('fade-out');
            setTimeout(() => {
                alertBox.style.display = 'none';
            }, 500);
        }
    }

    document.addEventListener("DOMContentLoaded", function () {

        const successAlert = document.getElementById('successAlert');
        if (successAlert) {
            setTimeout(function() {
                closeAlert('successAlert');
            }, 5000);
        }

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
