<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import="vo.*" %>
<%
	// deleteQna.jsp 디버깅 구분선
	System.out.println("----------deleteQna.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 삭제할 Qna 번호(qnaNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("qnaNo")==null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectQnaList.jsp");
		return;
	}
		

	// request 값 저장
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// requst 매개값 디버깅 코드
	System.out.println(qnaNo+" <-- qnaNo");
	
	
	// 특정 QNA 게시글을 삭제시키는 qnaDao의 deleteQna 메서드 호출
	if(qnaDao.deleteQna(qnaNo)) {
		System.out.println("QNA 삭제 성공!");
	} else {
		System.out.println("QNA 삭제 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectQnaList.jsp");
	
%>