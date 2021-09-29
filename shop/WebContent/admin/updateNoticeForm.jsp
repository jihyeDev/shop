<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// updateNoticeForm.jsp 디버깅 구분선
	System.out.println("----------updateNoticeForm.jsp----------");
	request.setCharacterEncoding("utf-8");
	// noticeDao 객체 생성
	NoticeDao noticeDao = new NoticeDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 수정할 공지사항 번호(noticeNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("noticeNo")==null || request.getParameter("noticeNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
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
		System.out.println(returnNotice.getCreateDate()+"<--- returnNotice.getUpdateDate()");
		System.out.println(returnNotice.getCreateDate()+"<--- returnNotice.getCreateDate()");
	}
%>

	<div class="container-fluid">
		<div class="row">

			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
				<h3 class="font-weight-bold">공지게시판 관리 <small class="font-weight-light text-secondary">_ 수정하기</small></h3>
			
				<form method="post" action="<%=request.getContextPath()%>/admin/updateNoticeAction.jsp">
					<table class="table mt-5 w-50">
						<tr>
							<td>NO</td>
							<td><input type="text" name="noticeNo" class="form-control" readonly="readonly" value="<%=returnNotice.getNoticeNo()%>"></td>
						</tr>
						<tr>
							<td>TITLE</td>
							<td><input type="text" name="noticeTitle" class="form-control" value="<%=returnNotice.getNoticeTitle()%>"></td>
						</tr>
						<tr>
							<td>CONTENT</td>
							<td>
								<textarea name="noticeContent" class="form-control" cols="30" rows="10"><%=returnNotice.getNoticeContent()%></textarea>
							</td>
						</tr>
						<tr>
							<td>WRITER</td>
							<td><input type="text" name="memberNo" class="form-control" readonly="readonly" value="<%=loginMember.getMemberNo()%>"></td>
						</tr>
						<tr>
							<td>UPDATE DATE</td>
							<td><input type="text" name="updateDate" class="form-control" readonly="readonly" value="<%=returnNotice.getUpdateDate()%>"></td>
						</tr>
						<tr>
							<td>CREATE DATE</td>
							<td><input type="text" name="createDate" class="form-control" readonly="readonly" value="<%=returnNotice.getCreateDate()%>"></td>
						</tr>
					</table>
					<button type="submit" class="btn btn-outline-secondary center-block">수정</button>
				</form>
				
			</div>
			
		</div>
	</div>
</body>
</html>