<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>강의실</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	
	// 1. 페이징 설정 
	var pageSize = 5;    	// 화면당 데이터 수 
	var pageBlock = 5;		// 하단 메뉴에 보이는 페이지 수
	
	var searchArea;
	var divRoomList;
	var roomPop;
	///////////하단 모달
	var pageSizeDtl = 5;
	var pageBlockDtl = 5;
	
	
	var searchAreaDtl;
	var listRoomDtl;
	var roomDtlPop;
	

	
	
	/* 2. html을 한번 읽고 함수 실행 */
	$(function(){
		//vue 초기화
		 vueinit(); 
		 
		 /*$("#searchSel").change(function() {
	    	fnSearchChange();
	    });	 */
		 
		// 3. 장비 조회 
		fnSearchList();
		
		// 버튼 이벤트 등록 (저장, 수정, 삭제, 모달창 닫기)
		fRegisterButtonClickEvent();
	});
	function vueinit(){
		
		searchArea = new Vue({
				el : "#searchArea",
			  data : {
				  searchSel : "",
				  searchText : "",
				  searchSelBox : "<input type='text' id='searchText' name='searchText' v-model='searchText' style='width: 150px; height: 25px;' />",
			  },
		  methods : {
				fnSearchChange : function(){
				    this.searchText = "";
				},
				fnSearchList : function(){
					fnSearchList();
				},
				fnOpenPopUp : function(){
					fnOpenPopUp();
				}
			}
		});
		
		divRoomList = new Vue({
				el : "#divRoomList",
			  data : {
				dataList : [],
				totalCnt : 0,
				pagingnavi : "",
				currentPage : 0,
			  },
		   methods : {
			   fnSelectRoom : function(room_cd){
				   fnSelectRoom(room_cd)
			   },
			   fnListRoomDtl : function(currentPageDtl, cls_room_cd, cls_room_nm){
					fnListRoomDtl(currentPageDtl, cls_room_cd, cls_room_nm) 
			   }
		   }
		});
		
		roomPop = new Vue({
		    el : "#roomPop",
		  data : {
			  selroomcd : 0, //강의실 코드
			  cls_room_nm : "", //강의실 이름
			  cls_room_size : 0, // 강의실 사이즈
			  cls_room_seat : 0, // 강의실 좌석수
			  cls_room_etc : "", // 강의실 비고
			  cls_room_use_yn : "", //강의실 사용여부
			  OriginYN : "", // 강의실 사용여부 오리지널
			  cnt_equ : 0, // 강의실 내의 보유중인 장비 종류 숫자 (강의실 삭제방지)
			  action : "", // 액션
			  delflag : false,
		  },
		methods : {
				fnUsingCheck : function(){
					fnUsingCheck();
				}
			} 
		})

		////////////하단 Vue
		searchAreaDtl = new Vue({
			el : "#searchAreaDtl",
			data : {
				cls_room_cd : "",
				cls_room_nm : "",
			}
		}),
		listRoomDtl = new Vue({
			el : "#listRoomDtl",
			data : {
				dataListDtl : [],
				totalCntDtl : 0,
				pagingnaviDtl : "",
				currentPageDtl : 0,
			}
		})
		roomDtlPop = new Vue({
			el : "#roomDtlPop",
			data : {
				dtl_cls_room_cd : "",
				dtl_cls_room_nm : "",
				dtl_able_cnt : 0,
				
				equ_cd : "",
				equ_nm : "",
				
				etc : "",
				use_cnt : 0,
				
				actionDtl : "",
				delflagDtl : false,
				
				isReadOnly : true,
				grayColor :  {
			        backgroundColor: '#f0f0f0'
			      },
			    isHidden : true,
			    
			    a : "equ",
			    b : "equ_cd",
			    c : "sel",
			    d : "",
			    e : ""
			},
			methods : {
				fnSelectDtl : function(equ_cd, cls_room_cd){
					fnSelectDtl(equ_cd, cls_room_cd);
				},
				fnOpenPopUpDtl : function(){
					fnOpenPopUpDtl();
				},
				fnDupEquCheck : function(){
					fnDupEquCheck();
				},
				callCombo : function(){
					
					selectComCombo(this.a,this.b,this.c,this.d,this.equ_cd);
					
				},
			},
			updated: function () {
				    if (this.actionDtl == 'I') {
					
				       this.callCombo();
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
				break;
			case 'btnDelete' : fnDelete();	// 삭제
				break;
			case 'btnUpdate' : fnUpdate();  // 수정하기
				break;
			case 'btnSaveDtl' : fnSaveDtl();  //  내역저장
				break;
			case 'btnDeleteDtl' : fnDeleteDtl();	// 내역삭제
				break;
			case 'btnUpdateDtl' : fnUpdateDtl();  // 내역수정하기
				break;
			case 'btnCloseDtl' : 
			case 'btnClose' : gfCloseModal();  // 모달닫기 

				break;
			}
		});
	}
	
	/* 4. 공지사항 리스트 불러오기  */
	function fnSearchList(currentPage){
		
		currentPage = currentPage || 1;   //  || = or 현재 페이지를 1로 설정
		
		
		
		// 4-1. 각각의 변수들을 param에 넣습니다. 변수 설명은 아래 참조
    	var param = {
    			pageSize : pageSize, // 제일 위에 1에서 설정함 1페이지에 나타내야하는 게시글 숫자
    			currntPage : currentPage, // 현재 페이지는 초기 1 Ajax 통신을 통해 페이지 변경시 변하게됨
    			searchSel : searchArea.searchSel, // searchsel id에 있는 value값
    			searchText : searchArea.searchText,
    	}
		
		console.log(searchArea.searchText);

		
    	var listCallBack = function(returnData) {
    		console.log(JSON.stringify(returnData));
    		

    		divRoomList.dataList = returnData.listRoom;
    		divRoomList.totalCnt = returnData.totalCnt;
    		
    		var paginationHtml = getPaginationHtml(currentPage, divRoomList.totalCnt, pageSize, pageBlock, 'fnSearchList');
    		console.log("paginationHtml : " + paginationHtml);
    		//swal(paginationHtml);
    		// 현재 페이지 설정
    		divRoomList.pagingnavi = paginationHtml;
    		divRoomList.currentPage = currentPage
    		
		};
		//5. param에 정보들을 모아모아 control에 있는 listRoom으로 보내고, listcallback으로 다시 받음
    	callAjax("/adm/listRoomVue.do", "post", "json", true, param, listCallBack);
		
	}

	// 상세 팝업
    function fnOpenPopUp() {
    	
    	fnPopUpInt();
    	
		// 모달 팝업
		gfModalPop("#roomPop");
		
    }
	//셀렉트 모달 / 변수 적용
    function fnSelectRoom(cls_room_cd) {
    	
    	var param = {
    			cls_room_cd : cls_room_cd,
    			
    	}
    	
    	var selectCallBack = function(returnData) {
    		console.log(JSON.stringify(returnData));  
    		console.log(returnData.sectInfo);
    		
    		fnPopUpInt(returnData.sectInfo);
    		
    		gfModalPop("#roomPop");
    	}
    	
    	callAjax("/adm/selectRoom.do", "post", "json", true, param, selectCallBack);
    	
    }
       
    //////셀렉트 모달의 실행함수 정의
    function fnPopUpInt(data) {

    	if(data == null || data == undefined || data == "") {
    		roomPop.selroomcd = ""; // 선택코드
        	
    		roomPop.cls_room_nm = ""; // 강의실 명
    		roomPop.cls_room_etc = ""; // 비고
    		roomPop.cls_room_size = ""; // 강의실 크기
    		roomPop.cls_room_seat = ""; // 강의실 좌석수
    		roomPop.cls_room_use_yn = ""; // 강의실 사용유무
    		roomPop.action = "I"; 
        	
    		roomPop.delflag = false
        	//$("#btnDelete").hide();   		
    	}  else {
    		roomPop.selroomcd = data.cls_room_cd
        	
        	roomPop.cls_room_nm = data.cls_room_nm; //강의실 명
        	roomPop.cls_room_etc = data.cls_room_etc; //비고
    		roomPop.cls_room_size = data.cls_room_size; // 강의실 크기
    		roomPop.cls_room_seat = data.cls_room_seat; // 강의실 좌석수
    		roomPop.cls_room_use_yn = data.cls_room_use_yn; // 강의실 사용유무
    		roomPop.OriginYN = data.cls_room_use_yn; // 강의실 사용유무
        	roomPop.cnt_equ = data.cnt_equ
    		
        	roomPop.action = "U";  
        	
        	roomPop.delflag = true;
        	//$("#btnDelete").show();
    	}   	

    } 

    // 세이브 버튼을 누르면 발동! 세이브 버튼은 fnPopUpInt 모달안에 있으므로 해당 모달에 붙어있다고 보면된다.
	function fnSave() {
    	
    	if(!fnValidate()) { //값을 다 넣었는지??
    		return;
    	}
    	
    	var param = { //컨트롤로 넘길 정보 목록들
    			action : roomPop.action, 
    			cls_room_cd : roomPop.selroomcd,
    			cls_room_nm : roomPop.cls_room_nm,
    			cls_room_size : roomPop.cls_room_size,
    			cls_room_seat : roomPop.cls_room_seat,
    			cls_room_etc : roomPop.cls_room_etc,
    			cls_room_use_yn : roomPop.cls_room_use_yn,
    	}
    	
    	var saveCallBack = function(returnValue) {
    		console.log(JSON.stringify(returnValue));
    		
    		if(returnValue.resultMsg == "저장" || returnValue.resultMsg == "수정" || returnValue.resultMsg == "삭제") {
    			swal(returnValue.resultMsg +" 되었습니다.");
    			gfCloseModal();
    			if(roomPop.action == "I") {
    				fnSearchList();
    			} else if(roomPop.action == "U") {
    				fnSearchList(divRoomList.currentPage);
    			} else if(roomPop.action == "D") {
    				fnSearchList(divRoomList.currentPage);
    			}
    		}
    		
    	}
    	
    	callAjax("/adm/roomSave.do", "post", "json", true, param, saveCallBack);
    }
	
	// 저장 validation 
	function fnValidate() {

		var chk = checkNotEmpty(
				[
						[ "cls_room_nm", "장비명을 입력해 주세요." ]
					,	[ "cls_room_size", "크기를 입력해 주세요" ]				
					,	[ "cls_room_seat", "좌석 수를 입력해 주세요" ]				
					,	[ "cls_room_use_yn", "사용 유무를 입력해 주세요" ]				
						]
		);

		if (!chk) {
			return;
		}
		return true;
	}

    function fnDelete() {
    	if(roomPop.cnt_equ != 0){
    		swal("해당 강의실 내의 장비를 모두 삭제 후 다시 시도해주세요")
    		return false
    	}else{
    		roomPop.action = "D"; 
	    	fnSave();
    	}
    }
    // 종강되지 않은 강의실이 하나라도 있으면 못바꿈
	function fnUsingCheck() {
	    var OriginYN = roomPop.OriginYN;
	    console.log(OriginYN);
	    var param = {
	        cls_room_nm: roomPop.cls_room_nm
	    }
	    var resultCallback = function (returnData) {
	        console.log(JSON.stringify(returnData));
	        console.log(returnData.usingYN);
	        if (returnData.usingYN != '0') {
	            swal("해당 강의실을 사용하는 종강되지 않은 강의가 있습니다. 확인 후 수정해주세요.")
	                .then(function() {
	                    // 에러가 발생했을 때, 셀렉트 박스의 값을 원래 값으로 되돌립니다.
	                    roomPop.cls_room_use_yn = OriginYN;
	                    console.log(JSON.stringify(OriginYN));
	                });
	        }
	    };
	
	    callAjax("/adm/usingRoomCheck.do", "post", "json", true, param, resultCallback);
	} 
    
    
///////////////////////////////하단 모달 작업 앞에 dtl또는 Dtl넣어서 구분 ///////////////////////////////////////////////////////////////
	// 강의실-장비 목록 조회
 	var pageSizeDtl = 5;    // 내역 데이터 수
	var pageBlockDtl = 5;   // 내역 페이지 수
	
	
 	function fnListRoomDtl(currentPageDtl, cls_room_cd, cls_room_nm) {
		
		currentPageDtl = currentPageDtl || 1;

		// 강의실코드 정보 설정
		searchAreaDtl.cls_room_cd = cls_room_cd;
		searchAreaDtl.cls_room_nm = cls_room_nm;
		
		var param = {
					cls_room_cd : searchAreaDtl.cls_room_cd
				,	cls_room_nm : searchAreaDtl.cls_room_nm
				,	currentPage : currentPageDtl
				,	pageSize : pageSizeDtl
		}
		console.log(param);
		
		var listCallbackDtl = function(data) {
			console.log(JSON.stringify(data))
			
    		listRoomDtl.dataListDtl = data.listRoomDtl;
			listRoomDtl.totalCntDtl = data.totalCntDtl;
			console.log(listRoomDtl.dataListDtl);
    		var paginationHtmlDtl = getPaginationHtml(currentPageDtl, listRoomDtl.totalCntDtl, pageSizeDtl, pageBlockDtl, 'fnListRoomDtl', [cls_room_cd, cls_room_nm]);
    		console.log("paginationHtmlDtl : " + paginationHtmlDtl);
    		//swal(paginationHtml);
    		// 현재 페이지 설정
    		listRoomDtl.pagingnaviDtl = paginationHtmlDtl;
    		listRoomDtl.currentPageDtl = currentPageDtl;
		};
		
		callAjax("/adm/listRoomDtlVue.do", "post", "json", true, param, listCallbackDtl);
	}
		
	// 상세코드 단건 조회
    function fnOpenPopUpDtl() {
    	if(searchAreaDtl.cls_room_cd == null || searchAreaDtl.cls_room_cd == undefined || searchAreaDtl.cls_room_cd == "") {
    		swal("강의실을 선택해주세요")
    	}else{
    	
    	
		// 팝업 오픈
    	fnPopUpInitDtl();
		// 모달 팝업
		gfModalPop("#roomDtlPop");
    	}
    }
	// 내역 셀리트 모달 적용
	function fnSelectDtl(equ_cd, cls_room_cd) {

		var param = {
				    equ_cd : equ_cd
				,	cls_room_cd : cls_room_cd
		};
		
		var resultCallback = function(returnData) {
    		console.log(JSON.stringify(returnData));  
    		console.log(returnData.sectInfoD);
			fnPopUpInitDtl(returnData.sectInfoD);
			
			gfModalPop("#roomDtlPop")
		};
		
		callAjax("/adm/selectRoomDtl.do", "post", "json", true, param, resultCallback);
	}

	

    //////셀렉트 모달의 실행함수 정의
    function fnPopUpInitDtl(data) {
    	
    	
    	var inhtml = "";

    	if(data == null || data == undefined || data == "") {
    		roomDtlPop.dtl_cls_room_cd = searchAreaDtl.cls_room_cd; // 강의실 코드
    		roomDtlPop.dtl_cls_room_nm = searchAreaDtl.cls_room_nm; // 강의실 명
    		
			roomDtlPop.dtl_able_cnt = "";
			roomDtlPop.equ_cd = "";
    		
			roomDtlPop.etc = ""; // 비고
			roomDtlPop.use_cnt = ""; // 사용 개수
        	
			roomDtlPop.actionDtl = "I";
        	
        	roomDtlPop.delflagDtl = false;		
        	
        	//selectComCombo(roomDtlPop.a,roomDtlPop.b,roomDtlPop.c,roomDtlPop.d,roomDtlPop.e);

        	
    	}  else {
        	roomDtlPop.dtl_cls_room_cd = searchAreaDtl.cls_room_cd; // 강의실 코드
    		roomDtlPop.dtl_cls_room_nm = searchAreaDtl.cls_room_nm; // 강의실 명
    		roomDtlPop.dtl_able_cnt = data.equ_able_cnt + data.use_cnt;
    		
    		
    		roomDtlPop.equ_cd = data.equ_cd; // 장비 코드
    		roomDtlPop.equ_nm = data.equ_nm; // 장비 명
    		roomDtlPop.etc = data.etc; // 비고
    		roomDtlPop.use_cnt = data.use_cnt; // 비고

        	roomDtlPop.actionDtl = "U";  
    		
        	roomDtlPop.delflagDtl = true;
    	}   	

    }
    // 
    function fnDupEquCheck() {
    	if(roomDtlPop.equ_cd == null || roomDtlPop.equ_cd == "" || roomDtlPop.equ_cd == undefined){
    		
    	}else{
	    	var param = {
	    			cls_room_cd : searchAreaDtl.cls_room_cd,
	    			equ_cd : roomDtlPop.equ_cd,
	    	}
	    	roomDtlPop.dtl_able_cnt = '';
			var resultCallback = function(returnData) {
	    		console.log(JSON.stringify(returnData));  
	    		console.log(returnData.dupYN);
	    		console.log(returnData.equ_able_cnt);
				if(returnData.dupYN == '1') {
					swal("이미 강의실에 장비가 있습니다. 확인 후 수정해주세요.")
					roomDtlPop.equ_cd ='';
				}else{
					roomDtlPop.dtl_able_cnt = returnData.equ_able_cnt;
				}
			};
			callAjax("/adm/dupEquCheck.do", "post", "json", true, param, resultCallback);
    	};
    }
    
    // 저장 수정 삭제 시작
	function fnSaveDtl() {
    	
    	if(!fnValidateDtl()) { //값을 다 넣었는지??
    		return;
    	}

    	var param = { //컨트롤로 넘길 정보 목록들
    			action : roomDtlPop.actionDtl, 
    			equ_cd : roomDtlPop.equ_cd,
    			equ_nm : roomDtlPop.equ_nm,
    			cls_room_nm : roomDtlPop.dtl_cls_room_nm,
    			cls_room_cd : roomDtlPop.dtl_cls_room_cd,
    			etc : roomDtlPop.etc,
    			use_cnt : roomDtlPop.use_cnt,
    			equ_able_cnt : roomDtlPop.dtl_able_cnt,
    			originUse : roomDtlPop.originUse,
    	};
    	
    	var saveCallBack = function(returnValue) {
    		console.log(JSON.stringify(returnValue));
    		
    		if(returnValue.resultMsg == "저장" || returnValue.resultMsg == "수정" || returnValue.resultMsg == "삭제") {
    			swal(returnValue.resultMsg +" 되었습니다.");
    			gfCloseModal();
    			if(roomDtlPop.actionDtl == "I") {
    				fnSearchList();
    				fnListRoomDtl(listRoomDtl.currentPageDtl, roomDtlPop.dtl_cls_room_cd, roomDtlPop.dtl_cls_room_nm);
    			} else if(roomDtlPop.actionDtl == "U") {
    				fnSearchList(divRoomList.currentPage);
    				fnListRoomDtl(listRoomDtl.currentPageDtl, roomDtlPop.dtl_cls_room_cd, roomDtlPop.dtl_cls_room_nm);
    			} else if(roomDtlPop.actionDtl == "D") {
    				fnSearchList(divRoomList.currentPage);
    				fnListRoomDtl(listRoomDtl.currentPageDtl, roomDtlPop.dtl_cls_room_cd, roomDtlPop.dtl_cls_room_nm);
    			}
    		}
    		
    	}
    	
    	callAjax("/adm/roomDtlSave.do", "post", "json", true, param, saveCallBack);
    }
	// 저장 validation
 	function fnValidateDtl() {

		var chk = checkNotEmpty(
				[
						[ "cls_room_cd", "강의실을 선택해 주세요." ]
					,	[ "use_cnt", "사용 수량을 입력해 주세요" ]				]
		);

		if (!chk) {
			return;
		}
		var useChk = fnChkUse()
		if(!useChk){
			return;
		}
		return true;
	}

    function fnDeleteDtl() {
    	roomDtlPop.actionDtl = "D"; 
    	fnSaveDtl();
    } 
    function fnChkUse(){
    	if(roomDtlPop.dtl_able_cnt < roomDtlPop.use_cnt){
    		swal("사용가능 개수보다 많이 입력하였습니다. 다시 확인해주세요");
    		return false;
    	}else{
    		return true;
    	}
    };

</script>


</head>
<body>
	<!-- ///////////////////// html 페이지  ///////////////////////////// -->

<form id="myForm" action="" method="">
	

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
							<span class="btn_nav bold"> 시설 관리 </span> 
							<span class="btn_nav bold"> 강의실 관리 </span> 
							<a href="/adm/lectureRoomvue.do" class="btn_set refresh">새로고침</a>
						</p>

						<p id="searchArea" class="conTitle">
							<span>강의실 관리</span> 
							<span class="fr"> 	
							    <select id="searchSel" name="searchSel" v-model="searchSel" @change="fnSearchChange">
							         <option value="">전체</option>
							         <option value="title">강의실명</option>
							         <option value="useYN">사용여부</option>
							    </select>
								    <span id="searchSelBox" >
									    <template v-if="searchSel == 'useYN'">
									        <select id='searchText' name='searchText' v-model='searchText'> 
									        	<option value="" selected disabled hidden>선택</option>
									        	<option value='Y'>사용</option>
									        	<option value='N'>미사용</option> 
									        </select>
									    </template>
									    <template v-else>
									        <input type='text' id='searchText' name='searchText' v-model='searchText' style='width: 150px; height: 25px;' />
									    </template>
								    </span>
							    <a class="btnType blue" href="#" @click="fnSearchList" name="modal"><span>검색</span></a>
							    	<a class="btnType blue" href="#" @click="fnOpenPopUp" name="modal"><span>신규등록</span></a>
							</span>
						</p>

						
						<div id="divRoomList" class="divRoomList">
							<table class="col">
								<caption>caption</caption>
	
		                            <colgroup>
						                   <col width="10%">
						                   <col width="20%">
						                    <col width="15%">
						                    <col width="10%">
						                    <col width="10%">
						                   <col width="30%">
						                   <col width="5%">
					                 </colgroup>
								<thead>
									<tr>
							              <th scope="col">강의실 코드</th>
							              <th scope="col">깅의실 명</th>
							              <th scope="col">강의실 크기(평방미터)</th>
							              <th scope="col">좌석 수</th>
							              <th scope="col">사용여부</th>
							              <th scope="col">비고</th>
							              <th scope="col">수정</th>
							              
									</tr>
								</thead>
								<tbody>
								      <template v-if="totalCnt == 0">
								                <tr>   <td colspan=10> 데이터가 없습니다.  </td> </tr>
								      </template> 
								      <template v-else v-for="list in dataList">
								                <tr> 
								                     <td>{{ list.cls_room_cd }}</td>
						                             <td><a href="#" @click="fnListRoomDtl(1, list.cls_room_cd, list.cls_room_nm)">{{ list.cls_room_nm }}</a></td>
						                             <td>{{ list.cls_room_size }}</td>
						                             <td>{{ list.cls_room_seat }}</td>
						                             <td>{{ list.cls_room_use_yn }}</td>
						                             <td>{{ list.cls_room_etc }}</td>
						                             <td><a class="btnType3 color1" href="#" @click="fnSelectRoom(list.cls_room_cd)"><span>수정</span></a></td>
								                </tr>
								      </template>
								</tbody>
							</table>
							
							<!-- 페이징 처리  -->
							<div class="paging_area" id="pagingnavi" v-html="pagingnavi">
							</div>
											
						</div>
					

			<p id="searchAreaDtl" class="conTitle mt50">
				<span>배치 장비 내역</span> 
				<span class="fr">
					<a class="btnType blue"  href="#" @click="fnOpenPopUpDtl" name="modal"><span>신규등록</span></a>
				</span>
			</p>

		<div class="divComDtlCodList" id="listRoomDtl">
			<table class="col">
				<caption>caption</caption>
				<colgroup>
					<col width="10%">
					<col width="15%">
					<col width="10%">
					<col width="10%">
					<col width="20%">
					<col width="10%">
				</colgroup>

				<thead>
					<tr>
						<th scope="col">장비 코드</th>
						<th scope="col">장비 명</th>
						<th scope="col">강의실 명</th>
						<th scope="col">사용갯수</th>
						<th scope="col">비고</th>
						<th scope="col">수정</th>
					</tr>
				</thead>
				<tbody>
				      <template v-if="totalCntDtl == 0">
		                	<tr>   <td colspan=10> 데이터가 없습니다.  </td> </tr>
				      </template> 
				      <template v-else v-for="list in dataListDtl">
			                <tr> 
								<td>{{list.equ_cd}}</td>
								<td>{{list.equ_nm}}</td>
								<td>{{list.cls_room_nm}}</td>
								<td>{{list.use_cnt}}</td>
								<td>{{list.etc}}</td>
	                             <td><a class="btnType3 color1" href="#" @click="fnSelectDtl(list.equ_cd, list.cls_room_cd)"><span>수정</span></a></td>
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
	<div id="roomPop" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>장비 등록</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="120px">
						<col width="120px">
						<col width="120px">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">강의실 명<span class="font_red">*</span></th>
							<td>
								<input type="hidden" id="cnt_equ"/>
								<input type="text" class="inputTxt p100" name="cls_room_nm" id="cls_room_nm" v-model="cls_room_nm" />
							 </td>
							<th scope="row">사용 여부<span class="font_red">*</span></th>
							<td> 
								<select id="cls_room_use_yn" name="cls_room_use_yn" v-model="cls_room_use_yn" @change="fnUsingCheck">
								 	<option value="" selected disabled hidden>선택</option>
								 	<option value="Y">사용</option>
								 	<option value="N">미사용</option>
								 </select>  
							</td>
						</tr>
						<tr>
							<th scope="row">좌석 수</th>
							<td>
								<input type="text" class="inputTxt p100" name="cls_room_seat" id="cls_room_seat" v-model="cls_room_seat" />
							 </td>
 							<th scope="row">강의실 크기</th>
							<td>
								<input type="text" class="inputTxt p100" name="cls_room_size" id="cls_room_size" v-model="cls_room_size"/>
							 </td>
						</tr>	
						<tr>
							<th scope="row">비고내용 <span class="font_red">*</span></th>
							<td colspan="3">
							     <textarea name="cls_room_etc" id="cls_room_etc"  rows="5" cols="30" v-model="cls_room_etc"></textarea>
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
	<div id="roomDtlPop" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>장비 내역 관리</strong>
			</dt>
			<dd class="content">

				<!-- s : 여기에 내용입력 -->

				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="120px">
						<col width="120px">
						<col width="120px">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">강의실 코드 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" id="dtl_cls_room_cd" name="dtl_cls_room_cd" v-model="dtl_cls_room_cd" :readonly="isReadOnly" :style="grayColor"/></td>
							<th scope="row">강의실 명 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" id="dtl_cls_room_nm" name="dtl_cls_room_nm" v-model="dtl_cls_room_nm" :readonly="isReadOnly" :style="grayColor"/></td>
						</tr>
						<tr>
							<th scope="row">사용가능 갯수 <span class="font_red">*</span></th>
							<td><input type="text" class="inputTxt p100" id=dtl_able_cnt name="dtl_able_cnt" v-model="dtl_able_cnt" :readonly="isReadOnly" :style="grayColor"/></td>
							<th scope="row">장비 명 <span class="font_red">*</span></th>
							<td>
							<template v-if="actionDtl == 'I'">
								<select id='equ_cd' name='equ_cd' v-model="equ_cd"  @change="fnDupEquCheck"></select>
								
							</template>
							<template v-else>
								<input type='text' class='inputTxt p100' id='equ_nm' name='equ_nm' v-model="equ_nm" :readonly="isReadOnly" :style="grayColor"/>
								<input type='hidden' id='equ_cd' name='equ_cd' v-show="isHidden" v-model="equ_cd"/>
							</template>
							</td>

						</tr>
						<tr>
							<th scope="row">사용 갯수 <span class="font_red">*</span></th>
							<td colspan="3">
							<input type="text" class="inputTxt p100" id="use_cnt" name="use_cnt" v-model="use_cnt"/>
							</td>
						</tr>
						<tr>
							<th scope="row">비고</th>
							<td colspan="3">
								<input type="text" class="inputTxt p100" id="etc" name="etc" v-model="etc"/>
							</td>
						</tr>
					
					</tbody>
				</table>

				<!-- e : 여기에 내용입력 -->

				<div class="btn_areaC mt30">
					<a href="" class="btnType blue" id="btnSaveDtl" name="btn"><span>저장</span></a>
					<a href="" class="btnType blue" id="btnDeleteDtl" name="btn" v-show="delflagDtl"><span>삭제</span></a>  
					<a href="" class="btnType gray" id="btnCloseDtl" name="btn"><span>취소</span></a>
				</div>
			</dd>
		</dl>
		<a href="" class="closePop"><span class="hidden">닫기</span></a>
	</div>
	


</form>

</body>
</html>
