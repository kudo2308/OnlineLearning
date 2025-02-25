document.addEventListener("DOMContentLoaded", function () {
  const modal = document.getElementById("popup");
  const openModal = document.getElementById("openModal");
  const closeModal = document.getElementById("closeModal");
  const closeSpan = document.querySelector(".close");

  // Mở pop-up
  openModal.addEventListener("click", function () {
      modal.style.display = "flex";
  });

  // Đóng pop-up khi nhấn vào dấu "X"
  closeSpan.addEventListener("click", function () {
      modal.style.display = "none";
  });

  // Đóng pop-up khi nhấn ra ngoài
  window.addEventListener("click", function (event) {
      if (event.target === modal) {
          modal.style.display = "none";
      }
  });
});
