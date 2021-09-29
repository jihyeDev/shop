<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// insertQnaCommentAction.jsp 디버깅 구분선
	System.out.println("----------insertQnaCommentAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// QnaCommentDao 객체 생성
	QnaCommentDao qnaCommentDao = new QnaCommentDao();
		
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 답변의 정보를 다 입력했는지 확인하는 코드
	if(request.getParameter("qnaNo")==null || request.getParameter("memberNo")==null || request.getParameter("qnaCommentContent")==null) {
		response.sendRedirect(request.getContextPath()+"/selectQnaOne.jsp?qnaNo="+request.getParameter("qnaNo"));
		return;
	}
	if(request.getParameter("qnaNo").equals("") || request.getParameter("memberNo").equals("") || request.getParameter("qnaCommentContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/selectQnaOne.jsp?qnaNo="+request.getParameter("qnaNo"));
		return;
	}
	
	// request 값 저장
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String qnaCommentContent = request.getParameter("qnaCommentContent");
	
	// requst 매개값 디버깅 코드
	System.out.println(qnaNo+"<-- qnaNo");
	System.out.println(memberNo+"<-- memberNo");
	System.out.println(qnaCommentContent+"<-- qnaCommentContent");
	
	// paramComment 객체 생성 후, 받아온 값 저장
	QnaComment paramComment = new QnaComment();
	paramComment.setQnaNo(qnaNo);
	paramComment.setMemberNo(memberNo);
	paramComment.setQnaCommentContent(qnaCommentContent);
	
	// QnA의 답변을 추가하는 QnaCommentDao의 insertQnaComment 메서드 호출
	if(qnaCommentDao.insertQnaComment(paramComment)) {
		System.out.println("QnA 답변 입력 성공!");
	} else {
		System.out.println("QnA 답변 실패");
	}
	response.sendRedirect(request.getContextPath()+"/selectQnaOne.jsp?qanNo"+qnaNo);
	
%>