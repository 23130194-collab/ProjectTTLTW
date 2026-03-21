<%@ page import="com.example.demo1.model.CartItem" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giới Thiệu | TechNova</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gioiThieu.css">
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
                    <a href="${pageContext.request.contextPath}/account" class="icon-btn active"
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

        <!-- Danh mục -->
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
<section class="hero-section">
    <div class="hero-content">
        <h1 class="hero-logo">TECHNOVA</h1>
        <p class="tagline">Nơi Công Nghệ Trở Nên Hoàn Hảo</p>
        <p class="subtitle">Đối tác tin cậy cho mọi dự án công nghệ của bạn</p>
    </div>
</section>

<section class="section values-section">
    <h2 class="section-title">Giá Trị Cốt Lõi</h2>
    <div class="values-grid">
        <div class="value-card">
            <div class="value-icon">⚡</div>
            <h3 class="value-title">Chất Lượng</h3>
            <p class="value-desc">Cam kết 100% linh kiện chính hãng, được nhập khẩu trực tiếp từ các nhà sản xuất uy
                tín hàng đầu thế giới. Mỗi sản phẩm đều trải qua kiểm tra nghiêm ngặt.</p>
        </div>
        <div class="value-card">
            <div class="value-icon">💎</div>
            <h3 class="value-title">Uy Tín</h3>
            <p class="value-desc">Xây dựng niềm tin qua hơn 10 năm phục vụ hàng nghìn khách hàng. Chính sách bảo
                hành rõ ràng, đổi trả linh hoạt, hỗ trợ tận tâm 24/7.</p>
        </div>
        <div class="value-card">
            <div class="value-icon">🚀</div>
            <h3 class="value-title">Đổi Mới</h3>
            <p class="value-desc">Luôn cập nhật những công nghệ mới nhất, mang đến cho bạn những sản phẩm tiên tiến
                nhất với giá cả cạnh tranh nhất thị trường.</p>
        </div>
    </div>
</section>

<section class="section vision-section">
    <h2 class="section-title">Tầm Nhìn</h2>
    <div class="vision-content">
        <div class="vision-image">
            <img src="https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?w=600&q=80"
                 alt="Technology Vision">
        </div>
        <div class="vision-text">
            <h2>Dẫn Đầu Tương Lai</h2>
            <p>Trở thành nhà cung cấp linh kiện máy tính hàng đầu Việt Nam, nơi mọi game thủ, developer và công nghệ
                viên tìm thấy giải pháp hoàn hảo cho setup của mình.</p>
            <p>Chúng tôi không chỉ bán sản phẩm, mà còn xây dựng một cộng đồng đam mê công nghệ, nơi mọi người có
                thể chia sẻ kinh nghiệm và cùng nhau phát triển.</p>
            <p>Mục tiêu của chúng tôi là làm cho công nghệ trở nên dễ tiếp cận hơn, giúp mọi người hiện thực hóa ý
                tưởng của mình.</p>
        </div>
    </div>
</section>

<section class="section core-section">
    <h2 class="section-title">Tại Sao Chọn TECHNOVA?</h2>
    <div class="core-grid">
        <div class="core-item">
            <div class="core-number">01</div>
            <h3 class="core-title">Giá Tốt Nhất</h3>
            <p class="core-desc">Cam kết giá tốt nhất thị trường với nhiều chương trình khuyến mãi hấp dẫn</p>
        </div>
        <div class="core-item">
            <div class="core-number">02</div>
            <h3 class="core-title">Giao Hàng Nhanh</h3>
            <p class="core-desc">Giao hàng toàn quốc trong 24h, miễn phí ship cho đơn từ 500K</p>
        </div>
        <div class="core-item">
            <div class="core-number">03</div>
            <h3 class="core-title">Bảo Hành Tận Tâm</h3>
            <p class="core-desc">Bảo hành chính hãng lên đến 36 tháng, đổi mới trong 7 ngày đầu</p>
        </div>
        <div class="core-item">
            <div class="core-number">04</div>
            <h3 class="core-title">Tư Vấn Chuyên Nghiệp</h3>
            <p class="core-desc">Đội ngũ kỹ thuật giàu kinh nghiệm, tư vấn tận tình cho mọi nhu cầu</p>
        </div>
    </div>
</section>

<section class="section mission-section">
    <h2 class="section-title">Sứ Mệnh</h2>
    <div class="mission-content">
        <div class="mission-text">
            <p>TechNova ra đời với sứ mệnh <span class="highlight">mang công nghệ đến gần hơn với mọi người</span>,
                giúp bạn xây dựng hệ thống máy tính trong mơ với chi phí hợp lý nhất.</p>
            <p>Chúng tôi tin rằng mỗi khách hàng đều xứng đáng có được sản phẩm chất lượng cao và dịch vụ chăm sóc
                tốt nhất. Đó là lý do tại sao chúng tôi không ngừng nỗ lực để <span class="highlight">hoàn thiện
                        từng chi tiết</span>.</p>
            <p>Với TechNova, bạn không chỉ mua linh kiện - bạn đang đầu tư cho tương lai công nghệ của chính mình.
            </p>
        </div>
    </div>
</section>
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
