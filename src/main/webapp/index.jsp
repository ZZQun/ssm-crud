<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>员工信息</title>
<%
	pageContext.setAttribute("APP_PATH",request.getContextPath());
%>

<!--  web路径 
不以/开始的相对路径，找资源，以当前资源的路径为基准，容易出问题
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)，需要叫上项目名
 -->
<script type="text/javascript " src = "${APP_PATH}/static/js/jquery.min.js"></script>
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAndModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">新增员工</h4>
      </div>
      <div class="modal-body">
      <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">姓名</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="请输入姓名">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">邮箱</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="请输入邮箱">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">性别</label>
			    <label class="radio-inline">
				  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
				</label>
				<label class="radio-inline">
				  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
				</label>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">部门</label>
			    <div class="col-sm-4">
			      <!-- 部门提交部门id即可 -->
			      <select class="form-control" name="dId" id="dept_add_select">
			      </select>
			    </div>
			  </div>
			  
			  
	  </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="emp_sava_btn">保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      </div>
    </div>
  </div>
</div>


	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_model_btn">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				
				<table class="table table-hover" id="emps_tables">
					<thead>
						<tr>
							<th>编号</th>
							<th>姓名</th>
							<th>性别</th>
							<th>邮箱</th>
							<th>部门</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					
					
					</tbody>
				</table>
				
			</div>
		</div>
		<!-- 显示分页信息 -->
		<div class="row">
			<!-- 分页信息 -->
			<div class="col-md-6" id="page_info_area">				
			</div>
			<!-- 分页条 -->
			<div class="col-md-6" id="page_nav_area">
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var totalRecord;
	
		//1、页面加载完成以后，直接去发送一个ajax请求，要到分页数据
		$(function() {
			to_page(1);
		});
		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"GET",
				success:function(result){
					//console.log(result);
					//1、在页面解析并显示员工数据
					build_emps_table(result);
					//2、解析并解释分页信息
					build_page_info(result);
					//3、解析显示分页条数据
					build_page_nav(result);
				}
			});
		}
		
		function build_emps_table(result){
			//先清空
			$("#emps_tables tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps,function(index,item){
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(item.gender == 'M'?"男":"女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.department.deptName);
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
								.append("编辑");
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash"))
								.append("删除");
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				//append方法执行完后以后还是返回原来元素
				$("<tr></tr>").append(empIdTd)
				.append(empNameTd)
				.append(genderTd)
				.append(emailTd)
				.append(deptNameTd)
				.append(btnTd)
				.appendTo("#emps_tables tbody");
			});
		}
		function build_page_info(result){
			//先清空
			$("#page_info_area").empty();
			$("#page_info_area").append("当前第" + result.extend.pageInfo.pageNum + "页，共" 
							+ result.extend.pageInfo.pages + "页，共" 
							+ result.extend.pageInfo.total + "条记录。");
			totalRecord = result.extend.pageInfo.total;
		}
		function build_page_nav(result){
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			
			//构建元素
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prepageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prepageLi.addClass("disabled");
			}else{
				//为元素添加点击事件
				firstPageLi.click(function(){
						to_page(1);
					});
				prepageLi.click(function(){
						to_page(result.extend.pageInfo.pageNum - 1);
					});
			}
			
			//构建元素
			var nextpageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			if(result.extend.pageInfo.hasNextPage == false){
				nextpageLi.addClass("disabled");
				lastPageLi.addClass("disabled");
			}else{
				//为元素添加点击事件
				nextpageLi.click(function(){
						to_page(result.extend.pageInfo.pageNum + 1);
					});
				lastPageLi.click(function(){
						to_page(result.extend.pageInfo.pages);
					});
			}
			
				
			ul.append(firstPageLi).append(prepageLi);
			$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if(result.extend.pageInfo.pageNum == item){
					numLi.addClass("active");
				}
				numLi.click(function(){
					to_page(item);
				});
				ul.append(numLi);
			});
			ul.append(nextpageLi).append(lastPageLi);
			
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
		
		//点击新增按钮弹出模态框
		$("#emp_add_model_btn").click(function(){
			//清除表单数据
			$("#empAndModel form")[0].reset();
			//发出ajax请求，查出部门信息，显示在下拉列表
			getDepts();
			
			//弹出模态框
			$('#empAndModel').modal({
				backdrop:"static"
			});
		});		
		//查出所有部门信息，并显示在下拉列表
		function getDepts(){
			$("#dept_add_select").empty();
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					//$("#dept_add_select").append()
					$.each(result.extend.depts,function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
						optionEle.appendTo("#dept_add_select");
					});
				}
			});
		}
		
		//校验表单数据
		function validate_add_form(){
			//1、拿到要检验的数据，使用正则表达式
			var empName = $("#empName_add_input").val();
       		var regName =  /(^[\u4e00-\u9fa5]{2,5}$)|(^[a-zA-Z]{3,16}$)/;
			if(!regName.test(empName)){
				//alert("姓名错误，姓名可以是2-5位中文或者3-16位英文！");
				show_validate_msg("#empName_add_input","error","姓名错误，姓名可以是2-5位中文或者3-16位英文！");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
			}
			//2、校验邮箱信息
			var email = $("#email_add_input").val();
        	var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式不正确！");
				show_validate_msg("#email_add_input","error","邮箱格式不正确！");
				return false;
			}else{
				show_validate_msg("#email_add_input","success","");
			}
			
			return true;
		}
		
		//显示校验结果的提示信息
		function show_validate_msg(ele,status,msg){
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");
			$(ele).next("span").text("");
			
			if(status == "success"){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if(status == "error"){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		
		/* $("#empName_add_input").change(function(){
			//发送ajax请求校验用户名是否可用
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"empName=" + empName,
				type:"POST",
				success:function(result){
					if(result.code == 100){
						show_validate_msg("#empName_add_input","success","");
						$("#emp_sava_btn").attr("ajax-va","success");
					}else{
						show_validate_msg("#empName_add_input","error","姓名已存在！");
						$("#emp_sava_btn").attr("ajax-va","error");
					}
				}
			});
		}); */
		
		function checkUser(){
			var empName = $("#empName_add_input").val();
			$.ajax({
				url:"${APP_PATH}/checkuser",
				data:"empName=" + empName,
				type:"POST",
				success:function(result){
					if(result.code == 100){
						return true;
					}else{
						show_validate_msg("#empName_add_input","error","姓名已存在！");
						return false;
					}
				}
			});
		}
		
		//点击保存，保存员工
		$("#emp_sava_btn").click(function(){
			//模框中填写的表单数据提交给服务器进行保存
			//1、先对要提交给服务器的数据进行校验
			if(!validate_add_form()){
				return false;
			}
			//1.1、判断姓名重复
			if(!checkUser()){
				return false;
			}
			
			//2、发送ajax请求保存员工			
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#empAndModel form").serialize(),
				success:function(result){
					//alert(result.msg);
					//员工保存成功
					//1、关闭模态框
					$("#empAndModel").modal('hide');
					//2、来到最后一页，显示刚才保存的数据
					//发送ajax请求显示最后一页数据
					to_page(totalRecord);
				}
			});
		});
		
		
		
	</script>

</body>
</html>