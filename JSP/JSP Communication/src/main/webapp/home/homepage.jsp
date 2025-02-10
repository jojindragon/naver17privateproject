<%@page import="data.dao.CommentDAO"%>
<%@page import="data.dao.BoardDAO"%>
<%@page import="data.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
/* Dark mode session */
Boolean dark = (Boolean) session.getAttribute("dark");
if(dark == null) {
	dark = false;
}

/* User session 불러오기 */
UserDTO user_dto = (UserDTO) session.getAttribute("User");
boolean status = user_dto != null;

BoardDAO b_dao = new BoardDAO();
CommentDAO c_dao = new CommentDAO();

int user_board = 0;
int user_comments = 0;
if(status) {
	user_board = b_dao.getAllWriteBoards(user_dto.getUser_id());
	user_comments = c_dao.getAllWriteComments(user_dto.getUser_id());
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유 게시판</title>
<link
	href="https://fonts.googleapis.com/css2?family=Caveat:wght@400..700&family=Gaegu&family=Jua&family=Nanum+Pen+Script&family=Playwrite+AU+SA:wght@100..400&family=Single+Day&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
body * {
	font-family: 'Jua';
}

.theme {	
	background-color: <%=dark? "#141517":"white"%>;
	color: <%=dark? "white":"black"%>;
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

#tagList {
	left: 5px;
	right: 5px;
	margin-top: 20px;
}

#tag_list {	
  	display: flex;
  	flex-wrap: wrap;
  	justify-content: center;
  	align-items: center; /* 요소 내부의 텍스트를 가운데 정렬 */
}
.nav-item {
  flex: 0 1 10%; /* 각 항목이 10% 너비를 차지하도록 설정 */
  margin: 5px;
  text-align: center; /* 텍스트를 가운데 정렬 */
}

.nav-link {
  white-space: nowrap; /* 텍스트를 한 줄에 표시 */
}

.nav-item .nav-link.active {
 	/* 선택(강조) 디자인 */
  	background-color: <%=dark? "white":"#007bff"%>; 
	color: "black";
	border: 1px solid;
  	border-radius: 5px; /* 테두리 둥글게 */
}

.notice {
	width: 80%; /* 창 너비의 80%를 차지 */
    margin: 0 auto; /* 중앙에 배치 */    
    display: flex;
    justify-content: center;
    text-align: center;
}
.line {
	width: 80%;	
	margin: 0 auto;
}
.board_list {
	width: 80%;
    margin: 0 auto;
    display: flex;
    justify-content: center;    
    min-height: 100vh; /* 전체 창 높이의 100%를 차지하여 수직 중앙 정렬 */
    text-align: center;
}

.notice-list {
    background-color: <%=dark? "#E3E006":"cyan"%>; 
    color: <%=dark? "#141517":"black"%>
}

.notice-list-item {
    display: flex;
    flex-direction: row;
    align-items: center;    
    border-bottom: 1px solid #ddd;
    padding: 5px 0; /* 간격을 줄입니다 */
    font-size: 0.9em; /* 높이를 적게 잡기 위해 폰트 크기를 줄입니다 */
}

.notice-list-item > div {
    flex: 1;
    padding: 0 5px; /* 요소 간의 간격을 줄입니다 */
    text-align: center;   
}

.notice-list-item .title {
    font-weight: bold;
}

.boarddetail {
	cursor: pointer;
}
.boarddetail:hover {
	border: 3px groove <%=dark? "#6a5acd":"gray"%>;
}

</style>
<script type="text/javascript">
$(function() {
	list(0);
	writeNot();
	darkmode(); // 다크 모드 전환
	logout(); // 로그 아웃 기능
	tags(); // 태그 리스트 및 클릭 이벤트(게시판 필터링)
	boarddetail();
});
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
			<%if(!status) { %>
			<button type="button" class="btn btn-outline-dark"
			 data-bs-toggle="modal" data-bs-target="#login_Modal">로그인</button>		
			<button type="button" class="btn btn-outline-dark"
			 data-bs-toggle="modal" data-bs-target="#register_Modal">회원가입</button>
			 <%} else { %>
			 <i class="bi bi-person-circle" data-bs-toggle="offcanvas" data-bs-target="#user_sidebar"></i>
			 <%} %>		
		</div>
	</div>
	
