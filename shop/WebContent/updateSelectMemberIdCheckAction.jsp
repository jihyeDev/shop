<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*"%>
<%@ page import="vo.*" %>
<%
	// updateSelectMemberIdCheckAction.jsp 디버깅 구분선
	System.out.println("----------updateSelectMemberIdCheckAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	// memberDao 생성
	MemberDao memberDao = new MemberDao();
	
	// login된 회원인지 확인하는 방어코드
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이면 이 페이지를 들어올 수 없음
	if(loginMember == null){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드 (공백이거나 null 인지)
	// memberIdCheck 입력값 유효성 검사
	if(request.getParameter("memberIdCheck")==null || request.getParameter("memberIdCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp");
		return;
	}
	
	// 입력받을 memberIdCheck를 저장
	String memberIdCheck = request.getParameter("memberIdCheck");
	System.out.println(memberIdCheck+" <-- memberIdCheck");
	
	// 입력받은 memberIdCheck를 중복값인지 확인하는 selectMemberId 메서드를 호출하여 리턴값을 result에 저장
	String result = memberDao.selectMemberId(memberIdCheck);
	
	
	// result 값이 null이면 사용 가능한 ID, 아니라면 이미 사용중인 ID
	if(result == null) {
		response.sendRedirect(request.getContextPath()+"/updateMemberIdFormByMember.jsp?memberIdCheck="+memberIdCheck);
	} else {
		response.sendRedirect(request.getContextPath()+"/updateMemberIdFormByMember.jsp?idCheckResult=Y");
	}
%>