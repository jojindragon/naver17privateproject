package data.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Vector;

import data.dto.TagDTO;
import db.connect.MysqlConnect;

public class TagDAO {
	MysqlConnect db = new MysqlConnect();
	
	// 태그 추가
	public void addTag(String name) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		String sql = """
				insert into tags (name) values(?)
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);			
			
			pstmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			db.dbClose(pstmt, conn);
		}
	}
	
	// 모든 태그 조회
	public List<TagDTO> getAllTags() {
		List<TagDTO> list = new Vector<TagDTO>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql = """
				select * from tags order by name
				""";
		
		conn = db.getConnection();
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				TagDTO dto = new TagDTO();
				dto.setTag_id(rs.getInt("tag_id"));
				dto.setName(rs.getString("name"));
				
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
