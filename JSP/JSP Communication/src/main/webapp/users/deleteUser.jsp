<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int user_id = Integer.parseInt(request.getParameter("user_id"));
UserDAO dao = new UserDAO();
dao.userDelete(user_id);
%>