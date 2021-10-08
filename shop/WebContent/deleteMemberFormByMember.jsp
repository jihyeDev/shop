<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	System.out.println("----------deleteMemberFormByMember.jsp----------");
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
			<div class="font-weight-bold"><%=m.getMemberName()%>(<%=m.getMemberId()%>)님</div>
			<span style="font-size:12px;">
				<%
					// LEVEL별로 무슨 등급인지 출력하는 if문
					if(m.getMemberLevel() == 0) {
				%>
						회원 Level.<%=m.getMemberLevel()%>
				<%
					} else {
				%>
						관리자 Level.<%=m.getMemberLevel()%>
				<%
					}
				%>
			</span>
		</div>
		
		<div class="text-center m-5" style="font-size:13px;">
			탈퇴 시 주문했던 전자책을 다시는 볼 수 없게됩니다.<br>
			탈퇴 시 QnA와 주문 후기들은 사라지지 않습니다.<br><br>
			<span class="font-weight-bold">정말 탈퇴하시겠습니까?<br><br></span>
			<form method="post" action="<%=request.getContextPath()%>/deleteMemberActionByMember.jsp">
				탈퇴를 위해 현재 비밀번호를 입력해주세요.<br>
				<input type="password" name="memberPw"><br>
				<input type="hidden" name="memberNo" value="<%=memberNo%>">
				<button class="btn btn-success m-5" type="submit">탈퇴</button>
			</form>
		</div>
		
	</div>
</body>
</html>