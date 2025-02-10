package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import data.dto.CommentDTO;
import db.connect.MysqlConnect;

public class CommentDAO {
	private MysqlConnect db = new MysqlConnect();

	// 댓글 작성 - insert
	public void insertComment(CommentDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql = """
				insert into comments
				(board_id, user_id, content, created_at)
				values(?, ?, ?, now())
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getBoard_id());
			pstmt.setInt(2, dto.getUser_id());
			pstmt.setString(3, dto.getContent());

			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}

	// 게시판의 댓글 갯수
	public int getAllCommentAndReply(int board_id) {
		int total_cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = """
				select
				(select count(*) from comments where board_id = ?) +
				(select count(*) from replies where board_id = ?) AS total_cnt;
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, board_id);
			pstmt.setInt(2, board_id);
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
	
	// 유저가 쓴 댓글 갯수
	public int getAllWriteComments(int user_id) {
		int total_cnt = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select
				(select count(*) from comments where user_id = ?) +
				(select count(*) from replies where user_id = ?) AS total_cnt;
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, user_id);
			pstmt.setInt(2, user_id);
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

	// 댓글 조회
	public List<CommentDTO> getComments(int board_id) {
		List<CommentDTO> list = new Vector<CommentDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = """
				select c.*, u.nickname from comments c
				join users u on c.user_id = u.user_id
				where board_id = ?
				order by c.created_at desc
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, board_id);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				CommentDTO dto = new CommentDTO();
				dto.setComment_id(rs.getInt("comment_id"));
				dto.setBoard_id(rs.getInt("board_id"));
				dto.setUser_id(rs.getInt("user_id"));
				dto.setContent(rs.getString("content"));
				dto.setCreated_at(rs.getTimestamp("created_at"));
				dto.setNickname(rs.getString("nickname"));

				list.add(dto);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(rs, pstmt, conn);
		}

		return list;
	}

}
