var layer = layui.layer, laydate = layui.laydate, laytpl = layui.laytpl;
try {
    $.template = template;
} catch (e) {
    console.log(e);
}
var ueditorOptions = {
    toolbars: [
        [
            //'anchor', //锚点
            'undo', //撤销
            'redo', //重做
            'bold', //加粗
            'indent', //首行缩进
            //'snapscreen', //截图
            'italic', //斜体
            'underline', //下划线
            'strikethrough', //删除线
            'subscript', //下标
            'fontborder', //字符边框
            'superscript', //上标
            'formatmatch', //格式刷
            //'source', //源代码
            'blockquote', //引用
            'pasteplain', //纯文本粘贴模式
            'selectall', //全选
            'print', //打印
            'preview', //预览
            'horizontal', //分隔线
            'removeformat', //清除格式
            'time', //时间
            'date', //日期
            'unlink', //取消链接
            'insertrow', //前插入行
            'insertcol', //前插入列
            'mergeright', //右合并单元格
            'mergedown', //下合并单元格
            'deleterow', //删除行
            'deletecol', //删除列
            'splittorows', //拆分成行
            'splittocols', //拆分成列
            'splittocells', //完全拆分单元格
            'deletecaption', //删除表格标题
            'inserttitle', //插入标题
            'mergecells', //合并多个单元格
            'deletetable', //删除表格
            'cleardoc', //清空文档
            'insertparagraphbeforetable', //"表格前插入行"
            //'insertcode', //代码语言
            'fontfamily', //字体
            'fontsize', //字号
            'paragraph', //段落格式
            //'simpleupload', //单图上传
            //'insertimage', //多图上传
            'edittable', //表格属性
            'edittd', //单元格属性
            'link', //超链接
            //'emotion', //表情
            'spechars', //特殊字符
            'searchreplace', //查询替换
            //'map', //Baidu地图
            //'gmap', //Google地图
            //'insertvideo', //视频
            //'help', //帮助
            'justifyleft', //居左对齐
            'justifyright', //居右对齐
            'justifycenter', //居中对齐
            'justifyjustify', //两端对齐
            'forecolor', //字体颜色
            'backcolor', //背景色
            'insertorderedlist', //有序列表
            'insertunorderedlist', //无序列表
            'fullscreen', //全屏
            'directionalityltr', //从左向右输入
            'directionalityrtl', //从右向左输入
            'rowspacingtop', //段前距
            'rowspacingbottom', //段后距
            //'pagebreak', //分页
            //'insertframe', //插入Iframe
            //'imagenone', //默认
            //'imageleft', //左浮动
            //'imageright', //右浮动
            //'attachment', //附件
            'imagecenter', //居中
            //'wordimage', //图片转存
            'lineheight', //行间距
            'edittip ', //编辑提示
            'customstyle', //自定义标题
            'autotypeset', //自动排版
            //'webapp', //百度应用
            'touppercase', //字母大写
            'tolowercase', //字母小写
            //'background', //背景
            //'template', //模板
            //'scrawl', //涂鸦
            //'music', //音乐
            'inserttable', //插入表格
            //'drafts', // 从草稿箱加载
            //'charts', // 图表
        ]
    ],
    initialContent: "",
    autoClearinitialContent: false,//获取光标是，是否自动清空初始化数据
    elementPathEnabled: false,//是否展示元素路径
    wordCount: false,//是否计数
    autoHeightEnabled: false,//高度是否自动增长
    textarea: "ueditorContent"//后台接受UEditor的数据的参数名称
};
/**
 * 字典值
 */
