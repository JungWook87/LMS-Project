<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>공지사항</title>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet swal import -->

<script type="text/javascript">
	
	// 1. 페이징 설정 
	var pageSize = 10;    	// 화면당 데이터 수 
	var pageBlock = 5;		// 하단 메뉴에 보이는 페이지 수
	
	var searcharea;
	var divNoticeList;
	var noticePop;
	
	/* 2. html을 한번 읽고 함수 실행 */
	$(function(){
/* 		 콤보박스 있을 경우 사용 
		 comcombo("delCD", "searchdel", "all", ""); 콤보박스 띄우기(공통코드명, 셀렉테그ID, 전체?, 초기값) */
		 
		 vueinit();
		 
		 
		 //alert(divNoticeList.usertype);
		 
		// 3. 공지사항 조회 
		fnSearchList();
		
		// 버튼 이벤트 등록 (저장, 수정, 삭제, 모달창 닫기)
		fRegisterButtonClickEvent();
	});

	/* 버튼 이벤트 등록 - 저장, 수정, 삭제  */
	function fRegisterButtonClickEvent(){
		$('a[name=btn]').click(function(e){ // a테그중 name에 btn들어가는 것을 클릭하였을 때
			e.preventDefault(); // 이벤트의 초기값 초기화
					
			var btnId = $(this).attr('id'); // btnId는 해당태그의 id속성의 값을 가진다
			
			//alert("btnId : " + btnId);
			
			switch(btnId){
			case 'btnSave' : fnSave(); //  저장
				//alert("저장버튼 클릭!!!이벤트!!");
				break;
			case 'btnDelete' : fnDelete();	// 삭제
				//alert("삭제버튼 클릭!!!이벤트!!");		
				break;
			case 'btnUpdate' : fnUpdate();  // 수정하기
				break;
			case 'searchBtn' : selectNoticeList();  // 검색하기
				break;
			case 'btnClose' : gfCloseModal();  // 모달닫기 
/* 			
			
							if($("#action").val() == "I") {
								fnSearchList();
							} else if($("#action").val() == "U") {
								fnSearchList($("#currentPage").val());
							} else if($("#action").val() == "D") {
								fnSearchList();
							}
			 */
			
				break;
				
			//case 'commentWrite' : fCommentInsert();   // 댓글--> 답변글로 변경 // 저장 
				//break;
			}
		});
	}	
	
	
	function vueinit() {
		
		searcharea = new Vue({
			                   el: "#searcharea",
			               data: {
			            	   searchSel : "",
			            	   searchText : "",
			            	   usertype: "${sessionScope.userType}",
			               }     
		});
		
		divNoticeList = new Vue({
			                  el:"#divNoticeList",
			              data: {
			            	  datalist:[],
		                     totalcnt:0,
		                     pagingnavi: "",
		                     currentPage:0,
		                     usertype: "${sessionScope.userType}",
			              } ,
			            methods : {
			            	fnSelectNotice : function(brdno) {
			            		//alert("fnSelectNotice : " + brdno);
			            		fnSelectNotice(brdno);
			            	}
			            	
			            }  
			                  
		})
		
		noticePop = new Vue({
		                    el:"#noticePop",
		                 data: {
		                	 brd_title:  "",
		                	 brd_ctt:"",
		                	 selnoticecd:"",
		                	 regdate:"",
		                	 viewcnt:"",
		                	 delflag:false,
		                	 isreadonly:false,
		                	 action:"",
		                	 usertype: "${sessionScope.userType}",
		                	 swriter:"${loginId}",
		                 }   
		})
		
		
		
	}
	
	function fnSearchList(currentPage){
		
		currentPage = currentPage || 1;   //  || = or 현재 페이지를 1로 설정
		
	//alert("현재 페이지 : " + currentPage);
		
		
		// 4-1. 각각의 변수들을 param에 넣습니다. 변수 설명은 아래 참조
    	var param = {
    			pageSize : pageSize, // 제일 위에 1에서 설정함 1페이지에 나타내야하는 게시글 숫자
    			currntPage : currentPage, // 현재 페이지는 초기 1 Ajax 통신을 통해 페이지 변경시 변하게됨
    			searchSel : searcharea.searchSel, // searchsel id에 있는 value값
    			searchText : searcharea.searchText,
    			searchDel : ""
    	}

		
    	var listCallBack = function(returnData) {
    		console.log(JSON.stringify(returnData));
    		
    		divNoticeList.datalist = returnData.listNotice;
    		divNoticeList.totalcnt = returnData.totalCnt;
    		
    		var paginationHtml = getPaginationHtml(currentPage, divNoticeList.totalcnt, pageSize, pageBlock, 'fnSearchList');
    		console.log("paginationHtml : " + paginationHtml);
    		//swal(paginationHtml);
    		divNoticeList.pagingnavi = paginationHtml;
    		
    		divNoticeList.currentPage = currentPage;
		}
		
		//5. param에 정보들을 모아모아 control에 있는 listnotice로 보내고, listcallback으로 다시 받음
    	callAjax("/notice/listNoticevue.do", "post", "json", true, param, listCallBack);
		
	}
	
    function fnOpenPopUp() {
    	
    	fnPopUpInt();
    	
		// 모달 팝업
		gfModalPop("#noticePop");
		
    }
    
	//셀렉트 모달 / 변수 적용
    function fnSelectNotice(brd_no) {
    	
    	var param = {
    			brd_no : brd_no,
    	}
    	
    	var selectCallBack = function(returnData) {
    		console.log(JSON.stringify(returnData));  
    		console.log(returnData.sectInfo);
    		fnPopUpInt(returnData.sectInfo);
    		
    		gfModalPop("#noticePop");
    	}
    	
    	callAjax("/notice/selectNotice.do", "post", "json", true, param, selectCallBack);
    	
    }
	
    //////셀렉트 모달의 실행함수 정의
    function fnPopUpInt(data) {

    	if(data == null || data == undefined || data == "") {
    		noticePop.brd_title = "";
    		noticePop.brd_ctt = "";
    		noticePop.selnoticecd = "";
    		noticePop.action = "I";  
        	
    		noticePop.regdate = "";
    		noticePop.viewcnt = "";
        	
    		noticePop.delflag = false;		
    		
    		noticePop.isreadonly = true;
    		
    		
    	}  else {
    		noticePop.brd_title = data.brd_title;
    		noticePop.brd_ctt = data.brd_ctt;    

    		noticePop.action = "U";  
        	
    		noticePop.regdate = data.brd_reg_date;
    		noticePop.viewcnt = data.brd_veiws_cnt;
        	
        	
    		noticePop.selnoticecd = data.brd_no;
        	
    		noticePop.delflag = true;
    		
    		if(noticePop.usertype != "B" &&  noticePop.usertype != "C") {
    			noticePop.isreadonly = false;
    		} else {
    			noticePop.isreadonly = true;
    		}
    	}   	

    }
    
    
	function fnSave() {
    	
    	if(!fnValidate()) { //값을 다 넣었는지??
    		return;
    	}
    	
    	var param = { //컨트롤로 넘길 정보 목록들
    			action : noticePop.action, 
    			brd_title : noticePop.brd_title,
    			brd_ctt : noticePop.brd_ctt,
    			brd_no : noticePop.selnoticecd,
    	}
    	
    	var saveCallBack = function(returnValue) {
    		console.log(JSON.stringify(returnValue));
    		
    		if(returnValue.resultMsg == "저장" || returnValue.resultMsg == "수정" || returnValue.resultMsg == "삭제") {
    			alert(returnValue.resultMsg +" 되었습니다.");
    			gfCloseModal();
    			if(noticePop.action == "I") {
    				fnSearchList();
    			} else if(noticePop.action == "U") {
    				fnSearchList(divNoticeList.currentPage);
    			} else if(noticePop.action == "D") {
    				fnSearchList(divNoticeList.currentPage);
    			}
    		}
    		
    	}
    	
    	callAjax("/notice/noticeSave.do", "post", "json", true, param, saveCallBack);
    }
	/** 저장 validation */
	function fnValidate() {

		var chk = checkNotEmpty(
				[
						[ "brd_title", "제목를 입력해 주세요." ]
					,	[ "brd_ctt", "내용을 입력해 주세요" ]				]
		);

		if (!chk) {
			return;
		}

		return true;
	}
	
    function fnDelete() {
    	noticePop.action = "D"; 
    	fnSave();
    }
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
							<span class="btn_nav bold"> 학습지원 </span> 
							<span class="btn_nav bold"> 공지사항 </span> 
							<a href="/notice/aNotice.do" class="btn_set refresh">새로고침</a>
						</p>

						<p id="searcharea" class="conTitle">
							<span>공지사항</span> 
							<span class="fr"> 	
							    <select id="searchSel" name="searchSel" v-model="searchSel">
							         <option value="">전체</option>
							         <option value="title">제목</option>
							         <option value="regname">등록자</option>
							    </select>
							    <input type="text" id="searchText" name="searchText"  v-model="searchText" style="width: 150px; height: 25px;" />
							    <a class="btnType blue" href="javascript:fnSearchList();" name="modal"><span>검색</span></a>
							    <template v-if="usertype == 'B' || usertype == 'C'">
							         <a class="btnType blue" href="javascript:fnOpenPopUp();" name="modal"><span>신규등록</span></a>
							    </template>
							</span>
						</p>
						
						<div id="divNoticeList" class="divNoticeList">
							<table class="col">
								<caption>caption</caption>
	
		                            <colgroup>
						                   <col width="10%">
						                   <col width="35%">
						                    <col width="20%">
						                    <col width="20%">
						                   <col width="15%">
					                 </colgroup>
								<thead>
									<tr>
							              <th scope="col">공지 번호</th>
							              <th scope="col">공지 제목</th>
							              <th scope="col">조회수</th>
							              <th scope="col">작성자</th>
							              <th scope="col">공지 날짜</th>
							              
									</tr>
								</thead>
								<tbody>
								      <template v-if="totalcnt == 0">
								                <tr>   <td colspan=5> 데이터가 업습니다.  </td> </tr>
								      </template> 
								      <template v-else v-for="one in datalist">
								                <tr @click="fnSelectNotice(one.brd_no)">
								                     <td>{{ one.brd_no }}</td>
						                             <td>{{ one.brd_title }}</td>
						                             <td>{{ one.brd_veiws_cnt }}</td>
						                             <td>{{ one.brd_wt }}</td>
						                             <td>{{ one.brd_reg_date }}</td>
								                </tr>
								      </template>
								</tbody>
							</table>
							
							<!-- 페이징 처리  -->
							<div class="paging_area" id="pagingnavi" v-html="pagingnavi">
							</div>
											
						</div>

		
					</div> <!--// content -->

					<h3 class="hidden">풋터 영역</h3>
						<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
				</li>
			</ul>
		</div>
	</div>


	<!--// 모달팝업 -->
	<div id="noticePop" class="layerPop layerType2" style="width: 600px;">
		<dl>
			<dt>
				<strong>공지사항 등록</strong>
			</dt>
			<dd class="content">
				<!-- s : 여기에 내용입력 -->
				<table class="row">
					<caption>caption</caption>
					<colgroup>
						<col width="120px">
						<col width="*">
						<col width="120px">
						<col width="*">
					</colgroup>

					<tbody>
						<tr>
							<th scope="row">등록 일자</th>
							<td id="regdate" v-text="regdate">
							 </td>
							<th scope="row">조회수</th>
							<td id="viewcnt" v-text="viewcnt">
							 </td>
						</tr>
						<tr>
							<th scope="row">공지 제목 <span class="font_red">*</span></th>
							<td colspan="3">
							      <input type="text" class="inputTxt p100" name="brd_title" id="brd_title"  :readonly="!isreadonly" v-model="brd_title" />
							 </td>
						</tr>
						<tr>
							<th scope="row">공지내용 <span class="font_red">*</span></th>
							<td colspan="3">
							     <textarea name="brd_ctt" id="brd_ctt"  rows="5" cols="30"  :readonly="!isreadonly" v-model="brd_ctt" ></textarea>
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
	
	


</form>

</body>
</html>
