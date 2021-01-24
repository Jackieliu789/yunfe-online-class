<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>资源详细信息</title>
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
                            $("[field='" + key + "']").html(record[key]);
                        }
                    }
                });
            </#if>
        });
    </script>
</head>
<body>
    <div class="ui-table-div">
        <table class="layui-table ui-table">
            <tr>
                <th>名称</th>
                <td field="name">--</td>
            </tr>
            <tr>
                <th>编码</th>
                <td field="code">--</td>
            </tr>
            <tr>
                <th>URL</th>
                <td field="url">--</td>
            </tr>
            <tr>
                <th>状态</th>
                <td field="stateStr">--</td>
            </tr>
            <tr>
                <th>操作类型</th>
                <td field="operateTypeStr">--</td>
            </tr>
            <tr>
                <th>功能模块名称</th>
                <td field="operateName">--</td>
            </tr>
            <tr>
                <th>操作对象</th>
                <td field="operateObject">--</td>
            </tr>
            <tr>
                <th>日志对象名称</th>
                <td field="tableName">--</td>
            </tr>
            <tr>
                <th>备注</th>
                <td field="remark">--</td>
            </tr>
        </table>
    </div>
</body>

</html>
