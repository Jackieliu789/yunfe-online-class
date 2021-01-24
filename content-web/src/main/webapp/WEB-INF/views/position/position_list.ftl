<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>职务列表</title>
	<#include "/common/resource.ftl">
</head>
<body>

<div class="ui-operation">
    <div class="ui-buttons">
        <div class="layui-btn-group tools">
            <button class="layui-btn layui-btn-normal open-dialog" p="url:'${params.contextPath}/view/position/position_edit.htm',title:'添加职务信息',width:'600px',height:'400px'"><i class="fa fa-plus"></i>添加</button>
            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/position/position_edit.htm',title:'编辑职务信息',width:'600px',height:'400px'"><i class="fa fa-pencil"></i>修改</button>
            <button class="layui-btn layui-btn-normal remove-button" reurl="${params.contextPath}/web/position/delete.json"><i class="fa fa-remove"></i>删除</button>
            <button class="layui-btn layui-btn-normal accept-button" reurl="${params.contextPath}/web/position/accpet.json"><i class="fa fa-play"></i>启用</button>
            <button class="layui-btn layui-btn-normal stop-button" reurl="${params.contextPath}/web/position/stop.json"><i class="fa fa-stop"></i>停用</button>
        </div>
        <div class="ui-searchs">
            <div class="value"><input type="text" name="searchInput" value="" placeholder="姓名  编码"/></div>
            <input type="button" value="搜索" class="layui-btn layui-btn-danger search-button"/>
        </div>
    </div>
</div>
<div class="ui-content" style="padding-left: 10px;padding-right:10px;">
    <table id="datagrid" options="url:'${params.contextPath}/web/position/list.json',params:'getSearchParams'">
        <thead>
			<tr>
				<th data-options="field:'id',checkbox:true"></th>
				<th data-options="field:'name',width:100">职务名称</th>
				<th data-options="field:'code',width:150">职务代码</th>
				<th data-options="field:'createTimeStr',width:150">创建时间</th>
				<th data-options="field:'stateStr',width:150,formatter:formatState">状态</th>
			</tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
    function getSearchParams(){
        return {searchInput:$("input[name='searchInput']").val()};
    }
    function formatState(val, row) {
		if (row.state == 1) {
			return '<span class="ui-accept">'+val+'</span>';
		} else {
            return '<span class="ui-stop">'+val+'</span>';
		}
    }

    $(function () {
        $(".remove-button").click(function () {
            var ids = DataGrid.getCheckedIds();
            if (ids == "") {
                layer.msg("请选择删除记录")
                return false;
            }
            var url = $(this).attr("reurl");
            layer.confirm('确定删除记录', function () {
                $.ajaxRequest({
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
        $(".accept-button").click(function () {
            var ids = DataGrid.getCheckedIds();
            if (ids == "") {
                layer.msg("请选择启用职务")
                return false;
            }
            var url = $(this).attr("reurl");
            $.ajaxRequest({
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
        $(".stop-button").click(function () {
            var ids = DataGrid.getCheckedIds();
            if (ids == "") {
                layer.msg("请选择停用职务")
                return false;
            }
            var url = $(this).attr("reurl");
            $.ajaxRequest({
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
</script>
</body>

</html>
