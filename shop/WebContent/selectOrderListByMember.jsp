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

		<h1>나의 주문 목록</h1>
		<table border="1">
			<thead>
				<tr>
					<th>orderNo</th>
					<th>ebookTitle</th>
					<th>orderPrice</th>
					<th>createDate</th>
					<th>memberId</th>
					<th>상세주문내역</th>
					<th>ebook후기</th>
				</tr>
			</thead>
			<tbody>
				<%
					for(OrderEbookMember oem : orderList) {
				%>
						<tr>
							<td><%=oem.getOrder().getOrderNo()%></td>
							<td><%=oem.getEbook().getEbookTitle()%></td>
							<td><%=oem.getOrder().getOrderPrice()%></td>
							<td><%=oem.getOrder().getCreateDate()%></td>
							<td><%=oem.getMember().getMemberId()%></td>
							<td><a href="">상세주문내역</a></td>
							<td>
				<%
							// 전자책 구입 후기 중복입력 방지 메서드 = 중복 : result = true, 중복X(후기작성가능) : false
							// 이미 후기를 입력했을 시 주문 후기 입력창 연결 X
							boolean commentCheck = false;
							if(commentCheck = orderCommentDao.insertOrderCommentCheck(oem.getOrder().getOrderNo(),oem.getEbook().getEbookNo())) {
				%>
								후기입력완료
				<%
							} else {
				%>
								<a href="<%=request.getContextPath()%>/insertOrderCommentForm.jsp?orderNo=<%=oem.getOrder().getOrderNo()%>&ebookNo=<%=oem.getEbook().getEbookNo()%>">ebook후기</a>
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