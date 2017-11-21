package com.ifox.crud.service;

import com.ifox.crud.bean.Employee;
import com.ifox.crud.bean.EmployeeExample;
import com.ifox.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

/**
 * Created by 钟超 on 2017/10/17.
 */
@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    /***
     * 查询所有员工
     * @return
     */
    public List<Employee> getAll(){
        return  employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * 员工保存方法
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
    public Boolean checkUser(String empName){
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count =  employeeMapper.countByExample(example);
        return count==0;
    }

}

