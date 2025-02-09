<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="data.dto.TagDTO"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.TagDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
TagDAO dao = new TagDAO();
List<TagDTO> list = dao.getAllTags();

JSONArray arr = new JSONArray();
for(TagDTO dto:list) {
	JSONObject ob = new JSONObject();
	ob.put("tag_id", dto.getTag_id());
	ob.put("name", dto.getName());
	
	arr.add(ob);
}
%>
<%=arr %>