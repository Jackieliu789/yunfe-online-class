<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>参会人员管理</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/vue_resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
    <style>
        .step-list{padding:0px;background:#eee;}
        .step-item{background:#fff;padding:10px;margin-top1:5px;border-bottom:1px solid #eee;border-top:none;}
        .step-item:last-child{border-bottom:none;}
        .fa-trash{background:#1E9FFF;color:#fff;width:25px;height:25px;text-align:center;line-height:25px;cursor:pointer;border-radius:50%;}
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
                    <div class="layui-card-header">已选人员</div>
                    <div class="layui-card-body step-list">
                        <div class="layui-row step-item" v-for="(item, index) in users">
                            <div class="layui-col-md8 layui-col-xs8 layui-col-sm8">{{item.userName}}</div>
                            <div class="layui-col-md4 layui-col-xs4 layui-col-sm4 text-right" @click="removeUser(index)"><i class="fa fa-trash"></i></div>
                        </div>
                        <div class="layui-row step-item" v-if="users.length <= 0">
                            <div class="layui-col-md12">暂无人员</div>
                        </div>
                    </div>
                </div>
                <#--end card-->
            </div>
        </div>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            users: [],
            meetingId: "${params.meetingId!}"
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
                    that.loadUsers();
                });
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
                $.http.post("${params.contextPath}/web/meeting/saveUser.json", {
                    meetingId: this.meetingId,
                    userId: userId
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
                $.http.post("${params.contextPath}/web/meeting/queryUsers.json", {meetingId: this.meetingId}).then(function (data) {
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
                $.http.post("${params.contextPath}/web/meeting/removeUser.json", {id: row.id}).then(function (data) {
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