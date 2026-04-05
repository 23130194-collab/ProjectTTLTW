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
</head>
<body>
    <div class="overlay">
        <div class="login-modal">
            <div class="login-form">
                <h2>Thay đổi mật khẩu</h2>
                <p>Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác.</p>
                <c:if test="${not empty requestScope.general_error}">
                    <div class="error-message-general">${requestScope.general_error}</div>
                </c:if>
                <form action="${pageContext.request.contextPath}/change-password" method="post">
                    <div class="input-group ${not empty requestScope.oldPassword_error ? 'has-error' : ''}">
                        <input type="password" name="oldPassword" placeholder="Mật khẩu cũ" class="${not empty requestScope.oldPassword_error ? 'input-error' : ''}" required>
                        <c:if test="${not empty requestScope.oldPassword_error}">
                            <span class="error-message">${requestScope.oldPassword_error}</span>
                        </c:if>
                    </div>
                    <div class="input-group ${not empty requestScope.newPassword_error ? 'has-error' : ''}">
                        <input type="password" name="newPassword" placeholder="Mật khẩu mới" class="${not empty requestScope.newPassword_error ? 'input-error' : ''}" required>
                        <c:if test="${not empty requestScope.newPassword_error}">
                            <span class="error-message">${requestScope.newPassword_error}</span>
                        </c:if>
                    </div>
                    <div class="input-group ${not empty requestScope.confirmPassword_error ? 'has-error' : ''}">
                        <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" class="${not empty requestScope.confirmPassword_error ? 'input-error' : ''}" required>
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
</body>
</html>
