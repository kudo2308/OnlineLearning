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

