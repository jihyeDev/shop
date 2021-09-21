<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// updateCategoryStateAction.jsp 디버깅 구분선
	System.out.println("----------updateCategoryStateAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// CategoryDao 객체 생성
	CategoryDao categoryDao = new CategoryDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 사용현황을 수정할 카테고리의 categoryName과 수정할 사용현황을 입력 받았는지 유효성 검사
	if(request.getParameter("categoryName")==null || request.getParameter("categoryName").equals("") || request.getParameter("categoryNewState")==null || request.getParameter("categoryNewState").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
		return;
	}
		

	// request 값 저장
	String categoryName = request.getParameter("categoryName");
	String categoryNewState = request.getParameter("categoryNewState");
	// requst 매개값 디버깅 코드
	System.out.println(categoryName+" <-- categoryName");
	System.out.println(categoryNewState+" <-- categoryNewState");
	// Category 객체 생성 후, 받아온 값 저장
	Category paramCategory = new Category();
	paramCategory.setCategoryName(categoryName);
	
	// 특정 카테고리의 사용현황을 수정하는 categoryDao의 updateCategoryState 메서드 호출
	if(categoryDao.updateCategoryState(paramCategory, categoryNewState)) {
		System.out.println("사용현황 수정 성공!");
	} else {
		System.out.println("사용현황 수정 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
	
%>