var Dictionary = {
    buildingLabel: 'buildingLabel', //楼宇标签
    industry: 'industry', //行业
    customerStatus: 'customerStatus', //客户状态
    visitChannel: 'visitChannel', //来访渠道
    priceUnit: 'priceUnit', //价格单位
    decorate: 'decorate', //装修
    houseLabel: 'houseLabel', //房源标签
    visitType: 'visitType', //拜访方式
    paymentDateUnit: 'paymentDateUnit', //提前付款时间单位
    discountType: 'discountType', //优惠类型
    contractLabel: 'contractLabel', //合同标签
    leaseDivideType: 'leaseDivideType', //租期划分方式
    currency: 'currency', //币种
    supplierLevel: 'supplierLevel', //供应商级次
};

if (!window.console || !window.console.log) {
    window.console = {
        log: function (msg) {
            return;
        }
    };
}

var UUID = {
    S4: function () {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
    },
    guid: function () {
        return this.S4() + this.S4() + "-" + this.S4() + "-" + this.S4() + "-" + this.S4() + "-" + this.S4() + this.S4() + this.S4();
    }
};

$.getUrl = function (url, paramName, paramValue) {
    if (url.indexOf("?") != -1) {
        url += "&" + paramName + "=" + paramValue;
    } else {
        url += "?" + paramName + "=" + paramValue;
    }
    return url;
};

//为Array增加去除重复元素的方法
Array.prototype.removeDuplicate = function () {
    var res = [this[0]];
    for (var i = 1; i < this.length; i++) {
        var repeat = false;
        for (var j = 0; j < res.length; j++) {
            if (this[i] == res[j]) {
                repeat = true;
                break;
            }
        }
        if (!repeat) {
            res.push(this[i]);
        }
    }
    return res;
}

var MapUtils = {
    gcj02_to_bd09: function (gg_lat, gg_lon) {
        var x_pi = 3.14159265358979324 * 3000.0 / 180.0;
        var x = gg_lon, y = gg_lat;
        var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * x_pi);
        var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * x_pi);
        var bd_lon = z * Math.cos(theta) + 0.0065;
        var bd_lat = z * Math.sin(theta) + 0.006;

        var bd_obj = new Object();
        bd_obj.lon = bd_lon;
        bd_obj.lat = bd_lat;

        return bd_obj;
    }
};

var DialogManager = {
    openDialog: function (p) {
        var params = eval("({" + (p || "") + "})");
        this.open(params);
        /*params.type = 2;
        params.shadeClose = true;
        params.shade = 0.2;
        params.closeBtn = 1;
        params.area = [params.width || '800px', params.height || "500px"];
        params.content = encodeURI(encodeURI(params.url));
        layer.open(params);*/
    },
    open: function (params) {
        var _default = {
            type: 2,
            shadeClose: true,
            shade: 0.2,
            closeBtn: 1,
            area: [params.width || '800px', params.height || "500px"],
            content: encodeURI(encodeURI(params.url))
        };
        $.extend(_default, params);
        layer.open(_default);
    },
    openHtml: function (params) {
        var _default = {
            type: 1,
            shadeClose: true,
            shade: 0.2,
            closeBtn: 1,
            area: [params.width || '800px', params.height || "500px"],
            content: params.html
        };
        $.extend(_default, params);
        layer.open(_default);
    },
    singleSelected: function (p) {
        var id = DataGrid.getSelectId();
        if (id == "" || id == undefined) {
            layer.msg("请选择一行!");
            return false;
        }
        var params = eval("({" + (p || "") + "})");

        var aliasId = params.aid ? params.aid : "id";
        params.url = $.getUrl(params.url, aliasId, id);
        this.openDialog(JSON.stringify(params).replace("{", "").replace("}", ""));
    },
    singleSelected2: function (obj, callBack) {
        var row = DataGrid.getSelectRow();
        if (row == "") {
            $.message("请选中一行数据");
            return;
        }
        var p = obj.attr("p");
        var params = eval("({" + (p || "") + "})");
        var success = callBack(row, params);
        if (!success) {
            return;
        }
        DialogManager.openDialog(JSON.stringify(params).replace("{", "").replace("}", ""));
    },
    closeAll: function () {
        layer.closeAll();
    }
};

