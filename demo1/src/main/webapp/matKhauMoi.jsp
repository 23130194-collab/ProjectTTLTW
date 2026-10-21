<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user_can_reset_password}">
    <c:redirect url="/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo mật khẩu mới</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/form.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>
<body>
    <div class="login-modal">
        <div class="login-form">
            <h2>Tạo mật khẩu mới</h2>
            <p>Vui lòng nhập mật khẩu mới cho tài khoản <strong><c:out value="${sessionScope.user_can_reset_password}" /></strong>.</p>

            <form action="reset-password" method="post">
                <div class="input-group ${not empty password_error ? 'has-error' : ''}">
                    <div class="password-container">
                        <input type="password" id="password" name="password" placeholder="Mật khẩu mới" class="${not empty password_error ? 'input-error' : ''}" required>
                        <i class="fa-solid fa-eye toggle-password" id="togglePassword"></i>
                    </div>
                    <c:if test="${not empty password_error}">
                        <span class="error-message"><c:out value="${password_error}" /></span>
                    </c:if>
                </div>
                <div class="input-group ${not empty confirmPassword_error ? 'has-error' : ''}">
                    <div class="password-container">
                        <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" class="${not empty confirmPassword_error ? 'input-error' : ''}" required>
                        <i class="fa-solid fa-eye toggle-password" id="toggleConfirmPassword"></i>
                    </div>
                    <c:if test="${not empty confirmPassword_error}">
                        <span class="error-message"><c:out value="${confirmPassword_error}" /></span>
                    </c:if>
                </div>
                <button type="submit" class="login-btn">Lưu thay đổi</button>
            </form>
        </div>
    </div>

    <script>
        function setupPasswordToggle(toggleId, passwordId) {
            const toggleButton = document.getElementById(toggleId);
            const passwordInput = document.getElementById(passwordId);

            toggleButton.addEventListener('click', function () {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.classList.toggle('fa-eye');
                this.classList.toggle('fa-eye-slash');
            });
        }

        setupPasswordToggle('togglePassword', 'password');
        setupPasswordToggle('toggleConfirmPassword', 'confirmPassword');
    </script>
</body>
</html>
