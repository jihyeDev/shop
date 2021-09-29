package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import commons.*;
import vo.*;

public class NoticeDao {
	// [사용자] 공지사항을 전체 SELECT하는 메서드
	public ArrayList<Notice> selectNoticeList (int beginRow, int ROW_PER_PAGE) throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Notice> list = new ArrayList<Notice>();
		
		// 매개변수 값을 디버깅
		System.out.println(beginRow + "<--- NoticeDao.selectNoticeList parem : beginRow");
		System.out.println(ROW_PER_PAGE + "<--- NoticeDao.selectNoticeList parem : ROW_PER_PAGE");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate FROM notice ORDER BY createDate DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, ROW_PER_PAGE);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// notice 객체 생성 후 저장
			Notice notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle (rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate (rs.getString("createDate"));
			notice.setUpdateDate (rs.getString("updateDate"));
			list.add(notice);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		
		//list를 return
		return list;
	}
		
	// [사용자] 공지사항 목록 페이지의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectNoticeListLastPage(int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ROW_PER_PAGE + "<--- NoticeDao.selectNoticeListLastPage parem : ROW_PER_PAGE");
			
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM notice";
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
	
	// [사용자] 공지사항의 제목을 사용하여 공지사항을 검색하는 메서드
	public ArrayList<Notice> selectNoticeListBySearch (int beginRow, int ROW_PER_PAGE, String searchNoticeTitle) throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Notice> list = new ArrayList<Notice>();
			
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, member_no memberNo, create_date createDate, update_date updateDate FROM notice WHERE notice_title LIKE ? ORDER BY createDate DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+searchNoticeTitle+"%");
		stmt.setInt(2, beginRow);
		stmt.setInt(3, ROW_PER_PAGE);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// notice 객체 생성 후 저장
			Notice notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle (rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate (rs.getString("createDate"));
			notice.setUpdateDate (rs.getString("updateDate"));
			list.add(notice);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//list를 return
		return list;
	}
	
	// [사용자] 공지사항 페이지의 검색 후의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectNoticeListSearchLastPage(int ROW_PER_PAGE, String searchNoticeTitle) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM notice WHERE notice_title LIKE ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1,"%"+searchNoticeTitle+"%");
		
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
	
	// [사용자] 공지사항의 상세 정보를 SELECT하는 메서드
	// noticeNo를 받아온 뒤 그 noticeNo을 기준으로 정보를 SELECT 함
	// notice이라는 객체에 저장하여서 리턴 해줌
	public Notice selecteNoticeOne (int noticeNo) throws ClassNotFoundException, SQLException {	
		// notice 객체를 사용하기 위해 null로 초기화
		Notice notice = null;
		
		// 매개변수 값을 디버깅
		System.out.println(noticeNo+" <-- 매개변수 noticeNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_Content noticeContent, member_no memberNo, create_date createDate, update_date updateDate FROM notice WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 객체라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// notice 객체 생성 후 저장
			notice = new Notice();
			notice.setNoticeNo(rs.getInt("noticeNo"));
			notice.setNoticeTitle(rs.getString("noticeTitle"));
			notice.setNoticeContent(rs.getString("noticeContent"));
			notice.setMemberNo(rs.getInt("memberNo"));
			notice.setCreateDate(rs.getString("createDate"));
			notice.setUpdateDate(rs.getString("updateDate"));
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//notice을 return
		return notice;
	}
	
	// [관리자] 공지사항 게시글을 수정하는 메서드
	// notice라는 객체로 수정할 내용들을 불러옴
	public boolean updateNoticeByAdmin(Notice notice) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(notice.getNoticeNo() + "<--- NoticeDao.updateNoticeByAdmin parem : noticeNo");
		System.out.println(notice.getNoticeTitle() + "<--- NoticeDao.updateNoticeByAdmin parem : noticeTitle");
		System.out.println(notice.getNoticeContent() + "<--- NoticeDao.updateNoticeByAdmin parem : noticeContent");
		System.out.println(notice.getMemberNo() + "<--- NoticeDao.updateNoticeByAdmin parem : memberNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE notice SET notice_title=?, notice_content=?, member_no=?, update_date=now() WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getMemberNo());
		stmt.setInt(4, notice.getNoticeNo());
		
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
	
	// [관리자] 특정 공지사항을 삭제하는 메서드
	// 받아온 noticeNo을 가지고 있는 notice 테이블의 행 삭제
	public boolean deleteNoticeByAdmin(int noticeNo) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(noticeNo + "<--- NoticeDao.deleteNoticeByAdmin parem : noticeNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM notice WHERE notice_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, noticeNo);
		
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
	
	// [관리자] 공지사항 게시글을 입력(추가) 하는 메서드
	// Notice 객체로 입력받아온 값을 DB에 insert 함
	public boolean insertNoticeByAdmin(Notice notice) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(notice.getNoticeTitle() + "<--- NoticeDao.insertNoticeByAdmin parem : noticeTitle");
		System.out.println(notice.getNoticeContent() + "<--- NoticeDao.insertNoticeByAdmin parem : noticeContent");
		System.out.println(notice.getMemberNo() + "<--- NoticeDao.insertNoticeByAdmin parem : memberNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO notice(notice_title, notice_content, member_no, create_date, update_date) VALUES (?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, notice.getNoticeTitle());
		stmt.setString(2, notice.getNoticeContent());
		stmt.setInt(3, notice.getMemberNo());
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
}
