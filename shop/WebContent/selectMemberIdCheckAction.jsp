<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*"%>
<%
	// selectMemberIdCheckAction.jsp 디버깅 구분선
	System.out.println("----------selectMemberIdCheckAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	// memberDao 생성
	MemberDao memberDao = new MemberDao();
	
	//인증 방어 코드 : 로그인 상태에서는 페이지 접근 불가
	// session.getAttribute("loginMember") --> null
	if(session.getAttribute("loginMember")!=null) {
		System.out.println("이미 로그인 되어 있습니다. loginMember == " + session.getAttribute("loginMember"));
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
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
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?memberIdCheck="+memberIdCheck);
	} else {
		response.sendRedirect(request.getContextPath()+"/insertMemberForm.jsp?idCheckResult=This ID is already taken"+memberIdCheck);
	}
%>