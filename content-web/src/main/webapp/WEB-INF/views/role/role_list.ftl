<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>角色列表</title>
	<#include "/common/resource.ftl">
</head>
<body>

<div class="ui-operation">
    <div class="ui-buttons">
        <div class="layui-btn-group tools">
            <button class="layui-btn layui-btn-normal open-dialog" p="url:'${params.contextPath}/view/role/role_edit.htm',title:'添加角色信息',width:'600px',height:'400px'"><i class="fa fa-plus"></i>添加</button>
            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/role/role_edit.htm',title:'编辑菜单信息',width:'600px',height:'400px'"><i class="fa fa-pencil"></i>修改</button>
            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/role/role_menu.htm',title:'配置菜单',aid:'roleId',width:'600px',height:'600px'"><i class="fa fa-tasks"></i>配置菜单</button>
            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/role/role_user.htm',title:'已配用户',aid:'roleId',width:'600px',height:'400px'"><i class="fa fa-user"></i>已配用户</button>
            <button class="layui-btn layui-btn-normal accpet-button" reurl="${params.contextPath}/web/role/accpet.json"><i class="fa fa-play"></i>启用</button>
            <button class="layui-btn layui-btn-normal stop-button" reurl="${params.contextPath}/web/role/stop.json"><i class="fa fa-stop"></i>停用</button>
            <button class="layui-btn layui-btn-normal remove-button" reurl="${params.contextPath}/web/role/delete.json"><i class="fa fa-remove"></i>删除</button>
        </div>
        <div class="ui-searchs">
            <div class="value"><input type="text" name="name" value="" placeholder="名称"/></div>
            <input type="button" value="搜索" class="layui-btn layui-btn-danger search-button"/>
        </div>
    </div>
</div>
<div class="ui-content" style="padding-left: 10px;padding-right:10px;">
    <table id="datagrid" options="url:'${params.contextPath}/web/role/list.json',params:'getSearchParams'">
        <thead>
			<tr>
				<th data-options="field:'id',checkbox:true"></th>
				<th data-options="field:'name',width:100,align:'left'">名称</th>
				<th data-options="field:'createName',width:150,align:'left'">创建人</th>
				<th data-options="field:'createTimeStr',width:150,align:'center'">创建日期</th>
				<th data-options="field:'isSysStr',width:150,align:'center'">系统角色</th>
 				<th data-options="field:'stateStr',width:150,align:'center',formatter:formatState">状态</th>
			</tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
	function getSearchParams(){
	    return {name:$("input[name='name']").val()};
	}

	function formatState(val, row) {
		if (row.state == 1) {
			return '<span class="ui-accept">' + val + '</span>';
		} else {
			return '<span class="ui-stop">' + val + '</span>';
		}
	}
	$(function(){
		 $(".remove-button").click(function () {
	            var ids = DataGrid.getCheckedIds();
	            if (ids == "") {
	                layer.msg("请选择删除记录")
	                return false;
	            }
	            var url = $(this).attr("reurl");
	            layer.confirm('确定删除记录', function () {
	                $.ajaxRequest({
	                	type:'post',
	                    url:url,
	                    data:{ids:ids.join(",")},
	                    success:function(data){
	                        $.message(data.message);
	                         if (data.success) {
	                            DataGrid.reload();
	                        }
	                    }
	                });
	            });
	        });
		 
		 $(".stop-button").click(function(){
			  var ids = DataGrid.getCheckedIds();
	            if (ids == "") {
	                layer.msg("请选择停用记录")
	                return false;
	            }
	            var url = $(this).attr("reurl");
	            $.ajaxRequest({
	            	type:'post',
                    url:url,
                    data:{ids:ids.join(",")},
                    success:function(data){
                        $.message(data.message);
                         if (data.success) {
                            DataGrid.reload();
                        }
                    }
                });
		 });
		 $(".accpet-button").click(function(){
			  var ids = DataGrid.getCheckedIds();
	            if (ids == "") {
	                layer.msg("请选择启用记录")
	                return false;
	            }
	            var url = $(this).attr("reurl");
	            $.ajaxRequest({
	            	type:'post',
                    url:url,
                    data:{ids:ids.join(",")},
                    success:function(data){
                        $.message(data.message);
                         if (data.success) {
                            DataGrid.reload();
                        }
                    }
                });
		 });
	})
</script>
</body>

</html>
