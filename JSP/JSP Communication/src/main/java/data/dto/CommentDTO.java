package data.dto;

import java.sql.Timestamp;

public class CommentDTO {
	private int comment_id;
	private int board_id;
	private int user_id;
	private String content;
	private Timestamp created_at;
	private String nickname;

	public CommentDTO() {
		// TODO Auto-generated constructor stub
	}
	
	public CommentDTO(int board_id, int user_id, String content) {
		super();
		this.board_id = board_id;
		this.user_id = user_id;
		this.content = content;
	}

	public int getComment_id() {
		return comment_id;
	}

	public void setComment_id(int comment_id) {
		this.comment_id = comment_id;
	}

	public int getBoard_id() {
		return board_id;
	}

	public void setBoard_id(int board_id) {
		this.board_id = board_id;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

}
