<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        #cancel-reason-modal .modal-content select:focus,
        #cancel-reason-modal .modal-content textarea:focus {
            border-color: #e53e3e;
            box-shadow: 0 0 0 3px rgba(229,62,62,0.1);
            outline: none;
        }
        #cancel-reason-modal .modal-content select,
        #cancel-reason-modal .modal-content textarea {
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .admin-cancellation-reason {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            background: #fff5f5;
            border: 1.5px solid #feb2b2;
            border-radius: 8px;
            padding: 12px 16px;
            margin: 12px 0;
            font-size: 14px;
        }
        .admin-cancellation-reason i {
            color: #e53e3e;
            font-size: 18px;
            flex-shrink: 0;
            margin-top: 1px;
        }
        .admin-cancellation-reason strong {
            color: #c53030;
            display: block;
            margin-bottom: 3px;
        }
        .admin-cancellation-reason span {
            color: #742a2a;
        }
    </style>
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
        <li class="nav-item"><a href="${contextPath}/admin/vouchers" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-ticket"></i></span>Voucher</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span class="nav-icon"><i class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>

    </ul>
    <div class="logout-section">
        <a href="${pageContext.request.contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
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
        <a href="${pageContext.request.contextPath}/admin/orders" class="back-link">
            <i class="fa-solid fa-arrow-left"></i> Quay lại
        </a>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${sessionScope.successMessage}" />
            </div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-danger">
                <span class="close-btn" onclick="this.parentElement.style.display='none';">&times;</span>
                <c:out value="${sessionScope.errorMessage}" />
            </div>
            <c:remove var="errorMessage" scope="session"/>
        </c:if>

        <c:if test="${not empty orderDetail}">
            <c:set var="recipientInfo" value="${orderDetail.order.recipientInfo}"/>
            <c:set var="recipientAddress" value="${fn:trim(recipientInfo.address)}"/>
            <c:set var="recipientWard" value="${fn:trim(recipientInfo.ward)}"/>
            <c:set var="recipientDistrict" value="${fn:trim(recipientInfo.district)}"/>
            <c:set var="recipientProvince" value="${fn:trim(recipientInfo.province)}"/>
            <div class="invoice-container">
                <header class="invoice-header">
                    <div><span class="invoice-logo">TechNova</span></div>
                    <div class="invoice-header-right">
                        <h2>Chi tiết hoá đơn</h2>
                        <span class="invoice-order-id">Đơn hàng <c:out value="${orderDetail.order.orderCode}" /></span>
                    </div>
                </header>

                <section class="invoice-meta">
                    <div class="meta-column">
                        <strong>Khách hàng:</strong>
                        <address><c:out value="${orderDetail.customer.name}" /><br/><c:out value="${orderDetail.customer.address}" /></address>
                    </div>
                    <div class="meta-column">
                        <strong>Thông tin người nhận:</strong>
                        <address>
                            <c:out value="${not empty recipientInfo.fullName ? recipientInfo.fullName : orderDetail.customer.name}" /><br/>
                            <c:out value="${not empty recipientInfo.phone ? recipientInfo.phone : orderDetail.customer.phone}" /><br/>
                            <c:out value="${recipientAddress}" /><c:if test="${not empty recipientWard}">, <c:out value="${recipientWard}" /></c:if><c:if test="${not empty recipientDistrict}">, <c:out value="${recipientDistrict}" /></c:if><c:if test="${not empty recipientProvince}">, <c:out value="${recipientProvince}" /></c:if>
                        </address>
                        <div><c:out value="${not empty recipientInfo.email ? recipientInfo.email : orderDetail.customer.email}" /></div>
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
                    Trạng thái hiện tại: <span class="badge ${statusClass}"><c:out value="${orderDetail.order.orderStatus}" /></span>
                </div>

                <c:if test="${orderDetail.order.orderStatus == 'Đã hủy' and not empty orderDetail.order.cancellationReason}">
                    <div class="admin-cancellation-reason">
                        <i class="fa-solid fa-circle-xmark"></i>
                        <div>
                            <strong>Lý do hủy đơn hàng</strong>
                            <span><c:out value="${orderDetail.order.cancellationReason}" /></span>
                        </div>
                    </div>
                </c:if>

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

                <c:set var="isProcessingOrder" value="${orderDetail.order.orderStatus == 'Đang xử lý' || orderDetail.order.orderStatus == 'Đang xử lí'}"/>
                <c:set var="isPendingOrder" value="${orderDetail.order.orderStatus == 'Chờ xác nhận'}"/>
                <c:if test="${isProcessingOrder || isPendingOrder}">
                    <section class="carrier-action-section">
                        <div class="carrier-action-content">
                            <div>
                                <strong>Giao vận GHN</strong>
                                <p>
                                    <c:choose>
                                        <c:when test="${orderDetail.order.sentToCarrier}">
                                            Đơn hàng đã được gửi sang Giao Hàng Nhanh. Chờ đơn vị vận chuyển lấy hàng và quét mã.
                                        </c:when>
                                        <c:when test="${isPendingOrder}">
                                            Đơn COD vẫn đang chờ xác nhận. Khi đơn chuyển sang Đang xử lý, admin có thể giao cho đơn vị vận chuyển.
                                        </c:when>
                                        <c:otherwise>
                                            Tạo vận đơn GHN để đơn vị vận chuyển đến lấy hàng.
                                        </c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <c:if test="${isProcessingOrder && not orderDetail.order.sentToCarrier}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" id="handoverCarrierForm">
                                    <input type="hidden" name="action" value="handoverToCarrier">
                                    <input type="hidden" name="orderId" value="${orderDetail.order.id}">
                                    <a href="#confirm-carrier-handover-modal" class="carrier-handover-btn open-modal-btn">
                                        <i class="fa-solid fa-truck-fast"></i>
                                        Giao cho đơn vị vận chuyển
                                    </a>
                                </form>
                            </c:if>
                            <c:if test="${isPendingOrder}">
                                <button type="button" class="carrier-handover-btn is-disabled" disabled>
                                    <i class="fa-solid fa-truck-fast"></i>
                                    Giao cho đơn vị vận chuyển
                                </button>
                            </c:if>
                        </div>
                    </section>
                </c:if>

                <div class="invoice-items-table-wrap">
                    <table class="invoice-items-table">
                        <thead>
                        <tr>
                            <th>STT</th>
                            <th>Hình ảnh</th>
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
                            <td><c:out value="${loop.count}" /></td>
                            <td>
                                <div class="order-product-image-box">
                                    <c:choose>
                                        <c:when test="${not empty item.productImage}">
                                            <c:set var="productImage" value="${fn:trim(item.productImage)}"/>
                                            <c:choose>
                                                <c:when test="${fn:startsWith(productImage, 'http')}">
                                                    <img src="${productImage}" alt="${item.productName}" class="order-product-image"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                </c:when>
                                                <c:when test="${fn:startsWith(productImage, '//')}">
                                                    <img src="${productImage}" alt="${item.productName}" class="order-product-image"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                </c:when>
                                                <c:when test="${not empty contextPath and fn:startsWith(productImage, contextPath)}">
                                                    <img src="${productImage}" alt="${item.productName}" class="order-product-image"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                </c:when>
                                                <c:when test="${fn:startsWith(productImage, '/')}">
                                                    <img src="${contextPath}${productImage}" alt="${item.productName}" class="order-product-image"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${contextPath}/${productImage}" alt="${item.productName}" class="order-product-image"
                                                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="order-product-image-placeholder">
                                                <i class="fa-regular fa-image"></i>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="order-product-image-placeholder is-visible">
                                                <i class="fa-regular fa-image"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </td>
                            <td class="product-name-cell"><strong><c:out value="${item.productName}" /></strong></td>
                            <td><fmt:formatNumber value="${item.originalPrice}" type="currency" currencySymbol="đ"/></td>
                            <td><fmt:formatNumber value="${item.discountPercentage / 100}" type="percent"/></td>
                            <td><c:out value="${item.quantity}" /></td>
                            <td><fmt:formatNumber value="${item.total}" type="currency" currencySymbol="đ"/></td>
                        </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <section class="invoice-summary">
                    <div class="summary-details">
                        <c:set var="productDiscountAmount" value="${orderDetail.order.discountAmount - orderDetail.order.voucherDiscountAmount}"/>
                        <div><span>Tổng tiền hàng</span> <span><fmt:formatNumber value="${orderDetail.order.subprice}" type="currency" currencySymbol="đ"/></span></div>
                        <div><span>Phí vận chuyển</span> <span><fmt:formatNumber value="${orderDetail.order.shippingFee}" type="currency" currencySymbol="đ"/></span></div>
                        <div><span>Giảm giá sản phẩm</span> <span>-<fmt:formatNumber value="${productDiscountAmount lt 0 ? 0 : productDiscountAmount}" type="currency" currencySymbol="đ"/></span></div>
                        <c:if test="${orderDetail.order.voucherDiscountAmount > 0}">
                            <div><span>Voucher giảm giá</span> <span>-<fmt:formatNumber value="${orderDetail.order.voucherDiscountAmount}" type="currency" currencySymbol="đ"/></span></div>
                        </c:if>
                        <div class="summary-total">
                            <strong>Tổng thanh toán</strong>
                            <strong><fmt:formatNumber value="${orderDetail.order.totalAmount}" type="currency" currencySymbol="đ"/></strong>
                        </div>
                    </div>
                </section>

                <footer class="invoice-footer">
                    <div class="invoice-notes">
                        <strong>Ghi chú của khách hàng:</strong>
                        <p><c:out value="${not empty orderDetail.order.notes ? orderDetail.order.notes : 'Không có ghi chú.'}" /></p>
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

