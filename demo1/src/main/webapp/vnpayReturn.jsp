<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <% 
            String status = (String) request.getAttribute("status");
            String message = (String) request.getAttribute("message");
        %>
        
        <h2 class="<%= status %>">
            <%= "success".equals(status) ? "Thanh toán thành công!" : ("failed".equals(status) ? "Thanh toán thất bại" : "Lỗi xác thực") %>
        </h2>
        
        <p><%= message %></p>
        
        <% if ("success".equals(status)) { %>
            <p>Cảm ơn bạn đã mua hàng. Đơn hàng của bạn đang được xử lý.</p>
            <a href="${pageContext.request.contextPath}/my-orders" class="btn">Xem đơn hàng của tôi</a>
        <% } else { %>
            <p>Vui lòng thử lại hoặc chọn phương thức thanh toán khác.</p>
            <a href="${pageContext.request.contextPath}/AddCart?action=view" class="btn">Thử thanh toán lại</a>
        <% } %>
    </div>
</body>
</html>
