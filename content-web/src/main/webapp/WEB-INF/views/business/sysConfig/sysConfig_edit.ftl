<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>编辑系统配置</title>
    <#include "/common/vue_resource.ftl">
    <#include "/common/upload.ftl">
    <style>
        .anchor-point > a {
            color: #FF5722;
            margin-right: 5px;
        }

        .button-container {
            position: fixed;
            top: 0px;
            right: 0;
            width: 100%;
            border-bottom: 1px solid #eee;
            background: #fff;
            z-index: 10;
            line-height: 45px;
        }

        .images {
            display: inline-block;
            margin-left: 10px;
            vertical-align: top;
        }

        .images img {
            height: 30px;
            cursor: pointer;
            border-radius: 5px;
        }

        .images .remove {
            font-size: 12px;
            text-align: center;
            background-color: rgba(0, 0, 0, 0.6);
            color: #fff;
            display: inline-block;
            padding: 0px 10px;
            height: 30px;
            line-height: 30px;
            vertical-align: top;
            border-radius: 10%;
            cursor: pointer;
            margin-left: 5px;
        }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="layui-container" style="margin-top:60px;margin-bottom:20px;">
        <form class="layui-form ajax-form" @submit.prevent="submitForm()" method="post">
            <div class="button-container">
                <div class="layui-row">
                    <div class="layui-col-md9 layui-col-md-offset1 anchor-point">
                        导航：
                        <a href="#website-config">网站设置</a>
                        <#--<a href="#core-config">核心设置</a>
                        <a href="#attachment-config">附件设置</a>
                        <a href="#watermark-config">图片水印</a>-->
                        <a href="#leaflet-config">宣传页配置</a>
                        <a href="#interface-config">音视频配置</a>
                        <a href="#board-config">白板配置</a>
                        <#--<a href="#oss-config">云存储配置</a>-->
                    </div>
                    <div class="layui-col-md2">
                        <input type="submit" value="保存" class="layui-btn"/>
                    </div>
                </div>
            </div>
            <div class="layui-card" id="website-config">
                <div class="layui-card-header">网站设置</div>
                <div class="layui-card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">网站全称<span class="ui-request">*</span></label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.websitName" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">一般不超过10个字符</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">网站简称<span class="ui-request">*</span></label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.websitShortName" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">一般不超过7个字符</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">小程序简称<span class="ui-request">*</span></label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.appletName" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">一般不超过7个字符</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">网站LOGO<span class="ui-request">*</span></label>
                        <div class="layui-input-block">
                            <div style="display:inline-block;vertical-align:top;">
                                <img v-if="record.logoImagePath"
                                     :src="'${params.fileRequestUrl!}' + record.logoImagePath"
                                     style="max-height:150px;max-width:150px;">
                            </div>
                            <div style="display:inline-block;vertical-align:top;">
                                <a id="select-logo-button">选择图片</a>
                                <div class="layui-form-mid layui-word-aux">JPG、PNG格式，图片小于5M</div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">地址栏图标</label>
                        <div class="layui-input-block">
                            <div style="display:inline-block;vertical-align:top;">
                                <img v-if="record.faviconImagePath"
                                     :src="'${params.fileRequestUrl!}' + record.faviconImagePath"
                                     style="max-height:150px;max-width:150px;">
                            </div>
                            <div style="display:inline-block;vertical-align:top;">
                                <a id="select-favicon-button">选择图片</a>
                                <div class="layui-form-mid layui-word-aux">建议尺寸：32像素×32像素。必须是ico文件</div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">版权信息</label>
                        <div class="layui-input-block">
                            <textarea v-model="record.copyright" placeholder="请输入版权信息" class="layui-textarea"></textarea>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">备案号</label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.recordNumber" placeholder="请输入备案号" class="layui-input"/>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">组织机构</label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.defaultOrgName" @click="showOrgDialog" placeholder="请输入选择组织机构" class="layui-input" readonly style="cursor:pointer;"/>
                            <input type="hidden" v-model="record.defaultOrgId" />
                            <div class="layui-form-mid layui-word-aux">小程序扫码之后创建的用户账号将归属于该组织机构</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">验证开启</label>
                        <div class="layui-input-block">
                            <select v-model="record.miniAppCheck" class="layui-input">
                                <option value="1">关闭</option>
                                <option value="2">开启</option>
                            </select>
                            <div class="layui-form-mid layui-word-aux">当提交小程序审核时务必开启，小程序审核通过之后再关闭</div>
                        </div>
                    </div>
                    <#--end-->
                </div>
            </div>

            <div class="layui-card" id="leaflet-config">
                <div class="layui-card-header">宣传页配置</div>
                <div class="layui-card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">是否开启</label>
                        <div class="layui-input-block">
                            <select v-model="record.leafletFlag" class="layui-input">
                                <option value="2">关闭</option>
                                <option value="1">开启</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">商务咨询</label>
                        <div class="layui-input-block">
                            <textarea type="text" v-model="record.businessConsult" class="layui-textarea"></textarea>
                            <div class="layui-form-mid layui-word-aux">换行请用&lt;br/&gt;放在两行之间</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">技术支持</label>
                        <div class="layui-input-block">
                            <textarea type="text" v-model="record.technicalSupport" class="layui-textarea"></textarea>
                            <div class="layui-form-mid layui-word-aux">换行请用&lt;br/&gt;放在两行之间</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">联系电话</label>
                        <div class="layui-input-block">
                            <textarea type="text" v-model="record.contactNumber" class="layui-textarea"></textarea>
                            <div class="layui-form-mid layui-word-aux">换行请用&lt;br/&gt;放在两行之间</div>
                        </div>
                    </div>
                    <#--end-->
                </div>
            </div>

            <div class="layui-card" id="interface-config">
                <div class="layui-card-header">音视频配置</div>
                <div class="layui-card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">音视频Key</label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.videoKey" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">第三方音视频接口的SDKAppID</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">ApiSecret</label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.videoSecret" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">第三方音视频接口的密钥</div>
                        </div>
                    </div>
                    <#--end-->
                </div>
            </div>

            <div class="layui-card" id="board-config">
                <div class="layui-card-header">白板配置</div>
                <div class="layui-card-body">
                    <div class="layui-form-item">
                        <label class="layui-form-label">是否开启</label>
                        <div class="layui-input-block">
                            <select v-model="record.openBoardFlag" class="layui-input">
                                <option value="2">关闭</option>
                                <option value="1">开启</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">白板Key</label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.boardKey" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">第三方互动白板接口的SDKAppID</div>
                        </div>
                    </div>
                    <div class="layui-form-item">
                        <label class="layui-form-label">ApiSecret</label>
                        <div class="layui-input-block">
                            <input type="text" v-model="record.boardSecret" class="layui-input"/>
                            <div class="layui-form-mid layui-word-aux">第三方互动白板接口的密钥</div>
                        </div>
                    </div>
                    <#--end-->
                </div>
            </div>

        </form>
    </div>
