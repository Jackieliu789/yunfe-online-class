<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>用户列表</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
    <script type="text/javascript">
        var getSearchParams = function(){
            return {
                searchInput:$("input[name='searchInput']").val() || "",
                orgId:$("input[name='orgId']").val() || "",
            };
        }
    </script>
</head>
<body>
    <table class="ui-table">
        <tr>
            <td class="ui-table-left" style="width:250px;">
                <!-- ** 左侧栏 ** -->
                <div class="ui-head">
                    <span>组织机构树</span>
                    <span class="right">
		            	<i class="fa fa-remove"></i>&nbsp;取消选中
		            </span>
                </div>
                <div class="ui-body">
                    <ul id="org-tree" class="ztree"></ul>
                </div>
            </td>
            <td class="ui-table-right" >
                <div class="ui-operation">
                    <div class="ui-buttons">
                        <div class="layui-btn-group tools">
                            <button class="layui-btn layui-btn-normal add-dialog" p="url:'${params.contextPath}/view/user/user_edit.htm',title:'添加用户',width:'800px',height:'90%'"><i class="fa fa-plus"></i>添加</button>
                            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/user/user_edit.htm',title:'修改用户信息',width:'800px',height:'90%'"><i class="fa fa-pencil"></i>修改</button>
                            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/user/user_role.htm',aid:'userId',title:'配置角色',width:'750px'"><i class="fa fa-tasks"></i>配置角色</button>
                            <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/user/user_org.htm',title:'变更用户单位',width:'550px'"><i class="fa fa-pencil"></i>变更单位</button>
                            <button class="layui-btn layui-btn-normal accept-button" reurl="${params.contextPath}/web/user/accept.json"><i class="fa fa-play"></i>启用</button>
                            <button class="layui-btn layui-btn-normal stop-button" reurl="${params.contextPath}/web/user/stop.json"><i class="fa fa-stop"></i>停用</button>
                            <button class="layui-btn layui-btn-normal delete-button" reurl="${params.contextPath}/web/user/remove.json"><i class="fa fa-remove"></i>删除</button>
                            <button class="layui-btn layui-btn-normal reset-button" reurl="${params.contextPath}/web/user/resetPass.json"><i class="fa fa-pencil"></i>重置密码</button>
                            <a class="layui-btn layui-btn-normal layui-btn-sm" target="_blank" href="${params.contextPath}/excel/账号信息导入_模板.xlsx">下载模板</a>
                            <button type="button" class="layui-btn layui-btn-normal layui-btn-sm excel-button">导入账号</button>
                        </div>
                        <div class="ui-searchs">
                            <div class="value" style="">
                                <input type="hidden" name="orgId" value=""/>
                                <input type="text" name="searchInput" placeholder="搜索账号、姓名">
                            </div>
                            <input type="button" value="搜索" class="layui-btn layui-btn-danger search-button"/>
                        </div>
                    </div>
                </div>
                <div class="ui-content" style="padding-left: 10px;padding-right:10px;">
                    <table id="datagrid" options="url:'${params.contextPath}/web/user/list.json',params:'getSearchParams'">
                        <thead>
                            <tr>
                                <th data-options="field:'id',checkbox:true">Item ID</th>
                                <th data-options="field:'name',width:100">姓名</th>
                                <th data-options="field:'policeNo',width:100">账号</th>
                                <th data-options="field:'categoryStr',width:100">类别</th>
                                <th data-options="field:'orgName',width:100">所在机构</th>
                                <th data-options="field:'positionName',width:80">职务</th>
                                <th data-options="field:'email',width:150">电子邮件</th>
                                <th data-options="field:'phone',width:100">手机号码</th>
                                <th data-options="field:'stateStr',width:60,align:'center',formatter:formatState">状态</th>
                                <th data-options="field:'createTimeStr',width:150,align:'center'">创建时间</th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </td>
        </tr>
    </table>
    <div style="display:none;">
        <form class="layui-form excel-form" action="${params.contextPath}/web/user/importExcel.json" method="post">
            <input type="hidden" name="_orgId" value=""/>
            <input type="file" name="file" single accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"/>
        </form>
    </div>
    <script type="text/javascript">
        function formatState(val, row) {
            if (row.state == 1) {
                return '<span class="ui-accept">' + val + '</span>';
            } else {
                return '<span class="ui-stop">' + val + '</span>';
            }
        }

        function treeClick(event, treeId, treeNode, clickFlag) {
            $("input[name='orgId']").val(treeNode.id);
            DataGrid.refresh();
        }

        var setting = {
            data: {simpleData: {enable: true}},
            callback:{onClick:treeClick}
        };
        var initTree = function () {
            $.ajaxRequest({
                url:"${params.contextPath}/web/organization/tree.json",
                success:function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var zTree = $.fn.zTree.init($("#org-tree"), setting, data.data);
                    var nodes = zTree.transformToArray(zTree.getNodes());
                    zTree.expandNode(nodes[0], true);
                }
            });
        };

        $(document).ready(function(){
            initTree();
            $(".add-dialog").click(function () {
                var treeObj = $.fn.zTree.getZTreeObj("org-tree");
                var nodes = treeObj.getSelectedNodes();
                if (nodes.length <= 0) {
                    $.message("请选择左边用户所属单位");
                    return;
                }
                var orgId = nodes[0].id;
                var p = $(this).attr("p");
                var params = eval("({" + p + "})");
                params.url += "?orgId="+orgId + "&orgName=" + nodes[0].name;
                DialogManager.openDialog(JSON.stringify(params).replace("{", "").replace("}", ""));
            });
            $(".stop-button, .accept-button").click(function(){
                var array = DataGrid.getCheckedIds();
                if (array.length <= 0) {
                    layer.msg("请勾选要操作的行!");
                    return false;
                }
                var url = $(this).attr("reurl");
                $.ajaxRequest({
                    url:url,
                    data:{ids:array.join(",")},
                    success:function(data){
                        if (data.success) {
                            $.message("操作成功");
                            DataGrid.reload();
                            return;
                        }
                        $.message("操作失败");
                    }
                });
            });
            $(".delete-button").click(function(){
                var array = DataGrid.getCheckedIds();
                if (array.length <= 0) {
                    layer.msg("请勾选要操作的行!");
                    return false;
                }
                var url = $(this).attr("reurl");
                layer.alert("确定要删除勾选的用户吗？", function(){
                    layer.closeAll();
                    $.ajaxRequest({
                        url:url,
                        data:{ids:array.join(",")},
                        success:function(data){
                            if (data.success) {
                                $.message("删除成功");
                                DataGrid.reload();
                                return;
                            }
                            $.message("删除失败");
                        }
                    });
                });
            });
            $(".reset-button").click(function(){
                var array = DataGrid.getCheckedIds();
                if (array.length <= 0) {
                    layer.msg("请勾选要操作的行!");
                    return false;
                }
                var url = $(this).attr("reurl");
                layer.alert("确定要重置勾选用户的密码吗？", function(){
                    layer.closeAll();
                    $.ajaxRequest({
                        url:url,
                        data:{ids:array.join(",")},
                        success:function(data){
                            $.message(data.message);
                            if (data.success) {
                                DataGrid.reload();
                                return;
                            }
                        }
                    });
                });
            });
            $(".ui-head .right").click(function(){
                var treeObj = $.fn.zTree.getZTreeObj("org-tree");
                treeObj.cancelSelectedNode();
                $("input[name='orgId']").val("");
                DataGrid.refresh();
            });
            $(".excel-button").click(function () {
                var treeObj = $.fn.zTree.getZTreeObj("org-tree");
                var nodes = treeObj.getSelectedNodes();
                if (nodes.length <= 0) {
                    $.message("请选择左边用户所属单位");
                    return;
                }
                var orgId = nodes[0].id;
                $("[name='_orgId']").val(orgId || "");
                $("[type='file']").val("").click();
            });

            $("[type='file']").change(function () {
                $(".excel-form").submit();
            });

            $(".excel-form").unbind().submit(function () {
                var form = $(this);
                form.formSubmit({
                    parentRefresh: false,
                    parentClose: false,
                    callBack:function (data) {
                        DataGrid.refresh();
                    }
                });
                return false;
            });
        });
    </script>
</body>
</html>
