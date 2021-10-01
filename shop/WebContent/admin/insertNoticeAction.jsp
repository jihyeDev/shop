<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	// insertNoticeAction.jsp 디버깅 구분선
	System.out.println("----------insertNoticeAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// noticeDao 객체 생성
	NoticeDao noticeDao = new NoticeDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
	
	// 입력값 방어 코드
	// 공지사항 게시글 입력값 유효성 검사
	if(request.getParameter("noticeTitle")==null || request.getParameter("noticeTitle").equals("") || request.getParameter("noticeContent")==null || request.getParameter("noticeContent").equals("") || request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertNoticeForm.jsp");
		return;
	}
	

	// request 값 저장
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// requst 매개값 디버깅 코드
	System.out.println(noticeTitle+" <-- noticeTitle");
	System.out.println(noticeContent+" <-- noticeContent");
	System.out.println(memberNo+" <-- memberNo");
	
	// Notice 객체 생성 후, 받아온 값 저장
	Notice paramNotice = new Notice();
	paramNotice.setNoticeTitle(noticeTitle);
	paramNotice.setNoticeContent(noticeContent);
	paramNotice.setMemberNo(memberNo);
	
	// 공지사항의 게시글을 입력하는 noticeDao의 insertNoticeByAdmin 메서드 호출
	if(noticeDao.insertNoticeByAdmin(paramNotice)) {
		System.out.println("공지사항 입력 성공");
	} else {
		System.out.println("공지사항 입력 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
%>