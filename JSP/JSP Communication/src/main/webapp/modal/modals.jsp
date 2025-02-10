<%@page import="data.dao.UserDAO"%>
<%@page import="data.dto.UserDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
/* User session 불러오기 */
UserDTO user_dto = (UserDTO) session.getAttribute("User");
UserDAO user_dao = new UserDAO();
boolean status = user_dto != null;
if(status) {
	UserDTO updatedUser = user_dao.getUserByID(user_dto.getUser_id());
    session.setAttribute("User", updatedUser);
}
%>
<!DOCTYPE html>
<html>
<head>
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
.btnfrm {
	float: right;
}

.fail {
	color: red;
	font-size: 0.8em;
	font: bold;
}
</style>
</head>
<body>
<!-- 로그인 Modal -->
<div class="modal" id="login_Modal" style="color: black;">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[로그인]</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<div class="modal-body">
				<form id="loginfrm">
					<h6>아이디</h6>
					<input type="text" class="form-control" name="username"
						required="required" /><br>
					<h6>비밀번호</h6>
					<input type="password" class="form-control" name="password"
						required="required" /><br> <span class="fail"></span>
					<button type="submit" class="btn btn-outline-success btnfrm">로그인</button>
				</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$("#loginfrm").submit(function(e) {
		e.preventDefault();

		$.ajax({
			type : "post",
			dataType : "text",
			data : $(this).serialize(),
			url : "../users/login.jsp",
			success : function(res) {
				/* alert(res); */
				if (res.trim() === "success") {
					location.reload();
				} else {
					$("#loginfrm .fail").html("ID&PWD를 확인하세요.");
				}
			},
			error : function() {
				$("#loginfrm .fail").html("로그인 요청 실패!");
			}
		});
	});
</script>

<!-- 회원가입 Modal -->
<div class="modal" id="register_Modal" style="color: black;">
	<div class="modal-dialog modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[회원가입]</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<div class="modal-body">
				<form id="registerfrm">
					<input type="hidden" name="admin" value="0" />
					<h6>프로필 사진</h6>
					<select id="selprofile" name="profile" class="form-select">
						<option value="../image/profile/1.svg?v=<%= System.currentTimeMillis() %>">귤</option>
						<option value="../image/profile/2.svg?v=<%= System.currentTimeMillis() %>">감자</option>
						<option value="../image/profile/3.svg?v=<%= System.currentTimeMillis() %>">스마일</option>
						<option value="../image/profile/4.svg?v=<%= System.currentTimeMillis() %>">콩</option>
					</select> <img src="" class="profile" width="80" style="margin-top: 10px;margin-left: 5px;" />
					<hr>
					<h6>아이디</h6>
					<input type="text" class="form-control" name="username"
						placeholder="UserID" required="required" />
					<hr>
					<h6>비밀번호</h6>
					<input type="password" class="form-control" minlength="8"
						name="password" placeholder="Password" required="required" />
					<hr>
					<h6>닉네임</h6>
					<input type="text" class="form-control" name="nickname"
						placeholder="Nickname" required="required" />
					<hr>
					<h6>이메일</h6>
					<input type="email" class="form-control" name="email"
						placeholder="Example@example.com" required="required" />
					<hr>

					<span class="fail"></span>
					<button type="submit" class="btn btn-info btnfrm">회원가입</button>
				</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$(".profile").attr("src", $("#selprofile").val());

	$("#selprofile").change(function() {
		$(".profile").attr("src", $("#selprofile").val());
	});

	$("#registerfrm").submit(function(e) {
		e.preventDefault();

		/* alert($(this).serialize()); */

		$.ajax({
			type : "get",
			dataType : "html",
			data : $(this).serialize(),
			url : "../users/register.jsp",
			success : function(res) {
				location.href = "./homepage.jsp";
			},
			error : function() {
				$("#registerfrm .fail").html("회원가입 실패!");
			}
		});
	});
</script>


<!-- 태그 추가 modal -->
<div class="modal" id="addTag_Modal" style="color: black;">
	<div class="modal-dialog modal-dialog-centered modal-sm">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[태그 추가]</h4>
			</div>

			<div class="modal-body">
				<label class="input-group"> <input type="text"
					class="form-control" id="tagname" placeholder="TagName"
					required="required" />
				</label>

				<span class="tag fail"></span>
				<button type="button" class="btn btn-sm btn-success" id="addTag"
					style="float: right; margin: 10px;">추가하기</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	$("#addTag").click(function() {
		let name = $("#tagname").val();

		$.ajax({
			type : "get",
			dataType : "text",
			data : {"name" : name},
			url : "../boards/addTag.jsp",
			success : function() {
				location.reload();
			},
			error : function() {
				$(".tag").html("태그 추가 실패..");
			}
		});
	});
</script>

