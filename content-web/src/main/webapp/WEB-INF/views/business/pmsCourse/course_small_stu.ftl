<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${params.websitName!}</title>
    <#include "/common/vue_resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/js/reconnecting-websocket.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/trtc.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/jquery.form.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/yunfei-socket.js?_t=${params.pageRandom!}"></script>
    <#--<link rel="stylesheet" href="https://unpkg.com/swiper/css/swiper.min.css">
    <script src="https://unpkg.com/swiper/js/swiper.min.js"> </script>-->
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/Swiper/5.4.2/css/swiper.min.css">
    <script src="https://cdn.bootcdn.net/ajax/libs/Swiper/5.4.2/js/swiper.min.js"></script>
    <script src="https://resources-tiw.qcloudtrtc.com/board/third/cos/5.1.0/cos.min.js"></script>
    <script src="https://resources-tiw.qcloudtrtc.com/board/2.4.6/TEduBoard.min.js"></script>
    <style>
        body, html, #app {margin: 0;height: 100%;}
        [v-cloak]{display:none !important;}
        .text-center{text-align:center;}
        .text-right{text-align:right;}
        #app{display:flex;flex-direction:column;background1:rgba(1,17,27,0.2);}
        .background{position: absolute;top: 0;right: 0;bottom: 0;left: 0;width: 100%;height: 100%;z-index: -1;filter1: blur(30px);background:#F2F2F2;}
        .header{height:40px;background:#fff;line-height:40px;color:#777;font-size:12px;border-bottom:1px solid #F2F2F2;}
        .body{flex-grow:1;flex-basis:0;display:flex;flex-direction:row;}
        .main{flex-grow:1;flex-basis:0;background:#fff;position:relative;}
        .recording{background:rgba(0,0,0,0.4);border-radius:22px;color:#fff;padding:5px 10px;font-size:12px;margin-right:10px;}
        .recording .fa{color:#f33;font-size:9px;margin-right:5px;}
        .class-out{cursor:pointer;}
        .radius-text{background:rgba(0,0,0,0.2);color:#393D49;padding:5px 10px;border-radius:20px;font-size:12px;margin-right:10px;}
        .tools{width:50px;padding-left:10px;}
        .tools .box{background:rgba(0,0,0,0.6);color:#fff;border-radius:10px 0 0 10px;}
        .tools .box .item{font-size:22px;text-align:center;padding:8px;cursor:pointer;}
        .tools .box .item:last-child{padding-bottom1:10px;}
        .whiteboard-tools{width:50px;padding-right:10px;}
        .whiteboard-tools .box{background:rgba(0,0,0,0.6);color:#fff;border-radius:0 10px 10px 0;}
        .whiteboard-tools .box .item{font-size:22px;text-align:center;padding:8px;cursor:pointer;position:relative;}
        .whiteboard-tools .box .item:first-child{border-radius:0 10px 0 0;}
        .whiteboard-tools .box .item:last-child{border-radius:0 0 10px 0;}
        .max-screen{z-index:10;position:absolute;cursor:pointer;background:#fff;width:30px;height:30px;text-align:center;line-height:30px;border-radius:30px;}
        .max-screen{right:10px;top:10px;}
        .video-container{background:#fff;margin-bottom:5px;display:flex;flex-direction:row;padding:5px 10px;padding-bottom:0px;}
        .video-container .teacher{width:210px;}
        .video-container .students{flex-basis:0;flex-grow:1;}
        .video-item{position:relative;width:200px !important;height:120px;display:inline-block;margin-right:10px;background:#F2F2F2;border-radius:10px;}
        .video-item .hand-up{z-index:10;position:absolute;right:10px;top:10px;width:25px;height:25px;line-height:25px;font-size:11px;cursor:pointer;background:rgba(0,0,0,0.2);color:#fff;border-radius:50%;text-align:center;}
        .video-item .hand-up.active{background:#1E9FFF;}
        .video-item .video{right:40px;}
        .video-item .video-player{height:100%;}
        .video-item .name{z-index:10;position:absolute;left:10px;top:10px;color:#fff;}
        .radius-user-text{background:rgba(0,0,0,0.2);color:#2F4056;padding:5px 10px;border-radius:20px;font-size:12px;margin-right:5px;}
        .unactive{color:#c2c2c2;}
        .active{color:#fff;background:#FF5722;}
        .main .box{height:100%;position:relative;}
        .color-box{position:absolute;top:-90px;left:54px;border:none;display:block;border-bottom:1px solid #f2f2f2;}
        .color-box .color:first-child{border-radius1:5px 5px 0 0;}
        .color-box .color:last-child{border-radius1:0 0 5px 5px;border-bottom:none;}
        .color-box .color{line-height:30px;color:#fff;border-bottom:1px solid #f2f2f2;background:#01AAED}
        .attachment-box{position:absolute;z-index:100;top:50%;left:50%;border:5px solid #009688;height:500px;width:500px;margin-top:-300px;margin-left:-300px;border-radius:10px;box-shadow:0 6px 18px 0 rgba(0,0,0,.2);background:#fff;padding:10px;}
        .attachment-box .layui-btn{border-radius:20px;}
        .attachment-box .close{cursor:pointer;z-index:10;position:absolute;top:-15px;right:-15px;width:30px;height:30px;text-align:center;line-height:30px;border-radius:30px;color:#fff;background:#FF5722;}
        .video-setting{position:absolute;top:50%; left:50%;margin-top:-250px;margin-left:-350px;z-index:210;border:5px solid #009688;border-radius:8px;}
        .setting-row{box-shadow:0 6px 18px 0 rgba(0,0,0,.2);background:#fff;border-radius:8px;width:700px;height:500px;}
        .setting{padding:50px 40px;}
        .setting .item{margin-bottom:40px;}
        .setting .title{color:rgba(0, 0, 0, 0.54);font-size:12px;margin-bottom:5px;}
        .setting .input select{width:100%;font-size:18px;line-height:40px;height:40px;border:none;border-bottom:1px solid #eee;color:rgba(0, 0, 0, 0.8);}
        #setting-video{height:100%;}
        #setting-video .warn-msg{margin-top: 20px;}
        .whiteboard{height:100%;overflow:hidden;}
        .whiteboard .background{background:#fff;}
        @media screen and (max-width:768px) {
            .video-setting{top:0;right:0;bottom:0;left:0;overflow:auto;background:#fff;margin-top:0;margin-left:0;position:fixed;}
            .setting-row{width:100%;}
            .attachment-box{top:0;right:0;bottom:0;left:0;overflow:auto;margin-top:0;margin-left:0;position:fixed;width:auto;height:auto;}
            .attachment-box .close{top:5px;right:auto;}
        }
        .ask-box{position:absolute;z-index:100;top:50%;left:50%;border:5px solid #009688;height:500px;width:400px;margin-top:-300px;margin-left:-220px;border-radius:10px;box-shadow:0 6px 18px 0 rgba(0,0,0,.2);background:#fff;padding:10px;}
        .ask-box .layui-btn{border-radius:20px;}
        .ask-box .close{cursor:pointer;z-index:10;position:absolute;top:-15px;right:-15px;width:30px;height:30px;text-align:center;line-height:30px;border-radius:30px;color:#fff;background:#FF5722;}
        .ask-container{display:flex;flex-direction:row;}
        .ask-container > div:first-child{flex-grow:1;flex-basis:0;}
        .ask-container .btn{padding:0 10px;width:80px;text-align:center;}
        .ques{background-color:#F4F8FB;padding:10px 0;overflow:auto;}
        .ques .item {display: flex;flex-direction: row;margin:0 10px;margin-bottom: 10px;}
        .ques .item .text-right{padding-right: 5px;}
        .ques .item .header-photo {width:35px;}
        .ques .item .header-photo img{width:30px;height: 30px;margin-right:5px;border-radius:50%;vertical-align: top;}
        .ques .item .box {flex-grow: 1;flex-basis: 0;}
        .ques .item .box .name{color: #9A9A9A;}
        .ques .item .box .msg{background-color:#fff;line-height:25px;padding:5px 10px;margin-top:5px;border-radius:5px;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="background">
        <#--<img width="100%" height="100%" src="${params.contextPath!}/images/default.jpg" />-->
    </div>
    <#--头部标题信息-->
    <div class="header">
        <div class="layui-row">
            <div class="layui-col-md5 layui-col-xs7" style="padding-left:10px;">
                <span class="radius-text">网络延迟：{{RTT}}ms</span>
                <span class="radius-text">用户：{{userName}}</span>
            </div>
            <div class="layui-col-md2 layui-col-xs2 text-center" style="font-weight:bold;color:#2F4056;">${params.n!'-'}</div>
            <div class="layui-col-md5 layui-col-xs3 text-right" style="padding-right:20px;">
                <span class="class-out" @click="bindLeaveOut"><i class="fa fa-sign-out"></i></span>
            </div>
        </div>
    </div>
    <div class="video-container">
        <div class="teacher">
            <div class="video-item">
                <div :class="showMaxHost ? 'hand-up' : 'hand-up active'" v-if="!showMaxHost && isTeacherIn" @click="bindShowMaxHost" title="放大"><i class="fa fa-arrows"></i></div>
                <div class="name radius-user-text" v-if="!isTeacherIn">等待老师上课</div>
                <div class="video-player" id="teacher-video"></div>
            </div>
        </div>
        <div class="students swiper-container">
            <div class="swiper-wrapper">
                <div class="video-item swiper-slide" v-if="item && key != screenId && key != teachId" v-for="(item, key) in remoteStreams" :key="key">
                    <div :class="isMuteVoice ? 'hand-up' : 'hand-up active'" v-if="key == userId" @click="bindMuteVoice" title="关闭/开启音频"><i class="fa fa-microphone"></i></div>
                    <div :class="isMuteVideo ? 'hand-up video' : 'hand-up video active'" v-if="key == userId" @click="bindMuteVideo"><i class="fa fa-video-camera"></i></div>
                    <div class="name radius-user-text">{{item.name}}</div>
                    <div class="video-player" :id="'video-player-' + key"></div>
                </div>
                <#--<div class="video-item swiper-slide" v-if="JSON.stringify(remoteStreams)=='{}'" style="text-align:center;line-height:50px;">暂无学生加入</div>-->
            </div>
            <div class="swiper-button-prev"></div>
            <div class="swiper-button-next"></div>
        </div>
    </div>
    <div class="body">
        <#--共享白板功能列表-->
        <#--<div class="whiteboard-tools"></div>-->
        <div class="main">
            <#--显示共享白板-->
            <div class="box whiteboard-box" v-show="showWhiteboard">
                <div class="whiteboard" id="whiteboard-box"></div>
            </div>
            <#--大屏显示主播信息-->
            <div class="box max-host-box" v-if="showMaxHost">
                <div class="max-screen" @click="bindCloseMaxHost"><i class="fa fa-arrows"></i></div>
                <div id="max-host-video" style="height:100%"></div>
            </div>
            <#--共享屏幕-->
            <div class="box share-screen-box" id="share-screen-box" v-if="showShareScreen"></div>
        </div>
        <#--功能列表-->
        <div class="tools">
            <div class="box">
                <div class="item" title="课件" @click="bindOpenAttaments"><i class="fa fa-folder-open"></i></div>
                <div class="item" title="音视频设置" @click="bindToggleSetting"><i :class="showVideoSetting ? 'fa fa-cog' : 'fa fa-cog unactive'"></i></div>
                <div class="item" title="聊天" @click="bindOpenAsk"><i :class="showAsk ? 'fa fa-wechat' : 'fa fa-wechat unactive'"></i></div>
            </div>
        </div>
    </div>
    <#--附件-->
    <div class="attachment-box" v-if="showAttachment">
        <div class="close" @click="bindCloseAttachment"><i class="fa fa-close"></i></div>
        <div class="layui-row" style="border-bottom:2px solid #F2F2F2;padding-bottom:10px;">
            <div class="layui-col-md3">课件</div>
            <div class="layui-col-md9" style="text-align:right;">
                <button type="button" class="layui-btn" @click="loadAttachments"><i class="fa fa-refresh"></i> 刷新</button>
            </div>
        </div>
        <div style="overflow:auto;height:450px;">
            <table class="layui-table" lay-size="sm">
                <thead>
                <tr>
                    <th>文件名</th>
                    <th style="width:50px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for='(item, index) in attachmentList'>
                    <td><a :href="'${params.contextPath}/web/attachment/download.json?id=' + item.id" target="_blank">{{item.originalName}}</a></td>
                    <td><a :href="'${params.contextPath}/web/attachment/download.json?id=' + item.id" target="_blank">下载</a></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <#--音视频设置-->
    <div class="video-setting" v-if="showVideoSetting">
        <div class="layui-row setting-row">
            <div class="layui-col-md6" id="setting-video"><div class="warn-msg text-center" v-if="!videoStream">暂无本地视频</div></div>
            <div class="layui-col-md6 setting">
                <div class="item">
                    <div class="title">摄像头</div>
                    <div class="input">
                        <select @change="changeVideoinput($event)">
                            <option v-for="(item,index) in videoinputs" :key="index" :value='item.deviceId'>{{item.label}}</option>
                        </select>
                    </div>
                </div>
                <div class="item">
                    <div class="title">麦克风</div>
                    <div class="input">
                        <select @change="changeAudioinput($event)">
                            <option v-for="(item,index) in audioinputs" :key="index" :value='item.deviceId'>{{item.label}}</option>
                        </select>
                    </div>
                </div>
                <div class="item">
                    <div class="title">扬声器</div>
                    <div class="input">
                        <select>
                            <option v-for="(item,index) in audiooutputs" :key="index" :value='item.deviceId'>{{item.label}}</option>
                        </select>
                    </div>
                </div>
                <button type="button" class="layui-btn layui-btn-fluid layui-btn-radius layui-btn-normal" @click="bindCloseSetting" style="height:44px;line-height:44px;">完成</button>
            </div>
        </div>
    </div>

    <#--附件-->
    <div class="ask-box" v-if="showAsk">
        <div class="close" @click="bindCloseAsk"><i class="fa fa-close"></i></div>
        <div class="layui-row" style="border-bottom:2px solid #F2F2F2;padding-bottom:10px;">
            <div class="layui-col-md12">讨论</div>
        </div>
        <div style="overflow:auto;height:400px;margin-bottom:10px;" class="ques" id="im-msg-box">
            <div class="item" v-for='(item, index) in askMsgs'>
                <#--<div class="header-photo" v-if="!item.active">
                    <img class="img" :src='item.p'/>
                </div>-->
                <div class="box" v-if="!item.active">
                    <div class="name">{{item.name}}</div>
                    <div class="msg">{{item.msg}}</div>
                </div>
                <div class="box" v-if="item.active">
                    <div class="name text-right">{{item.name}}</div>
                    <div class="msg">{{item.msg}}</div>
                </div>
                <#--<div class="header-photo" v-if="item.active">
                    <img class="img" :src='item.p'/>
                </div>-->
            </div>
        </div>
        <div class="ask-container">
            <div><input type="text" v-model="askMsg" v-on:keyup.13="sendAsk" placeholder="欢迎讨论" class="layui-input"></div>
            <div class="btn"><button type="button" class="layui-btn layui-btn-danger" @click="sendAsk">发送</button></div>
        </div>
    </div>

</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showAsk: false,
            showWhiteboard: true,//是否显示白板
            showShareScreen: false,//是否显示共享屏幕
            showMaxHost: false,//是否显示主播大屏

            showVideoSetting: false,//是否显示音视频设置信息

            isMuteVoice:false,//是否关闭掉声音
            isMuteVideo:false,//是否关闭掉摄像头

            isTeacherIn: false,

            userName: "${(user.name)!}",
            userId:'${(user.id)!}',//当前用户ID

            videoClient: null,//视频端
            videoStream: null,//视频流
            teacherStream: null,//老师流
            remoteStreams: {},//远程订阅流，包含自己

            cId: '${params.cid!}',
            webrtcId: ${params.videoKey!0},
            roomId: ${params.rid!''},
            videoSig: '${params.s!}',
            screenId: '${params.t!}_screen',
            teachId: '${params.t!}',

            attachmentList:[],
            showAttachment:false,

            RTT:'--',//网络延时

            videoinputs:[],//摄像头
            audioinputs:[],//麦克风
            audiooutputs:[],//扬声器

            rtmClient:null,

            teduBoard: null,
            boardAppId:${params._bk!0},
            boardSig:'${params._bs!}',

            askMsg:'',
            askMsgs:[],
        },
        mounted: function () {
            this.initVideo();
            this.initWebSocket();
            this.initBoard();
            setInterval(this.getNetworkTT, 1000);
            $(window).resize();

            window.swiper = new Swiper('.swiper-container', {
                slidesPerView:"auto",
                spaceBetween: 10,
                //freeMode: true,
                observer:true,
                observeParents:true,
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
            });

            var height = $("#whiteboard-box").height();
            var width = $("#whiteboard-box").width();
            $("#whiteboard-box").height(height);
            $("#whiteboard-box").width(width);
        },
        methods: {
            getNetworkTT: function () {//获取网络延时
                if (!this.videoClient) {
                    return;
                }
                var that = this;
                this.videoClient.getTransportStats().then(function (stats) {
                    that.RTT = stats.rtt || "--";
                });
            },
            initWebSocket: function () {
                var that = this;
                this.rtmClient = YunfeiRTM.createInstance({
                    url: '${params.webSocketUrl!}',
                    roomId: this.cId,
                    deviceId: this.userId
                });

                this.rtmClient.on("unmute_voice", function (data) {
                    that.unmuteAudio();
                });

                this.rtmClient.on("mute_voice", function (data) {
                    that.muteAudio();
                });

                this.rtmClient.on("kick_out", function (data) {
                    that.bindLeaveOut();
                });

                this.rtmClient.on("teduboard", function (data) {
                    that.teduBoard.addSyncData(data.msg);
                });

                this.rtmClient.on("im", function (data) {
                    var result = data.msg;
                    var p = result.p || '${params.contextPath!}/images/default.jpg';
                    that.askMsgs.push({name: result.u, msg: result.msg, active: (result.uid == that.userId), p: p});
                    that.$nextTick(function () {
                        var imContainer = document.getElementById('im-msg-box') // 获取对象
                        imContainer.scrollTop = imContainer.scrollHeight // 滚动高度
                    });
                });
            },
            initBoard: function () {
                if (!this.boardSig || this.boardAppId <= 0) {
                    return;
                }
                var params = {
                    id: 'whiteboard-box',
                    classId: this.roomId,
                    sdkAppId: this.boardAppId,
                    userId: this.userId,
                    drawEnable:false,
                    userSig: this.boardSig,
                };
                this.teduBoard = new TEduBoard(params);
            },
            loadAttachments: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/queryAttachments.json", {
                    courseItemId: this.cId,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.attachmentList = data.data;
                });
            },
            getDevices: function () {
                var that = this;
                TRTC.getDevices().then(function (devices) {
                    var options = {audiooutput: [], audioinput: [], videoinput: []};
                    for (var i = 0; i < devices.length; i++) {
                        var device = devices[i];
                        options[device.kind].push({deviceId: device.deviceId, label: (device.label || "设备-" + i)});
                    }
                    that.audiooutputs = options.audiooutput;
                    that.audioinputs = options.audioinput;
                    that.videoinputs = options.videoinput;
                }, function (errStr) {
                    $.message("获取设备信息失败：" + JSON.stringify(errStr));
                });
            },
            initVideo:function(){//初始化视频
                if (!this.webrtcId) {
                    $.message("音视频Key未配置，无法初始化音视频");
                    return;
                }
                var that = this;
                this.videoClient = TRTC.createClient({
                    mode: 'live',
                    sdkAppId: this.webrtcId,
                    userId: this.userId,
                    userSig: this.videoSig
                });
                this.videoClient.join({roomId: this.roomId, role: 'anchor'}).then(function () {
                    $.message('加入直播间成功');
                    that.subscribeVideoEvents();
                    that.publishStream();
                }).catch(function (error) {
                    that.videoClient = null;
                    $.message('进房失败：' + JSON.stringify(error));
                    console.error('进房失败 ' + error);
                });
            },
            publishStream: function () {
                if (!this.videoClient) {
                    $.message("视频未初始化");
                    return;
                }
                if (this.remoteStreams[this.userId]) {
                    return;
                }
                var that = this;
                that.videoStream = TRTC.createStream({userId: that.userId, audio: true, video: true});
                that.videoStream.setVideoProfile('480p');
                that.videoStream.initialize().then(function () {
                    that.publishVideo();
                    that.getDevices();
                    console.log('初始化本地流成功');
                }).catch(function (error) {
                    that.videoClient && that.videoClient.leave();
                    that.videoClient = null;
                    that.videoStream = null;
                    console.error('初始化本地流失败 ' + error);
                });
            },
            publishVideo: function () {
                var that = this;
                this.videoClient.publish(this.videoStream).then(function () {
                    $.message('本地音视频流发布成功');
                    that.addRemoteVideo(that.videoStream);
                    //that.videoStream.play("video-player", {objectFit1: "contain"});
                }).catch(function (error) {
                    that.videoStream = null;
                    $.message('本地流发布失败：' + JSON.stringify(error));
                    console.error('本地流发布失败：' + error);
                });
            },
            muteAudio:function () {//静音
                if (!this.videoStream) {
                    $.message("音频不存在");
                    return false;
                }
                this.isMuteVoice = true;
                this.videoStream.muteAudio();
                $.message("已被静音");
                return true;
            },
            unmuteAudio:function () {//启用音频
                if (!this.videoStream) {
                    $.message("音频不存在");
                    return false;
                }
                this.isMuteVoice = false;
                this.videoStream.unmuteAudio();
                $.message("已被启用音频");
            },
            leaveRoom: function () {//离开频道
                this.videoClient && this.videoClient.leave(function () {
                    console.log("client leaves channel");
                }, function (err) {
                    console.log("client leave failed ", err);
                });
                this.videoClient = null;
            },
            subscribeVideoEvents:function(){
                var that = this;
                //远端流增加
                this.videoClient.on('stream-added', function (event) {
                    that.videoClient.subscribe(event.stream);
                });
                //订阅远端流
                this.videoClient.on('stream-subscribed', function (event) {
                    var stream = event.stream;
                    that.addRemoteVideo(stream);
                });
                //远端流移除
                this.videoClient.on('stream-removed', function (event) {
                    var stream = event.stream;
                    that.closeRemoteVideo(stream.getUserId());
                });
            },
            addRemoteVideo: function (stream) {//添加远程连麦视频流
                if (!stream) {
                    console.log("该远程视频流不存在，无法添加");
                }
                var streamId = stream.getUserId();
                if (streamId == this.teachId) {
                    this.isTeacherIn = true;
                    this.teacherStream = stream;
                }
                if (streamId == this.screenId) {
                    this.showShareScreen = true;
                    this.showWhiteboard = false;
                }
                this.$set(this.remoteStreams, streamId, stream);
                this.$nextTick(function () {
                    for (var key in this.remoteStreams) {
                        var stream = this.remoteStreams[key];
                        if (!stream || stream.isPlaying_) {
                            continue;
                        }
                        if (key == this.teachId) {
                            stream.play("teacher-video", {objectFit1: "contain"});
                            continue;
                        }
                        if (key == this.screenId) {
                            if (this.showMaxHost) {
                                this.bindCloseMaxHost();
                            }
                            stream.play("share-screen-box", {objectFit1: "contain"});
                            continue;
                        }
                        stream.play("video-player-" + key, {objectFit1: "contain"});
                    }
                });
            },
            closeRemoteVideo: function (streamId) {
                if (!streamId) {
                    console.log("该远程视频流不存在，无法关闭");
                    return;
                }
                var stream = this.remoteStreams[streamId];
                stream && stream.stop();
                this.$set(this.remoteStreams, streamId, null);
                if (streamId == this.screenId) {
                    this.showShareScreen = false;
                    this.showWhiteboard = true;
                }
                if (streamId == this.teachId) {
                    this.isTeacherIn = false;
                    this.teacherStream = null;
                }

                if (streamId == this.userId) {
                    stream && stream.close();
                    this.videoClient.unpublish(stream, function (err) {
                        console.log("取消发布本地音视频流 error: " + err);
                    });
                    this.videoStream == null;
                }
            },
            bindShowShareScreen: function (screenStream) {
                if (this.showMaxHost) {
                    this.bindCloseMaxHost();
                }
                this.showWhiteboard = false;
                this.showShareScreen = true;
                this.$nextTick(function () {
                    screenStream.play("share-screen-box", {objectFit1: "contain"});
                });
            },
            bindCloseMaxHost: function () {//关闭主播大屏显示
                if (!this.teacherStream) {
                    $.message("老师还未开启视频");
                    return;
                }
                this.showMaxHost = false;
                this.showWhiteboard = true;
                this.$nextTick(function () {
                    this.teacherStream.stop();
                    this.teacherStream.play("teacher-video", {objectFit1: "contain"});
                });
            },
            bindShowMaxHost: function () {//开启主播大屏显示
                if (this.showShareScreen) {
                    $.message("老师正在共享屏幕");
                    return;
                }
                if (!this.isTeacherIn) {
                    $.message("老师还未开启视频");
                    return;
                }
                this.showWhiteboard = false;
                this.showMaxHost = true;
                this.$nextTick(function () {
                    this.teacherStream && this.teacherStream.stop();
                    this.teacherStream && this.teacherStream.play("max-host-video", {objectFit1: "contain"});
                });
            },
            getUserField: function (id, key) {
                var users = this.userList;
                for (var i = 0; i < users.length; i++) {
                    var meetingUser = users[i];
                    if (meetingUser.userId == id) {
                        return meetingUser[key];
                    }
                }
                return '';
            },
            changeVideoinput:function(e){
                var deviceId = e.target.value;
                if (this.videoStream) {
                    this.videoStream.switchDevice('video', deviceId, function () {
                        $.message("切换摄像头成功！");
                    }, function (err) {
                        $.message("切换摄像头失败：" + JSON.stringify(err));
                    });
                }
            },
            changeAudioinput:function(e){
                var deviceId = e.target.value;
                if (this.videoStream) {
                    this.videoStream.switchDevice('audio', deviceId, function () {
                        $.message("切换麦克风成功！");
                    }, function (err) {
                        $.message("切换麦克风失败：" + JSON.stringify(err));
                    });
                }
            },
            bindCloseAttachment:function(){
                this.showAttachment = false;
            },
            bindToggleSetting: function () {
                if (this.showVideoSetting) {
                    this.bindCloseSetting();
                    return;
                }
                this.showVideoSetting = true;
                this.$nextTick(function () {
                    this.videoStream && this.videoStream.stop();
                    this.videoStream && this.videoStream.play("setting-video"/*, {objectFit1: "contain"}*/);
                    this.videoStream && this.$set(this.remoteStreams, this.videoStream.getUserId(), null);
                });
            },
            bindCloseSetting: function () {
                this.videoStream && this.videoStream.stop();
                this.videoStream && this.$set(this.remoteStreams, this.videoStream.getUserId(), this.videoStream);
                this.showVideoSetting = false;
                this.$nextTick(function () {
                    for (var key in this.remoteStreams) {
                        var stream = this.remoteStreams[key];
                        if (!stream || stream.isPlaying_) {
                            continue;
                        }
                        stream.play("video-player-" + key, {objectFit1: "contain"});
                    }
                });
            },
            bindMuteVoice:function () {//是否关闭掉声音
                if (!this.videoStream) {
                    $.message("未开启视频");
                    return;
                }
                 if (this.isMuteVoice) {
                    this.unmuteAudio();
                    return;
                }
                this.muteAudio();
            },
            bindMuteVideo:function () {//是否关闭掉视频
                if (!this.videoStream) {
                    $.message("未开启视频");
                    return;
                }
                if (this.isMuteVideo) {
                    this.isMuteVideo = false;
                    this.videoStream.unmuteVideo();
                    return;
                }
                this.isMuteVideo = true;
                this.videoStream.muteVideo();
            },
            bindOpenAttaments:function () {
                this.showAttachment = true;
                if (this.attachmentList.length <= 0) {
                    this.loadAttachments();
                }
            },
            bindLeaveOut: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/participateUser/save.json", {
                    roomId: this.cId
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.leaveRoom();
                    window.close();
                });
            },
            bindCloseAsk: function () {
                this.showAsk = false;
            },
            bindOpenAsk: function () {
                this.showAsk = true;
                this.$nextTick(function () {
                    var imContainer = document.getElementById('im-msg-box') // 获取对象
                    imContainer.scrollTop = imContainer.scrollHeight // 滚动高度
                });
            },
            sendAsk: function () {
                if (!this.askMsg) {
                    $.message("不能发送空信息");
                    return;
                }
                if (this.askMsg.length > 1000) {
                    $.message("聊天字符超过500，无法发送");
                    return;
                }
                var data = {
                    roomId: this.cId,
                    type: 'im',
                    msg: {msg: this.askMsg, u: "${user.name!}", uid: '${user.id!}', p: '${user.headPhoto!}'}
                };
                this.askMsg = "";
                this.rtmClient.send(data);
            }
        }
    });

    var showNotice = function (msg) {
        try {
            Notification.requestPermission(function (permission) {
                if (permission == "granted") {
                    new Notification('连麦提醒', {body:msg, tag:'yunfeiTag'});
                }
            });
        } catch (e) {
            console.log(e);
        }
    };
</script>
</body>

</html>
