<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>设置邀请码</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="ui-form">
        <form class="layui-form" @submit.prevent="submitForm()" method="post">
            <input type="hidden" v-model="record.id" />
            <div class="layui-form-item">
                <label class="layui-form-label">邀请码<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.inviteCode" placeholder="请输入邀请码" class="layui-input"/>
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
                inviteCode:'',
            },
        },
        mounted: function () {
        },
        methods: {
            submitForm: function () {
                $.http.post("${params.contextPath}/web/meeting/modifyInviteCode.json", this.record).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    layer.alert(data.message || "操作成功", function () {
                        parent.app.loadData();
                        parent.layer.closeAll();
                    });
                });
            },
        }
    });
</script>
</body>

</html>
