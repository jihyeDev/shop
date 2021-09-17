<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<div>
	<ul class="nav nav-tabs">
		<!-- 회원 관리 : 목록, 수정(등급, 비밀번호), 강제탈퇴 -->
		<li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/admin/selectMemberList.jsp">회원관리</a></li>
		<!-- 전자책 카테고리 관리 : 목록, 추가, 사용유무 수정 -->
		<li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/admin/selectCategoryList.jsp">전자책 카테고리 관리</a></li>
		<!-- 전자책 관리 : 목록, 추가(이미지 추가), 수정, 삭제 -->
		<li class="nav-item"><a class="nav-link active" href="">주문 관리</a></li>
		<li class="nav-item"><a class="nav-link active" href="">상품평 관리</a></li>
		<li class="nav-item"><a class="nav-link active" href="">공지게시판 관리</a></li>
		<li class="nav-item"><a class="nav-link active" href="">QnA게시판 관리</a></li>
	</ul>
</div>