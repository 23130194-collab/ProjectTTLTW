
document.addEventListener("DOMContentLoaded", () => {
    const forgotForm = document.getElementById("forgot-password-form");

    forgotForm.addEventListener("submit", (event) => {
        event.preventDefault();
        const email = document.getElementById("forgot-email").value.trim();

        setTimeout(() => {
            window.location.href = "login.jsp";
        }, 500);
    });
});
