<%@page import="data.dto.BoardDTO"%>
<%@page import="data.dao.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* 작성한 사용자 추출 */
int user_id = Integer.parseInt(request.getParameter("user_id"));

/* 태그 ID 추출 */
int tag_id = Integer.parseInt(request.getParameter("tag_id"));

/* board 값 추출 */
String title = request.getParameter("title");
String content = request.getParameter("content");

String s = request.getParameter("is_secret");
boolean is_secret = Boolean.parseBoolean(s);


/* 게시글 저장 */
BoardDTO dto = new BoardDTO();
dto.setUser_id(user_id);
dto.setTag_id(tag_id);
dto.setTitle(title);
dto.setContent(content);
dto.setIs_secret(is_secret);

BoardDAO dao = new BoardDAO();
dao.createBoard(dto);

out.print("success");
%>