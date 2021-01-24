<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>编辑单品表</title>
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
                <label class="layui-form-label">音频名称<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <input type="text" v-model="record.name" placeholder="请输入名称" class="layui-input"/>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">音频上传<span class="ui-request">*</span></label>
                <div class="layui-input-block">
                    <div style="display:inline-block;vertical-align:top;" v-if="record.mediaPath">
                        <img src="${params.contextPath}/images/audio.png" style="height:60px;">
                        <input type="hidden" v-model="record.mediaPath"/>
                    </div>
                    <div style="display:inline-block;vertical-align:top;">
                        <a id="select-media-button">选择文件</a>
                        <div class="layui-form-mid layui-word-aux">格式支持mp3，为保证音频加载与播放的流畅性，建议上传大小不超过500M</div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">试听音频</label>
                <div class="layui-input-block">
                    <div style="display:inline-block;vertical-align:top;" v-if="record.tryAudioPath">
                        <img src="${params.contextPath}/images/audio.png" style="height:60px;">
                        <input type="hidden" v-model="record.tryAudioPath"/>
                    </div>
                    <div style="display:inline-block;vertical-align:top;">
                        <a id="select-try-audio-button">选择文件</a>
                        <div class="layui-form-mid layui-word-aux">格式支持mp3，为保证音频加载与播放的流畅性，建议上传大小不超过500M</div>
                    </div>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">音频封面<span class="ui-request">*</span></label>
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
                <label class="layui-form-label">音频详情</label>
                <div class="layui-input-block">
                    <script type="text/plain" id="contentEditor" style="width:100%;height:240px;"></script>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">文字防复制</label>
                <div class="layui-input-block" style="padding-top:10px;">
                    <label><input type="radio" name="copyStatus" v-model="record.copyStatus" value="1"/> 允许复制</label>
                    <div class="layui-form-mid layui-word-aux">商品的文字内容允许复制，图片点击放大和长按识别二维码功能允许使用</div>
                </div>
                <div class="layui-input-block">
                    <label><input type="radio" name="copyStatus" v-model="record.copyStatus" value="2"/> 禁止复制</label>
                    <div class="layui-form-mid layui-word-aux">商品的文字内容禁止复制，图片点击放大和长按识别二维码功能不允许使用</div>
                </div>
            </div>

            <blockquote class="layui-elem-quote block-title">商品信息</blockquote>
            <div class="layui-form-item">
                <label class="layui-form-label">售卖方式<span class="ui-request">*</span></label>
                <div class="layui-input-block" style="padding-top:10px;">
                    <label><input type="checkbox" v-model="record.sellAloneStatus" value="1"/> 支持单独售卖</label>
                </div>
                <div style="background:#F5F7FA;margin-left: 110px;padding: 20px 0px;" v-if="record.sellAloneStatus.length > 0">
                    <div class="layui-input-block" style="margin-left:20px">
                        <label style="margin-right:20px;">售卖设置</label>
                        <label style="margin-right:20px;"><input type="radio" name="priceStatus" v-model="record.priceStatus" value="1"/> 付费</label>
                        <label><input type="radio" name="priceStatus" v-model="record.priceStatus" value="2"/> 免费</label>
                    </div>
                    <div class="layui-input-block" style="margin-left:20px">
                        <div style="margin-bottom:10px;">商品价格&nbsp;&nbsp;<input type="text" v-model="record.price" placeholder="请输入价格" class="layui-input" style="width:200px;display:inline-block;" :disabled="record.priceStatus == '2'"/>&nbsp;元</div>
                        <div>划线价格&nbsp;&nbsp;<input type="text" v-model="record.linePrice" placeholder="请输入价格" class="layui-input" style="width:200px;display:inline-block;" :disabled="record.priceStatus == '2'"/>&nbsp;元</div>
                        <div class="layui-form-mid layui-word-aux">划线价格在商品详情页会以划线形式展示</div>
                    </div>
                </div>
            </div>

            <blockquote class="layui-elem-quote block-title">上架设置</blockquote>
            <div class="layui-form-item">
                <label class="layui-form-label">上架设置<span class="ui-request">*</span></label>
                <div class="layui-input-block" style="line-height:30px;">
                    <div><label><input type="radio" name="shelfStatus" v-model="record.shelfStatus" value="2"/> 立即上架</label></div>
                    <div>
                        <label style="margin-right:10px;"><input type="radio" name="shelfStatus" v-model="record.shelfStatus" value="4"/> 定时上架</label>
                        <input type="text" id="shelfTime" v-model="record.shelfTime" placeholder="请输入上架时间" class="layui-input" style="width:200px;display:inline-block;cursor:pointer;"/>
                    </div>
                    <div><label><input type="radio" name="shelfStatus" v-model="record.shelfStatus" value="1"/> 暂不上架</label></div>
                </div>
                <div class="layui-input-block" style="padding-top:10px;">
                    <label><input type="checkbox" v-model="record.hideStatus" value="1"/> 隐藏</label>
                    <div class="layui-form-mid layui-word-aux" style="display:inline-block;margin-left:10px;">上架的商品设置隐藏后，在店铺内不显示，但可以通过链接的方式访问</div>
                </div>
                <div class="layui-input-block">
                    <label><input type="checkbox" v-model="record.stopStatus" value="1"/> 停售</label>
                    <div class="layui-form-mid layui-word-aux" style="display:inline-block;margin-left:10px;">上架的商品设置停售后，将停止售卖</div>
                </div>
            </div>

            <blockquote class="layui-elem-quote block-title">引导加群</blockquote>
            <div class="layui-form-item">
                <label class="layui-form-label">引导加群<span class="ui-request">*</span></label>
                <div class="layui-input-block" style="padding-top:10px;">
                    <label style="margin-right:20px;"><input type="radio" name="groupStatus" v-model="record.groupStatus" value="1" @click="showGroup"/> 开启</label>
                    <label><input type="radio" name="groupStatus" v-model="record.groupStatus" value="2"/> 关闭</label>
                    <div class="layui-form-mid layui-word-aux">引导已购课程的用户加微信群、微信个人号或公众号等。</div>
                </div>
                <div style="margin-left:110px;padding:20px 0px;line-height:50px;" v-show="record.groupStatus == 1">
                    <div class="layui-input-block" style="margin-left:0px">
                        <label style="margin-right:20px;">引导方式 <span style="color:#f33">*</span></label>
                        <label><input type="checkbox" v-model="record.groupDetailStatus" value="1"/> 详情页引导加群</label>
                        <div style="margin-left: 90px;">
                            <label style="margin-right:10px;">引导标签内容设置</label>
                            <input type="text" v-model="record.groupTitle" placeholder="请输入自定义内容" class="layui-input" style="width:300px;display:inline-block;"/>
                        </div>
                        <div style="margin-left: 90px;">
                            <label><input type="checkbox" v-model="record.groupPayStatus" value="1"/> 购买成功页引导加群</label>
                        </div>
                    </div>
                    <div class="layui-input-block" style="margin-left:0px">
                        <label style="margin-right:20px;">内容设置 <span style="color:#f33">*</span></label>
                        <div style="display:inline-block">
                            <label style="margin-right:10px;width:112px;display: inline-block;">引导描述</label>
                            <input type="text" v-model="record.groupRemark" placeholder="请输入自定义内容" class="layui-input" style="width:300px;display:inline-block;"/>
                        </div>
                        <div style="margin-left: 90px;">
                            <label style="margin-right:10px;width:111px;display: inline-block;">二维码标题</label>
                            <input type="text" v-model="record.qrCodeTitle" placeholder="请输入自定义内容" class="layui-input" style="width:300px;display:inline-block;"/>
                        </div>
                        <div style="margin-left: 90px;">
                            <label style="margin-right:10px;width:110px;display: inline-block;">二维码上传 <span style="color:#f33">*</span></label>
                            <div style="display:inline-block;vertical-align:top;">
                                <img :src="record.qrCodeFullPath" style="max-height:150px;max-width:150px;">
                                <input type="hidden" v-model="record.qrCodePath"/>
                            </div>
                            <div style="display:inline-block;vertical-align:top;">
                                <a id="select-qrcode-button">选择文件</a>
                                <div class="layui-form-mid layui-word-aux">图片格式为：bmp、jpeg、jpg、gif，尺寸1:1，不可大于2M。</div>
                            </div>
                        </div>
                        <div class="layui-form-mid layui-word-aux">温馨提示：微信群人数超过100人后用户将无法扫码进群且微信群二维码有效期为7天，请及时更新群二维码；</div>
                    </div>
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
                mediaPath:'',
                tryAudioPath:'',
                qrCodePath:'',
                qrCodeFullPath:'',
                shelfTime:'',
                content:'',
                copyStatus:1,
                sellAloneStatus:['1'],
                priceStatus:1,
                price:'',
                linePrice:'',
                shelfStatus:2,
                hideStatus:[],
                groupStatus:2,
                stopStatus:[],
                groupDetailStatus:["1"],
                groupPayStatus:[],
                groupTitle:'加入课程交流群',
                qrCodeTitle:'',
                groupRemark:'',
            },
            hasShowGroup:false,//是否已经显示过开启引导加群
        },
        mounted: function () {
            this.init();
            this.loadData();
        },
        methods: {
            init:function(){
                var that = this;
                laydate.render({elem: '#shelfTime', done:function (value) {
                        that.record.shelfTime = value;
                    }});

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

                $.upload({
                    renderId:'#select-media-button',
                    accept:{title:'音频文件',extensions:'mp3',mimeTypes:'audio/mpeg'},
                    fileSingleSizeLimit: 500 * 1024 * 1024,//500M
                    uploadSuccess:function (file, data) {
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        var result = data.data[0];
                        that.record.mediaPath = result.path;
                    }
                });

                $.upload({
                    renderId:'#select-try-audio-button',
                    accept:{title:'音频文件',extensions:'mp3',mimeTypes:'audio/mpeg'},
                    fileSingleSizeLimit: 500 * 1024 * 1024,//500M
                    uploadSuccess:function (file, data) {
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        var result = data.data[0];
                        that.record.tryAudioPath = result.path;
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
                $.http.post("${params.contextPath}/web/pmsProduct/query.json", {id: '${params.id!}'}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var item = data.data;
                    for (var key in  that.record) {
                        that.record[key] = item[key];
                    }
                    item.coverPath && (that.record.coverFullPath = '${params.fileRequestUrl!}' + item.coverPath);
                    item.qrCodePath && (that.record.qrCodeFullPath = '${params.fileRequestUrl!}' + item.qrCodePath);
                    item.qrCodePath && that.showGroup();
                    item.shelfTime && (that.record.shelfTime = item.shelfTimeStr);
                    item.sellAloneStatus && (that.record.sellAloneStatus = item.sellAloneStatus == 1 ? ["1"] : []);
                    item.hideStatus && (that.record.hideStatus = item.hideStatus == 1 ? ["1"] : []);
                    item.stopStatus && (that.record.stopStatus = item.stopStatus == 1 ? ["1"] : []);
                    item.groupDetailStatus && (that.record.groupDetailStatus = item.groupDetailStatus == 1 ? ["1"] : []);
                    item.groupPayStatus && (that.record.groupPayStatus = item.groupPayStatus == 1 ? ["1"] : []);
                    window.um.setContent(item.content || "");
                });
            },
            showGroup:function(){
                if (this.hasShowGroup) {
                    return;
                }
                this.hasShowGroup = true;
                var that = this;
                this.$nextTick(function () {
                    $.upload({
                        renderId:'#select-qrcode-button',
                        accept:{title:'Images',extensions:'gif,jpg,jpeg,bmp,png',mimeTypes:'image/*'},
                        fileSingleSizeLimit: 2 * 1024 * 1024,//2M
                        uploadSuccess:function (file, data) {
                            if (!data.success) {
                                $.message(data.message);
                                return;
                            }
                            var result = data.data[0];
                            that.record.qrCodeFullPath = "${params.fileRequestUrl!}" + result.path;
                            that.record.qrCodePath = result.path;
                        }
                    });
                });
            },
            submitForm: function () {
                this.record.content = window.um.getContent();
                $.http.post("${params.contextPath}/web/pmsProduct/<#if (params.id)??>modifyAudioPro<#else>saveAudioPro</#if>.json", this.record).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var alt = layer.alert(data.message || "操作成功", function () {
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