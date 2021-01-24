<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>用户列表</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
</head>
<body>
    <div class="ui-head">
        <span>菜单树</span>
        <span class="right tree-save">
            <i class="fa fa-plus-circle"></i>&nbsp;保存
        </span>
    </div>
    <div class="ui-body">
        <form action="${params.contextPath}/web/menu/saveRoleMenu.json" class="ajax-form" method="post">
            <input name="roleId" type="hidden" value="${params.roleId!}" />
            <input type="hidden" name="menuIds"/>
            <ul id="ztreeMenu" class="ztree"></ul>
        </form>
    </div>
    <script type="text/javascript">
        $(document).ready(function(){
            //FormManager.init("dataForm");
            $("span.tree-save").click(function(){
                $(".ajax-form").submit();
            });
            loadTree('${(params.roleId)!}');
        });
        function getCheckedMenus(){
            var checkedMenus = zTree.getCheckedNodes();
            var menus = new Array();
            for (var i = 0; i < checkedMenus.length; i++) {
                menus.push(checkedMenus[i].id);
            }
            var menuIds = menus.join(",");
            $("input[name='menuIds']").val(menuIds);
        }
        //加载菜单树
        function loadTree(roleid){
            var setting = {
                data : {simpleData:{enable : true}},
                callback:{
                    onCheck:function(e,treeId,treeNode){
                        getCheckedMenus();
                    },
                    beforeCheck:function(treeId,treeNode){
                        /*if (treeNode.name == "控制台" || treeNode.name == "工作中心") {
                            if (treeNode.checked){
                                return false;
                            }
                        }*/
                    }
                },
                check: {
                    enable : true,
                    chkboxType : { "Y" : "ps", "N" : "s" }
                }
            };
            $.getJSON('${params.contextPath}/web/menu/availableList.json', function(data) {
                window.zTree = $.fn.zTree.init($("#ztreeMenu"), setting, data.data);
                if (roleid) {
                    showChecked(window.zTree, roleid);
                }
                zTree.expandAll(false);
            });
        }
        //回显勾选的菜单选中状态
        function showChecked(zTree, roleid){
            var nodes = zTree.transformToArray(zTree.getNodes()); //所有的菜单节点
            $.ajaxRequest({
                url:'${params.contextPath}/web/menu/queryTreeByRoleId.json',
                data:{'roleId':roleid},
                async:true,
                success:function(data){
                    var treeList = data.data;
                    for (var i = 0; i < nodes.length; i++) {
                        var nodeid = nodes[i].id;
                        for (var j = 0; j < treeList.length;j++) {
                            if (treeList[j].id == nodeid) {
                                zTree.checkNode(nodes[i],true,false);
                                break;
                            }
                        }
                    }
                    getCheckedMenus();
                }
            });
        }
    </script>
</body>
</html>
