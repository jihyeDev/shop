<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 입력폼</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
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
%>
	<div class="container-fluid">
		<div class="row">

			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
				<h3 class="font-weight-bold">카테고리목록 <small class="font-weight-light text-secondary">_ 카테고리 추가</small></h3>
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
				<table class="table mt-5 w-50">
					<tr>
						<td>CATEGORY NAME </td>
						<td>
							<div class="input-group">
								<input type="text" name="categoryNameCheck" class="form-control">
								<div class="input-group-append">
	      							<button type="submit" class="btn btn-outline-secondary">중복확인</button>
	    						</div>
	    					</div>
    						<%
								if(request.getParameter("nameCheckResult") == null & categoryNameCheck != "") {
							%>
									<small>* 사용할 수 있는 카테고리 이름입니다.</small>
							<%
								} else if(request.getParameter("nameCheckResult") == null) {
							%>
									<small>* 추가하려는 카테고리의 이름을 입력한 뒤 중복확인을 해주세요.</small>
							<%
								} else if(request.getParameter("nameCheckResult").equals("Y")){
							%>
									<small>* 중복된 카테고리 이름입니다. 다시 입력해주세요.</small>
							<%
								}
							%>
						</td>
					</tr>
				</table>
				</form>
				
				<!-- 카테고리 입력 폼 -->
				<form method="post" action="<%=request.getContextPath()%>/admin/insertCategoryAction.jsp">
				<table class="table mt-2 w-50">
					<tr>
						<td>CATEGORY NAME </td>
						<td>
							<input type="text" name="categoryName" class="form-control" readonly="readonly" value="<%=categoryNameCheck%>">
						</td>
					</tr>
					<tr>
						<td>STATE </td>
						<td>
							<select name="categoryState" class="custom-select">
								<option value="Y">사용</option>
								<option value="N">미사용</option>
							</select>
						</td>
					</tr>
				</table>
				<button class="btn btn-outline-secondary center-block" type="submit">추가</button>
				</form>
			</div>
		
		</div>
	</div>
</body>
</html>