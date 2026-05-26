 (function () {
    const selectedCard = document.querySelector('.address-card.selected')
    || document.querySelector('.address-card');
    if (selectedCard) {
    applyAddressToForm(selectedCard);
}
})();

    function applyAddressToForm(card) {
    document.getElementById('form-address').value    = card.dataset.fullAddress || '';
    document.getElementById('form-province').value   = card.dataset.province    || '';
    document.getElementById('form-district').value   = card.dataset.district    || '';
    document.getElementById('form-ward').value       = card.dataset.ward        || '';
    document.getElementById('form-address-id').value = card.dataset.id          || '';
    document.getElementById('form-fullname-addr').value = card.dataset.fullname || '';
    document.getElementById('form-phone-addr').value    = card.dataset.phone    || '';
    updateShippingFee(card.dataset.id || '');
}

    function _highlightAndApply(card) {
    const hint = document.getElementById('noAddressHint');
    if (hint) hint.remove();

    document.querySelectorAll('.address-card').forEach(c => c.classList.remove('selected'));
    document.querySelectorAll('.addr-radio').forEach(r => r.checked = false);
    card.classList.add('selected');
    const radio = card.querySelector('.addr-radio');
    if (radio) radio.checked = true;

    const displayBox = document.getElementById('selected-address-box');
    if (displayBox) {
    const labelEl  = card.querySelector('.addr-label');
    const label    = labelEl ? labelEl.textContent.trim() : '';
    const namePh   = escHtml(card.dataset.fullname) + ' | ' + escHtml(card.dataset.phone);
    const defBadge = card.dataset.default === 'true' ? '<span class="addr-default-badge">Mặc định</span>' : '';

    displayBox.innerHTML =
    '<div class="selected-address-display">'
    + '<div class="addr-name-phone">'
    + (label ? '<span class="addr-label">' + escHtml(label) + '</span>' : '')
    + namePh + ' ' + defBadge
    + '</div>'
    + '<div class="addr-detail">' + escHtml(card.dataset.fullAddress) + '</div>'
    + '<button type="button" class="btn-change-address" id="btnOpenAddressModal" onclick="openAddressModal()">'
    + '<i class="fa-solid fa-pen-to-square"></i> Thay đổi'
    + '</button>'
    + '</div>';
}

    applyAddressToForm(card);
}

    function selectAddress(card) {
    _highlightAndApply(card);
    setTimeout(closeAddressModal, 200);
}

    function applyNewCard(card) {
    _highlightAndApply(card);
    setTimeout(function () {
    const modalBox = document.querySelector('.address-modal-box');
    if (modalBox) modalBox.scrollTop = 0;
}, 50);
}

    function openAddressModal() {
    document.getElementById('addressModalOverlay').classList.add('show');
}
    function closeAddressModal() {
    document.getElementById('addressModalOverlay').classList.remove('show');
}

    document.getElementById('btnCloseAddressModal').addEventListener('click', closeAddressModal);
    document.getElementById('addressModalOverlay').addEventListener('click', function (e) {
    if (e.target === this) closeAddressModal();
});

    const btnOpen = document.getElementById('btnOpenAddressModal');
    if (btnOpen) btnOpen.addEventListener('click', openAddressModal);

    document.getElementById('toggleNewAddressForm').addEventListener('click', function () {
    const form = document.getElementById('newAddressForm');
    form.classList.toggle('show');
    this.querySelector('i').className = form.classList.contains('show') ? 'fa-solid fa-minus' : 'fa-solid fa-plus';
});

    fetch('https://provinces.open-api.vn/api/')
    .then(r => r.json())
    .then(data => {
    let html = '<option value="">Chọn Tỉnh/Thành phố*</option>';
    data.forEach(item => {
    html += '<option value="' + item.code + '|' + item.name + '">' + item.name + '</option>';
});
    document.getElementById('newProvince').innerHTML = html;
})
    .catch(err => console.error('Lỗi tải tỉnh/thành:', err));

    document.getElementById('newProvince').addEventListener('change', function () {
    const code = this.value ? this.value.split('|')[0] : null;
    const districtSel = document.getElementById('newDistrict');
    const wardSel = document.getElementById('newWard');
    districtSel.innerHTML = '<option value="">Chọn Quận/Huyện*</option>';
    wardSel.innerHTML = '<option value="">Chọn Phường/Xã*</option>';
    if (!code) return;
    fetch('https://provinces.open-api.vn/api/p/' + code + '?depth=2')
    .then(r => r.json())
    .then(data => {
    let html = '<option value="">Chọn Quận/Huyện*</option>';
    (data.districts || []).forEach(d => {
    html += '<option value="' + d.code + '|' + d.name + '">' + d.name + '</option>';
});
    districtSel.innerHTML = html;
})
    .catch(err => console.error('Lỗi tải quận/huyện:', err));
});

    document.getElementById('newDistrict').addEventListener('change', function () {
    const code = this.value ? this.value.split('|')[0] : null;
    const wardSel = document.getElementById('newWard');
    wardSel.innerHTML = '<option value="">Chọn Phường/Xã*</option>';
    if (!code) return;
    fetch('https://provinces.open-api.vn/api/d/' + code + '?depth=2')
    .then(r => r.json())
    .then(data => {
    let html = '<option value="">Chọn Phường/Xã*</option>';
    (data.wards || []).forEach(w => {
    html += '<option value="' + w.code + '|' + w.name + '">' + w.name + '</option>';
});
    wardSel.innerHTML = html;
})
    .catch(err => console.error('Lỗi tải phường/xã:', err));
});

    document.getElementById('newAddressForm').addEventListener('submit', function (e) {
    e.preventDefault();

    const form    = this;
    const saveBtn = form.querySelector('.btn-save-new-address');
    const errBox  = form.querySelector('.ajax-error');
    if (errBox) errBox.remove();

    const provinceVal = form.querySelector('[name="province"]').value;
    const districtVal = form.querySelector('[name="district"]').value;
    const wardVal     = form.querySelector('[name="ward"]').value;
    if (!provinceVal || !districtVal || !wardVal) {
    showFormError(form, 'Vui lòng chọn đầy đủ Tỉnh/Thành phố, Quận/Huyện và Phường/Xã.');
    return;
}

    saveBtn.disabled = true;
    saveBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang lưu...';

    const params = new URLSearchParams();
    new FormData(form).forEach((val, key) => params.append(key, val));

    fetch((window.CONTEXT_PATH || '') + '/account-address', {
    method: 'POST',
    headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
},
    body: params.toString()
})
    .then(r => r.json())
    .then(json => {
    saveBtn.disabled = false;
    saveBtn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Lưu địa chỉ';

    if (!json.success) {
    showFormError(form, json.error || 'Có lỗi xảy ra, vui lòng thử lại.');
    return;
}

    const cardList = document.getElementById('modalAddressCardList');
    if (!cardList.querySelector('.address-list-title')) {
    const title = document.createElement('div');
    title.className = 'address-list-title';
    title.textContent = 'Chọn địa chỉ';
    cardList.insertBefore(title, cardList.firstChild);
}

    const titleEl = cardList.querySelector('.address-list-title');
    const newCard = buildAddressCard(json);
    if (titleEl) {
    titleEl.insertAdjacentElement('afterend', newCard);
} else {
    cardList.insertBefore(newCard, cardList.firstChild);
}

    form.classList.remove('show');
    form.reset();
    document.getElementById('newDistrict').innerHTML = '<option value="">Chọn Quận/Huyện*</option>';
    document.getElementById('newWard').innerHTML = '<option value="">Chọn Phường/Xã*</option>';
    document.getElementById('toggleNewAddressForm').querySelector('i').className = 'fa-solid fa-plus';

    applyNewCard(newCard);
})
    .catch(() => {
    saveBtn.disabled = false;
    saveBtn.innerHTML = '<i class="fa-solid fa-floppy-disk"></i> Lưu địa chỉ';
    showFormError(form, 'Không thể kết nối, vui lòng thử lại.');
});
});

    function showFormError(form, msg) {
    const div = document.createElement('div');
    div.className = 'ajax-error';
    div.style.cssText = 'color:#e53935;font-size:13px;margin-bottom:8px;padding:8px 10px;background:#fff0f0;border-radius:6px;border:1px solid #ffc6c6;';
    div.textContent = msg;
    form.insertBefore(div, form.querySelector('.btn-save-new-address'));
}

    function buildAddressCard(addr) {
    const card = document.createElement('div');
    card.className = 'address-card';
    card.dataset.id          = addr.id;
    card.dataset.fullname    = addr.fullName;
    card.dataset.phone       = addr.phone;
    card.dataset.fullAddress = addr.fullAddress;
    card.dataset.ward        = addr.ward;
    card.dataset.district    = addr.district;
    card.dataset.province    = addr.province;
    card.dataset.default     = addr.isDefault ? 'true' : 'false';
    card.onclick = function () { selectAddress(this); };

    const labelHtml   = addr.label ? '<span class="addr-label">' + escHtml(addr.label) + '</span>' : '';
    const defaultHtml = addr.isDefault ? '<span class="addr-default-badge">Mặc định</span>' : '';
    card.innerHTML =
    '<div class="addr-name-phone">'
    +   labelHtml + escHtml(addr.fullName) + ' &nbsp;|&nbsp; ' + escHtml(addr.phone)
    +   defaultHtml
    + '</div>'
    + '<div class="addr-detail">' + escHtml(addr.fullAddress) + '</div>'
    + '<input type="radio" class="addr-radio" name="addrRadio" value="' + addr.id + '">';
    return card;
}

    function escHtml(s) {
    return (s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}

    function updateShippingFee(addressId) {
    if (!addressId) return;

    const shippingDisplay = document.getElementById('shippingFeeDisplay');
    const payableDisplay = document.getElementById('payableAmountDisplay');
    const footerDisplay = document.getElementById('footerPayableAmount');
    const hiddenShipping = document.getElementById('form-shipping-fee');
    const submitBtn = document.querySelector('#checkoutForm button[type="submit"]');

    if (shippingDisplay) shippingDisplay.textContent = 'Đang tính...';
    if (submitBtn) submitBtn.disabled = true;

    const params = new URLSearchParams();
    params.append('addressId', addressId);
    document.querySelectorAll('#checkoutForm input[name="productIds"]').forEach(input => {
    params.append('productIds', input.value);
});

    fetch((window.CONTEXT_PATH || '') + '/api/shipping/fee', {
    method: 'POST',
    headers: {
    'X-Requested-With': 'XMLHttpRequest',
    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
},
    body: params.toString()
})
    .then(r => r.json())
    .then(json => {
    if (!json.success) {
    if (shippingDisplay) shippingDisplay.textContent = json.message || 'Không tính được phí GHN';
    if (hiddenShipping) hiddenShipping.value = '0';
    return;
}

    const shippingFee = Number(json.shippingFee || 0);
    const totalAmount = Number(json.totalAmount || 0);
    if (hiddenShipping) hiddenShipping.value = shippingFee;
    if (shippingDisplay) shippingDisplay.textContent = shippingFee === 0 ? 'Miễn phí' : formatCurrency(shippingFee);
    if (payableDisplay) payableDisplay.textContent = formatCurrency(totalAmount);
    if (footerDisplay) footerDisplay.textContent = formatCurrency(totalAmount);
})
    .catch(() => {
    if (shippingDisplay) shippingDisplay.textContent = 'Không tính được phí GHN';
    if (hiddenShipping) hiddenShipping.value = '0';
})
    .finally(() => {
    if (submitBtn) submitBtn.disabled = false;
});
}

    function formatCurrency(value) {
    return Math.round(Number(value || 0)).toLocaleString('vi-VN') + '₫';
}

    const checkoutForm = document.getElementById('checkoutForm');
    checkoutForm.addEventListener('submit', function (event) {
    const phone = document.getElementById('phone');
    const email = this.querySelector('input[type="email"]');

    const phoneRegex = /^(03|05|07|08|09)[0-9]{8}$/;
    if (!phoneRegex.test(phone.value)) {
    alert('Số điện thoại không hợp lệ! Phải có 10 số và đúng đầu số nhà mạng.');
    phone.focus();
    event.preventDefault();
    return false;
}

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.value)) {
    alert('Định dạng email không đúng!');
    email.focus();
    event.preventDefault();
    return false;
}

    const addrVal = document.getElementById('form-address').value;
    if (!addrVal || addrVal.trim() === '') {
    alert('Vui lòng chọn hoặc thêm địa chỉ nhận hàng trước khi đặt hàng.');
    event.preventDefault();
    return false;
}

    const submitBtn = this.querySelector('button[type="submit"]');
    if (submitBtn) submitBtn.classList.add('btn-loading');
    const overlay = document.getElementById('loading-overlay');
    const textEl  = document.getElementById('loading-text');
    const t = setTimeout(function () {
    if (textEl)  textEl.textContent = 'Đang xử lý đơn hàng...';
    if (overlay) overlay.classList.add('active');
}, 400);
    window.addEventListener('pagehide', function () { clearTimeout(t); }, { once: true });
});

    window.addEventListener('pageshow', function (e) {
    if (e.persisted) {
    const overlay = document.getElementById('loading-overlay');
    if (overlay) overlay.classList.remove('active');
    document.querySelectorAll('.btn-loading').forEach(function (btn) { btn.classList.remove('btn-loading'); });
}
});

    const urlParams = new URLSearchParams(window.location.search);
    const error = urlParams.get('error');
    if (error === 'invalid_format') {
    alert('Thông tin số điện thoại hoặc email không đúng định dạng!');
} else if (error === 'db') {
    alert('Có lỗi xảy ra trong quá trình lưu đơn hàng vào hệ thống. Vui lòng thử lại!');
}
