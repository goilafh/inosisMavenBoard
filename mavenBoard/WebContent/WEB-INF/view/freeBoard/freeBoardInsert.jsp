<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>Insert title here</title>
</head>
<script language="javascript">
function writeCheck() {

	var f = document.freeboardForm;

	if(f.name.value == "" && f.title.value == ""){
		alert("이름, 제목을 입력하세요");
		return false;
	}
	else if(f.name.value == "" || f.title.value == ""){
		if(f.name.value == ""){
			alert("이름을 입력하세요");
			return false;
		}else{
			alert("제목을 입력하세요");
			return false;
		}
	}else{
		areYouSure();
		return false;
	}
}

function areYouSure(){	
	var f = document.freeboardForm;
	
	if(confirm("작성하시겠습니까?")){
		f.submit();
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

	<form id="form" name="freeboardForm" action="./freeBoardInsertPro.ino">
		<div style="width: 150px; float: left;">이름 :</div>
		<div style="width: 500px; float: left;" align="left">
			<input type="text" name="name" />
		</div>

		<div style="width: 150px; float: left;">제목 :</div>
		
		<div style="width: 500px; float: left;" align="left">
			<input type="text" name="title" />
		</div>

		<div style="width: 150px; float: left;">내용 :</div>
		<div style="width: 500px; float: left;" align="left">
			<textarea name="content" rows="25" cols="65"></textarea>
		</div>
		<div align="right">
			<input type="submit" value="글쓰기" onClick="return writeCheck()"> <input type="button"
				value="다시쓰기" onclick="reset()"> <input type="button"
				value="취소" onclick=""> &nbsp;&nbsp;&nbsp;
		</div>
	</form>



</body>
</html>