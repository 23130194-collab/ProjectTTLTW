<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực tài khoản</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/form.css">
    <link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.6.0/css/all.css">
</head>
<body>
<div class="overlay">
    <div class="login-modal">
        <h2>Xác thực tài khoản</h2>

        <c:choose>
            <c:when test="${sessionScope.otp_flow == 'reset_password'}">
                <p style="text-align: center; margin-bottom: 20px;">Một mã OTP đã được gửi đến email <strong>${sessionScope.email_for_verification}</strong>. Vui lòng nhập mã để đặt lại mật khẩu.</p>
            </c:when>
            <c:otherwise>
                <p style="text-align: center; margin-bottom: 20px;">Một mã OTP đã được gửi đến email <strong>${sessionScope.email_for_verification}</strong>. Vui lòng nhập mã để kích hoạt tài khoản.</p>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty sessionScope.resend_success}">
            <div class="success-message-general">${sessionScope.resend_success}</div>
            <c:remove var="resend_success" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.resend_error}">
            <div class="cooldown-message">${sessionScope.resend_error}</div>
            <c:remove var="resend_error" scope="session"/>
        </c:if>

        <form action="verify" method="post">
            <div class="input-group ${not empty otp_error ? 'has-error' : ''}">
                <input type="text" id="otp" name="otp" placeholder="Nhập mã OTP" class="${not empty otp_error ? 'input-error' : ''}" required>
                <c:if test="${not empty otp_error}">
                    <span class="error-message">${otp_error}</span>
                </c:if>
            </div>
            <button type="submit" class="login-btn">Xác nhận</button>
        </form>

        <div class="login" style="margin-top: 20px;">
            <p>Chưa nhận được mã? <a href="${pageContext.request.contextPath}/resend-otp">Gửi lại</a></p>
        </div>
    </div>
</div>
</body>
</html>
