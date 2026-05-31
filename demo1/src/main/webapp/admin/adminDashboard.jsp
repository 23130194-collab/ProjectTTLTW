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
    <style>
        .notification-btn { position: relative; }

        .notification-badge {
            position: absolute;
            top: -5px; right: -5px;
            background: red; color: white;
            border-radius: 50%;
            width: 18px; height: 18px;
            font-size: 11px;
            display: flex; align-items: center; justify-content: center;
        }

        .notification-dropdown {
            position: absolute;
            top: 60px; right: 20px;
            width: 320px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            z-index: 9999;
            max-height: 400px;
            overflow-y: auto;
        }

        .notification-header {
            padding: 12px 16px;
            font-weight: 600;
            border-bottom: 1px solid #f0f0f0;
            font-size: 15px;
        }

        .notification-item {
            display: flex;
            align-items: flex-start;
            padding: 12px 16px;
            border-bottom: 1px solid #f9f9f9;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            transition: background 0.2s;
        }

        .notification-item:hover { background: #f5f5f5; }

        .notification-item.unread { background: #eff6ff; }

        .notification-item .noti-content { flex: 1; font-size: 13px; }

        .notification-item .noti-time {
            font-size: 11px;
            color: #999;
            margin-top: 4px;
        }

        .notification-empty {
            padding: 24px;
            text-align: center;
            color: #999;
            font-size: 13px;
        }
    </style>
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
        <li class="nav-item"><a href="${contextPath}/admin/dashboard" class="nav-link active"><span
                class="nav-icon"><i class="fa-solid fa-border-all"></i></span>Dashboard</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/customers" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-users"></i></span>Khách hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/categories" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-list"></i></span>Mục sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/brands" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-certificate"></i></span>Thương hiệu</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/attributes" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-sliders"></i></span>Thuộc tính</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/banners" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-images"></i></span>Banner</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/products" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-box-open"></i></span>Sản phẩm</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/orders" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-clipboard-list"></i></span>Đơn hàng</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/vouchers" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-ticket"></i></span>Voucher</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/reviews" class="nav-link"><span
                class="nav-icon"><i class="fa-solid fa-star"></i></span>Đánh giá</a></li>
        <li class="nav-item"><a href="${contextPath}/admin/contacts" class="nav-link"><span class="nav-icon"><i
                class="fa-solid fa-envelope"></i></span>Liên hệ</a></li>

    </ul>

    <div class="logout-section">
        <a href="${contextPath}/logout" class="nav-link logout-link" id="logoutLink"><span
                class="nav-icon"><i class="fa-solid fa-right-from-bracket"></i></span>Đăng xuất</a>
    </div>
</aside>

<header class="header">
    <div class="header-actions">
        <button class="notification-btn" id="notificationBtn">
            <i class="fa-solid fa-bell"></i>
            <span class="notification-badge" id="notificationBadge" style="display:none"></span>
        </button>
        <div class="notification-dropdown" id="notificationDropdown" style="display:none">
            <div class="notification-header">
                <span>Thông báo</span>
            </div>
            <div class="notification-list" id="notificationList">
                <div class="notification-empty">Không có thông báo mới</div>
            </div>
        </div>

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
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);">
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
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #00c9a7 0%, #5b86e5 100%);">
                    <i class="fa-solid fa-hand-holding-dollar"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Doanh thu tháng này</h3>
                    <p class="stat-value">
                        <fmt:formatNumber value="${monthlyRevenue}" type="number" pattern="#,##0"/>đ
                    </p>

                    <div class="stat-sub">Tổng tích lũy:
                        <fmt:formatNumber value="${revenue}" type="number" pattern="#,##0"/>đ
                    </div>
                </div>
            </div>


            <div class="stat-card">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);">
                    <i class="fa-solid fa-shopping-bag"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Tổng đơn hàng</h3>
                    <p class="stat-value">${totalOrders}</p>

                    <div class="stat-sub">
                        <a href="${contextPath}/admin/orders?status=Chờ+xác+nhận"
                           class="stat-pending-link">
                            <i class="fa-solid fa-clock"></i> ${pendingOrders} đơn chờ xác nhận
                        </a>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <i class="fa-solid fa-users"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Khách hàng hoạt động</h3>
                    <p class="stat-value">${totalCustomers}</p>

                    <div class="stat-sub">+${newCustomersThisMonth} khách mới tháng này</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
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
                    <div class="stat-sub"><a href="${contextPath}/admin/products"
                                             class="stat-pending-link">Xem tất cả sản phẩm</a></div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <i class="fa-solid fa-cart-shopping"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Đã bán tháng này</h3>
                    <p class="stat-value">
                        <fmt:formatNumber value="${productsSoldThisMonth}" type="number"
                                          pattern="#,##0"/>
                    </p>

                    <div class="stat-sub">Tổng tích lũy:
                        <fmt:formatNumber value="${totalProductsSold}" type="number" pattern="#,##0"/>
                        sản phẩm
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Sắp hết hàng</h3>
                    <p class="stat-value">${lowStockProducts}</p>
                    <div class="stat-secondary">
                                        <span class="stat-change ${lowStockProducts > 0 ? 'negative' : 'positive'}">
                                            <i
                                                    class="fa-solid ${lowStockProducts > 0 ? 'fa-circle-exclamation' : 'fa-check'}"></i>
                                            ${lowStockProducts > 0 ? 'Cần nhập hàng' : 'Tồn kho ổn định'}
                                        </span>
                    </div>
                    <div class="stat-sub">
                        <a href="javascript:void(0);" onclick="openLowStockModal()"
                           class="stat-pending-link">
                            <i class="fa-solid fa-list-ul"></i> Xem sản phẩm
                        </a>
                    </div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon"
                     style="background: linear-gradient(135deg, #f43b47 0%, #453a94 100%);">
                    <i class="fa-solid fa-ban"></i>
                </div>
                <div class="stat-info">
                    <h3 class="stat-label">Tỷ lệ hủy đơn</h3>
                    <p class="stat-value">${cancelRate}%</p>
                    <div class="stat-secondary">
                                        <span class="stat-change ${cancelRate > 10 ? 'negative' : 'positive'}">
                                            <i
                                                    class="fa-solid ${cancelRate > 10 ? 'fa-arrow-trend-up' : 'fa-thumbs-up'}"></i>
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

        <div class="charts-section">
            <div class="charts-controls">
                <div class="tabs-container">
                    <button class="tab-btn active" data-tab="finance">Tài chính & Doanh thu</button>
                    <button class="tab-btn" data-tab="orders">Đơn hàng</button>
                    <button class="tab-btn" data-tab="products">Sản phẩm & Kho</button>
                    <button class="tab-btn" data-tab="payment">Thanh toán</button>
                    <button class="tab-btn" data-tab="reviews">Đánh giá & Dịch vụ</button>
                </div>
                <div class="time-filter">
                    <select id="timeRangeSelect" onchange="fetchChartData(this.value)">
                        <option value="7">7 ngày qua</option>
                        <option value="30" selected>30 ngày qua</option>
                        <option value="90">90 ngày qua</option>
                        <option value="365">1 năm qua</option>
                    </select>
                </div>
            </div>

            <div id="finance-tab" class="tab-content active">
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Doanh thu theo thời gian</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="revenueTimeChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card half-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Doanh thu theo danh mục</h3>
                        </div>
                        <div class="chart-container pie-container">
                            <canvas id="revenueCategoryChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div id="orders-tab" class="tab-content">
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Số lượng đơn hàng theo ngày</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="ordersTimeChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card half-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ trạng thái đơn hàng</h3>
                        </div>
                        <div class="chart-container pie-container">
                            <canvas id="orderStatusChart"></canvas>
                        </div>
                    </div>
                    <div class="chart-card half-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ Giao hàng thành công vs Thất bại</h3>
                        </div>
                        <div class="chart-container pie-container">
                            <canvas id="orderSuccessChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div id="products-tab" class="tab-content">
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Top 10 Sản phẩm bán chạy nhất</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="topProductsChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Tồn kho theo danh mục</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="stockCategoryChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ sản phẩm theo thương hiệu</h3>
                        </div>
                        <div class="chart-container pie-container">
                            <canvas id="brandRatioChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Sản phẩm sắp hết hàng</h3>
                        </div>
                        <div class="low-stock-table-container">
                            <table class="low-stock-table" id="lowStockTable">
                                <thead>
                                    <tr>
                                        <th style="width: 60px;">Ảnh</th>
                                        <th>Sản phẩm</th>
                                        <th>Giá</th>
                                        <th style="width: 100px;">Tồn kho</th>
                                        <th style="width: 200px;">Mức độ cảnh báo</th>
                                    </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <h3 class="chart-title">Sản phẩm chưa bán được (theo ngày tồn)</h3>
                            <select id="unsoldLimitSelect" onchange="updateUnsoldChart(this.value)" style="padding: 5px 10px; border-radius: 4px; border: 1px solid #ddd; outline: none; cursor: pointer;">
                                <option value="5">5 sản phẩm</option>
                                <option value="10">10 sản phẩm</option>
                                <option value="20" selected>20 sản phẩm</option>
                            </select>
                        </div>
                        <div class="chart-container">
                            <canvas id="unsoldProductsChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div id="payment-tab" class="tab-content">
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ phương thức thanh toán</h3>
                        </div>
                        <div class="chart-container pie-container">
                            <canvas id="paymentMethodRatioChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Doanh thu theo phương thức thanh toán</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="revenueByPaymentMethodChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <div id="reviews-tab" class="tab-content">
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Phân bố số sao đánh giá</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="ratingDistributionChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Điểm đánh giá trung bình theo danh mục</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="averageRatingByCategoryChart"></canvas>
                        </div>
                    </div>
                </div>
                <div class="charts-row">
                    <div class="chart-card full-width">
                        <div class="chart-header">
                            <h3 class="chart-title">Tỷ lệ hủy đơn (Theo ngày)</h3>
                        </div>
                        <div class="chart-container">
                            <canvas id="cancellationRateChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let charts = {};
    let fullUnsoldProductsData = {};

    const pastelColors = [
        'rgba(255, 182, 193, 0.7)',
        'rgba(173, 216, 230, 0.7)',
        'rgba(144, 238, 144, 0.7)',
        'rgba(255, 255, 224, 0.7)',
        'rgba(221, 160, 221, 0.7)',
        'rgba(240, 128, 128, 0.7)',
        'rgba(152, 251, 152, 0.7)',
        'rgba(176, 224, 230, 0.7)'
    ];

    const borderColors = pastelColors.map(c => c.replace('0.7', '1'));

    document.addEventListener("DOMContentLoaded", function () {
        const tabBtns = document.querySelectorAll('.tab-btn');
        const tabContents = document.querySelectorAll('.tab-content');

        tabBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                tabBtns.forEach(b => b.classList.remove('active'));
                tabContents.forEach(c => c.classList.remove('active'));

                btn.classList.add('active');
                document.getElementById(btn.dataset.tab + '-tab').classList.add('active');
            });
        });

        fetchChartData(30);
    });

    function fetchChartData(days) {
        fetch(`${contextPath}/admin/chart-data?days=` + days)
            .then(response => response.json())
            .then(data => {
                renderRevenueTimeChart(data.revenueTime);
                renderRevenueCategoryChart(data.revenueCategory);
                renderOrdersTimeChart(data.ordersTime);
                renderOrderStatusChart(data.orderStatus);
                renderOrderSuccessChart(data.orderSuccess);
                
                renderTopProductsChart(data.topProducts);
                renderStockCategoryChart(data.stockByCategory);
                renderBrandRatioChart(data.brandRatio);
                renderLowStockTable(data.lowStockList);
                
                fullUnsoldProductsData = data.unsoldProducts || {};
                const limitSelect = document.getElementById('unsoldLimitSelect');
                updateUnsoldChart(limitSelect ? limitSelect.value : 20);

                renderPaymentMethodRatioChart(data.paymentMethodRatio);
                renderRevenueByPaymentMethodChart(data.revenueByPaymentMethod);
                
                renderAverageRatingByCategoryChart(data.averageRatingByCategory);
                renderRatingDistributionChart(data.ratingDistribution);
                renderCancellationRateChart(data.cancellationRate);
            })
            .catch(error => console.error('Error fetching chart data:', error));
    }

    function destroyChartIfExists(chartId) {
        if (charts[chartId]) {
            charts[chartId].destroy();
        }
    }

    function renderRevenueTimeChart(data) {
        destroyChartIfExists('revenueTimeChart');
        const ctx = document.getElementById('revenueTimeChart').getContext('2d');
        charts['revenueTimeChart'] = new Chart(ctx, {
            type: 'line',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Doanh thu (VND)',
                    data: Object.values(data),
                    backgroundColor: 'rgba(173, 216, 230, 0.2)',
                    borderColor: 'rgba(173, 216, 230, 1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.3
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: value => new Intl.NumberFormat('vi-VN').format(value) + ' đ'
                        }
                    }
                },
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: context => new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(context.parsed.y)
                        }
                    }
                }
            }
        });
    }

    function renderRevenueCategoryChart(data) {
        destroyChartIfExists('revenueCategoryChart');
        const ctx = document.getElementById('revenueCategoryChart').getContext('2d');
        charts['revenueCategoryChart'] = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    data: Object.values(data),
                    backgroundColor: pastelColors,
                    borderColor: borderColors,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: {
                    legend: {position: 'right'},
                    tooltip: {
                        callbacks: {
                            label: context => context.label + ': ' + new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(context.parsed)
                        }
                    }
                }
            }
        });
    }

    function renderOrdersTimeChart(data) {
        destroyChartIfExists('ordersTimeChart');
        const ctx = document.getElementById('ordersTimeChart').getContext('2d');
        charts['ordersTimeChart'] = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Số lượng đơn hàng',
                    data: Object.values(data),
                    backgroundColor: 'rgba(144, 238, 144, 0.7)',
                    borderColor: 'rgba(144, 238, 144, 1)',
                    borderWidth: 1,
                    borderRadius: 5
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: {
                    y: {beginAtZero: true, ticks: {stepSize: 1}}
                },
                plugins: {legend: {display: false}}
            }
        });
    }

    function renderOrderStatusChart(data) {
        destroyChartIfExists('orderStatusChart');
        const ctx = document.getElementById('orderStatusChart').getContext('2d');
        charts['orderStatusChart'] = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    data: Object.values(data),
                    backgroundColor: pastelColors,
                    borderColor: borderColors,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: {legend: {position: 'right'}}
            }
        });
    }

    function renderOrderSuccessChart(data) {
        destroyChartIfExists('orderSuccessChart');
        const ctx = document.getElementById('orderSuccessChart').getContext('2d');
        const keys = Object.keys(data);
        const customColors = keys.map(k => k === 'Thành công' ? 'rgba(144, 238, 144, 0.7)' : (k === 'Thất bại' ? 'rgba(255, 182, 193, 0.7)' : 'rgba(221, 160, 221, 0.7)'));
        const customBorders = keys.map(k => k === 'Thành công' ? 'rgba(144, 238, 144, 1)' : (k === 'Thất bại' ? 'rgba(255, 182, 193, 1)' : 'rgba(221, 160, 221, 1)'));

        charts['orderSuccessChart'] = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: keys,
                datasets: [{
                    data: Object.values(data),
                    backgroundColor: customColors,
                    borderColor: customBorders,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: {legend: {position: 'right'}}
            }
        });
    }

    function renderTopProductsChart(data) {
        destroyChartIfExists('topProductsChart');
        const ctx = document.getElementById('topProductsChart').getContext('2d');
        charts['topProductsChart'] = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Số lượng bán',
                    data: Object.values(data),
                    backgroundColor: 'rgba(59, 130, 246, 0.7)',
                    borderColor: 'rgba(59, 130, 246, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true, maintainAspectRatio: false,
                scales: { x: { beginAtZero: true, ticks: { stepSize: 1 } } },
                plugins: { legend: { display: false } }
            }
        });
    }

    function updateUnsoldChart(limit) {
        if (!fullUnsoldProductsData) return;
        const keys = Object.keys(fullUnsoldProductsData).slice(0, limit);
        const slicedData = {};
        keys.forEach(k => {
            slicedData[k] = fullUnsoldProductsData[k];
        });
        renderUnsoldProductsChart(slicedData);
    }

    function renderUnsoldProductsChart(data) {
        destroyChartIfExists('unsoldProductsChart');
        const ctx = document.getElementById('unsoldProductsChart');
        if (!ctx) return;
        
        charts['unsoldProductsChart'] = new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Số ngày chưa bán',
                    data: Object.values(data),
                    backgroundColor: 'rgba(255, 99, 132, 0.7)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true, maintainAspectRatio: false,
                scales: { 
                    x: { 
                        beginAtZero: true, 
                        title: { display: true, text: 'Số ngày lưu kho' }
                    } 
                },
                plugins: { legend: { display: false } }
            }
        });
    }

    function renderStockCategoryChart(data) {
        destroyChartIfExists('stockCategoryChart');
        const ctx = document.getElementById('stockCategoryChart').getContext('2d');
        charts['stockCategoryChart'] = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Tồn kho',
                    data: Object.values(data),
                    backgroundColor: 'rgba(16, 185, 129, 0.7)',
                    borderColor: 'rgba(16, 185, 129, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });
    }

    function renderBrandRatioChart(data) {
        destroyChartIfExists('brandRatioChart');
        const ctx = document.getElementById('brandRatioChart').getContext('2d');
        charts['brandRatioChart'] = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    data: Object.values(data),
                    backgroundColor: pastelColors,
                    borderColor: borderColors,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { position: 'right' } }
            }
        });
    }

    function renderLowStockTable(list) {
        const tbody = document.querySelector('#lowStockTable tbody');
        tbody.innerHTML = '';
        if (!list || list.length === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="empty-state">Không có sản phẩm nào sắp hết hàng.</td></tr>';
            return;
        }

        list.forEach(item => {
            const formatPrice = new Intl.NumberFormat('vi-VN').format(item.price) + ' đ';
            const progressPercent = Math.min((item.stock / 5) * 100, 100);
            let colorClass = 'danger';
            if (item.stock > 2) colorClass = 'warning';
            
            const tr = document.createElement('tr');
            tr.innerHTML = 
                '<td><img src="' + item.image + '" alt="' + item.name + '" class="table-img"></td>' +
                '<td class="item-name-cell">' + item.name + '</td>' +
                '<td class="item-price-cell">' + formatPrice + '</td>' +
                '<td><span class="stock-badge ' + colorClass + '">' + item.stock + '</span></td>' +
                '<td>' +
                    '<div class="stock-progress-bg">' +
                        '<div class="stock-progress-fill ' + colorClass + '" style="width: ' + progressPercent + '%"></div>' +
                    '</div>' +
                '</td>';
            tbody.appendChild(tr);
        });
    }

    function renderPaymentMethodRatioChart(data) {
        destroyChartIfExists('paymentMethodRatioChart');
        const ctx = document.getElementById('paymentMethodRatioChart');
        if (!ctx || !data) return;
        charts['paymentMethodRatioChart'] = new Chart(ctx.getContext('2d'), {
            type: 'pie',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    data: Object.values(data),
                    backgroundColor: pastelColors,
                    borderColor: borderColors,
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { position: 'right' } }
            }
        });
    }

    function renderRevenueByPaymentMethodChart(data) {
        destroyChartIfExists('revenueByPaymentMethodChart');
        const ctx = document.getElementById('revenueByPaymentMethodChart');
        if (!ctx || !data) return;
        charts['revenueByPaymentMethodChart'] = new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Doanh thu',
                    data: Object.values(data),
                    backgroundColor: 'rgba(54, 162, 235, 0.7)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: { 
                    y: { 
                        beginAtZero: true,
                        ticks: {
                            callback: value => new Intl.NumberFormat('vi-VN').format(value) + ' đ'
                        }
                    } 
                },
                plugins: { 
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: context => new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(context.parsed.y)
                        }
                    }
                }
            }
        });
    }

    function renderAverageRatingByCategoryChart(data) {
        destroyChartIfExists('averageRatingByCategoryChart');
        const ctx = document.getElementById('averageRatingByCategoryChart');
        if (!ctx || !data) return;
        charts['averageRatingByCategoryChart'] = new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: {
                labels: Object.keys(data),
                datasets: [{
                    label: 'Điểm trung bình (Sao)',
                    data: Object.values(data),
                    backgroundColor: 'rgba(255, 159, 64, 0.7)',
                    borderColor: 'rgba(255, 159, 64, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: { 
                    y: { 
                        beginAtZero: true, 
                        max: 5,
                        ticks: { stepSize: 1 }
                    } 
                },
                plugins: { legend: { display: false } }
            }
        });
    }

    function renderRatingDistributionChart(data) {
        destroyChartIfExists('ratingDistributionChart');
        const ctx = document.getElementById('ratingDistributionChart');
        if (!ctx || !data) return;
        
        const fullData = {};
        for(let i=1; i<=5; i++) {
            fullData[i + " Sao"] = data[i + " Sao"] || 0;
        }

        charts['ratingDistributionChart'] = new Chart(ctx.getContext('2d'), {
            type: 'bar',
            data: {
                labels: Object.keys(fullData),
                datasets: [{
                    label: 'Số lượt đánh giá',
                    data: Object.values(fullData),
                    backgroundColor: 'rgba(153, 102, 255, 0.7)',
                    borderColor: 'rgba(153, 102, 255, 1)',
                    borderWidth: 1,
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                indexAxis: 'x',
                scales: { 
                    y: { 
                        beginAtZero: true,
                        ticks: { stepSize: 1 }
                    } 
                },
                plugins: { legend: { display: false } }
            }
        });
    }

    function renderCancellationRateChart(data) {
        destroyChartIfExists('cancellationRateChart');
        const ctx = document.getElementById('cancellationRateChart');
        if (!ctx || !data) return;
        
        charts['cancellationRateChart'] = new Chart(ctx.getContext('2d'), {
            type: 'line',
            data: {
                labels: Object.keys(data).map(dateStr => {
                    const d = new Date(dateStr);
                    return d.getDate() + '/' + (d.getMonth() + 1);
                }),
                datasets: [{
                    label: 'Tỷ lệ hủy đơn (%)',
                    data: Object.values(data),
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgba(255, 99, 132, 1)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                scales: { 
                    y: { 
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            callback: value => value + '%'
                        }
                    } 
                },
                plugins: { 
                    legend: { position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: context => context.parsed.y.toFixed(2) + '%'
                        }
                    }
                }
            }
        });
    }
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
            <button class="close-modal-btn" onclick="closeLowStockModal()"><i
                    class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="low-stock-list">
            <c:choose>
                <c:when test="${not empty lowStockProductsList}">
                    <c:forEach var="item" items="${lowStockProductsList}">
                        <a href="${contextPath}/admin/upload-product?id=${item.id}"
                           class="low-stock-item">
                            <img src="${item.image}" alt="${item.name}" class="item-img">
                            <div class="item-details">
                                <div class="item-name">${item.name}</div>
                                <div class="item-price-stock">
                                                    <span class="item-price">
                                                        <fmt:formatNumber value="${item.price}" type="number"
                                                                          pattern="#,##0"/>đ
                                                    </span>
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
    document.addEventListener('DOMContentLoaded', function () {
        const notificationBtn = document.getElementById('notificationBtn');
        const notificationDropdown = document.getElementById('notificationDropdown');
        const notificationList = document.getElementById('notificationList');
        const notificationBadge = document.getElementById('notificationBadge');

        notificationBtn.addEventListener('click', function (e) {
            e.stopPropagation();
            const isHidden = notificationDropdown.style.display === 'none';
            notificationDropdown.style.display = isHidden ? 'block' : 'none';
            if (isHidden) {
                loadNotifications();
            }
        });

        document.addEventListener('click', function () {
            notificationDropdown.style.display = 'none';
        });

        notificationDropdown.addEventListener('click', function (e) {
            e.stopPropagation();
        });

        function markAllAdminAsRead() {
            fetch('${contextPath}/NotificationServlet', { method: 'POST' })
                .then(() => {
                    const badge = document.getElementById('notificationBadge');
                    badge.style.display = 'none';
                    badge.textContent = '0';
                    loadNotifications();
                });
        }

        function loadNotifications() {
            fetch('${contextPath}/NotificationServlet')
                .then(res => res.json())
                .then(data => {
                    if (!data || data.length === 0) {
                        notificationList.innerHTML = '<div class="notification-empty">Không có thông báo mới</div>';
                        notificationBadge.style.display = 'none';
                        return;
                    }

                    const unreadCount = data.filter(n => n.read === false || n.isRead === 0 || n.isRead === false).length;
                    notificationBadge.textContent = unreadCount;
                    notificationBadge.style.display = unreadCount > 0 ? 'flex' : 'none';

                    notificationList.innerHTML = data.map(function(n) {
                        var isUnread = n.read === false || n.isRead === 0 || n.isRead === false;
                        var unreadClass = isUnread ? 'unread' : '';
                        var link = '${contextPath}' + n.link;

                        return '<a class="notification-item ' + unreadClass + '" href="' + link + '" onclick="markAsRead(' + n.id + ', this, \'' + link + '\', event)">'
                            + '<div class="noti-content">'
                            + '<div>' + n.content + '</div>'
                            + '<div class="noti-time">' + formatTime(n.createdAt) + '</div>'
                            + '</div>'
                            + '</a>';
                    }).join('');
                })
                .catch(err => console.error('Lỗi load notification:', err));
        }

        window.markAsRead = function(id, element, link, event) {
            event.preventDefault();

            if (element.classList.contains('unread')) {
                fetch('${contextPath}/NotificationServlet?id=' + id, { method: 'POST' })
                    .then(response => {
                        if(response.ok) {
                            element.classList.remove('unread');
                            const badge = document.getElementById('notificationBadge');
                            let count = parseInt(badge.textContent) || 0;
                            count = Math.max(0, count - 1);
                            badge.textContent = count;
                            badge.style.display = count > 0 ? 'flex' : 'none';
                        }
                    })
                    .catch(err => console.error('Lỗi khi đánh dấu đã đọc: ', err))
                    .finally(() => {
                        window.location.href = link;
                    });
            } else {
                window.location.href = link;
            }
        };

        function formatTime(timestamp) {
            if (!timestamp) return '';
            const d = new Date(timestamp);
            return d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear()
                + ' ' + d.getHours() + ':' + String(d.getMinutes()).padStart(2, '0');
        }

        fetch('${contextPath}/NotificationServlet')
            .then(res => res.json())
            .then(data => {
                if (!data || data.length === 0) return;
                const unreadCount = data.filter(n => n.read === false || n.isRead === 0 || n.isRead === false).length;
                notificationBadge.textContent = unreadCount;
                notificationBadge.style.display = unreadCount > 0 ? 'flex' : 'none';
            })
            .catch(err => console.error('Lỗi load badge:', err));
    });
</script>

<script>
    function openLowStockModal() {
        document.getElementById('lowStockModal').classList.add('show');
    }

    function closeLowStockModal() {
        document.getElementById('lowStockModal').classList.remove('show');
    }

    document.getElementById('lowStockModal').addEventListener('click', function (e) {
        if (e.target === this) {
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
