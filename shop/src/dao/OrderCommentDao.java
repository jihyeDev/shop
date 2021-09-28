package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import vo.*;
import commons.*;

public class OrderCommentDao {
	// [회원] 후기를 입력(추가) 하는 메서드
	// Ebook 객체로 입력받아온 값을 DB에 insert 함
	public boolean insertOrderComment(OrderComment comment) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(comment.getOrderNo() + "<--- OrderCommentDao.insertOrderComment parem : OrderNo");
		System.out.println(comment.getEbookNo() + "<--- OrderCommentDao.insertOrderComment parem : EbookNo");
		System.out.println(comment.getOrderScore() + "<--- OrderCommentDao.insertOrderComment parem : OrderScore");
		System.out.println(comment.getOrderCommentContent() + "<--- OrderCommentDao.insertOrderComment parem : OrderCommentContent");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO order_comment(order_no, ebook_no, order_score, order_comment_content, create_date, update_date) VALUES (?,?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, comment.getOrderNo());
		stmt.setInt(2, comment.getEbookNo());
		stmt.setInt(3, comment.getOrderScore());
		stmt.setString(4, comment.getOrderCommentContent());
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
	
	// [사용자] 후기 별점의 평균을 구하는 메서드
	// 받아온 ebookNo를 기준으로 AVG를 사용하여 SELECT 함
	public double selectOrderScoreAvg(int ebookNo) throws ClassNotFoundException, SQLException{
		double avgScore = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ebookNo + "<--- OrderCommentDao.selectOrderScoreAvg parem : ebookNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "SELECT AVG(order_score) FROM order_comment WHERE ebook_no=? GROUP BY ebook_no;";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		
		ResultSet rs = stmt.executeQuery();
		if(rs.next()) {
			avgScore = rs.getInt("AVG(order_score)");
		}
		
		// 종료
		stmt.close();
		conn.close();
		rs.close();
		
		return avgScore;
	}
	
	// [사용자] 후기를 SELECT 하는 메서드
	// 받아온 ebookNO를 기준으로 SELECT 하고 페이징함
	public ArrayList<OrderComment> selectCommentList(int beginRow, int rowPerPage, int ebookNo) throws ClassNotFoundException, SQLException{
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<OrderComment> list = new ArrayList<OrderComment>();
		
		// 매개변수 값을 디버깅
		System.out.println(beginRow + "<--- OrderCommentDao.selectCommentList parem : beginRow");
		System.out.println(rowPerPage + "<--- OrderCommentDao.selectCommentList parem : rowPerPage");
		System.out.println(ebookNo + "<--- OrderCommentDao.selectCommentList parem : ebookNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT order_score orderScore, order_comment_content orderCommentContent, create_date createDate FROM order_comment WHERE ebook_no=? ORDER BY create_date DESC LIMIT ?,?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		stmt.setInt(2, beginRow);
		stmt.setInt(3, rowPerPage);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// orderComment 객체 생성 후 저장
			OrderComment orderComment = new OrderComment();
			orderComment.setOrderScore (rs.getInt("orderScore"));
			orderComment.setOrderCommentContent (rs.getString("orderCommentContent"));
			orderComment.setCreateDate (rs.getString("createDate"));
			list.add(orderComment);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return list;
	}
	
	// [사용자] 전자책 상세페이지의 후기를 페이징하기 위해 마지막 페이지를 구하는 메서드
	// totalCount(전체 행)의 값을 구해서 마지막 페이지의 값을 리턴해줌
	// ROW_PER_PAGE : 한 페이지에 보여줄 행의 값
	public int selectCommentListLastPage(int ROW_PER_PAGE, int ebookNo) throws ClassNotFoundException, SQLException{
		int totalCount = 0;
		int lastPage = 0;
		
		// 매개변수 값을 디버깅
		System.out.println(ROW_PER_PAGE + "<--- OrderCommentDao.selectCommentListLastPage parem : ROW_PER_PAGE");
		System.out.println(ebookNo + "<--- OrderCommentDao.selectCommentListLastPage parem : ebookNo");
		
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT count(*) FROM order_comment WHERE ebook_no = ?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ebookNo);
		
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
