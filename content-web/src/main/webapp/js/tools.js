/**
 * 扩展了 String 类型，给其添加格式化的功能，替换字符串中 {placeholder} 或者 {0}, {1} 等模式部分为参数中传入的字符串
 * 使用方法:
 *     'I can speak {language} since I was {age}'.format({language: 'Javascript', age: 10})
 *     'I can speak {0} since I was {1}'.format('Javascript', 10)
 * 输出都为:
 *     I can speak Javascript since I was 10
 *
 * @param replacements 用来替换 placeholder 的 JSON 对象或者数组
 */
String.prototype.format = function (replacements) {
    replacements = (typeof replacements === 'object') ? replacements : Array.prototype.slice.call(arguments, 0);
    return formatString(this, replacements);
}
/*String.prototype.trim = function () {
    return $.trim(this);
}

String.prototype.startWith = function (str) {
    var reg = new RegExp("^" + str);
    return reg.test(this);
}

String.prototype.endWith = function (str) {
    var reg = new RegExp(str + "$");
    return reg.test(this);
}*/
/**
 * 替换字符串中 {placeholder} 或者 {0}, {1} 等模式部分为参数中传入的字符串
 * 使用方法:
 *     formatString('I can speak {language} since I was {age}', {language: 'Javascript', age: 10})
 *     formatString('I can speak {0} since I was {1}', 'Javascript', 10)
 * 输出都为:
 *     I can speak Javascript since I was 10
 *
 * @param str 带有 placeholder 的字符串
 * @param replacements 用来替换 placeholder 的 JSON 对象或者数组
 */
var formatString = function (str, replacements) {
    replacements = (typeof replacements === 'object') ? replacements : Array.prototype.slice.call(arguments, 1);
    return str.replace(/\{\{|\}\}|\{(\w+)\}/g, function (m, n) {
        if (m == '{{') {
            return '{';
        }
        if (m == '}}') {
            return '}';
        }
        return replacements[n];
    });
};

var FileUtils = {
    formatSize: function (bytes) {//格式化输出文件大小
        if (bytes === 0)
            return '0 B';

        var k = 1024,
            sizes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
            i = Math.floor(Math.log(bytes) / Math.log(k));
        return (bytes / Math.pow(k, i)).toPrecision(3) + ' ' + sizes[i];
    }
};

var WebUtils = {
    isIE: function () {//判断是否是IE浏览器
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
            return true;
        }
        return false;
    },
    stopPropagation: function (e) {//阻止事件冒泡
        if (e.stopPropagation) {
            e.stopPropagation();
        } else {
            e.cancelBubble = true;
        }
    },
    toArray: function (s) {//通用的转数组方法，只有该对象含有length属性
        try {
            Array.prototype.slice.call(s);
        } catch (e) {
            var arr = [];
            for (var i = 0, len = s.length; i < len; i++) {
                //arr.push(s[i]);
                arr[i] = s[i];
            }
        }
    }
};

//为Array类添加indexOf方法
function arrayIndexOf() {
    if (!Array.prototype.indexOf) {
        Array.prototype.indexOf = function (elt /*, from*/) {
            var len = this.length >>> 0;
            var from = Number(arguments[1]) || 0;
            from = (from < 0) ? Math.ceil(from) : Math.floor(from);
            if (from < 0) {
                from += len;
            }
            for (; from < len; from++) {
                if (from in this && this[from] === elt) {
                    return from;
                }
            }
            return -1;
        };
    }
}

arrayIndexOf();
/**
 * 方法作用：【格式化时间】
 * 使用方法
 * 示例：
 *      使用方式一：
 *      var now = new Date();
 *      var nowStr = now.format("yyyy-MM-dd HH:mm:ss");
 *      使用方式二：
 *      new Date().format("yyyy年MM月dd日");
 *      new Date().format("MM/dd/yyyy");
 *      new Date().format("yyyyMMdd");
 *      new Date().format("yyyy-MM-dd HH:mm:ss");
 * @param format {String} 传入要格式化的日期类型
 * @returns {2015-01-31 16:30:00}
 */
