<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="com.example.demo1.model.CartItem" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css">
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

<div class="app-container">
    <div class="header-cart">
        <a href="javascript:history.back()" class="back-link" title="Quay lại">
            <i class="fas fa-arrow-left"></i>
        </a>
        <span>Giỏ hàng</span>
    </div>

    <c:if test="${not empty sessionScope.cartError}">
        <div class="alert alert-danger" style="background-color: #f8d7da; color: #721c24; padding: 15px; margin: 10px 15px; border: 1px solid #f5c6cb; border-radius: 5px; position: relative;">
                <c:out value="${sessionScope.cartError}" />
            <span class="close-btn" onclick="this.parentElement.style.display='none';"
                  style="position: absolute; top: 50%; right: 15px; transform: translateY(-50%); cursor: pointer; font-weight: bold; font-size: 20px;">
                &times;
            </span>
        </div>
        <c:remove var="cartError" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty requestScope.cartItems}">
            <div class="empty-cart">
                <i class="fas fa-shopping-cart empty-cart-icon"></i>
                <p class="empty-cart-title">Giỏ hàng trống</p>
                <p class="empty-cart-sub">Bạn chưa có sản phẩm nào trong giỏ hàng.<br>Hãy tiếp tục mua sắm nhé!</p>
                <a href="${pageContext.request.contextPath}/home" class="btn-go-home">
                    <i class="fas fa-home"></i> Về trang chủ
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <c:set var="hasAvailable" value="false"/>
            <c:set var="hasOutOfStock" value="false"/>
            <c:forEach items="${requestScope.cartItems}" var="item">
                <c:choose>
                    <c:when test="${item.product.stock > 0}">
                        <c:set var="hasAvailable" value="true"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="hasOutOfStock" value="true"/>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <div class="cart-select-all">
                <input type="checkbox" id="selectAll" onchange="toggleSelectAll(this)" ${not hasAvailable ? 'disabled' : ''}>
                <label for="selectAll" style="${not hasAvailable ? 'color:#aaa;' : ''}">Chọn tất cả</label>
            </div>

            <div class="cart-content">

                <c:forEach items="${requestScope.cartItems}" var="item">
                    <c:if test="${item.product.stock > 0}">
                        <div class="product-item">
                            <div class="select-item">
                                <input type="checkbox" class="item-checkbox"
                                       data-id="${item.product.id}"
                                       data-price="${item.product.price}"
                                       data-qty="${item.quantity}"
                                       onchange="updateCart()">
                            </div>

                            <img src="${item.product.image}" alt="${item.product.name}">

                            <div class="info">
                                <div class="info-line">
                                    <a href="product-detail?id=${item.product.id}" style="text-decoration: none; color: inherit;">
                                    <span><c:out value="${item.product.name}" /></span>
                                    </a>
                                    <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px;">
                                        <a href="AddCart?action=delete&id=${item.product.id}" class="delete-icon">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                        <div class="qty" data-stock="${item.product.stock}">
                                            <button onclick="changeQty(this, ${item.product.id}, -1)">-</button>
                                            <input type="text" value="${item.quantity}" readonly>
                                            <button onclick="changeQty(this, ${item.product.id}, 1)">+</button>
                                        </div>
                                    </div>
                                </div>
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
                            </div>
                        </div>
                    </c:if>
                </c:forEach>

                <c:if test="${hasOutOfStock}">
                    <div class="out-of-stock-section">
                        <div class="out-of-stock-title">
                            <i class="fas fa-box-open"></i> Sản phẩm đã hết hàng
                        </div>

                        <c:forEach items="${requestScope.cartItems}" var="item">
                            <c:if test="${item.product.stock <= 0}">
                                <div class="product-item disabled">
                                    <div class="select-item">
                                        <input type="checkbox" class="item-checkbox" disabled>
                                    </div>

                                    <img src="${item.product.image}" alt="${item.product.name}">
                                    <div class="info">
                                        <div class="info-line">
                            <span>
                                <a href="ProductDetail?id=${item.product.id}" class="product-name-link">
                                    <span class="product-name-text"><c:out value="${item.product.name}" /></span>
                                </a>
                                <span class="badge-out-of-stock">Hết hàng</span>
                            </span>
                                            <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px;">
                                                <a href="AddCart?action=delete&id=${item.product.id}" class="delete-action">
                                                    <i class="fa fa-trash"></i>
                                                </a>
                                                <div class="qty">
                                                    <button disabled class="qty-disabled">-</button>
                                                    <input type="text" value="${item.quantity}" readonly disabled class="qty-disabled">
                                                    <button disabled class="qty-disabled">+</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div>
                            <span class="current-price" style="color: #888;">
                                <fmt:formatNumber value="${item.product.price}" pattern="#,###"/>₫
                            </span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

            </div>
        </c:otherwise>
    </c:choose>
