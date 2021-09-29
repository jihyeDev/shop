<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QNA 목록</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<%
	System.out.println("----------selectQnaList.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// QnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
	// 검색어
	String searchQnaTitle = "";
	// searchQnaTitle이 null이 아니라면 값을 받아서 검색어(searchQnaTitle)로 사용
	if(request.getParameter("searchQnaTitle") != null) { 
		searchQnaTitle = request.getParameter("searchQnaTitle");
	}
	// 디버깅
	System.out.println("searchQnaTitle(검색어) : "+searchQnaTitle);
	
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
	final int ROW_PER_PAGE = 10;
	int beginRow = (currentPage-1) * ROW_PER_PAGE;
	
	// 검색어가 없을때는 전체 QNA을 SELECT하고, 페이징하는 qnaDao의 selectQnaList 메서드 호출
	// 검색어가 있을때는 Like를 사용한 sql문을 실행하고 리스트를 리턴한 selectQnaListBySearch 메서드 호출
	// qnaList라는 리스트를 사용하기 위해 생성
	ArrayList<Qna> qnaList = new ArrayList<Qna>();
	if(searchQnaTitle.equals("") == true) { // 검색어가 없을 때
		qnaList = qnaDao.selectQnaList(beginRow, ROW_PER_PAGE);
	}else { // 검색어가 있을때
		qnaList = qnaDao.selectQnaListBySearch(beginRow, ROW_PER_PAGE, searchQnaTitle);
	}
%>
	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>
		
		<h1 class="jumbotron bg-white text-center">QnA</h1>
		
		<div class="text-center">
			<!-- qna_title로 검색 -->
			<div class="text-center">
				<form action="<%=request.getContextPath()%>/selectQnaList.jsp" method="get">
					SEARCH <input type="text" name="searchQnaTitle" placeholder="찾고 있는 질문을 입력해주세요" class="w-50">
					<button class="btn btn-dark btn-sm" type="submit">검색</button>
				</form>
			</div>
			<div>
				<%
					// session에 저장된 loginMember를 받아옴
					Member loginMember = (Member)session.getAttribute("loginMember");
					if(loginMember == null){
						// loginMember가 null일 때 출력하는 문구
				%>
						<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a> <span class="align-middle">후에 QnA 게시판에 질문이 가능합니다</span>
				<%
					} else if(loginMember.getMemberLevel() < 1) {
						// memberLevel이 1미만 일 때 출력하는 버튼
				%>
						<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/insertQnaForm.jsp">질문하기</a>
				<%
						
					} else if(loginMember.getMemberLevel() >= 1) {
						// memberLevel이 1이상 일 때 출력하는 버튼
				%>
						<a class="btn btn-outline-secondary center-block" href="<%=request.getContextPath()%>/admin/adminIndex.jsp">관리자 페이지</a>
						<!-- 답글 달지 않은 qna 글 출력 -->
				<%
					}
				%>
			</div>
		</div>
		
		<table class="table table-sm mt-2">
			<thead style="text-align:center;">
				<tr>
					<th style="width:5%;">NO</th>
					<th style="width:10%;">SECRET</th>
					<th style="width:10%;">CATEGORY</th>
					<th>TITLE</th>
					<th style="width:20%;">CREATE</th>
				</tr>
			</thead>
			<tbody>
				<%
					// qnaList를 출력하는 for문
					for(Qna q : qnaList) {
				%>
						<tr>
							<td style="text-align:center;"><%=q.getQnaNo()%></td>
							<td style="text-align:center;">
							<%
								if(q.getQnaSecret().equals("Y")){
							%>
									<img src="<%=request.getContextPath()%>/image/lock_1.png" width="18" height="18">
							<%
								} else {
							%>
									<img src="<%=request.getContextPath()%>/image/lock_2.png" width="18" height="18">
							<%
								}
							%>
							</td>
							<td style="text-align:center;"><%=q.getQnaCategory()%></td>
							<td>
								<a class="text-body" href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaTitle()%></a>
							</td>
							<td style="text-align:center;"><%=q.getCreateDate()%></td>
						</tr>
				<%
					}
				%>
			</tbody>
		</table>
			<%
			// 마지막 페이지(lastPage)를 구하는 qnaDao의 메서드 호출
			// int 타입의 lastPage에 저장
			// 검색어가 없을때는 전체 행을 COUNT 하는 selectQnaListLastPage메서드 호출
			// 검색어가 있을때는 LIKE 연산자를 사용한 sql문을 실행하고 lastPage를 리턴하는 selectQnaListSearchLastPage메서드 호출
			int lastPage;
			if(searchQnaTitle.equals("") == true) { // 검색어가 없을때
				lastPage = qnaDao.selectQnaListLastPage(ROW_PER_PAGE);
			} else { // 검색어가 있을때
				lastPage = qnaDao.selectQnaListSearchLastPage(ROW_PER_PAGE, searchQnaTitle);
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
				<a href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=1%>&searchQnaTitle=<%=searchQnaTitle%>" class="btn btn-outline-secondary center-block">◀처음</a>
			<%
			}
	
			// 이전 버튼
			// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
			if(startPage > displayPage){
			%>
				<a href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=startPage-displayPage%>&searchQnaTitle=<%=searchQnaTitle%>" class="btn btn-outline-secondary">&lt;이전</a>
			<%
			}
			
			// 페이징버튼
			// 화면에 보여질 시작 페이지 번호를 화면에 보여질 마지막 페이지 번호까지 반복하면서 페이지 번호 생성
			// 만약에 화면에 보여질 마지막 페이지 번호가 마지막 페이지보다 크다면 for문을 break로 종료시킴
			for(int i=startPage; i<=endPage; i++){
				if(currentPage == i){
			%>
					<a href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=i%>&searchQnaTitle=<%=searchQnaTitle%>" class="btn btn-secondary"><%=i%></a>
			<%
				} else if(endPage<lastPage || endPage == lastPage){
			%>
					<a href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=i%>&searchQnaTitle=<%=searchQnaTitle%>" class="btn btn-outline-secondary"><%=i%></a>
			<%	
				} else if(endPage>lastPage){
					break;
				}
			}
	
			// 다음 버튼
			// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
			if(endPage < lastPage){
			%>
				<a href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=startPage+displayPage%>&searchQnaTitle=<%=searchQnaTitle%>" class="btn btn-outline-secondary">다음></a>
			<%
			}
			
			// 끝으로 버튼
			// 가장 마지막 페이지로 바로 이동하는 버튼
			if(currentPage != lastPage && endPage != 0){
			%>
				<a href="<%=request.getContextPath()%>/selectQnaList.jsp?currentPage=<%=lastPage%>&searchQnaTitle=<%=searchQnaTitle%>" class="btn btn-outline-secondary">끝▶</a>
			<%
			}
			%>
	</div>
</body>
</html>