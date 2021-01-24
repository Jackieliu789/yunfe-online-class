<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>直播课程列表</title>
    <#include "/common/vue_resource.ftl">
    <style>
        .layui-card-header{font-weight:bold;}
        .class-list{display:flex;flex-direction:row;flex-wrap:wrap;}
        .class-list .item{border:2px solid #e2e2e2;margin-right:10px;margin-bottom:10px;padding:10px;width:260px;line-height:30px;border-radius:5px;}
        .class-list .item:hover{border:2px solid #FF5722;}
        .item span{font-size:12px;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container">
        <div class="layui-row app-header" style="padding:15px;">
            <div class="layui-col-md4">
                <span style="visibility: hidden;">aa</span>
            </div>
            <div class="layui-col-md4 text-center">我的课程/会议</div>
            <div class="layui-col-md4 text-right">
                <input type="text" id="date" v-model="params.date" class="layui-input" style="cursor:pointer;" readonly/>
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary search-button" @click="searchData">查询</button>
            </div>
        </div>

        <#--我的互动课堂-->
        <div class="layui-card">
            <div class="layui-card-header">互动课堂</div>
            <div class="layui-card-body class-list">
                <div class="item" v-for="(item, index) in courses">
                    <div>{{item.name}}</div>
                    <div style="color:#2F4056;">{{item.typeStr}}</div>
                    <div style="color:#2F4056;">
                        <span v-if="item.classStatus == 1" class="ui-warn">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 2" class="ui-accept">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 3" class="ui-no">{{item.classStatusStr}}</span>
                    </div>
                    <div style="color:#2F4056;font-size:12px;">{{item.beginDateStr2}} ~ {{item.endDateStr2}}</div>
                    <div class="text-center" v-if="item.classStatus != 3">
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" @click="toClassRoom(index)">进入教室</button>
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" v-if="item.teacherId == '${(user.id)!}'" @click="shareCourse(index)">分享</button>
                    </div>
                </div>
                <div v-if="courses.length == 0">--暂无课程--</div>
            </div>
        </div>
        <#--我的直播课堂-->
        <div class="layui-card">
            <div class="layui-card-header">直播课堂</div>
            <div class="layui-card-body class-list">
                <div class="item" v-for="(item, index) in liveCourses">
                    <div>{{item.name}}</div>
                    <div style="color:#2F4056;">
                        <span v-if="item.classStatus == 1" class="ui-warn">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 2" class="ui-accept">{{item.classStatusStr}}</span>
                        <span v-if="item.classStatus == 3" class="ui-no">{{item.classStatusStr}}</span>
                    </div>
                    <div style="color:#2F4056;font-size:12px;">{{item.beginDateStr2}} ~ {{item.endDateStr2}}</div>
                    <div class="text-center" v-if="item.classStatus != 3">
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" @click="toLiveRoom(index)">进入教室</button>
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" @click="shareLiveCourse(index)">分享</button>
                    </div>
                </div>
                <div v-if="liveCourses.length == 0">--暂无课程--</div>
            </div>
        </div>
        <#--我的会议-->
        <div class="layui-card">
            <div class="layui-card-header">会议</div>
            <div class="layui-card-body class-list">
                <div class="item" v-for="(item, index) in meetings">
                    <div>{{item.name}}</div>
                    <div style="color:#2F4056;">
                        <span v-if="item.status == 1" class="ui-warn">{{item.statusStr}}</span>
                        <span v-if="item.status == 2" class="ui-accept">{{item.statusStr}}</span>
                        <span v-if="item.status == 3" class="ui-no">{{item.statusStr}}</span>
                    </div>
                    <div style="color:#2F4056;font-size:12px;">{{item.beginDateStr2}} ~ {{item.endDateStr2}}</div>
                    <div class="text-center" v-if="item.status != 3">
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" @click="toMeetingRoom(index)">进入会议室</button>
                        <button type="button" class="layui-btn layui-btn-sm layui-btn-primary" v-if="item.hostId == '${(user.id)!}'" @click="shareMeetingCourse(index)">分享</button>
                    </div>
                </div>
                <div v-if="meetings.length == 0">--暂无会议--</div>
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
            params: {
                date: '${.now?string("yyyy-MM-dd")}',
            },
            courses: [],
            liveCourses: [],
            meetings: []
        },
        mounted: function () {
            this.init();
            this.loadCourse();
        },
        methods: {
            init: function () {
                var that = this;
                laydate.render({
                    elem: '#date', type: 'date', done: function (value) {
                        that.params.date = value;
                    }
                });
            },
            loadCourse: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/queryMyList.json", this.params).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.courses = data.data;
                    that.loadLiveCourse();
                });
            },
            loadLiveCourse: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/queryMyList.json", this.params).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.liveCourses = data.data;
                    that.loadMeeting();
                });
            },
            loadMeeting: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/meeting/queryMyList.json", this.params).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.meetings = data.data;
                });
            },
            searchData: function () {
                this.loadCourse();
            },
            toClassRoom: function (index) {
                var item = this.courses[index];
                $.http.post("${params.contextPath}/web/pmsCourseItem/toClassRoom.json", {
                    cid: item.id,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    $("#open-link").parent().attr("href", "${params.contextPath!}" + data.data);
                    $("#open-link").click();
                });
            },
            toLiveRoom: function (index) {
                var item = this.liveCourses[index];
                $.http.post("${params.contextPath}/web/pmsLiveCourse/toClassRoom.json", {
                    cid: item.id,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    $("#open-link").parent().attr("href", "${params.contextPath!}" + data.data);
                    $("#open-link").click();
                });
            },
            shareLiveCourse: function (index) {
                var item = this.liveCourses[index];
                var url = "${params.contextPath!}/view/business/pmsLiveCourse/pmsLiveCourse_share.htm?id=" + item.id;
                DialogManager.open({url: url, width: '700px', height: '450px', title: '直播课程分享'});
            },
            toMeetingRoom:function (index) {
                var item = this.meetings[index];
                $.http.post("${params.contextPath}/web/meeting/toMeetingRoom.json", {
                    mid: item.id,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    $("#open-link").parent().attr("href", "${params.contextPath!}" + data.data);
                    $("#open-link").click();
                });
            },
            shareMeetingCourse:function (index) {
                var item = this.meetings[index];
                var url = "${params.contextPath!}/view/business/meeting/meeting_share.htm?id=" + item.id;
                DialogManager.open({url: url, width: '700px', height: '450px', title: '会议分享'});
            },
            shareCourse:function (index) {
                var item = this.courses[index];
                var url = "${params.contextPath!}/view/business/pmsCourse/course_share.htm?id=" + item.id;
                DialogManager.open({url: url, width: '700px', height: '450px', title: '互动课程分享'});
            }
        }
    });
</script>
</body>

</html>