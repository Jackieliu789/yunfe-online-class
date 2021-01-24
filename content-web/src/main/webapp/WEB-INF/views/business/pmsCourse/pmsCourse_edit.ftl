<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑互动课程</title>
    <#include "/common/vue_resource.ftl">
    <#include "/common/upload.ftl">
    <link href="${params.contextPath!}/common/umeditor/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
    <script type="text/javascript" charset="utf-8" src="${params.contextPath!}/common/umeditor/umeditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="${params.contextPath!}/common/umeditor/umeditor.min.js"></script>
    <script type="text/javascript" src="${params.contextPath!}/common/umeditor/lang/zh-cn/zh-cn.js"></script>
</head>
<body>
<div id="app" v-cloak>
    <div class="ui-form">
        <form class="layui-form" @submit.prevent="submitForm()" method="post">
            <input type="hidden" v-model="record.id" />
            <blockquote class="layui-elem-quote block-title">基本信息</blockquote>
            <div class="layui-form-item">
                <label class="layui-form-label">课程名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.name" placeholder="请输入名称" class="layui-input"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">课程简介</label>
                <div class="layui-input-block">
                    <textarea v-model="record.intro" placeholder="请输入简介" class="layui-textarea"></textarea>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">课程封面<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <div style="display:inline-block;vertical-align:top;">
                        <img :src="record.coverFullPath" style="max-height:150px;max-width:150px;">
                        <input type="hidden" v-model="record.coverPath"/>
                    </div>
                    <div style="display:inline-block;vertical-align:top;">
                        <a id="select-file-button">选择文件</a>
                        <div class="layui-form-mid layui-word-aux">建议尺寸750*560px或者4:3，JPG、PNG格式，图片小于5M</div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">课程详情<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <script type="text/plain" id="contentEditor" style="width:100%;height:240px;"></script>
                </div>
            </div>

            <div class="layui-form-item">
                <div class="layui-input-block">
                    <input type="submit" value="保存" class="layui-btn" />
                </div>
            </div>
        </form>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            record : {
                id:'${params.id!}',
                name:'',
                coverPath:'',
                coverFullPath:'',
                intro:'',
                content:'',
            },
        },
        mounted: function () {
            this.init();
            this.loadData();
        },
        methods: {
            init:function(){
                var that = this;
                $.upload({
                    accept:{title:'Images',extensions:'gif,jpg,jpeg,bmp,png',mimeTypes:'image/*'},
                    fileSingleSizeLimit: 5 * 1024 * 1024,//5M
                    uploadSuccess:function (file, data) {
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        var result = data.data[0];
                        that.record.coverFullPath = "${params.fileRequestUrl!}" + result.path;
                        that.record.coverPath = result.path;
                    }
                });

                window.um = UM.getEditor('contentEditor', {
                    UMEDITOR_HOME_URL:"${params.contextPath!}/common/umeditor/",
                    imageUrl:"${params.contextPath!}/web/attachment/ueupload.json",
                    imagePath:"${params.fileRequestUrl!}",
                });
            },
            loadData: function () {
                if (!'${params.id!}') {
                    return;
                }
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourse/query.json", {id: '${params.id!}'}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var item = data.data;
                    for (var key in  that.record) {
                        that.record[key] = item[key];
                    }
                    item.coverPath && (that.record.coverFullPath = '${params.fileRequestUrl!}' + item.coverPath);
                    window.um.setContent(item.content || "");
                });
            },
            submitForm: function () {
                this.record.content = window.um.getContent();
                $.http.post("${params.contextPath}/web/pmsCourse/<#if (params.id)??>modify<#else>save</#if>.json", this.record).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var alt = layer.alert(data.message || "操作成功", function () {
                        var back = "${params.back!}";
                        if (back) {
                            history.go(-1);
                            return;
                        }
                        parent.app.loadData();
                        parent.layer.closeAll();
                        layer.close(alt);
                    });
                });
            },
        }
    });
</script>
</body>

</html>