$.ajaxRequest = function (params) {
    //params.loading = params.loading || true;
    var _init_param_json = {
        loading: true,
        async: true,
        dataType: "json",
        data: {}
    };
    $.extend(_init_param_json, params);
    if (_init_param_json.loading) {
        $.loading();
    }
    _init_param_json.data._t = new Date().getTime();
    $.ajax({
        url: _init_param_json.url,
        data: _init_param_json.data,
        type: "post",
        dataType: _init_param_json.dataType,
        async: _init_param_json.async,
        success: function (data) {
            $.closeLoading();
            params.success(data);
        }
    });
};

//全局loading
var _loading_id;
$.loading = function () {
    if (_loading_id) {
        layer.close(_loading_id);
        _loading_id = false;
    }
    _loading_id = layer.load(1, {shade: [0.1, "#000"]});
};
$.closeLoading = function () {
    //layer.closeAll();
    //alert("aaaa");
    if (_loading_id) {
        layer.close(_loading_id);
        _loading_id = false;
    }
};

$.fn.formSubmit = function (json) {
    var obj = $(this);
    obj.find("input[type='submit']").prop("disabled", "disabled");
    $.loading();
    var params = {
        parentRefresh: true,
        parentClose: true,
        warnTip: 'msg',
        callBack:function (data) {

        }
    };
    if (json) {
        $.extend(params, json);
    }
    obj.ajaxSubmit({
        type: "post",
        url: obj.attr("action"),
        dataType: "json",
        success: function (data) {
            $.closeLoading();
            obj.find("input[type='submit']").removeAttr("disabled");
            if (data.success) {
                var alt = layer.alert(data.message || "操作成功", function () {
                    //obj.resetForm();
                    params.callBack(data);
                    try {
                        if (params.parentClose) {
                            parent.layer.closeAll();
                        }
                        if (params.parentRefresh) {
                            parent.DataGrid.refresh();
                        }
                    } catch (e) {
                        if (params.parentClose) {
                            parent.layer.closeAll();
                        }
                    }
                    layer.close(alt);
                });
                return false;
            }
            if (params.warnTip == 'msg') {
                layer.msg(data.message);
            } else if (params.warnTip == 'alert') {
                layer.alert(data.message);
            }
        }
    });
    return false;
};

$.message = function (message) {
    layer.msg(message);
};

