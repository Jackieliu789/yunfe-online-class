<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑组织机构信息</title>
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
    <#include "/common/resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
    <script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url:'${params.contextPath}/web/organization/query.json',
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

                        if (record.parentOrg) {
                            $("[name='parentId']").val(record.parentOrg.id);
                            $("[name='parentName']").val(record.parentOrg.name);
                        }
                    }
                });
            </#if>
        });
    </script>
</head>
<body>
    <div class="ui-form">
        <form class="layui-form ajax-form" action="${params.contextPath}/web/organization/<#if (params.id)??>modify<#else>save</#if>.json" method="post">
            <input type="hidden" name="id" value=""/>
            <div class="layui-form-item">
                <label class="layui-form-label">名称<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="name" placeholder="请输入名称" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">编码<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <input type="text" name="code" placeholder="请输入编码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">上级组织</label>
                <div class="layui-input-block">
                    <input type="hidden" name="parentId" value="${params.parentId!'ROOT'}"/>
                    <input type="text" name="parentName" disabled="disabled" value="${params.parentName!'无上级组织'}" class="layui-input ui-disabled"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">类别<span class="ui-required">*</span></label>
                <div class="layui-input-block">
                    <select name="category" class="layui-select">
                        <option value="">请选择类别</option>
                        <option value="5">集团</option>
                        <option value="10">分公司</option>
                        <option value="15">部门</option>
                        <option value="20">科(室)</option>
                        <option value="25">其他</option>
                    </select>
                </div>
            </div>
            <#--<div class="layui-form-item">
                <label class="layui-form-label">所在区域</label>
                <div class="layui-input-block ui-more-parent">
					<input type="hidden" name="areaId" id="areaId" value="${params.areaId!''}"/>
                   	<input type="text" class="layui-input select-tree" readonly="readonly" name="areaName" id="areaName" p="check:false,id:'#areaId',name:'#areaName',url:'${params.contextPath}/web/area/tree.json'"/>
                </div>
	        </div>-->

            <div class="layui-form-item">
                <label class="layui-form-label">联系电话</label>
                <div class="layui-input-block">
                    <input type="text" name="telephone" placeholder="请输入联系电话" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">排序号</label>
                <div class="layui-input-block">
                    <input type="text" name="ordernum" placeholder="请输入排序号" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">备注</label>
                <div class="layui-input-block">
                    <textarea name="remark" class="layui-textarea" placeholder="请输入备注" maxlength="200"></textarea>
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
