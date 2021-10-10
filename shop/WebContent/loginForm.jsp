<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// 인증 방어 코드 : 로그인 전에만 페이지 열람 가능
	// session.getAttribute("loginMember") --> null
	if(session.getAttribute("loginMember")!=null) {
		System.out.println("이미 로그인 되어 있습니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
%>
	<div class="container pt-3">
		
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		
		<h1 class="jumbotron">LOGIN</h1>
		
		<form id="loginForm" method="post" action="./loginAction.jsp">
			<table class="table mt-5 w-50">
				<tr>
					<td>ID </td>
					<td><input type="text" id="memberId" name="memberId" class="form-control"></td>
				<tr>
				<tr>
					<td>PASSWORD</td>
					<td><input type="password" id="memberPw" name="memberPw" class="form-control"></td>
				</tr>
			</table>
			<div><button id="loginBtn" type="button" class="btn btn-success">로그인</button></div>
		</form>
	</div>
	
	<script>
		// 엔터키를 클릭했을 때 버튼을 누르는 클릭이벤트 실행
		$(document).keypress(function(event){
			if(event.keyCode == '13') {
				$('#loginBtn').click();
			}
		});
		
		$('#loginBtn').click(function() {
			// 버튼을 click했을 때
			if($('#memberId').val() == '') { // id가 공백이면
				alert('ID를 입력하세요');
				return;
			} else if($('#memberPw').val() == '') { // pw가 공백이면
				alert('PW를 입력하세요');
				return;
			} else{
				$('#loginForm').submit(); // <button type="button"> -> <button type="submit">
			}
		});
	</script>
	
</body>
</html>