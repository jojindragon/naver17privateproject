<%@page import="data.dao.ReplyDAO"%>
<%@page import="data.dto.ReplyDTO"%>
<%@page import="data.dao.CommentDAO"%>
<%@page import="data.dto.CommentDTO"%>
<%@page import="data.dao.TagDAO"%>
<%@page import="data.dto.TagDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="data.dto.BoardDTO"%>
<%@page import="data.dao.BoardDAO"%>
<%@page import="data.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
/* Dark mode session */
Boolean dark = (Boolean) session.getAttribute("dark");
if (dark == null) {
	dark = false;
}

/* User session 불러오기 */
UserDTO user_dto = (UserDTO) session.getAttribute("User");
boolean status = user_dto != null;
int user_id = 0;

int board_id = Integer.parseInt(request.getParameter("board_id"));
BoardDAO b_dao = new BoardDAO();
BoardDTO board_dto = b_dao.getBoard(board_id);
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

CommentDAO c_dao = new CommentDAO();
List<CommentDTO> clist = c_dao.getComments(board_id);

int user_board = 0;
int user_comments = 0;
if(status) {
	user_id = user_dto.getUser_id();
	user_board = b_dao.getAllWriteBoards(user_id);
	user_comments = c_dao.getAllWriteComments(user_id);
} else {
	if(board_dto.isIs_secret()) {
		response.sendRedirect("./homepage.jsp");
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세보기</title>
<link
	href="https://fonts.googleapis.com/css2?family=Caveat:wght@400..700&family=Gaegu&family=Jua&family=Nanum+Pen+Script&family=Playwrite+AU+SA:wght@100..400&family=Single+Day&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
body * {
	font-family: 'Jua';
}

.theme {
	background-color: <%=dark ? "#141517" : "white"%>;
	color: <%=dark ? "white" : "black"%>;
}

.header {
	width: 100%;
	display: flex;
	justify-content: space-between;
	padding: 10px;
}

.logo-title {
	display: flex;
	align-items: center;
	margin-left: 20px;
}

.logo {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	object-fit: cover; /* 이미지 비율 유지 */
	margin-right: 10px;
}

.btns {
	display: flex;
	font-size: 20px;
	text-align: center;
	font: bold;
	height: 30px;
	gap: 10px;
}

.btns i {
	width: 30px;
	cursor: pointer;
}

.btns i:hover {
	border: 1px groove;
	background-color: gray;
}

.user_profile {
	margin-top: 40px;
	margin-right: 10px;
	border: 1px solid;
	border-radius: 10px;
}

.side {
	cursor: pointer;
}

.side:hover {
	border: 1px groove;
	background-color: gray;
}

.result-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: calc(100vh - 500px); /* 헤더 높이를 제외한 전체 높이 설정 */
}

.result {
    width: 80%; /* 웹 페이지 너비의 80% */
    max-width: 800px; /* 최대 너비 */
    padding: 20px;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);/* 그림자 */
    margin: 20px 0;
    text-align: left;
}

.result h1 {
    margin-top: 0; /* 제목 위쪽 여백 제거 */
    font-size: 35px;
    color: #333;
}

.result .content_detail {
    font-size: 16px; /* 본문 폰트 크기 */
    font-family: 'Gaegu';
    line-height: 1.5; /* 본문 줄 간격 설정 */
    color: #666; /* 본문 색상 설정 */
}

.meta-info {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px; /* 제목과 내용 사이 여백 설정 */
}

.meta-info div {
    font-size: 14px;
    color: #999;
}

div.board_btn {
	display: flex;
	justify-content: flex-end;
}

div.board_btn * {
	margin-right: 15px;
}

