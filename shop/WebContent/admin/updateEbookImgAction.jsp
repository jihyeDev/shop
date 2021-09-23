<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%> <!-- 파일이름 중복 피할 수 있도록 -->
<%
	// updateEbookImgAction.jsp 디버깅 구분선
	System.out.println("----------updateEbookImgAction.jsp----------");
	request.setCharacterEncoding("utf-8");
	
	// ebookDao 객체 생성
	EbookDao ebookDao = new EbookDao();
		
	// adminPage의 방어코드 :  관리자 로그인 상태가 아니라면 페이지 접근 불가
	// session에 저장된 loginMember를 받아옴
	Member loginMember = (Member)session.getAttribute("loginMember");
	// loginMember가 null이거나 memberLevel이 1이하 일 때 이 페이지를 들어올 수 없음
	if(loginMember == null || loginMember.getMemberLevel() < 1){
		response.sendRedirect(request.getContextPath()+"/index.jsp");
		return;
	}
	
	// multipart/form-data로 넘겼기 때문에 request.getParameter("ebookNo")형태 사용불가
	MultipartRequest mr = new MultipartRequest(request, "D:/구디아카데미/git-shop/shop/WebContent/image", 1024*1024*1024, "utf-8", new DefaultFileRenamePolicy());
	System.out.println(mr+" <-- mr");
	
	// 입력값 방어 코드
	// 이미지를 수정할 특정 전자책의 ebookNo과 수정할 이미지 파일을 입력 받았는지 유효성 검사
	if(mr.getParameter("ebookNo")==null || mr.getParameter("ebookNo").equals("") || mr.getFilesystemName("ebookImg")==null || mr.getFilesystemName("ebookImg").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp");
		return;
	}
		

	// mr 값 저장
	int ebookNo = Integer.parseInt(mr.getParameter("ebookNo"));
	String ebookImg = mr.getFilesystemName("ebookImg");

	// mr 매개값 디버깅 코드
	System.out.println(ebookNo+" <-- ebookNo");
	System.out.println(ebookImg+" <-- ebookImg");
	
	// paramEbook 객체 생성 후, 받아온 값 저장
	Ebook paramEbook = new Ebook();
	paramEbook.setEbookNo(ebookNo);
	paramEbook.setEbookImg(ebookImg);
	
	// 특정 전자책의 이미지를 수정하는 ebookDao의 updateEbookImgByAdmin 메서드 호출
	if(ebookDao.updateEbookImg(paramEbook)) {
		System.out.println("이미지 수정 성공!");
	} else {
		System.out.println("이미지 수정 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectEbookOne.jsp?ebookNo="+ebookNo);
	
%>