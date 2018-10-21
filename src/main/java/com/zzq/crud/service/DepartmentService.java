package com.zzq.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zzq.crud.bean.Department;
import com.zzq.crud.dao.DepartmentMapper;

@Service
public class DepartmentService {
	
	@Autowired
	private DepartmentMapper depatmentMapper;
	
	public List<Department> getDepts() {
		//查出的所有部门信息
		List<Department> list = depatmentMapper.selectByExample(null);
		return list;
	}

}
