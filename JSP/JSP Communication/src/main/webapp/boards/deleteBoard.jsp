<%@page import="data.dao.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int board_id = Integer.parseInt(request.getParameter("board_id"));

BoardDAO dao = new BoardDAO();
dao.deleteBoard(board_id);
%>