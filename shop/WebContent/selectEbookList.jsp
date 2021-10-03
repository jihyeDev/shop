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
#ebookList {
	background-color : #f4f4f5;
}
#ebookList:hover {
	background-color : #28a745;
	color : white;
	box-shadow : 0px 0px 15px rgba(140, 140, 140, 0.75);
	transition : all 0.3s ease-in-out;
	margin-top : -5px;
}
#ebookList a {
	color : black;
}
#ebookList:hover a {
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
		
		<!-- 상품 목록 -->
		<%
			System.out.println("----------selectEbookList.jsp----------");
			request.setCharacterEncoding("utf-8");
			
			// ebookDao 객체 생성
			EbookDao ebookDao = new EbookDao();
			
			// categoryName을 다 불러오기 위한 selectCategoryListAllByPage 메서드를 불러옴
			CategoryDao categoryDao = new CategoryDao();
			ArrayList<Category> categoryList = categoryDao.selectCategoryListAllByPage();

			// categoryName는 무조건 공백("")인데 값이 넘어오면 변경
			String categoryName = "";
			if(request.getParameter("categoryName")!=null) { 
				categoryName = request.getParameter("categoryName");
			}
			// 디버깅
			System.out.println("categoryName(선택한 카테고리) : "+categoryName);
			
			// 검색어
			String searchEbookTitle = "";
			// searchEbookTitle이 null이 아니라면 값을 받아서 검색어(searchEbookName)로 사용
			if(request.getParameter("searchEbookTitle") != null) { 
				searchEbookTitle = request.getParameter("searchEbookTitle");
			}
			// 디버깅
			System.out.println("searchEbookTitle(검색어) : "+searchEbookTitle);
			
			// 페이징
			// 페이지번호 = 전달 받은 값이 없으면 currentPage를 1로 디폴트
			int currentPage = 1;
			// current가 null이 아니라면 값을 int 타입으로로 바꾸어서 페이지 번호로 사용
			if(request.getParameter("currentPage") != null) { 
				currentPage = Integer.parseInt(request.getParameter("currentPage"));
			}
			// 디버깅
			System.out.println("currentPage(현재 페이지 번호) : "+currentPage);
			
			// limit 값 설정 beginRow부터 rowPerPage만큼 보여주세요
			// ROW_PER_PAGE 변수를 상수로 설정하여서 10으로 초기화하면 끝까지 10이다.
			final int ROW_PER_PAGE = 20;
			int beginRow = (currentPage-1) * ROW_PER_PAGE;
			
			// 전체 목록
			// 선택된 카테고리가 없을때는 전체 전자책을 SELECT하고, 페이징하는 ebookDao의 selectEbookList메서드 호출
			// 선택된 카테고리가 있을때는 where를 사용한 sql문을 실행하고 리스트를 리턴한 selectEbookListByCategory메서드 호출
			// 검색어가 있을 때는 검색어를 넘겨서 검색한뒤 return해주는 selectEbookListBySearch메서드 호출
			// ebookList라는 리스트를 사용하기 위해 생성
			ArrayList<Ebook> ebookList = new ArrayList<Ebook>();
			if(request.getParameter("searchEbookTitle") != null) { // 검색어가 있을때
				ebookList = ebookDao.selectEbookListBySearch(searchEbookTitle);
			} else if(categoryName.equals("")) { // 선택된 카테고리가 없을때
				ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE);
			}else { // 선택된 카테고리가 있을때
				ebookList = ebookDao.selectEbookListByCategory(beginRow, ROW_PER_PAGE, categoryName);
			}
		%>
		
			<div class="bg-white text-center p-4">
				<h1>E-BOOK</h1>
				<small class="text-secondary">
					<%
						if(categoryName.equals("")){
					%>
						전체보기
					<%
						}
					%>
					<%=categoryName%>
				</small>
				<!-- ebook_title로 검색 -->
				<div class="mt-4">
					<form action="<%=request.getContextPath()%>/selectEbookList.jsp" method="get">
						<div class="input-group">
							<input type="text" name="searchEbookTitle" placeholder="SEARCH E-BOOK TITLE" class="form-control">
							<div class="input-group-append">
								<button class="btn btn-dark" type="submit">검색</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		
			<!-- categoryName으로 정렬 -->
			<div class="text-center">
				<a href="<%=request.getContextPath()%>/selectEbookList.jsp" class="btn btn-success btn-sm">전체보기</a>
				<%
       				for(Category c : categoryList) {
 				%>
						<a href="<%=request.getContextPath()%>/selectEbookList.jsp?categoryName=<%=c.getCategoryName()%>" class="btn btn-success btn-sm"><%=c.getCategoryName()%></a>
				<%
       				}
				%>
   			</div>
			
			<!-- 전체 상품 목록 -->
			<div class="row">
		<%
				for(Ebook e : ebookList) {
		%>
			    <div class="col-sm-3 p-3" >
			    	<div id="ebookList"class="col mr-3 rounded-lg p-4 mb-2">
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
			
			<!-- 페이징 버튼 -->
			<div class="text-center mb-4">
				<%
					// 마지막 페이지(lastPage)를 구하는 ebookDao의 메서드 호출
					// int 타입의 lastPage에 저장
					// 선택된 카테고리가 없을때는 전체 행을 COUNT 하는 selectEbookListLastPage메서드 호출
					// 선택된 카테고리가 있을때는 LIKE 연산자를 사용한 sql문을 실행하고 lastPage를 리턴하는 selectEbookListByCategoryLastPage메서드 호출
					int lastPage;
					if(categoryName.equals("") == true) { // 선택된 카테고리가 없을때
						lastPage = ebookDao.selectEbookListLastPage(ROW_PER_PAGE);
					} else { // 선택된 카테고리가 있을때
						lastPage = ebookDao.selectEbookListByCategoryLastPage(ROW_PER_PAGE,categoryName);
					}
					
					// 화면에 보여질 페이지 번호의 갯수
					int displayPage = 10;
					
					// 화면에 보여질 시작 페이지 번호
					// ((현재페이지번호 - 1) / 화면에 보여질 페이지 번호) * 화면에 보여질 페이지 번호 + 1
					// (currentPage - 1)을 하는 이유는 현재페이지가 10일시에도 startPage가 1이기 위해서
					int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
			
					// 화면에 보여질 마지막 페이지 번호
					// 만약에 마지막 페이지 번호(lastPage)가 화면에 보여질 페이지 번호(displayPage)보다 작다면 화면에 보여질 마지막 페이지번호(endPage)를 조정한다
					// 화면에 보여질 시작 페이지 번호 + 화면에 보여질 페이지 번호 - 1
					// -1을 하는 이유는 페이지 번호의 갯수가 10개이기 때문에 statPage에서 더한 1을 빼준다
					int endPage = 0;
					if(lastPage<displayPage){
						endPage = lastPage;
					} else if (lastPage>=displayPage){
						endPage = startPage + displayPage - 1;
					}
					
					// 디버깅
					System.out.println("startPage(화면에 보여질 시작 페이지 번호) : "+startPage+", endPage(화면에 보여질 마지막 페이지 번호) : "+endPage);
					
					// 검색어가 있을 시 페이징 버튼이 안나오게 하는 if문
					// return을 사용해 이후의 코드들을 실행 못하게 해줌
					if(searchEbookTitle.equals("") == false) {
						return;
					}
					
					// 처음으로 버튼
					// 제일 첫번째 페이지로 이동할때 = 1 page로 이동
					if(currentPage != 1){
				%>
						<a href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=1%>&categoryName=<%=categoryName%>" class="btn btn-outline-secondary center-block">◀처음</a>
				<%
					}
			
					// 이전 버튼
					// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
					if(startPage > displayPage){
				%>
						<a href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=startPage-displayPage%>&categoryName=<%=categoryName%>" class="btn btn-outline-secondary">&lt;이전</a>
				<%
					}
					
					// 페이징버튼
					// 화면에 보여질 시작 페이지 번호를 화면에 보여질 마지막 페이지 번호까지 반복하면서 페이지 번호 생성
					// 만약에 화면에 보여질 마지막 페이지 번호가 마지막 페이지보다 크다면 for문을 break로 종료시킴
					for(int i=startPage; i<=endPage; i++){
						if(currentPage == i){
				%>
							<a href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>" class="btn btn-secondary"><%=i%></a>
				<%
						} else if(endPage<lastPage || endPage == lastPage){
				%>
							<a href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>" class="btn btn-outline-secondary"><%=i%></a>
				<%	
						} else if(endPage>lastPage){
							break;
						}
					}
			
					// 다음 버튼
					// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
					if(endPage < lastPage){
				%>
						<a href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=startPage+displayPage%>&categoryName=<%=categoryName%>" class="btn btn-outline-secondary">다음></a>
				<%
					}
					
					// 끝으로 버튼
					// 가장 마지막 페이지로 바로 이동하는 버튼
					if(currentPage != lastPage && endPage != 0){
				%>
						<a href="<%=request.getContextPath()%>/selectEbookList.jsp?currentPage=<%=lastPage%>&categoryName=<%=categoryName%>" class="btn btn-outline-secondary">끝▶</a>
				<%
					}
				%>
		
			</div>
		
	</div>
</body>
</html>