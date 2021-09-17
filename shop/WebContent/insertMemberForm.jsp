<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입폼</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// 인증 방어 코드 : 로그인 상태에서는 페이지 접근 불가
	// session.getAttribute("loginMember") --> null
	if(session.getAttribute("loginMember")!=null) {
		System.out.println("이미 로그인 되어 있습니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
%>
	<!-- start: mainMenu include -->
	<div>
		<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
	</div>
	<!-- end : mainMenu include -->
	<h1>회원가입</h1>
	<%
		// 아이디 중복 검사를 완료한 memberIdCheck = 공백값이거나, 중복체크를 완료한 사용가능한 아이디 값
		// selectMemberIdCheckAction.jsp 페이지에서 중복 값인지 검사하고 다시 이 페이지로 보내서 저장함
		// memberIdCheck에 저장된 값을 ID 입력칸에 value로 넣어줌
		String memberIdCheck = "";
		if(request.getParameter("memberIdCheck") != null){
			memberIdCheck = request.getParameter("memberIdCheck");
		}
	%>
	<!-- 멤버아이디가 사용가능한지 중복 확인 폼 -->
	<form method="post" action="<%=request.getContextPath()%>/selectMemberIdCheckAction.jsp">
		ID : <input type="text" name="memberIdCheck"><button type="submit">아이디 중복 검사</button>
	</form>
	
	<div><%=request.getParameter("idCheckResult") %></div><!-- null or 이미 사용중인 아이디 입니다 -->
	
	<!-- 회원가입 폼 -->
	<form method="post" action="<%=request.getContextPath()%>/insertMemberAction.jsp">
	<table>
		<tr>
			<td>ID</td>
			<td><input type="text" name="memberId" readonly="readonly" value="<%=memberIdCheck%>"></td>
		</tr>
		<tr>
			<td>PASSWORD</td>
			<td><input type="password" name="memberPw"></td>
		</tr>
		<tr>
			<td>NAME</td>
			<td><input type="text" name="memberName"></td>
		</tr>
		<tr>
			<td>AGE</td>
			<td><input type="text" name="memberAge"></td>
		</tr>
		<tr>
			<td>GENDER</td>
			<td>
				<input type="radio" name="memberGender" value="남">남자 
				<input type="radio" name="memberGender" value="여">여자
			</td>
		</tr>
	</table>
	<button class="btn btn-success" type="submit">가입</button>
</form>
</body>
</html>