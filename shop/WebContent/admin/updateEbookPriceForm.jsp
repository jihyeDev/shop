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
	// updateEbookPriceForm.jsp 디버깅 구분선
	System.out.println("----------updateEbookPriceForm.jsp----------");
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
	// 가격을 수정할 전자책의 ebookNo을 입력 받았는지 유효성 검사
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
	// 디버깅과 실패시 인덱스 페이지로, 성공시 출력
	if(returnEbook==null){
		System.out.println("전자책 정보 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookOne.jsp?ebookNo="+ebookNo);
	} else {
		System.out.println("전자책 정보 불러오기 성공");
		System.out.println(returnEbook.getEbookNo()+"<--- returnEbook.getEbookNo()");
		System.out.println(returnEbook.getEbookTitle()+"<--- returnEbook.getEbookTitle()");
		System.out.println(returnEbook.getEbookImg()+"<---returnEbook.getEbookImg()");
		System.out.println(returnEbook.getEbookPrice()+"<---returnEbook.getEbookPrice()");
		System.out.println(returnEbook.getUpdateDate()+"<---returnEbook.getUpdateDate()");
		System.out.println(returnEbook.getCreateDate()+"<---returnEbook.getCreateDate()");
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
				<h3 class="font-weight-bold">전자책 관리 <small class="font-weight-light text-secondary">_ 가격 수정</small></h3>
				
				<form action="<%=request.getContextPath()%>/admin/updateEbookPriceAction.jsp" method="post">
					<table class="table mt-5 w-50">
						<tr>
							<td>NO</td>
							<td>
								<%=returnEbook.getEbookNo()%>
								<input type="hidden" name="ebookNo" value="<%=returnEbook.getEbookNo()%>">
							</td>
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
							<td>PRICE</td>
							<td><%=returnEbook.getEbookPrice()%> 원</td>
						</tr>
						<tr>
							<td>NEW PRICE <span class="text-danger">*</span></td>
							<td><input type="text" name="ebookPrice"> 원</td>
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
				
				<button type="submit" class="btn btn-outline-secondary center-block">가격수정</button>
				<br>
				</form>
				
			</div>
			
		</div>
	</div>
</body>
</html>