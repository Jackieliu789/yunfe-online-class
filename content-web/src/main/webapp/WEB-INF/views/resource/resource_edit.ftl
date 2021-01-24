<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑资源信息</title>
    <#include "/common/resource.ftl">
    <script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url: '${params.contextPath}/web/resource/query.json',
                    data: {id: "${params.id}"},
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
            </#if>
        });
    </script>
</head>
<body>
    <div class="ui-form">
        <form class="layui-form ajax-form" action="${params.contextPath}/web/resource/<#if (params.id)??>modify<#else>save</#if>.json" method="post">
            <input type="hidden" name="id" value="${params.id}"/>
            <div class="layui-form-item">
                <label class="layui-form-label">资源名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="name" placeholder="请输入资源名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">资源编码<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="code" placeholder="请输入资源编码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">URL<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="url" placeholder="请输入资源URL" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">模块名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="functionName" placeholder="请输入模块名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">功能类型<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                	<select class="layui-selectnew" name="operateType">
                	
	               		<option value="">--请选择--</option>
	                   	<option value="1">查询</option>
	                   	<option value="2">新增</option>
	                   	<option value="3">修改</option>
	                   	<option value="4">删除</option>
		            </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">操作对象<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                	<input type="text" name="operateObject" placeholder="如组织机构、用户等业务对象" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">操作表<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="tableName" placeholder="如组织机构表、用户表等" class="layui-input">
                </div>
            </div>
             <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea name="remark" placeholder="请输入备注内容" class="layui-textarea" maxlength="200"></textarea>
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
