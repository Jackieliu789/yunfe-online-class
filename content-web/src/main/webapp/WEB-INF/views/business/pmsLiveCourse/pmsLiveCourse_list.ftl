<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>直播课程列表</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container" @click="hideMenu">
        <div class="layui-row app-header">
            <div class="layui-col-md3">
                <button type="button" class="layui-btn layui-btn-sm" @click="add">创建直播</button>
            </div>
            <div class="layui-col-md9 text-right">
                <input type="text" v-model="params.name" placeholder="课程名称" class="layui-input">
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary search-button" @click="seachData">查询</button>
            </div>
        </div>
        <div class="app-list">
            <div class="layui-row">
                <div class="layui-col-md9">
                    <div class="app-table-num"><span class="num">课程列表(共 {{total}} 条)</span></div>
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
                    <th>开课日期</th>
                    <th>授课老师</th>
                    <th>上架状态</th>
                    <th>授课状态</th>
                    <th style="width:200px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(item, index) in rows">
                    <td>{{20 * (params.page - 1) + 1 + index}}</td>
                    <td>
                        <div class="layui-row layui-col-space10">
                            <div class="layui-col-xs3 bg-img" :style="{backgroundImage: 'url(${params.fileRequestUrl!}' + item.coverPath + ')' }">
                            </div>
                            <div class="layui-col-xs9 title">
                                {{item.name}}
                            </div>
                        </div>
                    </td>
                    <td>{{item.beginDateStr}}~<br>{{item.endDateStr}}</td>
                    <td>{{item.teacherName}}</td>
                    <td><span :class="item.shelfStatus != 3 ? 'ui-accept' : 'ui-no'">{{item.shelfStatusStr}}</span></td>
                    <td>
                        <span v-if="item.classStatus == 1" class="ui-warn">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 2" class="ui-accept">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 3" class="ui-no">{{item.classStatusStr}}</span>
                    </td>
                    <td class="more-parent" v-if="item.classStatus == 3">
                        <div class="ui-operating" @click="chatRecord(index)">聊天记录</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="userRecord(index)">参与统计</div>
                    </td>
                    <td class="more-parent" v-if="item.classStatus != 3">
                        <div class="ui-operating" @click="share(index)">分享</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="modify(index)">编辑</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" v-if="item.shelfStatus != 3" @click="lowerShelf(index)">下架</div>
                        <div class="ui-operating" v-if="item.shelfStatus == 3" @click="upperShelf(index)">上架</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click.stop="showMenu(index)">更多</div>
                        <div class="more-container" v-if="item.showMenu">
                            <div class="more-item" @click="modifyTeacher(index)">设置授课老师</div>
                            <div class="more-item" @click="userManage(index)">设置嘉宾</div>
                            <div class="more-item" @click="chatRecord(index)">聊天记录</div>
                            <div class="more-item" @click="userRecord(index)">参与统计</div>
                            <div class="more-item" v-if="item.inviteCode" @click="cancelInviteCode(index)">取消邀请码</div>
                            <div class="more-item" v-if="item.inviteCode" @click="modifyInviteCode(index)">变更邀请码</div>
                            <div class="more-item" v-if="!item.inviteCode" @click="modifyInviteCode(index)">设置邀请码</div>
                            <div class="more-item" v-if="item.classStatus == 1" @click="remove(index)">删除</div>
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
                $.http.post("${params.contextPath}/web/pmsLiveCourse/list.json", this.params).then(function (data) {
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
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/pmsLiveCourse_edit.htm";
                DialogManager.open({url:url, width:'90%', height:'100%', title:'添加课程'});
            },
            modify: function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/pmsLiveCourse_edit.htm?id=" + row.id;
                DialogManager.open({url: url, width: '90%', height: '100%', title: '编辑课程'});
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
            lowerShelf:function (index) {//下架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/lowerShelf.json", {id: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            upperShelf:function (index) {//上架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/upperShelf.json", {id: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            share: function (index) {//分享
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/pmsLiveCourse_share.htm?id=" + row.id;
                DialogManager.open({url: url, width: '700px', height: '450px', title: '直播课程分享'});
            },
            remove:function (index) {//删除
                var that = this;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/delete.json", {ids: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            modifyTeacher:function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/pmsLiveCourse_teacher.htm?courseId=" + row.id;
                DialogManager.open({url: url, width: '400px', height: '100%', title: '设置授课老师'});
            },
            userManage:function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/pmsLiveCourse_user.htm?courseId=" + row.id;
                DialogManager.open({url: url, width: '90%', height: '100%', title: '设置嘉宾'});
            },
            cancelInviteCode:function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/removeInviteCode.json", {
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
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/liveInviteCode_edit.htm?id=" + id;
                DialogManager.open({url: url, width: '400px', height: '200px', title: '设置邀请码'});
            },
            chatRecord:function (index) {
                var row = this.rows[index];
                var url = "${params.contextPath!}/view/business/chatRecord/chatRecord_list.htm?roomId=" + row.id;
                DialogManager.open({url: url, width: '90%', height: '100%', title: '聊天记录'});
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