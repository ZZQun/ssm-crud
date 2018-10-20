package com.zzq.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zzq.crud.bean.Employee;
import com.zzq.crud.service.EmployeeService;
/**
 * ����Ա��CRUD����
 * @author ZZQ
 *
 */
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	/**
	 * ��ѯԱ�����ݣ���ҳ��ѯ��
	 * @return
	 */
	@RequestMapping("/emps")
	public String getEmps(@RequestParam(value = "pn",defaultValue = "1")Integer pn,
			Model model) {
		//����PageHelper��ҳ���
		//�ڲ�ѯ֮ǰֻ��Ҫ����PageHelper.startPage,����ҳ�룬�Լ�ÿҳ��С
		PageHelper.startPage(pn, 5);
		//startPage��������������ѯ����һ����ҳ��ѯ
		List<Employee> emps = employeeService.getAll();
		//ʹ��PageInfo��װ��ѯ��Ľ����ֻ��Ҫ��PageInfo����ҳ��
		//��װ����ϸ�ķ�ҳ��Ϣ���������ǲ�ѯ���������ݣ�����������ʾ��ҳ��
		PageInfo page = new PageInfo(emps,5);
		model.addAttribute("pageInfo", page);
		
		return "list";
	}
}
