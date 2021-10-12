<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>QnA 목록</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<%
	System.out.println("----------selectQnaList.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// qnaDao 객체 생성
	QnaDao qnaDao = new QnaDao();
	
	// adminPage의 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 답글이 안 달린 Qna를 불러오기 위해 사용하는 변수 noCommentSet을 선언
	// noCommentSet 무조건 공백("")인데 값이 넘어오면 변경
	String noCommentSet = "";
	if(request.getParameter("noCommentSet")!=null) { 
		noCommentSet = request.getParameter("noCommentSet");
	}
	// 디버깅
	System.out.println("noCommentSet(답글이 안 달린 Qna를 불러오는 변수) : "+noCommentSet);
	
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
	
	// 답글이 달리지 않은 Qna 버튼을 안 눌렀을 때는 전체 QnA을 SELECT하고, 페이징하는 QnaDao의 selectQnaList메서드 호출
	// 답글이 달리지 않은 Qna 버튼을 눌렀을 때는 join를 사용한 sql문을 실행하고 리스트를 리턴한 selectNoCommentQnaList 메서드 호출
	// noCommentSet가 있으면 답글이 달리지 않은거 출력
	// list라는 리스트를 사용하기 위해 생성
	ArrayList<Qna> list = new ArrayList<Qna>();
	if(noCommentSet.equals("") == true) { // noCommentSet이 없을 때
		list = qnaDao.selectQnaList(beginRow, ROW_PER_PAGE);
	}else { // noCommentSet이 있을때
		list = qnaDao.selectNoCommentQnaList();
	}
%>
<body>
	<div class="container-fluid">
		<div class="row">
			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
			
				<h3 class="font-weight-bold">
					QnA게시판 관리
					<%
						if(noCommentSet.equals("")){
					%>
							<small class="font-weight-light text-secondary">_ ALL QNA</small>
					<%
						} else {
					%>
							<small class="font-weight-light text-secondary">_ NO COMMENT QNA</small>
					<%
						}
					%>
				</h3>
				
				<!-- noCommentSet에 값을 줘서 정렬 -->
				<div class="float-right">
					<a class="btn btn-dark" href="<%=request.getContextPath()%>/admin/selectQnaList.jsp">ALL QNA</a>
					<a class="btn btn-dark" href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?noCommentSet=Y">NO COMMENT QNA</a>
				</div>
				
				<table class="table table-bordered table-sm text-center mt-5">
					<thead>
						<tr>
							<th>NO</th>
							<th>CATEGORY</th>
							<th style="width:40%;">TITLE</th>
							<th>COMMENT</th>
							<th>CREATE DATE</th>
							<th>UPDATE DATE</th>
							<th>DELETE</th>
						</tr>
					</thead>
					<tbody>
						<%
							// list를 출력하는 for문
							for(Qna q : list) {
						%>
								<tr>
									<td>
										<a class="text-body" href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaNo()%></a>
									</td>
									<td><%=q.getQnaCategory()%>
									<td>
										<a class="text-body" href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>"><%=q.getQnaNo()%></a>
									</td>
									<td>
										<a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/selectQnaOne.jsp?qnaNo=<%=q.getQnaNo()%>">COMMENT</a>
									</td>
									<td><%=q.getCreateDate()%></td>
									<td><%=q.getUpdateDate()%></td>
									<td>
										<!-- 로그인된 관리자의 비밀번호를 확인 후 QNA 게시글을 삭제 -->
										<a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/admin/deleteQna.jsp?qnaNo=<%=q.getQnaNo()%>">삭제</a>
									</td>
								</tr>
						<%
							}
						%>
					</tbody>
				</table>
				<%
				if(noCommentSet.equals("")){
					// 마지막 페이지(lastPage)를 구하는 QnaDao의 메서드 호출
					// int 타입의 lastPage에 저장
					int lastPage;
					lastPage = qnaDao.selectQnaListLastPage(ROW_PER_PAGE);
					
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
						<a href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?currentPage=<%=1%>" class="btn btn-outline-secondary center-block">◀처음</a>
					<%
					}
			
					// 이전 버튼
					// 화면에 보여질 시작 페이지 번호가 화면에 보여질 페이지 번호의 갯수보다 크다면 이전 버튼을 생성
					if(startPage > displayPage){
					%>
						<a href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?currentPage=<%=startPage-displayPage%>" class="btn btn-outline-secondary">&lt;이전</a>
					<%
					}
					
					// 페이징버튼
					// 화면에 보여질 시작 페이지 번호를 화면에 보여질 마지막 페이지 번호까지 반복하면서 페이지 번호 생성
					// 만약에 화면에 보여질 마지막 페이지 번호가 마지막 페이지보다 크다면 for문을 break로 종료시킴
					for(int i=startPage; i<=endPage; i++){
						if(currentPage == i){
					%>
							<a href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?currentPage=<%=i%>" class="btn btn-secondary"><%=i%></a>
					<%
						} else if(endPage<lastPage || endPage == lastPage){
					%>
							<a href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?currentPage=<%=i%>" class="btn btn-outline-secondary"><%=i%></a>
					<%	
						} else if(endPage>lastPage){
							break;
						}
					}
			
					// 다음 버튼
					// 화면에 보여질 마지막 페이지 번호가 마지막페이지보다 작다다면 이전 버튼을 생성
					if(endPage < lastPage){
					%>
						<a href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?currentPage=<%=startPage+displayPage%>" class="btn btn-outline-secondary">다음></a>
					<%
					}
					
					// 끝으로 버튼
					// 가장 마지막 페이지로 바로 이동하는 버튼
					if(currentPage != lastPage && endPage != 0){
					%>
						<a href="<%=request.getContextPath()%>/admin/selectQnaList.jsp?currentPage=<%=lastPage%>" class="btn btn-outline-secondary">끝▶</a>
					<%
					}
				}
				%>
				
			</div>
			
		</div>
	</div>
</body>
</html>