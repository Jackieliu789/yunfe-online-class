<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑会议</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="ui-form">
        <form class="layui-form" @submit.prevent="submitForm()" method="post">
            <input type="hidden" v-model="record.id" />
            <div class="layui-form-item">
                <label class="layui-form-label">会议名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.name" placeholder="请输入名称" class="layui-input"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">会议时间<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <div style="display:inline-block;vertical-align:top;">
                        <input type="text" id="beginDate" v-model="record.beginDate" placeholder="开始日期" class="layui-input" style="width:200px;display:inline-block;cursor:pointer;" readonly/>
                    </div>
                    <span style="display:inline-block;line-height:35px;margin:0 5px;">至</span>
                    <div style="display:inline-block;vertical-align:top;">
                        <input type="text" id="endDate" v-model="record.endDate" placeholder="结束日期" class="layui-input" style="width:200px;display:inline-block;cursor:pointer;" readonly/>
                    </div>
                    <div class="layui-form-mid layui-word-aux">开始日期和结束日期请选择在同一天</div>
                </div>
            </div>
            <div class="layui-form-item" v-if="!record.id">
                <label class="layui-form-label">邀请码</label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.inviteCode" placeholder="请输入邀请码" class="layui-input"/>
                    <div class="layui-form-mid layui-word-aux">邀请码相当于给会议加密了，参会人员只有输入正确的邀请码才能进入会议室</div>
                </div>
            </div>
            <#--<div class="layui-form-item" v-if="!record.id">
                <label class="layui-form-label">注意</label>
                <div class="layui-input-block" style="color:#f33;">
                    会议室内包括主持人最多50人，系统不会限制选择参会人员的数量，但是超过50人之后音视频质量会严重下滑
                </div>
            </div>-->

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
                name:'',
                beginDate:'',
                endDate:'',
                inviteCode:''
            },
        },
        mounted: function () {
            this.init();
            this.loadData();
        },
        methods: {
            init:function(){
                var that = this;
                laydate.render({elem: '#beginDate', type:'datetime', done:function (value) {
                        that.record.beginDate = value;
                    }});

                laydate.render({elem: '#endDate', type:'datetime', done:function (value) {
                        that.record.endDate = value;
                    }});
            },
            loadData: function () {
                if (!'${params.id!}') {
                    return;
                }
                var that = this;
                $.http.post("${params.contextPath}/web/meeting/query.json", {id: '${params.id!}'}).then(function (data) {
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
                $.http.post("${params.contextPath}/web/meeting/<#if (params.id)??>modify<#else>save</#if>.json", this.record).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var alt = layer.alert(data.message || "操作成功", function () {
                        var back = "${params.back!}";
                        if (back) {
                            history.go(-1);
                            return;
                        }
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