var DataGrid = {
    renderId: '#datagrid',
    noRecord: function (data) {
        if (data.rows.length <= 0) {
            //$.message("没有符合条件的数据");
            var body = $(this).data().datagrid.dc.body2;
            var colnum = body.find('table tbody').find("tr:eq(0)").find("td");
            body.find('table tbody').append('<tr><td width="100%" style="line-height:26px;text-align:center;border-left:1px dotted #ccc;" colspan="' + colnum.length + '"><span>暂无数据</span></td></tr>');
        }
    },
    loadFilter: function (data) {
        if (!data.success) {
            $.message(data.message);
            data.rows = [];
            data.total = 0;
        }
        return data;
    },
    onClickRow: function (rowIndex, rowData) {
        DataGrid.getTable().datagrid('clearChecked');
        DataGrid.getTable().datagrid('checkRow', rowIndex);
    },
    getTable: function () {
        return $(this.renderId);
    },
    getCheckedIds: function () {
        var array = new Array();
        var rows = this.getTable().datagrid('getChecked');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                array.push(rows[i].id);
            }
        }
        return array;
    },
    getCheckedValues: function (field) {
        if (!field) {
            return getCheckedIds();
        }
        var array = new Array();
        var rows = this.getTable().datagrid('getChecked');
        if (rows.length > 0) {
            for (var i = 0; i < rows.length; i++) {
                rows[i][field] && array.push(rows[i][field]);
            }
        }
        return array;
    },
    getCheckedRows: function () {
        return this.getTable().datagrid('getChecked');
    },
    getSelectId: function () {
        var row = this.getTable().datagrid('getSelected');
        return row ? row.id : "";
    },
    getSelectValue: function (field) {
        field = field || 'id';
        var row = this.getTable().datagrid('getSelected');
        return row ? row[field] : "";
    },
    getSelectRow: function () {
        return this.getTable().datagrid('getSelected') || "";
    },
    refresh: function () {
        var table = this.getTable();
        table.datagrid("options").pageNumber = 1;
        table.datagrid({queryParams: this.getParams()});
    },
    reload: function () {
        this.getTable().datagrid('reload');
    },
    options: {},
    defalutOptions: {
        checkOnSelect: true,
        selectOnCheck: false,
        singleSelect: true,
        rownumbers: true,
        method: 'post',
        fitColumns: true,
        pagination: true,
        pageSize: 20
    },
    getParams: function () {
        var queryParams = this.options.params || false;
        if (queryParams) {
            return window[queryParams]();
        }
        return {};
    },
    initParams: function () {
        var table = this.getTable();

        var options_str = table.attr("options") || "";
        if (options_str == "") {
            return;
        }
        var options = eval('({' + options_str + '})');
        var tempOptions = {};
        $.extend(tempOptions, this.defalutOptions);
        $.extend(tempOptions, options);
        options = tempOptions;
        options.width = options.width || "100%";
        if (!options.height) {
            var windowHeight = $(window).height();
            var operationHeight = $("div.ui-operation").outerHeight();
            var searchHeight = $("div.ui-operation .ui-search-items").outerHeight();
            var gridHeight = windowHeight - operationHeight - 23;
            options.height = gridHeight + "px";
            $(".ui-table-left div.ui-body").height(gridHeight + searchHeight - 1);
        }

        var str = JSON.stringify(options).replace("{", "").replace("}", "");
        if (!options.onLoadSuccess) {
            str += ',onLoadSuccess:DataGrid.noRecord';
        } else {
            str += ',onLoadSuccess:' + options.onLoadSuccess;
        }
        if (options.dblClickRow) {
            str += ',onDblClickRow:' + options.dblClickRow;
        }
        if (options.onSelect) {
            str += ',onSelect:' + options.onSelect;
        }
        str += ',onClickRow:DataGrid.onClickRow';
        str += ',loadFilter:DataGrid.loadFilter';
        str += ',striped:true';
        table.removeAttr("options").addClass("easyui-datagrid")
            .attr("data-options", str);
        //$.message(table.attr("data-options"));
        this.options = options;
    },
    init: function () {
        var table = this.getTable() || "";
        if (table == "" || table.length <= 0) {
            return;
        }
        this.initParams();
        table.datagrid({
            queryParams:this.getParams()
        });
    }
};

