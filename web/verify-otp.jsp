<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="./assets/css/otp.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    </head>
    <body>
        <div class="wrapper">
            <h1>Verify Email</h1>
            <hr>
            <h2>Keep this window open and check your email</h2>
            <p>We have sent a 6-digit code to your email address. Verify your account by pasting the code below. Be sure to check your Spam folder</p>
            <div class="container">
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group text-center">
                            <div class="form-group-input otp-form-group mb-3">
                                <input id="otp-1" name="otp" type="text" minlength="1" maxlength="1" class="form-control otp-inputbar" autocomplete="off">
                                <input id="otp-2" name="otp" type="text" minlength="1" maxlength="1" class="form-control otp-inputbar" autocomplete="off">
                                <input id="otp-3" name="otp" type="text" minlength="1" maxlength="1" class="form-control otp-inputbar" autocomplete="off">
                                <input id="otp-4" name="otp" type="text" minlength="1" maxlength="1" class="form-control otp-inputbar" autocomplete="off">
                                <input id="otp-5" name="otp" type="text" minlength="1" maxlength="1" class="form-control otp-inputbar" autocomplete="off">
                                <input id="otp-6" name="otp" type="text" minlength="1" maxlength="1" class="form-control otp-inputbar" autocomplete="off">
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div id="error-message" class="error-message" style="display:none;">
                <i class="bx bxs-error"></i> 
            </div>
            <div id="error-message-susses" class="error-message-susses" style="display:none;">
                <i class="bx bxs-error"></i> 
            </div>

            <div class="verify">
                <div id="resend-btn" class="resend-btn" style="margin: auto 0">30</div>
                <button id="send-btn" type="button" class="btn">Verify</button>
            </div>
            <div class="register-link">             
                <c:set var="check" value="${requestScope.forget}" />
                <c:if test="${not empty check}">
                    <p>Do you want to change your email? <a href="forget?change=true">Change Email</a></p>  
                </c:if>
                <c:if test="${empty check}">
                    <p>Do you want to change your email? <a href="register?change=true">Change Email</a></p>  
                </c:if>
            </div>
        </div>
    </body>
    <script>
        $(document).ready(function () {
            const otpInputs = document.querySelectorAll(".otp-inputbar");
            // Chuyển input sau khi nhập
            otpInputs.forEach((input, index) => {
                input.addEventListener("input", function () {
                    if (this.value.length === 1 && index < otpInputs.length - 1) {
                        otpInputs[index + 1].focus();
                    }
                });
                // Quay lại input trước nếu xóa (Backspace)
                input.addEventListener("keydown", function (event) {
                    if (event.key === "Backspace" && this.value === "" && index > 0) {
                        otpInputs[index - 1].focus();
                    }
                });
                // Xử lý dán (paste) khi dán OTP
                input.addEventListener("paste", function (event) {
                    event.preventDefault();
                    let pasteData = (event.clipboardData || window.clipboardData).getData("text").trim();
                    if (/^\d{6}$/.test(pasteData)) {
                        otpInputs.forEach((inp, i) => {
                            inp.value = pasteData[i] || "";
                        });
                        otpInputs[otpInputs.length - 1].focus();
                    }
                });
            });
            //Xử lý khi nhấn nút Verify
            let otp = "";
            $('#send-btn').prop('disabled', true).css('opacity', '0.5');
            $('input[name="otp"]').on('input', function () {
                otp = $('input[name="otp"]').map(function () {
                    return this.value;
                }).get().join('');

                // Kiểm tra OTP có 6 ký tự
                if (otp.length === 6) {
                    $('#send-btn').prop('disabled', false).css('opacity', '1');
                } else {
                    $('#send-btn').prop('disabled', true).css('opacity', '0.5');
                }
            });

            $('#send-btn').click(function () {
                // Gửi yêu cầu AJAX để xác minh OTP
                $.ajax({
                    url: "verifyOTP",
                    type: 'POST',
                    data: {otp: otp},
                    dataType: 'json', // Đảm bảo nhận dữ liệu JSON từ server
                    success: function (response) {
                        $("#error-message").hide();
                        $("#error-message-susses").hide();
                        if (response.status === 'error') {
                            $("#error-message").text(response.message).show();
                            setTimeout(function () {
                                $("#error-message").fadeOut();
                            }, 3000);
                        }
                        if (response.status === 'success') {
                            $("#error-message-susses").text(response.message).show();
                            setTimeout(function () {
                                $("#error-message-susses").fadeOut();
                            }, 3000);
                        }
                        if ((response.status === 'redirect')) {
                            window.location.href = response.message + "";
                        }
                        if (response.time !== -1 && response.time !== null) {
                            $('#send-btn').prop('disabled', true).css('opacity', '0.5');
                        }
                    },
                    error: function () {
                        alert("Something went wrong");
                    }
                });
            });
            // Xử lý đếm ngược Resend OTP
            let timeLeft = 30;
            let countdown = null;
            function startCountdown() {
                // Đảm bảo rằng countdown chỉ chạy một lần
                if (countdown) {
                    clearInterval(countdown);
                }

                countdown = setInterval(function () {
                    let resendBtn = $("#resend-btn");
                    if (resendBtn.length) {
                        timeLeft--; // Giảm thời gian
                        resendBtn.text(timeLeft);
                        resendBtn.css("cursor", "not-allowed");
                        resendBtn.prop("disabled", true);
                        if (timeLeft <= 0) {
                            clearInterval(countdown);
                            resendBtn.text("Resend");
                            resendBtn.css("cursor", "pointer");
                            resendBtn.click(function () {
                                // Gửi yêu cầu AJAX để gửi lại OTP
                                $.ajax({
                                    url: "refeshOTP", // Gọi đến servlet 'refeshOTP'
                                    type: 'POST',
                                    dataType: 'json', // Đảm bảo nhận phản hồi dưới dạng JSON
                                    success: function (response) {
                                        $("#error-message").hide();
                                        $("#error-message-susses").hide();
                                        if (response.status === "success") {
                                            $("#error-message-susses").text(response.message).show();
                                            setTimeout(function () {
                                                $("#error-message-susses").fadeOut();
                                            }, 3000);
                                            timeLeft = response.time; // Reset thời gian đếm ngược
                                            startCountdown();
                                        } else if (response.status === 'error') {
                                            $("#error-message").text(response.message).show();
                                            setTimeout(function () {
                                                $("#error-message").fadeOut();
                                            }, 3000);
                                            if (response.time !== -1 && response.time !== null) {
                                                timeLeft = response.time;
                                                startCountdown();
                                            }
                                        } else if ((response.status === 'redirect')) {
                                            window.location.href = "login?error=" + response.message;
                                        }
                                    },
                                    error: function () {
                                        alert("Something went wrong");
                                    }
                                });
                            });
                        }
                    }
                }, 1000); // Đếm ngược mỗi giây
            }
            startCountdown();
        });
    </script>
</html>
