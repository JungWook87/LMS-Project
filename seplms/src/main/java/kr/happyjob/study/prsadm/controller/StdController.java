package kr.happyjob.study.prsadm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.happyjob.study.facadm.model.EquDtlModel;
import kr.happyjob.study.prsadm.model.InsModel;
import kr.happyjob.study.prsadm.model.StdLecModel;
import kr.happyjob.study.prsadm.model.StdModel;
import kr.happyjob.study.prsadm.service.StdService;

@Controller
@RequestMapping("/adm/")// 0. 제일처음 받아옴. 
public class StdController {
	
	@Autowired
	StdService stdService;
	
	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());

	// Get class name for logger
	private final String className = this.getClass().toString();
	
	
	
	// 처음 로딩될 때 학생내역 연결
	@RequestMapping("studentControl.do") // 0. 상위 개체 + stdControl.do // 
	public String stdControl(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {

		logger.info("+ Start " + className + ".stdControl");
		logger.info("   - paramMap : " + paramMap);
		String userType = (String) session.getAttribute("user_type"); // 유저타입 가지고 있기
		paramMap.put("userType", userType);
		String login_ID = (String) session.getAttribute("loginId"); // 로그인 세션에서 로그인 아이디 가지고 있기
		paramMap.put("login_ID", login_ID);
		System.out.println(login_ID);
//		paramMap.put("writer", loginID);
		
		return "prsadm/StdInfo";  // 0. 리턴 경로로 받아온 값들을 줌
	}
	
		// 처음 로딩될 때 학생내역 연결 Vue
		@RequestMapping("studentControlvue.do") // 0. 상위 개체 + stdControl.do // 
		public String stdControlvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
				HttpServletResponse response, HttpSession session) throws Exception {
			
			logger.info("+ Start " + className + ".stdControlvue");
			logger.info("   - paramMap : " + paramMap);
			String userType = (String) session.getAttribute("user_type"); // 유저타입 가지고 있기
			paramMap.put("userType", userType);
			String login_ID = (String) session.getAttribute("loginId"); // 로그인 세션에서 로그인 아이디 가지고 있기
			paramMap.put("login_ID", login_ID);
			System.out.println(login_ID);
			logger.info("+ End " + className + ".stdControlvue");
			
			return "prsadm/StdInfovue";  // 0. 리턴 경로로 받아온 값들을 줌
	}
	/**
	 * 학생 목록 카운트
	 */
	@RequestMapping("listStd.do") // 6. fnSearchList 함수에서 값을 받아옴
	public String listStd(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".listStd");
		logger.info("   - paramMap : " + paramMap);
		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));   
		int currntPage = Integer.parseInt((String) paramMap.get("currntPage"));   
		int startPoint = ( currntPage - 1 ) * pageSize;
		
		paramMap.put("pageSize", pageSize);
		paramMap.put("startPoint", startPoint);
		
		List<StdModel> listStd = stdService.listStd(paramMap); // 7. listStd를 서비스에서 paramMap값으로실행
		
		int totalCnt = stdService.totalCnt(paramMap); // 9. 서비스에서 실행한 토탈값 받아오기
		
		model.addAttribute("listStd", listStd);
		model.addAttribute("totalCnt", totalCnt);
		
		logger.info("+ End " + className + ".listStd");

		return "prsadm/StdList"; // 11. 이 값들을 다시 리스트 jsp로 ㄱㄱ
	}
	/**
	 * 학생 목록 카운트 Vue
	 */
	@RequestMapping("listStdvue.do") // 6. fnSearchList 함수에서 값을 받아옴
	@ResponseBody
	public Map<String, Object> listStdvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".listStdvue");
		logger.info("   - paramMap : " + paramMap);
		
		
		int pageSize = Integer.parseInt((String) paramMap.get("pageSize"));   
		int currentPage = Integer.parseInt((String) paramMap.get("currentPage"));   
		int startPoint = ( currentPage - 1 ) * pageSize;
		
		paramMap.put("pageSize", pageSize);
		paramMap.put("startPoint", startPoint);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		List<StdModel> listStd = stdService.listStd(paramMap); // 7. listStd를 서비스에서 paramMap값으로실행
		int totalCnt = stdService.totalCnt(paramMap); // 9. 서비스에서 실행한 토탈값 받아오기
		
		returnMap.put("listStd", listStd);
		returnMap.put("totalCnt", totalCnt);
		
		logger.info("+ End " + className + ".listStdvue");
		
		return returnMap; // 11. 이 값들을 다시 리스트 jsp로 ㄱㄱ
	}
	
	/**
	 * 학생 개별 조회 (팝업)
	 */
	@RequestMapping("selectStd.do")
	@ResponseBody
	public Map<String, Object> selectStd(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".selectStd");
		logger.info("   - paramMap : " + paramMap);
		
		
		StdModel	sectInfo = stdService.selectStd(paramMap);
		
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
	   returnmap.put("sectInfo", sectInfo);
		logger.info("   - paramMap : " + sectInfo);
		logger.info("+ End " + className + ".selectStd");

		return returnmap;
	}
	
	// 학생 신규등록, 업데이트
	@RequestMapping("stdSave.do")
	@ResponseBody
	public Map<String, Object> stdSave(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".stdSave");
		logger.info("   - paramMap : " + paramMap);
		
		String action = (String)paramMap.get("action");
		String resultMsg = "";
		
		
		if ("I".equals(action)) {
			// 학생 신규 저장
			stdService.insertStd(paramMap);
			resultMsg = "수정";
		} else if("U".equals(action)) {
			// 학생 수정 저장
			stdService.updateStd(paramMap);
			resultMsg = "수정";
			System.out.println(paramMap);
		}else if("D".equals(action)) {
			stdService.deleteStd(paramMap);
			resultMsg = "삭제";
		}		
		else {
			resultMsg = "FALSE : 등록에 실패하였습니다.";
		}
		
		//결과 값 전송
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("resultMsg", resultMsg);
	    
	    return resultMap;
	}
	/**
	 * 학생 수강 이력 목록 조회
	 */
	@RequestMapping("listStdLec.do")
	public String listStdLec(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".listStdLec");
		logger.info("   - paramMap : " + paramMap);
		
		
		int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
		int pageIndex = (currentPage-1)*pageSize;												// 페이지 시작 row 번호
		

		paramMap.put("pageIndex", pageIndex);
		paramMap.put("pageSize", pageSize);
		
		// 내역코드 목록 조회
		List<StdLecModel> listStdLecModel = stdService.listStdLec(paramMap);
		
		// 내역 목록 카운트 조회
		int totalCntStdLec = stdService.totalCntStdLec(paramMap);
		model.addAttribute("totalCntStdLec", totalCntStdLec);
		model.addAttribute("listStdLecModel", listStdLecModel);
		
		model.addAttribute("pageSize", pageSize);
		model.addAttribute("currentPageDtl",currentPage);
		
		logger.info("+ End " + className + ".listStdLec");

		return "/prsadm/StdLecList"; // 정보 모아모았당.. ㄱㄱ
	}
	
	/**
	 * 학생 수강 이력 목록 조회
	 */
	@RequestMapping("listStdLecvue.do")
	@ResponseBody
	public Map<String, Object> listStdLecvue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".listStdLecvue");
		logger.info("   - paramMap : " + paramMap);
		
		
		int currentPage = Integer.parseInt((String)paramMap.get("currentPage"));	// 현재 페이지 번호
		int pageSize = Integer.parseInt((String)paramMap.get("pageSize"));			// 페이지 사이즈
		int pageIndex = (currentPage-1)*pageSize;												// 페이지 시작 row 번호
		

		paramMap.put("pageIndex", pageIndex);
		paramMap.put("pageSize", pageSize);
		
		// 내역코드 목록 조회
		List<StdLecModel> listStdLec = stdService.listStdLec(paramMap);
		
		Map<String, Object> returnMap = new HashMap<String, Object>();
		// 내역 목록 카운트 조회
		int totalCntStdLec = stdService.totalCntStdLec(paramMap);
		
		//model.addAttribute("pageSize", pageSize);
		//model.addAttribute("currentPageDtl",currentPage);
		
		returnMap.put("totalCntStdLec", totalCntStdLec);
		returnMap.put("listStdLec", listStdLec);

		logger.info("+ End " + className + ".listStdLecvue");

		return returnMap; // 정보 모아모았당.. ㄱㄱ
	}	
	
	@RequestMapping("selectStdLec.do")
	@ResponseBody
	public Map<String, Object> selectLec(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request,
			HttpServletResponse response, HttpSession session) throws Exception {
		
		logger.info("+ Start " + className + ".selectLec");
		logger.info("   - paramMap : " + paramMap);
		
		
		StdLecModel	sectInfoL = stdService.selectLec(paramMap);
		
		Map<String, Object> returnmap = new HashMap<String, Object>();
		
	   returnmap.put("sectInfoL", sectInfoL);
		logger.info("   - paramMap : " + sectInfoL);
		logger.info("+ End " + className + ".selectLec");

		return returnmap;
	}
}
