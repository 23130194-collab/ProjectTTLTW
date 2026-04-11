<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login.jsp"/>
</c:if>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thay đổi mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/form.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
</head>
<body>
    <div class="overlay">
        <div class="login-modal">
            <div class="login-form">
                <h2>Thay đổi mật khẩu</h2>
                <p>Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác.</p>

                <form action="${pageContext.request.contextPath}/change-password" method="post">
                    <div class="input-group ${not empty requestScope.oldPassword_error ? 'has-error' : ''}">
                        <div class="password-container">
                            <input type="password" id="oldPassword" name="oldPassword" placeholder="Mật khẩu cũ" required>
                            <i class="fa-solid fa-eye toggle-password" id="toggleOldPassword"></i>
                        </div>
                        <c:if test="${not empty requestScope.oldPassword_error}">
                            <span class="error-message">${requestScope.oldPassword_error}</span>
                        </c:if>
                    </div>
                    <div class="input-group ${not empty requestScope.newPassword_error ? 'has-error' : ''}">
                        <div class="password-container">
                            <input type="password" id="newPassword" name="newPassword" placeholder="Mật khẩu mới" required>
                            <i class="fa-solid fa-eye toggle-password" id="toggleNewPassword"></i>
                        </div>
                        <c:if test="${not empty requestScope.newPassword_error}">
                            <span class="error-message">${requestScope.newPassword_error}</span>
                        </c:if>
                    </div>
                    <div class="input-group ${not empty requestScope.confirmPassword_error ? 'has-error' : ''}">
                        <div class="password-container">
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
                            <i class="fa-solid fa-eye toggle-password" id="toggleConfirmPassword"></i>
                        </div>
                        <c:if test="${not empty requestScope.confirmPassword_error}">
                            <span class="error-message">${requestScope.confirmPassword_error}</span>
                        </c:if>
                    </div>
                    <button type="submit" class="login-btn">Lưu thay đổi</button>
                </form>
                <div style="text-align: center; margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/account">Quay lại</a>
                </div>
            </div>
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

        setupPasswordToggle('toggleOldPassword', 'oldPassword');
        setupPasswordToggle('toggleNewPassword', 'newPassword');
        setupPasswordToggle('toggleConfirmPassword', 'confirmPassword');
    </script>
</body>
</html>
