<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
#answer {
	background-color : #f4f4f5;
}
</style>
</head>
<body>
<%
	// selectQnaOne.jsp 디버깅 구분선
	System.out.println("----------selectQnaOne.jsp----------");
	request.setCharacterEncoding("utf-8");
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
	// 입력값 방어 코드
	// 상세를 확인할 공지사항 번호(qnaNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("qnaNo")==null || request.getParameter("qnaNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
		return;
	}
		

	// request 값 저장
	int qnaNo = Integer.parseInt(request.getParameter("qnaNo"));
	// requst 매개값 디버깅 코드
	System.out.println(qnaNo+" <-- qnaNo");
	
	// 공지사항을 SELECT하는 qnaDao의 selectQnaOne 메서드
	// 성공시 : returnQna라는 객체에 저장시켜서 출력함
	// 실패시 : null
	Qna returnQna = qnaDao.selecteQnaOne(qnaNo);
	// 디버깅과 실패시 인덱스 페이지로, 성공시 출력
	if(returnQna==null){
		System.out.println("Qna 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
	} else {
		System.out.println("Qna 불러오기 성공");
		System.out.println(returnQna.getQnaNo()+"<--- returnQna.getQnaNo()");
		System.out.println(returnQna.getQnaCategory()+"<--- returnQna.getQnaCategory()");
		System.out.println(returnQna.getQnaSecret()+"<--- returnQna.getQnaSecret()");
		System.out.println(returnQna.getQnaTitle()+"<--- returnQna.getQnaTitle()");
		System.out.println(returnQna.getQnaContent()+"<--- returnQna.getQnaContent()");
		System.out.println(returnQna.getMemberNo()+"<--- returnQna.getMemberNo()");
		System.out.println(returnQna.getCreateDate()+"<--- returnQna.getCreateDate()");
	}
%>

	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>
		
		<h1 class="bg-white text-center">QnA</h1>
		
		<%
			// session에 저장된 loginMember를 받아옴
			Member loginMember = (Member)session.getAttribute("loginMember");
			// Qna가 비밀글일 때
			if(returnQna.getQnaSecret().equals("Y")){
				// 로그인 session이 없을 때 출력해줌
				if(loginMember == null){
		%>
				<div class="text-center">
					<img src="<%=request.getContextPath()%>/image/lock_1.png" width="18" height="18"><br>
					비밀글 입니다. 본인이 작성한 글이라면 <a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a>해주세요.
				</div>
		<%
				} else if(loginMember.getMemberNo() == returnQna.getMemberNo() || loginMember.getMemberLevel() >=1 ){
					// 로그인 세션의 meberNo과 Qna의 memberNo이 같다면 Qna의 상세글 출력해줌
					// 또는 로그인 세션의 memberLevel이 1이상 일 때 Qna의 상세글 출력해줌
		%>
				<table class="table mt-3">
					<tr>
						<td style="width:15%">TITLE</td>
						<td colspan="3"><%=returnQna.getQnaTitle()%></td>
					</tr>
					<tr>
						<td>CATEGORY</td>
						<td colspan="3"><%=returnQna.getQnaCategory()%></td>
					</tr>
					<tr>
						<td>CREATE</td>
						<td><%=returnQna.getCreateDate()%></td>
						<td>SECRET</td>
						<td>
							<%
								if(returnQna.getQnaSecret().equals("Y")){
							%>
									<img src="<%=request.getContextPath()%>/image/lock_1.png" width="18" height="18">
							<%
								} else {
							%>
									<img src="<%=request.getContextPath()%>/image/lock_2.png" width="18" height="18">
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td>CONTENT</td>
						<td colspan="3"><%=returnQna.getQnaContent()%></td>
					</tr>
				</table>
		<%
				} else {
					// login 세션이 있지만 본인이 쓴 글이 아닐 때 출력해줌
		%>
					<div class="text-center">
						<img src="<%=request.getContextPath()%>/image/lock_1.png" width="18" height="18"><br>
						비밀글 입니다.
					</div>
		<%
				}
			} else {
				// Qna가 비밀글이 아닐 때 상세정보 출력
		%>
				<table class="table mt-3">
					<tr>
						<td style="width:15%">TITLE</td>
						<td colspan="3"><%=returnQna.getQnaTitle()%></td>
					</tr>
					<tr>
						<td>CATEGORY</td>
						<td colspan="3"><%=returnQna.getQnaCategory()%></td>
					</tr>
					<tr>
						<td>CREATE</td>
						<td><%=returnQna.getCreateDate()%></td>
						<td>SECRET</td>
						<td>
							<%
								if(returnQna.getQnaSecret().equals("Y")){
							%>
									<img src="<%=request.getContextPath()%>/image/lock_1.png" width="18" height="18">
							<%
								} else {
							%>
									<img src="<%=request.getContextPath()%>/image/lock_2.png" width="18" height="18">
							<%
								}
							%>
						</td>
					</tr>
					<tr>
						<td>CONTENT</td>
						<td colspan="3"><%=returnQna.getQnaContent()%></td>
					</tr>
				</table>
		<%
			}
		%>
		
		<div>
		<%
			// qna 질문글의 작성자가 글쓴이라면 수정, 삭제 버튼을 누를수 있게끔 추가
			if(loginMember.getMemberNo() == returnQna.getMemberNo()){
		%>
				<div class="text-center">
					<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/updateQnaForm.jsp">수정</a>
					<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/deleteQna.jsp">삭제</a>
				</div>
		<%
			}
			
		%>
		</div>
		
		<div>
		<%
			// qna의 답변을 SELECT하는 qnaCommentDao의 selectQnaComment 메서드
			// 성공시 : comment 객체에 저장시켜서 출력함
			// 실패시 : null
			QnaCommentDao qnaCommentDao = new QnaCommentDao();
			QnaComment comment = qnaCommentDao.selectQnaComment(qnaNo);
			if(comment!=null) {
				// 답변이 있을 때 출력
		%>
				<div id="answer" class="mt-3 rounded-lg p-4 mb-2">
					<div><%=comment.getQnaCommentContent()%></div>
					| <%=comment.getCreateDate()%>
				</div>
		<%
			} else {
				// 관리자 로그인이 되어있다면 QnA에 답글 달기
				// adminPage의 방어코드
				// loginMember가 null이 아니거나 memberLevel이 1이상 일 때 QnA의 코멘트 다는 창이 나옴
				if(loginMember != null && loginMember.getMemberLevel() >= 1) {
		%>
					<div>
						<form action="<%=request.getContextPath()%>/admin/insertQnaCommentAction.jsp" method="post">
							<input type="hidden" name="qnaNo" value="<%=returnQna.getQnaNo()%>">
							<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>">
							<div class="mt-4 font-weight-bold">ANSWER</div>
							<textarea name="qnaCommentContent" class="form-control" rows="5" placeholder="답변을 입력해주세요."></textarea>
							<button class="btn btn-dark float-right" type="submit">입력</button>
						</form>
					</div>
		<%
				}
			}
		%>
		
		</div>
		
		
	</div>
</body>
</html>