<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>资源列表</title>
<#include "/common/resource.ftl">
</head>
<body>

<div class="ui-operation">
    <div class="ui-buttons">
        <div class="layui-btn-group tools">
            <button class="layui-btn layui-btn-normal open-dialog" p="url:'${params.contextPath}/view/resource/resource_edit.htm',title:'添加资源信息',width:'600px',height:'90%'">
                <i class="fa fa-plus"></i>添加
            </button>
            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/resource/resource_edit.htm',title:'编辑菜单信息',width:'600px',height:'90%'">
                <i class="fa fa-pencil"></i>修改
            </button>
            <button class="layui-btn layui-btn-normal remove-button" reurl="${params.contextPath}/web/resource/delete.json"><i class="fa fa-remove"></i>删除</button>
            <button class="layui-btn layui-btn-normal accpet-button" reurl="${params.contextPath}/web/resource/accpet.json"><i class="fa fa-play"></i>启用</button>
            <button class="layui-btn layui-btn-normal stop-button" reurl="${params.contextPath}/web/resource/stop.json">
                <i class="fa fa-stop"></i>停用
            </button>
        </div>
        <div class="ui-searchs">
            <div class="value"><input type="text" name="searchInput" value="" placeholder="名称  编码"/></div>
            <input type="button" value="搜索" class="layui-btn layui-btn-danger search-button"/>
        </div>
    </div>
</div>
<div class="ui-content" style="padding-left: 10px;padding-right:10px;">
    <table id="datagrid" options="url:'${params.contextPath}/web/resource/list.json',params:'getSearchParams',dblClickRow:'showDetail'">
        <thead>
        <tr>
            <th data-options="field:'id',checkbox:true"></th>
            <th data-options="field:'name',width:100">资源名称</th>
            <th data-options="field:'code',width:150">资源编码</th>
            <th data-options="field:'url',width:150">URL</th>
            <th data-options="field:'operateTypeStr',width:150">操作类型</th>
            <th data-options="field:'functionName',width:150">功能模块名称</th>
            <th data-options="field:'operateObject',width:150">操作对象</th>
            <th data-options="field:'tableName',width:150">操作表</th>
            <th data-options="field:'stateStr',width:150,formatter:formatState">状态</th>
        </tr>
        </thead>
    </table>
</div>
<script type="text/javascript">
    function getSearchParams() {
        return {searchInput: $("input[name='searchInput']").val()};
    }
    var showDetail = function (index, row) {
        var url = "${params.contextPath}/view/resource/resource_detail.htm?id=" + row.id;
        DialogManager.openDialog("url:'" + url + "',title:'资源详细信息',width:'800px',height:'450px'");
    };
    function formatState(val, row) {
        if (row.state == 1) {
            return '<span class="ui-accept">' + val + '</span>';
        } else {
            return '<span class="ui-stop">' + val + '</span>';
        }
    }
    $(function () {
        $(".remove-button").click(function () {
            var ids = DataGrid.getCheckedIds();
            if (ids == "") {
                layer.msg("请选择要删除的资源");
                return false;
            }
            var url = $(this).attr("reurl");
            layer.confirm('确认删除资源信息', function () {
                $.ajaxRequest({
                    type: 'post',
                    data: {ids: ids.join(",")},
                    url: url,
                    success: function (data) {
                        $.message(data.message);
                        if (data.success) {
                            DataGrid.reload();
                        }
                    }
                });
            });

        });

        $(".stop-button").click(function () {
            var ids = DataGrid.getCheckedIds();
            if (ids == "") {
                layer.msg("请选择要停用的资源");
                return false;
            }
            var url = $(this).attr("reurl");
            $.ajaxRequest({
                type: 'post',
                data: {ids: ids.join(",")},
                url: url,
                success: function (data) {
                    $.message(data.message);
                    if (data.success) {
                        DataGrid.reload();
                    }
                }
            });
        });
        $(".accpet-button").click(function () {
            var ids = DataGrid.getCheckedIds();
            if (ids == "") {
                layer.msg("请选择要启用的资源");
                return false;
            }
            var url = $(this).attr("reurl");
            $.ajaxRequest({
                type: 'post',
                data: {ids: ids.join(",")},
                url: url,
                success: function (data) {
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
