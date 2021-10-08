<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
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
	System.out.println("----------updateMemberFormByMember.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// memberDao 객체 생성
	MemberDao memberDao = new MemberDao();
	
	// login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 회원의 session에 저장된 loginMember를 객체로 전환하고
	// 거기에서 회원의 번호를 받아옴
	int memberNo = loginMember.getMemberNo();
	// 디버깅
	System.out.println("memberNo(로그인한 회원의 회원번호)) : "+memberNo);
	
	// 로그인한 회원의 정보를 불러오는 memberDao의 selectMemberOne 메서드를 호출
	Member m = memberDao.selectMemberOne(memberNo);
%>
	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>

		<div class="bg-white text-center p-4">
			<h1 class="pb-4">MY PAGE</h1>
			<div class="font-weight-bold">회원정보 수정하기</div>
		</div>
		<!-- 회원정보 수정 폼 -->
		<div class="mx-auto" style="width:50%;">
			<form id="updateForm" method="post" action="<%=request.getContextPath()%>/updateMemberActionByMember.jsp">
				<table class="table mt-2">
					<tr>
						<td>ID</td>
						<td>
							<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/updateMemberIdFormByMember.jsp">아이디 수정하기</a>
						</td>
					</tr>
					<tr>
						<td>PASSWORD</td>
						<td>
							<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/updateMemberPwFormByMember.jsp">비밀번호 수정하기</a>
						</td>
					</tr>
					<tr>
						<td>NAME</td>
						<td><input type="text" id="memberName" name="memberName" class="form-control" value="<%=m.getMemberName()%>"></td>
					</tr>
					<tr>
						<td>AGE</td>
						<td><input type="text" id="memberAge" name="memberAge" class="form-control" value="<%=m.getMemberAge()%>"></td>
					</tr>
					<tr>
						<td>GENDER</td>
						<td>
							<%
								if(m.getMemberGender().equals("남")){
							%>
								<input type="radio" class="memberGender" name="memberGender" value="남" checked>남자
								<input type="radio" class="memberGender" name="memberGender" value="여">여자
							<%
								} else {
							%>
								<input type="radio" class="memberGender" name="memberGender" value="남">남자
								<input type="radio" class="memberGender" name="memberGender" value="여" checked>여자
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td>PASSWORD</td>
						<td>
							<small style="color:red;">* 현재 비밀번호를 입력해주세요. 비밀번호 확인 후 수정이 완료됩니다 !</small>
							<input type="password" id="memberPw" name="memberPw" class="form-control">
							<input type="hidden" name="memberNo" value="<%=m.getMemberNo()%>">
						</td>
					</tr>
				</table>
				<div class="text-center">
					<button id="btn" class="btn btn-success" type="button">수정</button>
				</div>
			</form>
		</div>
		<br>
	</div>
	<script>
	$('#btn').click(function(){
			if($('#memberName').val() == '') {
				alert('NAME를 입력하세요!');
				return;
			}
			if($('#memberAge').val() == '') {
				alert('AGE를 입력하세요!');
				return;
			}
			let memberGedner = $('.memberGender:checked'); // . 클래스속성으로 부르면 리턴값은 배열
			if(memberGedner.length == 0) {
				alert('GENDER를 선택하세요!');
				return;
			}
			if($('#memberPw').val() == '') {
				alert('PASSWORD를 입력하세요!');
				return;
			}
			
			$('#updateForm').submit();
		});
	</script>
</body>
</html>