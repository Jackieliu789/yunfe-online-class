<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>编辑角色信息</title> <#include "/common/resource.ftl">
<script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url: '${params.contextPath}/web/role/query.json',
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
		<form class="layui-form ajax-form"
			action="${params.contextPath}/web/role/<#if (params.id)??>modify<#else>save</#if>.json"
			method="post">
			<input type="hidden" name="id" value="${params.id}" />
			<div class="layui-form-item">
				<label class="layui-form-label">角色名称<span class="ui-request">*</span></label>
				<div class="layui-input-block">
					<input type="text" name="name" placeholder="请输入角色名称"
						class="layui-input">
				</div>
			</div>

 			<div class="layui-form-item">
				<label class="layui-form-label">系统角色<span class="ui-request">*</span></label>
				<div class="layui-input-block">
					<select class="layui-selectnew" name="isSys">
						<option value="">--请选择--</option>
						<option value="1">是</option>
						<option value="2">否</option>
					</select>
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">备注</label>
				<div class="layui-input-block">
					<textarea name="remark" placeholder="请输入备注内容"
						class="layui-textarea"></textarea>
				</div>
			</div>

			<div class="layui-form-item">
				<div class="layui-input-block">
					<input type="submit" value="保存" class="layui-btn" />
				</div>
			</div>
		</form>
	</div>
</body>

</html>
