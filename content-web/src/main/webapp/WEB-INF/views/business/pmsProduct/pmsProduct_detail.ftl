<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>单品表详情</title>
    <#include "/common/resource.ftl">
    <script type="text/javascript">
        $(function () {
            <#if (params.id)??>
                $.ajaxRequest({
                    url: '${params.contextPath}/web/pmsProduct/query.json',
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
            <th>名称</th>
            <td field="name">--</td>
        </tr>
        <tr>
            <th>试看内容</th>
            <td field="trySeeContent">--</td>
        </tr>
        <tr>
            <th>定价</th>
            <td field="price">--</td>
        </tr>
        <tr>
            <th>订阅总额</th>
            <td field="amount">--</td>
        </tr>
        <tr>
            <th>上架时间</th>
            <td field="shelfTime">--</td>
        </tr>
        <tr>
            <th>封面路径</th>
            <td field="coverPath">--</td>
        </tr>
        <tr>
            <th>订阅量</th>
            <td field="subscribeNum">--</td>
        </tr>
        <tr>
            <th>上架状态(1上架，2下架)</th>
            <td field="shelfStatus">--</td>
        </tr>
        <tr>
            <th>类别(1图文，2音频，3视频)</th>
            <td field="category">--</td>
        </tr>
        <tr>
            <th>点击量</th>
            <td field="clickNum">--</td>
        </tr>
        <tr>
            <th>是否单卖</th>
            <td field="sellAloneStatus">--</td>
        </tr>
        <tr>
            <th>试听音频路径</th>
            <td field="tryAudioPath">--</td>
        </tr>
        <tr>
            <th>视频贴片路径</th>
            <td field="videoPatchPath">--</td>
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
