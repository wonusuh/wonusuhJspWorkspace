<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../../header.jsp"%>
<style>
#photo {
	width: 25%;
	height: 25%;
}
</style>
<c:if test="${vo==null}">
	<h1 class="py-3">일치하는 회원이 없습니다</h1>
</c:if>
<c:if test="${vo ne null}">
	<h1 class="py-3">${vo.name}회원의상세보기</h1>
	<form action="${ctx}/memberUpdate.do" method="post">
		<input type="hidden" name="num" value="${vo.num}" />
		<table class='table table-bordered'>
			<tr>
				<td>번호</td>
				<td class="left">${vo.num}</td>
			</tr>
			<tr>
				<td>아이디</td>
				<td class="left">${vo.id}</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td class="left">${vo.pass}</td>
			</tr>
			<tr>
				<td>이름</td>
				<td class="left">${vo.name}</td>
			</tr>
			<tr>
				<td>나이</td>
				<td><input class="col-12" type="text" name="age"
					value="${vo.age}" /></td>
			</tr>
			<tr>
				<td>이메일</td>
				<td><input class="col-12" type="text" name="email"
					value="${vo.email}" /></td>
			</tr>
			<tr>
				<td>전화번호</td>
				<td><input class="col-12" type="text" name="phone"
					value="${vo.phone}" /></td>
			</tr>
			<tr>
				<td>프로필 이미지</td>
				<td><c:if test="${vo.sFileName!=null}">
						<img src="Uploads/${vo.sFileName}" id="photo" />
					</c:if> <c:if test="${vo.sFileName==null}">
						<img
							src="https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"
							id="photo" class="default">
					</c:if></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="button"
					value="사진 업로드" class='col-3 btn btn-success' id="uploadBtn"
					<c:if test="${loginId!=vo.id and loginId!='admin'}">disabled="disabled"</c:if> />

					<input type="submit" value="수정하기" class='col-3 btn btn-primary'
					<c:if test="${loginId!=vo.id and loginId!='admin'}">disabled="disabled"</c:if> />

					<input type="button" value="사진 삭제" class='col-3 btn btn-warning'
					id="deleteBtn"
					<c:if test="${loginId!=vo.id and loginId!='admin'}">disabled="disabled"</c:if> />

				</td>
			</tr>
		</table>
	</form>

	<div id="upload">
		<form id="imgForm" method="post" enctype="multipart/form-data">
			<input id="uploadFile" type="file" name="uploadFile" accept="image/*">
			<input type="hidden" name="num" value="${vo.num}" />
		</form>
	</div>

</c:if>
</body>
</html>

<script type="text/javascript">
	console.log(`${vo.id} 로그인 했습니다.`);
	let uploadDiv = document.querySelector("#upload");
	uploadDiv.style.display = "none";
	let uploadBtn = document.querySelector(`#uploadBtn`);
	let deleteBtn = document.querySelector("#deleteBtn");
	let input = document.querySelector(`#uploadFile`);
	
	input.addEventListener("change",() => {
		let maxSize = 5 * 1024 * 1024;
		if(input.size == 0 || input.size > maxSize) return;
		let form = document.querySelector("#imgForm");
		let formData = new FormData(form);
		
		fetch("memberUploadImg.do", {
			method : 'POST',
			body : formData,
		})
		.then(response => response.text())
		.then((data) => {
			if(data === `fail`) {
				alert(`이미지 업로드에 실패했습니다.`);
			}else{
				alert(`이미지 업로드에 성공했습니다.`);
				let src = "Uploads/" + data;
				document.querySelector("#photo").setAttribute(`src`, src);
				document.querySelector("#photo").classList.remove("default");
			}
		})
		.catch((error) => {
			console.log(`error=`, error);
		});
	});
	
	uploadBtn.addEventListener("click", () => {
		uploadDiv.style.display = "block";
	});
	
	deleteBtn.addEventListener("click", () => {
		if(document.querySelector('.default')){
			alert("기본이미지는 삭제할 수 없습니다.");
			return;
		}
		fetch("memberDeleteImg.do", {
			method : "POST",
			headers : {"Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",},
			body : "num=" + document.querySelector('#num').value,
		})
		.then(response => response.text())
		.then((data) => {
			if(data === `fail`) {
				alert(`이미지 삭제에 실패했습니다.`);
			}else{
				alert('이미지 삭제에 성공했습니다.');
				let src = 'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg';
				document.querySelector(`#photo`).setAttribute(`src`, src);
				document.querySelector('#photo').classList.add("defalut");
			}
		})
		.catch((error) => {
			consol.log(`error : `, error);
		});
	});
</script>
