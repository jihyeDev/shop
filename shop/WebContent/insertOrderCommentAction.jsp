<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// insertOrderCommentAction.jsp 디버깅 구분선
	System.out.println("----------insertOrderCommentAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// orderCommentDao 객체 생성
	OrderCommentDao orderCommentDao = new OrderCommentDao();
		
	//login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 추가할 후기의 정보를 다 입력했는지 확인하는 코드
	if(request.getParameter("orderNo")==null || request.getParameter("ebookNo")==null || request.getParameter("orderScore")==null || request.getParameter("orderCommentContent")==null) {
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}
	if(request.getParameter("orderNo").equals("") || request.getParameter("ebookNo").equals("") || request.getParameter("orderScore").equals("") || request.getParameter("orderCommentContent").equals("")){
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}
	
	// request 값 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int orderScore = Integer.parseInt(request.getParameter("orderScore"));
	String orderCommentContent = request.getParameter("orderCommentContent");
	
	// requst 매개값 디버깅 코드
	System.out.println(orderNo+"<-- orderNo");
	System.out.println(ebookNo+"<-- ebookNo");
	System.out.println(orderScore+"<-- orderScore");
	System.out.println(orderCommentContent+"<-- orderCommentContent");
	
	// paramComment 객체 생성 후, 받아온 값 저장
	OrderComment paramComment = new OrderComment();
	paramComment.setOrderNo(orderNo);
	paramComment.setEbookNo(ebookNo);
	paramComment.setOrderScore(orderScore);
	paramComment.setOrderCommentContent(orderCommentContent);
	
	// 후기를 추가하는 orderCommentDao의 insertOrderComment 메서드 호출
	if(orderCommentDao.insertOrderComment(paramComment)) {
		System.out.println("후기 입력 성공!");
	} else {
		System.out.println("후기 입력 실패");
	}
	response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	
%>