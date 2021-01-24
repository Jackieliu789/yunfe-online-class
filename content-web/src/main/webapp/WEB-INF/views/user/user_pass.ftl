<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>修改密码</title>
    <#include "/common/resource.ftl">
</head>
<body>
<div class="ui-body profile-form" id="password">
    <div class="ui-form">
        <form class="layui-form ajax-form" action="${params.contextPath}/web/user/modifyPass.json" method="post">
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <span class="ui-required">
                        当前账号的密码口令太弱，请修改密码<br/><br/>
                        新密码规则为：<br/><br/><b>大写字母、小写字母、特殊字符、数字 两种或两种以上组合匹配，6-18位</b>
                    </span>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">原密码<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="password" name="oldPass" placeholder="请输入原密码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">新密码<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="password" name="newPass" placeholder="请输入新密码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">确认密码<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="password" name="confirmPass" placeholder="请输入确认密码" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <input type="button" value="保存" class="layui-btn pass-button"/>
                </div>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
    $(document).ready(function () {
        $(".ui-body").height($(window).height() - 50);
        //初始化数据
        $.ajaxRequest({
            url: "${params.contextPath}/web/user/query.json",
            data: {id: "${user.id!}"},
            async: true,
            success: function (data) {
                if (!data.success) {
                    $.message(data.message);
                    return;
                }
                var record = data.data;
                for (var key in record) {
                    $("[name='" + key + "']").val(record[key]);
                }
            }
        });
        //保存个人资料
        $(".info-button").click(function () {
            var form = $(this).parents("form");
            $.ajaxRequest({
                url: form.attr("action"),
                data: form.serialize(),
                async: true,
                success: function (data) {
                    $.message(data.message);
                }
            });
        });
        //修改密码
        $(".pass-button").click(function () {
            var form = $(this).parents("form");
            $.ajaxRequest({
                url: form.attr("action"),
                data: form.serialize(),
                async: true,
                success: function (data) {
                    $.message(data.message);
                    if (data.success) {
                        parent.layer.closeAll();
                        $("[name='oldPass']").val("");
                        $("[name='newPass']").val("");
                        $("[name='confirmPass']").val("");
                    }
                }
            });
        });
    });
</script>
</body>
</html>
