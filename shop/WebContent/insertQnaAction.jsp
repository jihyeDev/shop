<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	// insertQnaAction.jsp 디버깅 구분선
	System.out.println("----------insertQnaAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
	// 인증 방어 코드 : 로그아웃 상태에서는 페이지 접근 불가
	// session.getAttribute("loginMember") --> null
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(session.getAttribute("loginMember")==null) {
		System.out.println("로그인 한 후 이용 가능합니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
	
	// 입력값 방어 코드
	// Qna 게시글 입력값 유효성 검사
	if(request.getParameter("qnaTitle")==null || request.getParameter("qnaTitle").equals("") || request.getParameter("qnaCategory")==null || request.getParameter("qnaCategory").equals("") || request.getParameter("qnaContent")==null || request.getParameter("qnaContent").equals("") || request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertNoticeForm.jsp");
		return;
	}

	// request 값 저장
	String qnaTitle = request.getParameter("qnaTitle");
	String qnaCategory = request.getParameter("qnaCategory");
	String qnaContent = request.getParameter("qnaContent");
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// secret은 checkbox로 설정 --> null or 'Y'
	// null 일 때는 값을 'N'으로 설정
	String qnaSecret = request.getParameter("qnaSecret");
	if(qnaSecret == "" || qnaSecret == null) {
		qnaSecret = "N";
	}
	
	// requst 매개값 디버깅 코드
	System.out.println(qnaTitle+" <-- qnaTitle");
	System.out.println(qnaCategory+" <-- qnaCategory");
	System.out.println(qnaContent+" <-- qnaContent");
	System.out.println(memberNo+" <-- memberNo");
	System.out.println(qnaSecret+" <-- qnaSecret");
	
	// Qna 객체 생성 후, 받아온 값 저장
	Qna paramQna = new Qna();
	paramQna.setQnaTitle(qnaTitle);
	paramQna.setQnaCategory(qnaCategory);
	paramQna.setQnaContent(qnaContent);
	paramQna.setQnaSecret(qnaSecret);
	paramQna.setMemberNo(memberNo);
	
	// Qna 게시글을 입력하는 qnaDao의 insertQnaByMember 메서드 호출
	if(qnaDao.insertQnaByMember(paramQna)) {
		System.out.println("질문 입력 성공");
	} else {
		System.out.println("질문 입력 실패");
	}
	response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
%>