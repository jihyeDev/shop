<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QNA</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	//updateQnaForm.jsp 디버깅 구분선
	System.out.println("----------updateQnaForm.jsp----------");
	request.setCharacterEncoding("utf-8");
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();

	// 인증 방어 코드 : 로그아웃 상태에서는 페이지 접근 불가
	// session.getAttribute("loginMember") --> null
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null) {
		System.out.println("로그인 한 후 이용 가능합니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
	
	// 입력값 방어 코드
	// 수정할 QnA 번호(qnaNo)를 입력 받았는지 유효성 검사
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
	
	// 방어코드
	// QnaNo로 불러온 Qna의 정보에 있는 returnQna.getMemberNo()과 로그인 세션에 저장된 loginMember.getMemberNo()가 같아야 페이지 접속 가능
	if(returnQna.getMemberNo() != loginMember.getMemberNo()) {
		response.sendRedirect(request.getContextPath()+"/selectQnaList.jsp");
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
		
		<form method="post" id="qnaForm" action="<%=request.getContextPath()%>/updateQnaAction.jsp">
			<table class="table mt-2">
				<tr>
					<td>TITLE</td>
					<td><input type="text" id="qnaTitle" name="qnaTitle" class="form-control"  value="<%=returnQna.getQnaTitle()%>"></td>
				</tr>
				<tr>
					<td>CATEGORY</td>
					<td>
						<%
							// CATEGORY를 설정하는 select를 수정하기 전의 카테고리로
							// selected 하기 위해 배열로 생성하여 비교
							// "selected" 문자열을 저장하기 위한 용도의 배열
							String[] categorySelected = new String[3];
							if((returnQna.getQnaCategory()).equals("전자책관련")){
								categorySelected[0] = "selected";
							} else if((returnQna.getQnaCategory()).equals("개인정보관련")){
								categorySelected[1] = "selected";
							} else if((returnQna.getQnaCategory()).equals("기타")){
								categorySelected[2] = "selected";
							}
						%>
						<select name="qnaCategory" id="qnaCategory">
							<option value="전자책관련" <%=categorySelected[0]%>>전자책관련</option>
							<option value="개인정보관련" <%=categorySelected[1]%>>개인정보관련</option>
							<option value="기타" <%=categorySelected[2]%>>기타</option>
						</select>
					</td>
				</tr>
				<tr>
					<td>SECRET</td>
					<td>
						<%
						if((returnQna.getQnaSecret()).equals("Y")){
						%>
							<input type="checkbox" id="qnaSecret" name="qnaSecret" value="Y" checked> 비밀글
						<%
						} else {
						%>
							<input type="checkbox" id="qnaSecret" name="qnaSecret" value="Y"> 비밀글
						<%
						}
						%>
					</td>
				</tr>
				<tr>
					<td>CONTENT</td>
					<td>
						<textarea name="qnaContent" id="qnaContent" class="form-control" cols="30" rows="10"><%=returnQna.getQnaContent()%></textarea>
					</td>
				</tr>
			</table>
			<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo()%>">
			<input type="hidden" name="qnaNo" value="<%=returnQna.getQnaNo()%>">
			<button type="button" id="btn" class="btn btn-outline-secondary center-block float-right">수정하기</button>
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