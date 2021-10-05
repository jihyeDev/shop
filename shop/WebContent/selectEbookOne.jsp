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
<style>
#article {
	background-color : #f4f4f5;
}
#score fieldset{
    display: inline-block; /* 하위 별점 이미지들이 있는 영역만 자리를 차지함.*/
    border: 0; /* 필드셋 테두리 제거 */
}
#score input[type=radio]{
    display: none; /* 라디오박스 감춤 */
}
#score label{
    font-size: 1em; /* 이모지 크기 */
    color: transparent; /* 기존 이모지 컬러 제거 */
    text-shadow: 0 0 0 #f4f4f5; /* 새 이모지 색상 부여 */
}
#score{
    display: inline-block; /* 하위 별점 이미지들이 있는 영역만 자리를 차지함.*/
    direction: rtl; /* 이모지 순서 반전(Right-To-Left) */
}
#score input[type=radio]:checked ~ label{
    text-shadow: 0 0 0 #28a745; /* 마우스 클릭 체크 */
}
</style>
</head>
<body>
<%
	// selectEbookOne.jsp 디버깅 구분선
	System.out.println("----------selectEbookOne.jsp----------");
	request.setCharacterEncoding("utf-8");
	// ebookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
	// orderCommentDao 객체 생성
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	
	// 입력값 방어 코드
	// 상세정보를 확인할 특정 전자책의 ebookNo을 입력 받았는지 유효성 검사
	if(request.getParameter("ebookNo")==null || request.getParameter("ebookNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/selectEbookList.jsp");
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
		response.sendRedirect(request.getContextPath()+"/selectEbookList.jsp");
	} else {
		System.out.println("전자책 정보 불러오기 성공");
		System.out.println(returnEbook.getEbookNo()+"<--- returnEbook.getEbookNo()");
		System.out.println(returnEbook.getEbookISBN()+"<--- returnEbook.getEbookISBN()");
		System.out.println(returnEbook.getCategoryName()+"<--- returnEbook.getCategoryName()");
		System.out.println(returnEbook.getEbookTitle()+"<--- returnEbook.getEbookTitle()");
		System.out.println(returnEbook.getEbookAuthor()+"<--- returnEbook.getEbookAuthor()");
		System.out.println(returnEbook.getEbookCompany()+"<--- returnEbook.getEbookCompany()");
		System.out.println(returnEbook.getEbookPageCount()+"<--- returnEbook.getEbookPageCount()");
		System.out.println(returnEbook.getEbookPrice()+"<---returnEbook.getEbookPrice()");
		System.out.println(returnEbook.getEbookImg()+"<---returnEbook.getEbookImg()");
		System.out.println(returnEbook.getEbookSummary()+"<---returnEbook.getEbookSummary()");
		System.out.println(returnEbook.getEbookState()+"<---returnEbook.getEbookState()");
		System.out.println(returnEbook.getUpdateDate()+"<---returnEbook.getUpdateDate()");
		System.out.println(returnEbook.getCreateDate()+"<---returnEbook.getCreateDate()");
	}
	
	/*[설 명] 가격을 화폐단위로 변경
	 * 1. String.format 을 사용해서 원하는 형태의 문자열로 만들 수 있다
	 * 2. %,(콤마)d - 화폐단위로 정수값을 표시하겠다는 의미이다
	 */
	String price = String.format("%,d", returnEbook.getEbookPrice());
