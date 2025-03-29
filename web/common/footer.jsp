<%-- 
    Document   : footer
    Created on : Jan 24, 2025, 11:23:29 PM
    Author     : dohie
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Footer -->
<footer>
    <div class="footer-top">
        <div class="pt-exebar">
            <div class="container">
                <div class="d-flex align-items-stretch">
                    <div class="pt-logo mr-auto">
                        <a href="${pageContext.request.contextPath}/home"><img src="${pageContext.request.contextPath}/assets/images/logo-white.png" alt="Online Learning Logo"/></a>
                    </div>
                    <div class="pt-social-link">
                        <ul class="list-inline m-a0">
                            <li><a href="#" class="btn-link"><i class="fa fa-facebook"></i></a></li>
                            <li><a href="#" class="btn-link"><i class="fa fa-twitter"></i></a></li>
                            <li><a href="#" class="btn-link"><i class="fa fa-linkedin"></i></a></li>
                            <li><a href="#" class="btn-link"><i class="fa fa-instagram"></i></a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                
                <div class="col-12 col-lg-5 col-md-7 col-sm-12">
                    <div class="row">
                        <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                            <div class="widget footer_widget">
                                <h5 class="footer-title">Company</h5>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
                                    
                                </ul>
                            </div>
                        </div>
                        <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                            <div class="widget footer_widget">
                                <h5 class="footer-title">Get In Touch</h5>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                                    <li><a href="${pageContext.request.contextPath}/Blog">Blog</a></li>
                                    
                                </ul>
                            </div>
                        </div>
                        <div class="col-4 col-lg-4 col-md-4 col-sm-4">
                            <div class="widget footer_widget">
                                <h5 class="footer-title">Courses</h5>
                                <ul>
                                    <li><a href="${pageContext.request.contextPath}/CourseSearch">All Courses</a></li>
                                    <li><a href="${pageContext.request.contextPath}/my-courses">My Courses</a></li>
                                   
                                    <li><a href="${pageContext.request.contextPath}/userprofile">Profile</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-lg-3 col-md-5 col-sm-12 footer-col-4">
                    <div class="widget">
                        <h5 class="footer-title">Contact Us</h5>
                        <div class="google-map-container" style="margin-top: 15px; width: 100%; height: 200px; border-radius: 8px; overflow: hidden;">
                            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.482570608979!2d105.52510731476343!3d21.01324998600672!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x313454b32ca5086d%3A0xa3c62e29d8ab37e4!2sFPT%20University!5e0!3m2!1sen!2s!4v1648458193928!5m2!1sen!2s" 
                                    width="100%" height="100%" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
                        </div>
                        <ul class="contact-info">
                            <li><i class="fa fa-map-marker"></i> <a href="https://maps.google.com/?q=FPT+University+Hoa+Lac+High+Tech+Park+Hanoi+Vietnam" target="_blank">FPT University, Hoa Lac High Tech Park, Hanoi, Vietnam</a></li>
                            <li><i class="fa fa-phone"></i> +84 936 751 968</li>
                            <li><i class="fa fa-envelope"></i> <a href="mailto:hieudthe180516@fpt.edu.vn">hieudthe180516@fpt.edu.vn</a></li>
                            <li><i class="fa fa-clock-o"></i> Monday - Friday: 9:00 - 17:00</li>
                        </ul>
                        <!-- Google Maps Embed -->
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm-12 text-center">
                    <p class="m-b0"> <script>document.write(new Date().getFullYear())</script> Online Learning. All rights reserved.</p>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- Footer END -->

<!-- External JavaScripts -->
<script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/popper.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/magnific-popup/magnific-popup.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/counter/waypoints-min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendors/counter/counterup.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/functions.js"></script>
