document.addEventListener('DOMContentLoaded', function () {
    function initTinyMCE() {
        if (typeof tinymce !== 'undefined') {
            tinymce.init({
                selector: '#product-description',
                plugins: 'anchor autolink charmap codesample emoticons image link lists media searchreplace table visualblocks wordcount',
                toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table | align lineheight | numlist bullist indent outdent | emoticons charmap | removeformat',
                language: 'vi',
                height: 400,
                menubar: false,
                placeholder: 'Nhập mô tả chi tiết cho sản phẩm...',
                entity_encoding: 'raw',
                verify_html: false,
                forced_root_block: 'p',
                remove_script_host: false,
                convert_urls: false,
                setup: function(editor) {
                    editor.on('init', function() {
                        console.log('TinyMCE đã khởi tạo thành công!');
                        const textarea = document.getElementById('product-description');
                        if (textarea && textarea.value.trim()) {
                            editor.setContent(textarea.value);
                            console.log('Đã load nội dung vào TinyMCE');
                        }
                    });
                }
            });
        } else {
            console.error('TinyMCE chưa được load!');
            setTimeout(initTinyMCE, 500);
        }
    }
    initTinyMCE();

    const btnAddImage = document.getElementById('btn-add-image');
    const imageUrlInput = document.getElementById('image-url-input');
    const imageOrderInput = document.getElementById('image-order-input');
    const previewContainer = document.getElementById('image-preview-container');
    const dataContainer = document.getElementById('image-data-container');

    function loadExistingImages() {
        if (!dataContainer || !previewContainer) return;

        const urlInputs = dataContainer.querySelectorAll('input[name="imageUrls"]');
        const orderInputs = dataContainer.querySelectorAll('input[name="imageOrders"]');

        urlInputs.forEach((urlInput, index) => {
            let imageUrl = urlInput.value;
            const displayOrder = orderInputs[index] ? orderInputs[index].value : '0';
            const imageId = 'img-existing-' + index;

            urlInput.setAttribute('data-image-id', imageId);
            if (orderInputs[index]) {
                orderInputs[index].setAttribute('data-image-id', imageId);
            }

            let finalSrc = imageUrl;
            if (imageUrl && !imageUrl.startsWith('http') && !imageUrl.startsWith('/')) {
                finalSrc = globalContextPath + '/' + imageUrl;
            }

            const thumbItem = document.createElement('div');
            thumbItem.classList.add('thumb-item');
            thumbItem.setAttribute('data-image-id', imageId);

            thumbItem.innerHTML = `
            <img src="${finalSrc}" alt="Preview" onerror="this.src='https://placehold.co/100x100?text=No+Image'">
            <span class="remove-thumb" title="Xóa ảnh này">&times;</span>
            <div class="thumb-order">Thứ tự: ${displayOrder}</div>
        `;

            previewContainer.appendChild(thumbItem);
        });
    }

    loadExistingImages();

    function showInlineError(message) {
        let errorDiv = document.querySelector('.js-error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'js-error-message';
            errorDiv.style.cssText = "background-color: #ffebee; color: #c62828; padding: 15px; margin: 20px 0; border: 1px solid #ef9a9a; border-radius: 4px;";
            const formContainer = document.querySelector('.upload-product-container');
            if (formContainer) {
                formContainer.parentNode.insertBefore(errorDiv, formContainer);
            }
        }
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        setTimeout(() => {
            errorDiv.style.display = 'none';
        }, 5000);
    }

    if (btnAddImage) {
        btnAddImage.addEventListener('click', function() {
            const imageUrl = imageUrlInput.value.trim();
            const displayOrder = imageOrderInput.value.trim() || '0';

            if (!imageUrl) {
                alert('Vui lòng nhập URL hoặc tải ảnh lên.');
                return;
            }

            const imageId = 'img-' + Date.now();

            const thumbItem = document.createElement('div');
            thumbItem.classList.add('thumb-item');
            thumbItem.setAttribute('data-image-id', imageId);

            const imgElement = document.createElement('img');
            imgElement.src = imageUrl;
            imgElement.alt = "Preview";
            imgElement.onerror = function() {
                this.onerror = null;
                this.src = 'https://placehold.co/100x100/e2e8f0/475569?text=Lỗi+Ảnh';
            };

            const removeBtn = document.createElement('span');
            removeBtn.className = 'remove-thumb';
            removeBtn.innerHTML = '&times;';
            removeBtn.title = 'Xóa ảnh này';

            const orderDiv = document.createElement('div');
            orderDiv.className = 'thumb-order';
            orderDiv.textContent = `Thứ tự: ${displayOrder}`;

            thumbItem.appendChild(imgElement);
            thumbItem.appendChild(removeBtn);
            thumbItem.appendChild(orderDiv);
            previewContainer.appendChild(thumbItem);

            const urlHiddenInput = document.createElement('input');
            urlHiddenInput.type = 'hidden';
            urlHiddenInput.name = 'imageUrls';
            urlHiddenInput.value = imageUrl;
            urlHiddenInput.setAttribute('data-image-id', imageId);

            const orderHiddenInput = document.createElement('input');
            orderHiddenInput.type = 'hidden';
            orderHiddenInput.name = 'imageOrders';
            orderHiddenInput.value = displayOrder;
            orderHiddenInput.setAttribute('data-image-id', imageId);

            dataContainer.appendChild(urlHiddenInput);
            dataContainer.appendChild(orderHiddenInput);

            imageUrlInput.value = '';
            imageOrderInput.value = '';
            imageUrlInput.focus();
        });

        previewContainer.addEventListener('click', function(e) {
            if (e.target && e.target.classList.contains('remove-thumb')) {
                const thumbItem = e.target.closest('.thumb-item');
                if (thumbItem) {
                    const imageId = thumbItem.getAttribute('data-image-id');
                    thumbItem.remove();
                    const inputsToRemove = dataContainer.querySelectorAll(`[data-image-id="${imageId}"]`);
                    inputsToRemove.forEach(input => input.remove());
                }
            }
        });
    }

    const categorySelect = document.getElementById('category-select');
    const attributeSelect = document.getElementById('attribute-select');
    const attributesContainer = document.getElementById('attributes-container');

    const deleteModal = document.getElementById('delete-spec-modal');
    const btnCancelDelete = document.getElementById('btn-cancel-delete');
    const btnConfirmDelete = document.getElementById('btn-confirm-delete');
    const modalSpecName = document.getElementById('modal-spec-name');
    let itemToDelete = null;

    function closeModal() {
        if(deleteModal) {
            deleteModal.classList.remove('show');
            itemToDelete = null;
        }
    }

    if(btnConfirmDelete) {
        btnConfirmDelete.addEventListener('click', function() {
            if(itemToDelete) {
                itemToDelete.classList.add('is-deleting');
                itemToDelete.style.transition = 'all 0.2s ease';
                itemToDelete.style.opacity = '0';
                itemToDelete.style.maxHeight = '0';
                itemToDelete.style.margin = '0';
                itemToDelete.style.padding = '0';
                itemToDelete.style.overflow = 'hidden';

                setTimeout(() => {
                    itemToDelete.remove();
                }, 200);
            }
            closeModal();
        });
    }

    if(btnCancelDelete) {
        btnCancelDelete.addEventListener('click', closeModal);
    }

    if(deleteModal) {
        deleteModal.addEventListener('click', function(e) {
            if (e.target === deleteModal) {
                closeModal();
            }
        });
    }

    if (categorySelect && attributeSelect && attributesContainer) {

        categorySelect.addEventListener('change', function() {
            const categoryId = this.value;
            attributeSelect.innerHTML = '<option value="">Đang tải...</option>';

            if(categoryId) {
                const contextPath = (typeof globalContextPath !== 'undefined') ? globalContextPath : '';
                const apiUrl = contextPath + '/api/get-attributes?categoryId=' + categoryId;

                fetch(apiUrl)
                    .then(res => res.json())
                    .then(data => {
                        attributeSelect.innerHTML = '<option value="">Chọn thuộc tính</option>';
                        if (data.length === 0) {
                            attributeSelect.innerHTML = '<option value="">(Không có thuộc tính nào)</option>';
                        } else {
                            data.forEach(attr => {
                                const option = document.createElement('option');
                                option.value = attr.id;
                                option.textContent = attr.name;
                                option.dataset.name = attr.name;
                                attributeSelect.appendChild(option);
                            });
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        attributeSelect.innerHTML = '<option value="">Lỗi tải dữ liệu</option>';
                    });
            } else {
                attributeSelect.innerHTML = '<option value="">Chọn thuộc tính</option>';
            }
        });

        if (categorySelect.value) {
            categorySelect.dispatchEvent(new Event('change'));
        }

        attributeSelect.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const attrId = selectedOption.value;
            const attrName = selectedOption.dataset.name;

            if (!attrId) return;

            const existingSpecs = Array.from(attributesContainer.querySelectorAll('input[name="specIds"]'));
            const isDuplicate = existingSpecs.some(input => {
                return input.value === attrId && !input.closest('.attribute-item').classList.contains('is-deleting');
            });

            if (isDuplicate) {
                showInlineError("Thuộc tính '" + attrName + "' đã tồn tại trong danh sách!");
                this.value = "";
                return;
            }

            const itemDiv = document.createElement('div');
            itemDiv.className = 'attribute-item active';

            itemDiv.innerHTML = `
                <div class="attr-top">
                    <span class="attr-name">${attrName}</span>
                    <div class="attr-controls">
                        <span class="attr-delete" title="Xóa thuộc tính này">Xóa</span>
                        <i class="fa-solid fa-chevron-down attr-toggle-icon"></i>
                    </div>
                </div>
                <div class="attr-body">
                    <input type="hidden" name="specIds" value="${attrId}">
                    <div class="attr-row">
                        <span class="attr-label">Tên:</span>
                        <span class="attr-static-val">${attrName}</span>
                    </div>
                    <div class="attr-row">
                        <span class="attr-label">Giá trị:</span>
                        <input type="text" name="specValues" class="form-input" placeholder="Nhập giá trị...">
                    </div>
                </div>
            `;
            attributesContainer.appendChild(itemDiv);
            this.value = "";
        });

        attributesContainer.addEventListener('click', function(e) {
            const target = e.target;
            console.log("Bạn vừa click vào:", target);
            if (target.classList.contains('attr-delete')) {
                console.log("Đã bắt được sự kiện xóa!");
                e.stopPropagation();

                const item = target.closest('.attribute-item');
                if(item) {
                    itemToDelete = item;

                    const nameEl = item.querySelector('.attr-name');
                    if(nameEl && modalSpecName) {
                        modalSpecName.textContent = nameEl.textContent;
                    }

                    if(deleteModal) deleteModal.classList.add('show');
                }
                return;
            }

            const header = target.closest('.attr-top');
            if (header) {
                const item = header.closest('.attribute-item');
                if (item) item.classList.toggle('active');
            }
        });
    }
    const productForm = document.querySelector('.upload-product-container');
    productForm.addEventListener('submit', function(e) {
        const discountInput = document.querySelector('input[name="discountValue"]');
        if (discountInput && discountInput.value.trim() !== "") {
            const val = parseFloat(discountInput.value);
            if (val < 0 || val > 100) {
                e.preventDefault();
                showInlineError("Giá trị giảm giá phải nằm trong khoảng từ 0 đến 100%!");
                discountInput.style.borderColor = '#ef4444';
                discountInput.focus();
                return;
            }
        }

        const startDateInput = document.querySelector('input[name="discountStart"]');
        const endDateInput = document.querySelector('input[name="discountEnd"]');
        const discountValue = document.querySelector('input[name="discountValue"]').value;

        if (discountValue && parseFloat(discountValue) > 0) {
            if (startDateInput.value && endDateInput.value) {
                const start = new Date(startDateInput.value);
                const end = new Date(endDateInput.value);

                if (start >= end) {
                    e.preventDefault();
                    showInlineError("Ngày kết thúc giảm giá phải sau ngày bắt đầu!");
                    endDateInput.style.borderColor = '#ef4444';
                    endDateInput.focus();
                    return;
                }
            }
        }
    });

    document.addEventListener('DOMContentLoaded', function() {
        const discountInput = document.querySelector('input[name="discountValue"]');
        const startDateInput = document.querySelector('input[name="discountStart"]');
        const endDateInput = document.querySelector('input[name="discountEnd"]');

        function toggleDiscountDates() {
            const hasDiscount = discountInput.value.trim() !== "" && parseFloat(discountInput.value) > 0;

            startDateInput.addEventListener('change', function() {
                if (startDateInput.value) {
                    endDateInput.min = startDateInput.value;
                }
            });

            endDateInput.addEventListener('change', function() {
                if (endDateInput.value) {
                    startDateInput.max = endDateInput.value;
                }
            });

            if (hasDiscount) {
                startDateInput.removeAttribute('disabled');
                endDateInput.removeAttribute('disabled');
                startDateInput.style.backgroundColor = "#fff";
                endDateInput.style.backgroundColor = "#fff";
            } else {
                startDateInput.setAttribute('disabled', 'true');
                endDateInput.setAttribute('disabled', 'true');
                startDateInput.value = "";
                endDateInput.value = "";
                startDateInput.style.backgroundColor = "#f1f5f9";
                endDateInput.style.backgroundColor = "#f1f5f9";
            }
        }

        toggleDiscountDates();

        discountInput.addEventListener('input', toggleDiscountDates);
    });
});