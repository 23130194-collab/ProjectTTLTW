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
    <title>TechNova Admin - Mục sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminCategories.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminForm.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link active"><span class="nav-icon"><i
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
            <span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>
            Đăng xuất
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
        <div class="page-title">Mục sản phẩm</div>
        <div class="breadcrumb">
            <a href="${contextPath}/admin/dashboard" class="breadcrumb-link">Trang chủ</a>
            <span class="breadcrumb-separator">/</span>
            <span class="breadcrumb-current">Mục sản phẩm</span>
        </div>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${sessionScope.successMessage}" escapeXml="false"/>
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${sessionScope.errorMessage}" escapeXml="false"/>
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty requestScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${requestScope.errorMessage}" escapeXml="false"/>
            </div>
        </c:if>

        <form action="${contextPath}/admin/categories" method="post" class="admin-form-card" id="categoryForm">
            <c:if test="${not empty categoryToEdit}">
                <input type="hidden" name="categoryId" value="${categoryToEdit.id}">
            </c:if>
            <div class="admin-form-header">
                <div class="admin-form-header-icon">
                    <i class="fa-solid ${not empty categoryToEdit ? 'fa-pen' : 'fa-plus'}"></i>
                </div>
                <h2 class="admin-form-title-text">
                    <c:choose>
                        <c:when test="${not empty categoryToEdit}">Chỉnh sửa mục sản phẩm</c:when>
                        <c:otherwise>Thêm mục sản phẩm mới</c:otherwise>
                    </c:choose>
                </h2>
            </div>
            <div class="admin-form-grid">
                <div class="form-field form-span-2">
                    <label class="admin-form-label">Tên mục sản phẩm <span class="required">*</span></label>
                    <input type="text" name="categoryName" class="form-input"
                           placeholder="Nhập tên mục sản phẩm" value="${categoryToEdit.name}" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Thứ tự hiển thị <span class="required">*</span></label>
                    <input type="number" name="displayOrder" id="displayOrderInput" class="form-input"
                           placeholder="VD: 1" value="${categoryToEdit.display_order}" required>
                </div>
                <div class="form-field form-span-1">
                    <label class="admin-form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="active" ${categoryToEdit.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                        <option value="hidden" ${categoryToEdit.status == 'hidden' ? 'selected' : ''}>Ẩn</option>
                    </select>
                </div>
                <div class="form-field form-span-2">
                    <label class="admin-form-label">Đường dẫn hình ảnh</label>
                    <input type="text" name="imageUrl" class="form-input"
                           placeholder="https://example.com/image.png" value="${categoryToEdit.image}">
                </div>
                <div class="form-actions">
                    <a href="#confirm-save-modal" class="admin-btn-primary open-modal-btn">
                        <i class="fa-solid ${not empty categoryToEdit ? 'fa-floppy-disk' : 'fa-plus'}"></i>
                        <c:choose>
                            <c:when test="${not empty categoryToEdit}">Cập nhật</c:when>
                            <c:otherwise>Thêm mới</c:otherwise>
                        </c:choose>
                    </a>
                    <c:if test="${not empty categoryToEdit}">
                        <a href="${contextPath}/admin/categories" class="admin-btn-cancel">
                            <i class="fa-solid fa-xmark"></i> Hủy
                        </a>
                    </c:if>
                </div>
            </div>
            <c:if test="${not empty categoryToEdit.image}">
                <div style="margin-top: 12px; display: flex; align-items: center; gap: 10px;">
                    <span style="font-size: 13px; color: #64748b;">Ảnh hiện tại:</span>
                    <c:choose>
                        <c:when test="${categoryToEdit.image.startsWith('http')}">
                            <img src="${categoryToEdit.image}" alt="Preview"
                                 style="height: 40px; border-radius: 6px; border: 1px solid #e2e8f0;">
                        </c:when>
                        <c:otherwise>
                            <img src="${contextPath}/${categoryToEdit.image}" alt="Preview"
                                 style="height: 40px; border-radius: 6px; border: 1px solid #e2e8f0;">
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </form>

        <form action="${contextPath}/admin/categories" method="get" class="form-search-row">
            <div class="search-wrapper">
                <input type="text" name="searchKeyword" class="search-input-category"
                       placeholder="Tìm kiếm mục sản phẩm..." value="${searchKeyword}">
                <button type="submit" class="search-icon-btn"><i class="fa-solid fa-magnifying-glass"></i></button>
            </div>
        </form>

        <div class="category-table-container">
            <table class="category-table">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Hình ảnh</th>
                    <th>Tên mục sản phẩm</th>
                    <th>Thứ tự</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty categoryList and not empty searchKeyword}">
                        <tr>
                            <td colspan="6" class="no-results-cell">
                                <i class="fa-solid fa-magnifying-glass no-results-icon"></i>
                                Không tìm thấy kết quả phù hợp với từ khóa '<span class="no-results-keyword"><c:out value="${searchKeyword}" /></span>'
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${categoryList}" var="cat" varStatus="loop">
                            <tr>
                                <td><c:out value="${loop.index + 1}" /></td>
                                <td>
                                    <c:set var="imageSrc" value="${cat.image}"/>
                                    <c:choose>
                                        <c:when test="${imageSrc.startsWith('http')}">
                                            <img src="${imageSrc}" alt="${cat.name}" class="table-image">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${contextPath}/${imageSrc}" alt="${cat.name}" class="table-image">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><c:out value="${cat.name}" /></td>
                                <td><c:out value="${cat.display_order}" /></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cat.status.trim().equalsIgnoreCase('active')}">
                                            <span class="status status-active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status status-hidden">Ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="${contextPath}/admin/categories?action=edit&id=${cat.id}"
                                           class="action-btn edit" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                                        <a href="#confirm-delete-modal-${cat.id}" class="action-btn delete open-modal-btn"
                                           title="Xóa"><i class="fa-solid fa-trash-can"></i></a>
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

