package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

import vo.*;
import commons.*;

public class CategoryDao {
	
	// [관리자] 카테고리 목록을 출력하는 메서드
	// SELECT 한 값을 자료구조화 하여 list 생성 후 리턴
	public ArrayList<Category> selectCategoryListAllByPage () throws ClassNotFoundException, SQLException {
		// list라는 리스트를 사용하기 위해 생성
		ArrayList<Category> list = new ArrayList<Category>();
		
		// DB 실행
		// dbUtil 객체 생성
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "SELECT category_name categoryName, category_state categoryState, update_date updateDate, create_date createDate FROM category";
		PreparedStatement stmt = conn.prepareStatement(sql);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
		
		// 데이터 가공 (자료구조화)
		// ResultSet이라는 특수한 타입에서 ArrayList라는 일반화된 타입으로 변환(가공)
		ResultSet rs = stmt.executeQuery();
		while(rs.next()) {
			// Category 객체 생성 후 저장
			Category category = new Category();
			category.setCategoryName (rs.getString("categoryName"));
			category.setCategoryState (rs.getString("categoryState"));
			category.setUpdateDate (rs.getString("UpdateDate"));
			category.setCreateDate (rs.getString("CreateDate"));
			list.add(category);
		}
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		
		//list를 return
		return list;
	}
	
	// [관리자] 카테고리를 입력하기 전에 카테고리 이름의 중복 검사를 하는 메서드
	// 중복확인 할 categoryNameCheck 값을 받아와서 SELECT 하고 categoryName에 저장하여 리턴
	// 리턴하는 categoryName값이 null이면 사용 가능한 카테고리 이름, 아니라면 이미 사용중인 카테고리 이름
	public String selectCategoryName(String categoryNameCheck) throws ClassNotFoundException, SQLException {
		// categoryName을 null값으로 지정
		String categoryName = null;
			
		// 매개변수 값을 디버깅
		System.out.println(categoryNameCheck + "<--- CategoryDao.selectCategoryName parem : categoryNameCheck");
					
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "SELECT category_name categoryName FROM category WHERE category_name=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryNameCheck);
		// 디버깅 코드 : 쿼리내용과 표현식의 파라미터값 확인가능
		System.out.println(stmt + "<--- stmt");
			
		// SELECT 실행 값을 rs에 저장
		ResultSet rs = stmt.executeQuery();
			
		if(rs.next()) {
			categoryName = rs.getString("categoryName");
		}
					
		// 종료
		rs.close();
		stmt.close();
		conn.close();
		// memberIdcategoryName: null->사용 가능한 카테고리 이름, 아니면 이미 사용중인 카테고리 이름
		return categoryName;
	}
	
	// [관리자] 카테고리를 입력하는 메서드
	// Category 객체로 입력받아온 값을 category table에 INSERT 함
	public boolean insertCategory(Category category) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수 값을 디버깅
		System.out.println(category.getCategoryName() + "<--- CategoryDao.insertCategory parem : categoryName");
		System.out.println(category.getCategoryState() + "<--- CategoryDao.insertCategory parem : categoryState");
		
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		// dbUtil의 getConnection메서드를 사용하여 DB 연결
		Connection conn = dbUtil.getConnection();
		System.out.println(conn + "<--- conn");
		String sql = "INSERT INTO category(category_name, category_state, update_date, create_date) VALUES (?,?,NOW(),NOW())";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, category.getCategoryName());
		stmt.setString(2, category.getCategoryState());
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
		
		return result;
	}
	
	// [관리자] 특정 카테고리의 사용현황을 변경하는 메서드
	// categoryName과 수정된 사용현황을 입력받아와서 수정
	// Category category : categoryName 값
	// String CategoryNewState : 변경한 사용현황의 값
	public boolean updateCategoryState(Category category, String categoryNewState) throws ClassNotFoundException, SQLException {
		boolean result = false;
		
		// 매개변수값은 무조건! 디버깅
		System.out.println(category.getCategoryName() + "<--- CategoryDao.updateCategoryState parem : categoryName");
		System.out.println(categoryNewState + "<--- CategoryDao.updateCategoryState parem : categoryNewState");
						
		// DB 실행
		DBUtil dbUtil = new DBUtil();
		Connection conn = dbUtil.getConnection();
		String sql = "UPDATE category SET category_state=?, update_date=now() WHERE category_name=?";
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setString(1, categoryNewState);
		stmt.setString(2, category.getCategoryName());
						
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
}
