<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// updateNoticeAction.jsp 디버깅 구분선
	System.out.println("----------updateNoticeAction.jsp----------");
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
	// 수정할 공지사항 내용들을 입력 받았는지 유효성 검사
	if(request.getParameter("noticeNo")==null || request.getParameter("noticeNo").equals("") || request.getParameter("noticeTitle")==null || request.getParameter("noticeTitle").equals("") || request.getParameter("noticeContent")==null || request.getParameter("noticeContent").equals("") || request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
		return;
	}
		

	// request 값 저장
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// request 매개값 디버깅 코드
	System.out.println(noticeNo+" <-- noticeNo");
	System.out.println(noticeTitle+" <-- noticeTitle");
	System.out.println(noticeContent+" <-- noticeContent");
	System.out.println(memberNo+" <-- memberNo");
	// Notice 객체 생성 후, 받아온 값 저장
	Notice paramNotice = new Notice();
	paramNotice.setNoticeNo(noticeNo);
	paramNotice.setNoticeTitle(noticeTitle);
	paramNotice.setNoticeContent(noticeContent);
	paramNotice.setMemberNo(memberNo);
	
	// 공지사항의 게시글을 수정하는 noticeDao의 updateNoticeByAdmin 메서드 호출
	if(noticeDao.updateNoticeByAdmin(paramNotice)) {
		System.out.println("공지사항 게시글 수정 성공!");
		
	} else {
		System.out.println("공지사항 게시글 수정 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectNoticeList.jsp");
	
%>