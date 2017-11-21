<%--
  Created by IntelliJ IDEA.
  User: 钟超
  Date: 2017/10/18
  Time: 9:48
  To change this template use File | Settings | File Templates.
--%>
<%--
  Created by IntelliJ IDEA.
  User: 钟超
  Date: 2017/10/17
  Time: 18:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet" type="text/css">
</head>
<body>
<!--模态框-->
<div class="model fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" >
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@qq.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId"></select>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>
<!--搭建页面-->
<div class="container">
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6" id="page_info_area">
            当前页,
            总页,
            总记录条数
        </div>
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>
</div>
<script type="text/javascript">
    //1.页面加载完成之后，直接去发送一个ajax请求，要到分页数据
    var totalRecord;
    $(function () {
        to_page(1);
    });
    function to_page(pn) {
        $(function () {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn="+pn,
                type:"GET",
                success:function (result) {
                    //1.解析显示员工数据
                    build_emps_table(result);
                    //2.解析并显示分页信息
                    build_page_info(result);
                    //3.解析显示分页条信息
                    build_page_nav(result);
                }
            });
        });
    }

    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptName = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn_sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn_sm")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            $("<tr></tr>").append(empIdTd)
                .append(empNameTd).append(genderTd)
                .append(emailTd).append(deptName)
                .append(btnTd).appendTo("#emps_table tdody");
        })
    }
    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页,总"+result.extend.pageInfo.pages+"页," +
            "总"+result.extend.pageInfo.total+"记录条数");
        totalRecord = result.extend.pageInfo.total;
    }
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else {
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum -1);
            });
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if (result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum +1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }

        ul.append(firstPageLi).append(prePageLi);
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item){
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            })
            ul.append(numLi);
        });
        ul.append(nextPageLi).append(lastPageLi);
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }
    //点击新增按钮弹出模态框
    $("#emp_add_modal_btn").click(function () {
        //清除表单数据(表单重置)
        $("#empAddModel form")[0].reset();
        //发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts();
        //弹出模态框
        $("#empAddModel").modal({
            backdrop:"static"
        });
    });
    //查出部门信息，显示在下拉列表中
    function getDepts() {
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result) {
                //  console.log(result);
                //  $("#empAddModel select").append();
                $.each(result.extend.depts, function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                    optionEle.appendTo("#empeAddModel select    ");
                });
            }
        });
    }
    //校验表单数据
    function validate_add_form(){
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            //alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
            show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
            return false;
        }else {
            show_validate_msg("#empName_add_input","success","")
        }
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            //    alert("邮箱格式不正确");
            show_validate_msg("#email_add_input","error","邮箱格式不正确");
//            $("#email_add_input").parent().addClass("has-error");
//            $("#email_add_input").next("span").text("邮箱格式不正确");
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
//            $("#email_add_input").parent().addClass("has-success");
//            $("#email_add_input").next("span").text();
        }
        return true;
    }
    //显示当前校验结果信息
    function show_validate_msg(ele,status,msg) {
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error"==status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }
    $("#empName_add_input").change(function () {
        var empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if (result.code == 100) {
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    $("#emp_save_btn").attr("ajax-va","success");
                } else {
                    show_validate_msg("#empName_add_input","error",result.extend.va-msg);
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        })
    });
    //点击保存
    $("emp_save_btn").click(function () {
        //模态框中填写的数据提交给服务器进行保存
        //应该先对要提交的服务器的数据进行校验
        if (!validate_add_form()){
            return false;
        };
        //判断之前的ajax用户名的校验是否可用
        if ($(this).attr("ajax-va")=="error"){
            return false;
        }
        //发送ajax请求保存员工
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            data:$("#empAddModel form").serialize(),
            success:function (result) {
                //员工保存成功,关闭模态框
                $("#empAddModel").modal("hide");
                //来到最后一个页，显示刚才保存的数据
                to_page(totalRecord);
            }
        });
    });
</script>
<script src="static/js/jquery-1.7.2.js" type="text/javascript"></script>
<script type="text/javascript" src="static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</body>
</html>