<!-- 태그 nav -->
<nav class="navbar navbar-expand-sm navbar-light bg-light" id="tagList">
  <div class="container-fluid">
    <p class="navbar-brand" href="javascript:void(0)" style="margin-left: 30px;">Board Tag</p>    
    <div class="collapse navbar-collapse" id="mynavbar">      
      <ul class="navbar-nav mx-auto" id="tag_list">
        <li class="nav-item">
      		<div class="nav-link">loading...</div>      		
       	</li>        	
      </ul>
      <div class="d-flex">
      	<i class="bi bi-search" style="padding-top: 5px;"></i>&nbsp;&nbsp;
        <input class="form-control me-2" type="text" placeholder="Search Enter" id="searchTitle">        
      </div>
    </div>
  </div>
</nav>

<div style="margin-bottom: 10px;"></div>
<!-- 공지만 출력 -->
<div class="notice">
loading...
</div>

<!-- 게시판 목록 출력(공지 제외) -->
<div class="board_list">
loading...
</div>


<!-- 모든 Modal 불러오기 -->
<jsp:include page="../modal/modals.jsp" />


<!-- profile 사이드 바 -->
<%if(status) { %>	
<div class="offcanvas offcanvas-end user_profile" id="user_sidebar" style="color: black">
  <div class="offcanvas-header">
  	<h2 class="offcanvas-title" style="text-align: center;">프로필</h2>
  	<button type="button" class="btn-close" data-bs-dismiss="offcanvas"></button>  	   
  </div>
  <div class="offcanvas-body">
  	<div class="container text-center">
	  <div class="d-flex align-items-center">
      	<img src="<%=user_dto.getProfile() %>?v=<%= System.currentTimeMillis() %>" width="80" class="me-3" />
	    <div>
       	  <p class="mb-0" style="color: lightgreen;font-size: 0.8em;">자유 게시판</p>
       	  <b class="mb-0"><%=user_dto.getNickname() %></b>
	    </div>
	  </div>	  
    </div>
    <br><br>
    <p>&nbsp;작성한 글&nbsp;: <%=user_board %>개</p>
	<p>작성한 댓글: <%=user_comments %>개</p>
  	<hr>
    <div class="side" data-bs-toggle="modal" data-bs-target="#boardWrite_Modal">
		<i class="bi bi-pencil">&nbsp;&nbsp;글쓰기</i>
    </div>
    <hr>
    <div class="side" data-bs-toggle="modal" data-bs-target="#profile_Modal">
		<i class="bi bi-pencil-square">&nbsp;&nbsp;프로필 관리</i>
    </div>
    <hr>    
    <%if(user_dto.isAdmin()) { %>
    <!-- 관리자 전용 -->
    <div class="side" data-bs-toggle="modal" data-bs-target="#addTag_Modal">
    	<i class="bi bi-bookmarks">&nbsp;&nbsp;태그추가</i>
    </div>
    <hr>
    <div class="side" data-bs-toggle="modal" data-bs-target="#userManage_Modal">
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
<div class="modal" id="boardWrite_Modal" tabindex="-1" style="color: black;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[게시글 작성]</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>		
			</div>

			<div class="modal-body">
				<form id="boardfrm">
					<input type="hidden" name="user_id" value="<%=user_dto.getUser_id() %>" />					

					<h6>[제목]</h6>
					<input type="text" name="title" placeholder="title"
						class="form-control" required="required" /><br>
					<h6>[내용]</h6>
					<textarea name="content" placeholder="content"
						class="form-control" required="required"></textarea>
					<br>

					<!-- 태그 선택 -->
					<label>[태그 선택]</label> 
					<select id="selTag" name="tag_id" class="form-select form-sm">
						<option>loading...</option>
					</select><br>

					<!-- 비밀글 여부 -->
					<label> <input type="checkbox" id="is_secret" />&nbsp;비밀글
					</label>
					<span class="fail"></span>
					<button type="submit" class="btn btn-success" style="float: right; margin: 10px;">게시글 작성</button>
				</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
let check = <%=user_dto.isAdmin() %>;

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
<!-- 이벤트 등 기능(함수) 구현  -->
<script type="text/javascript">
function darkmode() {
	var isDark = <%=dark %>;
	
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
				location.reload();
			}
		});
	});
}

