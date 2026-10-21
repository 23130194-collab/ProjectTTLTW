<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đăng nhập | TechNova</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/form.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&display=swap" rel="stylesheet">
</head>

<body>
<div class="overlay">
    <div class="login-modal">
        <h2>Chào mừng đến với TechNova!</h2>

        <c:if test="${not empty sessionScope.successMessage}">
            <div class="success-message-general"><c:out value="${sessionScope.successMessage}" /></div>
            <c:remove var="successMessage" scope="session"/>
        </c:if>
        <c:if test="${not empty errors.general}">
            <div class="error-message-general"><c:out value="${errors.general}" /></div>
        </c:if>

        <form action="login" method="post">
            <div class="input-group">
                <input type="email" name="email" placeholder="Nhập email" value="${email_value}" required/>
            </div>

            <div class="input-group">
                <div class="password-container">
                    <input type="password" name="password" id="password" placeholder="Nhập mật khẩu" required/>
                    <i class="fa-solid fa-eye toggle-password" id="togglePassword"></i>
                </div>
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

<script>
    const togglePassword = document.getElementById('togglePassword');
    const password = document.getElementById('password');

    togglePassword.addEventListener('click', function (e) {
        const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
        password.setAttribute('type', type);
        this.classList.toggle('fa-eye');
        this.classList.toggle('fa-eye-slash');
    });
</script>

</body>
</html>
