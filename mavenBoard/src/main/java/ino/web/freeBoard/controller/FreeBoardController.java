package ino.web.freeBoard.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.swing.plaf.synth.SynthSplitPaneUI;

import org.json.simple.JSONObject;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import ino.web.freeBoard.common.util.pageUtil;
import ino.web.freeBoard.dto.FreeBoardDto;
import ino.web.freeBoard.service.FreeBoardService;

@Controller
public class FreeBoardController {
	
	@Autowired
	private FreeBoardService freeBoardService;
	
	@RequestMapping("/main.ino")
	public ModelAndView main(HttpServletRequest request, 
			@RequestParam(value="searchType", defaultValue="")String searchType,
			@RequestParam(value="searchWord", defaultValue="")String searchWord,
			@RequestParam(value="searchD1", defaultValue="")String searchD1,
			@RequestParam(value="searchD2", defaultValue="")String searchD2,
			@RequestParam(defaultValue="1") int curPage
			){
		
		ModelAndView mav = new ModelAndView();	
		HashMap<String, Object> map = new HashMap<>();
		map.put("searchD1", searchD1);
		map.put("searchD2", searchD2);
		/*사실 이렇게하면 안되고 서버로 보낼때, 아니면 서버에서 받을때 String 문자열로 합쳐서 받아야한다*/
		map.put("searchWord", searchWord);
		map.put("searchType", searchType);
		/*map.put("code", "COM001");*/
		if (!searchD1.isEmpty() || !searchD2.isEmpty()) {
			map.put("searchType", "DCODE003");
		}
		pageUtil pageUtil = new pageUtil(freeBoardService.freeBoardCount(map), curPage);
		map.put("startPage", pageUtil.getPageBegin());
		map.put("endPage", pageUtil.getPageEnd());
		/*날짜를 담는다*/
		/*selected 시키기위해*/
		/*맵에 까득담자*/
		 
		/*메인 호출시 searchDate 가 공백이되서 지나감*/
		
		List<HashMap<String,Object>> sList = freeBoardService.getSearchList(map);
		map.put("sList",sList);
		List<FreeBoardDto> list = freeBoardService.freeBoardList(map);
		map.put("freeBoardList", list);	
		map.put("pageUtil",pageUtil);
		/*모델 앤 뷰*/
		mav.addObject("freeBoard", map);
		
		mav.setViewName("boardMain");
		
		/*System.out.println("sList = " + sList);*/
		return mav;
	}
	
	@RequestMapping(value="/main2.ino", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> main2(@RequestParam(defaultValue="")String searchType,
			@RequestParam(defaultValue="")String searchWord,
			@RequestParam(defaultValue="")String searchD1,
			@RequestParam(defaultValue="")String searchD2,
			@RequestParam(defaultValue="1")int curPage){
		
		HashMap<String,Object> map = new HashMap<>();
		map.put("searchType", searchType);
		map.put("searchWord", searchWord);
		map.put("searchD1", searchD1);
		map.put("searchD2", searchD2);
		
		if (!searchD1.isEmpty() || !searchD2.isEmpty()) {
			map.put("searchType", "DCODE003");
		}
		
		pageUtil pageUtil = new pageUtil(freeBoardService.freeBoardCount(map),curPage);
		map.put("startPage", pageUtil.getPageBegin());
		map.put("endPage", pageUtil.getPageEnd());

		List<HashMap<String,Object>> sList = freeBoardService.getSearchList(map);
		map.put("sList",sList);
		List<FreeBoardDto> list = freeBoardService.freeBoardList(map);
		map.put("freeBoardList", list);	
		map.put("pageUtil",pageUtil);

		return map;
	}
		
	@RequestMapping("/freeBoardInsert.ino")
	public String freeBoardInsert(){
		//String 메서드에서 return "...";  ... < 페이지로(뷰) 바로 리턴
		return "freeBoardInsert";
	}
	
	@RequestMapping("/freeBoardInsertPro.ino")
	public String freeBoardInsertPro(HttpServletRequest request, FreeBoardDto dto){
		freeBoardService.freeBoardInsertPro(dto);
		//위 spl 수행 후 페이지 리턴 
		return "redirect:/main.ino";
		
	}
	//화면애서서버로 입력값을 주기전에 유용한 값인지확인부터 해야한다
	//화면에 제목,이름이 빈값인지 체크하는 로직이 필요함.
	//j쿼리, 스크립트든 아무렇게.
	//빈값일시, 알람 
	//입력이(2) 되었을시 저장완료
	@RequestMapping("/freeBoardDetail.ino")
	public ModelAndView freeBoardDetail(HttpServletRequest request, int num){
		FreeBoardDto board = freeBoardService.getDetailByNum(num);
		return new ModelAndView("freeBoardDetail", "freeBoardDto", board);
		
	}
	
	@RequestMapping("/freeBoardModify.ino")
	public String freeBoardModify(HttpServletRequest request, FreeBoardDto dto){
		freeBoardService.freeBoardModify(dto);
		return "redirect:/main.ino";
	}
	
		
	@RequestMapping("/freeBoardDelete.ino")
	public String FreeBoardDelete(int num){
		freeBoardService.FreeBoardDelete(num);
		return "redirect:/main.ino";
	}
}