<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="data.dto.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="data.dao.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
/* 필터값 전달 확인 */
String tagID = request.getParameter("tag_id");
if(tagID == null) {
	tagID = "0";
}
Integer tag_id = Integer.parseInt(tagID);


BoardDAO dao = new BoardDAO();
List<BoardDTO> list = dao.getALLBoards(tag_id);


JSONArray arr = new JSONArray();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

for(BoardDTO dto:list) {
	JSONObject ob = new JSONObject();
	ob.put("board_id", dto.getBoard_id());
	ob.put("user_id", dto.getUser_id());
	ob.put("tag_id", dto.getTag_id());
	ob.put("title", dto.getTitle());
	ob.put("content", dto.getContent());
	ob.put("is_secret", dto.isIs_secret());
	ob.put("writeday", sdf.format(dto.getCreated_at()));
	
	ob.put("nickname", dto.getNickname());
	ob.put("tag_name", dto.getTag_name());
	
	arr.add(ob);
}
%>
<%=arr %>