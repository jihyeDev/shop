<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%> <!-- 파일이름중복을 피할수 있도록 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전자책 입력폼</title>
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
	
	// categoryName을 다 불러오기 위한 selectCategoryListAllByPage 메서드를 불러옴
	CategoryDao categoryDao = new CategoryDao();
	ArrayList<Category> categoryList = categoryDao.selectCategoryListAllByPage();

%>
	<div class="container-fluid">
		<div class="row">

			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
				<h3 class="font-weight-bold">전자책 관리 <small class="font-weight-light text-secondary">_ 전자책 추가</small></h3>
				<%
					// 전자책 중복 검사를 완료한 ebookTitleCheck = 공백값이거나, 중복체크를 완료한 사용가능한 아이디 값
					// selectEbookTitleCheckAction.jsp 페이지에서 중복인지 검사하고 다시 이 페이지로 보내서 저장함
					// ebookTitleCheck에 저장된 값을 TITLE 입력칸에 value로 넣어줌
					String ebookTitleCheck = "";
					if(request.getParameter("ebookTitleCheck") != null){
						ebookTitleCheck = request.getParameter("ebookTitleCheck");
					}
				%>
				<!-- 전자책이 이미 등록되었는지 전자책 이름을 통해서 확인하는 폼 -->
				<form method="post" action="<%=request.getContextPath()%>/admin/selectEbookTitleCheckAction.jsp">
				<table class="table mt-5 w-50">
					<tr>
						<td>TITLE </td>
						<td>
							<div class="input-group">
								<input type="text" name="ebookTitleCheck" class="form-control">
								<div class="input-group-append">
	      							<button type="submit" class="btn btn-outline-secondary">중복확인</button>
	    						</div>
	    					</div>
    						<%
								if(request.getParameter("titleCheckResult") == null & ebookTitleCheck != "") {
							%>
									<small>* 추가할 수 있는 전자책입니다.</small>
							<%
								} else if(request.getParameter("titleCheckResult") == null) {
							%>
									<small>* 추가하려는 전자책의 제목을 입력한 뒤 중복확인을 해주세요.</small>
							<%
								} else if(request.getParameter("titleCheckResult").equals("Y")){
							%>
									<small>* 중복된 전자책입니다. 다시 입력해주세요.</small>
							<%
								}
							%>
						</td>
					</tr>
				</table>
				</form>
				
				<!-- 전자책 입력 폼 -->
				<form method="post" action="<%=request.getContextPath()%>/admin/insertEbookAction.jsp" enctype="multipart/form-data">
				<!-- multipart/form-data : 액션으로 기계어코드를 넘길때 사용 -->
	        	<!-- application/x-www-form-urlencoded : 액션으로 문자열 넘길때 사용 -->
	        	
				<table class="table mt-2 w-50">
					<tr>
						<td>TITLE </td>
						<td>
							<input type="text" name="ebookTitle" class="form-control" readonly="readonly" value="<%=ebookTitleCheck%>">
						</td>
					</tr>
					<tr>
						<td>CATEGORY </td>
						<td>
							<select name="categoryName" class="custom-select">
								<%
		            				for(Category c : categoryList) {
		         				%>
		               					<option value="<%=c.getCategoryName()%>"><%=c.getCategoryName()%></option>
		         				<%      
		            				}
		        				 %>
							</select>
						</td>
					</tr>
					<tr>
						<td>IMG </td>
						<td><input type="file" name="ebookImg"></td>
					</tr>
					<tr>
						<td>AUTHOR </td>
						<td>
							<input type="text" name="ebookAuthor" class="form-control">
						</td>
					</tr>
					<tr>
						<td>ISBN </td>
						<td>
							<input type="text" name="ebookIsbn" class="form-control">
						</td>
					</tr>
					<tr>
						<td>COMPANY </td>
						<td>
							<input type="text" name="ebookCompany" class="form-control">
						</td>
					</tr>
					<tr>
						<td>PAGE COUNT </td>
						<td>
							<input type="text" name="ebookPageCount" class="form-control">
						</td>
					</tr>
					<tr>
						<td>SUMMARY </td>
						<td>
							<input type="text" name="ebookSummary" class="form-control">
						</td>
					</tr>
					<tr>
						<td>STATE </td>
						<td>
							<select name="ebookState" class="custom-select">
								<option value="판매중">판매중</option>
								<option value="품절">품절</option>
								<option value="절판">절판</option>
								<option value="구편절판">구편절판</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>PRICE </td>
						<td>
							<input type="text" name="ebookPrice" class="form-control">
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