var FormManager = {
    init: function () {
        $("body").bind("click", function (evt) {
            if ($(evt.target).closest(".ui-more").length == 0) {
                $('.ui-more').hide();
            }
        });
    },
    //json格式：check:false,chkboxType:{"Y":"ps","N":"ps"},id:'hiddenId',name:'showName',url:''
    selectTree: function (obj, paramsStr) {//下拉选择tree，支持单选和多选
        var params = eval("({" + paramsStr + "})");
        var setting = {
            check: {enable: false, chkboxType: {"Y": "", "N": ""}},
            data: {simpleData: {enable: true}},
            callback: {}
        };
        if (params.check === true) {
            setting.check.enable = true;
            if (params.chkboxType) {
                setting.check.chkboxType = params.chkboxType;
            }
        }
        var parent = $(obj).parent();
        var moreDiv = parent.find(".ui-more");
        if (moreDiv.length <= 0) {
            $(obj).after('<div class="ui-more"><ul id="_select_tree" class="ztree"></ul></div>');
            moreDiv = parent.find(".ui-more");
        }
        moreDiv.width(parent.width() - 22);
        if (moreDiv.is(":visible")) {
            moreDiv.toggle();
            return;
        }
        moreDiv.toggle();

        setting.callback.onClick = function (event, treeId, treeNode) {
            if (setting.check.enable) {
                return;
            }
            $(params.id).val(treeNode.id);
            $(params.name).val(treeNode.name);
            moreDiv.hide();
        };
        setting.callback.onCheck = function (event, treeId, treeNode) {
            if (!setting.check.enable) {
                return;
            }
            var zTree = $.fn.zTree.getZTreeObj("_select_tree");
            var checkeds = zTree.getCheckedNodes();
            var ids = new Array(), names = new Array();
            for (var i = 0; i < checkeds.length; i++) {
                ids.push(checkeds[i].id);
                names.push(checkeds[i].name);
            }
            $(params.id).val(ids.join(","));
            $(params.name).val(names.join("，"));
        };

        var treeContent = $("#_select_tree").html() || "";
        if (treeContent == "") {
            $.ajaxRequest({
                url: params.url,
                success: function (data) {
                    $.fn.zTree.init($("#_select_tree"), setting, data.data);
                    showData();
                }
            });
        }

        function showData() {
            //回显数据
            var idsStr = $(params.id).val() || "";
            if (idsStr == "") {
                return;
            }
            var zTree = $.fn.zTree.getZTreeObj("_select_tree");
            var nodes = zTree.transformToArray(zTree.getNodes()); //所有的节点
            if (setting.check.enable) {
                var idArray = idsStr.split(",");
                for (var i = 0; i < nodes.length; i++) {
                    var nodeid = nodes[i].id;
                    for (var j = 0; j < idArray.length; j++) {
                        if (idArray[j] == nodeid) {
                            zTree.checkNode(nodes[i], true, false);
                            break;
                        }
                    }
                }
            } else {
                for (var i = 0; i < nodes.length; i++) {
                    var item = nodes[i];
                    if (item.id != idsStr) {
                        continue;
                    }
                    zTree.expandNode(item, true);
                    zTree.selectNode(item);
                    break;
                }
            }
        }//end showData
    },
    //json格式：model:'hospital',handlerId:'handlerId'
    singleModelSelect: function (obj, paramsStr) {//单选实体列表页面打开
        var params = eval("({" + paramsStr + "})");
        var parent = $(obj).parent();
        var moreDiv = parent.find(".ui-more");
        if (moreDiv.length <= 0) {
            var url = top.domain + "/view/business/common/single_select_list.htm?model={model}&handlerId={handlerId}".format(params);
            $(obj).after('<div class="ui-more" style="padding:0px;height:265px;"><iframe src="{url}" style="height:257px;"/></div>'.format({url: url}));
            moreDiv = parent.find(".ui-more");
        }
        $(".ui-more").removeClass("active");

        var width = parent.width() - 2;
        moreDiv.width(width > 400 ? width : 400).addClass("active");
        if (moreDiv.is(":visible")) {
            moreDiv.toggle();
            return;
        }
        moreDiv.toggle();
    },
    closeSingleModelSelect: function () {
        $(".ui-more.active").hide();
    }
};

/**
 * 页面省市区元素处理
 */
