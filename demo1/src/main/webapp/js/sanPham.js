document.addEventListener('DOMContentLoaded', function () {
    const globalContextPath = document.querySelector('script[src*="sanPham.js"]').getAttribute('src')
        .replace('/js/sanPham.js', '');
    const specBtn = document.querySelector('.spec-btn');
    const specModal = document.getElementById('spec-modal');
    const closeSpecBtn = document.getElementById('close-spec-modal');

    if (specBtn && specModal && closeSpecBtn) {
        specBtn.addEventListener('click', () => {
            specModal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        });
        closeSpecBtn.addEventListener('click', () => {
            specModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        });
        window.addEventListener('click', (e) => {
            if (e.target === specModal) {
                specModal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    }

    const btnWriteReview = document.getElementById('btn-write-review');
    const reviewModal = document.getElementById('review-modal');
    const closeReviewModal = document.getElementById('close-review-modal');

    if (btnWriteReview && reviewModal && closeReviewModal) {
        btnWriteReview.addEventListener('click', () => {
            reviewModal.style.display = 'block';
            document.body.style.overflow = 'hidden';
        });
        closeReviewModal.addEventListener('click', () => {
            reviewModal.style.display = 'none';
            document.body.style.overflow = 'auto';
        });
        window.addEventListener('click', (e) => {
            if (e.target === reviewModal) {
                reviewModal.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        });
    }

    const btnScrollTop = document.getElementById('btn-scroll-top');
    if (btnScrollTop) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 300) btnScrollTop.classList.add('show');
            else btnScrollTop.classList.remove('show');
        });
        btnScrollTop.addEventListener('click', () => {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    }

    const ratingInputs = document.querySelectorAll('.rating-input');
    const ratingOptions = document.querySelectorAll('.rating-option');
    const ratingGroup = document.querySelector('.rating-options');

    if (ratingGroup) {
        function highlightStars(count) {
            ratingOptions.forEach((option, index) => {
                option.classList.toggle('star-fill', index < count);
            });
        }

        function resetStars() {
            let checkedIndex = -1;
            ratingInputs.forEach((input, index) => {
                if (input.checked) checkedIndex = index;
            });
            highlightStars(checkedIndex + 1);
        }

        ratingOptions.forEach((option, index) => {
            option.addEventListener('mouseenter', () => highlightStars(index + 1));
        });
        ratingGroup.addEventListener('mouseleave', resetStars);
        ratingInputs.forEach(input => input.addEventListener('change', resetStars));

        resetStars();
    }

    const mainImage = document.getElementById('main-product-img');
    const thumbnailsWrapper = document.querySelector('.thumbnails-wrapper');
    const thumbnailImages = document.querySelectorAll('.thumbnails-wrapper img');
    const btnPrev = document.getElementById('prev-thumb-btn');
    const btnNext = document.getElementById('next-thumb-btn');

    if (mainImage && thumbnailsWrapper && thumbnailImages.length > 0) {

        thumbnailImages.forEach(thumb => {
            thumb.addEventListener('click', function () {
                mainImage.src = this.getAttribute('data-main-img');

                thumbnailImages.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });

        if (thumbnailImages[0]) thumbnailImages[0].classList.add('active');

        const visibleCount = 7;
        const thumbWidth = 85;

        function scrollToShow(index) {
            const scrollLeft = Math.max(0, (index - visibleCount + 2) * thumbWidth);
            thumbnailsWrapper.scrollTo({
                left: scrollLeft,
                behavior: 'smooth'
            });
        }

        function changeImage(direction) {
            const currentActive = document.querySelector('.thumbnails-wrapper img.active');
            if (!currentActive) return;

            let nextActive;
            if (direction === 'next') {
                nextActive = currentActive.nextElementSibling || thumbnailImages[0];
            } else {
                nextActive = currentActive.previousElementSibling || thumbnailImages[thumbnailImages.length - 1];
            }

            if (nextActive) {
                nextActive.click();
                const newIndex = Array.from(thumbnailImages).indexOf(nextActive);
                scrollToShow(newIndex);
            }
        }

        if (btnNext) {
            btnNext.addEventListener('click', () => changeImage('next'));
        }

        if (btnPrev) {
            btnPrev.addEventListener('click', () => changeImage('prev'));
        }
    }

    const reviewForm = document.getElementById('form-review-product');
    const txtReviewContent = document.querySelector('.review-comment-box textarea');

    if (reviewForm && txtReviewContent) {
        reviewForm.addEventListener('submit', (e) => {
            if (txtReviewContent.value.trim() === "") {
                alert("Bạn chưa nhập nội dung đánh giá!");
                e.preventDefault();
            }
        });
    }

    const reviewsList = document.querySelector('.reviews-list');
    const btnSeeMore = document.querySelector('.btn-see-more');
    const filterReviewInputs = document.querySelectorAll('.reviews-filter .filter-input');
    const productIdInput = document.querySelector('input[name="productId"]');

    if (reviewsList && filterReviewInputs.length > 0 && productIdInput) {
        let currentOffset = 5;
        let currentFilter = 0;
        let isLoading = false;

        function createReviewElement(review) {
            const reviewItem = document.createElement('div');
            reviewItem.className = 'review-item';
            reviewItem.setAttribute('data-rating', review.rating);

            const formattedDate = new Date(review.createdAt).toLocaleDateString('vi-VN');

            let ratingLabel = review.rating >= 5 ? 'Tuyệt vời' :
                review.rating >= 4 ? 'Tốt' :
                    review.rating >= 3 ? 'Bình thường' : 'Tệ';

            let starsHtml = '';
            for (let i = 1; i <= 5; i++) {
                starsHtml += `<i class="fa-solid fa-star ${review.rating >= i ? 'star-active' : 'star-grey'}"></i>`;
            }

            reviewItem.innerHTML = `
                <div class="reviewer-avatar">${(review.userName || 'U').substring(0, 1)}</div>
                <div class="review-content">
                    <div class="reviewer-name">${review.userName || 'Người dùng ẩn danh'}</div>
                    <div class="review-rating">
                        ${starsHtml}
                        <span class="rating-label-text">${ratingLabel}</span>
                    </div>
                    <div class="review-text">${review.content}</div>
                    <div class="review-time">
                        <i class="fa-regular fa-clock"></i>
                        Đánh giá đã đăng vào: ${formattedDate}
                    </div>
                </div>
            `;
            return reviewItem;
        }

        async function fetchReviews() {
            if (isLoading) return;
            isLoading = true;

            if (btnSeeMore) {
                btnSeeMore.textContent = 'Đang tải...';
                btnSeeMore.disabled = true;
            }

            try {
                const response = await fetch(
                    `${globalContextPath}/api/reviews?productId=${productIdInput.value}&filter=${currentFilter}&offset=${currentOffset}`
                );

                if (!response.ok) throw new Error('Network error');

                const newReviews = await response.json();

                if (newReviews.length > 0) {
                    newReviews.forEach(review => {
                        reviewsList.appendChild(createReviewElement(review));
                    });
                    currentOffset += newReviews.length;

                    if (newReviews.length < 5 && btnSeeMore) btnSeeMore.style.display = 'none';
                } else if (btnSeeMore) {
                    btnSeeMore.style.display = 'none';
                }
            } catch (error) {
                console.error(error);
                alert('Không thể tải đánh giá. Vui lòng thử lại!');
            } finally {
                isLoading = false;
                if (btnSeeMore) {
                    btnSeeMore.disabled = false;
                    btnSeeMore.textContent = 'Xem thêm đánh giá';
                }
            }
        }

        if (btnSeeMore) btnSeeMore.addEventListener('click', fetchReviews);

        filterReviewInputs.forEach(input => {
            input.addEventListener('change', () => {
                currentFilter = input.id === 'filter-all' ? 0 : parseInt(input.value) || 0;
                currentOffset = 0;
                reviewsList.innerHTML = '';
                if (btnSeeMore) btnSeeMore.style.display = 'flex';
                fetchReviews();
            });
        });
    }
});