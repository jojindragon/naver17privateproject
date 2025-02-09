<%@page import="data.dto.UserDTO"%>
<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

UserDAO dao = new UserDAO();
UserDTO dto = dao.login(username, password);

if(dto != null) {
	session.setAttribute("User", dto);
	response.getWriter().write("success");
} else {
	response.getWriter().write("fail");
}

%>