var AreaHelper = {
    areaCacheId: '_areas_',
    cacheArea: function (data) {//缓存省市区值，在首页加载进来
        var result = {};
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            result[item.id] = item;
        }
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            var parent = result[item.parentId];
            if (!parent) {
                item.isRoot = true;
                continue;
            }
            item.isRoot = false;
            var childArray = parent.child;
            if (!childArray) {
                childArray = [];
                parent.child = childArray;
            }
            childArray.push(item);
        }
        LocalStorage.setData(this.areaCacheId, result);
    },
    getOptionStr: function (parentAreaId) {
        var result = "<option value=''>请选择</option>";
        var list = LocalStorage.getData(this.areaCacheId);
        var childs = [];
        if (!parentAreaId) {//一级节点
            for (var key in list) {
                var item = list[key];
                if (item.isRoot) {
                    childs.push(item);
                }
            }
        } else {
            var parent = list[parentAreaId] || {};
            childs = parent.child || [];
        }
        for (var i = 0; i < childs.length; i++) {
            result += "<option value='{id}'>{name}</option>".format(childs[i]);
        }
        return result;
    },
    /**
     * 初始化页面
     * @param params
     * {
     *      domObj:$('.class'),
     *      data:[{id: '123', name: '安徽省'}, {id: '123', name: '合肥市'}]
     *  }
     */
    initPage: function (params) {
        var seletArray = params.domObj.children("select");
        seletArray.eq(0).html("<option value=''>请选择</option>");
        var initAreas = params.data;
        if (initAreas && initAreas.length > 0) {
            for (var i = 0; i < initAreas.length; i++) {
                var area = initAreas[i];
                var parentId = null;
                if (i != 0) {
                    parentId = initAreas[i - 1].id;
                }
                seletArray.eq(i).html(this.getOptionStr(parentId)).val(area.id);
            }
        } else {
            seletArray.eq(0).html(this.getOptionStr());
        }
        params.domObj.find("input[name='areas']").val(JSON.stringify(params.data || []));
        this.addChange(params)
    },
    addChange: function (params) {//添加change事件
        var seletArray = params.domObj.children("select");
        seletArray.unbind().change(function () {
            var value = $(this).val() || "";
            $(this).nextAll("select").html("");
            if (value) {
                $(this).next("select").html(AreaHelper.getOptionStr(value));
            }

            var data = [];
            $(this).parent().children("select").each(function () {
                var value = $(this).val() || "";
                if (!value) {
                    return false;
                }
                var name = $(this).find("option:selected").text();
                data.push({id: value, name: name});
            });
            $(this).parent().find("input[name='areas']").val(JSON.stringify(data));
        });
    }
};

/**
 * 页面字典元素处理
 */
var DictionaryHelper = {
    dictionaryCacheId: '_dictionary_',
    cacheDictionary: function (data) {//缓存字典项值，在首页加载进来
        var json = {};
        for (var i = 0; i < data.length; i++) {
            var item = data[i];
            var array = json[item.dictionary.value];
            if (!array) {
                array = {};
                json[item.dictionary.value] = array;
            }
            array[item.value] = item;
        }
        LocalStorage.setData(this.dictionaryCacheId, json);
    },
    getDictionaryOperator: function (dictionaryValue) {//获取数据字典操作对象
        var dictionaryItems = LocalStorage.getData(this.dictionaryCacheId)[dictionaryValue];
        var dictionaryOperator = new DictionaryOperator();
        dictionaryOperator.setDictionaryItemMap(dictionaryItems, dictionaryValue);
        return dictionaryOperator;
    },
    /**
     * 装配字典项为dom元素，如option, checkbox, radio
     * @param params 参数：
     * {
     *  dictionaryValue:'字典值',
     *  domType:'装配类型，取值为：option,checkbox,radio',
     *  domName:'dom元素名称',
     *  domClass:'dom元素class名称',
     *  domOther:'dom元素其他属性',
     *  selfAssemble:'function(dictionaryItems){},自定义装配函数，定义此项则domType和domName失效'
     * }
     */
    assemble: function (params) {
        if (StringUtils.isEmpty(params.dictionaryValue)) {
            console.log("dictionaryValue is empty");
            return;
        }
        var data = LocalStorage.getData(this.dictionaryCacheId);
        var dictionaryItems = [];
        try {
            dictionaryItems = data[params.dictionaryValue];
        } catch (e) {
            console.log(e);
            return;
        }
        if (params.selfAssemble) {
            params.selfAssemble(dictionaryItems);
            return;
        }
        if (params.domType == "option") {
            return this.assembleSelect(dictionaryItems, params);
        }
        return this.assembleCheckboxAndRadio(dictionaryItems, params);
    },
    assembleSelect: function (dictionaryItems, params) {
        //var result = "<select name='{domName}' class='{domClass}' {domOther}>".format(params);
        var result = "<option value='' {domOther}>请选择</option>".format(params);
        for (var key in dictionaryItems) {
            result += "<option value='{value}'>{name}</option>".format(dictionaryItems[key]);
        }
        //result += "</select>";
        return result;
    },
    assembleCheckboxAndRadio: function (dictionaryItems, params) {
        var result = "";
        for (var key in dictionaryItems) {
            var json = dictionaryItems[key];
            var item = {
                domType: params.domType,
                domName: params.domName,
                domClass: params.domClass,
                domOther: params.domOther,
                itemValue: json.value,
                itemName: json.name
            };
            result += "<label class='dic-item'><input type='{domType}' name='{domName}' class='{domClass}' {domOther} value='{itemValue}'/> {itemName}</label>".format(item);
        }
        return result;
    }
};

