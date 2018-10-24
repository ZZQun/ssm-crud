<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>部门信息</title>
<%
	pageContext.setAttribute("APP_PATH",request.getContextPath());
	pageContext.setAttribute("DEPT_PATH",request.getRequestURI());
%>
<script type="text/javascript " src = "${APP_PATH}/static/js/jquery.min.js"></script>
<link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
</head>
<body>
<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>部门信息</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="dept_add_model_btn">新增</button>
				<button class="btn btn-danger" id="dept_delete_all_btn">删除</button>
				<button class="btn btn-info" id="emp_jump_btn">员工列表</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="depts_tables">
					<thead>
						<tr>
							<th>
								<input type="checkbox" id="check_all"/>
							</th>
							<th>编号</th>
							<th>部门名字</th>
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
	
<!-- 部门添加的模态框 -->
<div class="modal fade" id="deptAndModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">部门新增</h4>
      </div>
      <div class="modal-body">
      <form class="form-horizontal">
		  <div class="form-group">
		    <label class="col-sm-2 control-label">部门名字</label>
		    <div class="col-sm-10">
		      <input type="text" name="deptName" class="form-control" id="deptName_add_input" placeholder="请输入部门名字">
		      <span class="help-block"></span>
		    </div>
		  </div>			  
	  </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="dept_sava_btn">保存</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
      </div>
    </div>
  </div>
