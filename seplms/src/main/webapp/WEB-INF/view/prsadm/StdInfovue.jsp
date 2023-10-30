<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>학생 관리 Vue</title>
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" charset="utf-8"
	src="${CTX_PATH}/js/popFindZipCode.js"></script>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	
	// 1. 페이징 설정 
	var pageSize = 5;    	// 화면당 데이터 수 
	var pageBlock = 5;		// 하단 메뉴에 보이는 페이지 수

	var searchArea;
	var stuList;
	var StdRegPop;
	
	var listStuLec;
	/* 2. html을 한번 읽고 함수 실행 $(document).ready*/
	$(function(){
		vueinit(); 
		// 3. 학생 조회 
		fnSearchList();
		
		// 버튼 이벤트 등록 (저장, 수정, 삭제, 모달창 닫기)
		fRegisterButtonClickEvent();
	});
	
	function vueinit(){
		searchArea = new Vue({
			el		: "#searchArea",
			data	: {
				searchSel  : "",
				searchText : "",
			},
			methods : {
				fnSearchList : function(){
					fnSearchList();
				}
			}
		}),
		stuList = new Vue({
			el		: "#stuList",
			data	: {
				pageSize 	: 0,
				currentPage : 0,
				pageBlock	: 0,
				
				totalCnt 	: 0,
				dataList	: [],
				
				pagingnavi	: "",				
				},
			methods	: {
				fnSelectId	: function(LoginID){
					fnSelectId(LoginID);
				},
				fnListStdLec : function(currentPageDtl, loginID){
					fnListStdLec(currentPageDtl,loginID)
				}
			}
		}),
		StdRegPop = new Vue({
			el		: "#StdRegPop",
			data	: {
				name		: "",
				sel_loginID : "",
				selCtg 		: "",
				ing_yn 		: "",
				addr1		: "",
				addr2		: "",
				addr3		: "",
				selSex		: "",
				hp1			: "",
				hp2			: "",
				hp3			: "",
				birthday	: "",
				email		: "",
					
				action		: "",
				disabled	: true,
				delflag		: false,
				
				isTrue		: true,
			},
			methods	: {
				fnSelectID	: function(LoginID){
					fnSelectId(LoginID);
				},
				execDaumPostcode : function(){
					execDaumPostcode();
				}
				
			}
		}),
		listStdLec = new Vue({
			el		: "#listStdLec",
			data	: {
				pageSizeDtl 	: 0,
				currentPageDtl  : 0,
				pageBlockDtl	: 0,
				
				totalCntDtl 	: 0,	
				dataListDtl	: [],
				
				pagingnaviDtl	: "",				
				
			},
		}),
		lecpop = new Vue({
			el		: "#lecpop",
			data	: {
				lec_nm		: "",
				lec_ctg		: "",
				ins_nm		: "",
				cls_room	: "",
				ins_email	: "",
				ins_hp 		: "",
				lec_goal 	: "",
			},
			methods : {
				fnSelectLec : function(){
					fnSelectLec(lec_cd, loginID);
				}
			}
		})
	}
	
	/* 버튼 이벤트 등록 - 저장, 수정, 삭제  */
	function fRegisterButtonClickEvent(){
		$('a[name=btn]').click(function(e){ // a테그중 name에 btn들어가는 것을 클릭하였을 때
			e.preventDefault(); // 이벤트의 초기값 초기화
					
			var btnId = $(this).attr('id'); // btnId는 해당태그의 id속성의 값을 가진다
			
			//alert("btnId : " + btnId);
			
			switch(btnId){
			case 'btnSave' : fnSave(); //  저장
							 if(StdRegPop.action == "I") {
								fnSearchList();
						  	 } else if(StdRegPop.action == "U") {
								fnSearchList($("#currentPage").val());
							 } else if(StdRegPop.action == "D") {
								fnSearchList();
							 }
				break;
			case 'btnDelete' : fnDelete();	// 삭제
				break;
			case 'btnUpdate' : fnUpdate();  // 수정하기
				break;
			case 'btnClose' : gfCloseModal();  // 모달닫기 
				break;
				
			}
		});
	}
	// 우편번호 api
	function execDaumPostcode(q) {
		new daum.Postcode({
			oncomplete : function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if (data.userSelectedType === 'R') {
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if (data.buildingName !== '' && data.apartment === 'Y') {
						extraAddr += (extraAddr !== '' ? ', '
								+ data.buildingName : data.buildingName);
					}
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				StdRegPop.addr1 = data.zonecode;
				StdRegPop.addr2 = addr;
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("addr3").focus(); //상세 주소
			}
		}).open({
			q : q
		});
	}

	/* 4. 학생 리스트 불러오기  */
	function fnSearchList(currentPage){
		
		currentPage = currentPage || 1;   //  || = or 현재 페이지를 1로 설정
		
	//alert("현재 페이지 : " + currentPage);
		// 4-1. 각각의 변수들을 param에 넣습니다. 변수 설명은 아래 참조
    	var param = {
    			pageSize : pageSize, // 제일 위에 1에서 설정함 1페이지에 나타내야하는 게시글 숫자
    			currentPage : currentPage, // 현재 페이지는 초기 1 Ajax 통신을 통해 페이지 변경시 변하게됨
    			searchSel : searchArea.searchSel, // searchsel id에 있는 value값
    			searchText : searchArea.searchText,
    	}

		
    	var listCallBack = function(returnData) {
    		console.log(returnData);
			
    		stuList.totalCnt = returnData.totalCnt;
    		stuList.dataList = returnData.listStd;
    		
    		console.log("totalCnt!!!!    " + stuList.totalCnt);

    		stuList.pagingnavi = getPaginationHtml(currentPage, stuList.totalCnt, pageSize, pageBlock, 'fnSearchList');
    		console.log("paginationHtml : " + stuList.pagingnavi);
    		//swal(paginationHtml);
    		
    		// 현재 페이지 설정
    		stuList.currentPage = currentPage;
		}
		//5. param에 정보들을 모아모아 control에 있는 listStd으로 보내고, listcallback으로 다시 받음
    	callAjax("/adm/listStdvue.do", "post", "json", true, param, listCallBack);
		
	}
   	// 상세 팝업
    function fnOpenPopUp() {
    	
    	fnPopUpInt();
    	
		// 모달 팝업
		gfModalPop("#StdRegPop");
		
    }
	//셀렉트 모달 / 변수 적용
    function fnSelectId(LoginID) {
    	
    	var param = {
    			loginID : LoginID,
    			
    	}
    	
    	var selectCallBack = function(returnData) {
    		console.log(JSON.stringify(returnData));  
    		console.log(returnData.sectInfo);
    		
    		fnPopUpInt(returnData.sectInfo);
    		
    		gfModalPop("#StdRegPop");
    	}
    	
    	callAjax("/adm/selectStd.do", "post", "json", true, param, selectCallBack);
    	
    }
    
    //////셀렉트 모달의 실행함수 정의
    function fnPopUpInt(data) {
    	
    	
    	
    	StdRegPop.name = data.name; // 이름
    	StdRegPop.sel_loginID = data.loginID;// 등록 ID
    	if(data.ctg_nm == null || data.ctg_nm == undefined){
    		data.ctg_nm = '';
    	}
    	StdRegPop.selCtg = data.ctg_nm; // 값 설정
    	
    	console.log(StdRegPop.selCtg);
    	console.log(data.ctg_nm);
    	
    	StdRegPop.ing_yn = data.ing_yn; // 비밀번호 확인
    	
    	StdRegPop.addr1 = data.addr.split(',')[2]; // 우편번호
    	StdRegPop.addr2 = data.addr.split(',')[0]; // 주소
    	StdRegPop.addr3 = data.addr.split(',')[1]; // 상세주소
    	
    	StdRegPop.selSex = data.sex; // 성별
    	
    	StdRegPop.hp1 = data.hp.split('-')[0]; // 연락처 1
    	StdRegPop.hp2 = data.hp.split('-')[1]; // 연락처 2
    	StdRegPop.hp3 = data.hp.split('-')[2]; // 연락처 3
    	
    	StdRegPop.birthday = data.birthday; // 생일 입력
    	
    	StdRegPop.email = data.email; // 이메일
    	
		  
    	
    	if(data.ctg_nm == null || data.ctg_nm == undefined || data.ctg_nm == "") {
    		StdRegPop.action = "I"; //액션 
    	}  else {
    		StdRegPop.action = "U";  
    	}   	

    }

    // 세이브 버튼을 누르면 발동! 세이브 버튼은 fnPopUpInt 모달안에 있으므로 해당 모달에 붙어있다고 보면된다.
	function fnSave() {
    	
    	if(!fnValidate()) { //값을 다 넣었는지??
    		return;
    	}
    	
    	var param = { //컨트롤로 넘길 정보 목록들
    			action : StdRegPop.action, 
    			name : StdRegPop.name,
    			loginID : StdRegPop.sel_loginID,
    			password : StdRegPop.password,
    			addr : StdRegPop.addr2 +","+ StdRegPop.addr3 +"," + StdRegPop.addr1,
    			hp : StdRegPop.hp1+"-"+StdRegPop.hp2+"-"+StdRegPop.hp3,
    			birthday : StdRegPop.birthday,
    			email : StdRegPop.email,    			
    			sex : StdRegPop.selSex, 
    			ctg_nm : StdRegPop.selCtg, 
    	}
    	
    	var saveCallBack = function(returnValue) {
    		console.log(JSON.stringify(returnValue));
    		
    		if(returnValue.resultMsg == "저장" || returnValue.resultMsg == "수정" || returnValue.resultMsg == "삭제") {
    			swal(returnValue.resultMsg +" 되었습니다.");
    			gfCloseModal();
    			fnSearchList(stuList.currentPage);
    		};
    		
    	};
    	
    	callAjax("/adm/stdSave.do", "post", "json", true, param, saveCallBack);
    }
	// 저장 validation 
	function fnValidate() {

		var chk = checkNotEmpty(
				[
						[ "name", "이름을 입력해 주세요." ]
					,	[ "sel_loginID", "ID를 입력해 주세요" ]				
					,	[ "addr1", "우편번호를 입력해 주세요" ]				
					,	[ "addr2", "주소를 입력해 주세요" ]				
					,	[ "addr3", "상세주소를 입력해 주세요" ]				
					,	[ "hp1" || "hp2" || "hp3", "연락처를 모두 입력해 주세요" ]				
					,	[ "birthday", "생년월일을 입력해 주세요" ]				
					,	[ "email", "이메일을 입력해 주세요" ]				
					,	[ "sex", "성별을 입력해 주세요" ]				
					,	[ "selCtg", "학생상태를 선택해주세요" ]				
						]
		);

		if (!chk) {
			return;
		}

		return true;
	}
	
    function fnDelete() {
    	StdRegPop.action = "D"; 
    	fnSave();
    } 
