<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// 인증 방어 코드 : 로그인 전에만 페이지 열람 가능
	// session.getAttribute("loginMember") --> null
	if(session.getAttribute("loginMember")!=null) {
		System.out.println("이미 로그인 되어 있습니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect("request.getContextPath()/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
%>
	<h1>로그인</h1>
	<form method="post" action="./loginAction.jsp">
		<div>memberId : </div>
		<div><input type="text" name="memberId"></div>
		<div>memberPw : </div>
		<div><input type="password" name="memberPw"></div>
		<div><button class="btn btn-success" type="submit">로그인</button></div>
	</form>
</body>
</html>