/* 댓글 디자인 */
.container {
	color: black;
}
.comment-list {
	margin-top: 20px;
}
.title-item {
	display: flex;
    justify-content: space-between;
	align-items: center;
	padding: 10px;
	border-bottom: 1px solid #ddd;
}
.comment-item {
	display: flex;
    justify-content: space-between;
	align-items: center;
	padding: 10px;
	border-bottom: 1px solid #ddd;
}
.comment-item:hover {
	cursor: pointer;
	border: 1px groove black;
	border-radius: 5px;	
}
.comment-item:last-child {
	border-bottom: none;
}
.comment-nickname, .comment-content, .comment-date {
	margin: 0 10px;
	white-space: nowrap; /* 줄바꿈 없이 한 줄로 표시 */
}
.comment-content {
	flex-grow: 1;
}
.comment-date {
	font-size: 0.9em;
	color: #999;
}

.addCom {
	width: 450px;
	height: 40px;
	margin-right: 10px;
	border: 1px solid gray;
	border-radius: 10px;	
}

.warningNot {
	color: red;
	font-size: 0.8em;
	margin: 10px;
}
</style>
<script type="text/javascript">
$(function() {	
	darkmode();
	logout();
});
function darkmode() {
	var isDark = <%=dark%>;
	
	/* 초기 설정 */
	if(isDark) {
		$("#mode").removeClass("bi-moon-stars").addClass("bi-brightness-high");
		$("#tagList").removeClass("bg-light navbar-light").addClass("bg-dark navbar-dark");
		$("#mode").siblings().removeClass("btn-outline-dark").addClass("btn-outline-light");		
		$(".logo").attr("src", "../image/blogo.gif");
	} else {
		$("#mode").removeClass("bi-brightness-high").addClass("bi-moon-stars");
		$("#tagList").removeClass("bg-dark navbar-dark").addClass("bg-light navbar-light");
		$("#mode").siblings().removeClass("btn-outline-light").addClass("btn-outline-dark");		
		$(".logo").attr("src", "../image/wlogo.gif");
	}
	
	/* 배경 밝기 변경 */
	$("#mode").click(function() {
		isDark = !isDark; //밝기 전환
		
		$.ajax({
            type: "post",
            url: "toggleDark.jsp", // 다크 모드 상태를 서버에 전달
            data: { "darkMode": isDark },
            success: function() {
                location.reload(); // 변경된 모드로 페이지 새로고침
            }
        });
	});
}

function logout() {
	$("#logout").click(function() {
		$.ajax({
			type: "post",
			dataType: "text",
			url: "../users/logout.jsp",
			success: function(res) {				
				location.href = "./homepage.jsp";
			}
		});
	});
}
</script>

</head>
<body class="theme">
	<div class="header input-group">
		<div class="logo-title">
			<img src="../image/wlogo.gif" class="logo" />
			<h2>[자유 게시판]</h2>
		</div>
		<div class="btns">
			<i class="bi bi-moon-stars" id="mode"></i>
			<%if (!status) { %>
			<button type="button" class="btn btn-outline-dark"
				data-bs-toggle="modal" data-bs-target="#login_Modal">로그인</button>
			<button type="button" class="btn btn-outline-dark"
				data-bs-toggle="modal" data-bs-target="#register_Modal">회원가입</button>
			<%} else { %>
			<i class="bi bi-person-circle" data-bs-toggle="offcanvas"
				data-bs-target="#user_sidebar"></i>
			<%} %>
		</div>
	</div>

