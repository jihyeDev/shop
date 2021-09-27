package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
}