function list(tagID) {
	// 게시판 출력	
	$.ajax({
		type: "get",
		dataType: "json",
		data: {"tag_id":tagID},
		url: "../boards/getBoardList.jsp",
		success: function(res) {
			writeBoards(res);
		}
	});
	
	/* 검색 기능 */
	$("#searchTitle").keyup(function(e) {
		let title = $(this).val(); 
		if(e.keyCode == 13) {
			$.ajax({
				type: "get",
				dataType: "json",
				data: "title="+title,
				url: "../boards/searchboard.jsp",
				success: function(res) {
					writeBoards(res);
				}
			});
		}
	});
	
}
function writeBoards(res) {
	let s="";
	if(res.length == 0) {
		s+="<b>게시글이 없습니다.</b>";
	} else {
		s+=`
		<div class="container mt-5">
	       	<h1>Board List</h1>
	       	<b style="margin-bottom: 5px;">\${res.length}개의 게시글</b>
	       	<div class="row">
		`;

		$.each(res, function(idx, ele) {
			let not = ele.tag_name == "공지";
			let dark = <%=dark %>;
			s+= `
			<div class="col-lg-4 col-md-6 col-sm-12 mb-4">
				<div class="card boarddetail" board_id="\${ele.board_id}" style="background-color:\${not ? (dark?'#E3E006':'cyan'):'white'}">
					<div class="card-body">
			`;
			if(ele.is_secret&&<%=!status %>) {
				s+=`<h5 class="card-title"><i class="bi bi-file-earmark-lock">&nbsp;비밀글입니다.</i></h5>`;
			} else {
				s+=`<h5 class="card-title">\${ele.title}</h5>`;
			}
			
			s+=`<h6 class="card-subtitle mb-2 text-muted">By \${ele.nickname} | Tag: \${ele.tag_name}</h6>			                        
				<p class="card-text"><small class="text-muted" style="font-size: 0.8em;">\${ele.writeday}</small></p>
				</div></div></div>
		    `;
		});
		s+="</div></div>";
	}
	
	$(".board_list").html(s);
}

function tags() {
	$.ajax({
		type: "get",
		dataType: "json",
		url: "../boards/getTags.jsp",
		success: function(res) {
			let s="";			
			
			if(res.length > 0) {
				$.each(res, function(idx, ele) {					
					s+=`
					<li class="nav-item">
				        <div class="nav-link tag-item" tagID="\${ele.tag_id}">\${ele.name}</div>
				     </li>					
					`;
				});
			} else {
				s+=`<b>태그가 없습니다...</b>`;
			}
			$("#tag_list").html(s);
		}
	});
	
	/* 태그 클릭 */
	$(document).on("click", ".tag-item", function() {
		let tagID = $(this).attr("tagID");
		
		// 디자인 변경        
        if($(this).hasClass("active")) {
        	$(this).removeClass("active");
        	list(0);
        } else {
        	$(".tag-item").removeClass('active');
        	$(this).addClass("active");
        	
        	// 필터링
            tagID = $(this).attr("tagID");
            list(tagID);
        }        
    });
}

function writeNot() {
	$.ajax({
		type: "get",
		dataType: "json",
		url: "../boards/getNotice.jsp",
		success: function(res) {
			let s="";
			if(res.length == 0) {
				s+="<b>공지가 없습니다.</b>";
			} else {				
				s+=`					
					<div class="container mt-5">
						<b style="margin-bottom: 5px;">\${res.length}개의 공지</b>
				       	<div class="notice-list">
					`;

					$.each(res, function(idx, ele) {						
						s+= `
						<div class="notice-list-item boarddetail" board_id="\${ele.board_id}">
							<div><b>\${ele.tag_name}</b></div>
							<div>\${ele.title}</div>
							<div>\${ele.nickname}</div>							
							<div>\${ele.content}</div>		                			                
			                <div><small class="text-muted">\${ele.writeday}</small></div>
			            </div>
					    `;
					});
					s+="</div></div>";
			}
			
			$(".notice").html(s);
		}
	});
}

function boarddetail() {
	$(document).on("click", ".boarddetail", function() {
		let board_id = $(this).attr("board_id");
		
		location.href = "./boarddetail.jsp?board_id="+board_id;
	});
}
</script>
</html>