<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>信息列表选择</title>
	<#include "/common/resource.ftl">
    <style type="text/css">
        body{background:#EBEDED;}
        .ui-searchs {margin:2px 5px;}
        .ui-searchs div{display:inline-block;vertical-align:top;}
        .ui-searchs .left input{height:25px;line-height:25px;padding:0px 2px;}
    </style>
</head>
<body>

<#if params.model! == 'customer'><#--客户-->
    <div class="ui-searchs">
        <div class="left"><input type="text" name="name" value="" placeholder="名称"/></div>
        <div class="right"><input type="button" value="搜索" class="layui-btn layui-btn-danger search-button2"/></div>
    </div>
    <table id="ui-datagrid" class="ui-datagrid" options="url:'${params.contextPath}/web/customer/list.json'">
        <thead>
            <tr>
                <th data-options="field:'id',checkbox:true"></th>
                <th data-options="field:'name',width:100,align:'left'">客户名称</th>
                <th data-options="field:'linkman',width:100,align:'left'">客户联系人</th>
                <th data-options="field:'maxNeedNum',width:100,align:'left',formatter:formatNeedNum">需求数量(㎡)</th>
            </tr>
        </thead>
    </table>
<#elseif params.model! == 'contract'><#--合同-->
    <div class="ui-searchs">
        <div class="left"><input type="text" name="contractNo" value="" placeholder="编号"/></div>
        <div class="right"><input type="button" value="搜索" class="layui-btn layui-btn-danger search-button2"/></div>
    </div>
    <table id="ui-datagrid" class="ui-datagrid" options="url:'${params.contextPath}/web/contract/list.json'">
        <thead>
            <tr>
                <th data-options="field:'id',checkbox:true"></th>
                <th data-options="field:'contractNo',width:120,align:'left'">合同编号</th>
                <th data-options="field:'customerName',width:150,align:'left'">品牌名称</th>
                <th data-options="field:'statusStr',width:110,align:'left'">合同状态</th>
            </tr>
        </thead>
    </table>
</#if>

<script type="text/javascript">
    function getSearchParams() {
        return {
            name: $("input[name='name']").val() || "",
            contractNo: $("input[name='contractNo']").val() || ""
        };
    }
    var scoreType = "";
    function formatScoreType(val, row) {
        if (!scoreType) {
            scoreType = DictionaryHelper.getDictionaryOperator(Dictionary.scoreType);
        }
        return scoreType.getDictionaryItemName(row.scoreType);
    }

    function formatNeedNum(val, row) {
        return (row.minNeedNum || "--") + " ~ " + (row.maxNeedNum || "--");
    }

    var onClickRow = function (rowIndex, rowData) {
        //console.log("rowIndex = " + rowIndex);
        //console.log("rowData = " + JSON.stringify(rowData));
        rowData._model = '${params.model!}';
        LocalStorage.sendData("${params.handlerId!'single_select'}", rowData);
        parent.FormManager.closeSingleModelSelect();
    };

    var datagridParams = {
        singleSelect: true,
        rownumbers: true,
        method: "post",
        fitColumns: true,
        pagination: true,
        pageSize: 5,
        width: "100%",
        height: "224px",
        striped: true,
        pageList: [5,10]
    };
    $(function () {
        var paramsStr = $(".ui-datagrid").attr("options");
        var params = eval('({' + paramsStr + '})');
        $.extend(params, datagridParams);
        var options = JSON.stringify(params).replace("{", "").replace("}", "");
        options += ',onLoadSuccess: DataGrid.noRecord,onClickRow:onClickRow';
        $("#ui-datagrid").addClass("easyui-datagrid")
                .attr('data-options', options)
                .datagrid({queryParams: getSearchParams()});

        $(".search-button2").click(function () {
            var table = $("#ui-datagrid");
            table.datagrid("options").pageNumber = 1;
            table.datagrid({queryParams: getSearchParams()});
        });
    });
</script>
</body>

</html>
