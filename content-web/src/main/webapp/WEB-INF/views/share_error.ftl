<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>${params.websitName!}</title>
    <#include "/common/vue_resource.ftl">
    <style>
        .layui-form-item{width:300px;margin:20px auto;text-align:center;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="ui-form">
            <form class="layui-form" method="post">
                <h1 class="text-center" style="font-size:28px;margin:50px 0;">邀请码验证</h1>
                <div class="layui-form-item">
                    <#if (params.error)! == 1>直播间不存在</#if>
                    <#if (params.error)! == 2>请等待主讲人进入直播间</#if>
                    <#if (params.error)! == 3>该直播间已经结束直播</#if>
                    <#if (params.error)! == 4>请在直播课开始时间前10分钟进入教室<br/>开始时间为：${(params.date)!}</#if>
                </div>
            </form>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {},
    });
</script>
</body>

</html>