<div id="cancel-reason-modal" class="modal-overlay">
    <div class="modal-content" style="max-width:500px;">
        <h3 style="color:#e53e3e;"><i class="fa-solid fa-ban" style="margin-right:8px;"></i>Hủy đơn hàng</h3>
        <p style="margin-bottom:16px; color:#555;">Vui lòng chọn hoặc nhập lý do hủy đơn hàng này. Lý do sẽ được hiển thị cho khách hàng.</p>
        <div style="margin-bottom:14px;">
            <label for="cancelReasonSelect" style="display:block; font-weight:600; margin-bottom:6px;">Lý do hủy <span style="color:red;">*</span></label>
            <select id="cancelReasonSelect" style="width:100%; padding:9px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px; outline:none;">
                <option value="">-- Chọn lý do --</option>
                <option value="Sản phẩm hết hàng đột xuất">Sản phẩm hết hàng đột xuất</option>
                <option value="Thông tin giao hàng không hợp lệ">Thông tin giao hàng không hợp lệ</option>
                <option value="Theo yêu cầu của khách hàng">Theo yêu cầu của khách hàng</option>
                <option value="Phát hiện đơn hàng gian lận">Phát hiện đơn hàng gian lận</option>
                <option value="Sản phẩm không còn được bán">Sản phẩm không còn được bán</option>
                <option value="other">Lý do khác...</option>
            </select>
        </div>
        <div id="cancelReasonCustomWrap" style="display:none; margin-bottom:14px;">
            <label for="cancelReasonCustom" style="display:block; font-weight:600; margin-bottom:6px;">Nhập lý do cụ thể</label>
            <textarea id="cancelReasonCustom" rows="3" placeholder="Nhập lý do hủy đơn hàng..." style="width:100%; padding:9px 12px; border:1px solid #ddd; border-radius:6px; font-size:14px; resize:vertical; box-sizing:border-box;"></textarea>
        </div>
        <div id="cancelReasonError" style="display:none; color:#e53e3e; font-size:13px; margin-bottom:10px;">
            <i class="fa-solid fa-circle-exclamation"></i> Vui lòng chọn hoặc nhập lý do hủy.
        </div>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelReasonModalClose">Quay lại</a>
            <button type="button" class="modal-btn modal-confirm" id="confirmCancelReasonBtn" style="background:#e53e3e; border-color:#e53e3e;">Xác nhận hủy đơn</button>
        </div>
    </div>
