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
});