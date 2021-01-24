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
        <span>组织机构树</span>
        <span class="right tree-save">
            <i class="fa fa-plus-circle"></i>&nbsp;保存
        </span>
    </div>
    <div class="ui-body">
        <form action="${params.contextPath}/web/user/changeOrg.json" class="ajax-form" method="post">
            <input name="userId" type="hidden" value="${params.id!}" />
            <input type="hidden" name="orgId" value=""/>
            <ul id="ztreeMenu" class="ztree"></ul>
        </form>
    </div>
    <script type="text/javascript">
        var setting = {data:{simpleData:{enable:true}},callback:{onClick:treeClick}};
        var user_org_id = "";
        var getUserOrgId = function(){
            $.ajaxRequest({
                url:'${params.contextPath}/web/user/query.json',
                data:{id:"${params.id!}"},
                success:function(data){
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    user_org_id = data.data.orgId;
                    $("input[name='orgId']").val(user_org_id);
                }
            });
        };
        function treeClick(event, treeId, treeNode) {
            $("input[name='orgId']").val(treeNode.id);
        }
        $(document).ready(function(){
            $("span.tree-save").click(function(){
                $(".ajax-form").submit();
            });
            getUserOrgId();
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
