<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입폼</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
	<div class="container pt-3">

		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		
		<h1 class="jumbotron">회원가입</h1>
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
		<table class="table mt-5 w-50">
			<tr>
				<td>ID </td>
				<td>
					<div class="input-group">
						<input type="text" name="memberIdCheck" class="form-control">
						<div class="input-group-append">
	      					<button type="submit" class="btn btn-outline-secondary">중복확인</button>
	    				</div>
	    			</div>
    				<%
						if(request.getParameter("idCheckResult") == null & memberIdCheck != "") {
					%>
							<small>* 사용할 수 있는 ID 입니다.</small>
					<%
						} else if(request.getParameter("idCheckResult") == null) {
					%>
							<small>* 사용하려는 ID를 입력한 뒤 중복확인을 해주세요.</small>
					<%
						} else if(request.getParameter("idCheckResult").equals("Y")){
					%>
							<small>* 중복된 ID 입니다. 다시 입력해주세요.</small>
					<%
						}
					%>
				</td>
			</tr>
		</table>
		</form>
		
		<!-- 회원가입 폼 -->
		<form id="joinForm" method="post" action="<%=request.getContextPath()%>/insertMemberAction.jsp">
			<table class="table mt-5 w-50">
				<tr>
					<td>ID</td>
					<td><input type="text" id="memberId" name="memberId" class="form-control" readonly="readonly" value="<%=memberIdCheck%>"></td>
				</tr>
				<tr>
					<td>PASSWORD</td>
					<td><input type="password" id="memberPW" name="memberPw" class="form-control"></td>
				</tr>
				<tr>
					<td>NAME</td>
					<td><input type="text" id="memberName" name="memberName" class="form-control"></td>
				</tr>
				<tr>
					<td>AGE</td>
					<td><input type="text" id="memberAge" name="memberAge" class="form-control"></td>
				</tr>
				<tr>
					<td>GENDER</td>
					<td>
						<input type="radio" class="memberGender" name="memberGender" value="남">남자 
						<input type="radio" class="memberGender" name="memberGender" value="여">여자
					</td>
				</tr>
			</table>
			<button id="btn" class="btn btn-success" type="button">가입</button>
		</form>
		<br>
	</div>
	<script>
	$('#btn').click(function(){
		if($('#memberId').val() == '') {
			alert('ID를 입력하세요!');
			return;
		}
		if ($('#memberPw').val() == '') {
			alert('PW를 입력하세요!');
			return;
		}
		if ($('#memberName').val() == '') {
			alert('NAME를 입력하세요!');
			return;
		} 
		let memberGedner = $('.memberGender:checked'); // . 클래스속성으로 부르면 리턴값은 배열
		if (memberGender.length == 0) {
			alert('GENDER를 선택하세요!');
			return;
		}
		$('#joinForm').submit();
	})
	</script>
</body>
</html>