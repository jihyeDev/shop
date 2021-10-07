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
	System.out.println("----------selectOrderListByMember.jsp----------");
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
	
	// 회원의 session에 저장된 loginMember를 객체로 전환하고
	// 거기에서 회원의 번호를 받아옴
	int memberNo = loginMember.getMemberNo();
	// 디버깅
	System.out.println("memberNo(로그인한 회원의 회원번호)) : "+memberNo);
	
	// 로그인한 회원의 정보를 불러오는 memberDao의 selectMemberOne 메서드를 호출
	Member m = memberDao.selectMemberOne(memberNo);
	
	// 로그인한 회원의 전체 주문 목록을 불러오는 orderDao의 selectOrderListByMember 메서드를 호출
	// orderList라는 리스트를 사용하기 위해 생성
	ArrayList<OrderEbookMember> orderList = orderDao.selectOrderListByMember(memberNo);
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
			<div class="font-weight-bold"><%=m.getMemberName()%>(<%=m.getMemberId()%>)님</div>
			<span style="font-size:12px;">
				<%
					// LEVEL별로 무슨 등급인지 출력하는 if문
					if(m.getMemberLevel() == 0) {
				%>
						회원 Level.<%=m.getMemberLevel()%>
				<%
					} else {
				%>
						관리자 Level.<%=m.getMemberLevel()%>
				<%
					}
				%>
			</span>
		</div>

		<table class="table table-hover">
			<thead>
				<tr>
					<th style="width:40%;">E-BOOK</th>
					<th class="text-center">PRICE</th>
					<th class="text-center">ORDER DATE</th>
					<th class="text-center">주문내역</th>
					<th class="text-center">후기작성</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(OrderEbookMember oem : orderList) {
				%>
						<tr>
							<td><a class="text-body" href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=oem.getEbook().getEbookNo()%>"><%=oem.getEbook().getEbookTitle()%></a></td>
							<td class="text-center">
								<%
									/*[설 명]
									 * 1. String.format 을 사용해서 원하는 형태의 문자열로 만들 수 있다
									 * 2. %,(콤마)d - 화폐단위로 정수값을 표시하겠다는 의미이다
									 */
									String price = String.format("%,d", oem.getOrder().getOrderPrice());
								%>
								<%=price%> 원
							</td>
							<td class="text-center"><%=oem.getOrder().getCreateDate()%></td>
							<td class="text-center"><a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/selectOrderOneByMember.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>">주문내역</a></td>
							<td class="text-center">
				<%
							// 전자책 구입 후기 중복입력 방지 메서드 = 중복 : result = true, 중복X(후기작성가능) : false
							// 이미 후기를 입력했을 시 주문 후기 입력창 연결 X
							boolean commentCheck = false;
							if(commentCheck = orderCommentDao.insertOrderCommentCheck(oem.getOrder().getOrderNo(),oem.getEbook().getEbookNo())) {
				%>
								<span class="badge badge-secondary">후기작성완료</span>
				<%
							} else {
				%>
								<a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>&ebookNo=<%=oem.getEbook().getEbookNo()%>">후기작성</a>
				<%
							}
				%>
							</td>
						</tr>
				<%		
					}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>