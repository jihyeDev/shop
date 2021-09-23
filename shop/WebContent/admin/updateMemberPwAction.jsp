<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%
	// updateMemberPwAction.jsp 디버깅 구분선
	System.out.println("----------updateMemberPwAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// MemberDao 객체 생성
	MemberDao memberDao = new MemberDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// 입력값 방어 코드
	// 비밀번호를 수정할 특정회원의 memberNo과 수정할 레벨을 입력 받았는지 유효성 검사
	if(request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("") || request.getParameter("memberPw")==null || request.getParameter("memberPw").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
		return;
	}
		

	// request 값 저장
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	String memberNewPw = request.getParameter("memberPw");
	// request 매개값 디버깅 코드
	System.out.println(memberNo+" <-- memberNo");
	System.out.println(memberNewPw+" <-- memberNewPw");
	// Member 객체 생성 후, 받아온 값 저장
	Member paramMember = new Member();
	paramMember.setMemberNo(memberNo);
	
	// 특정회원의 PW를 수정하는 memberDao의 updateMemberPwByAdmin 메서드 호출
	if(memberDao.updateMemberPwByAdmin(paramMember, memberNewPw)) {
		System.out.println("PASSWORD 수정 성공!");
		
	} else {
		System.out.println("PASSWORD 수정 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
	
%>