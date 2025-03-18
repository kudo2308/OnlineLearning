/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
// Cập nhật tổng giá khi chọn/bỏ chọn khóa học
document.querySelectorAll('.course-checkbox').forEach(checkbox => {
    checkbox.addEventListener('change', updateTotal);
});

function updateTotal() {
    let total = 0;
    document.querySelectorAll('.course-checkbox:checked').forEach(checkbox => {
        total += parseInt(checkbox.getAttribute('data-price'));
    });

    document.getElementById('total-price').innerText = `₫${total.toLocaleString()}`;
}

function checkout() {
    let selectedCheckboxes = document.querySelectorAll('.course-checkbox:checked');
    if (selectedCheckboxes.length === 0) {
        alert('Please select at least one product');
        return;
    }

    let form = document.createElement('form');
    form.method = 'post';
    form.action = 'payment';

    let total = 0;
    selectedCheckboxes.forEach(function(checkbox, index) {
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

    let totalInput = document.createElement('input');
    totalInput.type = 'hidden';
    totalInput.name = 'total';
    totalInput.value = total;
    form.appendChild(totalInput);

    document.body.appendChild(form);
    form.submit();
}