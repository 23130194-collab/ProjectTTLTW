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
</head>
<body>
    <div class="login-modal">
        <div class="login-form">
            <h2>Tạo mật khẩu mới</h2>
            <p>Vui lòng nhập mật khẩu mới cho tài khoản <strong>${sessionScope.user_can_reset_password}</strong>.</p>

            <form action="reset-password" method="post">
                <div class="input-group ${not empty password_error ? 'has-error' : ''}">
                    <input type="password" id="password" name="password" placeholder="Mật khẩu mới" class="${not empty password_error ? 'input-error' : ''}" required>
                    <c:if test="${not empty password_error}">
                        <span class="error-message">${password_error}</span>
                    </c:if>
                </div>
                <div class="input-group ${not empty confirmPassword_error ? 'has-error' : ''}">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" class="${not empty confirmPassword_error ? 'input-error' : ''}" required>
                    <c:if test="${not empty confirmPassword_error}">
                        <span class="error-message">${confirmPassword_error}</span>
                    </c:if>
                </div>
                <button type="submit" class="login-btn">Lưu thay đổi</button>
            </form>
        </div>
    </div>
</body>
</html>
