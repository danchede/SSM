package com.ifox.crud.test;

import com.ifox.crud.bean.Employee;
import com.ifox.crud.dao.DepartmentMapper;
import com.ifox.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * Created by 钟超 on 2017/10/16.
 * 测试dao层的工作
 * 推荐Spring的项目就可以使用Spring的单元测试类，可以自动注入需要我们需要的组件
 * 1.导入SpringTest模块
 * 2.@ContextConfiguration指定配置文件的位置
 * 3.直接@Autowired要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;
    @Autowired
    EmployeeMapper employeeMapper;
    @Autowired
    SqlSession sqlSession;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD(){
//        //1.创建SpringIOC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//        //2.从容器中获取mapper
//        DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
        System.out.println(departmentMapper);
        //插入几个部门
//          departmentMapper.insertSelective(new Department(null,"开发部"));
//          departmentMapper.insertSelective(new Department(null,"测试部"));
        //生成员工数据，测试员工插入
        //        employeeMapper.insertSelective(new Employee(null,"钟超","F","钟超@qq.com",1));
        //批量多个员工，使用可以执行批量操作的sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i=0;i<10;i++){
            String uid = UUID.randomUUID().toString().substring(0,5)+i;
            mapper.insertSelective(new Employee(null,uid,"M",uid+"@qq.com",1));
            System.out.println("批量完成！！");
        }
    }
}
