//////////////////////////여기서 부터는 하단 모달 작업////////////////////////////////////////////////////////////
	var pageSizeDtl = 5;    // 내역 데이터 수
	var pageBlockDtl = 5;   // 내역 페이지 수
 	function fnListStdLec(currentPageDtl, selID) {
		var selID = selID;
		currentPageDtl = currentPageDtl || 1;

		// 장비코드 정보 설정
		
		var param = {
					loginID : selID
				,	currentPage : currentPageDtl
				,	pageSize : pageSizeDtl
		}
		console.log(param);
		var resultCallback = function(data) {
		console.log(data);
			listStdLec.dataListDtl = data.listStdLec;
			listStdLec.totalCntDtl = data.totalCntStdLec;
			console.log("dataList??????" + listStdLec.dataListDtl);
			listStdLec.pagingnaviDtl = getPaginationHtml(currentPageDtl, listStdLec.totalCntDtl, pageSizeDtl, pageBlockDtl, 'fnListStdLec', [selID]);
			console.log(listStdLec.pagingnaviDtl);
			
			listStdLec.currentPageDtl = currentPageDtl;
		};
		
		callAjax("/adm/listStdLecvue.do", "post", "json", true, param, resultCallback);
	}
	
    
////////////////////////////////////강의내용 팝업모달/////////////////////////////////////////////////////////
	//셀렉트 모달 / 변수 적용
    function fnSelectLec(lec_cd, loginID) {
    	
    	var param = {
    			lec_cd : lec_cd,
    			loginID : loginID,
    	}
    	
    	var selectCallBack = function(returnData) {
    		console.log(JSON.stringify(returnData));  
    		console.log(returnData.sectInfoL);
    		
    		fnPopUpIntLec(returnData.sectInfoL);
    		
    		gfModalPop("#lecpop");
    	}
    	
    	callAjax("/adm/selectStdLec.do", "post", "json", true, param, selectCallBack);
    	
    }
    
    //////셀렉트 모달의 실행함수 정의
    function fnPopUpIntLec(data) {
    	lecpop.lec_nm = data.lec_nm; // 강의 코드
    	lecpop.lec_ctg = data.lec_ctg; // 강의명
    	lecpop.ins_nm = data.ins_nm; // 강사명
    	lecpop.cls_room = data.cls_room; // 강의실
    	lecpop.ins_email = data.ins_email; // 이메일
    	lecpop.ins_hp = data.ins_hp; // 연락처
    	lecpop.lec_goal = data.lec_goal; // 수업 목표
    }
