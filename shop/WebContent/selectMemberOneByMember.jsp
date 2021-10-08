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
	System.out.println("----------selectMemberOneByMember.jsp----------");
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
		
		<div class="row mx-auto mt-4" style="width:80%">
		
			<div class="col-sm-6">
				<div class="border p-4 mb-4">
					<div style="font-weight:bold; font-size:20px;">회원정보</div>
					<div class="mt-2 pb-5" style="font-size:13px; color:#a4a4a4;">
						<span style="color:red;">'나'를 알려주는 정보</span>입니다.<br>수정 화면에서 변경할 정보들을 변경하세요.
					</div>
					<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/updateMemberFormByMember.jsp">수정</a>
				</div>
			</div>
			
			<div class="col-sm-6">
				<div class="border p-4 mb-4">
					<div style="font-weight:bold; font-size:20px;">주문목록</div>
					<div class="mt-2 pb-5" style="font-size:13px; color:#a4a4a4;">
						내가 구입한 전자책의 목록입니다.<br>같은 책을 구입한 사람들과 <span style="color:red;">전자책의 후기</span>를 공유해보세요.
					</div>
					<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/selectOrderListByMember.jsp">목록</a>
				</div>
			</div>
			
			<div class="col-sm-6">
				<div class="border p-4 mb-4">
					<div style="font-weight:bold; font-size:20px;">내 QNA 질문</div>
					<div class="mt-2 pb-5" style="font-size:13px; color:#a4a4a4;">
						내가 질문한 <span style="color:red;">QnA들의 모음과 답변</span>입니다.<br>궁굼한 점을 전부 해결해 보세요.
					</div>
					<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/selectQnaListByMember.jsp">나의 질문</a>
					<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/insertQnaForm.jsp">질문하기</a>
				</div>
			</div>
			
			<div class="col-sm-6">
				<div class="border p-4 mb-4">
					<div style="font-weight:bold; font-size:20px;">회원탈퇴</div>
					<div class="mt-2 pb-5" style="font-size:13px; color:#a4a4a4;">
						전자책 쇼핑몰을 이용하고 싶지 않으실 때 사용해주세요.<br>감사합니다.
					</div>
					<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/deleteMemberFormByMember.jsp">탈퇴</a>
				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>