/**
 * 数据字典操作类，在程序中可以通过“字典项值”获取“字典项名称”和“字典项对象”<br/>
 * 注意：<br/>
 * “字典值”指的是Dictionary.value，“字典名称”指的是Dictionary.name<br/>
 * “字典项值”指的是DictionaryItem.value，“字典项名称”指的是DictionaryItem.name
 * @constructor
 */
function DictionaryOperator() {

    this.dictionaryItemMap = {};
    this.dictionaryValue = "";

    this.setDictionaryItemMap = function (dictionaryItemMap, dictionaryValue) {
        this.dictionaryItemMap = dictionaryItemMap;
        this.dictionaryValue = dictionaryValue;
    }

    /**
     * 获取字典项名称
     * @param dictionaryItemValue 字典项值
     * @returns {string}
     */
    this.getDictionaryItemName = function (dictionaryItemValue) {
        if (!dictionaryItemValue) {
            return "";
        }
        var dictionaryItem = this.getDictionaryItem(dictionaryItemValue);
        if (dictionaryItem) {
            return dictionaryItem.name;
        }
        return dictionaryItemValue;
    }

    /**
     * 获取字典项名称数组
     * @param dictionaryItemValue 用英文逗号分隔的字典项值
     * @returns {string}
     */
    this.getItemNameArray = function (dictionaryItemValue) {
        var valueArray = dictionaryItemValue.split(",");
        var nameArray = new Array();
        for (var i = 0; i < valueArray.length; i++) {
            var dictionaryItem = this.getDictionaryItem(valueArray[i]);
            if (dictionaryItem) {
                nameArray.push(dictionaryItem.name);
            }
        }
        return nameArray;
    }

    /**
     * 获取字典项对象
     * @param dictionaryItemValue 字典项值
     * @returns {}
     */
    this.getDictionaryItem = function (dictionaryItemValue) {
        return this.dictionaryItemMap[dictionaryItemValue];
    }
}

/*try {
    $.validator.setDefaults({
        submitHandler: function (form) {
            form.submit();//提交时拦截
        },
        //errorElement: 'div',
        errorClass: "error-valid",
        onfocusin: function (element) {
            $(element).valid();
        },
        onfocusout: function (element) {
            $(element).valid();
        },
        onclick: function (element) {
            //$(element).valid();
        },
        onkeyup: function (element) {
            //$(element).valid();
        },
        errorPlacement: function (error, element) {
            layer.closeAll();
            var id = $(element).attr("id");
            if (!id) {
                id = "valid-" + UUID.guid();
                $(element).attr("id", id);
            }
            layer.tips($(error).html(), element, {
                tips:[3, '#FFB800'],
            });
        },
        highlight: function (element, errorClass) { //高亮显示
            $(element).addClass(errorClass);
        },
        unhighlight: function (element, errorClass) {
            $(element).removeClass(errorClass);
        }
    });
} catch (e) {
    console.log(e);
}*/

