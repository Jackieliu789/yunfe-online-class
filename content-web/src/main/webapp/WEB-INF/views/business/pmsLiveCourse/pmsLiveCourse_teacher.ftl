<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>讲师管理</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/vue_resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container">
        <div class="layui-card">
            <div class="layui-card-header">组织机构</div>
            <div class="layui-card-body">
                <ul id="org-tree" class="ztree"></ul>
            </div>
        </div>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            courseId: "${params.courseId!}"
        },
        mounted: function () {
            this.loadTree();
        },
        methods: {
            loadTree: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/user/userOrgTree.json").then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var rows = data.data;
                    for (var i = 0; i < rows.length; i++) {
                        var item = rows[i];
                        if (item.isUser) {
                            item.icon = "${params.contextPath!}/images/user2.png";
                            continue;
                        }
                        item.icon = "${params.contextPath!}/images/org.png";
                    }

                    var setting = {
                        data: {simpleData: {enable: true}},
                        callback: {onClick: that.treeClick}
                    };
                    $.fn.zTree.init($("#org-tree"), setting, rows);
                });
            },
            treeClick: function (event, treeId, treeNode, clickFlag) {
                if (!treeNode.isUser) {
                    return;
                }

                var that = this;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/saveTeacher.json", {
                    id: this.courseId,
                    teacherId: treeNode.id
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var alt = layer.alert(data.message || "操作成功", function () {
                        parent.app.loadData();
                        parent.layer.closeAll();
                        layer.close(alt);
                    });
                });
            },
        }
    });
</script>
</body>

</html>