<%@page import="data.dao.ReplyDAO"%>
<%@page import="data.dto.ReplyDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int comment_id = Integer.parseInt(request.getParameter("comment_id"));
int board_id = Integer.parseInt(request.getParameter("board_id"));
int user_id = Integer.parseInt(request.getParameter("user_id"));
String content = request.getParameter("content");

ReplyDTO dto = new ReplyDTO(comment_id, board_id, user_id, content);
ReplyDAO dao = new ReplyDAO();
dao.insertReply(dto);
%>