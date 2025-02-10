<%@page import="data.dao.UserDAO"%>
<%@page import="data.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");
String nickname = request.getParameter("nickname");
String email = request.getParameter("email");
String profile = request.getParameter("profile");
int user_id = Integer.parseInt(request.getParameter("user_id"));

UserDTO dto = new UserDTO(user_id, username, password, nickname, email, profile);
UserDAO dao = new UserDAO();
dao.userProfileUpdate(dto);

/* session 갱신 */
UserDTO updatedUser = dao.getUserByID(dto.getUser_id());
session.setAttribute("User", updatedUser);
%>