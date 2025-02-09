<%@page import="data.dto.UserDTO"%>
<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dao" class="data.dao.UserDAO" />
<jsp:useBean id="dto" class="data.dto.UserDTO" />
<jsp:setProperty property="*" name="dto" />
<% dao.registerUser(dto); %>