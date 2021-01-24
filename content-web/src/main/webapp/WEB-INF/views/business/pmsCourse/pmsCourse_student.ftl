<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>学生管理</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/vue_resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
    <style>
        .step-list{padding:0px;background:#eee;}
        .step-item{background:#fff;padding:10px;margin-top1:5px;border-bottom:1px solid #eee;border-top:none;}
        .step-item:last-child{border-bottom:none;}
        .fa-trash{background:#1E9FFF;color:#fff;width:25px;height:25px;text-align:center;line-height:25px;cursor:pointer;border-radius:50%;}
        .hover-btn{color:#FF5722;cursor:pointer;}
    </style>
</head>
<body style="background:#F2F2F2;">
<div id="app" v-cloak>
    <div class="app-container">
        <div class="layui-row layui-col-space20" style="background:#F2F2F2;">
            <div class="layui-col-md6 layui-col-xs6 layui-col-sm6">
                <div class="layui-card">
                    <div class="layui-card-header">组织机构</div>
                    <div class="layui-card-body">
                        <ul id="org-tree" class="ztree"></ul>
                    </div>
                </div>
            </div>
            <div class="layui-col-md6 layui-col-xs6 layui-col-sm6">
                <div class="layui-card">
                    <div class="layui-card-header">已选学生</div>
                    <div class="layui-card-body step-list">
                        <div class="layui-row step-item" v-for="(item, index) in users">
                            <div class="layui-col-md8 layui-col-xs8 layui-col-sm8">{{item.userName}}</div>
                            <div class="layui-col-md4 layui-col-xs4 layui-col-sm4 text-right" @click="removeUser(index)"><i class="fa fa-trash"></i></div>
                        </div>
                        <div class="layui-row step-item" v-if="users.length <= 0">
                            <div class="layui-col-md12">暂无学生</div>
                        </div>
                    </div>
                </div>
                <#--end card-->
            </div>
        </div>
    </div>
</div>
<script>
    function addUsers(orgId) {
        var treeObj = $.fn.zTree.getZTreeObj("org-tree");
        var nodes = treeObj.getNodesByFilter(function (node) {
           return node.isUser && node.pId == orgId;
        });
        var userIds = [];
        for (var i = 0; i < nodes.length; i ++) {
            userIds.push(nodes[i].id);
        }
        app.addUsers(userIds);
    }
    var app = new Vue({
        el: '#app',
        data: {
            users: [],
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
                        view: {
                            addHoverDom: that.addHoverDom,
                            removeHoverDom: that.removeHoverDom,
                        },
                        callback: {onClick: that.treeClick}
                    };
                    $.fn.zTree.init($("#org-tree"), setting, rows);
                    that.loadUsers();
                });
            },
            addHoverDom: function (treeId, treeNode) {
                var aObj = $("#" + treeNode.tId + " > a");
                if ($("#addNext_" + treeNode.id).length > 0) return;
                if (!treeNode.isUser) {
                    var str = "<span class='hover-btn' id='addNext_" + treeNode.id + "' onclick='addUsers(\"" + treeNode.id + "\")'>全部添加</span>";
                    aObj.after(str);
                }
            },
            removeHoverDom: function (treeId, treeNode) {
                $("#addNext_" + treeNode.id).unbind().remove();
            },
            treeClick: function (event, treeId, treeNode, clickFlag) {
                if (!treeNode.isUser) {
                    return;
                }
                var users = this.users, userId = treeNode.id;
                for (var i = 0; i < users.length; i++) {
                    if (userId == users[i].userId) {
                        return;
                    }
                }

                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/saveCourseStudent.json", {
                    courseId: this.courseId,
                    userId: userId
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.loadUsers();
                });
            },
            addUsers: function (userIds) {
                var users = this.users;
                var ids = [];
                for (var i = 0; i < userIds.length; i ++) {
                    var exists = false;
                    for (var k = 0; k < users.length; k ++) {
                        if (userIds[i] == users[k].userId) {
                            exists = true;
                            break;
                        }
                    }

                    if (!exists) {
                        ids.push(userIds[i]);
                    }
                }

                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/saveCourseStudents.json", {
                    courseId: this.courseId,
                    userIds: ids.join(",")
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.loadUsers();
                });
            },
            loadUsers: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/queryCourseStudent.json", {courseId: this.courseId}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.users = data.data;
                });
            },
            removeUser: function (index) {
                var row = this.users[index];
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/removeCourseUser.json", {id: row.id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadUsers();
                });
            }
        }
    });
</script>
</body>

</html>