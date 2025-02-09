<%@page import="data.dao.BoardDAO"%>
<%@page import="data.dto.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int board_id = Integer.parseInt(request.getParameter("board_id"));
String title = request.getParameter("title");
String content = request.getParameter("content");

String s = request.getParameter("is_secret");
boolean is_secret = Boolean.parseBoolean(s);

BoardDTO dto = new BoardDTO();
dto.setBoard_id(board_id);
dto.setTitle(title);
dto.setContent(content);
dto.setIs_secret(is_secret);

BoardDAO dao = new BoardDAO();
dao.updateBoard(dto);
%>