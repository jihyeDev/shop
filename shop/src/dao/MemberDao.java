package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import vo.*;
import commons.*;

public class MemberDao {
	// dbUtil 객체 생성
	DBUtil dbUtil = new DBUtil();
	
	// [비회원] 회원가입을 하는 메서드
	// Member 객체로 입력받아온 값을 DB에 insert 함
	public void insertMember(Member member) throws ClassNotFoundException, SQLException {
		// 매개변수 값을 디버깅
		System.out.println(member.getMemberId() + "<--- MemberDao.insertMember parem : memberId");
		System.out.println(member.getMemberPw() + "<--- MemberDao.insertMember parem : memberPw");
		System.out.println(member.getMemberName() + "<--- MemberDao.insertMember parem : memberName");
		System.out.println(member.getMemberAge() + "<--- MemberDao.insertMember parem : memberAge");
		System.out.println(member.getMemberGender() + "<--- MemberDao.insertMember parem : memberGender");
		
		// DB 실행
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
		stmt.executeUpdate();
		
		// 종료
		stmt.close();
		conn.close();
	}
	
	// [회원] 로그인하는 메서드
	// Memeber member : member 객체로 입력받아온 memberId와 memberPw
	public Member login(Member member) throws ClassNotFoundException, SQLException {
		// returnMember 객체를 사용하기 위해 초기화
		Member returnMember = null;
		
		// 매개변수 값을 디버깅
		System.out.println(member.getMemberId() + "<--- MemberDao.deleteMember parem : memberId");
		System.out.println(member.getMemberPw() + "<--- MemberDao.deleteMember parem : memberPw");
		
		// DB 실행
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
	// rowPerPage : 한 페이지에 보여줄 행의 값
	public int selectMemberListLastPage(int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
			
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
}
