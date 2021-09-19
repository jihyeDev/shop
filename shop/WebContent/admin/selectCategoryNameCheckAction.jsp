<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*"%>
<%@ page import = "vo.*"%>
<%
	// selectCategoryNameCheckAction.jsp 디버깅 구분선
	System.out.println("----------selectCategoryNameCheckAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	// CategoryDao 생성
	CategoryDao CategoryDao = new CategoryDao();
	
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
	
	// 입력값 방어 코드 (공백이거나 null 인지)
	// categoryNameCheck 입력값 유효성 검사
	if(request.getParameter("categoryNameCheck")==null || request.getParameter("categoryNameCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp");
		return;
	}
	
	// 입력받을 categoryNameCheck를 저장
	String categoryNameCheck = request.getParameter("categoryNameCheck");
	System.out.println(categoryNameCheck+" <-- categoryNameCheck");
	
	// 입력받은 categoryNameCheck를 중복값인지 확인하는 selectCategoryName 메서드를 호출하여 리턴값을 result에 저장
	String result = CategoryDao.selectCategoryName(categoryNameCheck);
	
	
	// result 값이 null이면 사용 가능한 카테고리 이름, 아니라면 이미 사용중인 카테고리 이름
	if(result == null) {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?categoryNameCheck="+categoryNameCheck);
	} else {
		response.sendRedirect(request.getContextPath()+"/admin/insertCategoryForm.jsp?nameCheckResult=Y");
	}
%>