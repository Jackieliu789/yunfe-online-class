<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑用户信息</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
    <script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url:'${params.contextPath}/web/user/query.json',
                    data:{id:"${params.id}"},
                    success:function (data) {
                        if (!data.success) {
                            layer.msg(data.message);
                            return;
                        }
                        var record = data.data;
                        for (var key in record) {
                            $("[name='"+key+"']").val(record[key]);
                        }
                        if (record.organization) {
                            $("#orgName").val(record.organization.name);
                        }
                    }
                });
            </#if>
        });
    </script>
</head>
<body>
    <div class="ui-form">
        <form class="layui-form ajax-form" action="${params.contextPath}/web/user/<#if (params.id)??>modify<#else>save</#if>.json" method="post">
            <input type="hidden" name="id" value=""/>
            <input type="hidden" name="orgId" value="${params.orgId!}"/>
            <div class="layui-form-item">
                <label class="layui-form-label">所属单位</label>
                <div class="layui-input-block">
                    <input type="text" id="orgName" class="layui-input ui-disabled" value="${params.orgName!}" disabled="disabled"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">姓名<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="name" placeholder="请输入姓名" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">账号<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="policeNo" placeholder="请输入账号" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">职务<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="hidden" name="positionId" id="positionId"  class="layui-input">
                   	<input type="text" class="layui-input select-tree" readonly="readonly" placeholder="请选择职务" name="positionName" id="positionName" p="check:false,id:'#positionId',name:'#positionName',url:'${params.contextPath}/web/position/queryTree.json'"/> 
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">手机号码<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="phone" placeholder="请输入手机号码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">身份证号<#--<span class="ui-required">*</span>--></label>
                <div class="layui-input-block">
                    <input type="text" name="idcard" placeholder="请输入身份证号" class="layui-input">
                </div>
            </div>
            <#if !(params.id??)>
                <div class="layui-form-item">
                    <label class="layui-form-label">登录密码<span class="ui-required">*</span></label>
                    <div class="layui-input-block">
                        <input type="password" name="pass" placeholder="请输入登录密码" class="layui-input">
                    </div>
                </div>
            </#if>
            <div class="layui-form-item">
                <label class="layui-form-label">性别</label>
                <div class="layui-input-block">
                    <select name="gender" class="layui-select">
                        <option value="3">未知</option>
                        <option value="1">男</option>
                        <option value="2">女</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">Email</label>
                <div class="layui-input-block">
                    <input type="text" name="email" placeholder="请输入Email" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">座机号码</label>
                <div class="layui-input-block">
                    <input type="text" name="telephone" placeholder="请输入座机号码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <div class="layui-input-block">
                    <input type="submit" value="保存" class="layui-btn"/>
                </div>
            </div>
        </form>
    </div>
</body>

</html>
