<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	System.out.println("----------selectCategoryList.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// CategoryDao 객체 생성
	CategoryDao categoryDao = new CategoryDao();
	
	// adminPage의 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 전체 카테고리를 SELECT하는 categoryDao의 selectCategoryListAllByPage메서드 호출
	// categoryList에 저장하여 게시글 출력
	ArrayList<Category> categoryList = new ArrayList<Category>();
	categoryList = categoryDao.selectCategoryListAllByPage();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 목록</title>
</head>
<body>
	<!-- start: adminMenu include -->
	<div>
		<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
	</div>
	<!-- end : adminMenu include -->
	<h1>카테고리 목록</h1>
	<table border="1">
		<thead>
			<tr>
				<th>categoryName</th>
				<th>categoryState</th>
				<th>updateDate</th>
				<th>createDate</th>
			</tr>
		</thead>
		<tbody>
			<%
				// categoryList를 출력하는 for문
				for(Category c : categoryList) {
			%>
					<tr>
						<td><%=c.getCategoryName()%></td>
						<td>
							<%
								// 사용현황을 설정하는 select를 수정하기 전의 카테고리로
								// selected 하기 위해 배열로 생성하여 비교
								// "selected" 문자열을 저장하기 위한 용도의 배열
								String[] stateSelected = new String[2];
								if(c.getCategoryState().equals("Y")){
									stateSelected[0] = "selected";
								} else if(c.getCategoryState().equals("N")){
									stateSelected[1] = "selected";
								}
							%>
							<form action="<%=request.getContextPath()%>/admin/updateCategoryStateAction.jsp" method="get">
							<select name="categoryNewState">
								<option value="Y" <%=stateSelected[0]%>>사용</option>
								<option value="N" <%=stateSelected[1]%>>미사용</option>
							</select>
							<input type="hidden" name="categoryName" value="<%=c.getCategoryName()%>">
							<button class="btn btn-success">사용현황 수정</button>
							</form>
						</td>
						<td><%=c.getUpdateDate()%></td>
						<td><%=c.getCreateDate()%></td>
					</tr>
			<%
				}
			%>
		</tbody>
	</table>
	<br>
	<a href="<%=request.getContextPath()%>/admin/insertCategoryForm.jsp" class="btn btn-outline-secondary">카테고리 추가</a>
</body>
</html>