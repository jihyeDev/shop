<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import="vo.*" %>
<%
	// deleteQna.jsp 디버깅 구분선
	System.out.println("----------deleteQna.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
	// 인증 방어 코드 : 로그아웃 상태에서는 페이지 접근 불가
	// session.getAttribute("loginMember") --> null
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
		System.out.println("로그인 한 후 이용 가능합니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
	
	// 입력값 방어 코드
	// 수정할 QnA 번호(qnaNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("qnaNo")==null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
	
	// request 값 저장
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// requst 매개값 디버깅 코드
	System.out.println(qnaNo+" <-- qnaNo");
	
	
	// 특정 QNA 게시글을 삭제시키는 qnaDao의 deleteQnaByMember 메서드 호출
	if(qnaDao.deleteQnaByMember(qnaNo)) {
		System.out.println("QNA 삭제 성공!");
	} else {
		System.out.println("QNA 삭제 실패");
	}
	response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
	
%>