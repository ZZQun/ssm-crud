package com.zzq.crud.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zzq.crud.bean.Department;
import com.zzq.crud.bean.DepartmentExample;
import com.zzq.crud.bean.EmployeeExample;
import com.zzq.crud.bean.DepartmentExample.Criteria;
import com.zzq.crud.bean.Msg;
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

	/**
	 * 查询部门信息
	 * @param pn
	 * @return
	 */
	public PageInfo<Department> getAll(Integer pageNum) {
		PageHelper.startPage(pageNum, 5);
		DepartmentExample example = new DepartmentExample();
		example.setOrderByClause("dept_id");
		List<Department> depts = depatmentMapper.selectByExample(example);
		return new PageInfo(depts,5);
	}

	public void saveDept(Department department) {
		depatmentMapper.insert(department);
	}
	
	/**
	 * 判断部门是否重复
	 */
	public Msg checkDeptRepetition(String deptName) {
		DepartmentExample example = new DepartmentExample();
		Criteria createCriteria = example.createCriteria();
		createCriteria.andDeptNameEqualTo(deptName);
		long count = depatmentMapper.countByExample(example);
		if(count == 0) {
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "部门名字重复！");
		}		
	}

	public void deleteDeptById(String ids) {
		if(ids.contains("-")) {
			List<Integer> id_list = new ArrayList<Integer>();
			String[] str_ids = ids.split("-");
			for(String string : str_ids) {
				id_list.add(Integer.parseInt(string));				
			}
			deleteBatch(id_list);
		}else {
			Integer id = Integer.parseInt(ids);
			deleteDept(id);
		}
	}

	public void deleteDept(Integer id) {
		depatmentMapper.deleteByPrimaryKey(id);
	}
	public void deleteBatch(List<Integer> ids) {
		DepartmentExample example = new DepartmentExample();
		Criteria criteria = example.createCriteria();
		//删除的emp_id在ids集合里
		criteria.andDeptIdIn(ids);
		depatmentMapper.deleteByExample(example);
	}

}
