<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*" %>
<%
	request.setCharacterEncoding("utf-8");
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	//requst값 디버깅
	System.out.println(memberId+"<-- memberId");
	System.out.println(memberPw+"<-- memberPw");
	
	MemberDao memberDao = new MemberDao();
	Member paramMember = new Member();
	paramMember.setMemberId(memberId);
	paramMember.setMemberPw(memberPw);
	
	// 성공시 : memberId + memberName
	// 실패시 : null
	Member returnMember = memberDao.login(paramMember);
	// 디버깅
	if(returnMember==null){
		System.out.println("로그인 실패");
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
	} else {
		System.out.println("로그인 성공");
		System.out.println(returnMember.getMemberNo());
		System.out.println(returnMember.getMemberId());
		System.out.println(returnMember.getMemberLevel());
		
		// request, session : jsp 내장객체
		// 특정 사용자 공간(session)에 변수를 생성
		session.setAttribute("loginMember",returnMember);
		response.sendRedirect(request.getContextPath()+"/index.jsp");
	}
%>