<!-- boarddeatil 시작 -->
	<div class="result-container">		
        <div class="result">
        	<div class="input-group board_btn" style="margin-bottom: 10px;">
				<button class="btn btn-sm btn-outline-info" id="gotomain">메인</button>
            </div>
			<!-- 글 내용 -->			
            <div class="meta-info">
            	<h1 class="title_detail"><%=board_dto.getTitle() %></h1>
                <div>
                	작성자 <strong class="nickname_detail"><%=board_dto.getNickname() %></strong>
                	<img src="<%=board_dto.getProfile() %>" class="board_profile" width="25" />
                </div>
                <div>유형: <strong class="tag_detail"><%=board_dto.getTag_name() %></strong></div>
                <div>작성일: <strong class="writeday_detail"><%=sdf.format(board_dto.getCreated_at()) %></strong></div>
            </div>
            <pre class="content_detail" style="margin-bottom: 80px;"><%=board_dto.getContent() %></pre>           
            
            <!-- 댓글 리스트 -->
            <%if(!board_dto.getTag_name().equals("공지") && status) {%>
            <div class="container">
        		<h5>댓글 목록</h5>
        		<div class="input-group" style="margin-bottom: 5px;">
        			<input type="text" class="addCom" placeholder="comments" />
            		<button class="btn btn-outline-info btn-sm" id="addComment" style="margin-right: 10px;">댓글 달기</button>
            		<span class="warningNot"></span>
            	</div>   		
        		<%if(clist.size() == 0) {%>
        			<p style="font-size: 0.8em;">댓글이 없습니다.</p>
        		<%} else {%>
        			<p style="font-size: 0.8em;">총 <%=c_dao.getAllCommentAndReply(board_id) %>개의 댓글</p>
        		<%} %>
        		<hr>
        		<div class="comment-list">
        			<div class="title-item">
                		<div class="comment-nickname">닉네임</div>
                		<div class="comment-content">댓글</div>
                		<div class="comment-date">작성일</div>
            		</div>
        		<%for(CommentDTO dto:clist) { %>
        		<%
        		ReplyDAO dao = new ReplyDAO();
        		List<ReplyDTO> rlist = dao.getReplies(dto.getComment_id());
        		%>
        		<div class="comments">
            		<div class="comment-item">
                		<div class="comment-nickname"><%=dto.getNickname() %></div>
                		<div class="comment-content"><%=dto.getContent() %></div>
                		<div style="color: blue">[<%=rlist.size() %>]</div>
                		<div class="comment-date"><%=sdf.format(dto.getCreated_at()) %></div>
            		</div>
            		<div style="margin-top: 5px;">
                		<div class="input-group reple" style="margin-bottom: 5px;">
        					<input type="text" style="margin-right: 5px;width: 200px;" c_id=<%=dto.getComment_id() %> />
            				<button class="btn btn-outline-info btn-sm addReply">답글 달기</button>
            			</div>
            			<%if(rlist.size() != 0) {
            				for(ReplyDTO rdto:rlist) {%>
            				<!-- 답글 리스트 -->
            				<div class="comment-item">
            					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
  									<path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5"/>
								</svg>
                				<div class="comment-nickname"><%=rdto.getNickname() %></div>
                				<div class="comment-content"><%=rdto.getContent() %></div>                				
                				<div class="comment-date"><%=sdf.format(rdto.getCreated_at()) %></div>
            				</div>
            			<%}} %>
                	</div>
                </div>
            	<%} %>
        		</div>
    		</div>
    		<%} %>
        </div>
    </div>
    <script type="text/javascript">
    $("#gotomain").click(function() {
		location.href = "./homepage.jsp";    	
    });
    
    /* 관리자 or 작성자 검사 */
    <%if(status) { %>
    	let check1 = <%=user_dto.isAdmin() %>;
    	let check2 = <%=user_dto.getUser_id() == board_dto.getUser_id() %>;
    	
    	let s = "";
    	if(check2) {
    		s += `<button class="btn btn-sm btn-outline-info" data-bs-toggle="modal" data-bs-target="#updateBoard_Modal">글 수정</button>`;
    	}
    	
    	if(check1 || check2) {
    		s += `<button class="btn btn-sm btn-outline-danger" id="delBoard">글 삭제</button>`;
    		
    	}
        $(".board_btn").append(s);
    <%} %>
    
    $(document).on("click", "#delBoard", function() {
    	let board_id = <%=board_id %>;
    	
    	$.ajax({
    		type: "get",
    		dataType: "html",
    		data: {"board_id": board_id},
    		url: "../boards/deleteBoard.jsp",
    		success: function(res) {
    			location.href = "./homepage.jsp";
    		}
    	});
    });
    
    $("#addComment").click(function() {
    	let content = $(".addCom").val();
    	
    	if(content.trim() == "") {
    		/* alert("댓글 적어라."); */
    		$(".warningNot").text("빈칸 금지");
    	} else {
    		$.ajax({
        		type: "post",
        		dataType: "html",
        		data: {"board_id":<%=board_id %>, "user_id":<%=user_id %>, "content":content},
        		url: "../comments/insertComment.jsp",
        		success: function() {
        			location.reload();
        		}
        	});
    	}
    });
    
    $(".reple").hide();
    $(".comment-item").click(function() {
    	$(this).siblings().find(".reple").toggle();    	
    });
    
    $(".addReply").click(function() {
    	let comment_id = $(this).siblings().attr("c_id");
    	let content = $(this).siblings().val();
    	if(content.trim() == "") {
    		/* alert("댓글 적어라."); */
    		$(".warningNot").text("빈칸 금지");
    	} else {
    		$.ajax({
        		type: "post",
        		dataType: "html",
        		data: {"comment_id":comment_id, "board_id":<%=board_id %>, "user_id":<%=user_id %>, "content":content},
        		url: "../comments/insertReply.jsp",
        		success: function() {
        			location.reload();
        		}
        	});
    	}
    });
    
    </script>
    
