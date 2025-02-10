package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import data.dto.BoardDTO;
import db.connect.MysqlConnect;

public class BoardDAO {
private MysqlConnect db = new MysqlConnect();
	
	// 게시글 작성 - insert
	public void createBoard(BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;		
		
		String sql = """
				insert into boards
				(user_id, tag_id, title, content, is_secret, created_at, updated_at)
				values(?, ?, ?, ?, ?, now(), now())
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getUser_id());			
			pstmt.setInt(2, dto.getTag_id());
			pstmt.setString(3, dto.getTitle());
			pstmt.setString(4, dto.getContent());
			pstmt.setBoolean(5, dto.isIs_secret());

			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
				
	}
	
	// 게시글 목록  조회 - 필터링 포함
	public List<BoardDTO> getALLBoards(int tag_id) {
		List<BoardDTO> list = new Vector<BoardDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = "";
		if(tag_id == 0) {
			sql = """
					select b.*, u.nickname, t.name
					from boards b
					join users u on b.user_id = u.user_id
					join tags t on b.tag_id = t.tag_id
					order by b.created_at desc
					""";
		} else {
			sql = """
					select b.*, u.nickname, t.name
					from boards b
					join users u on b.user_id = u.user_id
					join tags t on b.tag_id = t.tag_id
					where b.tag_id = ?
					order by b.created_at desc
					""";
		}
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			if(tag_id != 0) {
				pstmt.setInt(1, tag_id);
			}
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setBoard_id(rs.getInt("board_id"));
				dto.setUser_id(rs.getInt("user_id"));
				dto.setTag_id(rs.getInt("tag_id"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setIs_secret(rs.getBoolean("is_secret"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				dto.setUpdated_at(rs.getTimestamp("updated_at"));
				
				dto.setNickname(rs.getString("nickname"));
				dto.setTag_name(rs.getString("name"));
				
				list.add(dto);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return list;
	}
	
	// 공지글만 가져오기
	public List<BoardDTO> getALLNotice() {
		List<BoardDTO> list = getALLBoards(1);
		
		return list;
	}
	
	// 검색란 제목 검색
	public List<BoardDTO> getSearchBoard(String title) {
		List<BoardDTO> list = new Vector<BoardDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select b.*, u.nickname, t.name
				from boards b
				join users u on b.user_id = u.user_id
				join tags t on b.tag_id = t.tag_id
				where title like ?
				order by b.created_at desc
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+title+"%");
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BoardDTO dto = new BoardDTO();
				dto.setBoard_id(rs.getInt("board_id"));
				dto.setUser_id(rs.getInt("user_id"));
				dto.setTag_id(rs.getInt("tag_id"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setIs_secret(rs.getBoolean("is_secret"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				dto.setUpdated_at(rs.getTimestamp("updated_at"));
				
				dto.setNickname(rs.getString("nickname"));
				dto.setTag_name(rs.getString("name"));
				
				list.add(dto);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		
		return list;
	}
	
	// 보드 상세보기
	public BoardDTO getBoard(int board_id) {
		BoardDTO dto = new BoardDTO();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select b.*, u.nickname, u.profile, t.name
					from boards b
					join users u on b.user_id = u.user_id
					join tags t on b.tag_id = t.tag_id
					where b.board_id = ?
					order by b.created_at desc
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);	
			pstmt.setInt(1, board_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto.setBoard_id(rs.getInt("board_id"));
				dto.setUser_id(rs.getInt("user_id"));
				dto.setTag_id(rs.getInt("tag_id"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setIs_secret(rs.getBoolean("is_secret"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				dto.setUpdated_at(rs.getTimestamp("updated_at"));
				
				dto.setNickname(rs.getString("nickname"));
				dto.setProfile(rs.getString("profile"));
				dto.setTag_name(rs.getString("name"));
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}
		
		return dto;
	}
	
	// 게시글 삭제
	public void deleteBoard(int board_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;		
			
		String sql = """
				delete from boards
				where board_id = ?
				""";
			
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, board_id);

			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
					
	}
	
	// 게시글 수정
	public void updateBoard(BoardDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;		
			
		String sql = """
				update boards set
				title = ?, content = ?, is_secret = ?
				where board_id = ?
				""";
			
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setBoolean(3, dto.isIs_secret());
			pstmt.setInt(4, dto.getBoard_id());

			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
					
	}
	
	// 작성한 글 갯수
	public int getAllWriteBoards(int user_id) {
		int total_cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = """
				select count(*) as total_cnt from boards where user_id = ?
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_id);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				total_cnt = rs.getInt("total_cnt");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return total_cnt;
	}
	
}
