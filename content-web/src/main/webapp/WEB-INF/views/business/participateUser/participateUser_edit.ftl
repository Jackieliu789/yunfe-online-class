<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>编辑课程参与用户(进入直播间上课的用户)</title>
	<#include "/common/resource.ftl">
	<script type="text/javascript">
		$(function () {
			<#if (params.id)??>
				$.ajaxRequest({
					url: '${params.contextPath}/web/participateUser/query.json',
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
		<form class="layui-form ajax-form" action="${params.contextPath}/web/participateUser/<#if (params.id)??>modify<#else>save</#if>.json" method="post">
			<input type="hidden" name="id" value="${params.id}" />
			<div class="layui-form-item">
                <label class="layui-form-label">主键<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="id" placeholder="请输入主键" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">直播间id<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="roomId" placeholder="请输入直播间id" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">用户id<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="userId" placeholder="请输入用户id" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">是否删除(1是，2否)<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="isDel" placeholder="请输入是否删除(1是，2否)" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">创建人id<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="createId" placeholder="请输入创建人id" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">创建时间<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="createTime" placeholder="请输入创建时间" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">修改人id<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="modifyId" placeholder="请输入修改人id" class="layui-input"/>
                </div>
            </div>
			<div class="layui-form-item">
                <label class="layui-form-label">修改时间<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="modifyTime" placeholder="请输入修改时间" class="layui-input"/>
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
