<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="icon" href="<c:url value='/resources/template_img/favicon.png' />" type="image/png">
<!--     Bootstrap CSS -->
<link rel="stylesheet" href="<c:url value='/resources/template_css/bootstrap.min.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_vendors/linericon/style.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_css/font-awesome.min.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_css/magnific-popup.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_vendors/owl-carousel/owl.carousel.min.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_vendors/lightbox/simpleLightbox.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_vendors/nice-select/css/nice-select.css' />">
<link rel="stylesheet" href="<c:url value='/resources/template_vendors/animate-css/animate.css' />">
<!--     main css -->
<link rel="stylesheet" href="<c:url value='/resources/template_css/style.css' />">
<script src="<c:url value='/resources/js/jquery-3.4.1.js'/>"></script> 
<script src="<c:url value='/resources/js/popper.min.js' />"></script>
<script src="<c:url value='/resources/template_js/bootstrap.min.js' />"></script>
<script>
        $(function (){
            $('#msgButton').on('click',function(){
                var hiddenVal = $('input.msg_location').val();
	        	openUploadMessenger(hiddenVal);
            })
        })
        function openUploadMessenger(hiddenVal) {
            open('<c:url value="/msg/msg_start?' + hiddenVal + '"/>',
                    "_blank",
                    "width=1000, height=800");   
        }
    </script>
</head>
<body>
<!--================ Start Header Menu Area =================-->
    <header class="header_area">
        <div class="main_menu">
            <nav class="navbar navbar-expand-lg navbar-light">
                <div class="container">
                    <!-- Brand and toggle get grouped for better mobile display -->
                    <a class="navbar-brand logo_h" href="<c:url value="/"/>"><img src="${pageContext.request.contextPath}/resources/template_img/logo.png" alt=""></a>
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                     aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <!-- Collect the nav links, forms, and other content for toggling -->
                    <div class="collapse navbar-collapse offset" id="navbarSupportedContent">
                        <ul class="nav navbar-nav menu_nav ml-auto">
                            <li class="nav-item active"><a class="nav-link" href="<c:url value="/"/>">???????????????</a></li>
                            <li class="nav-item submenu dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                                 aria-expanded="false">????????????</a>
                                <ul class="dropdown-menu">
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/personality/personalityInsight'/>">?????? ??????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/personality/keywordTimeline'/>">??????????????? ????????????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/analysis/company'/>">?????? ??????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/analysis/entrysheet'/>">??????????????? ??????</a></li>
                                </ul>
                            </li>
                            <li class="nav-item submenu dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                                 aria-expanded="false">?????????</a>
                                <ul class="dropdown-menu">
                                    <li class="nav-item"><a class="nav-link" href="#" data-toggle="modal" data-target="#inputTitleHeader">??? ?????????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value="/resume/resumeList"/>">????????? ??????</a></li>
                                </ul>
                            </li>
                            <li class="nav-item submenu dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                                 aria-expanded="false">?????????</a>
                                <ul class="dropdown-menu">
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/schedule/scheduleForm'/>">????????????</a></li>
                                </ul>
                            </li>
                            <li class="nav-item submenu dropdown">
                                <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true"
                                 aria-expanded="false">????????????</a>
                                <ul class="dropdown-menu">
<%--                                     <li class="nav-item"><a class="nav-link" href="<c:url value='/interview/getintro'/>">????????????</a></li> --%>
                                    <li class="nav-item"><a class="nav-link" href="http://localhost:8888/zipangu/interview/getintro">????????????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/interview/getinterviewResult'/>">????????????</a></li>
                                </ul>
                            </li>
                            <c:choose>
                                <c:when test="${sessionScope.userID == null}">
<%--  									<li class="nav-item"><a class="nav-link" href="<c:url value='/member/signupForm' />">????????????</a></li> --%>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/member/loginForm'/>">?????????</a></li>
                                </c:when>
                                <c:when test="${sessionScope.userID != null}">
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/member/myPage'/>">???????????????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="<c:url value='/member/logout'/>">????????????</a></li>
                                    <li class="nav-item"><a class="nav-link" href="#">${sessionScope.userID}??? ???????????????.</a></li>
                                </c:when>
                            </c:choose>
                        </ul>
                        <ul class="nav navbar-nav ml-auto">
                            <div class="social-icons d-flex align-items-center">
                            <section id="msgSection">
                                <c:choose>
                                    <c:when test="${sessionScope.authority=='2'}">
                                        <input type="hidden" class="msg_location" value="mentee_id=${sessionScope.userID}&mentor_id=Administrator">
                                    </c:when>
                                    <c:when test="${sessionScope.authority=='1'}">
                                        <input type="hidden" class="msg_location" value="mentee_id=Administrator&mentor_id=${sessionScope.userID}">
                                    </c:when>
                                </c:choose>
                                <button id="msgButton">
                                    <i id="msgFa"class="fa fa-comments-o"></i>
                                    <label id="msgLabel" class="col-form-label" style="font-size: 10px;">?????????/????????????</label>
                                </button>
                                </a>
                            </section>
                            </div>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    </header>
    <div class="modal" id="inputTitleHeader">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">????????? ????????? ????????? ?????????.</h4>
					<button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
				<form action="<c:url value='/resume/resumeForm' />" method="get">
					<div class="modal-body">
						<input class="form-control" type="text" name="title" required>
						<input type="hidden" name="resume_num" value="-1">
					</div>
					<div class="modal-footer">
						<button type="submit" class="btn btn-primary">??????</button>
						<button type="button" class="btn btn-danger" data-dismiss="modal">??????</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>