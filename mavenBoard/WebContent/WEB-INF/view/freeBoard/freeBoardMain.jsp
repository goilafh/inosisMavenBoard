<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

</head>

<body>

	<div>
		<h1>자유게시판</h1>

	</div>

	<div style="width: 650px;" align="right">
		<form name="searchForm" method="post" action="./main2.ino">
			<!-- 년도월일 검색조건 -->
			<input type="text" name="searchD1"
				onkeyup="auto_date_format(event, this)"
				onkeypress="auto_date_format(event, this)"
				value="${freeBoard.searchD1 }" maxlength="10" style="width: 100px;">
			~ <input type="text" name="searchD2"
				onkeyup="auto_date_format(event, this)"
				onkeypress="auto_date_format(event, this)"
				value="${freeBoard.searchD2 }" maxlength="10" style="width: 100px;">
			<!-- 검색조건 -->
			<select name="searchType">
				<c:forEach items="${freeBoard.sList}" var="sList">
					<c:if test="${sList.CODE == 'COM001' }">
						<option value="${sList.DETAIL_CODE}"
							<c:if test="${sList.DETAIL_CODE eq freeBoard.searchType}"> selected </c:if>>
							${sList.DETAIL_CODE_NAME}</option>
					</c:if>
				</c:forEach>
			</select> <input type="text" name="searchWord" id="searchWord"
				value="${freeBoard.searchWord}">
			<button type="button" onClick="fn_doPage(1)">검색</button>
		</form>
		<a href="./freeBoardInsert.ino">글쓰기</a>
	</div>
	<hr style="width: 600px">

	<!-- 아래는 db리스트 출력 -->
	<div id="listId">
		<c:forEach items="${freeBoard.freeBoardList }" var="dto">
			<div style="width: 50px; float: left;">${dto.num }</div>
			<div style="width: 300px; float: left;">
				<a href="./freeBoardDetail.ino?num=${dto.num }">${dto.title }</a>
			</div>
			<div style="width: 150px; float: left;">${dto.name }</div>
			<div style="width: 150px; float: left;">${dto.regdate }</div>
			<hr style="width: 600px">
		</c:forEach>
	</div>
	<!--./oooo.ino?key=value&key=value&key=value  -->
	<!--RequeseParam 이 변수로 key를 받는것  -->
	<div id="pageId">
		<!-- 처음페이지로 이동 : 현재 페이지가 1보다 크면 [처음] 하이퍼링크를 화면에 출력 -->
		<c:if test="${freeBoard.pageUtil.curBlock > 1}">
			<a href="./main.ino?curPage=1">[처음]</a>
		</c:if>
		<!-- 이전페이지 블록으로 이동 : 현재 페이지 블럭이 1보다 크면 [이전] 하이퍼링크를 화면에 출력-->
		<c:if test="${freeBoard.pageUtil.curBlock > 1 }">
			<a href="./main.ino?curPage=${freeBoard.pageUtil.prevPage}">[이전]</a>
		</c:if>
		<!-- 하나의 블럭에서 반복문 수행 시작페이지 부터 끝페이지까지 -->
		<c:forEach var="num" begin="${freeBoard.pageUtil.blockBegin }"
			end="${freeBoard.pageUtil.blockEnd }">
			<!-- 현재페이지이면 하이퍼링크 제거 -->
			<c:choose>
				<c:when test="${num == freeBoard.pageUtil.curPage }">
					<span style="color: red">${num }</span>
				</c:when>
				<c:otherwise>
					<a href="./main.ino?curPage=${num}">${num }</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<!-- 다음페이지 블록으로 이동 : 현재 페이지 블럭이 전체 페이지 블럭보다 작거나 같으면 [다음] 하이퍼링크를 화면에 출력-->
		<c:if
			test="${freeBoard.pageUtil.curBlock <= freeBoard.pageUtil.totBlock }">
			<a href="./main.ino?curPage=${freeBoard.pageUtil.nextPage}">[다음]</a>
		</c:if>
		<!-- 끝페이지 블록으로 이동 : 현재 페이지가 전체 페이지보다 작거나 같으면 [끝] 하이퍼링크를 화면에 출력-->
		<c:if
			test="${freeBoard.pageUtil.curPage < freeBoard.pageUtil.totPage }">
			<a href="./main.ino?curPage=${freeBoard.pageUtil.totPage}">[끝]</a>
		</c:if>
	</div>
	<script type="text/javascript">
		function fn_doPage(curPage) {
			
			var data = $('[name=searchForm]').serialize();
			data += "&curPage="+curPage; //***
			
			/* 정규표현식 숫자만 */
			var regexp = /^[0-9]*$/;
			
			if(searchForm.searchD1.value != "" || searchForm.searchD2.value !=""){
				if(searchForm.searchD1.value > searchForm.searchD2.value){
					alert("시작날짜가 작아야합니다");
					searchForm.searchD1.focus();
					return false;
				}
			}else{
				if(searchForm.searchWord.value == ""){	
					alert("검색어를 입력하세요");
					searchForm.searchWord.focus();
					return false;
				}else{
					if(searchForm.searchType.value == "DCODE001"){
						var searchWordValue = searchForm.searchWord.value;
						if(!regexp.test(searchWordValue)){
							alert("글 번호 검색입니다 번호로 검색해주세요");
							searchForm.searchWord.value = "";
							searchForm.searchWord.focus();
							return false;
						}	
					}
				}
			}
			
			
			$.ajax({
				type : "POST",
				url : "main2.ino",
				data : data,
				success : function(sendData) {
					$("#listId").empty();
					$("#pageId").empty();
					var a ='';
					var b ='';
					$.each(sendData.freeBoardList, function(key, value){
						a='';
						a += '<div style="width: 50px; float: left;">'+value.num+'</div>';
						a += '<div style="width: 300px; float: left;">'+
						 '<a href="./freeBoardDetail.ino?num='+value.num+ '">'+value.title+'</a></div>';
						a += '<div style="width: 150px; float: left;">'+value.name+'</div>';
						a += '<div style="width: 150px; float: left;">'+value.regdate+'</div>';
						a += '<hr style="width: 600px">';
						
						$("#listId").append(a);
					});
					
					if(sendData.pageUtil.curPage > 1){
						b += '<a href="javascript:fn_doPage(1)">[처음]</a>';
					};
					if(sendData.pageUtil.curBlock > 1){
						b += '<a href="javascript:fn_doPage('+sendData.pageUtil.prevPage+')">'
					};
					for(var bBegin = sendData.pageUtil.blockBegin; bBegin <= sendData.pageUtil.blockEnd; bBegin++){
						if(bBegin == sendData.pageUtil.curPage){
							b += '<span style = "color : red">' + bBegin + '</span>&nbsp';
						}else{
							b += '<a href="javascript:fn_doPage('+bBegin+')">' + bBegin + '</a>&nbsp';
						};
					};
					if(sendData.pageUtil.curBlock <= sendData.pageUtil.totBlock){
						b += '<a href="javascript:fn_doPage('+sendData.pageUtil.nextPage+')">[다음]</a>';
					};
					if(sendData.pageUtil.curPage < sendData.pageUtil.totPage){
						b += '<a href="javascript:fn_doPage('+sendData.pageUtil.totPage+')">[끝]</a>';
					};
					$("#pageId").append(b);
				}
			});
		};

		function auto_date_format(e, oThis) {

			var num_arr = [ 97, 98, 99, 100, 101, 102, 103, 104, 105, 96, 48,
					49, 50, 51, 52, 53, 54, 55, 56, 57 ]

			var key_code = (e.which) ? e.which : e.keyCode;
			if (num_arr.indexOf(Number(key_code)) != -1) {

				var len = oThis.value.length;
				if (len == 4)
					oThis.value += "-";
				if (len == 7)
					oThis.value += "-";

			}

		}
	</script>
</body>
</html>