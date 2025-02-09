package data.dto;

import java.sql.Timestamp;

public class UserDTO {
	private int user_id;
	private String username;
	private String password;
	private String nickname;
	private String email;
	private String profile;
	private boolean admin;
	private Timestamp created_at;

	public UserDTO() {
		// TODO Auto-generated constructor stub
	}
	
	public UserDTO(int user_id, String username, String password, String nickname, String email, String profile) {
		super();
		this.user_id = user_id;
		this.username = username;
		this.password = password;
		this.nickname = nickname;
		this.email = email;
		this.profile = profile;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getProfile() {
		return profile;
	}

	public void setProfile(String profile) {
		this.profile = profile;
	}

	public boolean isAdmin() {
		return admin;
	}

	public void setAdmin(boolean admin) {
		this.admin = admin;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}

}
