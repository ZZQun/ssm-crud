package com.zzq.crud.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zzq.crud.bean.Employee;
import com.zzq.crud.bean.EmployeeExample;
import com.zzq.crud.bean.Msg;
import com.zzq.crud.bean.EmployeeExample.Criteria;
import com.zzq.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {
	
	@Autowired
	EmployeeMapper employeeMapper;

	/**
	 * 查询所有员工
	 * @return
	 */
	public PageInfo<Employee> getAll(Integer pageNum) {
		//引入PageHelper分页插件
		//在查询之前只需要调用PageHelper.startPage,传入页码，以及每页大小
		PageHelper.startPage(pageNum, 5);
		//封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
		EmployeeExample example = new EmployeeExample();
		example.setOrderByClause("emp_id");
		List<Employee> emps = employeeMapper.selectByExampleWithDept(example);
		return new PageInfo(emps,5);
	}

	/**
	 * 员工保存方法
	 * return  true-当前姓名可用  false-不可用
	 * @param employee
	 */
	public void saveEmp(Employee employee) {
		employeeMapper.insertSelective(employee);
	}
	
	/**
	 * 检验用户名是否可用
	 * @param empName
	 * @return
	 */
	public Msg checkUser(String empName) {
	//先判断用户名是否是合法的表达式
		String regx = "(^[\\u4e00-\\u9fa5]{2,5}$)|(^[a-zA-Z]{3,16}$)";
		if(!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "姓名错误，姓名必须是2-5位中文或者3-16位英文！");
		}
		
		//数据库用户名重复校验
		boolean b = checkUserRepetition(empName);
		if(b) {
			return Msg.success();
		}else {
			return Msg.fail().add("va_msg", "姓名已存在！");
		}
	}
	public boolean checkUserRepetition(String empName) {
		
		EmployeeExample example = new EmployeeExample();
		Criteria createCriteria = example.createCriteria();
		createCriteria.andEmpNameEqualTo(empName);
		long count = employeeMapper.countByExample(example);
		return count == 0;
	}

	/**
	 * 按照员工id查询员工信息
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id) {
		Employee employee = employeeMapper.selectByPrimaryKey(id);
		return employee;
	}

	/**
	 * 员工更新
	 * @param employee
	 */
	public void updateEmp(Employee employee) {
		employeeMapper.updateByPrimaryKeySelective(employee);
	}

	/**
	 * 员工根据id删除
	 * @param id
	 */
	public void deleteEmpById(String ids) {
		if(ids.contains("-")) {
			List<Integer> id_list = new ArrayList<>();
			String[] str_ids = ids.split("-");
			for(String string : str_ids) {
				id_list.add(Integer.parseInt(string));				
			}
			deleteBatch(id_list);
		}else {
			Integer id = Integer.parseInt(ids);
			deleteEmp(id);
		}
	}
	public void deleteEmp(Integer id) {
		employeeMapper.deleteByPrimaryKey(id);
	}
	public void deleteBatch(List<Integer> ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		//删除的emp_id在ids集合里
		criteria.andEmpIdIn(ids);
		employeeMapper.deleteByExample(example);
	}



}