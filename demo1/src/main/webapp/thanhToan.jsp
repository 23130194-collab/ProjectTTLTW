<%@ page import="com.example.demo1.model.CartItem" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin giao hàng | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/thongTin.css">
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
                    <span class="cart-badge"><c:out value="${fn:length(requestScope.cartItems)}" /></span>
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
                        <c:out value="${cat.name}" />
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </c:forEach>
        </div>
    </div>
</header>

<div class="overlay" id="overlay"></div>

<div id="loading-overlay" class="loading-overlay">
    <div class="loading-spinner-box">
        <div class="loading-spinner"></div>
        <p class="loading-text" id="loading-text">Đang xử lý...</p>
    </div>
</div>

<form action="ProcessOrderServlet" method="POST" id="checkoutForm">
    <input type="hidden" id="form-address"    name="address"   value="">
    <input type="hidden" id="form-province"   name="province"  value="">
    <input type="hidden" id="form-district"   name="district"  value="">
    <input type="hidden" id="form-ward"       name="ward"      value="">
    <input type="hidden" id="form-address-id" name="addressId" value="">
    <input type="hidden" id="form-fullname-addr" name="recipientName"  value="">
    <input type="hidden" id="form-phone-addr"    name="recipientPhone" value="">
    <input type="hidden" id="form-shipping-fee"  name="shippingFee" value="${shippingFee}">
    <input type="hidden" id="form-voucher-id" name="voucherId" value="">
    <input type="hidden" id="base-total-amount" value="${totalAmount}">
    <input type="hidden" id="voucher-discount-amount" value="0">

    <div class="app-container">
        <div class="app-scroll">
            <div class="header-cart">
                <a href="AddCart?action=view" class="back-link">
                    <i class="fa-solid fa-arrow-left"></i>
                </a>
                <span>Thông tin</span>
            </div>

            <c:set var="totalOldPrice" value="0"/>

            <c:forEach items="${requestScope.cartItems}" var="item">
                <c:set var="totalOldPrice" value="${totalOldPrice + (item.product.oldPrice * item.quantity)}"/>
                <input type="hidden" name="productIds" value="${item.product.id}">

                <div class="product-box">
                    <img src="${item.product.image}" alt="${item.product.name}">
                    <div class="product-info">
                        <b><c:out value="${item.product.name}" /></b><br>
                        <div>
                            <span class="current-price">
                                <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>₫
                            </span>
                            <c:if test="${item.product.oldPrice > item.product.price}">
                                <span class="old-price">
                                    <fmt:formatNumber value="${item.product.oldPrice}" pattern="#,###"/>₫
                                </span>
                            </c:if>
                        </div>
                        <small class="product-qty">Số lượng: <c:out value="${item.quantity}" /></small>
                    </div>
                </div>
            </c:forEach>

            <div class="section">
                <div class="section-title">THÔNG TIN KHÁCH HÀNG</div>

                <input name="fullname" class="input-box" value="${sessionScope.user.name}"
                       placeholder="Họ và tên*" required>

                <input name="phone" id="phone" class="input-box" value="${sessionScope.user.phone}"
                       placeholder="Số điện thoại*" required type="tel"
                       pattern="^(03|05|07|08|09)[0-9]{8}$"
                       title="Số điện thoại phải có 10 chữ số và bắt đầu bằng 03, 05, 07, 08 hoặc 09">

                <input name="email" class="input-box" value="${sessionScope.user.email}"
                       placeholder="Email*" type="email" required>
            </div>

            <div class="section">
                <div class="section-title">ĐỊA CHỈ NHẬN HÀNG</div>

                <c:choose>
                    <c:when test="${not empty requestScope.userAddresses}">
                        <div id="selected-address-box">
                            <c:choose>
                                <c:when test="${not empty requestScope.defaultAddress}">
                                    <div class="selected-address-display">
                                        <div class="addr-name-phone">
                                            <c:if test="${not empty requestScope.defaultAddress.label}">
                                                <span class="addr-label"><c:out value="${requestScope.defaultAddress.label}" /></span>
                                            </c:if>
                                                <c:out value="${requestScope.defaultAddress.fullName}" />
                                            &nbsp;|&nbsp;
                                                <c:out value="${requestScope.defaultAddress.phone}" />
                                            <span class="addr-default-badge">Mặc định</span>
                                        </div>
                                        <div class="addr-detail"><c:out value="${requestScope.defaultAddress.fullAddress}" /></div>
                                        <button type="button" class="btn-change-address" id="btnOpenAddressModal">
                                            <i class="fa-solid fa-pen-to-square"></i> Thay đổi
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:set var="firstAddr" value="${requestScope.userAddresses[0]}"/>
                                    <div class="selected-address-display">
                                        <div class="addr-name-phone">
                                            <c:if test="${not empty firstAddr.label}">
                                                <span class="addr-label"><c:out value="${firstAddr.label}" /></span>
                                            </c:if>
                                                <c:out value="${firstAddr.fullName}" />
                                            &nbsp;|&nbsp;
                                                <c:out value="${firstAddr.phone}" />
                                        </div>
                                        <div class="addr-detail"><c:out value="${firstAddr.fullAddress}" /></div>
                                        <button type="button" class="btn-change-address" id="btnOpenAddressModal">
                                            <i class="fa-solid fa-pen-to-square"></i> Thay đổi
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div id="selected-address-box">
                            <div class="no-address-hint">
                                <i class="fa-solid fa-location-dot"></i>
                                Bạn chưa có địa chỉ nhận hàng nào.
                            </div>
                            <button type="button" class="btn-change-address" id="btnOpenAddressModal"
                                    style="width:100%; text-align:center;" onclick="openAddressModal()">
                                <i class="fa-solid fa-plus"></i> Thêm địa chỉ nhận hàng
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>

                <textarea name="note" placeholder="Ghi chú (nếu có)" style="margin-top:10px;"></textarea>
            </div>

            <div class="payment-box">
                <div class="section-title">PHƯƠNG THỨC THANH TOÁN</div>
                <select name="payment_method" class="payment-select">
                    <option value="Thanh toán khi nhận hàng (COD)">Thanh toán khi nhận hàng (COD)</option>
                    <option value="VNPAY">Chuyển khoản qua VNPAY</option>
                </select>
            </div>

            <div class="voucher-select-box">
                <div class="section-title">VOUCHER</div>
                <select id="voucherSelect" class="voucher-select">
                    <option value="" data-discount="0" data-min-order="0">Không sử dụng voucher</option>
                    <c:forEach items="${requestScope.userVouchers}" var="voucher">
                        <option value="${voucher.id}" data-discount="${voucher.discountValue}" data-min-order="${voucher.minOrderValue}">
                            <c:out value="${voucher.code}" /> - Giảm <fmt:formatNumber value="${voucher.discountValue}" pattern="#,###"/>đ
                        </option>
                    </c:forEach>
                </select>
                <div id="voucher-error-msg" style="color: #ef4444; font-size: 13px; margin-top: 5px; display: none;"></div>
            </div>

            <c:set var="shippingFee" value="${empty shippingFee ? 0 : shippingFee}"/>
            <c:set var="payableAmount" value="${totalAmount + shippingFee}"/>

            <div class="box">
                <div class="section-title">CHI TIẾT THANH TOÁN</div>
                <c:if test="${not empty shippingError or not empty sessionScope.checkoutError}">
                    <div class="ajax-error" style="color:#e53935;font-size:13px;margin-bottom:8px;padding:8px 10px;background:#fff0f0;border-radius:6px;border:1px solid #ffc6c6;">
                        <c:out value="${not empty sessionScope.checkoutError ? sessionScope.checkoutError : shippingError}"/>
                    </div>
                    <c:remove var="checkoutError" scope="session"/>
                </c:if>
                <div class="line">
                    Tổng tiền hàng
                    <span><fmt:formatNumber value="${totalOldPrice}" pattern="#,###"/>₫</span>
                </div>
                <c:if test="${totalOldPrice > totalAmount}">
                    <div class="line discount">
                        Giảm giá trực tiếp
                        <span>-<fmt:formatNumber value="${totalOldPrice - totalAmount}" pattern="#,###"/>₫</span>
                    </div>
                </c:if>
                <div class="line voucher-discount" id="voucherDiscountLine" style="display:none;">
                    Voucher
                    <span id="voucherDiscountDisplay">-0₫</span>
                </div>
                <div class="line">
                    Phí vận chuyển
                    <span id="shippingFeeDisplay">
                        <c:choose>
                            <c:when test="${shippingFee == 0}">Miễn phí</c:when>
                            <c:otherwise><fmt:formatNumber value="${shippingFee}" pattern="#,###"/>₫</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="line total">
                    <b>Tổng tiền thanh toán</b>
                    <b id="payableAmountDisplay"><fmt:formatNumber value="${payableAmount}" pattern="#,###"/>₫</b>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-bar">
        <span class="total-amount">Tạm tính: <span id="footerPayableAmount"><fmt:formatNumber value="${payableAmount}" pattern="#,###"/>₫</span></span>
        <button type="submit" class="btn-buy-link">Thanh Toán</button>
    </div>
