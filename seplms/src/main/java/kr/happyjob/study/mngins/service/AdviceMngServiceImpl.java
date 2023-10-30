package kr.happyjob.study.mngins.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.mngins.dao.AdviceMngDao;
import kr.happyjob.study.mngins.model.AdviceModel;

@Service
public class AdviceMngServiceImpl implements AdviceMngService {

	// Set logger
	private final Logger logger = LogManager.getLogger(this.getClass());
	
	// Get class name for logger
	private final String className = this.getClass().toString();
	
	@Autowired
	AdviceMngDao adviceMngDao;

	
	// 상담 목록
	@Override
	public List<AdviceModel> adviceList(Map<String, Object> paramMap) throws Exception {
		return adviceMngDao.adviceList(paramMap);
	}
	
	// 목록 총 개수
	@Override
	public int totalcnt(Map<String, Object> paramMap) throws Exception {
		return adviceMngDao.totalcnt(paramMap);
	}

	// 상담 등록
	@Override
	public String insertAdv(Map<String, Object> paramMap) throws Exception {
		int result = 0;
		result = adviceMngDao.insertAdv(paramMap);
		
		String msg = null;
		
		if(result != 0) msg = "저장 성공";
		else msg = "저장 실패";
		
		return msg;
	}
	
	// 상담 갱신
	@Override
	public String updateAdv(Map<String, Object> paramMap) throws Exception {

		int result = 0;
		result = adviceMngDao.updateAdv(paramMap);
		
		String msg = null;
		
		if(result != 0) msg = "갱신 성공";
		else msg = "갱신 실패";
		
		return msg;
	}
	// 상담 삭제
	@Override
	public String deleteAdv(Map<String, Object> paramMap) throws Exception {

		int result = 0;
		result = adviceMngDao.deleteAdv(paramMap);
		
		String msg = null;
		
		if(result != 0) msg = "삭제 성공";
		else msg = "삭제 실패";
		
		return msg;
	}


	@Override
	public AdviceModel selectAdv(Map<String, Object> paramMap) throws Exception {
		return adviceMngDao.selectAdv(paramMap);
	}
}