%>

	<div class="container pt-3">
		<!-- start: mainMenu include -->
		<div>
			<jsp:include page="/partial/mainMenu.jsp"></jsp:include>
		</div>
		<!-- end : mainMenu include -->
		<hr>
		
		<h1 class="bg-white text-center">상품페이지</h1>
		
		<div id="article" class="row rounded-lg p-4 mb-4 mt-4">
		
			<div class="col-sm-4">
				<img src="<%=request.getContextPath()%>/image/<%=returnEbook.getEbookImg()%>" width="330" height="450">
			</div>
			<div class="col-sm-8">
				<div><%=returnEbook.getCategoryName()%></div>
				<h3 class="font-weight-bold"><%=returnEbook.getEbookTitle()%></h3>
				<small><%=returnEbook.getEbookAuthor()%> | <%=returnEbook.getEbookCompany()%></small>
				
				<hr>
				
				<table class="mt-5">
					<tr>
						<td style="width:70px;"><small>상태</small></td>
						<td><%=returnEbook.getEbookState()%></td>
					</tr>
					<tr>
						<td><small>판매가</small></td>
						<td><span class="font-weight-bold" style="font-size:18px;"><%=price%></span><small>원</small></td>
					</tr>
				</table>
				
				<!-- 로그인 시에만 주문가능한 주문 버튼 -->
				<div class="mt-5 pt-5">
					<%
						Member loginMember = (Member)session.getAttribute("loginMember");
						if(loginMember == null) {
					%>
						<a class="btn btn-outline-success btn-sm" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a> <span class="align-middle">후에 주문이 가능합니다</span>
					<%
						} else {
					%>
							<form method="post" action="<%=request.getContextPath()%>/insertOrderAction.jsp">
								<input type="hidden" name="ebookNo" value="<%=returnEbook.getEbookNo() %>">
								<input type="hidden" name="ebookPrice" value="<%=returnEbook.getEbookPrice() %>">
								<input type="hidden" name="memberNo" value="<%=loginMember.getMemberNo() %>">
								<button type="submit" class="btn btn-success">주문하기</button>
							</form>
					<%
						}
					%>
				</div>
			</div>
		
		</div>
		
		<div>
			<div>총 페이지 <%=returnEbook.getEbookPageCount()%></div>
			<div><%=returnEbook.getEbookSummary()%></div>
			<div>출판 <%=returnEbook.getCreateDate()%> | 업데이트 <%=returnEbook.getUpdateDate()%></div>
		</div>
		
		<div>
			<hr>
				<!-- 이 상품의 별점의 평균 -->
				<%
					double avgScore = orderCommentDao.selectOrderScoreAvg(ebookNo);
				%>
				별점 평균 : <%=avgScore%>
				
				<!-- 이 상품의 상품 후기(페이징) -->
				<%
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
				final int ROW_PER_PAGE = 10;
				int beginRow = (currentPage-1) * ROW_PER_PAGE;
				
				ArrayList<OrderComment> commentList = new ArrayList<OrderComment>();
				commentList = orderCommentDao.selectCommentList(beginRow, ROW_PER_PAGE, ebookNo);
				
				// 마지막 페이지(lastPage)를 구하는 orderCommentDao의 메서드 호출
				// int 타입의 lastPage에 저장
				// 전체 행을 COUNT 하는 selectCommentListLastPage메서드 호출
				int lastPage = orderCommentDao.selectCommentListLastPage(ROW_PER_PAGE, ebookNo);
				
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
				%>
				<table class="table table-sm mt-1">
					<thead style="text-align:center;">
						<tr>
							<td style="width:15%;">GRADE</td>
							<td>COMMENT</td>
							<td style="width:20%;">DATE</td>
						</tr>
					</thead>
					<tbody>
					<%
						for(OrderComment c : commentList) {
					%>
							<tr>
								<td>
									<%
										// 별점을 이모지를 포함한 radio로 만들어서 출력하게 만들기
										// checked 하기 위해 배열로 생성하여 비교
										// "checked" 문자열을 저장하기 위한 용도의 배열
										String[] scoreChecked = new String[5];
										if(c.getOrderScore() == 1){
											scoreChecked[0] = "checked";
										} else if(c.getOrderScore() == 2){
											scoreChecked[1] = "checked";
										} else if(c.getOrderScore() == 3){
											scoreChecked[2] = "checked";
										} else if(c.getOrderScore() == 4){
											scoreChecked[3] = "checked";
										} else if(c.getOrderScore() == 5){
											scoreChecked[4] = "checked";
										}
									%>
									<div id="score">
										<fieldset>
									        <input type="radio" value="5" id="rate1" <%=scoreChecked[4]%> disabled><label for="rate1">⭐</label>
									        <input type="radio" value="4" id="rate2" <%=scoreChecked[3]%> disabled><label for="rate2">⭐</label>
									        <input type="radio" value="3" id="rate3" <%=scoreChecked[2]%> disabled><label for="rate3">⭐</label>
									        <input type="radio" value="2" id="rate4" <%=scoreChecked[1]%> disabled><label for="rate4">⭐</label>
									        <input type="radio" value="1" id="rate5" <%=scoreChecked[0]%> disabled><label for="rate5">⭐</label>
								        </fieldset>
									</div>
								</td>
								<td><%=c.getOrderCommentContent()%></td>
								<td><%=c.getCreateDate()%></td>
							</tr>
					<%
						}
					%>
					</tbody>
				</table>
				
				<%
				if(endPage == 0){
				%>
					<h2 style="text-align:center">작성된 후기가 없습니다.</h2>
				<%
				}
				// 처음으로 버튼
				// 제일 첫번째 페이지로 이동할때 = 1 page로 이동
				if(currentPage != 1){
					%>
					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?currentPage=<%=1%>&ebookNo=<%=ebookNo%>" class="btn btn-outline-secondary center-block">◀처음</a>
				<%
				}
					
				// 이전 버튼
				// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
				if(startPage > displayPage){
				%>
					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?currentPage=<%=startPage-displayPage%>&ebookNo=<%=ebookNo%>" class="btn btn-outline-secondary">&lt;이전</a>
				<%
				}
							
				// 페이징버튼
				// 화면에 보여질 시작 페이지 번호를 화면에 보여질 마지막 페이지 번호까지 반복하면서 페이지 번호 생성
				// 만약에 화면에 보여질 마지막 페이지 번호가 마지막 페이지보다 크다면 for문을 break로 종료시킴
				for(int i=startPage; i<=endPage; i++){
					if(currentPage == i){
				%>
						<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?currentPage=<%=i%>&ebookNo=<%=ebookNo%>" class="btn btn-secondary"><%=i%></a>
				<%
					} else if(endPage<lastPage || endPage == lastPage){
				%>
						<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?currentPage=<%=i%>&ebookNo=<%=ebookNo%>" class="btn btn-outline-secondary"><%=i%></a>
				<%	
					} else if(endPage>lastPage){
						break;
					}
				}
					
				// 다음 버튼
				// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
				if(endPage < lastPage){
				%>
					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?currentPage=<%=startPage+displayPage%>&ebookNo=<%=ebookNo%>" class="btn btn-outline-secondary">다음></a>
				<%
					}
							
				// 끝으로 버튼
				// 가장 마지막 페이지로 바로 이동하는 버튼
				if(currentPage != lastPage && endPage != 0){
				%>
					<a href="<%=request.getContextPath()%>/selectEbookOne.jsp?currentPage=<%=lastPage%>&ebookNo=<%=ebookNo%>" class="btn btn-outline-secondary">끝▶</a>
				<%
				}
				%>
		</div>
	
	</div>
</body>
</html>