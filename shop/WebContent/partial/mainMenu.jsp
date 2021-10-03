<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<nav class="navbar navbar-expand-sm navbar-light">
	<ul class="nav navbar-nav" style="color:#135200; font-weight:bold; font-size:20px;">
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/index.jsp">MAIN</a></li>
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/selectEbookList.jsp">E-BOOK</a></li>
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/selectNoticeList.jsp">NOTICE</a></li>
		<li class="nav-item active"><a class="nav-link active" href="<%=request.getContextPath()%>/selectQnaList.jsp">QNA</a></li>
	</ul>
	<ul class="nav navbar-nav ml-auto">
		<%
			// 로그인 전 = session의 loginMember가 null 일 때
			if(session.getAttribute("loginMember")==null) {
		%>
				<li>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/loginForm.jsp">LOGIN</a>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/insertMemberForm.jsp">JOIN</a>
				</li>
		<%
			// 로그인 후
			// loginMember 객체에 session의 loginMember를 저장
			} else {
				Member loginMember = (Member)session.getAttribute("loginMember");
		%>
				<li>
					<%=loginMember.getMemberId()%> 님 
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/logout.jsp">LOGOUT</a>
		<%
					if(loginMember.getMemberLevel() > 0) {
		%>		
					<!-- 관리자 페이지로 가는 링크 -->
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/admin/adminIndex.jsp">ADMIN PAGE</a>
		<%
					}
		%>
					<a class="btn btn-success btn-sm" href="<%=request.getContextPath()%>/selectOrderListByMember.jsp">MY PAGE</a>
				</li>
		<%
			}
		%>
	</ul>
</nav>