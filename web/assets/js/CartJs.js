// Biến toàn cục lưu thông tin giảm giá
let discount = 0;
let discountType = "percentage"; // "percentage" hoặc "fixed"

// Khởi tạo khi trang được tải
document.addEventListener('DOMContentLoaded', function() {
    // Lắng nghe sự kiện khi checkbox được chọn
    document.querySelectorAll('.course-checkbox').forEach(checkbox => {
        checkbox.addEventListener('change', updateTotal);
    });
    
    // Khởi tạo tổng giá ban đầu
    updateTotal();
    
    // Ngăn form submit thông thường
    const couponForm = document.getElementById('couponForm');
    if (couponForm) {
        couponForm.addEventListener('submit', function(e) {
            e.preventDefault();
            applyCoupon();
            return false;
        });
    }
    
    // Gán sự kiện click cho nút Apply
    const applyBtn = document.querySelector('.apply-btn');
    if (applyBtn) {
        applyBtn.addEventListener('click', applyCoupon);
    }
});

// Hàm áp dụng mã giảm giá
function applyCoupon() {
    let couponCode = document.getElementById('couponCode').value.trim();
    
    // Kiểm tra xem mã giảm giá có tồn tại không
    if (couponCode) {
        // Gửi yêu cầu tới server để kiểm tra mã giảm giá
        let xhr = new XMLHttpRequest();
        xhr.open("GET", "cart?couponCode=" + encodeURIComponent(couponCode), true);
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                try {
                    let response = JSON.parse(xhr.responseText);
                    console.log("Phản hồi từ server:", response);
                    
                    if (response.success) {
                        // Nếu mã giảm giá hợp lệ
                        discount = parseFloat(response.discount);
                        discountType = response.discountType; // Lưu kiểu giảm giá
                        
                        let message = '';
                        if (discountType === "percentage") {
                            message = 'Áp dụng mã giảm giá thành công: Giảm ' + discount + '%';
                        } else if (discountType === "fixed") {
                            message = 'Áp dụng mã giảm giá thành công: Giảm ₫' + discount.toLocaleString();
                        }
                        
                        alert(message);
                        updateTotal();
                    } else {
                        alert('Mã giảm giá không hợp lệ');
                        discount = 0;
                        discountType = "percentage";
                        updateTotal();
                    }
                } catch (e) {
                    console.error("Lỗi khi phân tích phản hồi JSON: ", e);
                    alert('Đã xảy ra lỗi khi xử lý mã giảm giá');
                }
            }
        };
        
        xhr.send();
    } else {
        alert('Vui lòng nhập mã giảm giá.');
    }
    
    return false;
}

// Hàm tính toán và cập nhật tổng giá
function updateTotal() {
    let total = 0;
    
    // Lặp qua các checkbox đã chọn và tính tổng giá trị
    document.querySelectorAll('.course-checkbox:checked').forEach(checkbox => {
        let price = parseInt(checkbox.getAttribute('data-price'));
        total += price;
    });
    
    // Tính giá sau khi giảm dựa vào loại giảm giá
    let discountedPrice = total;
    
    if (discountType === "percentage") {
        // Giảm theo phần trăm
        let discountAmount = (total * discount / 100);
        discountedPrice = total - discountAmount;
    } else if (discountType === "fixed") {
        // Giảm theo số tiền cố định
        discountedPrice = Math.max(0, total - discount); // Đảm bảo giá không âm
    }
    
    // Cập nhật giá trị trên giao diện
    document.querySelectorAll('#total-price').forEach(element => {
        element.innerText = `₫${total.toLocaleString()}`;
    });
    
    document.querySelectorAll('#discounted-price').forEach(element => {
        element.innerText = `₫${discountedPrice.toLocaleString()}`;
    });
}

// Hàm thanh toán
function checkout() {
    let selectedCheckboxes = document.querySelectorAll('.course-checkbox:checked');
    if (selectedCheckboxes.length === 0) {
        alert('Vui lòng chọn ít nhất một khóa học');
        return;
    }
    
    let form = document.createElement('form');
    form.method = 'post';
    form.action = 'payment';
    
    let total = 0;
    selectedCheckboxes.forEach(function (checkbox) {
        let courseId = checkbox.getAttribute('data-course-id');
        let expertId = checkbox.getAttribute('data-expert-id');
        let price = parseInt(checkbox.getAttribute('data-price'));
        total += price;
        
        // Tạo trường ẩn cho mỗi cặp courseId và expertID
        let pairInput = document.createElement('input');
        pairInput.type = 'hidden';
        pairInput.name = 'courseExpertPairs';
        pairInput.value = courseId + ':' + expertId;
        form.appendChild(pairInput);
    });
    
    // Tính toán tổng giá sau khi giảm giá
    let discountedTotal = total;
    
    if (discountType === "percentage") {
        discountedTotal = total - (total * discount / 100);
    } else if (discountType === "fixed") {
        discountedTotal = Math.max(0, total - discount);
    }
    
    let totalInput = document.createElement('input');
    totalInput.type = 'hidden';
    totalInput.name = 'total';
    totalInput.value = Math.round(discountedTotal);
    
    // Thêm thông tin giảm giá
    let discountInput = document.createElement('input');
    discountInput.type = 'hidden';
    discountInput.name = 'discount';
    discountInput.value = discount;
    
    // Thêm thông tin kiểu giảm giá
    let discountTypeInput = document.createElement('input');
    discountTypeInput.type = 'hidden';
    discountTypeInput.name = 'discountType';
    discountTypeInput.value = discountType;
    
    form.appendChild(totalInput);
    form.appendChild(discountInput);
    form.appendChild(discountTypeInput);
    document.body.appendChild(form);
    form.submit();
}