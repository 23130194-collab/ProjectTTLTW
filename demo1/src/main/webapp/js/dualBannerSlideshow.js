document.addEventListener('DOMContentLoaded', function () {
    function setupSlider(sliderId) {
        const sliderElement = document.getElementById(sliderId);
        if (!sliderElement) return;

        const wrapper = sliderElement.querySelector('.slides-wrapper');
        const slides = wrapper.querySelectorAll('.banner-img');
        const prevBtn = sliderElement.querySelector('.prev-btn');
        const nextBtn = sliderElement.querySelector('.next-btn');
        const dotsContainer = sliderElement.querySelector('.dots-container');

        let currentSlideIndex = 0;
        let slideWidth = slides[0].clientWidth;
        let autoSlideInterval;

        function goToSlide(index) {
            if (index < 0) {
                index = slides.length - 1;
            } else if (index >= slides.length) {
                index = 0;
            }
            currentSlideIndex = index;

            const offset = -currentSlideIndex * slideWidth;
            wrapper.style.transform = `translateX(${offset}px)`;

            updateDots();
        }

        function nextSlide() {
            goToSlide(currentSlideIndex + 1);
        }

        function startAutoSlideshow() {
            if (autoSlideInterval) {
                clearInterval(autoSlideInterval);
            }
            autoSlideInterval = setInterval(nextSlide, 4000);
        }

        function handleResize() {
            slideWidth = slides[0].clientWidth;
            goToSlide(currentSlideIndex);
        }

        function createDots() {
            dotsContainer.innerHTML = '';
            slides.forEach((_, index) => {
                const dot = document.createElement('span');
                dot.classList.add('dot');
                if (index === 0) dot.classList.add('active');

                dot.addEventListener('click', () => {
                    goToSlide(index);
                    startAutoSlideshow();
                });
                dotsContainer.appendChild(dot);
            });
        }

        function updateDots() {
            dotsContainer.querySelectorAll('.dot').forEach((dot, index) => {
                dot.classList.toggle('active', index === currentSlideIndex);
            });
        }

        let isDragging = false;
        let startPos = 0;
        let currentTranslate = 0;
        let prevTranslate = 0;
        let animationID = 0;

        function dragStart(event) {
            clearInterval(autoSlideInterval);

            isDragging = true;

            startPos = event.type.includes('mouse') ? event.clientX : event.touches[0].clientX;

            wrapper.style.transition = 'none';
        }

        function drag(event) {
            if (!isDragging) return;

            const currentPos = event.type.includes('mouse') ? event.clientX : event.touches[0].clientX;

            currentTranslate = prevTranslate + currentPos - startPos;

            wrapper.style.transform = `translateX(${currentTranslate}px)`;
        }

        function dragEnd() {
            if (!isDragging) return;
            isDragging = false;

            wrapper.style.transition = 'transform 0.5s ease-in-out';

            const movedBy = currentTranslate - prevTranslate;
            const threshold = slideWidth / 4;

            if (movedBy < -threshold) {
                goToSlide(currentSlideIndex + 1);
            } else if (movedBy > threshold) {
                goToSlide(currentSlideIndex - 1);
            } else {
                goToSlide(currentSlideIndex);
            }

            prevTranslate = -currentSlideIndex * slideWidth;

            startAutoSlideshow();
        }

        slideWidth = slides[0].clientWidth;
        prevTranslate = 0;

        createDots();
        startAutoSlideshow();

        prevBtn.addEventListener('click', () => {
            goToSlide(currentSlideIndex - 1);
            startAutoSlideshow();
        });
        nextBtn.addEventListener('click', () => {
            goToSlide(currentSlideIndex + 1);
            startAutoSlideshow();
        });

        wrapper.addEventListener('mousedown', dragStart);
        window.addEventListener('mousemove', drag);
        window.addEventListener('mouseup', dragEnd);

        wrapper.addEventListener('mouseleave', dragEnd);
        wrapper.addEventListener('dragstart', e => e.preventDefault());

        wrapper.addEventListener('touchstart', dragStart);
        wrapper.addEventListener('touchmove', drag);
        wrapper.addEventListener('touchend', dragEnd);

        window.addEventListener('resize', handleResize);
    }

    setupSlider('banner-left');
    setupSlider('banner-right');
});