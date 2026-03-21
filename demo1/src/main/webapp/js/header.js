const categoryToggle = document.getElementById("category-toggle");
const categoryBox = document.getElementById("categoryBox");
const overlay = document.getElementById("overlay");

categoryToggle.addEventListener("click", (e) => {
    e.preventDefault();
    categoryBox.classList.toggle("show");
    overlay.classList.toggle("active");
});

overlay.addEventListener("click", () => {
    categoryBox.classList.remove("show");
    overlay.classList.remove("active");
});

const currentPage = window.location.pathname.split("/").pop();
const navLinks = document.querySelectorAll(".nav-links a");

navLinks.forEach(link => {
    const linkPage = link.getAttribute("href");
    if (linkPage === currentPage || (linkPage === "index.html" && currentPage === "")) {
        link.classList.add("active");
    } else {
        link.classList.remove("active");
    }
});
