<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TechNova Admin - Danh sách sản phẩm</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminProductList.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/headerAndSidebar.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminModal.css">
</head>

<body>

<aside class="sidebar">
    <div class="logo">
        <a href="${contextPath}/admin/dashboard">
            <img src="https://i.postimg.cc/Hn4Jc3yj/logo-2.png" alt="TechNova Logo">
        </a>
        <a href="${contextPath}/admin/dashboard" style="text-decoration: none;">
            <span class="logo-text">TechNova</span>
        </a>
    </div>
    <ul class="nav-menu">
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link active"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>

    </ul>
    <div class="logout-section"><a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span
            class="nav-icon"><i
            class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a></div>
</aside>

<header class="header">
    <div class="header-actions">
        <button class="notification-btn" id="notificationBtn">
            <i class="fa-solid fa-bell"></i>
        </button>

        <div class="user-profile">
            <img src="https://www.shutterstock.com/image-vector/admin-icon-strategy-collection-thin-600nw-2307398667.jpg"
                 alt="User Profile">
        </div>
    </div>
</header>

<main class="main-content">
    <div class="content-area">

        <div class="page-header">
            <div class="page-title-wrapper">
                <h1 class="page-title">Sản phẩm</h1>
                <div class="breadcrumb">
                    <a href="adminDashboard.jsp" class="breadcrumb-link">Trang chủ</a>
                    <span class="breadcrumb-separator">/</span>
                    <span class="breadcrumb-current">Sản phẩm</span>
                </div>
            </div>

            <a href="${contextPath}/admin/upload-product" class="add-product-btn" title="Thêm sản phẩm mới">
                <i class="fa-solid fa-plus"></i>
            </a>
        </div>

        <div class="filter-bar">
            <form action="${contextPath}/admin/products" method="get" id="filterForm" class="filter-left">
                <div class="filter-item">
                    <div class="select-wrapper">
                        <select name="categoryId" id="category-select" onchange="this.form.submit()">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.id}" ${category.id == selectedCategoryId ? 'selected' : ''}>
                                        ${category.name}
                                </option>
                            </c:forEach>
                        </select>
                        <i class="fa-solid fa-chevron-down select-arrow"></i>
                    </div>
                </div>

                <div class="filter-item">
                    <div class="select-wrapper">
                        <select name="status" id="status-select" onchange="this.form.submit()">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${'active' == selectedStatus ? 'selected' : ''}>Hoạt động</option>
                            <option value="inactive" ${'inactive' == selectedStatus ? 'selected' : ''}>Ẩn</option>
                        </select>
                        <i class="fa-solid fa-chevron-down select-arrow"></i>
                    </div>
                </div>
                <div class="search-wrapper">
                    <input type="text" name="keyword" class="search-input-product" placeholder="Tìm kiếm sản phẩm..."
                           value="${selectedKeyword}">
                    <button class="search-btn" type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </div>
            </form>

        </div>

        <div class="product-table-container">
            <table class="product-table">
                <thead>
                <tr>
                    <th style="width: 50px;">STT</th>
                    <th style="width: 100px;">Hình ảnh</th>
                    <th style="width: 170px">Sản phẩm</th>
                    <th style="width: 125px;">Giá bán</th>
                    <th style="width: 100px;">Tồn kho</th>
                    <th style="width: 120px;">Trạng thái</th>
                    <th style="width: 150px;">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="product" items="${productList}" varStatus="loop">
                    <tr>
                        <td>${(currentPage - 1) * itemsPerPage + loop.index + 1}</td>
                        <td class="td-image">
                            <div class="img-wrapper">
                                <img src="${product.image}" alt="${product.name}"
                                     onerror="this.src='${contextPath}/assets/images/logo-2.png';"></div>
                        </td>
                        <td class="td-name">
                            <span class="product-name" title="${product.name}">${product.name}</span>
                        </td>
                        <td class="td-price">
                            <div class="price-group">
                                <span class="current-price"><fmt:formatNumber value="${product.price}" type="number"
                                                                              pattern="#,##0"/>đ</span>
                                <c:if test="${product.oldPrice > 0 && product.oldPrice > product.price}">
                                    <span class="old-price"><fmt:formatNumber value="${product.oldPrice}" type="number"
                                                                              pattern="#,##0"/>đ</span>
                                </c:if>
                            </div>
                        </td>
                        <td><span class="stock-text">${product.stock}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${product.status == 'active'}">
                                    <span class="status status-active">Hoạt động</span>
                                </c:when>
                                <c:when test="${product.status == 'inactive'}">
                                    <span class="status status-hidden">Ẩn</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status status-other">${product.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${contextPath}/admin/upload-product?id=${product.id}" class="action-btn edit"
                                   title="Sửa"><i class="fa-solid fa-pen"></i></a>
                                <a href="#confirm-delete-modal-${product.id}" class="action-btn delete"
                                   title="Xoá sản phẩm"><i class="fa-solid fa-trash-can"></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination-container">
                <c:url var="prevUrl" value="/admin/products">
                    <c:param name="page" value="${currentPage - 1}"/>
                    <c:if test="${not empty selectedCategoryId}"><c:param name="categoryId"
                                                                          value="${selectedCategoryId}"/></c:if>
                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                    <c:if test="${not empty selectedKeyword}"><c:param name="keyword"
                                                                       value="${selectedKeyword}"/></c:if>
                    <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                </c:url>
                <a href="${currentPage > 1 ? prevUrl : '#'}"
                   class="pagination-btn ${currentPage == 1 ? 'disabled' : ''}">
                    <i class="fa-solid fa-chevron-left"></i>
                </a>

                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:url var="pageUrl" value="/admin/products">
                        <c:param name="page" value="${i}"/>
                        <c:if test="${not empty selectedCategoryId}"><c:param name="categoryId"
                                                                              value="${selectedCategoryId}"/></c:if>
                        <c:if test="${not empty selectedStatus}"><c:param name="status"
                                                                          value="${selectedStatus}"/></c:if>
                        <c:if test="${not empty selectedKeyword}"><c:param name="keyword"
                                                                           value="${selectedKeyword}"/></c:if>
                        <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                    </c:url>
                    <a href="${pageUrl}" class="page-number ${currentPage == i ? 'active' : ''}">${i}</a>
                </c:forEach>

                <c:url var="nextUrl" value="/admin/products">
                    <c:param name="page" value="${currentPage + 1}"/>
                    <c:if test="${not empty selectedCategoryId}"><c:param name="categoryId"
                                                                          value="${selectedCategoryId}"/></c:if>
                    <c:if test="${not empty selectedStatus}"><c:param name="status" value="${selectedStatus}"/></c:if>
                    <c:if test="${not empty selectedKeyword}"><c:param name="keyword"
                                                                       value="${selectedKeyword}"/></c:if>
                    <c:if test="${not empty selectedSort}"><c:param name="sort" value="${selectedSort}"/></c:if>
                </c:url>
                <a href="${currentPage < totalPages ? nextUrl : '#'}"
                   class="pagination-btn ${currentPage == totalPages ? 'disabled' : ''}">
                    <i class="fa-solid fa-chevron-right"></i>
                </a>
            </div>
        </c:if>

    </div>
