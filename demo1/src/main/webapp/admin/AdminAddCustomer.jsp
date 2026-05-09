<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm khách hàng mới - TechNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        html,
        body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #f1f5f9;
        }

        .main-content {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .form-container {
            width: 100%;
            max-width: 550px;
            background: #ffffff;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .form-title {
            font-size: 22px;
            font-weight: 600;
            color: #1e293b;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #475569;
            font-size: 15px;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
            outline: none;
            transition: all 0.2s ease;
        }

        .form-group input:focus {
            border-color: #5b86e5;
            box-shadow: 0 0 0 3px rgba(91, 134, 229, 0.15);
        }

        .error-text {
            color: #b91c1c;
            font-size: 13px;
            margin-top: 8px;
            display: block;
        }

        .btn-submit {
            background: #5b86e5;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 15px;
            transition: background 0.2s ease;
        }

        .btn-submit:hover {
            background: #4a72d4;
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            display: flex;
            align-items: center;
            justify-content: center;
            visibility: hidden;
            opacity: 0;
            transition: 0.3s;
            z-index: 9999;
        }

        .modal-overlay.show {
            visibility: visible;
            opacity: 1;
        }

        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 400px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        .modal-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 25px;
        }

        .modal-btn {
            padding: 10px 25px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
        }

        .modal-confirm {
            background-color: #5b86e5;
            color: white;
        }

        .modal-cancel {
            background-color: #e2e8f0;
            color: #334155;
        }
    </style>
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
                <c:if test="${not empty errors.name}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> ${errors.name}</span></c:if>
            </div>

            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" value="${email_value}" required placeholder="VD: email@example.com">
                <c:if test="${not empty errors.email}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> ${errors.email}</span></c:if>
            </div>

            <div class="form-group">
                <label>Mật khẩu tạm thời *</label>
                <input type="password" name="password" required placeholder="Ít nhất 8 ký tự, có hoa, số và ký tự đặc biệt">
                <c:if test="${not empty errors.password}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> ${errors.password}</span></c:if>
            </div>

            <div class="form-group">
                <label>Xác nhận mật khẩu *</label>
                <input type="password" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                <c:if test="${not empty errors.confirmPassword}"><span class="error-text"><i class="fa-solid fa-circle-exclamation"></i> ${errors.confirmPassword}</span></c:if>
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