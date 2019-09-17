package ino.web.freeBoard.service;

import ino.web.freeBoard.dto.FreeBoardDto;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FreeBoardService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	public List<FreeBoardDto> freeBoardList(Map<String,Object> map){
		
		return sqlSessionTemplate.selectList("freeBoardGetList", map);
	}
	
	public int freeBoardCount(Map<String,Object> map){
		return sqlSessionTemplate.selectOne("freeBoardCount", map);
	}
	
	public void freeBoardInsertPro(FreeBoardDto dto){
		sqlSessionTemplate.insert("freeBoardInsertPro",dto);
	}
	
	public FreeBoardDto getDetailByNum(int num){
		return sqlSessionTemplate.selectOne("freeBoardDetailByNum", num);
	}
	
	public int getNewNum(){
		return sqlSessionTemplate.selectOne("freeBoardNewNum");
	}
	
	public void freeBoardModify(FreeBoardDto dto){
		sqlSessionTemplate.update("freeBoardModify", dto);
	}

	public void FreeBoardDelete (int num) {
		sqlSessionTemplate.delete("freeBoardDelete", num);
		
	}
	
	public List<FreeBoardDto> freeBoardListByNum(int num){
		return sqlSessionTemplate.selectList("freeBoardSearchList", num);
	}

	public List<HashMap<String, Object>> getSearchList(HashMap<String, Object> map) {
		return sqlSessionTemplate.selectList("freeBoardGetType", map);
	}

}
