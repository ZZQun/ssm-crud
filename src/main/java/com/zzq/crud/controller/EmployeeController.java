package com.zzq.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zzq.crud.bean.Employee;
import com.zzq.crud.bean.Msg;
import com.zzq.crud.service.EmployeeService;
/**
 * 处理员工CRUD请求
 * @author ZZQ
 *
 */
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	
	
	/**
	 * 单个或者批量删除
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{ids}",method=RequestMethod.DELETE)
	public Msg deleteEmpById(@PathVariable("ids")String ids) {
		employeeService.deleteEmpById(ids);
		return Msg.success();
	}
	
	
	
	/**
	 * Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
	 * 员工更新方法
	 * @param employee
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Msg updateEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {
			Map<String,Object> map = new HashMap<String,Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors) {
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else {
			employeeService.updateEmp(employee);
			return Msg.success();
		}
		
	}
	
	/**
	 * 根据id查询员工
	 * @param id
	 * @return
	 */
	@RequestMapping(value="/emp/{id}",method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id) {
		
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}
	
	/**
	 * 检查用户名是否可用
	 * @param empName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkUser(@RequestParam("empName")String empName) {
		return employeeService.checkUser(empName);
	}
	
	/**
	 * 员工保存
	 * 1、支持JSR303校验
	 * 2、导入Hibernate-Validator
	 * @return
	 */
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee,BindingResult result) {
		if(result.hasErrors()) {
			//校验失败，在模态框中显示错误的信息
			Map<String,Object> map = new HashMap<String,Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError : errors) {
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
		
	}
	
		
	/**
	 * 查询员工数据（分页查询）
	 * 导入jackson包
	 * @return
	 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1")Integer pn,
			Model model) {
				PageInfo<Employee> pageInfo = employeeService.getAll(pn);
				//使用PageInfo包装查询后的结果，只需要将PageInfo交给页面
				return Msg.success().add("pageInfo",pageInfo);
	}

}