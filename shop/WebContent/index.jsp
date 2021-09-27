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
		
		<h1 class="jumbotron bg-white text-center">메인페이지</h1>
		
		<!-- 상품 목록 -->
		<%
			System.out.println("----------index.jsp----------");
			request.setCharacterEncoding("utf-8");
			
			// ebookDao 객체 생성
			EbookDao ebookDao = new EbookDao();
			
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
			
			// 목록
			// 검색을 하지 않았을 때는 전체 전자책을 SELECT하고, 페이징하는 ebookDao의 selectEbookList메서드 호출
			// 검색을 했을 때는 LIKE 연산자를 사용한 sql문을 실행하고 리스트를 리턴한 selectEbookListByCategory메서드 호출
			// ebookList라는 리스트를 사용하기 위해 생성
			ArrayList<Ebook> ebookList = new ArrayList<Ebook>();
			if(searchEbookTitle.equals("")) { // 검색을 하지 않았을 때
				ebookList = ebookDao.selectEbookList(beginRow, ROW_PER_PAGE);
			} else { // 검색을 했을 때
				ebookList = ebookDao.selectEbookListBySearch(beginRow, ROW_PER_PAGE, searchEbookTitle);
			} 
		%>
			<div class="row">
		<%
				for(Ebook e : ebookList) {
		%>
			    <div class="col-sm-3 p-3" >
			    	<div id="ebookList"class="col mr-3 rounded-lg p-4 mb-2">
				    	<div>
	       					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=e.getEbookNo()%>">
	       						<img src="<%=request.getContextPath()%>/image/<%=e.getEbookImg()%>" width="200" height="200">
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
		<%
			// 마지막 페이지(lastPage)를 구하는 ebookDao의 메서드 호출
			// int 타입의 lastPage에 저장
			// 검색을 하지 않았을 때는 전체 행을 COUNT 하는 selectEbookListLastPage메서드 호출
			// 검색을 했을 때는 LIKE 연산자를 사용한 sql문을 실행하고 lastPage를 리턴하는 selectEbookListByCategoryLastPage메서드 호출
			int lastPage;
			if(searchEbookTitle.equals("")) { // 검색을 하지 않았을 때
				lastPage = ebookDao.selectEbookListLastPage(ROW_PER_PAGE);
			} else { // 검색을 했을 때
				lastPage = ebookDao.selectEbookListBySearchLastPage(ROW_PER_PAGE,searchEbookTitle);
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
					
			// 처음으로 버튼
			// 제일 첫번째 페이지로 이동할때 = 1 page로 이동
			if(currentPage != 1){
			%>
				<a href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=1%>&searchEbookTitle=<%=searchEbookTitle%>" class="btn btn-outline-secondary center-block">◀처음</a>
			<%
			}
				
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(startPage > displayPage){
			%>
				<a href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=startPage-displayPage%>&searchEbookTitle=<%=searchEbookTitle%>" class="btn btn-outline-secondary">&lt;이전</a>
			<%
			}
						
			// 페이징버튼
			// 화면에 보여질 시작 페이지 번호를 화면에 보여질 마지막 페이지 번호까지 반복하면서 페이지 번호 생성
			// 만약에 화면에 보여질 마지막 페이지 번호가 마지막 페이지보다 크다면 for문을 break로 종료시킴
			for(int i=startPage; i<=endPage; i++){
				if(currentPage == i){
			%>
					<a href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=i%>&searchEbookTitle=<%=searchEbookTitle%>" class="btn btn-secondary"><%=i%></a>
			<%
				} else if(endPage<lastPage || endPage == lastPage){
			%>
					<a href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=i%>&searchEbookTitle=<%=searchEbookTitle%>" class="btn btn-outline-secondary"><%=i%></a>
			<%	
				} else if(endPage>lastPage){
					break;
				}
			}
				
			// 다음 버튼
			// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
			if(endPage < lastPage){
			%>
				<a href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=startPage+displayPage%>&searchEbookTitle=<%=searchEbookTitle%>" class="btn btn-outline-secondary">다음></a>
			<%
				}
						
			// 끝으로 버튼
			// 가장 마지막 페이지로 바로 이동하는 버튼
			if(currentPage != lastPage){
			%>
				<a href="<%=request.getContextPath()%>/index.jsp?currentPage=<%=lastPage%>&searchEbookTitle=<%=searchEbookTitle%>" class="btn btn-outline-secondary">끝▶</a>
			<%
			}
			%>
		
	</div>
</body>
</html>