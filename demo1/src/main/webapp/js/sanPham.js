document.addEventListener('DOMContentLoaded', function () {
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
            window.scrollTo({top: 0, behavior: 'smooth'});
        });
    }

    const ratingInputs = document.querySelectorAll('.rating-input');
    const ratingOptions = document.querySelectorAll('.rating-option');
    const ratingGroup = document.querySelector('.rating-options');

    if (ratingGroup) {
        function highlightStars(count) {
            ratingOptions.forEach((option, index) => {
                if (index < count) option.classList.add('star-fill');
                else option.classList.remove('star-fill');
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
        ratingInputs.forEach((input) => {
            input.addEventListener('change', resetStars);
        });
        resetStars();
    }

    const mainImage = document.getElementById('main-product-img');
    const thumbnailImages = document.querySelectorAll('.thumbnails-wrapper img');

    if (mainImage && thumbnailImages.length > 0) {
        thumbnailImages.forEach(thumb => {
            thumb.addEventListener('click', function () {
                const newSrc = this.getAttribute('data-main-img');
                if (newSrc) mainImage.src = newSrc;

                thumbnailImages.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
            });
        });
    }

    const sliderWrapper = document.querySelector('.thumbnails-wrapper');
    const btnPrev = document.querySelector('.thumb-nav.prev-btn');
    const btnNext = document.querySelector('.thumb-nav.next-btn');

    if (sliderWrapper && btnPrev && btnNext) {
        const scrollAmount = (75 + 10) * 2;
        btnNext.addEventListener('click', () => {
            sliderWrapper.scrollBy({left: scrollAmount, behavior: 'smooth'});
        });
        btnPrev.addEventListener('click', () => {
            sliderWrapper.scrollBy({left: -scrollAmount, behavior: 'smooth'});
        });
    }

    const reviewForm = document.getElementById('form-review-product');
    const txtReviewContent = document.querySelector('.review-comment-box textarea');

    if (reviewForm && txtReviewContent) {
        reviewForm.addEventListener('submit', (e) => {
            const content = txtReviewContent.value;

            if (content.trim() === "") {
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
        const productId = productIdInput.value;

        let currentOffset = 5;
        let currentFilter = 0;
        let isLoading = false;

        function createReviewElement(review) {
            const reviewItem = document.createElement('div');
            reviewItem.className = 'review-item';
            reviewItem.setAttribute('data-rating', review.rating);

            const formattedDate = new Date(review.createdAt).toLocaleDateString('vi-VN');

            let ratingLabel = 'Bình thường';
            if (review.rating >= 5) ratingLabel = 'Tuyệt vời';
            else if (review.rating >= 4) ratingLabel = 'Tốt';
            else if (review.rating < 3) ratingLabel = 'Tệ';

            let starsHtml = '';
            for (let i = 1; i <= 5; i++) {
                starsHtml += `<i class="fa-solid fa-star ${review.rating >= i ? 'star-active' : 'star-grey'}"></i>`;
            }

            reviewItem.innerHTML = `
            <div class="reviewer-avatar">${review.userName.substring(0, 1)}</div>
            <div class="review-content">
                <div class="reviewer-name">${review.userName}</div>
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
            if (isLoading) {
                return;
            }

            isLoading = true;

            if (btnSeeMore) {
                btnSeeMore.textContent = 'Đang tải...';
                btnSeeMore.disabled = true;
            }

            const apiUrl = `${globalContextPath}/api/reviews?productId=${productId}&filter=${currentFilter}&offset=${currentOffset}`;

            try {
                const response = await fetch(apiUrl);

                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }

                const newReviews = await response.json();

                if (newReviews.length > 0) {
                    newReviews.forEach(review => {
                        const reviewElement = createReviewElement(review);
                        reviewsList.appendChild(reviewElement);
                    });

                    currentOffset += newReviews.length;

                    if (newReviews.length < 5 && btnSeeMore) {
                        btnSeeMore.style.display = 'none';
                    }
                } else {
                    if (btnSeeMore) {
                        btnSeeMore.style.display = 'none';
                    }
                }

            } catch (error) {
                console.error('Fetch error:', error);
                if (btnSeeMore) {
                    btnSeeMore.textContent = 'Lỗi, thử lại?';
                }
                alert('Không thể tải đánh giá. Vui lòng thử lại!');
            } finally {
                isLoading = false;
                if (btnSeeMore) {
                    btnSeeMore.disabled = false;
                    if (btnSeeMore.textContent === 'Đang tải...') {
                        btnSeeMore.textContent = 'Xem thêm đánh giá';
                    }
                }
            }
        }

        if (btnSeeMore) {
            btnSeeMore.addEventListener('click', fetchReviews);
        }

        filterReviewInputs.forEach(input => {
            input.addEventListener('change', function () {
                let newFilterValue = 0;
                if (this.id === 'filter-all') {
                    newFilterValue = 0;
                } else {
                    const match = this.id.match(/\d+/);
                    newFilterValue = match ? parseInt(match[0]) : 0;
                }

                currentFilter = newFilterValue;

                currentOffset = 0;

                reviewsList.innerHTML = '';

                if (btnSeeMore) {
                    btnSeeMore.style.display = 'flex';
                    btnSeeMore.textContent = 'Xem thêm đánh giá';
                }

                fetchReviews();
            });
        });
    }
});