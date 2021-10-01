<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QNA 입력폼</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// 인증 방어 코드 : 로그아웃 상태에서는 페이지 접근 불가
	// session.getAttribute("loginMember") --> null
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(session.getAttribute("loginMember")==null) {
		System.out.println("로그인 한 후 이용 가능합니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
%>
	<div class="container pt-3">

		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		
		<h1 class="bg-white text-center">QnA</h1>
		
		<form method="post" id="qnaForm" action="<%=request.getContextPath()%>/insertQnaAction.jsp">
			<table class="table mt-2">
				<tr>
					<td>TITLE</td>
					<td><input type="text" id="qnaTitle" name="qnaTitle" class="form-control"></td>
				</tr>
				<tr>
					<td>CATEGORY</td>
					<td>
						<select name="qnaCategory" id="qnaCategory">
							<option value="전자책관련">전자책관련</option>
							<option value="개인정보관련">개인정보관련</option>
							<option value="기타">기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>SECRET</td>
					<td><input type="checkbox" id="qnaSecret" name="qnaSecret" value="Y"> 비밀글</td>
				</tr>
				<tr>
					<td>CONTENT</td>
					<td>
						<textarea name="qnaContent" id="qnaContent" class="form-control" cols="30" rows="10"></textarea>
					</td>
				</tr>
			</table>
			<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>">
			<button type="button" id="btn" class="btn btn-outline-secondary center-block float-right">질문하기</button>
		</form>
		<br>
	</div>
	<script>
	$('#btn').click(function(){
		if($('#qnaTitle').val() == '') {
			alert('제목을 입력하세요!');
			return;
		}
		if ($('#qnaContent').val() == '') {
			alert('질문 내용을 입력하세요!');
			return;
		}
		$('#qnaForm').submit();
	})
	</script>
</body>
</html>