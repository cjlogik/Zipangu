package com.syuusyoku.zipangu.dao;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Locale;
import javax.servlet.http.HttpSession;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.multipart.MultipartFile;
import com.syuusyoku.zipangu.vo.InterviewResultVO;
import com.syuusyoku.zipangu.vo.InterviewVO;
import com.syuusyoku.zipangu.vo.QuestionVO;

@Controller
public class InterviewDAO {
	
	@Autowired
	private SqlSession sqlSession;

	//질문 리스트
	public ArrayList<QuestionVO> selectList(){
		ArrayList<QuestionVO> list = null;
		try {
			InterviewMapper mapper = sqlSession.getMapper(InterviewMapper.class);
			list = mapper.selectList();
			
			Collections.shuffle(list);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	//모의 면접 시작시 interview DB에 저장
	public int startInterview(InterviewVO vo, HttpSession session){
		String userID = (String)session.getAttribute("userID");
		vo.setUserID(userID);

		try {
			InterviewMapper mapper = sqlSession.getMapper(InterviewMapper.class);
			mapper.startInterview(vo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vo.getInterview_num();
	}
	
	//음성파일 저장
	public String convert(MultipartFile blob) {
		//파일명
		long systemTime = System.currentTimeMillis();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmssSS", Locale.KOREA);
		String dTime = formatter.format(systemTime);

		File original = new File("C:/Zipangu/interview/blob");
		File change = new File("C:/Zipangu/interview/"+dTime+".wav");
		Path filepath = Paths.get("C:/Zipangu/interview/",blob.getOriginalFilename());
		
		try(
			OutputStream os = Files.newOutputStream(filepath)){
				os.write(blob.getBytes());
		} catch (IOException e) {
			e.printStackTrace();
		}
	    if (!original.renameTo(change)) {
	        System.err.println("이름 변경 에러 : " + original);
	      }
	    return dTime;
	}
	
	//모의 면접 결과 저장 
	public int insertInterview(InterviewResultVO vo){
		int result = 0;
		
		try {
			InterviewMapper mapper = sqlSession.getMapper(InterviewMapper.class);
			result = mapper.insertInterview(vo);
		} catch (Exception e) {
		e.printStackTrace();
		}
		return result;
	}

	//결과 전체 표시
	public ArrayList<InterviewResultVO> resultList(InterviewResultVO vo, HttpSession session){
		String userID = (String)session.getAttribute("userID");
		vo.setUserID(userID);
		
		ArrayList<InterviewResultVO> list = null;
		try {
			InterviewMapper mapper = sqlSession.getMapper(InterviewMapper.class);
			list = mapper.resultList(vo);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
}
