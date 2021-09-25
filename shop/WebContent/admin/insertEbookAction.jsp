<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import = "dao.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest"%> <!-- request 대신 -->
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%> <!-- 파일이름 중복 피할 수 있도록 -->
<%
	// insertEbookAction.jsp 디버깅 구분선
	System.out.println("----------insertEbookAction.jsp----------");
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
	// 추가할 전자책의 정보를 다 입력했는지 확인하는 코드
	if(mr.getParameter("ebookIsbn")==null || mr.getParameter("categoryName")==null || mr.getParameter("ebookTitle")==null || mr.getParameter("ebookAuthor")==null || mr.getParameter("ebookCompany")==null || mr.getParameter("ebookPageCount")==null || mr.getParameter("ebookPrice")==null || mr.getFilesystemName("ebookImg")==null || mr.getParameter("ebookSummary")==null || mr.getParameter("ebookState")==null) {
		response.sendRedirect(request.getContextPath()+"/admin/insertEbookForm.jsp");
		return;
	}
	
	if(mr.getParameter("ebookIsbn").equals("") || mr.getParameter("categoryName").equals("") || mr.getParameter("ebookTitle").equals("") || mr.getParameter("ebookAuthor").equals("") || mr.getParameter("ebookCompany").equals("") || mr.getParameter("ebookPageCount").equals("") || mr.getParameter("ebookPrice").equals("") || mr.getFilesystemName("ebookImg").equals("") || mr.getParameter("ebookSummary").equals("") || mr.getParameter("ebookState").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/insertEbookForm.jsp");
		return;
	}
		

	// mr 값 저장
	String ebookIsbn = mr.getParameter("ebookIsbn");
	String categoryName = mr.getParameter("categoryName");
	String ebookTitle = mr.getParameter("ebookTitle");
	String ebookAuthor = mr.getParameter("ebookAuthor");
	String ebookCompany = mr.getParameter("ebookCompany");
	int ebookPageCount = Integer.parseInt(mr.getParameter("ebookPageCount"));
	int ebookPrice = Integer.parseInt(mr.getParameter("ebookPrice"));
	String ebookImg = mr.getFilesystemName("ebookImg");
	String ebookSummary = mr.getParameter("ebookSummary");
	String ebookState = mr.getParameter("ebookState");

	// mr 매개값 디버깅 코드
	System.out.println(ebookIsbn+" <-- ebookIsbn");
	System.out.println(categoryName+" <-- categoryName");
	System.out.println(ebookTitle+" <-- ebookTitle");
	System.out.println(ebookAuthor+" <-- ebookAuthor");
	System.out.println(ebookCompany+" <-- ebookCompany");
	System.out.println(ebookPageCount+" <-- ebookPageCount");
	System.out.println(ebookPrice+" <-- ebookPrice");
	System.out.println(ebookImg+" <-- ebookImg");
	System.out.println(ebookSummary+" <-- ebookSummary");
	System.out.println(ebookState+" <-- ebookState");
	
	// paramEbook 객체 생성 후, 받아온 값 저장
	Ebook paramEbook = new Ebook();
	paramEbook.setEbookISBN(ebookIsbn);
	paramEbook.setCategoryName(categoryName);
	paramEbook.setEbookTitle(ebookTitle);
	paramEbook.setEbookAuthor(ebookAuthor);
	paramEbook.setEbookCompany(ebookCompany);
	paramEbook.setEbookPageCount(ebookPageCount);
	paramEbook.setEbookPrice(ebookPrice);
	paramEbook.setEbookImg(ebookImg);
	paramEbook.setEbookSummary(ebookSummary);
	paramEbook.setEbookState(ebookState);
	
	// 전자책을 추가하는 ebookDao의 insertEbook 메서드 호출
	if(ebookDao.insertEbook(paramEbook)) {
		System.out.println("전자책 입력 성공!");
	} else {
		System.out.println("전자책 입력 실패");
	}
	response.sendRedirect(request.getContextPath()+"/admin/selectEbookList.jsp");
	
%>