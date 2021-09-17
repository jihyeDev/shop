<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	// insertCategoryAction.jsp 디버깅 구분선
	System.out.println("----------insertCategoryAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
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
	// 카테고리 입력값 유효성 검사
	if(request.getParameter("categoryName")==null || request.getParameter("categoryState")==null || request.getParameter("categoryName").equals("") || request.getParameter("categoryState").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	

	// request 값 저장
	String categoryName = request.getParameter("categoryName");
	String categoryState = request.getParameter("categoryState");
	// requst 매개값 디버깅 코드
	System.out.println(categoryName+"<-- categoryName");
	System.out.println(categoryState+"<-- categoryState");
	
	// CategoryDao 객체 생성
	CategoryDao categoryDao = new CategoryDao();
	
	// category 객체 생성 후, 받아온 값 저장
	Category paramCategory = new Category();
	paramCategory.setCategoryName(categoryName);
	paramCategory.setCategoryState(categoryState);
	
	// 카테고리를 입력하는 categoryDao의 insertCategory 메서드 호출
	categoryDao.insertCategory(paramCategory);
	System.out.println("카테고리 입력 성공");
	response.sendRedirect(request.getContextPath()+"/admin/selectCategoryList.jsp");
%>