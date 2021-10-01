<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import="vo.*" %>
<%
	// deleteOrder.jsp 디버깅 구분선
	System.out.println("----------deleteOrder.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// orderDao 객체 생성
	OrderDao orderDao = new OrderDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 삭제할 주문 번호(orderNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("orderNo")==null || request.getParameter("orderNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectOrderList.jsp");
		return;
	}
		

	// request 값 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	// requst 매개값 디버깅 코드
	System.out.println(orderNo+" <-- orderNo");
	
	
	// 특정 주문을 삭제시키는 orderDao의 deleteOrderByAdmin 메서드 호출
	if(orderDao.deleteOrderByAdmin(orderNo)) {
		System.out.println("주문 취소 성공!");
	} else {
		System.out.println("주문 취소 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectOrderList.jsp");
	
%>