$(function () {
    DataGrid.init();
    FormManager.init();

    function onAjaxError(event, xhr, settings, err) {
        $.message("error", "异步请求失败，请与系统管理员联系或重新登录试试");
    }

    $(document).ajaxError(onAjaxError);

    $(".open-dialog").click(function () {
        var p = $(this).attr("p");
        DialogManager.openDialog(p);
    });

    $(".singleSelected").click(function () {
        var p = $(this).attr("p");
        DialogManager.singleSelected(p);
    });

    $(".ajax-form").unbind().submit(function () {
        try {
            var form = $(this);
            if (!form.valid()) {
                $.message("验证不通过，无法提交表单");
                return false;
            }

            form.formSubmit();
        } catch (e) {
            console.log("表单提交错误：" + e);
        }
        return false;
    });

    $(".search-button").click(function () {
        DataGrid.refresh();
    });

    $(".select-tree").click(function (e) {
        FormManager.selectTree(this, $(this).attr("p"));
        WebUtils.stopPropagation(e);
    });

    $(".single-model-select").click(function (e) {
        FormManager.singleModelSelect(this, $(this).attr("p"));
        WebUtils.stopPropagation(e);
    });

    //日期初始化
    $(".ui-date").each(function () {
        var obj = $(this), id = obj.attr("id");
        if (!id) {
            id = "date-" + UUID.guid();
            obj.attr("id", id);
        }
        laydate.render({
            elem: '#' + id,
            trigger:'click',
            done:function (value, date, endDate) {
                obj.focus();
            }
        });
    });
    $(".ui-datetime").each(function () {
        var obj = $(this), id = obj.attr("id");
        if (!id) {
            id = "date-" + UUID.guid();
            obj.attr("id", id);
        }
        laydate.render({
            elem: '#' + id,
            type:'datetime'
        });
    });
    $(".ui-month").each(function () {
        var obj = $(this), id = obj.attr("id");
        if (!id) {
            id = "date-" + UUID.guid();
            obj.attr("id", id);
        }
        laydate.render({
            elem: '#' + id,
            type:'month'
        });
    });
    $(".ui-time").each(function () {
        var obj = $(this), id = obj.attr("id");
        if (!id) {
            id = "date-" + UUID.guid();
            obj.attr("id", id);
        }
        laydate.render({
            elem: '#' + id,
            type:'time'
        });
    });
    /*$(".ui-date").click(function () {
        WdatePicker({dateFmt: 'yyyy-MM-dd'});
    });
    $(".ui-datetime").click(function () {
        WdatePicker({dateFmt: 'yyyy-MM-dd HH:mm:ss'});
    });
    $(".ui-month").click(function () {
        WdatePicker({dateFmt: 'yyyy-MM'});
    });
    $(".ui-time").click(function () {
        WdatePicker({dateFmt: 'HH:mm'});
    });
    $(".ui-datehour").click(function () {
    	WdatePicker({dateFmt: 'yyyy-MM-dd HH'});
    });*/

    //初始化select字典
    $(".dic-select").each(function () {
        var obj = $(this);
        var p = obj.attr("p") || "";
        var params = eval('({' + p + '})');

        var default_ = {
            dictionaryValue: obj.attr("dic-code"),
            domType: 'option',
            domName: '',
            domClass: '',
            domOther: '',
        };
        $.extend(default_, params);

        var str = DictionaryHelper.assemble(default_);
        obj.html(str);
    });

    //初始化省市区联动select
    $(".area-select").each(function () {
        AreaHelper.initPage({domObj: $(this)});
    });

    /*$(".ui-searchs .more").click(function () {
        var flag = $(this).find(".fa");
        if (flag.hasClass("fa-angle-double-up")) {
            flag.removeClass("fa-angle-double-up").addClass("fa-angle-double-down");
            $(".ui-search-items").show();
            return;
        }
        flag.removeClass("fa-angle-double-down").addClass("fa-angle-double-up");
        $(".ui-search-items").hide();
    });*/
});