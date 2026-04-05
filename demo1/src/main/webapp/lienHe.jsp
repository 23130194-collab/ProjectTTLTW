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
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Liên hệ | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lienHe.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
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
                    <a href="${pageContext.request.contextPath}/my-orders" class="icon-btn active"
                       title="Tài khoản của bạn">
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
<main>

    <section class="form-section">
        <div>
            <h2>Liên hệ với chúng tôi</h2>
            <p class="subtitle">Gửi tin nhắn — phản hồi trong 24h làm việc.</p>
            <img src="https://cdn-icons-png.flaticon.com/512/4712/4712108.png" alt="contact icon" class="contact-icon">
        </div>

        <c:if test="${not empty sessionScope.contactMessage}">
            <div class="contact-alert alert-${sessionScope.messageType}">
                    ${sessionScope.contactMessage}
            </div>
            <c:remove var="contactMessage" scope="session"/>
            <c:remove var="messageType" scope="session"/>
        </c:if>

        <form action="${pageContext.request.contextPath}/contact" method="post">
            <label for="name">Họ và tên *</label>
            <input type="text" id="name" name="name" placeholder="Họ và tên"
                   value="${loggedInUser.name}" ${not empty loggedInUser ? 'readonly' : ''} required/>

            <label for="email">Email *</label>
            <input type="email" id="email" name="email" placeholder="you@example.com"
                   value="${loggedInUser.email}" ${not empty loggedInUser ? 'readonly' : ''} required/>

            <label for="content">Nội dung *</label>
            <textarea id="content" name="content" placeholder="Nhập nội dung..." required></textarea>

            <button type="submit">Gửi</button>
        </form>
    </section>

    <div class="right-column">
        <section class="info-section">
            <h2>Thông tin cửa hàng</h2>
            <div class="info-item">
                <i class="fa-solid fa-location-dot"></i>
                <div><strong>Địa chỉ</strong> Khu phố 33, phường Linh Xuân , Thành phố Hồ Chí Minh , Việt Nam</div>
            </div>
            <div class="info-item">
                <i class="fa-solid fa-phone"></i>
                <div><strong>Điện thoại</strong> +84 123 456 789</div>
            </div>
            <div class="info-item">
                <i class="fa-solid fa-envelope"></i>
                <div><strong>Email</strong> support@technova.com</div>
            </div>
            <div class="info-item">
                <i class="fa-solid fa-clock"></i>
                <div><strong>Giờ làm việc</strong> Thứ 2 - Thứ 7: 07:00 - 22:00</div>
            </div>

            <h2>Kết nối với chúng tôi</h2>
            <div class="socials">
                <a href="#"><i class="fa-brands fa-facebook" style="color: #0062ff;"></i></a>
                <a href="#"><i class="fa-brands fa-instagram" style="color: #ff0095;"></i></a>
                <a href="#"><i class="fa-brands fa-youtube" style="color: #ff0000;"></i></a>
                <a href="#"><i class="fa-brands fa-tiktok" style="color: #000000;"></i></a>
            </div>
        </section>

        <div class="map-box">
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.214525515939!2d106.78918677408876!3d10.871281657438859!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3175276398969f7b%3A0x9672b7efd0893fc4!2zVHLGsOG7nW5nIMSQ4bqhaSBo4buNYyBOw7RuZyBMw6JtIFRQLiBI4buTIENow60gTWluaA!5e0!3m2!1svi!2s!4v1736802873211!5m2!1svi!2s"
                    allowfullscreen loading="lazy"></iframe>
        </div>
    </div>
</main>
<footer>
    <div class="footer-container">
        <div class="footer-main-content">

            <div class="footer-col col-1">
                <h4>Tổng đài hỗ trợ miễn phí</h4>
                <ul>
                    <li>Mua hàng - bảo hành 1800.2097 (7h30 - 18h30)</li>
                    <li>Khiếu nại 1800.2063 (8h00 - 21h30)</li>
                </ul>

                <h4>Phương thức thanh toán</h4>
                <div class="payment-methods">
                    <img src="https://i.postimg.cc/FsJvZGsX/apple-Pay.png" alt="Apple Pay">
                    <img src="https://i.postimg.cc/pTTbnJ10/bidv.png" alt="BIDV">
                    <img src="https://i.postimg.cc/L6fXXmPn/momo.jpg" alt="MoMo">
                    <img src="https://i.postimg.cc/bYn803wR/Zalo-Pay.png" alt="Zalo Pay">
                </div>
            </div>

            <div class="footer-col col-2">
                <h4>Thông tin về chính sách</h4>
                <ul>
                    <li>Mua hàng và thanh toán online</li>
                    <li>Mua hàng trả góp online</li>
                    <li>Mua hàng trả góp bằng thẻ tín dụng</li>
                    <li>Chính sách giao hàng</li>
                    <li>Chính sách đổi trả</li>
                    <li>Đổi điểm</li>
                    <li>Xem ưu đãi</li>
                    <li>Tra cứu hóa đơn điện tử</li>
                    <li>Thông tin hóa đơn mua hàng</li>
                    <li>Trung tâm bảo hành chính hãng</li>
                    <li>Quy định về việc sao lưu dữ liệu</li>
                    <li>Thuế VAT</li>
                </ul>
            </div>

            <div class="footer-col col-3">
                <h4>Dịch vụ và thông tin khác</h4>
                <ul>
                    <li>Khách hàng doanh nghiệp</li>
                    <li>Ưu đãi thanh toán</li>
                    <li>Quy chế hoạt động</li>
                    <li>Chính sách bảo mật thông tin cá nhân</li>
                    <li>Chính sách bảo hành</li>
                    <li>Liên hệ hợp tác kinh doanh</li>
                    <li>Tuyển dụng</li>
                    <li>Dịch vụ bảo hành</li>
                </ul>
            </div>

            <div class="footer-col col-4">
                <h4>Kết nối với TechNova</h4>
                <div class="connect-methods">
                    <img src="https://i.postimg.cc/CLjh0my7/youtube.png" alt="Youtube">
                    <img src="https://i.postimg.cc/rsBv3Xyx/facebook.png" alt="Facebook">
                    <img src="https://i.postimg.cc/vBkYYKHS/tiktok.png" alt="TikTok">
                    <img src="https://i.postimg.cc/k55qxC26/Zalo.png" alt="Zalo">
                </div>
            </div>

        </div>
        <div class="footer-subscription"></div>
    </div>
</footer>
<script src="${pageContext.request.contextPath}/js/header.js"></script>

</body>
</html>