<!--게시글 수정 -->
<div class="modal" id="updateBoard_Modal" style="color: black;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[게시글 수정]</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<div class="modal-body">
				<form id="boardUpdatefrm">
					<input type="hidden" name="board_id"
						value="<%=board_id %>" />

					<h6>[제목]</h6>
					<input type="text" name="title" placeholder="title" value=<%=board_dto.getTitle() %>
						class="form-control" required="required" /><br>
					<h6>[내용]</h6>
					<textarea name="content" placeholder="content"
						class="form-control" required="required"><%=board_dto.getContent() %></textarea><br>

					<!-- 비밀글 여부 -->
					<label> <input type="checkbox" id="up_secret" />&nbsp;비밀글
					</label> <span class="fail"></span>
					<button type="submit" class="btn btn-success"
						style="float: right; margin: 10px;">내용 수정</button>
				</form>
				<script type="text/javascript">
				$("#boardUpdatefrm").submit(function(e) {
	       			e.preventDefault();
	       			
	       			let frmData = {
	       				board_id: $("input[name='board_id']").val(),
	       				title: $("input[name='title']").val(),
	       				content: $("textarea[name='content']").val(),
	       				is_secret: $("#up_secret").is(":checked")       				
	       			};
	       			/* alert(frmData.is_secret); */
	       			
	       			$.ajax({
	       				type: "post",
	       				dataType: "html",
	       				url: "../boards/updateBoard.jsp",
	       				data: frmData,
	       				success: function(res) {
	       					location.reload();
	       				},
	       				error: function() {
	       					$("#boardUpdatefrm .fail").html("게시글 작성 실패!");
	       				}
	       			});
	       			
	       		});
				</script>
			</div>
		</div>
	</div>
</div>
<!-- 본문 끝 -->

	<!-- 모든 Modal 불러오기 -->
	<jsp:include page="../modal/modals.jsp" />
	
	<!-- profile 사이드 바 -->
