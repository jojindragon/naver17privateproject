<%@page import="data.dao.TagDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String name = request.getParameter("name");
TagDAO dao = new TagDAO();
dao.addTag(name);
%>