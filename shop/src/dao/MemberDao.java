package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import vo.*;
import commons.*;

public class MemberDao {
	
	// [비회원] 회원가입을 하기 전에 아이디 중복 검사를 하는 메서드
	// 중복확인 할 memberIdCheck 값을 받아와서 SELECT 하고 memberId에 저장하여 리턴
	// 리턴하는 memberId값이 null이면 사용 가능한 ID, 아니라면 이미 사용중인 ID
	public String selectMemberId(String memberIdCheck) throws ClassNotFoundException, SQLException {
		// memberId를 null값으로 지정
		String memberId = null;
		
		// 매개변수 값을 디버깅
		System.out.println(memberIdCheck + "<--- MemberDao.selectMemberId parem : memberIdCheck");
				
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "SELECT member_id memberId FROM member WHERE member_id=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberIdCheck);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// SELECT 실행 값을 rs에 저장
		ResultSet rs = stmt.executeQuery();
		
		if(rs.next()) {
			memberId = rs.getString("memberId");
		}
				
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		// memberId: null->사용 가능한 ID, 아니면 이미 사용중인 ID
		return memberId;
	}
	
	// [비회원] 회원가입을 하는 메서드
	// Member 객체로 입력받아온 값을 DB에 insert 함
	public boolean insertMember(Member member) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(member + "<--- MemberDao.insertMember parem : member");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO member(member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) VALUES (?,PASSWORD(?),0,?,?,?,NOW(),NOW())";
		/*
		 * INSERT INTO member(member_id, member_pw, member_level, member_name, member_age, member_gender, update_date, create_date) VALUES (?,PASSWORD(?),0,?,?,?,NOW(),NOW())
		 * LEVEL은 무조건 0으로 설정한 뒤, 관리자가 LEVEL을 지정한다
		 * PASSWORD() 함수를 사용하여 member_pw을 암호화 한다
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		stmt.setString(3, member.getMemberName());
		stmt.setInt(4, member.getMemberAge());
		stmt.setString(5, member.getMemberGender());
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// INSERT 실행
		int row = stmt.executeUpdate();
		if(row == 1) {
			result = true;
		}
		
		// 종료
		stmt.close();
		conn.close();
		
		// 성공 : result = true, 실패 : false
		return result;
	}
	
	// [회원] 로그인하는 메서드
	// Memeber member : member 객체로 입력받아온 memberId와 memberPw
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		// returnMember 객체를 사용하기 위해 초기화
		Member returnMember = null;
		
		// 매개변수 값을 디버깅
		System.out.println(member + "<--- MemberDao.deleteMember parem : member");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel FROM member WHERE member_id=? AND member_pw=PASSWORD(?)";
		/*
		 * SELECT member_no memberNo, member_id memberId, member_level memberLevel FROM member WHERE member_id=? AND member_pw=PASSWORD(?)
		 * PASSWORD() 함수로 암호화된 값을 사용할 때는 PASSWORD()함수를 다시 사용한다
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, member.getMemberId());
		stmt.setString(2, member.getMemberPw());
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// SELECT 실행 값을 rs에 저장
		ResultSet rs = stmt.executeQuery();
		
		// 로그인 성공시 리턴값 Member : memberNo + memberId + memberLevel
		// 로그인 실패시 리턴값 Member : null
		if(rs.next()) {
			returnMember = new Member();
			returnMember.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			returnMember.setMemberId(rs.getString("memberId"));
			returnMember.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
		}
		
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		//returnMember 객체를 return
		return returnMember;
	}
	
	// [관리자] 회원 목록을 출력하는 메서드
	public ArrayList<Member> selectMemberListAllByPage (int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Member> list = new ArrayList<Member>();
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member ORDER BY createDate DESC LIMIT ?,?";
		/*
		 * SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, creat_date createDate FROM member ORDER BY createDate DESC;
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// member 객체 생성 후 저장
			Member member = new Member();
			member.setMemberNo(rs.getInt("memberNo"));
			member.setMemberId (rs.getString("memberId"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setMemberName (rs.getString("memberName"));
			member.setMemberAge(rs.getInt("memberAge"));
			member.setMemberGender (rs.getString("memberGender"));
			member.setUpdateDate (rs.getString("UpdateDate"));
			member.setCreateDate (rs.getString("CreateDate"));
			list.add(member);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		
		//list를 return
		return list;
	}
		
	// [관리자] 회원 목록 페이지의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectMemberListLastPage(int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ROW_PER_PAGE + "<--- MemberDao.selectMemberListLastPage parem : ROW_PER_PAGE");
			
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM member";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		ResultSet rs = stmt.executeQuery();
		// 디버깅 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println("총 행의 개수 stmt : "+stmt);
		
		// totalCount 저장
		if(rs.next()) {
			totalCount = rs.getInt("count(*)");
		}
		System.out.println("totalCounnt(총 행의 개수) : "+totalCount);
			
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage+=1;
		}
		System.out.println("lastPage(마지막 페이지 번호) : "+lastPage);
			
		rs.close();
		stmt.close();
		conn.close();
			
		return lastPage;
	}
	
	// [관리자] 회원아이디를 사용하여 회원을 검색하는 메서드
	public ArrayList<Member> selectMemberListAllBySearchMemberId (int beginRow, int ROW_PER_PAGE, String searchMemberId) throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Member> list = new ArrayList<Member>();
			
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member WHERE member_id LIKE ? ORDER BY createDate DESC LIMIT ?,?";
		/*
		 * SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, creat_date createDate FROM member WHERE member_id LIKE ? ORDER BY createDate DESC;
		 */
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+searchMemberId+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// member 객체 생성 후 저장
			Member member = new Member();
			member.setMemberNo(rs.getInt("memberNo"));
			member.setMemberId (rs.getString("memberId"));
			member.setMemberLevel(rs.getInt("memberLevel"));
			member.setMemberName (rs.getString("memberName"));
			member.setMemberAge(rs.getInt("memberAge"));
			member.setMemberGender (rs.getString("memberGender"));
			member.setUpdateDate (rs.getString("updateDate"));
			member.setCreateDate (rs.getString("createDate"));
			list.add(member);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//list를 return
		return list;
	}
	
	// [관리자] 회원 목록 페이지의 검색 후의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectMemberListSearchLastPage(int ROW_PER_PAGE, String searchMemberId) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM member WHERE member_id LIKE ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+searchMemberId+"%");
		
		ResultSet rs = stmt.executeQuery();
		// 디버깅 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println("총 행의 개수 stmt : "+stmt);
		
		// totalCount 저장
		if(rs.next()) {
			totalCount = rs.getInt("count(*)");
		}
		System.out.println("totalCounnt(총 행의 개수) : "+totalCount);
				
		// 마지막 페이지
		// lastPage를 전체 행의 수와 한 페이지에 보여질 행의 수(rowPerPage)를 이용하여 구한다
		lastPage = totalCount / ROW_PER_PAGE;
		if(totalCount % ROW_PER_PAGE != 0) {
			lastPage+=1;
			}
		System.out.println("lastPage(마지막 페이지 번호) : "+lastPage);
				
		rs.close();
		stmt.close();
		conn.close();
				
		return lastPage;
	}
	
	// [관리자] 특정회원의 정보를 SELECT하는 메서드
	// memberNo를 받아와서 한 행을 SELECT 한 뒤 자료구조화
	public Member selectMemberOne (int memberNo) throws ClassNotFoundException, SQLException {	
		// member 객체를 사용하기 위해 null로 초기화
		Member member = null;
		
		// 매개변수 값을 디버깅
		System.out.println(memberNo+" <-- 매개변수 memberNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT member_no memberNo, member_id memberId, member_level memberLevel, member_name memberName, member_age memberAge, member_gender memberGender, update_date updateDate, create_date createDate FROM member WHERE member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 객체라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// member 객체 생성 후 저장
			member = new Member();
			member.setMemberNo(Integer.parseInt(rs.getString("memberNo")));
			member.setMemberId (rs.getString("memberId"));
			member.setMemberLevel(Integer.parseInt(rs.getString("memberLevel")));
			member.setMemberName (rs.getString("memberName"));
			member.setMemberAge(Integer.parseInt(rs.getString("memberAge")));
			member.setMemberGender (rs.getString("memberGender"));
			member.setUpdateDate (rs.getString("UpdateDate"));
			member.setCreateDate (rs.getString("CreateDate"));
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//member를 return
		return member;
	}
	
	
	// [관리자] 특정회원의 레벨을 변경하는 메서드
	// memberNo과 수정된 level을 입력받아와서 수정
	// Member member : memberNo값
	// String MemberNewLevel : 변경할 memberLevel 값
	public boolean updateMemberLevelByAdmin(Member member, int memberNewLevel) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수값은 무조건! 디버깅
		System.out.println(member + "<--- MemberDao.updateMemberLevelByAdmin parem : member");
		System.out.println(memberNewLevel + "<--- MemberDao.updateMemberLevelByAdmin parem : memberNewLevel");
						
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE member SET member_level=?, update_date=now() WHERE member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNewLevel);
		stmt.setInt(2, member.getMemberNo());
						
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
						
		// UPDATE 실행
		int row = stmt.executeUpdate();
		if(row == 1) {
			result = true;
		}
		// 종료
		stmt.close();
		conn.close();
		
		// 성공 : result = true, 실패 : false
		return result;
	}
	
	// [관리자] 특정회원의 비밀번호를 변경하는 메서드
	// memberNo과 수정된 비밀번호를 입력받아와서 비밀번호를 변경
	// Member member : memberNo값
	// String MemberNewPw : 변경할 memberPw 값
	public boolean updateMemberPwByAdmin(Member member, String memberNewPw) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수값은 무조건! 디버깅
		System.out.println(member + "<--- MemberDao.updateMemberPwByAdmin parem : member");
		System.out.println(memberNewPw + "<--- MemberDao.updateMemberPwByAdmin parem : memberNewPw");
								
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE member SET member_pw=PASSWORD(?), update_date=now() WHERE member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, memberNewPw);
		stmt.setInt(2, member.getMemberNo());
								
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
								
		// UPDATE 실행
		int row = stmt.executeUpdate();
		if(row == 1) {
			result = true;
		}
						
		// 종료
		stmt.close();
		conn.close();
		
		return result;
	}
	
	// [관리자] 특정회원을 삭제하는 메서드
	// memberNo를 입력받아와서 삭제하는 메서드
	public boolean deleteMemberByAdmin(int memberNo) throws ClassNotFoundException, SQLException{
		boolean result = false;
		
		// 매개변수값은 무조건! 디버깅
		System.out.println(memberNo + "<--- MemberDao.deleteMemberByAdmin parem : memberNo");
										
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM member WHERE member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, memberNo);
										
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
										
		// DELETE 실행
		int row = stmt.executeUpdate();
		if(row == 1) {
			result = true;
		}
								
		// 종료
		stmt.close();
		conn.close();
		
		return result;
	}
	
	// [관리자] 전체 회원의 수를 알 수 있는 메서드
	// totalMember(전체 회원)의 값을 구해서 리턴해줌
	public int selectTotalMember() throws ClassNotFoundException, SQLException{
		int totalMember = 0;
			
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM member";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		ResultSet rs = stmt.executeQuery();
		// 디버깅 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println("총 행의 개수 stmt : "+stmt);
		
		// totalMember 저장
		if(rs.next()) {
			totalMember = rs.getInt("count(*)");
		}
			
		rs.close();
		stmt.close();
		conn.close();
			
		return totalMember;
	}
}
