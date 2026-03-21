<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thank You</title>
    <link rel="stylesheet" href="css/thankyou.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">

</head>
<body>

<div class="container">
    <div class="success-icon">
        <img src="https://media.istockphoto.com/id/1416145560/vi/vec-to/v%C3%B2ng-tr%C3%B2n-m%C3%A0u-xanh-l%C3%A1-c%C3%A2y-v%E1%BB%9Bi-d%E1%BA%A5u-t%C3%ADch-m%C3%A0u-xanh-l%C3%A1-c%C3%A2y-bi%E1%BB%83u-t%C6%B0%E1%BB%A3ng-nh%C3%A3n-d%C3%A1n-ok-ph%E1%BA%B3ng-bi%E1%BB%83u.jpg?s=170667a&w=0&k=20&c=B56rAk2Hbi0qYCi-dMbn6TemvFLKaKl7WWNzXM6WzRU=" alt="404 Icon">
    </div>
    <h1 class="message">Đặt hàng thành công!</h1>
    <a href="${pageContext.request.contextPath}/my-orders" class="btn-product">Xem đơn hàng</a>
    <a href="${pageContext.request.contextPath}/home" class="btn-product">Quay lại trang chủ</a>
</div>
</body>
</html>