<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng nhập | TechNova</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/form.css"/>
    <link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.6.0/css/all.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
</head>

<body>
<div class="overlay">
    <div class="login-modal">
        <h2>Chào mừng đến với TechNova!</h2>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="success-message-general">${sessionScope.successMessage}</div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errors.general}">
            <div class="error-message-general">${errors.general}</div>
        </c:if>

        <form action="login" method="post">
            <div class="input-group ${not empty errors.email ? 'has-error' : ''}">
                <input type="email" name="email" placeholder="Nhập email" value="${email_value}" class="${not empty errors.email ? 'input-error' : ''}" required/>
                <c:if test="${not empty errors.email}">
                    <span class="error-message">${errors.email}</span>
                </c:if>
            </div>

            <div class="input-group ${not empty errors.password ? 'has-error' : ''}">
                <input type="password" name="password" placeholder="Nhập mật khẩu" class="${not empty errors.password ? 'input-error' : ''}" required/>
                <c:if test="${not empty errors.password}">
                    <span class="error-message">${errors.password}</span>
                </c:if>
            </div>

            <div class="remember">
                <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
            </div>

            <button type="submit" class="login-btn">Đăng nhập</button>
        </form>

        <div class="divider">
            <span>Hoặc đăng nhập bằng</span>
        </div>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/login-google-handler" class="social-btn google">
                <img src="https://i.postimg.cc/52XY45D7/z7179766768017-0600811c9c5ce7a039bb0715af80295b.jpg" alt="Google logo">
                Google
            </a>
        </div>

        <div class="signup">
            <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/signup">Đăng ký ngay</a></p>
        </div>
    </div>
</div>

</body>
</html>
