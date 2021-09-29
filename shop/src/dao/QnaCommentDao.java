package dao;

import java.sql.*;

import vo.*;
import commons.*;

public class QnaCommentDao {
	
	// [관리자] 후기를 입력(추가) 하는 메서드
	// QnaComment 객체로 입력받아온 값을 DB에 insert 함
	public boolean insertQnaComment(QnaComment comment) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(comment.getQnaNo() + "<--- QnaCommentDao.insertQnaComment parem : qnaNo");
		System.out.println(comment.getMemberNo() + "<--- QnaCommentDao.insertQnaComment parem : memberNo");
		System.out.println(comment.getQnaCommentContent() + "<--- QnaCommentDao.insertQnaComment parem : qnaCommentContent");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO qna_comment(qna_no, member_no, qna_comment_content, create_date, update_date) VALUES (?,?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, comment.getQnaNo());
		stmt.setInt(2, comment.getMemberNo());
		stmt.setString(3, comment.getQnaCommentContent());
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
	
	// [사용자] QnA 답변을 SELECT 하는 메서드
	// 받아온 qnaNo를 기준으로 SELECT 한 뒤 comment라는 객체에 저장해서 리턴
	public QnaComment selectQnaComment(int qnaNo) throws ClassNotFoundException, SQLException{
		// qna 객체를 사용하기 위해 null로 초기화
		QnaComment qnaComment = null;
		
		// 매개변수 값을 디버깅
		System.out.println(qnaNo + "<--- qnaCommentDao.selectQnaComment parem : qnaNo");
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT qna_comment_content qnaCommentContent, create_date createDate FROM qna_comment WHERE qna_no=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, qnaNo);
		
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// qnaComment 객체 생성 후 저장
			qnaComment = new QnaComment();
			qnaComment.setQnaCommentContent (rs.getString("qnaCommentContent"));
			qnaComment.setCreateDate (rs.getString("createDate"));
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
				
		//list를 return
		return qnaComment;
	}

}
