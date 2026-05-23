<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Chi tiết đơn hàng | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${contextPath}/css/user.css">
    <link rel="stylesheet" href="${contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/search.css">
</head>

<body>
<header class="header">
    <div class="header-container">
        <a href="${pageContext.request.contextPath}/home" class="logo">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
            <span class="brand-name">TechNova</span>
        </a>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="active">Trang chủ</a>
            <a href="${pageContext.request.contextPath}/gioiThieu.jsp">Giới thiệu</a>
            <a href="#" id="category-toggle">Danh mục</a>
            <a href="${pageContext.request.contextPath}/contact">Liên hệ</a>
        </nav>

        <div class="search-box" style="position: relative; overflow: visible;">
            <form action="search" method="get" id="searchForm" style="display: flex; width: 100%;">
                <input type="text" name="keyword" id="searchInput" autocomplete="off" placeholder="Bạn muốn mua gì...">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
            <div id="suggestion-box" class="suggestion-box"></div>
        </div>

        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="icon-btn cart-btn-wrapper" title="Giỏ hàng">
                <i class="fas fa-shopping-cart"></i>
                <c:if test="${not empty requestScope.cartItems}">
                    <span class="cart-badge">${fn:length(requestScope.cartItems)}</span>
                </c:if>
            </a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/my-orders" class="icon-btn" title="Tài khoản của bạn">
                        <i class="fas fa-user"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="icon-btn" title="Đăng nhập">
                        <i class="fas fa-user"></i>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="category-box" id="categoryBox">
            <c:forEach items="${applicationScope.categoryList}" var="cat">
                <a href="list-product?id=${cat.id}" class="category-item">
                    <c:set var="imageSrc" value="${cat.image}"/>
                    <c:choose>
                        <c:when test="${fn:startsWith(imageSrc, 'http')}">
                            <img src="${imageSrc}" class="category-icon" alt="${cat.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/${imageSrc}" class="category-icon" alt="${cat.name}">
                        </c:otherwise>
                    </c:choose>
                        ${cat.name}
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </c:forEach>
        </div>
    </div>
</header>

