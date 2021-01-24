<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>组织机构列表</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
</head>
<body>
    <div class="ui-head">
        <span>组织机构树</span>
        <span class="right tree-save">
            <i class="fa fa-plus-circle"></i>&nbsp;确定
        </span>
    </div>
    <div class="ui-body">
        <#--<form action="${params.contextPath}/web/user/changeOrg.json" class="ajax-form" method="post">
            <input name="userId" type="hidden" value="${params.id!}" />
            <input type="hidden" name="orgId" value=""/>
            <ul id="ztreeMenu" class="ztree"></ul>
        </form>-->
        <ul id="ztreeMenu" class="ztree"></ul>
    </div>
    <script type="text/javascript">
        var setting = {data:{simpleData:{enable:true}},callback:{onClick:treeClick}};
        var user_org_id = "", user_org_name = "";
        function treeClick(event, treeId, treeNode) {
            user_org_id = treeNode.id;
            user_org_name = treeNode.name;
        }
        $(document).ready(function(){
            $("span.tree-save").click(function(){
                //$(".ajax-form").submit();
                parent.app.setOrgData(user_org_id, user_org_name);
                parent.layer.closeAll();
            });
            loadTree();
        });
        //加载菜单树
        function loadTree(){
            $.getJSON('${params.contextPath}/web/organization/tree.json', function(data) {
                var list = data.data;
                var zTree = $.fn.zTree.init($("#ztreeMenu"), setting, list);

                if (list && user_org_id) {
                    var nodes = zTree.transformToArray(zTree.getNodes());
                    for (var i = 0; i < nodes.length; i ++) {
                        var item = nodes[i];
                        if (item.id != user_org_id) {
                            continue;
                        }
                        zTree.expandNode(item, true);
                        zTree.selectNode(item);
                        break;
                    }
                }
            });
        }
    </script>
</body>
</html>
