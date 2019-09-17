<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<script>
function modify(){
	if(confirm("수정하시겠습니까?")){
		var form = document.insertForm;
		form.action = "./freeBoardModify.ino";
		form.method="POST";
		form.submit();
		return true;
	}else{
		return false;
	}
}
function delCheck(){
	
	if(confirm("삭제하시겠습니까?")){
		location.href = "./freeBoardDelete.ino?num=${freeBoardDto.num }";
		return true;
	}else{
		return false;
	}
	
}
function canCheck(){
	
	if(confirm("취소하고 메인으로 돌아갑니까?")){
		location.href ="./main.ino";
		return true;
	}else{
		return false;
	}
	
}
	
</script>
<body>

	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width: 650px;" align="right">
		<a href="./main.ino">리스트로</a>
	</div>
	<hr style="width: 600px">

	<form name="insertForm">
		<input type="hidden" name="num" value="${freeBoardDto.num }" />

		<div style="width: 150px; float: left;">이름 :</div>
		<div style="width: 500px; float: left;" align="left">
			<input type="text" name="name" value="${freeBoardDto.name }" readonly />
		</div>

		<div style="width: 150px; float: left;">제목 :</div>
		<div style="width: 500px; float: left;" align="left">
			<input type="text" name="title" value="${freeBoardDto.title }" />
		</div>

		<div style="width: 150px; float: left;">작성날자</div>
		<div style="width: 500px; float: left;" align="left">
			<input type="text" name="regdate" value="${freeBoardDto.regdate }" />
		</div>

		<div style="width: 150px; float: left;">내용 :</div>
		<div style="width: 500px; float: left;" align="left">
			<textarea name="content" rows="25" cols="65">${freeBoardDto.content }</textarea>
		</div>
		<div align="right">
			<input type="button" value="수정" onclick="modify()"> 
			<input type="button" value="삭제" onclick="delCheck()">
				<!--"location.href='./freeBoardDelete.ino?num=${freeBoardDto.num }'">-->

			<input type="button" value="취소" onclick="canCheck()">
			&nbsp;&nbsp;&nbsp;
		</div>

	</form>

</body>
</html>