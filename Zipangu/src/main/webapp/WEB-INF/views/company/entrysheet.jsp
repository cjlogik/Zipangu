<jsp:include page="../include/header.jsp"></jsp:include>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% request.setCharacterEncoding("utf-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<title>Zipangu</title>

<script src="${pageContext.request.contextPath}/resources/js/jquery-3.4.1.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script>

var bookmarkCount;
var bookmarkList;
var totalEntrysheet;
var typeResult;

$(function(){
	getBookmarkCount();
	bookmarkList = getBookmarkList();
	if(bookmarkList.length == 0) {
		$('#loadingDiv').hide();
		$('#resultDiv').attr('hidden','hidden');
		$('#resultDivIfnoResult').removeAttr('hidden','hidden');
		$('#resultDivIfResult').hide();
		return;
	}
	getTotalEntrysheet();
})

function getBookmarkCount() {
	$.ajax({
        url : "/zipangu/analysis/getBookmarkCount",
        type: "post",
        async: false,
        success: function(data){
            bookmarkCount = data;
        },
        error: function(e){
            console.log(e);
        }
	});
}
function getBookmarkList(){
	var result;
	$.ajax({
        url : "/zipangu/analysis/getBookmarkList",
        type: "post",
        async: false,
        success: function(data){
        	result = data;
        },
        error: function(e){
            console.log(e);
        }
    });
    return result;
}
function getTotalEntrysheet() {
    $.ajax({
//         url : "http://192.168.0.8:5000/getTotalEntrysheet",
        url : "http://10.10.17.117:5000/getTotalEntrysheet",
        type : "post",
        success: function(data){
            totalEntrysheet = data;
        }, error: function(e){
            console.log(e);
        },beforeSend: function(){
            $('#loadingDiv').show();
            $('#resultDiv').hide();
            $('#resultDiv2').hide();
        },complete: function(){
        	$('#loadingDiv').hide();
            $('#resultDiv').show();
            $('#resultDiv2').show();
            
            google.charts.load("current", {packages:["corechart"]});
            google.charts.setOnLoadCallback(drawChart);
            
            setNavUl(bookmarkCount);
            setEntrysheet();
            $('#ali0').trigger('click');
        }
    });
}
function drawChart(){
	var chartData = [];
	var totalCount = 0;
	$.each(bookmarkCount, function(index, item){
		var temp = [item.type, item.count];
		totalCount += item.count;
		chartData.push(temp);
	});
	var data = new google.visualization.DataTable();
	data.addColumn('string','??????');
	data.addColumn('number','?????????');
    data.addRows(chartData);
    
	var options = {
			title : '????????? ???????????? ??? : ' + totalCount + '???',
			width : 600,
			height : 400,
			is3D : true, 
		};
	var chart = new google.visualization.PieChart(document.getElementById('chartDiv'));
    chart.draw(data, options);
}

function kuromoji(typeItem) {
    var str = '';
    var temp = [];
    $.ajax({
        url : "/zipangu/analysis/kuromoji",
        type : "post",
        data : {
            type : typeItem
        },
        async: false,
        success: function(data){
            data = $.unique(data.split(' '));
            temp.push(data);
        }, error: function(e){
            console.log(e);
        }
    })
    return temp;
}

function setNavUl(data) {
	var liStr = '';
	var divStr = '';
	$.each(data, function(index, item){
		if(index == 0){
			liStr += '<li class="nav-item"><a id="ali'+ index + '" class="nav-link active show" data-toggle="tab" href="#li' + index +'">';
			liStr += item.type;
			liStr += '</a></li>';
		} else {
			liStr += '<li class="nav-item"><a id="ali'+ index + '" class="nav-link" data-toggle="tab" href="#li' + index +'">';
			liStr += item.type;
			liStr += '</a></li>';
		}
	});
	$('ul.nav-tabs').html(liStr);
}
function setEntrysheet(){
	$('a.nav-link').on('click', function(){
		$('#indexNum').val(1);
		var type = $(this).text();
		var title = type;
	    if(type.includes('???')){
	    	type = type.substring(type.indexOf('???') + 1, type.indexOf('???'));
		}
		var type_arr = kuromoji(type);
		var index = $('#indexNum').val()-1;
		
		typeResult = searchEntrysheet(type_arr[0]);
		$('#indexNum').attr('max', typeResult.length);
		if(typeResult.length != 0){
			$('#resultDivIfResult').show();
			$('#typeResultLength').html(typeResult.length);
			$('#table').html(entrysheetOutput(index));
		} else {
			$('#resultDivIfResult').hide();
			$('#table').html('<tr><th>?????? ????????? ????????????.</th></tr>');
		}
		var tbodyStr = bookmarkOutput(type);
		$('#bookmark_tbody').html(tbodyStr);
		$('#currentBookmarkTitle').html('???????????? ?????? : ' + title);
	});
}
function searchEntrysheet(type_arr){
	var typeResult = [];
	$.each(type_arr, function(index,item){
		$.each(totalEntrysheet, function(index2, item2){
			if(item2.JOBTYPE.includes(item)) {
				typeResult.push(item2);
			}
		})
	})
	return typeResult;
}
function bookmarkOutput(type) {
    var str = '';
    var num = 1;
    var typeResult = [];
    $.each(bookmarkList, function(index, item){
        if(item.type.indexOf(type) !== -1) {
            typeResult.push(item);
            str += '<tr><td>' + (num++) + '</td>';
            str += '<td><a href="<c:url value="/analysis/deleteBookmark"/>?company_num=' + item.company_num + '">'+ item.coname + '</a></td>';
            str += '<td>' + item.location + '</td>';
            str += '<td>' + item.contact + '</td></tr>';
        }
    });
    return str;
}
function search(){
    var index = $('#indexNum').val()-1;
    $('#table').html(entrysheetOutput(index));
}
function entrysheetOutput(index){
	var str = '';
	
	if(typeResult.length != 0){
		str += '<tr><th>??????</th></tr>';
		str += '<tr><td>' + typeResult[index].COMSIZE + '</th></tr>';
		str += '<tr><th>??????</th></tr>';
	    str += '<tr><td>' + typeResult[index].JOBTYPE + '</th></tr>';
	    str += '<tr><th>??????</th></tr>';
	    str += '<tr><td>' + typeResult[index].COMLOCATION + '</th></tr>';
	    str += '<tr><th>????????????</th></tr>';
	    str += '<tr><td>' + typeResult[index].QUALIFICATION + '</th></tr>';
	    str += '<tr><th>??????/??????</th></tr>';
	    str += '<tr><td>' + typeResult[index].HOBBYNSKILL + '</th></tr>';
	    str += '<tr><th>??????/??????</th></tr>';
	    str += '<tr><td>' + typeResult[index].STUDY + '</th></tr>';
	    str += '<tr><th>PR</th></tr>';
	    str += '<tr><td>' + typeResult[index].PR + '</th></tr>';
	    str += '<tr><th>???????????? ???</th></tr>';
	    str += '<tr><td>' + typeResult[index].ABSORPTION + '</th></tr>';
	    str += '<tr><th>??????</th></tr>';
	    str += '<tr><td>' + typeResult[index].ADVICE + '</th></tr>';
	}
	return str;
}
</script>
</head>
<body>
<!--================Home Banner Area =================-->
    <section class="banner_area">
        <div class="banner_inner overlay d-flex align-items-center">
            <div class="container">
                <div class="banner_content text-center">
                    <div class="page_link">
                        <a href="<c:url value="/"/>">???????????????
                        </a>
                        <a href="<c:url value="/analysis/company"/>">??????????????? ??????</a>
                    </div>
                    <h2>??????????????? ??????</h2>
                    <br>
                    <p style="color: white;"></p>
                </div>
            </div>
        </div>
    </section>
<!--================End Home Banner Area =================-->
	<div class="container-fluid">
	    <br>
	    <div class="row justify-content-center align-items-center">
	        <div class="card-body col-md-6" align="center">
	            <h1>??????????????? ??????</h1>
	            <hr>
	            <p>${sessionScope.userID}?????? ???????????? ????????? ????????????, Zipangu??? ????????? 587?????? ????????? ??? ??????????????? ????????? ?????? ???????????? ???????????????.</p>
	        </div>
	    </div>
	    <br>
	    <div id="loadingDiv" class="row justify-content-center align-items-center" style="padding-top: 100px; padding-bottom: 200px;">
	       <img src="<c:url value="/resources/img/loading.gif"/>">
	    </div>
		<div class="row" id="resultDiv">
			<div class="container">
				<div class="col-md-6" style="float: right;">
				    <div class="card-body">
			            <h4 class="card-title">???????????? ?????? ??????</h4>
			            <hr>
			            <div id="chartDiv"></div>
			        </div>
				</div>
			    <div class="col-md-6">
			       <div class="card-body">
		                <h4 class="card-title" id="currentBookmarkTitle">???????????? ??????</h4>
		                <hr>
		                <p>???????????? ????????? ????????? ?????? ?????? ???????????? ??????????????????.</p>
		                <div class="card-body pre-scrollable">
		                <table class="table table-hover table-responsive" id="testTable">
		                    <thead>
		                        <tr>
		                            <th style="width: 10%;">#</th>
		                            <th style="width: 20%;">?????????</th>
		                            <th style="width: 15%;">??????</th>
		                            <th style="width: 50%;">?????????</th>
		                        </tr>
		                    </thead>
		                    <tbody id="bookmark_tbody">
		                    </tbody>
		                </table>
		                </div>
		            </div>
			    </div>
			</div>
		</div>
		<div class="row justify-content-center align-items-center" id="resultDivIfnoResult" hidden="hidden">
		    <div class="jumbotron" align="center">
		        <div class="card-body col-md-9">
	                <h2>????????? ??????????????? ????????????.</h2>
	                <hr>
                </div>
                <div class="row justify-content-center align-items-center">
                    <p>?????? ??????????????? ??????????????????.</p>
                </div>
                <br>
                <a href="<c:url value="/analysis/company"/>" class="genric-btn danger e-large" style="width: 300px; font-size: 15px;">???????????? ???????????? ??????</a>
		    </div>
		</div>
		<div class="row" id="resultDiv2">
		   <div class="container" id="inputContainer">
		       <ul class="nav nav-tabs">
	            </ul>
	            <div class="tab-content">
	               <div id="resultDivIfResult">
	                   <div class="row justify-content-center" style="padding-top: 30px; padding-bottom: 15px;">
	                       <p>??? <span id="typeResultLength"></span>?????? ?????? ?????????????????? ????????????. ??????????????? ?????? ??????????????? ????????? ??????????????????.</p>
	                   </div>
	                   <div class="row justify-content-center" style="padding-bottom: 30px;">
                            <input type="number" id="indexNum" value="1" min="1" class="form-control col-1">
                            <input type="button" class="btn btn-info" value="??????" id="searchBtn" onclick="search();"/>
                       </div>
	               </div>
    	           <table class="table" id="table">
	               </table>
	            </div>
	        </div>
		</div>
	</div>
<c:choose>
    <c:when test="${requestScope.deleteResult == true}">
        <script>
            alert('??????????????? ?????????????????????.');
        </script>
    </c:when>
    <c:when test="${requestScope.deleteResult == false}">
        <script>
        alert('??????????????? ????????? ?????????????????????.');
        </script>
    </c:when>
</c:choose>
</body>
</html>
<jsp:include page="../include/footer.jsp"></jsp:include>
