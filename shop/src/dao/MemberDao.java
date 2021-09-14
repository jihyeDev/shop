package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import vo.*;
import commons.*;

public class MemberDao {
	// dbUtil 객체 생성
	DBUtil dbUtil = new DBUtil();
	
	// 회원가입을 하는 메서드
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
	
	// 로그인
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
}
