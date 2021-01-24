<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>${params.websitName!}</title>
    <#include "/common/vue_resource.ftl">
    <style>
        .layui-form-item{width:300px;margin:20px auto;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="ui-form">
        <form class="layui-form" @submit.prevent="submitForm()" method="post">
            <h1 class="text-center" style="font-size:28px;margin:50px 0;">直播课程邀请码验证</h1>
            <div class="layui-form-item">
                <input type="text" v-model="record.code" placeholder="请输入邀请码" class="layui-input"/>
            </div>
            <div class="layui-form-item">
                <input type="submit" value="提交验证" class="layui-btn layui-btn-fluid"/>
            </div>
        </form>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            record: {
                cid: '${params.cid!}',
                code: '',
            },
        },
        mounted: function () {
        },
        methods: {
            submitForm: function () {
                $.http.post("${params.contextPath}/pmsLiveCourse/check/invit/code.json", this.record).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    location.href = "${params.contextPath!}" + data.data;
                });
            },
        }
    });
</script>
</body>

</html>
