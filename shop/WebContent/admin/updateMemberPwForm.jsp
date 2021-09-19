<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.*" %>
<%@ page import="dao.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<%
	// updateMemberPwForm.jsp 디버깅 구분선
	System.out.println("----------updateMemberPwForm.jsp----------");
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
	// 비밀번호를 수정할 특정회원의 memberNo을 입력 받았는지 유효성 검사
	if(request.getParameter("memberNo")==null || request.getParameter("memberNo").equals("")) {
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
		return;
	}
		

	// request 값 저장
	int memberNo = Integer.parseInt(request.getParameter("memberNo"));
	// requst 매개값 디버깅 코드
	System.out.println(memberNo+" <-- memberNo");
	
	// 특정회원의 정보를 SELECT하는 memberDao의 selectMemberOne 메서드
	// 성공시 : returnMember 객체 받아옴
	// 실패시 : null
	Member returnMember = memberDao.selectMemberOne(memberNo);
	// 디버깅과 실패시 인덱스 페이지로, 성공시 출력
	if(returnMember==null){
		System.out.println("회원정보 불러오기 실패");
		response.sendRedirect(request.getContextPath()+"/admin/selectMemberList.jsp");
	} else {
		System.out.println("회원정보 불러오기 성공");
		System.out.println(returnMember.getMemberNo()+"<--- returnMember.getMemberNo()");
		System.out.println(returnMember.getMemberId()+"<--- returnMember.getMemberId()");
		System.out.println(returnMember.getMemberLevel()+"<--- returnMember.getMemberLevel()");
		System.out.println(returnMember.getMemberName()+"<--- returnMember.getMemberName()");
		System.out.println(returnMember.getMemberAge()+"<--- returnMember.getMemberAge()");
		System.out.println(returnMember.getMemberGender()+"<--- returnMember.getMemberGender()");
		System.out.println(returnMember.getUpdateDate()+"<---returnMember.getUpdateDate()");
		System.out.println(returnMember.getCreateDate()+"<---returnMember.getCreateDate()");
	}
%>
	<div class="container-fluid">
		<div class="row">

			<!-- start: adminMenu include -->
			<div class="col-sm-2 bg-light">
				<jsp:include page="/partial/adminMenu.jsp"></jsp:include>
			</div>
			<!-- end : adminMenu include -->
			
			<div class="col-sm-10 mt-5">
				<h3 class="font-weight-bold">회원목록 <small class="font-weight-light text-secondary">_ 특정회원 비밀번호 수정</small></h3>
				
				<form method="post" action="<%=request.getContextPath()%>/admin/updateMemberPwAction.jsp">
					<table class="table mt-5 w-50">
						<tr>
							<td>NO</td>
							<td><input type="text" name="memberNo" class="form-control" readonly="readonly" value="<%=returnMember.getMemberNo()%>"></td>
						</tr>
						<tr>
							<td>ID</td>
							<td><input type="text" name="memberId" class="form-control" readonly="readonly" value="<%=returnMember.getMemberId()%>"></td>
						</tr>
						<tr class="table-secondary">
							<td>NEW PASSWORD <span class="text-danger">*</span></td>
							<td><input type="text" class="form-control" name="memberPw"></td>
						</tr>
						<tr>
							<td>LEVEL</td>
							<td>
								<%
									// LEVEL을 설정하는 select를 수정하기 전의 카테고리로
									// selected 하기 위해 배열로 생성하여 비교
									// "selected" 문자열을 저장하기 위한 용도의 배열
									String[] levelSelected = new String[3];
									if(returnMember.getMemberLevel()==0){
										levelSelected[0] = "selected";
									} else if(returnMember.getMemberLevel()==1){
										levelSelected[1] = "selected";
									} else if(returnMember.getMemberLevel()==2){
										levelSelected[2] = "selected";
									}
								%>
								<select name="memberLevel" class="custom-select" disabled>
									<option value="0" <%=levelSelected[0]%>>회원 Level.0</option>
									<option value="1" <%=levelSelected[1]%>>관리자 Level.1</option>
									<option value="2" <%=levelSelected[2]%>>관리자 Level.2</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>NAME</td>
							<td><input type="text" name="memberName" class="form-control" readonly="readonly" value="<%=returnMember.getMemberName()%>"></td>
						</tr>
						<tr>
							<td>AGE</td>
							<td><input type="text" name="memberAge" class="form-control" readonly="readonly" value="<%=returnMember.getMemberAge()%>"></td>
						</tr>
						<tr>
							<td>GENDER</td>
							<td>
								<%
									if(returnMember.getMemberGender().equals("남")){
								%>
									<input type="radio" name="memberGender" disabled value="남" checked>남자 
									<input type="radio" name="memberGender" disabled value="여">여자
								<%
									} else {
								%>
									<input type="radio" name="memberGender" disabled value="남">남자 
									<input type="radio" name="memberGender" disabled value="여" checked>여자
								<%
									}
								%>
							</td>
						</tr>
						<tr>
							<td>UPDATE DATE</td>
							<td><input type="text" name="updateDate" class="form-control" readonly="readonly" value="<%=returnMember.getUpdateDate()%>"></td>
						</tr>
						<tr>
							<td>CREATE DATE</td>
							<td><input type="text" name="createDate" class="form-control" readonly="readonly" value="<%=returnMember.getCreateDate()%>"></td>
						</tr>
					</table>
					<button type="submit" class="btn btn-outline-secondary center-block">수정</button>
				</form>
				
			</div>
			
		</div>
	</div>
</body>
</html>