<c:forEach var="cat" items="${categoryList}">
    <div id="confirm-delete-modal-${cat.id}" class="modal-overlay">
        <div class="modal-content">
            <h3>Xác nhận xóa</h3>
            <p>Bạn có chắc chắn muốn xóa danh mục "<c:out value="${cat.name}" />" không?</p>
            <div class="modal-buttons">
                <a href="#" class="modal-btn modal-cancel">Hủy</a>
                <a href="${contextPath}/admin/categories?action=delete&id=${cat.id}"
                   class="modal-btn modal-confirm">Xóa</a>
            </div>
        </div>
    </div>
</c:forEach>

<div id="confirm-save-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận lưu</h3>
        <p>Bạn có chắc chắn muốn lưu các thay đổi cho danh mục này không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="categoryForm" class="modal-btn modal-confirm">Lưu</button>
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
    document.addEventListener('DOMContentLoaded', function () {
        document.querySelectorAll('.alert').forEach(function (alert) {
            setTimeout(function () {
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        });

        document.querySelectorAll('.open-modal-btn').forEach(button => {
            button.addEventListener('click', function (event) {
                event.preventDefault();
                const modalId = this.getAttribute('href');
                document.querySelector(modalId).classList.add('show');
            });
        });

        document.querySelectorAll('.modal-cancel').forEach(button => {
            button.addEventListener('click', function (event) {
                event.preventDefault();
                this.closest('.modal-overlay').classList.remove('show');
            });
        });

        document.querySelectorAll('.modal-overlay').forEach(overlay => {
            overlay.addEventListener('click', function (event) {
                if (event.target === this) {
                    this.classList.remove('show');
                }
            });
        });

        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
            logoutLink.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });
        }
        if (cancelLogoutBtn) {
            cancelLogoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });
        }
        if (logoutConfirmModal) {
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