<%if (status) {%>
	<div class="offcanvas offcanvas-end user_profile" id="user_sidebar"
		style="color: black">
		<div class="offcanvas-header">
			<h2 class="offcanvas-title" style="text-align: center;">프로필</h2>
			<button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>
		</div>
		<div class="offcanvas-body">
			<div class="container text-center">
				<div class="d-flex align-items-center">
					<img
						src="<%=user_dto.getProfile()%>?v=<%=System.currentTimeMillis()%>"
						width="80" class="me-3" />
					<div>
						<p class="mb-0" style="color: lightgreen; font-size: 0.8em;">자유게시판</p>
						<b class="mb-0"><%=user_dto.getNickname()%></b>
					</div>
				</div>
			</div>
			<br><br>
    		<p>&nbsp;작성한 글&nbsp;: <%=user_board %>개</p>
			<p>작성한 댓글: <%=user_comments %>개</p>
			<hr>
			<div class="side" data-bs-toggle="modal"
				data-bs-target="#boardWrite_Modal">
				<i class="bi bi-pencil">&nbsp;&nbsp;글쓰기</i>
			</div>
			<hr>
			<div class="side" data-bs-toggle="modal"
				data-bs-target="#profile_Modal">
				<i class="bi bi-pencil-square">&nbsp;&nbsp;프로필 관리</i>
			</div>
			<hr>
			<%if (user_dto.isAdmin()) { %>
			<!-- 관리자 전용 -->
			<div class="side" data-bs-toggle="modal"
				data-bs-target="#addTag_Modal">
				<i class="bi bi-bookmarks">&nbsp;&nbsp;태그추가</i>
			</div>
			<hr>
			<div class="side" data-bs-toggle="modal"
				data-bs-target="#userManage_Modal">
				<i class="bi bi-person-lines-fill">&nbsp;&nbsp;유저 관리</i>
			</div>
			<hr>
			<%} %>
			<div class="side" id="logout">
				<i class="bi bi-box-arrow-right">&nbsp;&nbsp;로그아웃</i>
			</div>
		</div>
	</div>

	<!-- 글 작성 Modal -->
	<div class="modal" id="boardWrite_Modal" tabindex="-1"
		style="color: black;">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">[게시글 작성]</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<div class="modal-body">
					<form id="boardfrm">
						<input type="hidden" name="user_id"
							value="<%=user_dto.getUser_id()%>" />

						<h6>[제목]</h6>
						<input type="text" name="title" placeholder="title"
							class="form-control" required="required" /><br>
						<h6>[내용]</h6>
						<textarea name="content" placeholder="content"
							class="form-control" required="required"></textarea>
						<br>

						<!-- 태그 선택 -->
						<label>[태그 선택]</label> <select id="selTag" name="tag_id"
							class="form-select form-sm">
							<option>loading...</option>
						</select><br>

						<!-- 비밀글 여부 -->
						<label> <input type="checkbox" id="is_secret" />&nbsp;비밀글
						</label> <span class="fail"></span>
						<button type="submit" class="btn btn-success"
							style="float: right; margin: 10px;">게시글 작성</button>
					</form>
				</div>
			</div>
		</div>
	</div>
<script type="text/javascript">
let check = <%=user_dto.isAdmin()%>;

document.addEventListener('DOMContentLoaded', function() {
    $('#boardWrite_Modal').on('shown.bs.modal', function () {
      setTimeout(function() {
        $('#boardTitle').focus();
      }, 500); // 500ms 지연 시간
    });
});

$(document).ready(function(){
	$.ajax({
		type: "get",
		dataType: "json",
		url: "../boards/getTags.jsp",
		success: function(res) {
			let b="";
			let not;
			$.each(res, function(idx, ele) {
				if(ele.tag_id == 1) {
					not = true;
				} else {
					not = false;
				}
				
				b+= `
				<option value="\${ele.tag_id}" \${not && !check ?"disabled":""} \${not&&check?"selected":""} >\${ele.name}</option>
				`;
			});
			$("#selTag").html(b);
			
			/* 게시글 모달의 기능 - 게시글 작성 */
			$("#boardfrm").submit(function(e) {
       			e.preventDefault();
       			
       			/* alert($(this).serialize()); - bool값, 배열 값 못 읽음 */
       			let frmData = {
       				user_id: $("input[name='user_id']").val(),
       				tag_id: $("#selTag").val(),
       				title: $("input[name='title']").val(),
       				content: $("textarea[name='content']").val(),
       				is_secret: $("#is_secret").is(":checked")       				
       			};
       			/* alert(frmData.is_secret); */
       			
       			$.ajax({
       				type: "post",
       				dataType: "html",
       				url: "../boards/createBoard.jsp",
       				data: frmData,
       				success: function(res) {
       					if(res.trim() === "success") {       						
           					location.reload();
           				} else {
           					$("#boardfrm .fail").html("게시글 작성 실패!"+res.message);
           				}       					
       				},
       				error: function() {
       					$("#boardfrm .fail").html("Server Error");
       				}
       			});
       			
       		});
			
		},
		error: function() {
			$("#selTag").html("<option>요청 실패!</option>");
		}
	});
});
</script>

<%} %>

</body>
</html>