Date.prototype.format = function (format) {
    var o = {
        "M+": this.getMonth() + 1, //month
        "d+": this.getDate(), //day
        "H+": this.getHours(), //24小时制
        'h+': this.getHours() % 12 == 0 ? 12 : this.getHours() % 12, // 12小时制
        "m+": this.getMinutes(), //minute
        "s+": this.getSeconds(), //second
        "q+": Math.floor((this.getMonth() + 3) / 3), //quarter
        "S": this.getMilliseconds() //millisecond
    }
    if (/(y+)/.test(format)) {
        format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    }
    for (var k in o) {
        if (new RegExp("(" + k + ")").test(format)) {
            format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k] : ("00" + o[k]).substr(("" + o[k]).length));
        }
    }
    return format;
}

/***********************************************************************
 *                           日期时间工具类                            *
 *                     注：调用方式，DateUtils.方法名                   *
 * ********************************************************************/
var DateUtils = {
    weekNames: ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"],
    dateFormats: [
        {
            format: /^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3], result[4], result[5], result[6]);
            }
        },
        {
            format: /^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3], result[4], result[5]);
            }
        },
        {
            format: /^(\d{4})\-(\d{2})\-(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3]);
            }
        },
        {
            format: /^(\d{4})\-(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1);
            }
        },
        {
            format: /^(\d{4})\/(\d{2})\/(\d{2}) (\d{2}):(\d{2}):(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3], result[4], result[5], result[6]);
            }
        },
        {
            format: /^(\d{4})\/(\d{2})\/(\d{2}) (\d{2}):(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3], result[4], result[5]);
            }
        },
        {
            format: /^(\d{4})\/(\d{2})\/(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3]);
            }
        },
        {
            format: /^(\d{4})\/(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1);
            }
        },
        {
            format: /^(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):(\d{2}):(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3], result[4], result[5], result[6]);
            }
        },
        {
            format: /^(\d{4})\.(\d{2})\.(\d{2}) (\d{2}):(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3], result[4], result[5]);
            }
        },
        {
            format: /^(\d{4})\.(\d{2})\.(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1, result[3]);
            }
        },
        {
            format: /^(\d{4})\.(\d{2})$/, parse: function (result) {
                return new Date(result[1], result[2] - 1);
            }
        }
    ],
    /*
     * 方法作用：【取传入日期是星期几】
     * 使用方法：DateUtils.dayForWeek(new Date());
     * @param date{date} 传入日期类型
     * @returns {星期四，...}
     */
    dayForWeek: function (date) {
        if (date instanceof Date) {
            return this.weekNames[date.getDay()];
        } else {
            return "Param error,date type!";
        }
    },
    /*
     * 方法作用：【字符串转换成日期】
     * 日期格式：yyyy-MM-dd, yyyy-MM-dd HH:mm:ss, yyyy-MM
     *          yyyy/MM/dd, yyyy/MM/dd HH:mm:ss, yyyy/MM
     *          yyyy.MM.dd, yyyy.MM.dd HH:mm:ss, yyyy.MM
     * 使用方法：DateUtils.strToDate("2010-01-01");
     * @param str {String}字符串格式的日期，传入格式：yyyy-mm-dd(2015-01-31)
     * @return {Date}由字符串转换成的日期
     */
    strToDate: function (str) {
        if (typeof(str) != "string") {
            return "args is not string type";
        }
        var dateFormats = DateUtils.dateFormats;
        for (var i = 0; i < dateFormats.length; i++) {
            var p = dateFormats[i];
            var result = str.match(p.format);
            if (result) {
                return p.parse(result);
            }
        }
        return "date format is not support";
    },
    /*
     * 方法作用：【计算2个日期之间的天数】
     * 使用方法：DateUtils.countDays(startDate,endDate);
     * @startDate {Date}起始日期
     * @endDate {Date}结束日期
     * @return endDate 与 startDate的天数差
     */
    countDays: function (startDate, endDate) {
        if (startDate instanceof Date && endDate instanceof Date) {
            var days = Math.floor((endDate - startDate) / (1000 * 3600 * 24));
            return Math.abs(days);
        } else {
            return "Param error,date type!";
        }
    },
    /*
     * 方法作用：【计算2个日期之间的天数】
     * 传入格式：yyyy-mm-dd(2015-01-31)
     * 使用方法：DateUtils.countDaysStr(startDate,endDate);
     * @startDateStr {String}起始日期
     * @endDateStr {String}结束日期
     * @return endDate - startDate的天数差
     */
    countDaysStr: function (startDateStr, endDateStr) {
        if (typeof(startDateStr) != "string" || typeof(endDateStr) != "string") {
            return "args is not string type";
        }
        var startDate = this.strToDate(startDateStr);
        var endDate = this.strToDate(endDateStr);
        var days = Math.floor((endDate - startDate) / (1000 * 3600 * 24));
        return Math.abs(days);
    },
    /*
     * 方法作用：【计算2个日期之间的天数, 结果可为负值】
     * 使用方法：DateUtils.countDays(startDate,endDate);
     * @startDate {Date}起始日期
     * @endDate {Date}结束日期
     * @return endDate 与 startDate的天数差
     */
    countRealDays: function (startDate, endDate) {
        if (startDate instanceof Date && endDate instanceof Date) {
            var days = Math.floor((endDate - startDate) / (1000 * 3600 * 24));
            return days;
        } else {
            return "Param error,date type!";
        }
    },
    /*
     * 方法作用：【计算2个日期之间的天数, 结果可为负值】
     * 传入格式：yyyy-mm-dd(2015-01-31)
     * 使用方法：DateUtils.countDaysStr(startDate,endDate);
     * @startDateStr {String}起始日期
     * @endDateStr {String}结束日期
     * @return endDate - startDate的天数差
     */
    countRealDaysStr: function (startDateStr, endDateStr) {
        if (typeof(startDateStr) != "string" || typeof(endDateStr) != "string") {
            return "args is not string type";
        }
        var startDate = this.strToDate(startDateStr);
        var endDate = this.strToDate(endDateStr);
        var days = Math.floor((endDate - startDate) / (1000 * 3600 * 24));
        return days;
    },
    /*
     * 方法作用：【计算2个日期之间相差多少分钟】
     * 使用方法：DateUtils.timeDiff(startDate,endDate);
     * @startDate {Date}起始日期
     * @endDate {Date}结束日期
     * @return endDate 与 startDate的天数差
     */
    timeDiff: function (startDate, endDate) {
        if (startDate instanceof Date && endDate instanceof Date) {
            var mius = Math.floor((endDate - startDate) / (1000 * 60));
            return Math.abs(mius);
        } else {
            return "Param error,date type!";
        }
    },
    /*
     * 方法作用：【计算2个日期之间相差多少分钟】
     * 传入格式：yyyy-mm-dd(2015-01-31)
     * 使用方法：DateUtils.timeDiffStr(startDate,endDate);
     * @startDateStr {String}起始日期
     * @endDateStr {String}结束日期
     * @return endDate与 startDate的分钟差
     */
    timeDiffStr: function (startDateStr, endDateStr) {
        if (typeof(startDateStr) != "string" || typeof(endDateStr) != "string") {
            return "args is not string type";
        }
        var startDate = this.strToDate(startDateStr);
        var endDate = this.strToDate(endDateStr);
        var mius = Math.floor((endDate - startDate) / (1000 * 60));
        return Math.abs(mius);
    },
    /*
     * 方法作用：【判断endDate是否大于等于startDate】
     * 使用方法：DateUtils.compareDate(startDate,endDate);
     * @startDate {Date}起始日期
     * @endDate {Date}结束日期
     * @return {Boolean}
     */
    compareDate: function (startDate, endDate) {
        if (startDate instanceof Date && endDate instanceof Date) {
            return (endDate - startDate) >= 0;
        } else {
            return "Param error,date type!";
        }
    },
    /*
     * 方法作用：【判断endDate是否大于等于startDate】
     * 传入格式：yyyy-mm-dd(2015-01-31)
     * 使用方法：DateUtils.compareDateStr(startDate,endDate);
     * @startDateStr {Date}起始日期
     * @endDateStr {Date}结束日期
     * @return {Boolean}
     */
    compareDateStr: function (startDateStr, endDateStr) {
        if (typeof(startDateStr) != "string" || typeof(endDateStr) != "string") {
            return "args is not string type";
        }
        var startDate = this.strToDate(startDateStr);
        var endDate = this.strToDate(endDateStr);
        return (endDate - startDate) >= 0;
    },
    /*
     * 方法作用：【为日期添加月数】
     * 使用方法：DateUtils.addMonth(date, num);
     * @date {Date}日期
     * @num {int}月数
     * @return {Date}新的日期
     */
    addMonth: function (date, num) {
        if (!(date instanceof Date) || typeof(num) != "number") {
            return "args's type is not support!";
        }
        var mm = date.getMonth();
        var newDate = new Date(date.getTime());
        newDate.setMonth(mm + num);
        return newDate;
    },
    /*
     * 方法作用：【为日期添加天数】
     * 使用方法：DateUtils.addDay(date, num);
     * @date {Date}日期
     * @num {int}天数
     * @return {Date}新的日期
     */
    addDay: function (date, num) {
        if (!(date instanceof Date) || typeof(num) != "number") {
            return "args's type is not support!";
        }
        var newDate = new Date(date.getTime() + num * 24 * 3600 * 1000);
        return newDate;
    },
    /*
     * 方法作用：【为日期添加小时数】
     * 使用方法：DateUtils.addHour(date, num);
     * @date {Date}日期
     * @num {int}小时数
     * @return {Date}新的日期
     */
    addHour: function (date, num) {
        if (!(date instanceof Date) || typeof(num) != "number") {
            return "args's type is not support!";
        }
        var newDate = new Date(date.getTime() + num * 3600 * 1000);
        return newDate;
    },
    /*
     * 方法作用：【为日期添加分钟数】
     * 使用方法：DateUtils.addHour(date, num);
     * @date {Date}日期
     * @num {int}分钟数
     * @return {Date}新的日期
     */
    addMinute: function (date, num) {
        if (!(date instanceof Date) || typeof(num) != "number") {
            return "args's type is not support!";
        }
        var newDate = new Date(date.getTime() + num * 60 * 1000);
        return newDate;
    },
    /*
     * 方法作用：【判定某年是否为闰年】
     * 使用方法：DateUtils.isLeapYear(year);
     * @year {int}年份：2016
     * @return {Boolean}
     */
    isLeapYear: function (year) {
        if (typeof(year) != "number") {
            return "args's type is not support!";
        }
        return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0);
    },
    /*
     * 方法作用：【获取某月的天数】
     * 使用方法：DateUtils.isLeapYear(year);
     * @year {int}年份：2016
     * @month {int}月：5(6月)
     * @return {Boolean}
     */
    getMonthDays: function (year, month) {
        if (typeof(year) != "number" || typeof(month) != "number") {
            return "args's type is not support!";
        }
        return [31, null, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month] || (this.isLeapYear(year) ? 29 : 28);
    },
    /*
     * 方法作用：【获取某日期在所在年是第几周】
     * 使用方法：DateUtils.getWeekOfYear(date);
     * @date {Date}日期
     * @return {int}周数
     */
    getWeekOfYear: function (date) {
        if (!(date instanceof Date)) {
            return "args's type is not support!";
        }
        var year = date.getFullYear(),
            month = date.getMonth(),
            days = date.getDate();
        //那一天是那一年中的第多少天
        for (var i = 0; i < month; i++) {
            days += this.getMonthDays(year, i);
        }
        return Math.floor(days / 7);
    },
    /*
     * 方法作用：【获取某年总共有多少周】
     * 使用方法：DateUtils.getMaxWeekNumOfYear(year);
     * @year {int}年份：2016
     * @return {int}周数
     */
    getMaxWeekNumOfYear: function (year) {
        if (typeof(year) != "number") {
            return "args's type is not support!";
        }
        //那一年中一共有多少天
        var days = 0;
        for (var i = 0; i < 12; i++) {
            days += this.getMonthDays(year, i);
        }
        return Math.floor(days / 7);
    },
    /*
     * 方法作用：【获取某年第几周的开始日期】
     * 使用方法：DateUtils.getFirstDayOfWeek(year, week);
     * @year {int}年份：2016
     * @week {int}周数：12
     * @return {Date}开始日期
     */
    getFirstDayOfWeek: function (year, week) {
        if (typeof(year) != "number" || typeof(week) != "number") {
            return "args's type is not support!";
        }
        //获取某年的第一天
        var date = new Date(year, 0, 1);
        var temp = date.getDay();
        if (temp != 1) {
            temp = temp == 0 ? 7 : temp;
            date = date.setDate(date.getDate() + (8 - temp));
            date = new Date(date);
        }
        date = this.addDay(date, (week - 1) * 7);
        return date;
    },
    /*
     * 方法作用：【获取某年第几周的结束日期】
     * 使用方法：DateUtils.getLastDayOfWeek(year, week);
     * @year {int}年份：2016
     * @week {int}周数：12
     * @return {Date}结束日期
     */
    getLastDayOfWeek: function (year, week) {
        if (typeof(year) != "number" || typeof(week) != "number") {
            return "args's type is not support!";
        }
        //获取某年的第一天
        var date = new Date(year, 0, 1);
        var temp = date.getDay();
        if (temp != 1) {
            temp = temp == 0 ? 7 : temp;
            date = date.setDate(date.getDate() + (8 - temp));
            date = new Date(date);
        }
        date = this.addDay(date, week * 7 - 1);
        return date;
    }
};