<div class="container">
    <div class="top-card">
        <div class="profile">
            <div class="summary-card">
                <div class="summary-left">
                    <div class="reviewer-avatar">${fn:substring(sessionScope.user.name, 0, 1)}</div>
                    <div class="summary-info">
                        <div class="summary-name">${sessionScope.user.name}</div>
                        <div class="summary-phone">${sessionScope.user.phone}</div>
                    </div>
                </div>
                <div class="summary-divider"></div>
                <div class="summary-item">
                    <div class="summary-icon">
                        <i class="fa-solid fa-cart-shopping" style="color: #ff0000;"></i>
                    </div>
                    <div class="summary-text">
                        <div class="summary-count">${totalOrders}</div>
                        <div class="summary-label">Tổng số đơn hàng đã mua</div>
                    </div>
                </div>

                <div class="summary-divider"></div>

                <div class="summary-item">
                    <div class="summary-icon">
                        <i class="fa-solid fa-sack-dollar" style="color: #74C0FC;"></i>
                    </div>
                    <div class="summary-text">
                        <div class="summary-count">
                            <fmt:formatNumber value="${totalSpent}" pattern="#,###"/>đ
                        </div>
                        <div class="summary-small">Tổng tiền tích lũy</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="main">
        <aside class="side">
            <nav class="menu">
                <a href="${contextPath}/my-orders" class="menu-item active">
                    <i class="fa-solid fa-list icon"></i> <span class="label">Đơn hàng của tôi</span>
                </a>
                <a href="${contextPath}/favorites" class="menu-item">
                    <i class="fa-regular fa-heart icon"></i> <span class="label">Sản phẩm yêu thích</span>
                </a>
                <a href="${contextPath}//account" class="menu-item">
                    <i class="fa-regular fa-user icon"></i> <span class="label">Thông tin tài khoản</span>
                </a>
                <a href="#" id="logoutLink" class="menu-item">
                    <i class="fa-solid fa-right-from-bracket icon"></i>
                    <span class="label">Đăng xuất</span>
                </a>
            </nav>
        </aside>

        <section class="content">
            <div class="order-filter-tabs">
                <a href="${pageContext.request.contextPath}/my-orders"
                   class="tab-link ${empty param.status ? 'active' : ''}">Tất cả</a>

                <a href="${pageContext.request.contextPath}/my-orders?status=Chờ xác nhận"
                   class="tab-link ${param.status == 'Chờ xác nhận' ? 'active' : ''}">Chờ xác nhận</a>

                <a href="${pageContext.request.contextPath}/my-orders?status=Đang xử lý"
                   class="tab-link ${param.status == 'Đang xử lý' ? 'active' : ''}">Đang xử lý</a>

                <a href="${pageContext.request.contextPath}/my-orders?status=Đang giao"
                   class="tab-link ${param.status == 'Đang giao' ? 'active' : ''}">Đang giao</a>

                <a href="${pageContext.request.contextPath}/my-orders?status=Đã giao"
                   class="tab-link ${param.status == 'Đã giao' ? 'active' : ''}">Đã giao</a>

                <a href="${pageContext.request.contextPath}/my-orders?status=Đã hủy"
                   class="tab-link ${param.status == 'Đã hủy' ? 'active' : ''}">Đã hủy</a>
            </div>
            <div class="section active" id="order-details">
                <c:if test="${not empty order}">
                    <div class="order-details-view">
                        <a class="back-link" href="${contextPath}/my-orders">
                            <i class="fa-solid fa-chevron-left"></i>
                            Đơn hàng của tôi / <span>Chi tiết đơn hàng</span>
                        </a>

                        <div class="card detail-card">
                            <h3 class="card-title">Tổng quan</h3>
                            <div class="overview-header">
                                <span>Đơn hàng: <strong>${order.orderCode}</strong></span>
                                <span class="divider"></span>
                                <span>Ngày đặt hàng: <strong><fmt:formatDate value="${order.createdAt}" pattern="HH:mm dd/MM/yyyy"/></strong></span>
                                <span class="divider"></span>
                                <span>Trạng thái hiện tại: <strong>${order.orderStatus}</strong></span>
                            </div>

                            <c:forEach var="item" items="${orderItems}">
                                <div class="overview-product">
                                    <img src="${item.productImage}" alt="${item.productName}" class="product-thumb-small">
                                    <div class="product-details-small">
                                        <div class="product-title-small">${item.productName}</div>
                                        <div class="product-price-small">
                                            <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>đ
                                        </div>
                                    </div>
                                    <div class="product-quantity-small">
                                        <span>Số lượng: <strong>${item.quantity}</strong></span>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <div class="card detail-card">
                            <h3 class="card-title">Lịch sử trạng thái</h3>
                            <div class="order-timeline">
                                <c:forEach var="step" items="${timelineSteps}" varStatus="loop">
                                    <div class="timeline-step ${step.completed ? 'completed' : ''} ${step.current ? 'current' : ''} ${step.cancelled ? 'cancelled' : ''}">
                                        <div class="timeline-icon">
                                            <c:choose>
                                                <c:when test="${step.cancelled}">
                                                    <i class="fa-solid fa-xmark"></i>
                                                </c:when>
                                                <c:when test="${step.completed}">
                                                    <i class="fa-solid fa-check"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-regular fa-clock"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="timeline-content">
                                            <div class="timeline-title">${step.status}</div>
                                            <div class="timeline-time">
                                                <c:choose>
                                                    <c:when test="${not empty step.occurredAt}">
                                                        <fmt:formatDate value="${step.occurredAt}" pattern="HH:mm dd/MM/yyyy"/>
                                                    </c:when>
                                                    <c:otherwise>Chưa cập nhật</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <c:if test="${not loop.last}">
                                        <div class="timeline-connector ${step.completed and not step.current ? 'completed' : ''}"></div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="card detail-card">
                            <h3 class="card-title">Thông tin thanh toán</h3>
                            <div class="payment-group">
                                <div class="payment-sub-title">Sản phẩm</div>
                                <div class="payment-line-new"><span>Số lượng sản phẩm:</span><strong>${fn:length(orderItems)}</strong></div>
                                <div class="payment-line-new"><span>Tổng tiền hàng:</span><strong><fmt:formatNumber value="${order.subprice}" pattern="#,###"/>đ</strong></div>
                                <div class="payment-line-new"><span>Giảm giá:</span><strong style="color:var(--accent-dark);">-<fmt:formatNumber value="${order.discountAmount}" pattern="#,###"/>đ</strong></div>
                                <div class="payment-line-new"><span>Phí vận chuyển:</span><strong style="color:green;">Miễn phí</strong></div>
                            </div>

                            <div class="payment-group">
                                <div class="payment-sub-title">Thanh toán</div>
                                <div class="payment-line-new final"><span>Tổng số tiền:</span><strong class="final-price"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</strong></div>
                                <div class="payment-line-new final"><span>Tổng số tiền đã thanh toán:</span><strong class="final-price"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</strong></div>
                            </div>
                        </div>

                        <c:if test="${order.orderStatus eq 'Chờ xác nhận'}">
                            <div class="action-footer">
                                <button type="button" id="showCancelModalBtn" class="btn-cancel-order">Hủy đơn hàng</button>
                            </div>

                            <div id="cancelOrderModal" class="cancel-modal-overlay">
                                <div class="cancel-modal-content">
                                    <form id="cancelOrderForm" action="${contextPath}/order-detail" method="post">
                                        <div class="modal-header">
                                            <h3>Lý do hủy đơn hàng</h3>
                                            <p>Vui lòng cho chúng tôi biết lý do bạn muốn hủy đơn hàng này.</p>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="id" value="${order.id}">
                                            <div class="input-group">
                                                <select name="cancellationReason" id="cancellationReason" class="form-control" required>
                                                    <option value="" disabled selected>-- Chọn lý do --</option>
                                                    <option value="Hết nhu cầu mua hàng">Hết nhu cầu mua hàng</option>
                                                    <option value="Đặt nhầm sản phẩm">Đặt nhầm sản phẩm</option>
                                                    <option value="Cần thay đổi phương thức thanh toán">Cần thay đổi phương thức thanh toán</option>
                                                    <option value="Muốn thay đổi địa chỉ giao hàng">Muốn thay đổi địa chỉ giao hàng</option>
                                                    <option value="Tìm thấy nơi khác giá tốt hơn">Tìm thấy nơi khác giá tốt hơn</option>
                                                    <option value="Lý do khác">Lý do khác</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="submit" id="confirmCancelBtn" class="modal-btn modal-btn-confirm">Xác nhận hủy</button>
                                            <button type="button" id="closeModalBtn" class="modal-btn modal-btn-cancel">Không</button>
                                        </div>
                                    </form>
                                </div>
	                            </div>
	                        </c:if>

                        <c:if test="${order.orderStatus eq 'Đang giao'}">
                            <div class="action-footer">
                                <button type="button" id="showConfirmReceivedModalBtn" class="btn-confirm-received">
                                    Xác nhận nhận hàng
                                </button>
                            </div>

                            <div id="confirmReceivedModal" class="cancel-modal-overlay confirm-received-modal">
                                <div class="cancel-modal-content">
                                    <form action="${contextPath}/confirm-received" method="post">
                                        <div class="modal-header">
                                            <h3>Xác nhận nhận hàng</h3>
                                            <p>Bạn xác nhận đã nhận được đơn hàng ${order.orderCode}? Sau khi xác nhận, đơn hàng sẽ được hoàn tất.</p>
                                        </div>
                                        <input type="hidden" name="id" value="${order.id}">
                                        <div class="modal-footer">
                                            <button type="submit" class="modal-btn modal-btn-confirm modal-btn-confirm-received">Xác nhận</button>
                                            <button type="button" id="closeConfirmReceivedModalBtn" class="modal-btn modal-btn-cancel">Không</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </c:if>
                <c:if test="${empty order}">
                    <p style="text-align: center; padding: 50px;">Không tìm thấy thông tin đơn hàng.</p>
                </c:if>
            </div>
        </section>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
	        const showModalBtn = document.getElementById('showCancelModalBtn');
	        const modal = document.getElementById('cancelOrderModal');
	        const closeModalBtn = document.getElementById('closeModalBtn');
	        const showConfirmReceivedModalBtn = document.getElementById('showConfirmReceivedModalBtn');
	        const confirmReceivedModal = document.getElementById('confirmReceivedModal');
	        const closeConfirmReceivedModalBtn = document.getElementById('closeConfirmReceivedModalBtn');

        if (showModalBtn) {
            showModalBtn.addEventListener('click', function () {
                if(modal) modal.style.display = 'flex';
            });
        }

	        if (closeModalBtn) {
	            closeModalBtn.addEventListener('click', function () {
	                if(modal) modal.style.display = 'none';
	            });
	        }

	        if (showConfirmReceivedModalBtn) {
	            showConfirmReceivedModalBtn.addEventListener('click', function () {
	                if(confirmReceivedModal) confirmReceivedModal.style.display = 'flex';
	            });
	        }

	        if (closeConfirmReceivedModalBtn) {
	            closeConfirmReceivedModalBtn.addEventListener('click', function () {
	                if(confirmReceivedModal) confirmReceivedModal.style.display = 'none';
	            });
	        }

	        window.addEventListener('click', function (event) {
	            if (event.target === modal) {
	                if(modal) modal.style.display = 'none';
	            }
	            if (event.target === confirmReceivedModal) {
	                if(confirmReceivedModal) confirmReceivedModal.style.display = 'none';
	            }
	        });
    });
</script>
<script>
    window.CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>
<script src="${pageContext.request.contextPath}/js/searchSuggestion.js"></script>

</body>
</html>
