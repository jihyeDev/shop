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
</head>
<body>
<%
	System.out.println("----------selectOrderOneByMember.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// memberDao 객체 생성
	MemberDao memberDao = new MemberDao();
	// orderDao 객체 생성
	OrderDao orderDao = new OrderDao();
	// orderCommentDao 객체 생성
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	
	// login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 상세를 확인할 주문 번호(orderNo)를 입력 받았는지 유효성 검사
	if(request.getParameter("orderNo")==null || request.getParameter("orderNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
		return;
	}
	// request 값 저장
	int orderNo = Integer.parseInt(request.getParameter("orderNo"));
	// requst 매개값 디버깅 코드
	System.out.println(orderNo+" <-- orderNo");
	
	// 회원의 session에 저장된 loginMember를 객체로 전환하고
	// 거기에서 회원의 번호를 받아옴
	int memberNo = loginMember.getMemberNo();
	// 디버깅
	System.out.println("memberNo(로그인한 회원의 회원번호)) : "+memberNo);
	
	// 로그인한 회원의 정보를 불러오는 memberDao의 selectMemberOne 메서드를 호출
	Member m = memberDao.selectMemberOne(memberNo);
	
	// 입력받아온 orderNo을 이용해 상세 주문내역을 불러오는 orderDao의 selectOrderOne 메서드를 호출
	// 성공시 : oem 객체에 저장시켜서 출력함
	// 실패시 : null
	OrderEbookMember oem = orderDao.selectOrderOne(orderNo);
	// 디버깅과 실패시 주문내역 목록 페이지로, 성공시 출력
	if(oem==null){
		System.out.println("주문내역 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/selectOrderListByMember.jsp");
	} else {
		System.out.println("주문내역 불러오기 성공");
		System.out.println(oem + "<--- orderDao.selectOrderOne parem : oem");
	}
	
	// 본인의 주문 내역인지 확인하는 방어 코드
	if(m.getMemberNo() != oem.getMember().getMemberNo()){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
	}
%>
	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>

		<div class="bg-white text-center p-4">
			<h1 class="pb-4">MY PAGE</h1>
			<div class="font-weight-bold">상세 주문내역</div>
		</div>

		<!-- 주문한 전자책의 정보를 출력 -->
		<div id="article" class="row rounded-lg p-4 mb-4 mt-4">
		
			<div class="col-sm-4">
				<a class="text-body" href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>">
					<img src="<%=request.getContextPath()%>/image/<%=oem.getEbook().getEbookImg()%>" width="200" height="200">
				</a>
			</div>
			<div class="col-sm-8">
				<div><%=oem.getEbook().getCategoryName()%></div>
				<h3 class="font-weight-bold"><%=oem.getEbook().getEbookTitle()%></h3>
				<small><%=oem.getEbook().getEbookAuthor()%> | <%=oem.getEbook().getEbookCompany()%></small>
				
				<hr>
				
				<table class="mt-5">
					<tr>
						<td style="width:70px;"><small>상태</small></td>
						<td><%=oem.getEbook().getEbookState()%></td>
					</tr>
					<tr>
						<td><small>판매가</small></td>
						<td>
							<span class="font-weight-bold" style="font-size:18px;">
							<%
								/*[설 명]
								 * 1. String.format 을 사용해서 원하는 형태의 문자열로 만들 수 있다
								 * 2. %,(콤마)d - 화폐단위로 정수값을 표시하겠다는 의미이다
								 */
								String price = String.format("%,d", oem.getOrder().getOrderPrice());
							%>
							<%=price%>
							</span><small> 원</small>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<table class="table text-center mt-3">
			<tr>
				<td>ORDER PRICE</td>
				<td>
					<%=price%> 원
				</td>
			</tr>
			<tr>
				<td>ORDER DATE</td>
				<td><%=oem.getOrder().getCreateDate()%></td>
			</tr>
			<tr>
				<td>CANCEL ORDER</td>
				<td>
					<a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/deleteOrderFormByMember.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>">주문취소</a>
					<br>
					<small><span style="color:red;">*</span> 주문취소 신청을 한 뒤에 관리자의 승인으로 취소됩니다.</small>
				</td>
			</tr>
		</table>
		
		<div class="text-center m-4">
			<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/selectOrderListByMember.jsp">목록으로</a>
		</div>	
	</div>
</body>
</html>