<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
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
				<h3 class="font-weight-bold">공지게시판 관리 <small class="font-weight-light text-secondary">_ 수정하기</small></h3>
			
				<form method="post" action="<%=request.getContextPath()%>/admin/insertNoticeAction.jsp">
					<table class="table mt-5 w-50">
						<tr>
							<td>TITLE</td>
							<td><input type="text" name="noticeTitle" class="form-control"></td>
						</tr>
						<tr>
							<td>CONTENT</td>
							<td>
								<textarea name="noticeContent" class="form-control" cols="30" rows="10"></textarea>
							</td>
						</tr>
						<tr>
							<td>WRITER</td>
							<td><input type="text" name="memberNo" class="form-control" readonly="readonly" value="<%=loginMember.getMemberNo()%>"></td>
						</tr>
					</table>
					<button type="submit" class="btn btn-outline-secondary center-block">글쓰기</button>
				</form>
				
			</div>
			
		</div>
	</div>
</body>
</html>