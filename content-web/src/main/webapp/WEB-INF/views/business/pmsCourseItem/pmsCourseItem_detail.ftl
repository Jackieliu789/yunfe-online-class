<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>互动课堂-课节表详情</title>
    <#include "/common/resource.ftl">
    <script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url: '${params.contextPath}/web/pmsCourseItem/query.json',
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
            <th>主键</th>
            <td field="id">--</td>
        </tr>
        <tr>
            <th>课程id</th>
            <td field="courseId">--</td>
        </tr>
        <tr>
            <th>老师id</th>
            <td field="teacherId">--</td>
        </tr>
        <tr>
            <th>名称</th>
            <td field="name">--</td>
        </tr>
        <tr>
            <th>开始时间</th>
            <td field="beginDate">--</td>
        </tr>
        <tr>
            <th>结束时间</th>
            <td field="endDate">--</td>
        </tr>
        <tr>
            <th>排序</th>
            <td field="sort">--</td>
        </tr>
        <tr>
            <th>上课状态(1未开始，2授课中，3已结束)</th>
            <td field="classStatus">--</td>
        </tr>
        <tr>
            <th>班型(1-1v16，2-1vN)</th>
            <td field="type">--</td>
        </tr>
        <tr>
            <th>录制状态(1录制，2不录制)</th>
            <td field="recordStatus">--</td>
        </tr>
        <tr>
            <th>是否删除(1是，2否)</th>
            <td field="isDel">--</td>
        </tr>
        <tr>
            <th>创建人id</th>
            <td field="createId">--</td>
        </tr>
        <tr>
            <th>创建时间</th>
            <td field="createTime">--</td>
        </tr>
        <tr>
            <th>修改人id</th>
            <td field="modifyId">--</td>
        </tr>
        <tr>
            <th>修改时间</th>
            <td field="modifyTime">--</td>
        </tr>
    </table>
</div>
</body>

</html>