</script>


</head>
<body>
	<!-- ///////////////////// html 페이지  ///////////////////////////// -->

<form id="myForm" action="" method="">
	
	<input type="hidden" id="currentPage" value="1">  <!-- 현재페이지는 처음에 항상 1로 설정하여 넘김  -->
	<input type="hidden" id="currentPageDtl" value="1">  <!-- 내역 현재페이지는 처음에 항상 1로 설정하여 넘김  -->
	<input type="hidden" name="action" id="action" value=""> <!-- 뭘 할건지? -->
	<input type="hidden" name="userType" id="usetType" value=""> <!-- 유저 권한 -->
	<input type="hidden" id="swriter" value="${loginId}"> <!-- 작성자 session에서 java에서 넘어온값 -->
	<input type="hidden" id="selStatus" value=""> <!-- 승인 여부  -->
	<input type="hidden" id="selStd" value=""> <!-- 선택된 학생  --> 

	<div id="wrap_area">

		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> 
					<jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">

						<p class="Location">
							<a href="../dashboard/dashboard.do" class="btn_set home">메인으로</a>
							<span class="btn_nav bold"> 인원 관리 </span> 
							<span class="btn_nav bold"> 학생 관리 vue </span> 
							<a href="/adm/studentControl.do" class="btn_set refresh">새로고침</a>
						</p>

						<p class="conTitle" id="searchArea">
							<span>학생 관리 Vue</span> 
							<span class="fr"> 	
							    <select id="searchSel" name="searchSel" v-model="searchSel">
							         <option value="">전체</option>
							         <option value="title">학생명</option>
							         <option value="ID">학생ID</option>
							    </select>
							    <input type="text" id="searchText" name="searchText" v-model="searchText" style="width: 150px; height: 25px;" />
							    <a class="btnType blue" href="#" @click="fnSearchList" name="modal"><span>검색</span></a>
							</span>
						</p>
						<div class="divStuList" id="stuList">
							<table class="col">
								<caption>caption</caption>
	
		                            <colgroup>
						                   <col width="20%">
						                   <col width="15%">
						                   <col width="20%">
						                   <col width="20%">
						                   <col width="10%">
						                   <col width="15%">
					                 </colgroup>
								<thead>
									<tr>
							              <th scope="col">학생명 (ID)</th>
							              <th scope="col">재직상태</th>
							              <th scope="col">휴대전화</th>
							              <th scope="col">가입일자</th>
							              <th scope="col">수강 여부</th>
							              <th scope="col">수강 이력 보기</th>
									</tr>
								</thead>
								<tbody>
									<template v-if="totalCnt == 0">
										<tr>
											<td colspan="20">학생 정보가 없습니다.</td>
										</tr>
									</template>
									<template v-else v-for="list in dataList">
										<tr>
											<td><a href="#" @click="fnSelectId(list.loginID)">{{list.name}} ({{list.loginID}})</a></td>
											<template v-if="list.ctg_nm == null || list.ctg_nm == undefined">
												<td> 미입력 </td>
											</template>
											<template v-else>
												<td>{{list.ctg_nm}}</td>
											</template>
											<td>{{list.hp}}</td>
											<td>{{list.regdate.split(" ")[0]}}</td>
											<td>{{list.ing_yn}}</td>
											<td><a class="btnType3 color1" href="#" @click="fnListStdLec(1,list.loginID)"><span>수강이력보기</span></a></td>
										</tr>
									</template>
								</tbody>
							</table>
							
							<!-- 페이징 처리  -->
							<div class="paging_area" id="pagingnavi" v-html="pagingnavi">
							</div>
						</div>
			<p class="conTitle mt50">
				<span>학생 수강이력</span> 
			</p>

		<div class="divStdLecList" id="listStdLec">
			<table class="col">
				<caption>caption</caption>
				<colgroup>
					<col width="8%">
					<col width="20%">
					<col width="10%">
					<col width="8%">
					<col width="15%">
					<col width="15%">
					<col width="8%">
					<col width="8%">
					<col width="8%">
				</colgroup>

				<thead>
					<tr>
						<th scope="col">강의코드</th>
						<th scope="col">강의명</th>
						<th scope="col">강사명</th>
						<th scope="col">강의실</th>
						<th scope="col">강의시작일</th>
						<th scope="col">강의종료일</th>
						<th scope="col">승인여부</th>
						<th scope="col">종강여부</th>
						<th scope="col">상태</th>
					</tr>
				</thead>
				<tbody >
						<template v-if="totalCntDtl == 0">
						<tr>
							<td colspan="12">학생을 선택해 주세요.</td>
						</tr>
						</template>
						<template v-else v-for="list in dataListDtl">
						<tr>
							<td>{{list.lec_cd}}</td>
							<td><a href="#" @click="fnSelectLec(list.lec_cd,list.loginID)">{{list.lec_nm}}</a></td>
							<td>{{list.ins_nm}}</td>
							<td>{{list.cls_room}}</td>
							<td>{{list.lec_start_date}}</td>
							<td>{{list.lec_end_date}}</td>
							<td>{{list.app_yn}}</td>
							<td>{{list.end_yn}}</td>
							<td>{{list.lec_status}}</td>
						</tr>
						</template>
				</tbody>
			</table>
		<div class="paging_area"  id="pagingnaviDtl" v-html="pagingnaviDtl"> </div>
		</div>
		</div>
		
					<h3 class="hidden">풋터 영역</h3>
				<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>	
	
	</div>


	<!--// 모달팝업 -->
	<div id="StdRegPop" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>학생 정보조회</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="150px">
						<col width="180px">
						<col width="150px">
						<col width="180px">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">이름<span class="font_red">*</span></th>
							<td>
								<input type="text" class="inputTxt p100" name="name" id="name" v-model="name"/>
							 </td>
							<th scope="row">아이디<span class="font_red">*</span></th>
							<td>
								<input type="text" class="inputTxt p100" name="sel_loginID" id="sel_loginID" v-model="sel_loginID" />
							</td>
						</tr>
						<tr>
							<th scope="row">학생 상태<span class="font_red">*</span></th>
							<td>
								<select id="selCtg" name="selCtg" v-model="selCtg">
									<option value = "" :selected="isTrue" :disabled="isTrue">선택</option>
									<option value = "실업자">실업자</option>
									<option value = "재직자">재직자</option>
								</select>
							 </td>
							<th scope="row">수강 여부<span class="font_red">*</span></th>
							<td>{{ing_yn}}
							</td>
						</tr>
						<tr>
							<th scope="row">우편번호<span class="font_red">*</span></th>
							<td colspan="2">
								<input type="text" class="inputTxt p100" name="addr1" id="addr1" :disabled="disabled" v-model="addr1"/>
							 </td>
							<td><input type="button" value="우편번호 찾기"
									@click="execDaumPostcode"
									style="width: 130px; height: 20px;" /></td>
						</tr>
						<tr>
							<th scope="row">주소 <span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100" name="addr2" id="addr2" v-model="addr2" :disabled="disabled" />
						    </td>
						</tr>
						<tr>
							<th scope="row">상세주소<span class="font_red">*</span></th>
							<td colspan="3">
							     <input type="text" class="inputTxt p100" name="addr3" id="addr3" v-model="addr3" />
						    </td>
						</tr>
						<tr>
							<th scope="row">성별<span class="font_red">*</span></th>
							<td colspan="3" id="selSex" name="selSex"  >
								<label><input type="radio" name="sex" v-model="selSex" id="male" value="M" checked="true"> 남자 </label>
								<label><input type="radio" name="sex" v-model="selSex" id="female" value="F"> 여자 </label>
							</td>
						</tr>
						<tr>
							<th scope="row">연락처<span class="font_red">*</span></th>
							<td colspan = "3">
							     <input class="inputTxt" style="width: 118px" maxlength="3" type="text" name="hp1" id="hp1" v-model="hp1" />
							    - <input class="inputTxt" style="width: 118px" maxlength="4" type="text" name="hp2" id="hp2" v-model="hp2"/>
							    - <input class="inputTxt" style="width: 118px" maxlength="4" type="text" name="hp3" id="hp3" v-model="hp3"/>
						    </td>
						</tr>
						<tr>
							<th scope="row">생년월일<span class="font_red">*</span></th>
							<td>
							     <input type="date" class="inputTxt p100" name="birthday" id="birthday" style="font-size: 15px" v-model="birthday"/>
						    </td>
						</tr>
						<tr>
							<th scope="row">이메일<span class="font_red">*</span></th>
							<td colspan = "3">
							     <input type="text" class="inputTxt p100" name="email" id="email" v-model="email"/>
						    </td>
						</tr>
					</tbody>
				</table>
	
				<!-- e : 여기에 내용입력 -->
	
				<div class="btn_areaC mt30">
						<a href="" class="btnType blue" id="btnSave" name="btn"><span>저장</span></a> 
						<a href="" class="btnType blue" id="btnDelete" name="btn" v-show="delflag"><span>삭제</span></a> 
						<a href=""	class="btnType gray"  id="btnClose" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop" id="btnClose" name="btn"><span class="hidden">닫기</span></a>
	</div>
