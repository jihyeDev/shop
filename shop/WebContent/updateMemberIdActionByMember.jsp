<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// updateMemberIdActionByMember.jsp 디버깅 구분선
	System.out.println("----------updateMemberIDActionByMember.jsp----------");
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
	// 회원정보를 수정할 특정회원의 memberNo과 수정할 정보를 입력 받았는지 유효성 검사
	if(request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("") || request.getParameter("memberPw")==null || request.getParameter("memberPw").equals("") || request.getParameter("memberId")==null || request.getParameter("memberId").equals("")) {
		response.sendRedirect(request.getContextPath()+"/updateMemberFormByMember.jsp");
		return;
	}
		

	// request 값 저장
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberPw = request.getParameter("memberPw");
	String memberId = request.getParameter("memberId");
	// request 매개값 디버깅 코드
	System.out.println(memberNo+" <-- memberNo");
	System.out.println(memberPw+" <-- memberPw");
	System.out.println(memberId+" <-- memberId");
	
	// Member 객체 생성 후, 받아온 값 저장
	Member paramMember = new Member();
	paramMember.setMemberNo(memberNo);
	paramMember.setMemberPw(memberPw);
	paramMember.setMemberId(memberId);
	
	// 회원이 ID를 수정하는 memberDao의 updateMemberIdByMember 메서드 호출
	// 회원의 ID를 수정시 매개값의 memberPw와 DB에 저장된 member_pw가 같아야지만 수정 가능
	if(memberDao.updateMemberIdByMember(paramMember)) {
		System.out.println("ID 수정 성공!");
		
	} else {
		System.out.println("ID 수정 실패");
	}
	response.sendRedirect(request.getContextPath()+"/selectMemberOneByMember.jsp");
	
%>