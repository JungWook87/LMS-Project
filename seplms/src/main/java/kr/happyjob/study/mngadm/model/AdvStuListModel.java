package kr.happyjob.study.mngadm.model;

public class AdvStuListModel {


	

	// tb_consulting
	private int cst_no;			//상담번호			
	private int lec_cd;			//강의코드			
	private String cst_date;	//상담일자	
	private String std_id;	// 학생ID
	private String ins_id;	// 강사ID
	// tb_userinfo
	private String std_nm; 	//학생명
	private String ins_nm; 	//강사명
	// tb_lec
	private String lec_nm;		//수강강의명
	
	private String loginID; 	//강사명
	
	private String cls_room; 	//강의실
	
	private String cst_update_date; 	//수정일자

	private String cst_ctt; 	//상담내용
	
	public String getCst_ctt() {
		return cst_ctt;
	}

	public void setCst_ctt(String cst_ctt) {
		this.cst_ctt = cst_ctt;
	}

	public String getCls_room() {
		return cls_room;
	}

	public void setCls_room(String cls_room) {
		this.cls_room = cls_room;
	}

	public String getCst_update_date() {
		return cst_update_date;
	}

	public void setCst_update_date(String cst_update_date) {
		this.cst_update_date = cst_update_date;
	}

	public int getCst_no() {
		return cst_no;
	}

	public void setCst_no(int cst_no) {
		this.cst_no = cst_no;
	}

	public int getLec_cd() {
		return lec_cd;
	}

	public void setLec_cd(int lec_cd) {
		this.lec_cd = lec_cd;
	}

	public String getCst_date() {
		return cst_date;
	}

	public void setCst_date(String cst_date) {
		this.cst_date = cst_date;
	}

	public String getStd_id() {
		return std_id;
	}

	public void setStd_id(String std_id) {
		this.std_id = std_id;
	}

	public String getIns_id() {
		return ins_id;
	}

	public void setIns_id(String ins_id) {
		this.ins_id = ins_id;
	}

	public String getStd_nm() {
		return std_nm;
	}

	public void setStd_nm(String std_nm) {
		this.std_nm = std_nm;
	}

	public String getIns_nm() {
		return ins_nm;
	}

	public void setIns_nm(String ins_nm) {
		this.ins_nm = ins_nm;
	}

	public String getLec_nm() {
		return lec_nm;
	}

	public void setLec_nm(String lec_nm) {
		this.lec_nm = lec_nm;
	}

	public String getLoginID() {
		return loginID;
	}

	public void setLoginID(String loginID) {
		this.loginID = loginID;
	}

	
}
