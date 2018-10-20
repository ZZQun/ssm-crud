package com.zzq.crud.test;

import java.util.UUID;

import javax.swing.Spring;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.zzq.crud.bean.Department;
import com.zzq.crud.bean.Employee;
import com.zzq.crud.dao.DepartmentMapper;
import com.zzq.crud.dao.EmployeeMapper;

/**
 * ����dao��Ĺ���
 * @author ZZQ
 *�Ƽ�Spring����Ŀ����ʹ��Spring�ĵ�Ԫ���ԣ������Զ�ע��������Ҫ�����
 *1������SpringTestģ��
 *2��@ContextConfigurationָ��spring�����ļ���λ��
 *3��ֱ��autowiredҪʹ�õ����
 */

 
public class MapperTest {
	
	@Autowired
	DepartmentMapper departmentMapper;
	@Autowired
	EmployeeMapper employeeMapper;
	@Autowired
	SqlSession sqlSession;
	/**
	 * ����DepartmentMapper
	 */
	@Test
	public void testCRUD() {
		//1.����SpringIOC����
//		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
		//2.�������л�ȡmapper
//		DepartmentMapper bean =  ioc.getBean(DepartmentMapper.class);
		System.out.println(departmentMapper);
		
		//1.���뼸������		
//		departmentMapper.insertSelective(new Department(null,"������"));
//		departmentMapper.insertSelective(new Department(null,"���Բ�"));
		
		//2.����Ա�����ݣ�����Ա������
//		employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "845211164@qq.com", 1));
		
		//3.����������Ա��������ʹ��ִ������������sqlSession
//		for() {
//			employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "845211164@qq.com", 1));
//		}
//		EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
//		for(int i = 0;i < 1000;i++) {
//			String uuid = UUID.randomUUID().toString().substring(0, 5);
//			mapper.insertSelective(new Employee(null, uuid, "M", uuid+"@qq.com", 1));
//		}
//		System.out.println("finish");
	}

}