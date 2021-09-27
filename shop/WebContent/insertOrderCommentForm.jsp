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
#article {
	background-color : #f4f4f5;
}
</style>
</head>
<body>
<%
	System.out.println("----------insertOrderCommentForm.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// ebookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
	
	//login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 후기 입력값 유효성 검사
	if(request.getParameter("orderNo")==null || request.getParameter("ebookNo")==null || request.getParameter("orderNo").equals("") || request.getParameter("ebookNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}
	
	// request 값 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	
	// requst 매개값 디버깅 코드
	System.out.println(orderNo+"<-- orderNo");
	System.out.println(ebookNo+"<-- ebookNo");
	
	// 주문한 전자책의 정보를 불러오는 selectEbookOne 메서드 호출
	// 성공시 : returnEbook라는 객체에 저장시켜서 출력함
	// 실패시 : null
	Ebook returnEbook = ebookDao.selecteEbookOne(ebookNo);
	// 디버깅과 실패시 인덱스 페이지로, 성공시 출력
	if(returnEbook==null){
		System.out.println("전자책 정보 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/selectEbookList.jsp");
	} else {
		System.out.println("전자책 정보 불러오기 성공");
		System.out.println(returnEbook.getEbookNo()+"<--- returnMember.getEbookNo()");
		System.out.println(returnEbook.getEbookISBN()+"<--- returnMember.getEbookISBN()");
		System.out.println(returnEbook.getCategoryName()+"<--- returnMember.getCategoryName()");
		System.out.println(returnEbook.getEbookTitle()+"<--- returnMember.getEbookTitle()");
		System.out.println(returnEbook.getEbookAuthor()+"<--- returnMember.getEbookAuthor()");
		System.out.println(returnEbook.getEbookCompany()+"<--- returnMember.getEbookCompany()");
		System.out.println(returnEbook.getEbookPageCount()+"<--- returnMember.getEbookPageCount()");
		System.out.println(returnEbook.getEbookPrice()+"<---returnMember.getEbookPrice()");
		System.out.println(returnEbook.getEbookImg()+"<---returnMember.getEbookImg()");
		System.out.println(returnEbook.getEbookSummary()+"<---returnMember.getEbookSummary()");
		System.out.println(returnEbook.getEbookState()+"<---returnMember.getEbookState()");
		System.out.println(returnEbook.getUpdateDate()+"<---returnMember.getUpdateDate()");
		System.out.println(returnEbook.getCreateDate()+"<---returnMember.getCreateDate()");
	}
%>
	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>
		<!-- comment를 달을 전자책의 정보를 출력 -->
		<div id="article" class="row rounded-lg p-4 mb-4 mt-4">
		
			<div class="col-sm-4">
				<img src="<%=request.getContextPath()%>/image/<%=returnEbook.getEbookImg()%>" width="200" height="200">
			</div>
			<div class="col-sm-8">
				<div><%=returnEbook.getCategoryName()%></div>
				<h3 class="font-weight-bold"><%=returnEbook.getEbookTitle()%></h3>
				<small><%=returnEbook.getEbookAuthor()%> | <%=returnEbook.getEbookCompany()%></small>
				
				<hr>
				
				<table class="mt-5">
					<tr>
						<td style="width:70px;"><small>상태</small></td>
						<td><%=returnEbook.getEbookState()%></td>
					</tr>
					<tr>
						<td><small>판매가</small></td>
						<td><span class="font-weight-bold" style="font-size:18px;"><%=returnEbook.getEbookPrice()%></span><small>원</small></td>
					</tr>
				</table>
			</div>
		
		</div>
		
		<!-- comment 입력 폼 -->
		<div>
			<form method="post" action="<%=request.getContextPath()%>/insertOrderCommentAction.jsp">
				<input type="hidden" name="orderNo" value="<%=orderNo%>">
				<input type="hidden" name="ebookNo" value="<%=ebookNo%>">
				<table class="table mt-5">
					<tr>
						<td>SCORE</td>
						<td>10/<input type="text" name="orderScore"></td>
					</tr>
					<tr>
						<td>COMMENT</td>
						<td><textarea name="orderCommentContent" class="form-control"></textarea>
					</tr>
				</table>
				<button class="btn btn-success" type="submit">입력</button>
			</form>
		</div>
	
	</div>
</body>
</html>