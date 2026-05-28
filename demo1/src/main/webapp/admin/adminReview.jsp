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
    <title>TechNova Admin - Quản lý Đánh giá</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminReview.css?v=2.5">
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
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span class="nav-icon"><i
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
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>
    </ul>
    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i
                class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
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
                <h1 class="page-title">Quản lý Đánh giá</h1>
                <div class="breadcrumb">
                    <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
                    <span>/</span>
                    <span class="breadcrumb-current">Đánh giá</span>
                </div>
            </div>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">${sessionScope.errorMessage}</div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty reviewToEdit}">
            <form id="reviewForm" action="${contextPath}/admin/reviews" method="post" class="review-form">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="reviewId" value="${reviewToEdit.id}">
                <input type="hidden" name="page" value="${currentPage}">
                <input type="hidden" name="searchKeyword" value="${searchKeyword}">
                <input type="hidden" name="statusFilter" value="${selectedStatus}">
                <input type="hidden" name="ratingFilter" value="${selectedRating}">
                <div class="form-columns">
                    <div class="form-column-left">
                        <div class="form-group"><label class="form-label">Sản phẩm</label><input type="text"
                                                                                                 class="form-control"
                                                                                                 value="${reviewToEdit.productName}"
                                                                                                 readonly></div>
                        <div class="form-group"><label class="form-label">Nội dung</label><textarea
                                class="form-control content-area" rows="6" readonly>${reviewToEdit.content}</textarea>
                        </div>
                    </div>
                    <div class="form-column-right">
                        <div class="form-group"><label class="form-label">Người dùng</label><input type="text"
                                                                                                   class="form-control"
                                                                                                   value="${reviewToEdit.userName}"
                                                                                                   readonly></div>
                        <div class="form-group"><label class="form-label">Điểm</label><input type="number"
                                                                                             class="form-control"
                                                                                             value="${reviewToEdit.rating}"
                                                                                             readonly></div>
                        <div class="form-group"><label class="form-label">Thời gian</label><input type="text"
                                                                                                  class="form-control"
                                                                                                  value="<fmt:formatDate value='${reviewToEdit.createdAt}' pattern='HH:mm dd/MM/yyyy'/>"
                                                                                                  readonly></div>
                        <div class="form-group">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-control">
                                <option value="active" ${reviewToEdit.status.trim().equalsIgnoreCase('active') ? 'selected' : ''}>
                                    Hoạt động
                                </option>
                                <option value="hidden" ${reviewToEdit.status.trim().equalsIgnoreCase('hidden') ? 'selected' : ''}>
                                    Ẩn
                                </option>
                            </select>
                        </div>
                        <div class="form-buttons">
                            <a href="#" id="save-button" class="btn btn-primary">Cập nhật</a>
                            <a href="${contextPath}/admin/reviews?page=${currentPage}&status=${selectedStatus}&rating=${selectedRating}&searchKeyword=${searchKeyword}"
                               class="btn btn-secondary">Hủy</a>
                        </div>
                    </div>
                </div>
            </form>
        </c:if>

        <div class="filter-bar">
            <form action="${contextPath}/admin/reviews" method="get" class="search-form" style="width: 100%; display: flex; justify-content: space-between; align-items: center; gap: 15px; flex-wrap: wrap;">
                <div class="filter-dropdowns" style="display: flex; gap: 15px;">
                    <select name="status" class="form-control" onchange="this.form.submit()" style="width: 150px; cursor: pointer;">
                        <option value="all" ${empty selectedStatus or selectedStatus == 'all' ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="hidden" ${selectedStatus == 'hidden' ? 'selected' : ''}>Ẩn</option>
                    </select>
                    
                    <select name="rating" class="form-control" onchange="this.form.submit()" style="width: 150px; cursor: pointer;">
                        <option value="all" ${empty selectedRating or selectedRating == 'all' ? 'selected' : ''}>Tất cả số sao</option>
                        <option value="5" ${selectedRating == '5' ? 'selected' : ''}>5 Sao</option>
                        <option value="4" ${selectedRating == '4' ? 'selected' : ''}>4 Sao</option>
                        <option value="3" ${selectedRating == '3' ? 'selected' : ''}>3 Sao</option>
                        <option value="2" ${selectedRating == '2' ? 'selected' : ''}>2 Sao</option>
                        <option value="1" ${selectedRating == '1' ? 'selected' : ''}>1 Sao</option>
                    </select>
                </div>
                
                <div class="search-wrapper" style="flex: 1; max-width: 400px; margin: 0;">
                    <input type="text" name="searchKeyword" id="searchInput" class="search-input-review"
                           placeholder="Tìm theo tên sản phẩm, người dùng..." value="${searchKeyword}">
                    <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
                </div>
            </form>
        </div>

        <div class="table-container">
            <table class="review-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Sản phẩm</th>
                    <th>Người dùng</th>
                    <th>Đánh giá</th>
                    <th class="col-content">Nội dung</th>
                    <th>Ngày</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty reviewList and not empty searchKeyword}">
                        <tr>
                            <td colspan="8" style="text-align: center; padding: 40px 20px; color: #6b7280;">
                                <i class="fa-solid fa-magnifying-glass" style="font-size: 2rem; color: #d1d5db; display: block; margin-bottom: 12px;"></i>
                                Không tìm thấy kết quả phù hợp với từ khóa '<strong>${searchKeyword}</strong>'
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="review" items="${reviewList}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * 10 + loop.count}</td>
                                <td class="col-product">
                                    <span class="truncate-text" title="${review.productName}">${review.productName}</span>
                                </td>
                                <td>${review.userName}</td>
                                <td><span class="rating-star">${review.rating} <i class="fa-solid fa-star"></i></span></td>
                                <td class="col-content text-left">
                                    <span class="truncate-text" title="${review.content}">${review.content}</span>
                                </td>
                                <td><fmt:formatDate value="${review.createdAt}" pattern="HH:mm dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${review.status.trim().equalsIgnoreCase('active')}">
                                            <span class="status status-active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status status-hidden">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="col-actions">
                                    <div class="action-buttons">
                                        <a href="${contextPath}/admin/reviews?action=edit&id=${review.id}&page=${currentPage}&status=${selectedStatus}&rating=${selectedRating}&searchKeyword=${searchKeyword}"
                                           class="action-btn edit" title="Sửa trạng thái"><i class="fa-solid fa-pen"></i></a>
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
                    <a href="${contextPath}/admin/reviews?page=${currentPage - 1}&status=${selectedStatus}&rating=${selectedRating}&searchKeyword=${searchKeyword}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-left"></i></a>
                </c:if>
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <a href="${contextPath}/admin/reviews?page=${i}&status=${selectedStatus}&rating=${selectedRating}&searchKeyword=${searchKeyword}"
                       class="page-number ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <a href="${contextPath}/admin/reviews?page=${currentPage + 1}&status=${selectedStatus}&rating=${selectedRating}&searchKeyword=${searchKeyword}"
                       class="pagination-btn"><i class="fa-solid fa-chevron-right"></i></a>
                </c:if>
            </div>
        </c:if>
    </div>
</main>

<div id="confirm-save-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận lưu</h3>
        <p>Bạn có chắc chắn muốn lưu các thay đổi này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancel-save">Hủy</a>
            <button type="submit" form="reviewForm" class="modal-btn modal-confirm">Lưu</button>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const saveBtn = document.getElementById('save-button');
        const confirmSaveModal = document.getElementById('confirm-save-modal');
        const cancelSaveBtn = document.getElementById('cancel-save');

        if (saveBtn && confirmSaveModal && cancelSaveBtn) {
            saveBtn.addEventListener('click', function (e) {
                e.preventDefault();
                confirmSaveModal.classList.add('show');
            });

            cancelSaveBtn.addEventListener('click', function (e) {
                e.preventDefault();
                confirmSaveModal.classList.remove('show');
            });

            confirmSaveModal.addEventListener('click', function (e) {
                if (e.target === confirmSaveModal) {
                    confirmSaveModal.classList.remove('show');
                }
            });
        }

        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            setTimeout(function () {
                alert.style.display = 'none';
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
