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
    <title>TechNova Admin - Quản lý Liên hệ</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminContacts.css?v=1">
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
        <a href="${contextPath}/admin/dashboard" style="text-decoration: none;">
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
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/vouchers" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-ticket"></i></span>Voucher</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link active"><span class="nav-icon"><i class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>
    </ul>
    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
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
                <h1 class="page-title">Quản lý Liên hệ</h1>
                <div class="breadcrumb">
                    <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
                    <span>/</span>
                    <span class="breadcrumb-current">Liên hệ</span>
                </div>
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

        <c:if test="${not empty selectedContact}">
            <fmt:formatDate value="${selectedContact.createdAt}" pattern="HH:mm dd/MM/yyyy" var="selectedContactCreatedAt"/>
            <div class="detail-card">
                <div class="detail-card-header">
                    <h2>Chi tiết liên hệ #${selectedContact.id}</h2>
                    <a class="btn btn-secondary" href="${contextPath}/admin/contacts?page=${currentPage}&status=${selectedStatus}&keyword=${searchKeyword}">Đóng</a>
                </div>

                <div class="detail-grid">
                    <div class="detail-group">
                        <label>Họ tên</label>
                        <input type="text" class="form-control" value="${selectedContact.name}" readonly>
                    </div>
                    <div class="detail-group">
                        <label>Email</label>
                        <input type="text" class="form-control" value="${selectedContact.email}" readonly>
                    </div>
                    <div class="detail-group">
                        <label>Ngày gửi</label>
                        <input type="text" class="form-control" value="${selectedContactCreatedAt}" readonly>
                    </div>
                    <div class="detail-group">
                        <label>Trạng thái</label>
                        <input type="text" class="form-control" value="${selectedContact.processed ? 'Đã xử lý' : 'Chưa xử lý'}" readonly>
                    </div>
                </div>

                <div class="detail-group">
                    <label>Nội dung liên hệ</label>
                    <textarea class="form-control textarea-readonly" readonly>${selectedContact.content}</textarea>
                </div>

                <c:if test="${selectedContact.processed and not empty selectedContact.responseContent}">
                    <div class="detail-group">
                        <label>Nội dung đã phản hồi</label>
                        <textarea class="form-control textarea-readonly" readonly>${selectedContact.responseContent}</textarea>
                        <p class="response-time">Phản hồi lúc:
                            <fmt:formatDate value="${selectedContact.respondedAt}" pattern="HH:mm dd/MM/yyyy"/>
                        </p>
                    </div>
                </c:if>

                <form action="${contextPath}/admin/contacts" method="post" class="reply-form">
                    <input type="hidden" name="action" value="reply">
                    <input type="hidden" name="contactId" value="${selectedContact.id}">
                    <input type="hidden" name="page" value="${currentPage}">
                    <input type="hidden" name="searchKeyword" value="${searchKeyword}">
                    <input type="hidden" name="statusFilter" value="${selectedStatus}">

                    <div class="detail-group">
                        <label for="responseContent">Phản hồi qua email</label>
                        <textarea id="responseContent" name="responseContent" class="form-control textarea-edit" placeholder="Nhập nội dung phản hồi cho khách hàng..." required>${selectedContact.responseContent}</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary"><i class="fa-solid fa-paper-plane"></i> Gửi phản hồi</button>
                    </div>
                </form>

                <c:if test="${not selectedContact.processed}">
                    <form action="${contextPath}/admin/contacts" method="post" class="mark-form">
                        <input type="hidden" name="action" value="markProcessed">
                        <input type="hidden" name="contactId" value="${selectedContact.id}">
                        <input type="hidden" name="page" value="${currentPage}">
                        <input type="hidden" name="searchKeyword" value="${searchKeyword}">
                        <input type="hidden" name="statusFilter" value="${selectedStatus}">
                        <button type="submit" class="btn btn-outline"><i class="fa-solid fa-check"></i> Đánh dấu đã xử lý</button>
                    </form>
                </c:if>
            </div>
        </c:if>

        <div class="filter-bar">
            <div class="filter-tabs">
                <a href="${contextPath}/admin/contacts?status=all&keyword=${searchKeyword}" class="tab ${selectedStatus == 'all' ? 'active' : ''}">Tất cả</a>
                <a href="${contextPath}/admin/contacts?status=pending&keyword=${searchKeyword}" class="tab ${selectedStatus == 'pending' ? 'active' : ''}">Chưa xử lý</a>
                <a href="${contextPath}/admin/contacts?status=processed&keyword=${searchKeyword}" class="tab ${selectedStatus == 'processed' ? 'active' : ''}">Đã xử lý</a>
            </div>

            <form action="${contextPath}/admin/contacts" method="get" class="search-form">
                <input type="hidden" name="status" value="${selectedStatus}">
                <div class="search-wrapper">
                    <input type="text" class="search-input" name="keyword" value="${searchKeyword}" placeholder="Tìm theo tên người dùng">
                    <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </form>
        </div>

        <div class="table-container">
            <table class="contact-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Người gửi</th>
                    <th>Email</th>
                    <th>Nội dung</th>
                    <th>Ngày gửi</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty contactList}">
                        <tr>
                            <td colspan="7" class="empty-state">
                                <i class="fa-solid fa-envelope-open-text"></i>
                                <span>Không tìm thấy liên hệ</span>
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="contact" items="${contactList}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * 10 + loop.count}</td>
                                <td>${contact.name}</td>
                                <td>${contact.email}</td>
                                <td class="text-left"><span class="truncate-text" title="${contact.content}">${contact.content}</span></td>
                                <td><fmt:formatDate value="${contact.createdAt}" pattern="HH:mm dd/MM/yyyy"/></td>
                                <td>
                                    <span class="status-badge ${contact.processed ? 'status-processed' : 'status-pending'}">
                                            ${contact.processed ? 'Đã xử lý' : 'Chưa xử lý'}
                                    </span>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${contextPath}/admin/contacts?action=detail&id=${contact.id}&page=${currentPage}&status=${selectedStatus}&keyword=${searchKeyword}" class="action-btn view" title="Xem chi tiết"><i class="fa-solid fa-eye"></i></a>
                                        <c:if test="${not contact.processed}">
                                            <form action="${contextPath}/admin/contacts" method="post">
                                                <input type="hidden" name="action" value="markProcessed">
                                                <input type="hidden" name="contactId" value="${contact.id}">
                                                <input type="hidden" name="page" value="${currentPage}">
                                                <input type="hidden" name="searchKeyword" value="${searchKeyword}">
                                                <input type="hidden" name="statusFilter" value="${selectedStatus}">
                                                <button type="submit" class="action-btn done" title="Đánh dấu đã xử lý">
                                                    <i class="fa-solid fa-check"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <c:if test="${currentPage > 1}">
                    <a href="${contextPath}/admin/contacts?page=${currentPage - 1}&status=${selectedStatus}&keyword=${searchKeyword}" class="pagination-btn"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${contextPath}/admin/contacts?page=${i}&status=${selectedStatus}&keyword=${searchKeyword}" class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="${contextPath}/admin/contacts?page=${currentPage + 1}&status=${selectedStatus}&keyword=${searchKeyword}" class="pagination-btn"><i class="fa-solid fa-chevron-right"></i></a>
                </c:if>
            </div>
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
        const alerts = document.querySelectorAll('.alert');
        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        alerts.forEach(function (alert) {
            setTimeout(function () {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });

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
