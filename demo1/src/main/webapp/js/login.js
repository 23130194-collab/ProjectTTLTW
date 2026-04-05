document.addEventListener("DOMContentLoaded", () => {
    const loginForm = document.getElementById("login-form");

    loginForm.addEventListener("submit", (event) => {
        event.preventDefault();

        setTimeout(() => {
            window.location.href = "home.jsp";
        }, 500);
    });
});