</div>
	
	<script type="text/javascript">
	var totalRecord,currentPage;
	//跳转员工信息按钮
	$("#emp_jump_btn").click(function(){
		window.location.href='${APP_PATH}/';
	});
	
	$(function(){
		to_dept_page(1);
	});
	
	function to_dept_page(pn){
		$.ajax({
			url:"${APP_PATH}/Depts",
			data:"pn="+pn,
			type:"GET",
			success:function(result){
				//console.log(result);
				build_depts_table(result);
				//2、解析并解释分页信息
				build_page_info(result);
				//3、解析显示分页条数据
				build_page_nav(result);
			}
		});
	} 
	
	function build_depts_table(result){
		//先清空
		$("#depts_tables tbody").empty();
		var emps = result.extend.pageInfo.list;
		$.each(emps,function(index,item){
			var checkBox = $("<td><input type='checkbox' class='check_item'/></td>");
			var deptIdTd = $("<td></td>").append(item.deptId);
			var deptNameTd = $("<td></td>").append(item.deptName);
			var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
							.append($("<span></span>").addClass("glyphicon glyphicon-trash"))
							.append("删除");
			//为删除按钮添加一个自定义的属性，来表示当前员工id
			delBtn.attr("delete-id",item.deptId);
			var btnTd = $("<td></td>").append(delBtn);
			//append方法执行完后以后还是返回原来元素
			$("<tr></tr>").append(checkBox)
			.append(deptIdTd)
			.append(deptNameTd)
			.append(btnTd)
			.appendTo("#depts_tables tbody");
		});
	}
	function build_page_info(result){
		//先清空
		$("#page_info_area").empty();
		$("#page_info_area").append("当前第" + result.extend.pageInfo.pageNum + "页，共" 
						+ result.extend.pageInfo.pages + "页，共" 
						+ result.extend.pageInfo.total + "条记录。");
		totalRecord = result.extend.pageInfo.total;
		currentPage = result.extend.pageInfo.pageNum;
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
				to_dept_page(result.extend.pageInfo.pageNum + 1);
				});
			lastPageLi.click(function(){
				to_dept_page(result.extend.pageInfo.pages);
				});
		}
		
			
		ul.append(firstPageLi).append(prepageLi);
		$.each(result.extend.pageInfo.navigatepageNums,function(index,item){
			var numLi = $("<li></li>").append($("<a></a>").append(item));
			if(result.extend.pageInfo.pageNum == item){
				numLi.addClass("active");
			}
			numLi.click(function(){
				to_dept_page(item);
			});
			ul.append(numLi);
		});
		ul.append(nextpageLi).append(lastPageLi);
		
		var navEle = $("<nav></nav>").append(ul);
		navEle.appendTo("#page_nav_area");
	}
	
	//重置表单
    function reset_form(ele){
        $(ele)[0].reset();
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }
	
  //点击新增按钮弹出模态框
	$("#dept_add_model_btn").click(function(){
		//清除表单数据（表单完整重置（表单的数据，表单的样式））
		reset_form("#deptAndModel form");		
		//弹出模态框
		$('#deptAndModel').modal({
			backdrop:"static"
		});
	});	
  
	//点击保存，保存部门
	$("#dept_sava_btn").click(function(){
		//模框中填写的表单数据提交给服务器进行保存
		if($(this).attr("ajax-va") == "error"){
			show_validate_msg("#deptName_add_input","error",$(this).attr("error-msg"));
            return false;
        }
		//发送ajax请求保存部门	
		$.ajax({
			url:"${APP_PATH}/dept",
			type:"POST",
			data:$("#deptAndModel form").serialize(),
			success:function(result){
				if(result.code == 100){
					//部门保存成功
					//1、关闭模态框
					$("#deptAndModel").modal('hide');
					//2、来到最后一页，显示刚才保存的数据
					//发送ajax请求显示最后一页数据
					to_dept_page(totalRecord);
				}else{
					//显示失败信息
					//有哪个字段的错误信息就显示哪个字段
					show_validate_msg("#deptName_add_input","error",result.extend.va_msg);				
				}
			}
		});
	});
	
	$("#deptName_add_input").change(function(){
		//发送ajax请求校验部门名是否可用
		var deptName = this.value;
		$.ajax({
			url:"${APP_PATH}/checkDept",
			data:"deptName=" + deptName,
			type:"POST",
			success:function(result){
				if(result.code == 100){
					show_validate_msg("#deptName_add_input","success","");
					$("#dept_sava_btn").attr("ajax-va","success");
				}else{
					show_validate_msg("#deptName_add_input","error",result.extend.va_msg);
					$("#dept_sava_btn").attr("ajax-va","error");
					$("#dept_sava_btn").attr("error-msg",result.extend.va_msg);
				}
			}
		});
	});
	
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
	
	//单个删除
	$(document).on("click",".delete_btn",function(){
		//1、弹出是否确认删除对话框
		var deptName = $(this).parents("tr").find("td:eq(2)").text();
		var deptId = $(this).attr("delete-id");
		//alert($(this).parents("tr").find("td:eq(2)").text());
		if(confirm("确认删除" + deptName + "吗？")){
			//确认，发送ajax请求删除
			$.ajax({
				url:"${APP_PATH}/dept/" + deptId,
				type:"DELETE",
				success:function(result){
					alert(result.msg);
					//回到本页
					to_dept_page(currentPage);
				}
			});
		}
		
	});
	
	//全选/全不选功能
	$("#check_all").click(function(){
		//prop修改的读取dom原生属性的值
		$(".check_item").prop("checked",$(this).prop("checked"));
	});
	
	$(document).on("click",".check_item",function(){
		//判断当前选择中的元素是否5个
		var flag = $(".check_item:checked").length == $(".check_item").length;
		$("#check_all").prop("checked",flag);
	});
	
	//点击批量删除
	$("#dept_delete_all_btn").click(function(){
    if($(".check_item:checked").length <= 0){
        alert("请勾选需要删除的员工信息!");
    }else {
        var deptNames = "";
        var del_ids = "";
        $.each($(".check_item:checked"),function(){
        	deptNames += $(this).parents("tr").find("td:eq(2)").text()+",";
            del_ids  +=  $(this).parents("tr").find("td:eq(1)").text()+"-";
        });
        //最后的逗号,"-"处理
        deptNames.substring(0,deptNames.length-1);
        del_ids.substring(0,del_ids.length-1);

        if(confirm("确认删除"+deptNames+"吗?")){
            $.ajax({
                url:"${APP_PATH}/dept/" + del_ids,
                type:"DELETE",
                success:function(result){
                    alert(result.msg);
                    $("#check_all").prop("checked",false);
                    to_dept_page(currentPage);
                }
            })
        }
    }
});
	

	</script>
</body>
</html>