package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import data.dto.UserDTO;
import db.connect.MysqlConnect;

public class UserDAO {
	private MysqlConnect db = new MysqlConnect();
	
	// 회원가입
	public void registerUser(UserDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = """
				insert into users
				(username, password, nickname, email, profile, admin, created_at)
				values(?, ?, ?, ?, ?, ?, now())
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPassword());
			pstmt.setString(3, dto.getNickname());
			pstmt.setString(4, dto.getEmail());		
			pstmt.setString(5, dto.getProfile());		
			pstmt.setBoolean(6, dto.isAdmin());
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
		
	}
	
	// 단일 유저 얻기
	public UserDTO getUserByID(int user_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select * from users
				where user_id = ?
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				UserDTO dto = new UserDTO();
				dto.setUser_id(rs.getInt("user_id"));
				dto.setUsername(rs.getString("username"));
				dto.setPassword(rs.getString("password"));
				dto.setNickname(rs.getString("nickname"));
				dto.setEmail(rs.getString("email"));
				dto.setProfile(rs.getString("profile"));
				dto.setAdmin(rs.getBoolean("admin"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
				return dto;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return null;
	}
	
	// 로그인 - ID & PWD 검증
	public UserDTO login(String username, String password) {		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select * from users
				where username = ? AND password = ?
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, username);
			pstmt.setString(2, password);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				UserDTO dto = new UserDTO();
				dto.setUser_id(rs.getInt("user_id"));
				dto.setUsername(rs.getString("username"));
				dto.setPassword(rs.getString("password"));
				dto.setNickname(rs.getString("nickname"));
				dto.setEmail(rs.getString("email"));
				dto.setProfile(rs.getString("profile"));
				dto.setAdmin(rs.getBoolean("admin"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
				return dto;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return null;
	}

	// 프로필 업데이트
	public void userProfileUpdate(UserDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = """
				update users set
				username = ?, password = ?, nickname = ?, email = ?, profile = ?
				where user_id = ?
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getUsername());
			pstmt.setString(2, dto.getPassword());
			pstmt.setString(3, dto.getNickname());
			pstmt.setString(4, dto.getEmail());
			pstmt.setString(5, dto.getProfile());
			pstmt.setInt(6, dto.getUser_id());
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	
	/*관리자 기능*/
	// 모든 유저 획득
	public List<UserDTO> getAllUsers() {
		List<UserDTO> list = new Vector<UserDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select * from users				
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				UserDTO dto = new UserDTO();
				dto.setUser_id(rs.getInt("user_id"));
				dto.setUsername(rs.getString("username"));
				dto.setPassword(rs.getString("password"));
				dto.setNickname(rs.getString("nickname"));
				dto.setEmail(rs.getString("email"));
				dto.setProfile(rs.getString("profile"));
				dto.setAdmin(rs.getBoolean("admin"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				
				list.add(dto);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	// 유저 삭제
	public void userDelete(int user_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = """
				delete from users
				where user_id = ?		
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_id);
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	// 유저 - 관리자 승격
	public void userAdminUp(int user_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = """
				update users set
				admin = true
				where user_id = ?				
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_id);
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	
}
