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
	System.out.println("----------selectQnaListByMember.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// memberDao 객체 생성
	MemberDao memberDao = new MemberDao();
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
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
	
	// 로그인한 회원이 작성한 Qna 목록을 불러오는 qnaDao의 selectQnaListByMember 메서드를 호출
	// qnaList라는 리스트를 사용하기 위해 생성
	ArrayList<Qna> qnaList = qnaDao.selectQnaListByMember(memberNo);
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
			<div class="font-weight-bold">나의 QNA 질문</div>
		</div>
		
		<div class="mx-auto" style="width:80%;">
			<table class="table table-hover">
				<thead>
					<tr class="text-center">
						<th style="width:10%;">CATEGORY</th>
						<th>TITLE</th>
						<th style="width:25%;">CREATE DATE</th>
					</tr>
				</thead>
				<tbody>
					<%
						for(Qna q : qnaList) {
					%>
							<tr>
								<td class="text-center"><%=q.getQnaCategory()%></td>
								<td>
									<a class="text-body" href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaTitle()%></a>
								</td>
								<td class="text-center"><%=q.getCreateDate()%></td>
							</tr>
					<%		
						}
					%>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>