const filterBtn = document.getElementById("filterToggleBtn");
const filterSection = document.querySelector(".filter-section");

filterBtn.addEventListener("click", () => {
    filterSection.classList.toggle("active");
});

const cancelBtn = document.querySelector(".cancel-button");
cancelBtn.addEventListener("click", () => {
    filterSection.classList.remove("active");
});

const confirmBtn = document.querySelector(".confirm-button");
confirmBtn.addEventListener("click", () => {
    filterSection.classList.remove("active");
});