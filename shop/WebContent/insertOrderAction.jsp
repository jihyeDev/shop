<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// insertOrderAction.jsp 디버깅 구분선
	System.out.println("----------insertOrderAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// orderDao 객체 생성
	OrderDao orderDao = new OrderDao();
		
	// login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 추가할 후기의 정보를 다 입력했는지 확인하는 코드
	if(request.getParameter("ebookNo")==null || request.getParameter("ebookPrice")==null || request.getParameter("memberNo")==null) {
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	if(request.getParameter("ebookNo").equals("") || request.getParameter("ebookPrice").equals("") || request.getParameter("memberNo").equals("")){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// request 값 저장
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int ebookPrice = Integer.parseInt(request.getParameter("ebookPrice"));
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	
	// requst 매개값 디버깅 코드
	System.out.println(ebookNo+"<-- ebookNo");
	System.out.println(ebookPrice+"<-- ebookPrice");
	System.out.println(memberNo+"<-- memberNo");
	
	// paramOrder 객체 생성 후, 받아온 값 저장
	Order paramOrder = new Order();
	paramOrder.setEbookNo(ebookNo);
	paramOrder.setMemberNo(memberNo);
	paramOrder.setOrderPrice(ebookPrice);
	
	// 전자책을 주문하는 orderDao의 insertOrder 메서드 호출
	if(orderDao.insertOrder(paramOrder)) {
		System.out.println("주문 성공!");
	} else {
		System.out.println("주문 실패");
	}
	response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	
%>