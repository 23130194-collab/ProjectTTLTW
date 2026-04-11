function showFavToast(type, contextPath) {
    const existing = document.getElementById('fav-toast');
    if (existing) existing.remove();

    const toast = document.createElement('div');
    toast.id = 'fav-toast';
    toast.className = 'fav-toast';

    if (type === 'added') {
        toast.innerHTML = `
            <i class="fa-solid fa-circle-check fav-toast-icon"></i>
            <span class="fav-toast-msg">Đã thêm vào danh sách yêu thích! <a href="${contextPath}/favorites" class="fav-toast-view">Xem danh sách</a></span>
            <button class="fav-toast-close" onclick="this.parentElement.remove()">&#10005;</button>
        `;
    } else {
        toast.innerHTML = `
            <i class="fa-solid fa-circle-check fav-toast-icon"></i>
            <span class="fav-toast-msg">Đã xóa sản phẩm khỏi danh sách yêu thích</span>
            <button class="fav-toast-close" onclick="this.parentElement.remove()">&#10005;</button>
        `;
    }

    document.body.appendChild(toast);

    requestAnimationFrame(() => toast.classList.add('show'));

    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 300);
    }, 5000);
}

document.addEventListener('DOMContentLoaded', function () {
    const contextPath = (typeof globalContextPath !== 'undefined') ? globalContextPath : '';

    const removeLinks = document.querySelectorAll('.fav-remove-link');
    const container = document.querySelector('.favorite-grid');

    removeLinks.forEach(function (link) {
        link.addEventListener('click', async function (e) {
            e.preventDefault();

            const productCard = this.closest('.product-card-fav');
            const href = this.getAttribute('href');

            try {
                await fetch(href, {
                    method: 'GET',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });

                if (productCard) {
                    productCard.style.transition = 'opacity 0.3s';
                    productCard.style.opacity = '0';
                    setTimeout(() => {
                        productCard.remove();
                        const remaining = container.querySelectorAll('.product-card-fav');
                        if (remaining.length === 0) {
                            container.innerHTML = '<p style="grid-column: span 2; text-align: center; color: #999; margin-top: 20px;">Bạn chưa có sản phẩm yêu thích nào.</p>';
                        }
                    }, 300);
                }

                showFavToast('removed', contextPath);
            } catch (error) {
                console.error('Lỗi xóa yêu thích:', error);
            }
        });
    });

    const likeButtons = document.querySelectorAll('.like-btn');

    likeButtons.forEach(btn => {
        btn.addEventListener('click', async (e) => {
            e.stopImmediatePropagation();

            const icon = btn.querySelector('i.fa-heart');
            if (!icon) return;

            const productId = btn.getAttribute('data-id');
            if (!productId) return;

            btn.style.pointerEvents = 'none';
            btn.style.opacity = '0.7';

            try {
                const response = await fetch(`${contextPath}/toggle-favorite?id=${productId}`, {
                    method: 'GET',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });

                if (response.status === 401 || response.status === 403) {
                    window.location.href = `${contextPath}/login`;
                    return;
                }

                if (!response.ok) throw new Error('Server error');

                const data = await response.json();

                if (typeof data.isFavorite === 'boolean') {
                    if (data.isFavorite) {
                        btn.classList.add('is-favorite');
                        icon.classList.remove('fa-regular');
                        icon.classList.add('fa-solid');
                        showFavToast('added', contextPath);
                    } else {
                        btn.classList.remove('is-favorite');
                        icon.classList.remove('fa-solid');
                        icon.classList.add('fa-regular');
                        showFavToast('removed', contextPath);
                    }
                }
            } catch (error) {
                console.error('Lỗi toggle favorite:', error);
            } finally {
                btn.style.pointerEvents = 'auto';
                btn.style.opacity = '1';
            }
        });
    });
});