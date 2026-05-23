<%@ page import="com.example.demo1.model.CartItem" %>
<%@ page import="java.util.Map" %>
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
    <link rel="stylesheet" href="css/header.css">
    <link rel="stylesheet" href="css/thongTin.css">
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

        <div class="search-box">
            <form action="search" method="get" id="searchForm" style="display: flex; width: 100%;">
                <input type="text" name="keyword" id="searchInput"
                       placeholder="Bạn muốn mua gì hôm nay?" autocomplete="off">
                <button type="submit"><i class="fas fa-search"></i></button>
            </form>
            <div id="suggestion-box" class="suggestion-box" style="display:none;"></div>
        </div>

        <div class="header-actions">

            <%
                int totalQuantity = 0;
                Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");

                if (cart != null) {
                    totalQuantity = cart.size();
                }
            %>

            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="icon-btn cart-btn-wrapper"
               title="Giỏ hàng">
                <i class="fas fa-shopping-cart"></i>

                <% if (totalQuantity > 0) { %>
                <span class="cart-badge"><%= totalQuantity %></span>
                <% } %>
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
                            <img src="${pageContext.request.contextPath}/${imageSrc}" class="category-icon"
                                 alt="${cat.name}">
                        </c:otherwise>
                    </c:choose>
                        ${cat.name}
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

<form action="ProcessOrderServlet" method="POST">
    <div class="app-container">
        <div class="app-scroll">
            <div class="header-cart">
                <a href="AddCart?action=view" class="back-link">
                    <i class="fa-solid fa-arrow-left"></i>
                </a>
                <span>Thông tin</span>
            </div>

            <c:set var="totalOldPrice" value="0"/>
            <c:forEach items="${sessionScope.cart}" var="entry">
                <c:set var="item" value="${entry.value}"/>
                <c:set var="totalOldPrice" value="${totalOldPrice + (item.product.oldPrice * item.quantity)}"/>

                <div class="product-box">
                    <img src="${item.product.image}" alt="${item.product.name}">
                    <div class="product-info">
                        <b>${item.product.name}</b><br>
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
                        <small class="product-qty">Số lượng: ${item.quantity}</small>
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

                <select name="province" id="province" required>
                    <option value="">Chọn Tỉnh/Thành phố*</option>
                </select>

                <select name="district" id="district" required>
                    <option value="">Chọn Quận/Huyện*</option>
                </select>

                <select name="ward" id="ward" required>
                    <option value="">Chọn Phường/Xã*</option>
                </select>
                <textarea name="address" placeholder="Số nhà, tên đường*" required></textarea>
                <textarea name="note" placeholder="Ghi chú (nếu có)"></textarea>
            </div>

            <div class="payment-box">
                <div class="section-title">PHƯƠNG THỨC THANH TOÁN</div>
                <select name="payment_method" class="payment-select">
                    <option value="Thanh toán khi nhận hàng (COD)">Thanh toán khi nhận hàng (COD)</option>
                    <option value="Chuyển khoản ngân hàng">Chuyển khoản ngân hàng</option>
                </select>
            </div>

            <div class="box">
                <div class="section-title">CHI TIẾT THANH TOÁN</div>
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
                <div class="line">
                    Phí vận chuyển
                    <span>0đ</span>
                </div>
                <div class="line total">
                    <b>Tổng tiền thanh toán</b>
                    <b><fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫</b>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-bar">
        <span class="total-amount">Tạm tính: <fmt:formatNumber value="${totalAmount}" pattern="#,###"/>₫</span>
        <button type="submit" class="btn-buy-link">Thanh Toán</button>
    </div>
</form>

</body>
<script src="js/header.js"></script>
<script>
    const form = document.querySelector('form');
    form.addEventListener('submit', function (event) {
        const phone = document.getElementById('phone');
        const email = document.querySelector('input[type="email"]');

        const phoneRegex = /^(03|05|07|08|09)[0-9]{8}$/;
        if (!phoneRegex.test(phone.value)) {
            alert("Số điện thoại không hợp lệ! Phải có 10 số và đúng đầu số nhà mạng.");
            phone.focus();
            event.preventDefault();
            return false;
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email.value)) {
            alert("Định dạng email không đúng!");
            email.focus();
            event.preventDefault();
            return false;
        }

        const submitBtn = form.querySelector('button[type="submit"]');
        if (submitBtn) submitBtn.classList.add('btn-loading');
        const overlay = document.getElementById('loading-overlay');
        const textEl = document.getElementById('loading-text');
        const t = setTimeout(function() {
            if (textEl) textEl.textContent = 'Đang xử lý đơn hàng...';
            if (overlay) overlay.classList.add('active');
        }, 400);
        window.addEventListener('pagehide', function() { clearTimeout(t); }, { once: true });
    });

    window.addEventListener('pageshow', function(e) {
        if (e.persisted) {
            const overlay = document.getElementById('loading-overlay');
            if (overlay) overlay.classList.remove('active');
            document.querySelectorAll('.btn-loading').forEach(function(btn) { btn.classList.remove('btn-loading'); });
        }
    });
</script>
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    $(document).ready(function() {
        fetch('https://provinces.open-api.vn/api/p/')
            .then(response => response.json())
            .then(data => {
                let html = '<option value="">Chọn Tỉnh/Thành phố*</option>';
                data.forEach(item => {
                    html += '<option data-code="' + item.code + '" value="' + item.name + '">' + item.name + '</option>';
                });
                $('#province').html(html);
            })
            .catch(err => console.error("Lỗi tải Tỉnh/Thành:", err));

        $('#province').change(function() {
            const code = $(this).find(':selected').data('code');
            if (code) {
                fetch('https://provinces.open-api.vn/api/p/' + code + '?depth=2')
                    .then(response => response.json())
                    .then(data => {
                        let html = '<option value="">Chọn Quận/Huyện*</option>';
                        if (data.districts) {
                            data.districts.forEach(item => {
                                html += '<option data-code="' + item.code + '" value="' + item.name + '">' + item.name + '</option>';
                            });
                        }
                        $('#district').html(html);
                        $('#ward').html('<option value="">Chọn Phường/Xã*</option>');
                    });
            } else {
                $('#district').html('<option value="">Chọn Quận/Huyện*</option>');
                $('#ward').html('<option value="">Chọn Phường/Xã*</option>');
            }
        });

        $('#district').change(function() {
            const code = $(this).find(':selected').data('code');
            if (code) {
                fetch('https://provinces.open-api.vn/api/d/' + code + '?depth=2')
                    .then(response => response.json())
                    .then(data => {
                        let html = '<option value="">Chọn Phường/Xã*</option>';
                        if (data.wards) {
                            data.wards.forEach(item => {
                                html += '<option data-code="' + item.code + '" value="' + item.name + '">' + item.name + '</option>';
                            });
                        }
                        $('#ward').html(html);
                    });
            } else {
                $('#ward').html('<option value="">Chọn Phường/Xã*</option>');
            }
        });
    });
</script>
</html>
