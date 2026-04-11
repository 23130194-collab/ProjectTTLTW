let isShowingAllHistory = false;

window.toggleShowAllHistory = function(event) {
    if (event) event.stopPropagation();
    isShowingAllHistory = true;
    window.renderHistory();
};

window.clearAllHistory = function(event) {
    if (event) event.stopPropagation();
    localStorage.removeItem('searchHistory');
    isShowingAllHistory = false;
    window.renderHistory();
};

window.deleteHistoryItem = function(event, keyword) {
    if (event) event.stopPropagation();
    let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
    history = history.filter(item => item.toLowerCase() !== keyword.toLowerCase());
    localStorage.setItem('searchHistory', JSON.stringify(history));
    window.renderHistory();
};

window.renderHistory = function() {
    const suggestionBox = document.getElementById('suggestion-box');
    const searchInput = document.getElementById('searchInput');

    if (!suggestionBox || !searchInput) return;

    const history = JSON.parse(localStorage.getItem('searchHistory') || '[]');

    if (history.length === 0) {
        suggestionBox.style.display = 'none';
        return;
    }

    let html = `
        <div style="padding:10px 16px; display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #eee; background:#f9f9f9;">
            <span style="color:#666; font-size:13px; font-weight:600;">Lịch sử tìm kiếm</span>
            <span onclick="clearAllHistory(event)" style="color:#ff3366; cursor:pointer; font-size:13px;">Xóa tất cả</span>
        </div>`;

    const showCount = isShowingAllHistory ? history.length : Math.min(5, history.length);

    for (let i = 0; i < showCount; i++) {
        const term = history[i];
        html += `
            <div class="suggestion-item history-item" data-term="${term}">
                <span>${term}</span>
                <span class="delete-btn" onclick="deleteHistoryItem(event, '${term}')">✕</span>
            </div>`;
    }

    if (history.length > 5) {
        if (!isShowingAllHistory) {
            html += `<div class="history-control-btn" onclick="toggleShowAllHistory(event)">
                        Xem tất cả (${history.length})
                     </div>`;
        } else {
            html += `<div class="history-control-btn" onclick="event.stopPropagation(); isShowingAllHistory=false; renderHistory();">
                        Thu gọn
                     </div>`;
        }
    }

    suggestionBox.innerHTML = html;
    suggestionBox.style.display = 'block';

    suggestionBox.querySelectorAll('.history-item').forEach(item => {
        item.onclick = function(e) {
            if (e.target.classList.contains('delete-btn')) return;
            searchInput.value = this.getAttribute('data-term');
            suggestionBox.style.display = 'none';
            document.getElementById('searchForm').submit();
        };
    });
};

document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.getElementById('searchInput');
    const suggestionBox = document.getElementById('suggestion-box');
    const searchForm = document.getElementById('searchForm');
    const CP = window.CONTEXT_PATH || '';

    searchInput.addEventListener('focus', function() {
        if (this.value.trim() === '') {
            isShowingAllHistory = false;
            window.renderHistory();
        }
    });

    searchInput.addEventListener('input', function () {
        const keyword = this.value.trim();
        if (keyword.length < 2) {
            if (keyword === '') {
                isShowingAllHistory = false;
                window.renderHistory();
            } else {
                suggestionBox.style.display = 'none';
            }
            return;
        }

        fetch(CP + '/search-suggestions?keyword=' + encodeURIComponent(keyword))
            .then(res => res.json())
            .then(data => {
                if (!data || data.length === 0) {
                    suggestionBox.style.display = 'none';
                    return;
                }
                let html = '';
                data.forEach(item => {
                    html += `<div class="suggestion-item prod-item" data-id="${item.id}">${item.name}</div>`;
                });
                suggestionBox.innerHTML = html;
                suggestionBox.style.display = 'block';

                suggestionBox.querySelectorAll('.prod-item').forEach(el => {
                    el.onclick = function() {
                        window.location.href = CP + '/product-detail?id=' + this.getAttribute('data-id');
                    };
                });
            })
            .catch(err => console.error(err));
    });

    searchForm.addEventListener('submit', function() {
        const kw = searchInput.value.trim();
        if (kw) {
            let history = JSON.parse(localStorage.getItem('searchHistory') || '[]');
            history = history.filter(item => item.toLowerCase() !== kw.toLowerCase());
            history.unshift(kw);
            localStorage.setItem('searchHistory', JSON.stringify(history.slice(0, 20)));
        }
    });

    document.addEventListener('click', function(e) {
        if (!searchForm.contains(e.target)) {
            suggestionBox.style.display = 'none';
        }
    });
});