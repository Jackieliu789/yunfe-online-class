<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>课节列表</title>
    <#include "/common/vue_resource.ftl">
    <style>
        .subject-header .img{background-size:cover;border-radius:10px;background-repeat:no-repeat;}
        .subject-header > div{height:120px;vertical-align:top;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container" @click="hideMenu">
        <div class="layui-row layui-col-space20 subject-header" style="background-color:#F5F7FA;padding:20px;margin:0 15px;">
            <div class="layui-col-md2 img" v-if="record.coverPath" :style="{backgroundImage: 'url(${params.fileRequestUrl!}' + record.coverPath + ')' }"></div>
            <div class="layui-col-md2 img" v-if="!record.coverPath"></div>
            <div class="layui-col-md7" style="vertical-align:top;">
                <div style="font-size:16px;font-weight:bold;">{{record.name || ""}}</div>
                <#--<div style="color:#f33;margin-top:20px;" v-if="record.priceStatus == 2">免费</div>
                <div style="color:#f33;margin-top:20px;" v-if="record.priceStatus == 1">￥ {{record.price || 0}}</div>-->
                <div style="margin-top:65px;">
                    课程学员：{{record.studentNum || 0}}
                </div>
            </div>
            <div class="layui-col-md3 text-right">
                <div class="more-parent">
                    <div class="ui-operating" @click="modifyCourse()">编辑</div>
                    <div class="ui-split"></div>
                    <div class="ui-operating" v-if="record.shelfStatus != 3" @click="lowerCourseShelf()">下架</div>
                    <div class="ui-operating" v-if="record.shelfStatus == 3" @click="upperCourseShelf()">上架</div>
                    <div class="ui-split"></div>
                    <div class="ui-operating" @click.stop="showCourseMenu()">更多</div>
                    <div class="more-container" style="top:26px;right:-5px;" v-if="showTopMenu">
                        <div class="more-item" @click="shareCourse()">分享</div>
                        <div class="more-item" @click="teacherManage()">讲师管理</div>
                        <div class="more-item" @click="studentManage()">学员管理</div>
                    </div>
                </div>
                <div style="margin-top:70px;">课程进度：{{record.overItemNum}} / {{record.itemNum}}</div>
            </div>
        </div>
        <div class="layui-row app-header">
            <div class="layui-col-md3">
                <div class="layui-btn-group">
                    <button type="button" class="layui-btn layui-btn-sm" @click="add">新建课节</button>
                </div>
            </div>
            <div class="layui-col-md9 text-right">
                <input type="text" v-model="params.name" placeholder="课节名称" class="layui-input">
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary search-button" @click="seachData">查询</button>
            </div>
        </div>
        <div class="app-list">
            <div class="layui-row">
                <div class="layui-col-md9">
                    <div class="app-table-num"><span class="num">课节列表(共 {{total}} 条)</span></div>
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
                    <th>课节名称</th>
                    <th>班型</th>
                    <th>讲师名称</th>
                    <th>学员人数</th>
                    <th>上课时间</th>
                    <th>授课状态</th>
                    <th>排序</th>
                    <th style="width:200px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(item, index) in rows">
                    <td>{{20 * (params.page - 1) + 1 + index}}</td>
                    <td>{{item.name}}</td>
                    <td>{{item.typeStr}}</td>
                    <td>{{item.teacherName}}</td>
                    <td>{{item.studentNum}}</td>
                    <td>{{item.beginDateStr}}~<br>{{item.endDateStr}}</td>
                    <td>
                        <span v-if="item.classStatus == 1" class="ui-warn">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 2" class="ui-accept">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 3" class="ui-no">{{item.classStatusStr}}</span>
                    </td>
                    <td>
                        <span v-if="!item.isSort">{{item.sort}}</span>
                        <input v-if="item.isSort" type="text" class="layui-input" @keyup.enter="modifySort(index)" v-model="sortValue" style="width:50px;"/>
                    </td>
                    <td class="more-parent" v-if="item.classStatus == 3">
                        <div class="ui-operating" @click="chatRecord(index)">聊天记录</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="userRecord(index)">参与统计</div>
                    </td>
                    <td class="more-parent" v-if="item.classStatus != 3">
                        <div class="ui-operating" @click="showSort(index)">排序</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="attendClass(index)">去上课</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="modify(index)">编辑</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click.stop="showMenu(index)">更多</div>
                        <div class="more-container" v-if="item.showMenu">
                            <div class="more-item" @click="share(index)">分享</div>
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
                    <td colspan="9" class="text-center">没有更多数据了...</td>
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

    <div style="display:none">
        <a href="#" target="_blank"><span id="open-link">aa</span></a>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            params: {
                name:'',
                page: 1,
                courseId:'${params.courseId!}',
            },
            record:{},
            rows: [],
            total: 0,
            showTopMenu:false,
            sortValue:0,
        },
        mounted: function () {
            this.loadCourse();
        },
        methods: {
            seachData: function () {
                this.params.page = 1;
                this.$nextTick(function () {
                    this.loadData();
                });
            },
            loadCourse: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/query.json", {id: "${params.courseId!}"}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.record = data.data;
                    that.loadData();
                });
            },
            loadData: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/list.json", this.params).then(function (data) {
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
                location.href = "${params.contextPath!}/view/business/pmsCourseItem/pmsCourseItem_edit.htm?courseId=" + this.params.courseId;
            },
            modify: function (index) {
                var row = this.rows[index];
                location.href = "${params.contextPath!}/view/business/pmsCourseItem/pmsCourseItem_edit.htm?id=" + row.id + "&courseId=" + this.params.courseId;
            },
            showMenu:function (index) {
                this.hideMenu();
                this.$set(this.rows[index], "showMenu", true);
            },
            hideMenu: function () {
                var that = this;
                this.showTopMenu = false;
                this.rows.forEach(function (item) {
                    that.$set(item, 'showMenu', false);
                });
            },
            share:function (index) {//分享
                var url = "${params.contextPath!}/view/business/pmsCourse/course_share.htm?id=" + this.rows[index].id;
                DialogManager.open({url: url, width: '700px', height: '450px', title: '互动课程分享'});
            },
            remove:function (index) {//删除
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/delete.json", {ids: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            lowerCourseShelf:function () {//下架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/lowerShelf.json", {id: this.params.courseId}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadCourse();
                    parent.app.loadData();
                });
            },
            upperCourseShelf:function () {//上架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/upperShelf.json", {id: this.params.courseId}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadCourse();
                    parent.app.loadData();
                });
            },
            teacherManage:function () {//停止更新
                var url = "${params.contextPath!}/view/business/pmsCourse/pmsCourse_teacher.htm?courseId=" + this.params.courseId;
                DialogManager.open({url: url, width: '800px', height: '100%', title: '讲师管理'});
            },
            studentManage: function () {//更新中
                var url = "${params.contextPath!}/view/business/pmsCourse/pmsCourse_student.htm?courseId=" + this.params.courseId;
                DialogManager.open({url: url, width: '800px', height: '100%', title: '学生管理'});
            },
            modifyCourse: function () {
                var url = "${params.contextPath!}/view/business/pmsCourse/pmsCourse_edit.htm?back=true&id=" + this.params.courseId;
                location.href = url;
            },
            showCourseMenu: function () {
                this.showTopMenu = true;
            },
            shareCourse: function () {
                alert("开发中");
            },
            removeCourse: function () {
                $.http.post("${params.contextPath}/web/pmsCourse/delete.json", {ids: this.params.courseId}).then(function (data) {
                    if (!data.success) {
                        return;
                    }
                    var alt = layer.alert(data.message || "操作成功", function () {
                        parent.app.loadData();
                        parent.layer.closeAll();
                        layer.close(alt);
                    });
                });
            },
            showSort:function (index) {
                var sort = this.rows[index].sort;
                this.sortValue = sort;
                this.$set(this.rows[index], "isSort", true);
            },
            modifySort: function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/pmsCourseItem/modifySort.json", {
                    id: id,
                    sort: this.sortValue
                }).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.$set(that.rows[index], "isSort", false);
                    that.$set(that.rows[index], "sort", that.sortValue);
                });
            },
            attendClass:function (index) {
                $.http.post("${params.contextPath}/web/pmsCourseItem/toClassRoom.json", {
                    cid: this.rows[index].id,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    $("#open-link").parent().attr("href", "${params.contextPath!}" + data.data);
                    $("#open-link").click();
                });
            },
            cancelInviteCode:function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/pmsCourseItem/removeInviteCode.json", {
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
                var url = "${params.contextPath!}/view/business/pmsCourseItem/inviteCode_edit.htm?id=" + id;
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