</div>

<div id="confirm-carrier-handover-modal" class="modal-overlay">
    <div class="modal-content">
        <h3>Giao cho đơn vị vận chuyển</h3>
        <p>Hệ thống sẽ tạo vận đơn GHN cho đơn hàng này. Bạn có chắc chắn muốn tiếp tục?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel">Hủy</a>
            <button type="submit" form="handoverCarrierForm" class="modal-btn modal-confirm">Giao cho GHN</button>
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
                const selectedStatus = document.getElementById('orderStatus').value;
                if (selectedStatus === 'Đã hủy') {
                    document.getElementById('cancelReasonSelect').value = '';
                    document.getElementById('cancelReasonCustomWrap').style.display = 'none';
                    if (document.getElementById('cancelReasonCustom')) document.getElementById('cancelReasonCustom').value = '';
                    document.getElementById('cancelReasonError').style.display = 'none';
                    document.getElementById('cancel-reason-modal').classList.add('show');
                } else {
                    const modalId = this.getAttribute('href');
                    document.querySelector(modalId).classList.add('show');
                }
            });
        });

        document.getElementById('cancelReasonSelect').addEventListener('change', function() {
            const customWrap = document.getElementById('cancelReasonCustomWrap');
            customWrap.style.display = (this.value === 'other') ? 'block' : 'none';
            document.getElementById('cancelReasonError').style.display = 'none';
        });

        document.getElementById('confirmCancelReasonBtn').addEventListener('click', function() {
            const select = document.getElementById('cancelReasonSelect');
            const customText = document.getElementById('cancelReasonCustom');
            const errorDiv = document.getElementById('cancelReasonError');
            let reason = '';

            if (select.value === 'other') {
                reason = customText ? customText.value.trim() : '';
            } else {
                reason = select.value.trim();
            }

            if (!reason) {
                errorDiv.style.display = 'block';
                return;
            }

            let reasonInput = document.getElementById('hiddenCancellationReason');
            if (!reasonInput) {
                reasonInput = document.createElement('input');
                reasonInput.type = 'hidden';
                reasonInput.name = 'cancellationReason';
                reasonInput.id = 'hiddenCancellationReason';
                document.getElementById('updateStatusForm').appendChild(reasonInput);
            }
            reasonInput.value = reason;
            document.getElementById('updateStatusForm').submit();
        });

        document.getElementById('cancelReasonModalClose').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('cancel-reason-modal').classList.remove('show');
        });
        document.getElementById('cancel-reason-modal').addEventListener('click', function(e) {
            if (e.target === this) this.classList.remove('show');
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
