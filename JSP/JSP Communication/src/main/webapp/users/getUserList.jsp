<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="data.dto.UserDTO"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

UserDAO dao = new UserDAO();
List<UserDTO> list = dao.getAllUsers();


JSONArray arr = new JSONArray();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

for(UserDTO dto:list) {
	JSONObject ob = new JSONObject();
	ob.put("user_id", dto.getUser_id());	
	ob.put("nickname", dto.getNickname());
	ob.put("email", dto.getEmail());
	ob.put("profile", dto.getProfile());
	ob.put("admin", dto.isAdmin());
	ob.put("created_at", sdf.format(dto.getCreated_at()));
	
	arr.add(ob);
}
%>
<%=arr %>