<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm khách hàng mới - TechNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/adminAddCustomer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<main class="main-content">
    <div class="form-container">
        <h2 class="form-title"><i class="fa-solid fa-user-plus"></i> Thêm khách hàng mới</h2>
        <hr style="margin-bottom: 20px; border: 0; border-top: 1px solid #eee;">

        <form id="addCustomerForm" action="${pageContext.request.contextPath}/admin/add-customer" method="post">
            <div class="form-group">
                <label>Họ và tên *</label>
                <input type="text" name="name" value="${name_value}" required placeholder="VD: Nguyễn Văn A">
                <c:if test="${not empty errors.name}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${errors.name}" /></span></c:if>
            </div>

            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" value="${email_value}" required placeholder="VD: email@example.com">
                <c:if test="${not empty errors.email}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${errors.email}" /></span></c:if>
            </div>

            <div class="form-group">
                <label>Mật khẩu tạm thời *</label>
                <input type="password" name="password" required placeholder="Ít nhất 8 ký tự, có hoa, số và ký tự đặc biệt">
                <c:if test="${not empty errors.password}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${errors.password}" /></span></c:if>
            </div>

            <div class="form-group">
                <label>Xác nhận mật khẩu *</label>
                <input type="password" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                <c:if test="${not empty errors.confirmPassword}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> <c:out value="${errors.confirmPassword}" /></span></c:if>
            </div>

            <div style="margin-top: 25px;">
                <button type="button" class="btn-submit" onclick="validateAndOpenModal()">Thêm khách hàng</button>
                <a href="${pageContext.request.contextPath}/admin/customers" style="text-decoration:none; color:#64748b; margin-left:15px; font-size:14px;">Hủy bỏ</a>
            </div>

            <div id="confirmAddModal" class="modal-overlay">
                <div class="modal-content">
                    <h3>Xác nhận thêm mới</h3>
                    <p>Bạn có chắc chắn muốn thêm khách hàng này vào hệ thống?</p>
                    <div class="modal-buttons">
                        <button type="button" class="modal-btn modal-cancel" onclick="closeConfirmModal()">Hủy</button>
                        <button type="button" class="modal-btn modal-confirm" onclick="submitForm()">Đồng ý</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<script>
    function validateAndOpenModal() {
        const form = document.getElementById('addCustomerForm');
        if (form.checkValidity()) {
            document.getElementById('confirmAddModal').classList.add('show');
        } else {
            form.reportValidity();
        }
    }

    function closeConfirmModal() {
        document.getElementById('confirmAddModal').classList.remove('show');
    }

    function submitForm() {
        document.getElementById('addCustomerForm').submit();
    }
</script>
</body>
</html>
