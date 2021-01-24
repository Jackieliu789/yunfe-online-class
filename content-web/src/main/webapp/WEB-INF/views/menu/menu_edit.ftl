<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑菜单信息</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
    <script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url: '${params.contextPath}/web/menu/query.json',
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
                        if (record.parent) {
                            $("#parentName").val(record.parent.name);
                        }
                    }
                });
            </#if>
        });
    </script>
</head>
<body>
	<div class="ui-form">
		<form class="layui-form ajax-form" action="${params.contextPath}/web/menu/<#if (params.id)??>modify<#else>save</#if>.json" method="post">
			<input type="hidden" name="id" value="${params.id}" />
			<div class="layui-form-item">
                <label class="layui-form-label">菜单名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
					<input type="text" class="layui-input" placeholder="请输入菜单名称" name="name">
                </div>
	        </div>
        	<div class="layui-form-item">
                <label class="layui-form-label">上级菜单</label>
                <div class="layui-input-block ui-more-parent">
					<input type="hidden" name="parentId" id="parentId" value="ROOT"/>
                   	<input type="text" class="layui-input select-tree" readonly="readonly" id="parentName" p="check:false,id:'#parentId',name:'#parentName',url:'${params.contextPath}/web/menu/tree.json'"/>
                </div>
	        </div>
        	<div class="layui-form-item">
                <label class="layui-form-label">菜单类型<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                	<select class="layui-selectnew" name="category">
                	    <option value="">请选择类型</option>
	               		<option value="1">菜单</option>
	                   	<option value="2">按钮</option>
	                   	<option value="3">开关</option>
	                   	<option value="5">小程序</option>
	                   	<option value="4">其它</option>
		            </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">菜单编号<span class="ui-request">*</span></label>
                <div class="layui-input-block">
			        <input type="text" class="layui-input" placeholder="请输入菜单编号" name="code">
                </div>
	        </div>	
             
            <div class="layui-form-item">
                <label class="layui-form-label">图标路径</label>
                <div class="layui-input-block">
			        <input type="text" class="layui-input" placeholder="请输入图标路径，可输入100个字符" name="icon" >
                </div>
	        </div>
            <div class="layui-form-item">
                <label class="layui-form-label">排序序号<span class="ui-request">*</span></label>
                <div class="layui-input-block">
				    <input type="text" class="layui-input" placeholder="请输入排序序号" name="orderBy" >
                </div>
	        </div>
            <div class="layui-form-item">
                <label class="layui-form-label">请求路径</label>
                <div class="layui-input-block">
				    <input type="text" class="layui-input" placeholder="请输入请求路径" name="url" >
                </div>
	        </div>
	        <div class="layui-form-item">
                <label class="layui-form-label">描述</label>
                <div class="layui-input-block">
				    <textarea class="layui-textarea" name="remark" placeholder="菜单说明，可输入100个字符"></textarea>
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
