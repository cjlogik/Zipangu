package com.syuusyoku.zipangu.vo;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class Sender_MsgVO {
	private String msg_num;
	private String userID;
	private String userName;
	private LocalDateTime send_Time;
	private String content;
}