</div>

<c:if test="${not empty requestScope.cartItems}">
    <div class="footer-bar">
        <span class="total-amount">Tạm tính: <span id="totalDisplay">0</span>₫</span>
        <a href="AddCart?action=checkout" class="btn-buy-link">Mua ngay</a>
    </div>
</c:if>

<script src="js/header.js"></script>
<script>
    function toggleSelectAll(source) {
        document.querySelectorAll('.item-checkbox:not(:disabled)').forEach(cb => cb.checked = source.checked);
        updateCart();
    }

    function updateCart() {
        const all      = document.querySelectorAll('.item-checkbox:not(:disabled)');
        const checked  = document.querySelectorAll('.item-checkbox:checked:not(:disabled)');
        const selectAll = document.getElementById('selectAll');

        if(selectAll && all.length > 0) {
            selectAll.indeterminate = checked.length > 0 && checked.length < all.length;
            selectAll.checked       = all.length > 0 && all.length === checked.length;
        }

        let total = 0;
        checked.forEach(cb => {
            const price = parseFloat(cb.dataset.price) || 0;
            const qty   = parseInt(cb.dataset.qty)     || 1;
            total += price * qty;
        });
        document.getElementById('totalDisplay').textContent = total.toLocaleString('vi-VN');
    }

    function changeQty(btn, productId, delta) {
        const qtyDiv = btn.closest('.qty');
        const qtyInput = qtyDiv.querySelector('input');
        const curQty = parseInt(qtyInput.value);
        const newQty = curQty + delta;

        if (newQty < 1) return;

        fetch('AddCart?action=update&id=' + productId + '&num=' + delta, { method: 'GET' })
            .then(res => {
                if (res.ok) {
                    qtyInput.value = newQty;
                    const checkbox = btn.closest('.product-item').querySelector('.item-checkbox');
                    checkbox.dataset.qty = newQty;
                    updateCart();
                } else {
                    res.text().then(errorMessage => {
                        showToast(errorMessage);
                    });
                }
            })
            .catch(err => console.error(err));
    }

    function showToast(msg) {
        const existing = document.getElementById('stockToast');
        if (existing) existing.remove();

        const toast = document.createElement('div');
        toast.id = 'stockToast';
        toast.className = 'stock-toast';
        toast.textContent = msg;
        document.body.appendChild(toast);

        requestAnimationFrame(() => toast.classList.add('show'));
        setTimeout(() => {
            toast.classList.remove('show');
            setTimeout(() => toast.remove(), 300);
        }, 5000);
    }

    function showLoadingOverlay(text) {
        const overlay = document.getElementById('loading-overlay');
        const textEl = document.getElementById('loading-text');
        if (!overlay) return;
        if (textEl) textEl.textContent = text || 'Đang xử lý...';
        overlay.classList.add('active');
    }

    function hideLoadingOverlay() {
        const overlay = document.getElementById('loading-overlay');
        if (overlay) overlay.classList.remove('active');
    }

    window.addEventListener('pageshow', function(e) {
        if (e.persisted) {
            hideLoadingOverlay();
            document.querySelectorAll('.btn-loading').forEach(btn => btn.classList.remove('btn-loading'));
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        const btnCheckout = document.querySelector('a.btn-buy-link[href*="checkout"]');
        if (btnCheckout) {
            btnCheckout.addEventListener('click', function(e) {
                e.preventDefault();

                const checked = document.querySelectorAll('.item-checkbox:checked:not(:disabled)');
                if (checked.length === 0) {
                    showToast("Vui lòng chọn ít nhất một sản phẩm còn hàng để thanh toán!");
                    return;
                }

                const ids = Array.from(checked).map(cb => cb.dataset.id).join(',');

                this.classList.add('btn-loading');
                const t = setTimeout(() => showLoadingOverlay('Đang chuyển đến thanh toán...'), 400);

                window.location.href = "AddCart?action=checkout&ids=" + ids;
                window.addEventListener('pagehide', () => clearTimeout(t), { once: true });
            });
        }

        document.querySelectorAll('a.delete-icon').forEach(function(link) {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const href = this.getAttribute('href');
                this.classList.add('btn-loading');
                const t = setTimeout(() => showLoadingOverlay('Đang xóa sản phẩm...'), 400);
                window.location.href = href;
                window.addEventListener('pagehide', () => clearTimeout(t), { once: true });
            });
        });
    });
</script>

<script>
    window.CONTEXT_PATH = '<c:out value="${pageContext.request.contextPath}" />';
</script>
<script src="${pageContext.request.contextPath}/js/searchSuggestion.js"></script>
</body>

</html>