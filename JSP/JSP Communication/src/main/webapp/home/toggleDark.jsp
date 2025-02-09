<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
boolean darkMode = Boolean.parseBoolean(request.getParameter("darkMode"));
session.setAttribute("dark", darkMode);
response.getWriter().write("success");
%>