<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑课程</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="ui-form">
        <form class="layui-form" @submit.prevent="submitForm()" method="post">
            <input type="hidden" v-model="record.id" />
            <div class="layui-form-item">
                <label class="layui-form-label">课节名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.name" placeholder="请输入名称" class="layui-input"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">班型<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <select type="text" v-model="record.type" class="layui-input">
                        <option value="1">1v49</option>
                        <option value="2">1vN</option>
                    </select>
                    <div class="layui-form-mid layui-word-aux">
                        <p>1、1v49指课堂内学生人数不超过49人，并且老师与学生、学生与学生之间都能相互看到对方画面，听到对方声音</p>
                        <p>2、1vN指课堂内学生只能看到和听到老师音视频，学生如果需要和老师互动交流需要举手请求连麦或者老师直接连麦学生，连麦视频49人以内</p>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">上课时间<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <div style="display:inline-block;vertical-align:top;">
                        <input type="text" id="beginDate" v-model="record.beginDate" placeholder="开始日期" class="layui-input" readonly style="width:200px;display:inline-block;cursor:pointer;"/>
                    </div>
                    <span style="display:inline-block;line-height:35px;margin:0 5px;">至</span>
                    <div style="display:inline-block;vertical-align:top;">
                        <input type="text" id="endDate" v-model="record.endDate" placeholder="结束日期" class="layui-input" readonly style="width:200px;display:inline-block;cursor:pointer;"/>
                    </div>
                    <div class="layui-form-mid layui-word-aux">开始日期和结束日期请选择在同一天</div>
                </div>
            </div>
            <div class="layui-form-item" v-if="!record.id">
                <label class="layui-form-label">邀请码</label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.inviteCode" placeholder="请输入邀请码" class="layui-input"/>
                    <div class="layui-form-mid layui-word-aux">邀请码相当于给课节加密了，学生只有输入正确的邀请码才能进入课堂</div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">选择讲师<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <select type="text" v-model="record.teacherId" class="layui-input">
                        <option value="">请选择</option>
                        <option :value="item.userId" v-for="(item, index) in teachers">{{item.userName}}</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">选择学员<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <table class="layui-table" lay-even lay-skin="line" lay-size="sm">
                        <thead>
                        <tr>
                            <th style="width:50px;cursor:pointer;" @click="selectAll">全选/取消</th>
                            <th>学生姓名</th>
                            <th>所属组织</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr v-for="(item, index) in students">
                            <td><input type="checkbox" :value="item.userId" v-model="record.userIds"/></td>
                            <td>{{item.userName}}</td>
                            <td>{{item.orgName}}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <input type="submit" value="保存" class="layui-btn" />
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            record : {
                id:'${params.id!}',
                courseId:'${params.courseId!}',
                name:'',
                type:'1',
                teacherId:'',
                beginDate:'',
                endDate:'',
                inviteCode:'',
                userIds:[],
            },
            teachers:[],
            students:[],
        },
        mounted: function () {
            this.init();
            this.loadTeachers();
        },
        methods: {
            init: function () {
                var that = this;
                laydate.render({elem: '#beginDate', type:'datetime', done:function (value) {
                        that.record.beginDate = value;
                    }});

                laydate.render({elem: '#endDate', type:'datetime', done:function (value) {
                        that.record.endDate = value;
                    }});
            },
            loadTeachers: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/queryCourseTeacher.json", {courseId: this.record.courseId}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.teachers = data.data;
                    that.loadStudents();
                });
            },
            loadStudents: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/queryCourseStudent.json", {courseId: this.record.courseId}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.students = data.data;
                    that.loadData();
                });
            },
            loadData: function () {
                if (!'${params.id!}') {
                    return;
                }
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/query.json", {id: '${params.id!}'}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var item = data.data;
                    for (var key in  that.record) {
                        that.record[key] = item[key];
                    }
                    that.record.beginDate = item.beginDateStr + ":00";
                    that.record.endDate = item.endDateStr + ":00";
                });
            },
            submitForm: function () {
                $.http.post("${params.contextPath}/web/pmsCourseItem/<#if (params.id)??>modify<#else>save</#if>.json", this.record).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    layer.alert(data.message || "操作成功", function () {
                        history.go(-1);
                    });
                });
            },
            selectAll:function () {
                var len = this.record.userIds.length;
                if (len == this.students.length && len > 0) {
                    this.record.userIds = [];
                    return;
                }
                var userIds = [];
                for (var i = 0; i < this.students.length; i ++) {
                    userIds.push(this.students[i].userId);
                }
                this.record.userIds = userIds;
            }
        }
    });
</script>
</body>

</html>
