
document.addEventListener("DOMContentLoaded", () => {
    const signupForm = document.getElementById("signup-form");

    signupForm.addEventListener("submit", (event) => {
        event.preventDefault();

        setTimeout(() => {
            window.location.href = "login.jsp";
        }, 500);
    });
});