/***********************************************************************
 *                           加载工具类                                *
 *                     注：调用方式，LoadUtils.方法名                   *
 * ********************************************************************/
var LoadUtils = {
    /*
     * 方法说明：【动态加载js文件css文件】
     * 使用方法：loadUtil.loadjscssfile("http://libs.baidu.com/jquery/1.9.1/jquery.js")
     * @param fileurl 文件路径
     */
    loadjscssfile: function (fileurl) {
        var filetypes = fileurl.toLowerCase().split(".");
        var filetype = filetypes[filetypes, length - 1];
        var fileref;
        if (filetype == "js") {
            fileref = document.createElement('script');
            fileref.setAttribute("type", "text/javascript");
            fileref.setAttribute("src", fileurl);
        } else if (filetype == "css") {
            fileref = document.createElement('link');
            fileref.setAttribute("rel", "stylesheet");
            fileref.setAttribute("type", "text/css");
            fileref.setAttribute("href", fileurl);
        }
        if (typeof fileref != "undefined") {
            document.getElementsByTagName("head")[0].appendChild(fileref);
        } else {
            alert("loadjscssfile method error!");
        }
    }
};
/********************** String工具类***************/
//trim去掉字符串两边的指定字符,默去空格
String.prototype.trim = function (tag) {
    if (!tag) {
        tag = '\\s';
    } else {
        if (tag == '\\') {
            tag = '\\\\';
        } else if (tag == ',' || tag == '|' || tag == ';') {
            tag = '\\' + tag;
        } else {
            tag = '\\s';
        }
    }
    eval('var reg=/(^' + tag + '+)|(' + tag + '+$)/g;');
    return this.replace(reg, '');
};
//字符串截取后面加入...
String.prototype.interceptString = function (len) {
    if (this.length > len) {
        return this.substring(0, len) + "...";
    } else {
        return this;
    }
}
//将一个字符串用给定的字符变成数组
String.prototype.toArray = function (tag) {
    if (this.indexOf(tag) != -1) {
        return this.split(tag);
    } else {
        if (this != '') {
            return [this.toString()];
        } else {
            return [];
        }
    }
}
//是否是以XX开头
String.prototype.startsWith = function (tag) {
    return this.substring(0, tag.length) == tag;
}
//是否已XX结尾
String.prototype.endsWith = function (tag) {
    return this.substring(this.length - tag.length) == tag;
}
String.prototype.replaceAll = function (s1, s2) {
    return this.replace(new RegExp(s1, "gm"), s2);
}

