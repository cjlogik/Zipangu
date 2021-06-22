package com.syuusyoku.zipangu.vo;

import lombok.Data;

@Data
public class CompanyVO {
	private int company_num;
	private String userID;
	private String coname;
	private String type;
	private String location;
	private String contact;
	private int count;
}