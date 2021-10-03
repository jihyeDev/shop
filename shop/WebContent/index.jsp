<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index.jsp</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
#rankEbookList {
	background-color : white;
}
#rankEbookList:hover {
	background-color : #28a745;
	color : white;
	box-shadow : 0px 0px 15px rgba(140, 140, 140, 0.75);
	transition : all 0.3s ease-in-out;
	margin-top : -5px;
}
#rankEbookList a {
	color : black;
}
#rankEbookList:hover a {
	color : white;
}
#ctg {
	background-color : #28a745;
}
#cEbookList {
	background-color : white;
}
#cEbookList:hover {
	background-color : #28a745;
	color : white;
	box-shadow : 0px 0px 15px rgba(140, 140, 140, 0.75);
	transition : all 0.3s ease-in-out;
	margin-top : -5px;
}
#cEbookList a {
	color : black;
}
#cEbookList:hover a {
	color : white;
}
</style>
</head>
<body>
	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>
		
		<!-- 메인 페이지 -->
		<%
			System.out.println("----------index.jsp----------");
			request.setCharacterEncoding("utf-8");
			
			// ebookDao 객체 생성
			EbookDao ebookDao = new EbookDao();
			
			// noticeDao 객체 생성
			NoticeDao noticeDao = new NoticeDao();
			
			// categoryDao 객체 생성
			CategoryDao categoryDao = new CategoryDao();
			
			// 인기 목록 4개(많이 주문된 4개의 ebook)
			ArrayList<Ebook> popularEbookList = ebookDao.selectPopularEbookList();
			
			// 최신 전자책 목록 4개(가장 최근 update된 4개의 ebook)
			ArrayList<Ebook> createEbookList = ebookDao.selectCreateEbookList();
			
			// 최근 공지사항 5개 출력
			ArrayList<Notice> noticeList = noticeDao.selectCreateNoticeList();
			
			// categoryName을 다 불러오기 위한 selectCategoryListAllByPage 메서드를 불러옴
			ArrayList<Category> categoryList = categoryDao.selectCategoryListAllByPage();
		%>
		
		
			<!-- 인기목록 -->
			<div class="row rounded-lg" style="background-color : #c9e9b1;">
				<div class="col-sm-12 m-3"><span style="font-size:20px; font-weight:bold; color:#135200;">BESTSELLER</span></div>
		<%
				for(Ebook e : popularEbookList) {
		%>
			    <div class="col-sm-3 p-3" >
			    	<div id="rankEbookList"class="col mr-3 rounded-lg p-4 mb-2">
				    	<div>
	       					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>">
	       						<img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="250">
	       					</a>
	       				</div>
	       				<div class="font-weight-bold mt-2">
	       					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>">
	       						<%=e.getEbookTitle()%>
	       					</a>
	       				</div>
	       				<small class="mt-2"><%=e.getEbookAuthor()%> | <%=e.getEbookCompany()%></small>
	       				<div class="font-weight-bold mt-3"><%=e.getEbookPrice()%><small class="font-weight-normal">원</small></div>
       				</div>
			    </div>
		<%
				}
		%>
			</div>
			
			<div class="row mt-5">
				<!-- 공지사항 출력 -->
				<div class="col-sm-6 p-3">
					<div class="text-center" style="font-size:21px; font-weight:bold;">NOTICE</div>
					<table class="table" style="font-size:14px;">
						<tbody>
							<%
								// noticeList를 출력하는 for문
								for(Notice n : noticeList) {
							%>
									<tr>
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
				
				<div class="col-sm-6 p-3">
					
					<!-- 전자책의 제목으로 검색할 수 있는 기능 추가 -->
					<div class="text-center" style="font-size:21px; font-weight:bold;">SEARCH</div>
						<div class="text-center p-3 mt-3">
							<form action="<%=request.getContextPath()%>/selectEbookList.jsp" method="get">
								<div class="input-group mb-3">
									<input type="text" name="searchEbookTitle" placeholder="SEARCH E-BOOK TITLE" class="form-control">
									<div class="input-group-append">
										<button class="btn btn-dark" type="submit">검색</button>
									</div>
								</div>
							</form>
						</div>
						
					<!-- 카테고리 별로 전자책을 볼 수 있는 버튼 출력 -->
					<div class="text-center" style="font-size:21px; font-weight:bold;">CATEGORY</div>
						<div class="text-center p-3">
						<%
							// categoryList를 출력하는 for문
							for(Category c : categoryList) {
						%>
								<a href="<%=request.getContextPath()%>/selectEbookList.jsp?categoryName=<%=c.getCategoryName()%>" class="btn btn-outline-success p-2">
									<%=c.getCategoryName()%>
								</a>
						<%
							}
						%>
						</div>
						
				</div>
				
			</div>
			
			<!-- 최신목록 -->
			<div class="row rounded-lg mt-5" style="background-color : #f4f4f5;">
				<div class="col-sm-12 m-3"><span style="font-size:20px; font-weight:bold;">LATEST E-BOOK</span></div>
		<%
				for(Ebook e : createEbookList) {
		%>
			    <div class="col-sm-3 p-3" >
			    	<div id="cEbookList"class="col mr-3 rounded-lg p-4 mb-2">
				    	<div>
	       					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>">
	       						<img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="250">
	       					</a>
	       				</div>
	       				<div class="font-weight-bold mt-2">
	       					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>">
	       						<%=e.getEbookTitle()%>
	       					</a>
	       				</div>
	       				<small class="mt-2"><%=e.getEbookAuthor()%> | <%=e.getEbookCompany()%></small>
	       				<div class="font-weight-bold mt-3"><%=e.getEbookPrice()%><small class="font-weight-normal">원</small></div>
       				</div>
			    </div>
		<%
				}
		%>
			</div>
	</div>
</body>
</html>