var StringUtils = {
    isNotEmpty: function (val) {
        return !this.isEmpty(val);
    },
    isEmpty: function (val) {
        if ((val == null || typeof(val) == "undefined")
            || (typeof(val) == "string" && val == "" && val != "undefined")) {
            return true;
        } else {
            return false;
        }
    }
}
//StringBuffer
var StringBuffer = function () {
    this._strs = new Array;
};
StringBuffer.prototype.append = function (str) {
    this._strs.push(str);
};
StringBuffer.prototype.toString = function () {
    return this._strs.join("");
};

/**
 * dialog内嵌套iframe，参数格式如下：
 * Dialog.open({
 *       title:'测试标题',
 *       url:'http://www.baidu.com',
 *       btn:[
 *           {
 *              name:"关闭",
 *              callback:function(){
 *                  Dialog.closeAll();
 *              }
 *           },
 *           {
 *              name:"保存",
 *              callback:function(){
 *                  alert("save");
 *              }
 *           }
 *       ]
 *   });
 * @type {{open: Dialog.open, close: Dialog.close, closeAll: Dialog.closeAll}}
 */
var Dialog = {
    open: function (params) {
        this.closeAll();
        params.id = new Date().getTime();
        params.width = params.width || "800px";
        params.height = params.height || "400px";
        params.title = params.title || "窗口";
        var str = '<div class="modal fade kjlink-model" id="{id}" tabindex="-1" role="dialog">';
        str += '<div class="modal-dialog" role="document" style="width:{width}">';
        str += '<div class="modal-content" style="width:{width}">';
        //if (params.title) {
        str += '<div class="modal-header" style="padding:10px;">';
        str += '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>';
        str += '<h4 class="modal-title">{title}</h4>';
        str += '</div>';
        //}
        str += '<div class="modal-body" style="padding:0px;">';
        str += '<iframe src="{url}" scrolling="auto" style="border:none;width:100%;height:{height};overflow:auto;"/>';
        str += '</div>';
        if (params.btn) {
            var btns = params.btn;
            str += '<div class="modal-footer">';
            for (var i = 0; i < btns.length; i++) {
                var btn = btns[i];
                btn.id = new Date().getTime() + "" + i;
                if (i % 2 == 0) {
                    str += '<button id="{id}" type="button" class="btn btn-default">{name}</button>'.format(btn);
                } else {
                    str += '<button id="{id}" type="button" class="btn btn-primary">{name}</button>'.format(btn);
                }
            }
            str += '</div>';
        }
        str += '</div>';
        str += '</div>';
        str += '</div>';
        $("body").append(str.format(params));
        $("#" + params.id).modal(/*{show:true}*/);
        $(".kjlink-model .close").unbind().click(function () {
            var dialogId = $(this).parents(".kjlink-model").attr("id");
            Dialog.close(dialogId);
        });
        if (params.btn) {
            var btns = params.btn;
            for (var i = 0; i < btns.length; i++) {
                var btn = btns[i];
                $("#" + btn.id).click(btn.callback);
            }
        }
        return params.id;
    },
    close: function (dialogId) {
        $("#" + dialogId).next(".modal-backdrop").remove();
        $("#" + dialogId).slideUp(function () {
            $(this).remove();
        });
    },
    closeAll: function () {
        $(".modal-backdrop").remove();
        $(".kjlink-model").remove();
    }
};

