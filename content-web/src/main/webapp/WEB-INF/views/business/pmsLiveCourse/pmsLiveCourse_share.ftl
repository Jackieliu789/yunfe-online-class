<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>直播课程分享</title>
    <#include "/common/vue_resource.ftl">
    <style>
        .text-center {
            line-height: 30px;
        }

        .text-center img {
            border-radius: 5px;
            height: 200px;
        }

        .txt {
            color: #777;
            margin-top:10px;
        }
        .copy{color:#FF5722;display:inline-block;margin-left:10px;cursor:pointer;}
        .link{border:1px solid #e2e2e2;margin:0 20px;margin-top:20px;line-height:40px;border-radius:2px;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="text-center" style="margin-top:10px;"><img v-if="codeUrl" :src="codeUrl" alt=""></div>
    <div class="text-center txt">使用微信扫描上面二维码</div>
    <div class="text-center link">{{shareUrl}}</div>
    <div class="text-center txt">
        复制以上网址在PC端最新版Chrome浏览器中(或最新版Safari浏览器)打开
        <span class="copy" @click="copy">复制链接</span>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            shareUrl: '${params.contextPath!}/live/course/share/${params.id!}.htm',
            codeUrl:'',
        },
        mounted: function () {
            this.loadCode();
        },
        methods: {
            copy: function () {
                var aux = document.createElement("input");
                aux.setAttribute("value", this.shareUrl);
                document.body.appendChild(aux);
                aux.select();
                document.execCommand("copy");
                document.body.removeChild(aux);
                $.message("复制成功");
            },
            loadCode:function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsLiveCourse/wxacode.json", {id: "${params.id!}"}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.codeUrl = "${params.fileRequestUrl!}" + data.data;
                });
            }
        }
    });
</script>
</body>

</html>