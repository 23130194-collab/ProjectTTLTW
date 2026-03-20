document.addEventListener('DOMContentLoaded', function () {
    const tabs = document.querySelectorAll('.product-tabs .tab');

    tabs.forEach(tab => {
        tab.addEventListener('click', function () {
            tabs.forEach(t => t.classList.remove('active'));

            this.classList.add('active');

            console.log('Đã chọn tab:', this.innerText);
        });
    });

    const selectAllCheckbox = document.getElementById('selectAllProducts');
    const rowCheckboxes = document.querySelectorAll('.row-check');

    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function () {
            const isChecked = this.checked;

            rowCheckboxes.forEach(checkbox => {
                checkbox.checked = isChecked;
            });
        });
    }

    rowCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (!this.checked) {
                selectAllCheckbox.checked = false;
            } else {
                const allChecked = Array.from(rowCheckboxes).every(cb => cb.checked);
                selectAllCheckbox.checked = allChecked;
            }
        });
    });

    const editBtns = document.querySelectorAll('.action-btn.edit');
    editBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            const productName = this.closest('tr').querySelector('.product-name').innerText;
            console.log('Đang sửa sản phẩm:', productName);
        });
    });

    const viewBtns = document.querySelectorAll('.action-btn.view');
    viewBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            const productName = this.closest('tr').querySelector('.product-name').innerText;
            console.log('Đang xem chi tiết:', productName);
        });
    });

    const deleteBtns = document.querySelectorAll('.action-btn.delete');
    deleteBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            const productName = this.closest('tr').querySelector('.product-name').innerText;
            if(!confirm(`Bạn có chắc muốn xóa sản phẩm: "${productName}" không?`)) {
                e.preventDefault();
                console.log('Đã hủy xóa:', productName);
            }
        });
    });

    const searchInput = document.querySelector('.search-input-product');
    if (searchInput) {
        searchInput.addEventListener('keyup', function(e) {
            if (e.key === 'Enter') {
            }
        });
    }
});