<!-- 강의계획서 모달팝업 -->	
	<div id="lecpop" class="layerPop layerType2" style="width: 1000px;">
		<dl>
			<dt>
				<strong>강의 계획서</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="200px">
						<col width="300px">
						<col width="200px">
						<col width="300px">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">강의명</th>
							<td>{{lec_nm}}</td>
							<th scope="row">분류</th>
							<td>{{lec_ctg}}</td>
						</tr>
						<tr>
							<th scope="row">강사명</th>
							<td>{{ins_nm}}</td>
							<th scope="row">강의실</th>
							<td >{{cls_room}}</td>
						</tr>
						<tr>
							<th scope="row">이메일</th>
							<td >{{ins_email}}</td>
							<th scope="row">연락처</th>
							<td >{{ins_hp}}</td>
						</tr>
						<tr>
							<th scope="row">수업목표</th>
							<td colspan="3">
								<textarea name="lec_goal" id="lec_goal" v-model="lec_goal"  rows="5" cols="30" style="resize:none; border:none; outline:none;" readonly></textarea>
						    </td>
						</tr>
					</tbody>
				</table>
				
				<div class="btn_areaC mt30">
					<a href="" class="btnType gray" id="btnClose" name="btn"><span>닫기</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>


</form>

</body>
</html>
