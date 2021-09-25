<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// updateEbookPriceAction.jsp 디버깅 구분선
	System.out.println("----------updateEbookPriceAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// EbookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 가격을 수정할 전자책의 ebookNo과 수정할 가격을 입력 받았는지 유효성 검사
	if(request.getParameter("ebookNo")==null || request.getParameter("ebookPrice")==null) {
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp");
		return;
	}
		

	// request 값 저장
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	int ebookPrice = Integer.parseInt(request.getParameter("ebookPrice"));
	// request 매개값 디버깅 코드
	System.out.println(ebookNo+" <-- ebookNo");
	System.out.println(ebookPrice+" <-- ebookPrice");
	// Ebook 객체 생성 후, 받아온 값 저장
	Ebook paramEbook = new Ebook();
	paramEbook.setEbookNo(ebookNo);
	paramEbook.setEbookPrice(ebookPrice);
	
	// 전자책의 가격을 수정하는 ebookDao의 updateEbookPrice 메서드 호출
	if(ebookDao.updateEbookPrice(paramEbook)) {
		System.out.println("가격 수정 성공!");
	} else {
		System.out.println("가격 수정 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectEbookOne.jsp?ebookNo="+ebookNo);
	
%>