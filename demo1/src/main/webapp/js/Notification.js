document.addEventListener("DOMContentLoaded", function () {
    const openNotice = document.getElementById("openNotice");
    const noticeBox = document.getElementById("noticeBox");
    const noticeOverlay = document.getElementById("noticeOverlay");
    const closeNoticeBtn = document.getElementById("closeNoticeBtn");

    function hideNotice() {
        if (noticeBox && noticeOverlay) {
            noticeBox.classList.remove("show");
            noticeOverlay.classList.remove("show");
        }
    }

    if (openNotice) {
        openNotice.addEventListener("click", function () {
            if (noticeBox && noticeOverlay) {
                noticeBox.classList.add("show");
                noticeOverlay.classList.add("show");
            }
        });
    }

    if (closeNoticeBtn) {
        closeNoticeBtn.addEventListener("click", hideNotice);
    }

    if (noticeOverlay) {
        noticeOverlay.addEventListener("click", hideNotice);
    }

    const noticeDetails = document.querySelectorAll('.notice-detail');
    const unreadBadge = document.getElementById('unreadBadge');

    noticeDetails.forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();

            const targetUrl = this.getAttribute('href');
            const noticeItem = this.closest('.notice-item');
            const notiId = noticeItem.getAttribute('data-id');

            if (noticeItem.classList.contains('unread')) {
                fetch(globalContextPath + '/NotificationServlet', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: 'id=' + encodeURIComponent(notiId)
                })
                    .then(response => {
                        if (response.ok) {
                            noticeItem.classList.remove('unread');

                            if (unreadBadge) {
                                let currentCount = parseInt(unreadBadge.textContent.replace(/[^0-9]/g, ''));

                                if (currentCount > 1) {
                                    unreadBadge.textContent = '(' + (currentCount - 1) + ')';
                                } else {
                                    unreadBadge.style.display = 'none';
                                }
                            }
                        }
                        window.location.href = targetUrl;
                    })
                    .catch(error => {
                        console.error("Lỗi cập nhật thông báo:", error);
                        window.location.href = targetUrl;
                    });
            } else {
                window.location.href = targetUrl;
            }
        });
    });
});