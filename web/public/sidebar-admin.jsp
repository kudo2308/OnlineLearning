<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="ttr-sidebar">
    <div class="ttr-sidebar-wrapper content-scroll">
        <!-- side menu logo start -->
        <div class="ttr-sidebar-logo">
            <a href="#"><img alt="" src="assets/images/logo.png" width="122" height="27"></a>
            <div class="ttr-sidebar-toggle-button">
                <i class="ti-arrow-left"></i>
            </div>
        </div>
        <!-- side menu logo end -->
        <!-- sidebar menu start -->
        <nav class="ttr-sidebar-navi">
            <ul>
                <li>
                    <a href="${pageContext.request.contextPath}/dashboard.jsp" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label">Dashboard</span>
                    </a>
                </li>  
                <li class="ttr-seperate"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/manager-courses" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label">Courses list</span>
                    </a>
                </li>  
                <li class="ttr-seperate"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/UserList" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label">Users List</span>
                    </a>
                </li>  
                <li>
                    <a href="${pageContext.request.contextPath}/admin-registrations" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label">Registration List</span>
                    </a>
                </li>  
                <li>
                    <a href="${pageContext.request.contextPath}/admin-new-registrations" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-bell"></i></span>
                        <span class="ttr-label">New Registrations</span>
                    </a>
                </li>  
                <li class="ttr-seperate"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/transaction-history" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label"> Transaction List </span>
                    </a>
                </li>  

                <li class="ttr-seperate"></li>

                <li>
                    <a href="${pageContext.request.contextPath}/postList" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label"> Post List </span>
                    </a>
                </li>  

                <li class="ttr-seperate"></li>
                
                <li>
                    <a href="${pageContext.request.contextPath}/promotionList" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label">Promotion</span>
                    </a>
                </li>  

                <li class="ttr-seperate"></li>

                <li>
                    <a href="${pageContext.request.contextPath}/couponList" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label"> Coupon </span>
                    </a>
                </li>  

                <li class="ttr-seperate"></li>

                <li>
                    <a href="${pageContext.request.contextPath}/approveRequest" class="ttr-material-button">
                        <span class="ttr-icon"><i class="ti-book"></i></span>
                        <span class="ttr-label"> Blog Request </span>
                    </a>
                </li>  

                <li class="ttr-seperate"></li>
            </ul>

        </nav>

    </div>
</div>