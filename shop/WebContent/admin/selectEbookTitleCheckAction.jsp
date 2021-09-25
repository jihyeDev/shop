<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "dao.*"%>
<%@ page import = "vo.*"%>
<%
	// selectEbookTitleCheckAction.jsp 디버깅 구분선
	System.out.println("----------selectEbookTitleCheckAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	// EbookDao 생성
	EbookDao ebookDao = new EbookDao();
	
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		// 다시 브라우즈에게 다른 곳을 요청하도록 하는 메서드
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		// 페이지 전체 실행하지 말고 종료
		return;
	}
	
	// 입력값 방어 코드 (공백이거나 null 인지)
	// ebookTitleCheck 입력값 유효성 검사
	if(request.getParameter("ebookTitleCheck")==null || request.getParameter("ebookTitleCheck").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertEbookForm.jsp");
		return;
	}
	
	// 입력받을 ebookTitleCheck를 저장
	String ebookTitleCheck = request.getParameter("ebookTitleCheck");
	System.out.println(ebookTitleCheck+" <-- ebookTitleCheck");
	
	// 입력받은 ebookTitleCheck를 중복값인지 확인하는 selectEbookTitle 메서드를 호출하여 리턴값을 result에 저장
	String result = ebookDao.selectEbookTitle(ebookTitleCheck);
	
	
	// result 값이 null이면 추가 가능한 전자책, 아니라면 이미 입력된 전자책
	if(result == null) {
		response.sendRedirect(request.getContextPath()+"/admin/insertEbookForm.jsp?ebookTitleCheck="+ebookTitleCheck);
	} else {
		response.sendRedirect(request.getContextPath()+"/admin/insertEbookForm.jsp?titleCheckResult=Y");
	}
%>