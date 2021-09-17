<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 입력폼</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
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
%>
	<!-- start: adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : adminMenu include -->
	<h1>카테고리 입력</h1>
	<%
		// 카테고리 이름 중복 검사를 완료한 categoryNameCheck = 공백값이거나, 중복체크를 완료한 사용가능한 아이디 값
		// selectcategoryNameCheckAction.jsp 페이지에서 중복 값인지 검사하고 다시 이 페이지로 보내서 저장함
		// categoryNameCheck에 저장된 값을 NAME 입력칸에 value로 넣어줌
		String categoryNameCheck = "";
		if(request.getParameter("categoryNameCheck") != null){
			categoryNameCheck = request.getParameter("categoryNameCheck");
		}
	%>
	<!-- 카테고리 이름이 사용가능한지 중복 확인 폼 -->
	<form method="post" action="<%=request.getContextPath()%>/admin/selectCategoryNameCheckAction.jsp">
		카테고리 이름 : <input type="text" name="categoryNameCheck"> <button type="submit" class="btn btn-outline-secondary">카테고리 이름 중복 검사</button>
	</form>
	
	<div><%=request.getParameter("nameCheckResult") %></div><!-- null or 이미 사용중인 아이디 입니다 -->
	
	<!-- 카테고리 입력 폼 -->
	<form method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp">
	<table>
		<tr>
			<td>카테고리 이름 : </td>
			<td><input type="text" name="categoryName" readonly="readonly" value="<%=categoryNameCheck%>"></td>
		</tr>
		<tr>
			<td>카테고리 사용현황 : </td>
			<td>
				<select name="categoryState">
					<option value="Y">사용</option>
					<option value="N">미사용</option>
				</select>
			</td>
		</tr>
	</table>
	<button class="btn btn-success" type="submit">입력</button>
</form>
</body>
</html>