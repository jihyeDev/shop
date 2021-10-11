<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	// deleteCategoryAction.jsp 디버깅 구분선
	System.out.println("----------deleteCategoryAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// CategoryDao 객체 생성
	CategoryDao categoryDao = new CategoryDao();
	
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
	if(request.getParameter("categoryName")==null || request.getParameter("categoryName").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectCategoryList.jsp");
		return;
	}
	
	// request 값 저장
	String categoryName = request.getParameter("categoryName");
	
	// requst 매개값 디버깅 코드
	System.out.println(categoryName+"<-- categoryName");
	
	// 카테고리를 삭제하고 관련 전자책들도 다 삭제하는 categoryDao의 deleteCategoryByAdmin 메서드 호출
	if(categoryDao.deleteCategoryByAdmin(categoryName)) {
		System.out.println("카테고리 & 관련 전자책 삭제 성공");
	} else {
		System.out.println("카테고리 & 관련 전자책 삭제 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
%>