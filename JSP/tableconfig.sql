# 유저 테이블
CREATE TABLE users(
	user_id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	nickname VARCHAR(50) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
    profile VARCHAR(255) NOT NULL,
	admin BOOLEAN DEFAULT FALSE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# 게시판 태그 테이블
CREATE TABLE tags (
  tag_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL
);

# 게시판 테이블
CREATE TABLE boards (
    board_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    tag_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_secret BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);
# 댓글 테이블
CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY,
  board_id INT NOT NULL,
  user_id INT NOT NULL,
  content VARCHAR(500) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (board_id) REFERENCES boards(board_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

# 답글 테이블
CREATE TABLE replies (
  reply_id INT AUTO_INCREMENT PRIMARY KEY,
  comment_id INT NOT NULL,
  board_id INT NOT NULL,
  user_id INT NOT NULL,
  content VARCHAR(500) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (comment_id) REFERENCES comments(comment_id) ON DELETE CASCADE,
  FOREIGN KEY (board_id) REFERENCES boards(board_id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);