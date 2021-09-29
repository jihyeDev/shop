<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div style="height:100vh;">
	<ul class="nav flex-column font-weight-bold" style="position:fixed;">
		<!-- 관리자 페이지 메인 -->
		<li class="nav item">
			<a class="nav-link mt-1 px-3" href="<%=request.getContextPath()%>/admin/adminIndex.jsp" style="color:#722ED1;">ADMIN MAIN</a>
		</li>
		<!-- 회원 관리 : 목록, 수정(등급, 비밀번호), 강제탈퇴 -->
		<li class="nav-item">
			<a class="nav-link text-secondary mt-5 px-3" href="<%=request.getContextPath()%>/admin/selectMemberList.jsp">회원관리</a>
		</li>
		<!-- 전자책 카테고리 관리 : 목록, 추가, 사용유무 수정 -->
		<li class="nav-item">
			<a class="nav-link text-secondary pt-2 px-3" href="<%=request.getContextPath()%>/admin/selectCategoryList.jsp">전자책 카테고리 관리</a>
		</li>
		<!-- 전자책 관리 : 목록, 추가(이미지 추가), 수정, 삭제 -->
		<li class="nav-item">
			<a class="nav-link text-secondary pt-2 px-3" href="<%=request.getContextPath()%>/admin/selectEbookList.jsp">전자책 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary pt-2 px-3" href="<%=request.getContextPath()%>/admin/selectOrderList.jsp">주문 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary pt-2 px-3" href="">상품평 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary pt-2 px-3" href="<%=request.getContextPath()%>/admin/selectNoticeList.jsp">공지게시판 관리</a>
		</li>
		<li class="nav-item">
			<a class="nav-link text-secondary pt-2 px-3" href="">QnA게시판 관리</a>
		</li>
		<li>
			<a class="nav-link mt-5 px-3" href="<%=request.getContextPath()%>/index.jsp" style="color:#722ED1;"><small>shop 바로가기</small></a>
		</li>
	</ul>
</div>