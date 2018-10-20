package com.zzq.crud.test;

import javax.swing.Spring;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.zzq.crud.dao.DepartmentMapper;

/**
 * ����dao��Ĺ���
 * @author ZZQ
 *�Ƽ�Spring����Ŀ����ʹ��Spring�ĵ�Ԫ���ԣ������Զ�ע��������Ҫ�����
 *1������SpringTestģ��
 *2��@ContextConfigurationָ��spring�����ļ���λ��
 *3��ֱ��autowiredҪʹ�õ����
 */

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations= {"classpath:applicationContext.xml"})
public class MapperTest {
	
	@Autowired
	DepartmentMapper departmentMapper;

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
	}

}