</div>
<script type="text/javascript">
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            record: {
                websitName: '云飞在线互动教育平台',
                websitShortName: '云飞在线教育',
                appletName: '云飞在线教育',
                logoImagePath: '',
                faviconImagePath: '',
                copyright: 'Copyright © 2019-2020 Yunfeisoft.com. 云飞CMS 版权所有',
                recordNumber: '',
                videoKey: '',
                videoSecret: '',
                openBoardFlag: '2',
                boardKey: '',
                boardSecret: '',
                miniAppCheck:'1',
                defaultOrgName:'',
                defaultOrgId:'',
                leafletFlag:'2',
                businessConsult:'QQ1： 1060764567<br/>QQ2： 648850843',
                technicalSupport:'QQ1： 648850843<br/>QQ2： 657300182',
                contactNumber:'电话1： 17756009717<br/>电话2： 18817702051'
            },
        },
        mounted: function () {
            this.init();
            this.loadData();
        },
        methods: {
            init: function () {
                var that = this;
                //网站LOGO
                $.upload({
                    renderId: "#select-logo-button",
                    accept: {title: 'Images', extensions: 'gif,jpg,jpeg,bmp,png', mimeTypes: 'image/*'},
                    uploadSuccess: function (file, data) {
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        var result = data.data[0];
                        that.record.logoImagePath = result.path;
                    }
                });

                //地址栏图标
                $.upload({
                    renderId: "#select-favicon-button",
                    accept: {title: 'Images', extensions: 'ico', mimeTypes: 'image/x-icon'},
                    uploadSuccess: function (file, data) {
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        var result = data.data[0];
                        that.record.faviconImagePath = result.path;
                    }
                });
            },
            loadData: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/sysConfig/list.json").then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    var list = data.data;
                    for (var i = 0, size = list.length; i < size; i++) {
                        var record = list[i];
                        that.record[record.key] = record.value || "";
                    }
                });
            },
            showOrgDialog: function () {
                this.showTypes = false;
                DialogManager.open({url:'${params.contextPath!}/view/business/sysConfig/sysConfig_org.htm', width:'400px', height:'100%', title:'选择组织机构'});
            },
            setOrgData: function (orgId, orgName) {
                this.record.defaultOrgId = orgId;
                this.record.defaultOrgName = orgName;
            },
            submitForm: function () {
                $.http.post("${params.contextPath}/web/sysConfig/save.json", this.record).then(function (data) {
                    $.message(data.message);
                });
            },
        }
    });
</script>
</body>

</html>
