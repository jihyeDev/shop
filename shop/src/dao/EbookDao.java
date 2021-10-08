package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import vo.*;
import commons.*;

public class EbookDao {
	
	// [관리자 & 사용자] 전자책 목록을 SELECT하는 메서드
	// SELECT 한 값을 자료구조화 하여 list 생성 후 리턴
	public ArrayList<Ebook> selectEbookList(int beginRow, int rowPerPage) throws ClassNotFoundException, SQLException{
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Ebook> list = new ArrayList<Ebook>();
		
		// 매개변수 값을 디버깅
		System.out.println(beginRow + "<--- EbookDao.selectEbookList parem : beginRow");
		System.out.println(rowPerPage + "<--- EbookDao.selectEbookList parem : rowPerPage");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT ebook_no ebookNo, ebook_isbn ebookISBN, category_name categoryName, ebook_title ebookTitle, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, create_date createDate, update_date updateDate FROM ebook ORDER BY create_date DESC LIMIT ?, ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, beginRow);
		stmt.setInt(2, rowPerPage);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// ebook 객체 생성 후 저장
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookISBN(rs.getString("ebookISBN"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
			ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookSummary(rs.getString("ebookSummary"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setUpdateDate (rs.getString("updateDate"));
			ebook.setCreateDate (rs.getString("createDate"));
			list.add(ebook);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return list;
	}
	
	// [관리자 & 사용자] 선택된 카테고리가 있을 때 전자책 목록을 SELECT하는 메서드
	// SELECT 한 값을 자료구조화 하여 list 생성 후 리턴
	public ArrayList<Ebook> selectEbookListByCategory(int beginRow, int rowPerPage, String categoryName) throws ClassNotFoundException, SQLException{
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Ebook> list = new ArrayList<Ebook>();
		
		// 매개변수 값을 디버깅
		System.out.println(beginRow + "<--- EbookDao.selectEbookListByCategory parem : beginRow");
		System.out.println(rowPerPage + "<--- EbookDao.selectEbookListByCategory parem : rowPerPage");
		System.out.println(categoryName + "<--- EbookDao.selectEbookListByCategory parem : categoryName");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT ebook_no ebookNo, ebook_isbn ebookISBN, category_name categoryName, ebook_title ebookTitle, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, create_date createDate, update_date updateDate FROM ebook WHERE category_name=? ORDER BY create_date DESC LIMIT ?, ?";
		PreparedStatement stmt =conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
				
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// ebook 객체 생성 후 저장
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookISBN(rs.getString("ebookISBN"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
			ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookSummary(rs.getString("ebookSummary"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setUpdateDate (rs.getString("updateDate"));
			ebook.setCreateDate (rs.getString("createDate"));
			list.add(ebook);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
						
		//list를 return
		return list;
	}
	
	// [사용자] 전자책 중에 가장 많이 주문된 4개의 전자책을 SELECT하는 메서드
	// SELECT 한 값을 자료구조화 하여 list 생성 후 리턴
	public ArrayList<Ebook> selectPopularEbookList() throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Ebook> list = new ArrayList<Ebook>();
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT t.ebook_no ebookNo, e.category_name categoryName, e.ebook_title ebookTitle, e.ebook_img ebookImg, e.ebook_price ebookPrice, e.ebook_author ebookAuthor, e.ebook_company ebookCompany, e.ebook_state ebookState FROM ebook e INNER JOIN (SELECT ebook_no, COUNT(ebook_no) cnt FROM orders GROUP BY ebook_no ORDER BY COUNT(ebook_no) DESC LIMIT 0,4) t ON e.ebook_no = t.ebook_no ORDER BY cnt DESC;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// ebook 객체 생성 후 저장
			Ebook ebook = new Ebook();
			ebook.setEbookNo (rs.getInt("ebookNo"));
			ebook.setCategoryName (rs.getString("categoryName"));
			ebook.setEbookTitle (rs.getString("ebookTitle"));
			ebook.setEbookImg (rs.getString("ebookImg"));
			ebook.setEbookPrice (rs.getInt("ebookPrice"));
			ebook.setEbookAuthor (rs.getString("ebookAuthor"));
			ebook.setEbookCompany (rs.getString("ebookCompany"));
			ebook.setEbookState(rs.getString("ebookState"));
			list.add(ebook);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return list;
	}
	
	// [사용자] 전자책 중에 최근 올라온 4개의 전자책을 SELECT하는 메서드
	// SELECT 한 값을 자료구조화 하여 list 생성 후 리턴
	public ArrayList<Ebook> selectCreateEbookList() throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Ebook> list = new ArrayList<Ebook>();
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT ebook_no ebookNo, category_name categoryName, ebook_title ebookTitle, ebook_img ebookImg, ebook_price ebookPrice, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_state ebookState FROM ebook ORDER BY create_date DESC LIMIT 0,4;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// ebook 객체 생성 후 저장
			Ebook ebook = new Ebook();
			ebook.setEbookNo (rs.getInt("ebookNo"));
			ebook.setCategoryName (rs.getString("categoryName"));
			ebook.setEbookTitle (rs.getString("ebookTitle"));
			ebook.setEbookImg (rs.getString("ebookImg"));
			ebook.setEbookPrice (rs.getInt("ebookPrice"));
			ebook.setEbookAuthor (rs.getString("ebookAuthor"));
			ebook.setEbookCompany (rs.getString("ebookCompany"));
			ebook.setEbookState(rs.getString("ebookState"));
			list.add(ebook);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return list;
	}
	
	// [관리자 & 사용자] 검색하였을 때 전자책 목록을 SELECT하는 메서드
	// LIKE를 이용하여 SELECT 한 값을 자료구조화 하고 list 생성 후 리턴
	public ArrayList<Ebook> selectEbookListBySearch(String searchEbookTitle) throws ClassNotFoundException, SQLException{
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Ebook> list = new ArrayList<Ebook>();
		
		// 매개변수 값을 디버깅
		System.out.println(searchEbookTitle + "<--- EbookDao.selectEbookListBySearch parem : searchEbookTitle");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT ebook_no ebookNo, ebook_isbn ebookISBN, category_name categoryName, ebook_title ebookTitle, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, create_date createDate, update_date updateDate FROM ebook WHERE ebook_title LIKE ? ORDER BY create_date DESC";
		PreparedStatement stmt =conn.prepareStatement(sql);
		stmt.setString(1, "%"+searchEbookTitle+"%");
				
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// ebook 객체 생성 후 저장
			Ebook ebook = new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookISBN(rs.getString("ebookISBN"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
			ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookSummary(rs.getString("ebookSummary"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setUpdateDate (rs.getString("updateDate"));
			ebook.setCreateDate (rs.getString("createDate"));
			list.add(ebook);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
							
		//list를 return
		return list;
	}
	
	// [관리자] 전자책 관리 페이지의 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectEbookListLastPage(int ROW_PER_PAGE) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ROW_PER_PAGE + "<--- EbookDao.selectEbookListLastPage parem : ROW_PER_PAGE");
			
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM ebook";
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

	// [관리자] 전자책 관리 페이지의 선택된 카테고리가 있을 시 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectEbookListByCategoryLastPage(int ROW_PER_PAGE, String categoryName) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ROW_PER_PAGE + "<--- EbookDao.selectEbookListByCategoryLastPage parem : ROW_PER_PAGE");
		System.out.println(categoryName + "<--- EbookDao.selectEbookListByCategoryLastPage parem : categoryName");
		
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM ebook WHERE category_name = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryName);
		
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
	
	// [관리자] 전자책의 상세 정보를 SELECT하는 메서드
	// ebookNo를 받아온 뒤 그 ebookNo을 기준으로 정보를 SELECT 함
	// ebook이라는 객체에 저장하여서 리턴 해줌
	public Ebook selecteEbookOne (int ebookNo) throws ClassNotFoundException, SQLException {	
		// ebook 객체를 사용하기 위해 null로 초기화
		Ebook ebook = null;
		
		// 매개변수 값을 디버깅
		System.out.println(ebookNo+" <-- 매개변수 ebookNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT ebook_no ebookNo, ebook_isbn ebookISBN, category_name categoryName, ebook_title ebookTitle, ebook_author ebookAuthor, ebook_company ebookCompany, ebook_page_count ebookPageCount, ebook_price ebookPrice, ebook_img ebookImg, ebook_summary ebookSummary, ebook_state ebookState, create_date createDate, update_date updateDate FROM ebook WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 객체라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// ebook 객체 생성 후 저장
			ebook = new Ebook();
			ebook.setEbookNo(ebookNo);
			ebook.setEbookISBN(rs.getString("ebookISBN"));
			ebook.setCategoryName(rs.getString("categoryName"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
			ebook.setEbookPageCount(rs.getInt("ebookPageCount"));
			ebook.setEbookPrice(rs.getInt("ebookPrice"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookSummary(rs.getString("ebookSummary"));
			ebook.setEbookState(rs.getString("ebookState"));
			ebook.setUpdateDate (rs.getString("updateDate"));
			ebook.setCreateDate (rs.getString("createDate"));
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
			
		//ebook을 return
		return ebook;
	}
	
	// [관리자] 특정 전자책의 이미지를 수정하는 메서드
	// ebook이라는 객체로 ebookNo과 ebookImg(새로운 이미지)를 불러옴
	public boolean updateEbookImg(Ebook ebook) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(ebook + "<--- EbookDao.updateEbookImg parem : Ebook");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE ebook SET ebook_img=?, update_date=now() WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, ebook.getEbookImg());
		stmt.setInt(2, ebook.getEbookNo());
		
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
	
	// [관리자] 특정 전자책의 가격를 수정하는 메서드
	// ebook이라는 객체로 ebookNo과 ebookPrice(수정할 가격)을 불러옴
	public boolean updateEbookPrice(Ebook ebook) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(ebook + "<--- EbookDao.updateEbookPrice parem : Ebook");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE ebook SET ebook_price=?, update_date=now() WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebook.getEbookPrice());
		stmt.setInt(2, ebook.getEbookNo());
		
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
	
	// [관리자] 특정 전자책을 삭제하는 메서드
	// ebook이라는 객체로 ebookNo을 불러옴
	public boolean deleteEbook(Ebook ebook) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(ebook + "<--- EbookDao.deleteEbook parem : Ebook");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "DELETE FROM ebook WHERE ebook_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebook.getEbookNo());
		
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
	
	// [관리자] 전자책을 입력하기 전에 전자책의 중복 검사를 제목을 통해 하는 메서드
	// 중복확인 할 ebookTitleCheck 값을 받아와서 SELECT 하고 ebookTitle에 저장하여 리턴
	// 리턴하는 ebookTitle값이 null이면 입력 가능한 전자책, 아니라면 입력된 전자책
	public String selectEbookTitle(String ebookTitleCheck) throws ClassNotFoundException, SQLException {
		// ebookTitle을 null값으로 지정
		String ebookTitle = null;
			
		// 매개변수 값을 디버깅
		System.out.println(ebookTitleCheck + "<--- ebookDao.selectEbookTitle parem : ebookTitleCheck");
					
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "SELECT ebook_title ebookTitle FROM ebook WHERE ebook_title=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, ebookTitleCheck);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// SELECT 실행 값을 rs에 저장
		ResultSet rs = stmt.executeQuery();
			
		if(rs.next()) {
			ebookTitle = rs.getString("ebookTitle");
		}
					
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		// ebookTitle: null-> 입력가능한 전자책, 아니면 이미 입력된 전자책
		return ebookTitle;
	}
	
	// [관리자] 전자책을 입력(추가) 하는 메서드
	// Ebook 객체로 입력받아온 값을 DB에 insert 함
	public boolean insertEbook(Ebook ebook) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(ebook + "<--- EbookDao.insertEbook parem : Ebook");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO ebook(ebook_isbn, category_name, ebook_title, ebook_author, ebook_company, ebook_page_count, ebook_price, ebook_img, ebook_summary, ebook_state, create_date, update_date) VALUES (?,?,?,?,?,?,?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, ebook.getEbookISBN());
		stmt.setString(2, ebook.getCategoryName());
		stmt.setString(3, ebook.getEbookTitle());
		stmt.setString(4, ebook.getEbookAuthor());
		stmt.setString(5, ebook.getEbookCompany());
		stmt.setInt(6, ebook.getEbookPageCount());
		stmt.setInt(7, ebook.getEbookPrice());
		stmt.setString(8, ebook.getEbookImg());
		stmt.setString(9, ebook.getEbookSummary());
		stmt.setString(10, ebook.getEbookState());
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
	
	// [관리자] 주문목록 중에 가장 많이 팔린 ebook을 SELECT하는 메서드
	// ebook이라는 객체에 저장하여서 리턴 해줌
	public Ebook selectPopularOrder() throws ClassNotFoundException, SQLException {
		// ebook 객체를 사용하기 위해 null로 초기화
		Ebook ebook = null;
				
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT e.ebook_title ebookTitle, e.ebook_img ebookImg, e.ebook_author ebookAuthor, e.ebook_company ebookCompany, t.ebook_no ebookNo, t.ctn ctn FROM ebook e INNER JOIN (SELECT ebook_no, COUNT(ebook_no) ctn FROM orders GROUP BY ebook_no) t ON e.ebook_no = t.ebook_no ORDER BY t.ctn DESC LIMIT 0,1;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			ebook= new Ebook();
			ebook.setEbookNo(rs.getInt("ebookNo"));
			ebook.setEbookTitle(rs.getString("ebookTitle"));
			ebook.setEbookImg(rs.getString("ebookImg"));
			ebook.setEbookAuthor(rs.getString("ebookAuthor"));
			ebook.setEbookCompany(rs.getString("ebookCompany"));
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return ebook;
	}
	
	// [관리자] ebook의 총매출(주문된 ebook_price 값을 sum()을 사용해 더함)을 SELECT하는 메서드
	// int totalSales에 저장하여 리턴해줌
	public int selectTotalEbookPrice() throws ClassNotFoundException, SQLException {
		// 리턴해줄 totalSales 초기화
		int totalSales=0;
				
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT SUM(e.ebook_price) sum FROM orders o INNER JOIN ebook e ON o.ebook_no = e.ebook_no;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// SELECT 한 값을 totalSales에 저장
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			totalSales=rs.getInt("sum");
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//totalSales를 return
		return totalSales;
	}
}