</main>

<c:forEach var="product" items="${productList}">
    <div id="confirm-delete-modal-${product.id}" class="modal-overlay">
        <div class="modal-content">
            <h3>Xác nhận xoá sản phẩm</h3>
            <p>Bạn có chắc chắn muốn xoá sản phẩm "${product.name}" không?</p>
            <div class="modal-buttons">
                <a href="#" class="modal-btn modal-cancel">Hủy</a>
                <a href="${contextPath}/admin/products?action=delete&id=${product.id}" class="modal-btn modal-confirm">Đồng
                    ý</a>
            </div>
        </div>
    </div>
</c:forEach>

<div id="logoutConfirmModal" class="modal-overlay">
    <div class="modal-content">
        <h3>Xác nhận đăng xuất</h3>
        <p>Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?</p>
        <div class="modal-buttons">
            <a href="#" class="modal-btn modal-cancel" id="cancelLogout">Hủy</a>
            <a href="${contextPath}/logout" class="modal-btn modal-confirm">Đăng xuất</a>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const logoutLink = document.getElementById('logoutLink');
        const logoutConfirmModal = document.getElementById('logoutConfirmModal');
        const cancelLogoutBtn = document.getElementById('cancelLogout');

        if (logoutLink && logoutConfirmModal && cancelLogoutBtn) {
            logoutLink.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.add('show');
            });

            cancelLogoutBtn.addEventListener('click', function (e) {
                e.preventDefault();
                logoutConfirmModal.classList.remove('show');
            });

            logoutConfirmModal.addEventListener('click', function (e) {
                if (e.target === logoutConfirmModal) {
                    logoutConfirmModal.classList.remove('show');
                }
            });
        }
    });
</script>
</body>
</html>