<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<nav class="navbar navbar-expand-sm navbar-light">
	<ul class="nav navbar-nav">
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/index.jsp">MAIN</a></li>
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/selectNoticeList.jsp">NOTICE</a></li>
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/selectQnaList.jsp">QNA</a></li>
		<li class="nav-item active"><a class="nav-link active" href="">menu4</a></li>
		<li class="nav-item active"><a class="nav-link active" href="">menu5</a></li>
	</ul>
	<ul class="nav navbar-nav ml-auto">
		<%
			// 로그인 전 = session의 loginMember가 null 일 때
			if(session.getAttribute("loginMember")==null) {
		%>
				<li>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/loginForm.jsp">로그인</a>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/insertMemberForm.jsp">회원가입</a>
				</li>
		<%
			// 로그인 후
			// loginMember 객체에 session의 loginMember를 저장
			} else {
				Member loginMember = (Member)session.getAttribute("loginMember");
		%>
				<li>
					<%=loginMember.getMemberId()%> 님 / Level : <%=loginMember.getMemberLevel()%>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a>
					<!-- 관리자 페이지로 가는 링크 -->
		<%
					if(loginMember.getMemberLevel() > 0) {
		%>		
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/admin/adminIndex.jsp">관리자 페이지</a>
		<%
					}
		%>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/selectOrderListByMember.jsp">주문목록</a>
				</li>
		<%
			}
		%>
	</ul>
</nav>