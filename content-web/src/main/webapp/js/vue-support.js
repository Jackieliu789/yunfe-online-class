try {
    var layer = layui.layer, laydate = layui.laydate;
} catch (e) {
    console.log(e);
}
if (!window.console || !window.console.log) {
    window.console = {
        log: function (msg) {
            return;
        }
    };
}

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
    if (_loading_id) {
        layer.close(_loading_id);
        _loading_id = false;
    }
};

$.message = function (message) {
    layer.msg(message);
};

//axios.defaults.headers.post['Content-Type'] = 'application/json; charset=utf-8';
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded; charset=utf-8';
//配置发送请求前的拦截器 可以设置token信息
axios.interceptors.request.use(function (config) {
    $.loading();
    var data = config.data;
    if (data) {
        var formData = new FormData();
        for (var key in data) {
            formData.append(key, data[key]);
        }
        config.data = formData;
    }
    //console.log("config = " + JSON.stringify(config));
    return config;
}, function (error) {
    $.closeLoading();
    $.message("请求失败，错误信息为<br/>[" + error.message + "]");
    return Promise.reject(error);
});

// 配置响应拦截器
axios.interceptors.response.use(function (res) {
    $.closeLoading();
    //console.log("res = " + JSON.stringify(res));
    /*if (res.data.code == '401') {
        //全局登陆过滤，当判读token失效或者没有登录时 返回登陆页面
        return false;
    }*/
    return Promise.resolve(res.data);
}, function (error) {
    $.closeLoading();
    $.message("响应失败，错误信息为<br/>[" + error.message + "]");
    return Promise.reject(error);
});

$.http = axios;