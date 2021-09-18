<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<h1 class="jumbotron">메인페이지</h1>
		<%
			// 로그인 전 = session의 loginMember가 null 일 때
			if(session.getAttribute("loginMember")==null) {
		%>
			<div><a class="btn btn-success" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a></div><br>
			<div><a class="btn btn-success" href="<%=request.getContextPath()%>/insertMemberForm.jsp">회원가입</a></div>
		<%
			// 로그인 후
			// loginMember 객체에 session의 loginMember를 저장
			} else {
				Member loginMember = (Member)session.getAttribute("loginMember");
		%>
			<div>
				<div><%=loginMember.getMemberId()%> 님 / Level : <%=loginMember.getMemberLevel()%></div><br>
				<div><a class="btn btn-success" href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a></div>
				<!-- 관리자 페이지로 가는 링크 -->
		<%
				if(loginMember.getMemberLevel() > 0) {
		%>		
				<div><a class="btn btn-success" href="<%=request.getContextPath()%>/admin/adminIndex.jsp">관리자 페이지</a></div>
		<%
				}
		%>
			</div>
		<%
			}
		%>
	</div>
</body>
</html>