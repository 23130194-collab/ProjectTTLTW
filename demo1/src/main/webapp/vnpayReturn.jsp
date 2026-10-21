<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả thanh toán VNPAY</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        .success { color: #28a745; }
        .failed { color: #dc3545; }
        .error { color: #ffc107; }
        .container { border: 1px solid #ccc; padding: 30px; border-radius: 10px; max-width: 500px; margin: 0 auto; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .btn { display: inline-block; padding: 10px 20px; color: #fff; background-color: #007bff; text-decoration: none; border-radius: 5px; margin-top: 20px; }
        .btn:hover { background-color: #0056b3; }
    </style>
</head>
<body>
    <div class="container">
        <h2 class="<c:out value="${status}"/>">
            <c:choose>
                <c:when test="${status == 'success'}">
                    Thanh toán thành công!
                </c:when>
                <c:when test="${status == 'failed'}">
                    Thanh toán thất bại
                </c:when>
                <c:otherwise>
                    Lỗi xác thực
                </c:otherwise>
            </c:choose>
        </h2>
        
        <p><c:out value="${message}" /></p>
        
        <c:choose>
            <c:when test="${status == 'success'}">
                <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đang được xử lý.</p>
                <a href="${pageContext.request.contextPath}/my-orders" class="btn">Xem đơn hàng của tôi</a>
            </c:when>
            <c:otherwise>
                <p>Vui lòng thử lại hoặc chọn phương thức thanh toán khác.</p>
                <a href="${pageContext.request.contextPath}/AddCart?action=view" class="btn">Thử thanh toán lại</a>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
