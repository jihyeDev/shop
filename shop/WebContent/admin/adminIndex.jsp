<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.ArrayList"%>
<%
	System.out.println("----------adminIndex.jsp----------");
	request.setCharacterEncoding("utf-8");

	// adminPage의 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// ebookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
	// memberDao 객체 생성
	MemberDao memberDao = new MemberDao();
	// noticeDao 객체 생성
	NoticeDao noticeDao = new NoticeDao();
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	// orderCommentDao 객체 생성
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	// orderDao 객체 생성
	OrderDao orderDao = new OrderDao();
	
	// 가장 인기 많은 책을 출력하기 위한 ebookDao의 selectPopular 호출
	Ebook popular = ebookDao.selectPopularOrder();
	// 총 매출을 출력하기 위한 ebookDao의 selectTotalEbookPrice 호출
	int totalSales = ebookDao.selectTotalEbookPrice();
	// 총 회원수를 출력하기 위한 memberDao의 selectTotalMember 호출
	int totalMember = memberDao.selectTotalMember();
	
	// 최근 공지사항 중 5개를 출력하기 위한 NoticeDao의 selectCreateNoticeList 호출
	ArrayList<Notice> noticeList = noticeDao.selectCreateNoticeList();
	// 답글이 달리지 않은 QnA를 출력하기 위한 QnaDao의 selectNoCommentQnaList 호출
	ArrayList<Qna> noComment = qnaDao.selectNoCommentQnaList();
	// 최근 올라온 상품평 중 5개를 출력하기 위한 OrderCommentDao의 selectCreateOrderCommentList 호출
	ArrayList<OrderComment> orderCommentList = orderCommentDao.selectCreateOrderCommentList();
	// 최신 주문목록 5개를 출력하기 위한 OrderDao의 selectCreateOrderList 호출
	ArrayList<OrderEbookMember> orderList = orderDao.selectCreateOrderList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>admin.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style type="text/css">
#article1 {
	background-color : #f9f0ff;
}
#article1 a {
	color : #22075e;
}
#article2 {
	background-color : #e6f7ff;
}
#article3 {
	background-color : #f6ffed;
}
</style>
</head>
<body>
	<div class="container-fluid">
		<div class="row">
		
			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
				<h3 class="font-weight-bold">관리자 페이지<small class="font-weight-light text-secondary">_ 관리자 <%=loginMember.getMemberId()%>님</small></h3>
				
				<div class="row mt-3">
				
					<!-- 가장 인기 있는 전자책을 보여줌 -->
					<div id="article1" class="col-sm-3 ml-3 rounded-lg p-4">
						<div style="color:#22075e; font-size:15px;" class="mb-3">Popular ebook</div>
						<div class="row">
							<div class="col-6">
								<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=popular.getEbookNo()%>">
			       					<img src="<%=request.getContextPath()%>/image/<%=popular.getEbookImg()%>" width="130" height="130">
			       				</a>
							</div>
		       				<div class="col-6 font-weight-bold mt-2">
		       					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=popular.getEbookNo()%>">
		       						<span style="font-size:20px;"><%=popular.getEbookTitle()%></span>
		       					</a>
		       					<small class="mt-2"><%=popular.getEbookAuthor()%> | <%=popular.getEbookCompany()%></small>
		       				</div>
		       			</div>
					</div>
					
					<!-- 총 판매 금액을 보여줌 -->
					<div id="article2" class="col-sm-3 ml-3 rounded-lg p-4">
						<div style="color:#00474f; font-size:15px;" class="mb-5">Total sales</div>
						<div style="color:#00474f;" class="text-center">
							<span style="font-size:32px;" class="font-weight-bold"><%=totalSales%></span> <small>원</small>
						</div>
					</div>
					
					<!-- 총 회원의 수를 보여줌 -->
					<div id="article3" class="col-sm-3 ml-3 rounded-lg p-4">
						<div style="color:#135200; font-size:15px;" class="mb-5">Total members</div>
						<div style="color:#135200;" class="text-center">
							<span style="font-size:32px;" class="font-weight-bold"><%=totalMember%></span> <small>명</small>
						</div>
					</div>
					
				</div>
				
				<div class="row mt-3">
					
					<!-- 답글 달리지 않은 QnA -->
					<div class="col-sm-4 m-3 p-4" style="font-size:11px;">
						<div style="font-size:14px;">NO QNA COMMENT</div>
						<table class="table">
							<tbody>
								<%
									// noComment를 출력하는 for문
									for(Qna c : noComment) {
								%>
										<tr>
											<td style="width:10%;"><%=c.getQnaNo()%></td>
											<td>
												<a class="text-body" href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=c.getQnaNo()%>"><%=c.getQnaTitle()%></a>
											</td>
										</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
					
					<!-- 최근공지사항 5개 -->
					<div class="col-sm-4 m-3 p-4" style="font-size:11px;">
						<div style="font-size:14px;">NOTICE</div>
						<table class="table">
							<tbody>
								<%
									// noticeList를 출력하는 for문
									for(Notice n : noticeList) {
								%>
										<tr>
											<td style="width:10%;"><%=n.getNoticeNo()%></td>
											<td>
												<a class="text-body" href="<%=request.getContextPath()%>/selectNoticeOne.jsp?noticeNo=<%=n.getNoticeNo()%>"><%=n.getNoticeTitle()%></a>
											</td>
										</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
					
					<!-- 최근 주문목록 5개 -->
					<div class="col-sm-4 m-3 p-4" style="font-size:11px;">
						<div style="font-size:14px;">NEW ORDER LIST</div>
						<table class="table">
							<tbody>
								<%
									// orderList를 출력하는 for문
									for(OrderEbookMember o : orderList) {
								%>
										<tr>
											<td style="width:10%;"><%=o.getEbook().getEbookNo()%></td>
											<td>
												
												<a class="text-body" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp"><%=o.getEbook().getEbookTitle()%></a>
											</td>
										</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
					
					<!-- 최근 상품평 5개 -->
					<div class="col-sm-4 m-3 p-4" style="font-size:11px;">
						<div style="font-size:14px;">NEW ORDER COMMENT</div>
						<table class="table">
							<tbody>
								<%
									// OrderCommentList를 출력하는 for문
									for(OrderComment o : orderCommentList) {
								%>
										<tr>
											<td style="width:10%;"><%=o.getOrderScore()%></td>
											<td>
												<a class="text-body" href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=o.getEbookNo()%>"><%=o.getOrderCommentContent()%></a>
											</td>
										</tr>
								<%
									}
								%>
							</tbody>
						</table>
					</div>
				</div>
			
			</div>
			
		</div>
	</div>
</body>
</html>