/**
 * 跨iframe传值, 用法如下：
 *
 * 监听传递的数据：
 * LocalStorage.registHandler("handlerId", function(data){
 *      console.log(data);
 * });
 *
 * 发送传递的数据
 * LocalStorage.sendData("handlerId", "Hello KJLink!");
 * */
var LocalStorage = {
    getHandlerCache: function () {
        var top = window.top, cache = top['_LOCAL_STORAGE_HANDLER'];
        if (!cache) {
            cache = {};
            top['_LOCAL_STORAGE_HANDLER'] = cache;
        }
        return cache;
    },
    getDataCache: function () {
        var top = window.top, cache = top['_LOCAL_STORAGE_DATA'];
        if (!cache) {
            cache = {};
            top['_LOCAL_STORAGE_DATA'] = cache;
        }
        return cache;
    },
    setData: function (dataId, data) {//存储数据
        var cache = this.getDataCache();
        cache[dataId] = data;
    },
    getData: function (dataId) {//获取数据
        var cache = this.getDataCache();
        return cache[dataId];
    },
    removeData: function (dataId) {//清除数据
        var cache = this.getDataCache();
        cache[dataId] = "";
    },
    registHandler: function (handlerId, handler) {//注册处理handler
        var cache = this.getHandlerCache();
        cache[handlerId] = handler;
    },
    removeHandler: function (handlerId) {//删除处理handler
        var cache = this.getHandlerCache();
        cache[handlerId] = "";
    },
    sendData: function (handlerId, data) {//发送数据
        var cache = this.getHandlerCache();
        var handler = cache[handlerId] || "";
        if (handler == "") {
            console.log("The Id [{0}] bind handler is missing.".format(handlerId));
            return;
        }
        handler(data);
    }
};

