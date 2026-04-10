document.addEventListener("DOMContentLoaded", function () {
    const hearts = document.querySelectorAll('.product-fav-heart');
    const container = document.querySelector('.favorite-grid');
    hearts.forEach(function (heart) {
        heart.addEventListener('click', function () {
            const confirmDelete = confirm("Bạn có chắc muốn bỏ sản phẩm này khỏi danh sách yêu thích?");

            if (confirmDelete) {
                const productCard = this.closest('.product-card-fav');

                if (productCard) {
                    productCard.remove();
                    const remainingProducts = container.querySelectorAll('.product-card-fav');
                    if (remainingProducts.length === 0) {
                        container.innerHTML = '<p style="grid-column: span 2; text-align: center; color: #999; margin-top: 20px;">Bạn chưa có sản phẩm yêu thích nào.</p>';
                    }
                }
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
                const response = await fetch(`${globalContextPath}/toggle-favorite?id=${productId}`, {
                    method: 'GET',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' }
                });

                if (response.status === 401 || response.status === 403) {
                    window.location.href = `${globalContextPath}/login`;
                    return;
                }

                if (!response.ok) throw new Error('Server error');

                const data = await response.json();

                if (typeof data.isFavorite === 'boolean') {
                    if (data.isFavorite) {
                        btn.classList.add('is-favorite');
                        icon.classList.remove('fa-regular');
                        icon.classList.add('fa-solid');
                    } else {
                        btn.classList.remove('is-favorite');
                        icon.classList.remove('fa-solid');
                        icon.classList.add('fa-regular');
                    }
                }
            } catch (error) {
                console.error('Lỗi toggle favorite:', error);
                alert('Có lỗi khi cập nhật yêu thích. Vui lòng thử lại!');
            } finally {
                btn.style.pointerEvents = 'auto';
                btn.style.opacity = '1';
            }
        });
    });
});