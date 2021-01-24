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
        <#if !user>
            <form class="layui-form" @submit.prevent="loginForm()" method="post">
                <h1 class="text-center" style="font-size:28px;margin:50px 0;">${params.websitName!}</h1>
                <div class="layui-form-item">
                    <input type="text" v-model="login.account" placeholder="请输入用户名" class="layui-input"/>
                </div>
                <div class="layui-form-item">
                    <input type="password" v-model="login.pass" placeholder="请输入密码" class="layui-input"/>
                </div>
                <div class="layui-form-item">
                    <input type="submit" value="登录" class="layui-btn layui-btn-fluid"/>
                </div>
            </form>
        </#if>
        <#if user>
            <form class="layui-form" @submit.prevent="submitForm()" method="post">
                <h1 class="text-center" style="font-size:28px;margin:50px 0;">直播课程邀请码验证</h1>
                <div class="layui-form-item">
                    <input type="text" v-model="record.code" placeholder="请输入邀请码" class="layui-input"/>
                </div>
                <div class="layui-form-item">
                    <input type="submit" value="提交验证" class="layui-btn layui-btn-fluid"/>
                </div>
            </form>
        </#if>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            login: {
                account: '',
                pass: ''
            },
            record: {
                mid: '${params.mid!}',
                code: '',
            },
        },
        mounted: function () {
        },
        methods: {
            <#if user>
                submitForm: function () {
                    $.http.post("${params.contextPath}/web/meeting/check/invit/code.json", this.record).then(function (data) {
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        location.href = "${params.contextPath!}" + data.data;
                    });
                },
            </#if>
            loginForm:function () {
                $.http.post("${params.contextPath}/loginIn.json", this.login).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    location.href = "${params.contextPath!}/meeting/share/${params.mid!}.json";
                });
            }
        }
    });
</script>
</body>

</html>
