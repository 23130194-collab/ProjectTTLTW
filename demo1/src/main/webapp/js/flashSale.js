let countdownTime = 10 * 60;
function updateCountdown() {
    const minutes = String(Math.floor(countdownTime / 60)).padStart(2, '0');
    const seconds = String(countdownTime % 60).padStart(2, '0');
    document.getElementById('countdown').textContent = `00:${minutes}:${seconds}`;
    if (countdownTime > 0) countdownTime--;
}
setInterval(updateCountdown, 1000);

const slider = document.getElementById('slider');
const leftBtn = document.querySelector('.arrow.left');
const rightBtn = document.querySelector('.arrow.right');
let scrollAmount = 0;

function slide(dir) {
    const cardWidth = 250;
    const visible = 4.8;
    const maxScroll = (slider.children.length - visible) * cardWidth;
    if (dir === 'right') {
        scrollAmount += cardWidth;
        if (scrollAmount > maxScroll) scrollAmount = 0;
    } else {
        scrollAmount -= cardWidth;
        if (scrollAmount < 0) scrollAmount = maxScroll;
    }
    slider.style.transform = `translateX(-${scrollAmount}px)`;
}

rightBtn.addEventListener('click', () => slide('right'));
leftBtn.addEventListener('click', () => slide('left'));
setInterval(() => slide('right'), 5000);