var CalculateFloat = {
    floatAdd: function (arg1, arg2) {// 浮点数加法运算
        var r1, r2, m;
        try {
            r1 = arg1.toString().split(".")[1].length;
        } catch (e) {
            r1 = 0;
        }
        try {
            r2 = arg2.toString().split(".")[1].length;
        } catch (e) {
            r2 = 0;
        }
        m = Math.pow(10, Math.max(r1, r2));
        var value = (arg1 * m + arg2 * m) / m;
        if (value.toString().indexOf(".") != -1 && value.toString().split(".")[1].length > 4) {
            var array = value.toString().split(".");
            array[1] = array[1].substring(0, 5);
            value = parseFloat(array.join("."));
        }
        return value;
    },
    floatSub: function (arg1, arg2) {// 浮点数减法运算
        var r1, r2, m, n;
        try {
            r1 = arg1.toString().split(".")[1].length;
        } catch (e) {
            r1 = 0
        }
        try {
            r2 = arg2.toString().split(".")[1].length;
        } catch (e) {
            r2 = 0
        }
        m = Math.pow(10, Math.max(r1, r2));
        n = (r1 >= r2) ? r1 : r2;
        var value = ((arg1 * m - arg2 * m) / m).toFixed(n);
        if (value.toString().indexOf(".") != -1 && value.toString().split(".")[1].length > 4) {
            var array = value.toString().split(".");
            array[1] = array[1].substring(0, 5);
            value = parseFloat(array.join("."));
        }
        return value;
    },
    floatMul: function (arg1, arg2) {// 浮点数乘法运算
        var m = 0, s1 = arg1.toString(), s2 = arg2.toString();
        try {
            m += s1.split(".")[1].length;
        } catch (e) {
        }
        try {
            m += s2.split(".")[1].length;
        } catch (e) {
        }
        var value = Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);
        if (value.toString().indexOf(".") != -1 && value.toString().split(".")[1].length > 4) {
            var array = value.toString().split(".");
            array[1] = array[1].substring(0, 5);
            value = parseFloat(array.join("."));
        }
        return value;
    },
    floatDiv: function (arg1, arg2) {// 浮点数除法运算
        var t1 = 0, t2 = 0, r1, r2;
        try {
            t1 = arg1.toString().split(".")[1].length;
        } catch (e) {
        }
        try {
            t2 = arg2.toString().split(".")[1].length;
        } catch (e) {
        }
        with (Math) {
            r1 = Number(arg1.toString().replace(".", ""));
            r2 = Number(arg2.toString().replace(".", ""));
            var value = (r1 / r2) * pow(10, t2 - t1);
            if (value.toString().indexOf(".") != -1 && value.toString().split(".")[1].length > 4) {
                var array = value.toString().split(".");
                array[1] = array[1].substring(0, 5);
                value = parseFloat(array.join("."));
            }
            return value;
        }
    }
};