<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên mật khẩu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/form.css">
</head>
<body>
    <div class="login-modal">
        <div class="login-form">
            <h2>Quên mật khẩu</h2>
            <p>Vui lòng nhập địa chỉ email của bạn. Chúng tôi sẽ gửi một mã OTP để xác thực.</p>

            <c:if test="${not empty error}">
                <div class="error-message-general">${error}</div>
            </c:if>

            <form action="forgot-password" method="post">
                <div class="input-group ${not empty error ? 'has-error' : ''}">
                    <input type="email" id="email" name="email" value="${emailValue}" class="${not empty error ? 'input-error' : ''}" required>
                    <c:if test="${not empty error}">
                        <span class="error-message">${error}</span>
                    </c:if>
                </div>
                <button type="submit" class="login-btn">Gửi mã xác nhận</button>
            </form>
            <div style="text-align: center; margin-top: 20px;">
                <a href="login">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>
</body>
</html>
