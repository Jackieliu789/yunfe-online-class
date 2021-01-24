<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>会议列表</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container" @click="hideMenu">
        <div class="layui-row app-header">
            <div class="layui-col-md3">
                <button type="button" class="layui-btn layui-btn-sm" @click="add">创建会议</button>
            </div>
            <div class="layui-col-md9 text-right">
                <input type="text" v-model="params.name" placeholder="会议名称" class="layui-input">
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary search-button" @click="seachData">查询</button>
            </div>
        </div>
        <div class="app-list">
            <div class="layui-row">
                <div class="layui-col-md9">
                    <div class="app-table-num"><span class="num">会议列表(共 {{total}} 条)</span></div>
                </div>
                <div class="layui-col-md3 text-right">
                    <span class="prev" @click="loadPrev">上一页</span>
                    <span class="next" @click="loadNext">下一页</span>
                </div>
            </div>
            <table class="layui-table" lay-even lay-skin="nob" lay-size1="sm">
                <thead>
                <tr>
                    <th style="width:20px;">#</th>
                    <th style="width:300px;">名称</th>
                    <th>开会时间</th>
                    <th>主持人</th>
                    <th>开会状态</th>
                    <th>参会人数</th>
                    <th style="width:215px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(item, index) in rows">
                    <td>{{20 * (params.page - 1) + 1 + index}}</td>
                    <td>{{item.name}}</td>
                    <td>{{item.beginDateStr}}~<br>{{item.endDateStr}}</td>
                    <td>{{item.hostName}}</td>
                    <td>
                        <span v-if="item.status == 1" class="ui-warn">{{item.statusStr}}</span>
                        <span v-if="item.status == 2" class="ui-accept">会议中</span>
                        <span v-if="item.status == 3" class="ui-no">{{item.statusStr}}</span>
                    </td>
                    <td>{{item.userNum}}</td>
                    <td class="more-parent" v-if="item.status == 3">
                        <div class="ui-operating" @click="userRecord(index)">参与统计</div>
                    </td>
                    <td class="more-parent" v-if="item.status != 3">
                        <div class="ui-operating" @click="share(index)">分享</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="modify(index)">编辑</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="userManage(index)">设置参会人员</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click.stop="showMenu(index)">更多</div>
                        <div class="more-container" v-if="item.showMenu">
                            <div class="more-item" @click="modifyHost(index)">设置主持人</div>
                            <div class="more-item" @click="userRecord(index)">参与统计</div>
                            <div class="more-item" v-if="item.inviteCode" @click="cancelInviteCode(index)">取消邀请码</div>
                            <div class="more-item" v-if="item.inviteCode" @click="modifyInviteCode(index)">变更邀请码</div>
                            <div class="more-item" v-if="!item.inviteCode" @click="modifyInviteCode(index)">设置邀请码</div>
                            <div class="more-item" v-if="item.status == 1" @click="remove(index)">删除</div>
                        </div>
                    </td>
                </tr>
                <tr v-if="rows.length <= 0">
                    <td colspan="8" class="text-center">没有更多数据了...</td>
                </tr>
                </tbody>
            </table>
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="app-table-num"><span class="num">共 {{total}} 条</span></div>
                </div>
                <div class="layui-col-md6 text-right">
                    <span class="prev" @click="loadPrev">上一页</span>
                    <span class="next" @click="loadNext">下一页</span>
                </div>
            </div>
        </div>
    </div>

</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            params: {
                name:'',
                page: 1,
            },
            rows: [],
            total: 0,
        },
        mounted: function () {
            this.loadData();
        },
        methods: {
            seachData:function(){
                this.params.page = 1;
                this.$nextTick(function () {
                    this.loadData();
                });
            },
            loadData: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/meeting/list.json", this.params).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.rows = data.rows;
                    that.total = data.total;
                });
            },
            loadNext: function () {
                if (this.rows.length < 20 && this.rows.length > 0) {
                    return;
                }
                this.params.page = this.params.page + 1;
                this.loadData();
            },
            loadPrev: function () {
                if (this.params.page <= 1) {
                    return;
                }
                this.params.page = this.params.page - 1;
                this.loadData();
            },
            add:function () {
                this.showTypes = false;
                var url = "${params.contextPath!}/view/business/meeting/meeting_edit.htm";
                DialogManager.open({url:url, width:'650px', height:'100%', title:'添加会议'});
            },
            modify: function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/meeting/meeting_edit.htm?id=" + row.id;
                DialogManager.open({url: url, width: '650px', height: '100%', title: '编辑会议'});
            },
            showMenu:function (index) {
                this.hideMenu();
                this.$set(this.rows[index], "showMenu", true);
            },
            hideMenu: function () {
                var that = this;
                this.rows.forEach(function (item) {
                    that.$set(item, 'showMenu', false);
                });
            },
            modifyHost:function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/meeting/meeting_host.htm?meetingId=" + row.id;
                DialogManager.open({url: url, width: '400px', height: '100%', title: '设置主持人'});
            },
            userManage:function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/meeting/meeting_user.htm?meetingId=" + row.id;
                DialogManager.open({url: url, width: '90%', height: '100%', title: '设置参会人员'});
            },
            share:function (index) {//分享
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/meeting/meeting_share.htm?id=" + row.id;
                DialogManager.open({url: url, width: '700px', height: '450px', title: '会议分享'});
            },
            remove:function (index) {//删除
                var that = this;
                $.http.post("${params.contextPath}/web/meeting/delete.json", {ids: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            cancelInviteCode:function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/meeting/removeInviteCode.json", {
                    id: id,
                    sort: this.sortValue
                }).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            modifyInviteCode:function (index) {
                var id = this.rows[index].id;
                var url = "${params.contextPath!}/view/business/meeting/meetingInviteCode_edit.htm?id=" + id;
                DialogManager.open({url: url, width: '400px', height: '200px', title: '设置邀请码'});
            },
            userRecord:function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/participateUser/participateUser_list.htm?roomId=" + row.id;
                DialogManager.open({url: url, width: '90%', height: '100%', title: '参与统计'});
            },
        }
    });
</script>
</body>

</html>