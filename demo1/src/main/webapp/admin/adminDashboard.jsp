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
    <title>TechNova Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${contextPath}/admin/admincss/adminDashBoard.css">
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
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link active"><span class="nav-icon"><i
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
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>

    </ul>

    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span class="nav-icon"><i
                class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
    </div>
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
        <h1 class="page-title">Dashboard</h1>
        <div class="breadcrumb">
            <a href="adminDashboard.html">Trang chủ</a> / <span>Dashboard</span>
        </div>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
                    <i class="fa-solid fa-sack-dollar"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Doanh thu hôm nay</h3>
                    <p class="stat-value">
                        <fmt:formatNumber value="${todaysRevenue}" type="number" pattern="#,##0"/>đ
                    </p>

                    <div class="stat-sub">Cập nhật lúc 00:00</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #00c9a7 0%, #5b86e5 100%);">
                    <i class="fa-solid fa-hand-holding-dollar"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Doanh thu tháng này</h3>
                    <p class="stat-value">
                        <fmt:formatNumber value="${monthlyRevenue}" type="number" pattern="#,##0"/>đ
                    </p>

                    <div class="stat-sub">Tổng tích lũy: <fmt:formatNumber value="${revenue}" type="number" pattern="#,##0"/>đ</div>
                </div>
            </div>


            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);">
                    <i class="fa-solid fa-shopping-bag"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Tổng đơn hàng</h3>
                    <p class="stat-value">${totalOrders}</p>

                    <div class="stat-sub">
                        <a href="${contextPath}/admin/orders?status=Chờ+xác+nhận" class="stat-pending-link">
                            <i class="fa-solid fa-clock"></i> ${pendingOrders} đơn chờ xác nhận
                        </a>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Khách hàng hoạt động</h3>
                    <p class="stat-value">${totalCustomers}</p>

                    <div class="stat-sub">+${newCustomersThisMonth} khách mới tháng này</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fa-solid fa-box-open"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Sản phẩm đang bán</h3>
                    <p class="stat-value">${activeProducts}</p>
                    <div class="stat-secondary">
                        <span class="stat-change positive">
                            <i class="fa-solid fa-circle-check"></i> Đang hoạt động
                        </span>
                    </div>
                    <div class="stat-sub"><a href="${contextPath}/admin/products" class="stat-pending-link">Xem tất cả sản phẩm</a></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Đã bán tháng này</h3>
                    <p class="stat-value"><fmt:formatNumber value="${productsSoldThisMonth}" type="number" pattern="#,##0"/></p>

                    <div class="stat-sub">Tổng tích lũy: <fmt:formatNumber value="${totalProductsSold}" type="number" pattern="#,##0"/> sản phẩm</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Sắp hết hàng</h3>
                    <p class="stat-value">${lowStockProducts}</p>
                    <div class="stat-secondary">
                        <span class="stat-change ${lowStockProducts > 0 ? 'negative' : 'positive'}">
                            <i class="fa-solid ${lowStockProducts > 0 ? 'fa-circle-exclamation' : 'fa-check'}"></i>
                            ${lowStockProducts > 0 ? 'Cần nhập hàng' : 'Tồn kho ổn định'}
                        </span>
                    </div>
                    <div class="stat-sub">
                        <a href="javascript:void(0);" onclick="openLowStockModal()" class="stat-pending-link">
                            <i class="fa-solid fa-list-ul"></i> Xem sản phẩm
                        </a>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon" style="background: linear-gradient(135deg, #f43b47 0%, #453a94 100%);">
                    <i class="fa-solid fa-ban"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Tỷ lệ hủy đơn</h3>
                    <p class="stat-value">${cancelRate}%</p>
                    <div class="stat-secondary">
                        <span class="stat-change ${cancelRate > 10 ? 'negative' : 'positive'}">
                            <i class="fa-solid ${cancelRate > 10 ? 'fa-arrow-trend-up' : 'fa-thumbs-up'}"></i>
                            ${cancelRate > 10 ? 'Cảnh báo cao' : 'Mức bình thường'}
                        </span>
                    </div>
                    <div class="stat-sub">Tỷ lệ đơn hàng bị hủy</div>
                </div>
            </div>
        </div>

        <div class="status-cards-row">
            <div class="status-card">
                <div class="status-icon-wrapper pending-icon">
                    <i class="fa-solid fa-arrows-rotate"></i>
                </div>
                <div class="status-info">
                    <div class="status-label">Đơn chờ xử lý</div>
                    <div class="status-value">${pendingOrders}</div>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon-wrapper processing-icon">
                    <i class="fa-solid fa-truck-fast"></i>
                </div>
                <div class="status-info">
                    <div class="status-label">Đơn đang giao</div>
                    <div class="status-value">${processingOrders}</div>
                </div>
            </div>

            <div class="status-card">
                <div class="status-icon-wrapper delivered-icon">
                    <i class="fa-solid fa-check"></i>
                </div>
                <div class="status-info">
                    <div class="status-label">Đơn đã giao</div>
                    <div class="status-value">${deliveredOrders}</div>
                </div>
            </div>
        </div>

        <div class="charts-row">
            <div class="chart-card full-width">
                <div class="chart-header">
                    <h3 class="chart-title">Doanh thu 7 ngày gần nhất</h3>
                </div>
                <div class="chart-container">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        const chartLabels = ${chartLabels};
        const chartData = ${chartData};

        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: chartLabels,
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: chartData,
                    backgroundColor: 'rgba(75, 192, 192, 0.5)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    borderRadius: 5,
                    barThickness: 30
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value, index, values) {
                                return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                let label = context.dataset.label || '';
                                if (label) {
                                    label += ': ';
                                }
                                if (context.parsed.y !== null) {
                                    label += new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND'
                                    }).format(context.parsed.y);
                                }
                                return label;
                            }
                        }
                    }
                }
            }
        });
    });
</script>
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

<div id="lowStockModal" class="modal-overlay">
    <div class="modal-content low-stock-modal-content">
        <div class="modal-header">
            <h3>Sản phẩm sắp hết hàng</h3>
            <button class="close-modal-btn" onclick="closeLowStockModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="low-stock-list">
            <c:choose>
                <c:when test="${not empty lowStockProductsList}">
                    <c:forEach var="item" items="${lowStockProductsList}">
                        <a href="${contextPath}/admin/upload-product?id=${item.id}" class="low-stock-item">
                            <img src="${item.image}" alt="${item.name}" class="item-img">
                            <div class="item-details">
                                <div class="item-name">${item.name}</div>
                                <div class="item-price-stock">
                                    <span class="item-price"><fmt:formatNumber value="${item.price}" type="number" pattern="#,##0"/>đ</span>
                                    <span class="item-stock">Còn lại: ${item.stock}</span>
                                </div>
                            </div>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">Không có sản phẩm nào sắp hết hàng.</div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="modal-footer">
            <button class="modal-btn modal-cancel" onclick="closeLowStockModal()">Quay lại</button>
        </div>
    </div>
</div>

<script>
    function openLowStockModal() {
        document.getElementById('lowStockModal').classList.add('show');
    }

    function closeLowStockModal() {
        document.getElementById('lowStockModal').classList.remove('show');
    }

    document.getElementById('lowStockModal').addEventListener('click', function(e) {
        if(e.target === this) {
            closeLowStockModal();
        }
    });

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
