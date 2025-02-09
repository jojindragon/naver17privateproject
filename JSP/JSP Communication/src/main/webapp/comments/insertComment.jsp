<%@page import="data.dto.CommentDTO"%>
<%@page import="data.dao.CommentDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int board_id = Integer.parseInt(request.getParameter("board_id"));
int user_id = Integer.parseInt(request.getParameter("user_id"));
String content = request.getParameter("content");

CommentDTO dto = new CommentDTO(board_id, user_id, content);
CommentDAO dao = new CommentDAO();
dao.insertComment(dto);
%>