<!--유저 관리 -->
<div class="modal" id="userManage_Modal" style="color: black;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[유저 목록]</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<div class="modal-body">
			<table class="table table-bordered" id="user_list">
				
			</table>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">	
	writeUserList();
	// 유저 삭제
	$(document).on("click", ".user_del", function() {
		let user_id = $(this).attr("user_id");
		
		$.ajax({
			type: "get",
			dataType: "html",
			data: {"user_id":user_id},
			url: "../users/deleteUser.jsp",
			success: function() {
				writeUserList();
			}
		});
	});
	// 유저 관리자 임명
	$(document).on("click", ".admin_up", function() {
		let user_id = $(this).attr("user_id");
		
		$.ajax({
			type: "get",
			dataType: "html",
			data: {"user_id":user_id},
			url: "../users/adminUp.jsp",
			success: function() {
				writeUserList();
			}
		});
	});
	
	function writeUserList() {
		$.ajax({
			type: "get",
			dataType: "json",
			url: "../users/getUserList.jsp",
			success: function(res) {
				if(res.length != 0) {
					let s = `
					<thead>
						<th>프로필</th>
						<th>유저명</th>
						<th>이메일</th>
						<th>관리자 여부</th>
						<th>계정 생성일</th>
						<th>유저 삭제</th>
						<th>관리자 부여</th>
					</thead>
					<tbody>				
					`;
					$.each(res, function(idx, ele) {
						s+=`
						<tr>
							<td align="center">
								<img src="\${ele.profile}" width="30" />
							</td>
							<td>\${ele.nickname}</td>
							<td>\${ele.email}</td>
							<td>\${ele.admin?"O":"X"}</td>
							<td>\${ele.created_at}</td>
							<td align="center">
								<button class="user_del btn btn-sm btn-outline-danger" user_id="\${ele.user_id}">삭제</button>						
							</td>
							<td align="center">
								<button class="admin_up btn btn-sm btn-outline-danger" user_id="\${ele.user_id}">임명</button>
							</td>
						</tr>
						`;
					});
					
					s+= "</tbody></table>"
					$("#user_list").html(s);
				} else {
					$("#user_list").html("유저가 없습니다.");
				}
			},
			error: function() {
				$("#user_list").html("유저 목록 호출 실패!");
			}
		});
	}
</script>

<!--프로필 관리 -->
<%if(status) { %>
<div class="modal" id="profile_Modal" style="color: black;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<h4 class="modal-title">[프로필 관리]</h4>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>

			<div class="modal-body">
				<form id="profilefrm">
					<input type="hidden" name="user_id" value=<%=user_dto.getUser_id() %> />
					<h6>프로필 사진 변경</h6>
					<select id="selphoto" name="profile" class="form-select">
						<option value="../image/profile/1.svg?v=<%= System.currentTimeMillis() %>">귤</option>
						<option value="../image/profile/2.svg?v=<%= System.currentTimeMillis() %>">감자</option>
						<option value="../image/profile/3.svg?v=<%= System.currentTimeMillis() %>">스마일</option>
						<option value="../image/profile/4.svg?v=<%= System.currentTimeMillis() %>">콩</option>
					</select> 
					<img src="" class="profile" width="80" style="margin-top: 10px;margin-left: 5px;" />
					<hr>
					<h6>아이디 변경</h6>
					<input type="text" class="form-control" name="username" value=<%=user_dto.getUsername() %>
						placeholder="UserID" required="required" />
					<hr>
					<h6>비밀번호 변경</h6>
					<input type="password" class="form-control" minlength="8"
						name="password" placeholder="Password" required="required" />
					<hr>
					<h6>닉네임</h6>
					<input type="text" class="form-control" name="nickname" value=<%=user_dto.getNickname() %>
						placeholder="Nickname" required="required" />
					<hr>
					<h6>이메일</h6>
					<input type="email" class="form-control" name="email" value=<%=user_dto.getEmail() %>
						placeholder="Example@example.com" required="required" />
					<hr>

					<span class="fail"></span>
					<button type="submit" class="btn btn-info btnfrm">프로필 수정</button>
				</form>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
$(".profile").attr("src", $("#selphoto").val());

$("#selphoto").change(function() {
	$(".profile").attr("src", $("#selphoto").val());
});

$("#profilefrm").submit(function(e) {
	e.preventDefault();
	
	$.ajax({
		type : "get",
		dataType : "html",
		data : $(this).serialize(),
		url : "../users/profileUpdate.jsp",
		success : function(res) {
			<%
			UserDTO updatedUser = user_dao.getUserByID(user_dto.getUser_id());
		    session.setAttribute("User", updatedUser);		    
			%>
			location.reload();
		},
		error : function() {
			$("#profilefrm .fail").html("프로필 변경 실패!");
		}
	});
});
</script>
<%} %>
</body>
</html>