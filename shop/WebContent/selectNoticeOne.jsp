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
	// selectNoticeOne.jsp 디버깅 구분선
	System.out.println("----------selectNoticeOne.jsp----------");
	request.setCharacterEncoding("utf-8");
	// noticeDao 객체 생성
	NoticeDao noticeDao = new NoticeDao();
	
	// 입력값 방어 코드
	// 상세를 확인할 공지사항 번호(noticeNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("noticeNo")==null || request.getParameter("noticeNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectNoticeList.jsp");
		return;
	}
		

	// request 값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	// requst 매개값 디버깅 코드
	System.out.println(noticeNo+" <-- noticeNo");
	
	// 공지사항을 SELECT하는 noticeDao의 selectNoticeOne 메서드
	// 성공시 : returnNotice라는 객체에 저장시켜서 출력함
	// 실패시 : null
	Notice returnNotice = noticeDao.selecteNoticeOne(noticeNo);
	// 디버깅과 실패시 인덱스 페이지로, 성공시 출력
	if(returnNotice==null){
		System.out.println("공지사항 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/selectNoticeList.jsp");
	} else {
		System.out.println("공지사항 불러오기 성공");
		System.out.println(returnNotice.getNoticeNo()+"<--- returnNotice.getNoticeNo()");
		System.out.println(returnNotice.getNoticeTitle()+"<--- returnNotice.getNoticeTitle()");
		System.out.println(returnNotice.getNoticeContent()+"<--- returnNotice.getNoticeContent()");
		System.out.println(returnNotice.getCreateDate()+"<--- returnNotice.getCreateDate()");
	}
%>

	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>
		
		<h1 class="bg-white text-center">공지사항</h1>
		
		<table class="table mt-3">
			<tr>
				<td style="width:15%">TITLE</td>
				<td><%=returnNotice.getNoticeTitle()%></td>
			</tr>
			<tr>
				<td>CREATE</td>
				<td><%=returnNotice.getCreateDate()%></td>
			</tr>
			<tr>
				<td>CONTENT</td>
				<td><%=returnNotice.getNoticeContent()%></td>
			</tr>
		</table>
		<div class="text-center">
			<%
				// session에 저장된 loginMember를 받아옴
				Member loginMember = (Member)session.getAttribute("loginMember");
				// loginMember가 null이거나 memberLevel이 1미만 일 때 출력하는 버튼
				if(loginMember == null || loginMember.getMemberLevel() < 1){
			%>
					<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/selectNoticeList.jsp">목록으로</a>
			<%
				} else if(loginMember.getMemberLevel() >= 1) {
			%>
					<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/selectNoticeList.jsp">목록으로</a>
					<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/updateNoticeForm.jsp?noticeNo=<%=returnNotice.getNoticeNo()%>">수정</a>
					<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/deleteNotice.jsp?noticeNo=<%=returnNotice.getNoticeNo()%>">삭제</a>
			<%
				}
			%>
		</div>
	</div>
</body>
</html>