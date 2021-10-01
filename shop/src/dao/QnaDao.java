package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.DBUtil;
import vo.Qna;

public class QnaDao {
	// [사용자] qna를 전체 SELECT하는 메서드
	public ArrayList<Qna> selectQnaList (int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Qna> list = new ArrayList<Qna>();
		
		// 매개변수 값을 디버깅
		System.out.println(beginRow + "<--- QnaDao.selectQnaList parem : beginRow");
		System.out.println(ROW_PER_PAGE + "<--- QnaeDao.selectQnaList parem : ROW_PER_PAGE");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate FROM qna ORDER BY createDate DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// Qna 객체 생성 후 저장
			Qna qna = new Qna();
			qna.setQnaNo(rs.getInt("qnaNo"));
			qna.setQnaCategory(rs.getString("qnaCategory"));
			qna.setQnaTitle(rs.getString("qnaTitle"));
			qna.setQnaContent(rs.getString("qnaContent"));
			qna.setQnaSecret(rs.getString("qnaSecret"));
			qna.setMemberNo(rs.getInt("memberNo"));
			qna.setCreateDate(rs.getString("createDate"));
			qna.setUpdateDate(rs.getString("updateDate"));
			list.add(qna);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		
		//list를 return
		return list;
	}
		
	// [사용자] Qna 목록 페이지의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectQnaListLastPage(int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ROW_PER_PAGE + "<--- qnaDao.selectQnaListLastPage parem : ROW_PER_PAGE");
			
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM qna";
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
	
	// [사용자] Qna의 제목을 사용하여 공지사항을 검색하는 메서드
	public ArrayList<Qna> selectQnaListBySearch (int beginRow, int ROW_PER_PAGE, String searchQnaTitle) throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Qna> list = new ArrayList<Qna>();
			
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate FROM qna WHERE qna_title LIKE ? ORDER BY createDate DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+searchQnaTitle+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// Qna 객체 생성 후 저장
			Qna qna = new Qna();
			qna.setQnaNo(rs.getInt("qnaNo"));
			qna.setQnaCategory(rs.getString("qnaCategory"));
			qna.setQnaTitle(rs.getString("qnaTitle"));
			qna.setQnaContent(rs.getString("qnaContent"));
			qna.setQnaSecret(rs.getString("qnaSecret"));
			qna.setMemberNo(rs.getInt("memberNo"));
			qna.setCreateDate(rs.getString("createDate"));
			qna.setUpdateDate(rs.getString("updateDate"));
			list.add(qna);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//list를 return
		return list;
	}
	
	// [사용자] Qna 페이지의 검색 후의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectQnaListSearchLastPage(int ROW_PER_PAGE, String searchQnaTitle) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM qna WHERE qna_title LIKE ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+searchQnaTitle+"%");
		
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
	
	// [사용자] qna의 상세 정보를 SELECT하는 메서드
	// qnaNo를 받아온 뒤 그 qnaNo을 기준으로 정보를 SELECT 함
	// qna이라는 객체에 저장하여서 리턴 해줌
	public Qna selecteQnaOne (int qnaNo) throws ClassNotFoundException, SQLException {	
		// Qna 객체를 사용하기 위해 null로 초기화
		Qna qna = null;
		
		// 매개변수 값을 디버깅
		System.out.println(qnaNo+" <-- 매개변수 qnaNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT qna_no qnaNo, qna_category qnaCategory, qna_title qnaTitle, qna_content qnaContent, qna_secret qnaSecret, member_no memberNo, create_date createDate, update_date updateDate FROM qna WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 객체라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// Qna 객체 생성 후 저장
			qna = new Qna();
			qna.setQnaNo(rs.getInt("qnaNo"));
			qna.setQnaCategory(rs.getString("qnaCategory"));
			qna.setQnaTitle(rs.getString("qnaTitle"));
			qna.setQnaContent(rs.getString("qnaContent"));
			qna.setQnaSecret(rs.getString("qnaSecret"));
			qna.setMemberNo(rs.getInt("memberNo"));
			qna.setCreateDate(rs.getString("createDate"));
			qna.setUpdateDate(rs.getString("updateDate"));
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//qna를 return
		return qna;
	}
	
	// [회원] QnA 게시글을 입력(추가) 하는 메서드
	// Qna 객체로 입력받아온 값을 DB에 insert 함
	public boolean insertQnaByMember(Qna qna) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(qna + "<--- QnaDao.insertQnaByMember parem : qna");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO qna(qna_title, qna_category, qna_secret, qna_content, member_no, create_date, update_date) VALUES (?,?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaTitle());
		stmt.setString(2, qna.getQnaCategory());
		stmt.setString(3, qna.getQnaSecret());
		stmt.setString(4, qna.getQnaContent());
		stmt.setInt(5, qna.getMemberNo());
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
	
	// [회원] QnA 게시글을 수정하는 메서드
	// Qna라는 객체로 수정할 내용들을 불러옴
	public boolean updateQnaByMember(Qna qna) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(qna + "<--- QnaDao.updateQnaByMember parem : qna");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "UPDATE qna SET qna_title=?, qna_category=?, qna_secret=?, qna_content=?, update_date=now() WHERE qna_no=? && member_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, qna.getQnaTitle());
		stmt.setString(2, qna.getQnaCategory());
		stmt.setString(3, qna.getQnaSecret());
		stmt.setString(4, qna.getQnaContent());
		stmt.setInt(5, qna.getQnaNo());
		stmt.setInt(6, qna.getMemberNo());
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
	
	// [회원] 특정 QnA를 삭제하는 메서드
	// 받아온 qnaNo을 가지고 있는 qna 테이블의 행 삭제
	public boolean deleteQnaByMember(int qnaNo) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(qnaNo + "<--- qnaDao.deleteQnaByMember parem : qnaNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM qna WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		
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
				
		// 성공 : result = true, 실패 : false
		return result;
	}
	
	// [관리자] qna 중에서 답글이 달리지 않은 qna 게시글을 SELECT하는 메서드
	// SELECT 한 값을 자료구조화 하여 list 생성 후 리턴
	public ArrayList<Qna> selectNoCommentQnaList() throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Qna> list = new ArrayList<Qna>();
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT q.*, qc.* FROM qna q LEFT JOIN qna_comment qc ON q.qna_no = qc.qna_no WHERE qc.qna_no IS NULL;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		
		while(rs.next()) {
			// Qna 객체 생성 후 저장
			Qna qna = new Qna();
			qna.setQnaNo(rs.getInt("qna_no"));
			qna.setQnaCategory(rs.getString("qna_category"));
			qna.setQnaTitle(rs.getString("qna_title"));
			qna.setQnaContent(rs.getString("qna_content"));
			qna.setQnaSecret(rs.getString("qna_secret"));
			qna.setMemberNo(rs.getInt("member_no"));
			qna.setCreateDate(rs.getString("create_date"));
			qna.setUpdateDate(rs.getString("update_date"));
			list.add(qna);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return list;
	}
}
