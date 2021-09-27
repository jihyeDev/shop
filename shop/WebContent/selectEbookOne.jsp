<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
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
	// selectEbookOne.jsp 디버깅 구분선
	System.out.println("----------selectEbookOne.jsp----------");
	request.setCharacterEncoding("utf-8");
	// ebookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
	
	// 입력값 방어 코드
	// 레벨을 수정할 특정회원의 ebookNo을 입력 받았는지 유효성 검사
	if(request.getParameter("ebookNo")==null || request.getParameter("ebookNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectEbookList.jsp");
		return;
	}
		

	// request 값 저장
	int ebookNo = Integer.parseInt(request.getParameter("ebookNo"));
	// requst 매개값 디버깅 코드
	System.out.println(ebookNo+" <-- ebookNo");
	
	// 특정전자책의 정보를 SELECT하는 ebookDao의 selectEbookOne 메서드
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
		
		<h1 class="bg-white text-center">상품페이지</h1>
		
		<div id="article" class="row rounded-lg p-4 mb-4 mt-4">
		
			<div class="col-sm-4">
				<img src="<%=request.getContextPath()%>/image/<%=returnEbook.getEbookImg()%>" width="330" height="450">
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
		
		<div>
			<div>총 페이지 <%=returnEbook.getEbookPageCount()%></div>
			<div><%=returnEbook.getEbookSummary()%></div>
			<div>출판 <%=returnEbook.getCreateDate()%> | 업데이트 <%=returnEbook.getUpdateDate()%></div>
		</div>
	
	</div>
</body>
</html>