</form>

<div class="address-modal-overlay" id="addressModalOverlay">
    <div class="address-modal-box">
        <div class="address-modal-header">
            <h3>Địa chỉ nhận hàng</h3>
            <button type="button" class="address-modal-close" id="btnCloseAddressModal">&times;</button>
        </div>

        <div id="modalAddressCardList">
            <c:choose>
                <c:when test="${not empty requestScope.userAddresses}">
                    <div class="address-list-title">Chọn địa chỉ</div>
                    <c:forEach items="${requestScope.userAddresses}" var="addr">
                        <div class="address-card ${addr.defaultAddress ? 'selected' : ''}"
                             data-id="${addr.id}"
                             data-fullname="${addr.fullName}"
                             data-phone="${addr.phone}"
                             data-full-address="${addr.fullAddress}"
                             data-ward="${addr.ward}"
                             data-district="${addr.district}"
                             data-province="${addr.province}"
                             data-default="${addr.defaultAddress}"
                             onclick="selectAddress(this)">
                            <div class="addr-name-phone">
                                <c:if test="${not empty addr.label}">
                                    <span class="addr-label"><c:out value="${addr.label}" /></span>
                                </c:if>
                                    <c:out value="${addr.fullName}" /> &nbsp;|&nbsp; <c:out value="${addr.phone}" />
                                <c:if test="${addr.defaultAddress}">
                                    <span class="addr-default-badge">Mặc định</span>
                                </c:if>
                            </div>
                            <div class="addr-detail"><c:out value="${addr.fullAddress}" /></div>
                            <input type="radio" class="addr-radio"
                                   name="addrRadio" value="${addr.id}"
                                ${addr.defaultAddress ? 'checked' : ''}
                                   onclick="event.stopPropagation(); selectAddress(this.closest('.address-card'))">
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-address-hint" id="noAddressHint">
                        <i class="fa-solid fa-location-dot"></i>
                        Chưa có địa chỉ nào. Hãy thêm địa chỉ mới bên dưới.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="add-address-toggle" id="toggleNewAddressForm">
            <i class="fa-solid fa-plus"></i> Thêm địa chỉ mới
        </div>

        <form class="new-address-form" id="newAddressForm">
            <input type="hidden" name="action" value="add">

            <div class="row-2col">
                <input class="input-box" name="fullName"
                       placeholder="Họ tên người nhận*" required
                       value="${sessionScope.user.name}">
                <input class="input-box" name="phone" type="tel"
                       placeholder="Số điện thoại*" required
                       pattern="^(03|05|07|08|09)[0-9]{8}$"
                       value="${sessionScope.user.phone}">
            </div>
            <input class="input-box" name="label" placeholder="Nhà, Công ty, ...">

            <select name="province" id="newProvince" required>
                <option value="">Chọn Tỉnh/Thành phố*</option>
            </select>
            <select name="district" id="newDistrict" required>
                <option value="">Chọn Quận/Huyện*</option>
            </select>
            <select name="ward" id="newWard" required>
                <option value="">Chọn Phường/Xã*</option>
            </select>
            <input class="input-box" name="addressDetail"
                   placeholder="Số nhà, tên đường*" required>

            <div class="checkbox-row">
                <input type="checkbox" name="defaultAddress" id="newDefaultCheck" value="true">
                <label for="newDefaultCheck">Đặt làm địa chỉ mặc định</label>
            </div>
            <button type="submit" class="btn-save-new-address">
                 Lưu địa chỉ
            </button>
        </form>
    </div>
</div>

<script>
    window.CONTEXT_PATH = '<c:out value="${pageContext.request.contextPath}" />';
</script>
<script src="js/header.js"></script>
<script src="${pageContext.request.contextPath}/js/thanhToan.js"></script>
<script src="${pageContext.request.contextPath}/js/searchSuggestion.js"></script>
</body>
</html>
