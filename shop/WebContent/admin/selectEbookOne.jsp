<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// selectEbookOne.jsp 디버깅 구분선
	System.out.println("----------selectEbookOne.jsp----------");
	request.setCharacterEncoding("utf-8");
	// ebookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 레벨을 수정할 특정회원의 ebookNo을 입력 받았는지 유효성 검사
	if(request.getParameter("ebookNo")==null || request.getParameter("ebookNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp");
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
	// 디버깅과 실패시 전자책 관리 페이지로, 성공시 출력
	if(returnEbook==null){
		System.out.println("전자책 정보 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp");
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

	<div class="container-fluid">
		<div class="row">

			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
				<h3 class="font-weight-bold">전자책 관리 <small class="font-weight-light text-secondary">_ <%=returnEbook.getEbookTitle()%></small></h3>
			
				<table class="table mt-5 w-50">
					<tr>
						<td>NO</td>
						<td><%=returnEbook.getEbookNo()%></td>
					</tr>
					<tr>
						<td>TITLE</td>
						<td><%=returnEbook.getEbookTitle()%></td>
					</tr>
					<tr>
						<td>IMG</td>
						<td><img src="<%=request.getContextPath()%>/image/<%=returnEbook.getEbookImg()%>"></td>
					</tr>
					<tr>
						<td>AUTHOR</td>
						<td><%=returnEbook.getEbookAuthor()%></td>
					</tr>
					<tr>
						<td>CATEGORY</td>
						<td><%=returnEbook.getCategoryName()%></td>
					</tr>
					<tr>
						<td>SUMMARY</td>
						<td><%=returnEbook.getEbookSummary()%></td>
					</tr>
					<tr>
						<td>ISBN</td>
						<td><%=returnEbook.getEbookISBN()%></td>
					</tr>
					<tr>
						<td>COMPANY</td>
						<td><%=returnEbook.getEbookCompany()%></td>
					</tr>
					<tr>
						<td>PAGECOUNT</td>
						<td><%=returnEbook.getEbookPageCount()%></td>
					</tr>
					<tr>
						<td>STATE</td>
						<td><%=returnEbook.getEbookState()%></td>
					</tr>
					<tr>
						<td>PRICE</td>
						<td><%=returnEbook.getEbookPrice()%> 원</td>
					</tr>
					<tr>
						<td>UPDATE</td>
						<td><%=returnEbook.getUpdateDate()%></td>
					</tr>
					<tr>
						<td>CREATE</td>
						<td><%=returnEbook.getCreateDate()%></td>
					</tr>
					
				</table>
				
				<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/selectEbookList.jsp">전자책목록</a>
				<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/updateEbookImgForm.jsp?ebookNo=<%=returnEbook.getEbookNo()%>">이미지수정</a>
				<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/updateEbookPriceForm.jsp?ebookNo=<%=returnEbook.getEbookNo()%>">가격수정</a>
				<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/deleteEbookForm.jsp?ebookNo=<%=returnEbook.getEbookNo()%>">삭제</a>
				<br>
				
			</div>
			
		</div>
	</div>
</body>
</html>