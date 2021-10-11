<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	System.out.println("----------deleteCategoryForm.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// adminPage의 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 삭제</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
			
				<h3 class="font-weight-bold">카테고리 삭제</h3>
				
				<div class="mt-5 ml-2" style="width:70%;">
					<span style="color:red;">* </span><span style="font-weight:bold;">'<%=categoryName%>'</span> 카테고리 삭제 시 카테고리 관련 전자책이 <span style="font-weight:bold;">전부 삭제</span> 됩니다.
					<input type="hidden">
				</div>
				<a href="<%=request.getContextPath()%>/admin/deleteCategoryAction.jsp?categoryName=<%=categoryName%>" class="btn btn-outline-secondary mt-3 ml-2">카테고리 삭제</a>
				<a href="<%=request.getContextPath()%>/admin/selectCategoryList.jsp" class="btn btn-outline-secondary mt-3 ml-2">목록으로</a>
			</div>
			
		</div>
	</div>
</body>
</html>