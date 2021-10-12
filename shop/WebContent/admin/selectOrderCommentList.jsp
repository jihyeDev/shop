<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%
	System.out.println("----------selectOrderCommentList.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// orderDao 객체 생성
	OrderCommentDao orderCommentDao = new OrderCommentDao();
	
	// adminPage의 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
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
	
	// 전체 상품평을 SELECT하고, 페이징하는 orderCommentDao의 selectCommentListByAdmin 메서드 호출
	// list라는 리스트를 사용하기 위해 생성
	ArrayList<OrderComment> list = new ArrayList<OrderComment>();
	list = orderCommentDao.selectCommentListByAdmin(beginRow, ROW_PER_PAGE);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품평 목록</title>
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
	<div class="container-fluid">
		<div class="row">
			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
			
				<h3 class="font-weight-bold">상품평 목록</h3>
				
				<table class="table table-bordered table-sm text-center mt-5">
					<thead>
						<tr>
							<th>ORDER</th>
							<th>EBOOK</th>
							<th>ORDER SCORE</th>
							<th style="width:40%;">COMMENT</th>
							<th>CREATE DATE</th>
							<th>DELETE</th>
						</tr>
					</thead>
					<tbody>
						<%
							// list를 출력하는 for문
							for(OrderComment oc : list) {
						%>
								<tr>
									<td><%=oc.getOrderNo()%></td>
									<!-- 책 정보 페이지로 바로 넘어가는 버튼 -->
									<td><a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/admin/selectEbookOne.jsp?ebookNo=<%=oc.getEbookNo()%>"><%=oc.getEbookNo()%></a></td>
									<td>
										<%
											// 별점을 이모지를 포함한 radio로 만들어서 출력하게 만들기
											// checked 하기 위해 배열로 생성하여 비교
											// "checked" 문자열을 저장하기 위한 용도의 배열
											String[] scoreChecked = new String[5];
											if(oc.getOrderScore() == 1){
												scoreChecked[0] = "checked";
											} else if(oc.getOrderScore() == 2){
												scoreChecked[1] = "checked";
											} else if(oc.getOrderScore() == 3){
												scoreChecked[2] = "checked";
											} else if(oc.getOrderScore() == 4){
												scoreChecked[3] = "checked";
											} else if(oc.getOrderScore() == 5){
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
									<td><a class="text-body" href="<%=request.getContextPath()%>/selectEbookOne.jsp?ebookNo=<%=oc.getEbookNo()%>"><small><%=oc.getOrderCommentContent()%></small></a></td>
									<td><%=oc.getCreateDate()%></td>
									<!-- 상품평을 삭제하는 PAGE로 연결하는 버튼 -->
									<td><a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/admin/deleteOrderComment.jsp?orderNo=<%=oc.getOrderNo()%>">삭제</a></td>
								</tr>
						<%
							}
						%>
					</tbody>
				</table>
					<%
						// 마지막 페이지(lastPage)를 구하는 orderDao의 메서드 호출
						// int 타입의 lastPage에 저장
						// 검색어가 없을때는 전체 행을 COUNT 하는 selectOrderListLastPage메서드 호출
						// 검색어가 있을때는 LIKE 연산자를 사용한 sql문을 실행하고 lastPage를 리턴하는 selectOrderListSearchLastPage메서드 호출
						int lastPage;
						lastPage = orderCommentDao.selectCommentListLastPageByAdmin(ROW_PER_PAGE);
						
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
						
						
						if(endPage == 0){
						%>
							<div class="font-weight-bold text-center m-5">작성된 후기가 없습니다.</div>
						<%
						}
						// 처음으로 버튼
						// 제일 첫번째 페이지로 이동할때 = 1 page로 이동
						if(currentPage != 1){
						%>
							<a href="<%=request.getContextPath()%>/admin/selectOrderCommentList.jsp?currentPage=<%=1%>" class="btn btn-outline-secondary center-block">◀처음</a>
						<%
						}
				
						// 이전 버튼
						// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
						if(startPage > displayPage){
						%>
							<a href="<%=request.getContextPath()%>/admin/selectOrderCommentList.jsp?currentPage=<%=startPage-displayPage%>" class="btn btn-outline-secondary">&lt;이전</a>
						<%
						}
						
						// 페이징버튼
						// 화면에 보여질 시작 페이지 번호를 화면에 보여질 마지막 페이지 번호까지 반복하면서 페이지 번호 생성
						// 만약에 화면에 보여질 마지막 페이지 번호가 마지막 페이지보다 크다면 for문을 break로 종료시킴
						for(int i=startPage; i<=endPage; i++){
							if(currentPage == i){
						%>
								<a href="<%=request.getContextPath()%>/admin/selectOrderCommentList.jsp?currentPage=<%=i%>" class="btn btn-secondary"><%=i%></a>
						<%
							} else if(endPage<lastPage || endPage == lastPage){
						%>
								<a href="<%=request.getContextPath()%>/admin/selectOrderCommentList.jsp?currentPage=<%=i%>" class="btn btn-outline-secondary"><%=i%></a>
						<%	
							} else if(endPage>lastPage){
								break;
							}
						}
				
						// 다음 버튼
						// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
						if(endPage < lastPage){
						%>
							<a href="<%=request.getContextPath()%>/admin/selectOrderCommentList.jsp?currentPage=<%=startPage+displayPage%>" class="btn btn-outline-secondary">다음></a>
						<%
						}
						
						// 끝으로 버튼
						// 가장 마지막 페이지로 바로 이동하는 버튼
						if(currentPage != lastPage && endPage != 0){
						%>
							<a href="<%=request.getContextPath()%>/admin/selectOrderCommentList.jsp?currentPage=<%=lastPage%>" class="btn btn-outline-secondary">끝▶</a>
						<%
						}
						%>
				
			</div>
			
		</div>
	</div>
</body>
</html>