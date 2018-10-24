package com.zzq.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.zzq.crud.bean.Department;
import com.zzq.crud.bean.Msg;
import com.zzq.crud.service.DepartmentService;

/**
 * 处理和部门有关的请求
 * @author ZZQ
 *
 */
@Controller
public class DepartmentController {

	@Autowired
	private DepartmentService departmentService;
	
	/**
	 * 部门查询
	 * 分页
	 * @param pn
	 * @param model
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/Depts")
	public Msg getDeptsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn,
			Model model) {
		PageInfo<Department> pageInfo = departmentService.getAll(pn);
		return Msg.success().add("pageInfo", pageInfo);
	}
	
	/**
	 * 返回所有部门的信息
	 */
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDept() {
		List<Department> list = departmentService.getDepts();
		return Msg.success().add("depts", list);
	}
	
	/**
	 * 保存部门
	 */
	@RequestMapping(value="/dept",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveDept(Department department) {
		if(departmentService.checkDeptRepetition(department.getDeptName()).getCode() == 200) {
			return departmentService.checkDeptRepetition(department.getDeptName());
		}else {
			departmentService.saveDept(department);
			return Msg.success();
		}
	}
	
	/**
	 * 检查部门名是否重复
	 */
	@ResponseBody
	@RequestMapping(value="/checkDept")
	public Msg checkDept(@RequestParam("deptName")String deptName) {
		return departmentService.checkDeptRepetition(deptName);
	}
	
	/**
	 * 删除员工
	 */
	@ResponseBody
	@RequestMapping(value="/dept/{ids}",method=RequestMethod.DELETE)
	public Msg deleteDept(@PathVariable("ids")String ids) {
		departmentService.deleteDeptById(ids);
		return Msg.success();
	}
	
}
