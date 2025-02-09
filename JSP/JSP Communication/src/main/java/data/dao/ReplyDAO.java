package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import data.dto.ReplyDTO;
import db.connect.MysqlConnect;

public class ReplyDAO {
private MysqlConnect db  = new MysqlConnect();
	
	// 답글 작성 - insert
	public void insertReply(ReplyDTO dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = """
				insert into replies
				(comment_id, board_id, user_id, content, created_at)
				values(?, ?, ?, ?, now())
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getComment_id());
			pstmt.setInt(2, dto.getBoard_id());
			pstmt.setInt(3, dto.getUser_id());		
			pstmt.setString(4, dto.getContent());
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	// 댓글 조회
	public List<ReplyDTO> getReplies(int comment_id) {
		List<ReplyDTO> list = new Vector<ReplyDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select r.*, u.nickname
				from replies r
				join users u on r.user_id = u.user_id
				where r.comment_id = ?
				order by r.created_at
				""";
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment_id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ReplyDTO dto = new ReplyDTO();
				dto.setReply_id(rs.getInt("reply_id"));
				dto.setComment_id(rs.getInt("comment_id"));				
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
