<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*" %>
<%@ page import="vo.*" %>
<%
	// deleteMemberActionByMember.jsp 디버깅 구분선
	System.out.println("----------deleteMemberActionByMember.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// MemberDao 객체 생성
	MemberDao memberDao = new MemberDao();
	
	// login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
		
	// 입력값 방어 코드
	// 삭제할 특정회원의 memberNo과 memberPw를 입력 받았는지 유효성 검사
	if(request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("") || request.getParameter("memberPw")==null || request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/deleteMemberFormByMember.jsp");
		return;
	}
		

	// request 값 저장
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberPw = request.getParameter("memberPw");
	// requst 매개값 디버깅 코드
	System.out.println(memberNo+" <-- memberNo");
	System.out.println(memberPw+" <-- memberPw");
	
	
	// 특정회원을 강제 탈퇴(삭제)시키는 memberDao의 deleteMemberByAdmin 메서드 호출
	if(memberDao.deleteMemberByMember(memberNo,memberPw)) {
		System.out.println("회원 탈퇴 성공!");
	} else {
		System.out.println("회원 탈퇴 실패");
	}
	
	// 사용자의 세션을 새로운 세션으로 갱신
	session.invalidate();
	response.sendRedirect(request.getContextPath()+"/index.jsp");
	
%>