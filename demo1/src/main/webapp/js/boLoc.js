document.addEventListener('DOMContentLoaded', function () {
    const filterBtn = document.getElementById("filterToggleBtn");
    const filterSection = document.querySelector(".filter-section");
    const confirmBtn = document.querySelector(".confirm-button");
    const filterCheckboxes = document.querySelectorAll('.options-grid input[type="checkbox"]');

    function updateConfirmButtonState() {
        const isAnyCheckboxChecked = Array.from(filterCheckboxes).some(checkbox => checkbox.checked);
        confirmBtn.disabled = !isAnyCheckboxChecked;
    }

    filterBtn.addEventListener("click", () => {
        filterSection.classList.toggle("active");
    });

    filterCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateConfirmButtonState);
    });

    const cancelBtn = document.querySelector(".cancel-button");
    cancelBtn.addEventListener("click", (event) => {
        event.preventDefault();
        filterCheckboxes.forEach(checkbox => {
            checkbox.checked = false;
        });
        updateConfirmButtonState();
        window.location.href = cancelBtn.href;
    });

    updateConfirmButtonState();
});
