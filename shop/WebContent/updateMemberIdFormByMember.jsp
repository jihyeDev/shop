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
	System.out.println("----------updateMemberIdFormByMember.jsp----------");
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
			<div class="font-weight-bold">ID 변경하기</div>
		</div>
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
		<div class="mx-auto" style="width:50%;">
			<form method="post" action="<%=request.getContextPath()%>/updateSelectMemberIdCheckAction.jsp">
			<table class="table mt-5">
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
		</div>
		<!-- 회원정보 수정 폼 -->
		<div class="mx-auto" style="width:50%;">
			<form method="post" action="<%=request.getContextPath()%>/updateMemberIdActionByMember.jsp">
				<table class="table mt-2">
					<tr>
						<td>ID</td>
						<td>
							<input type="text" id="memberId" name="memberId" class="form-control" readonly="readonly" value="<%=memberIdCheck%>">
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
					<button class="btn btn-success" type="submit">수정</button>
				</div>
			</form>
		</div>
		<br>
	</div>
</body>
</html>