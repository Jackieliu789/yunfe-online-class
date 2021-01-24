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
    <script type="text/javascript" src="${params.contextPath}/js/yunfei-socket.js?_t=${params.pageRandom!}"></script>
    <link rel="stylesheet" href="https://sdk.herewhite.com/white-web-sdk/2.6.3.css">
    <script src="https://sdk.herewhite.com/white-web-sdk/2.6.3.js"></script>
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
        .body .right{width:300px;background:rgba(255,255,255,0.8);border-left:1px solid #fff;display:flex;flex-direction:column;}
        .recording{background:rgba(0,0,0,0.4);border-radius:22px;color:#fff;padding:5px 10px;font-size:12px;margin-right:10px;}
        .recording .fa{color:#f33;font-size:9px;margin-right:5px;}
        .class-out{cursor:pointer;}
        .radius-text{background:rgba(0,0,0,0.2);color:#393D49;padding:5px 10px;border-radius:20px;font-size:12px;margin-right:10px;}
        .tools{width:50px;padding-left:10px;}
        .tools .box{background:rgba(0,0,0,0.6);color:#fff;margin-top:150px;border-radius:10px 0 0 10px;}
        .tools .box .item{font-size:22px;text-align:center;padding:8px;cursor:pointer;}
        .tools .box .item:last-child{padding-bottom1:10px;}
        .whiteboard-tools{width:50px;padding-right:10px;}
        .whiteboard-tools .box{background:rgba(0,0,0,0.6);color:#fff;margin-top:100px;border-radius:0 10px 10px 0;}
        .whiteboard-tools .box .item{font-size:22px;text-align:center;padding:8px;cursor:pointer;position:relative;}
        .whiteboard-tools .box .item:first-child{border-radius:0 10px 0 0;}
        .whiteboard-tools .box .item:last-child{border-radius:0 0 10px 0;}
        .right .video{height:240px;background:#999;position:relative;}
        .max-screen, .mute-voice, .mute-video{z-index:10;position:absolute;cursor:pointer;background:#fff;width:30px;height:30px;text-align:center;line-height:30px;border-radius:30px;}
        .max-screen{right:10px;top:10px;}
        .mute-voice{bottom:10px;left:10px;color:#1E9FFF;}
        .mute-video{bottom:10px;left:50px;color:#1E9FFF;}
        .video-player{height:100%;}
        .video-user{position:absolute;bottom1:0;font-size1:200px;color:#fff;left1:85px;width:90%;text-align:center;top:20px;}
        .right .box{display:flex;flex-direction:column;flex-grow:1;flex-basis:0;}
        .im-msg-box, .record-box{flex-grow:1;flex-basis:0;padding:10px;overflow:auto;}
        .im-send-box{border-top:1px solid #fff;padding:10px;}
        .im-send-box input[type="text"]{height:30px;border:0;border-radius: 15px;padding:0 10px;margin:0 5px;vertical-align:top;flex-grow:1;flex-basis:0;width:100%;background: #f2f2f2;}
        .im-send-box input[type="button"]{height:30px;line-height:30px;vertical-align:top;border-radius: 15px;}
        .video-container{position:absolute;left:0;top:0;z-index:10;}
        .video-item{position:relative;width:200px;height:120px;display:inline-block;margin-right:10px;margin-bottom:10px;}
        .video-item .hand-up{z-index:10;position:absolute;right:10px;top:10px;width:30px;height:30px;line-height:30px;cursor:pointer;background:rgba(0,0,0,0.2);color:#fff;border-radius:50%;text-align:center;}
        .video-item .name{z-index:10;position:absolute;left:10px;top:10px;color:#fff;}
        .im-send-box{display:flex;flex-direction:row;}
        .im-image{font-size:24px;line-height:30px;color:#1E9FFF;cursor:pointer;}
        .msg-item{margin-bottom:10px;}
        .msg-item .name{color:#FF5722;font-size:12px;}
        .msg-item .msg{border-radius:5px;padding:10px;background:#f2f2f2;display:inline-block;clear:both;}
        .msg-item .msg img{max-width:100px;cursor:pointer;}
        .msg-item.this .name{text-align:right;}
        .msg-item.this .msg{background-color:#5FB878;float:right;color:#fff;}
        .msg-item.this:after{content:" ";display:block;clear:both;}
        .record-item{display:flex;flex-direction:row;line-height:35px;}
        .record-item > div{flex-grow:1}
        .record-item > div:last-child{text-align:right;cursor:pointer;}
        .radius-user-text{background:rgba(0,0,0,0.2);color:#2F4056;padding:5px 10px;border-radius:20px;font-size:12px;margin-right:5px;}
        .unactive{color:#c2c2c2;}
        .active{color:#fff;background:#FF5722;}
        .main .box{height:100%;position:relative;}
        .color-box{position:absolute;top:-90px;left:54px;border:none;}
        .color-box .color:first-child{border-radius:5px 5px 0 0;}
        .color-box .color:last-child{border-radius:0 0 5px 5px;background:#fff;}
        .audio-player{position:absolute;z-index:100;top:50%;left:50%;border:5px solid #009688;height:50px;width:400px;margin-top:-150px;margin-left:-300px;border-radius:30px;box-shadow:0 6px 18px 0 rgba(0,0,0,.2);}
        .audio-player audio{width:100%;height:100%;border-radius:30px;}
        .mp4-player{position:absolute;z-index:100;top:50%;left:50%;border:5px solid #009688;width:800px;height:600px;margin-top:-300px;margin-left:-500px;border-radius1:10px;box-shadow:0 6px 18px 0 rgba(0,0,0,.2);background:#F2F2F2;}
        .mp4-player video{width:100%;height:100%;border-radius1:10px;}
        .attachment-box{position:absolute;z-index:100;top:50%;left:50%;border:5px solid #009688;height:500px;width:500px;margin-top:-300px;margin-left:-300px;border-radius:10px;box-shadow:0 6px 18px 0 rgba(0,0,0,.2);background:#fff;padding:10px;}
        .attachment-box .layui-btn{border-radius:20px;}
        .audio-player .close, .mp4-player .close, .attachment-box .close{cursor:pointer;z-index:10;position:absolute;top:-15px;right:-15px;width:30px;height:30px;text-align:center;line-height:30px;border-radius:30px;color:#fff;background:#FF5722;}
        .mp-play{background:#01AAED;padding:5px 10px;color:#fff;border-radius:20px;font-size:12px;cursor:pointer;}
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
        @media screen and (max-width:768px ) {
            .body .right{width:150px;}
            .right .video{height:100px;}
            .video-setting{top:0;right:0;bottom:0;left:0;overflow:auto;background:#fff;margin-top:0;margin-left:0;position:fixed;}
            .setting-row{width:100%;}
            .attachment-box{top:0;right:0;bottom:0;left:0;overflow:auto;margin-top:0;margin-left:0;position:fixed;width:auto;height:auto;}
            .attachment-box .close{top:5px;right:auto;}
        }
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
    <div class="body">
        <#--共享白板功能列表-->
        <div class="whiteboard-tools">
            <#--<div class="box" v-if="showWhiteboard">
                <div class="item" data-type="save" title="保存"><i class="fa fa-save"></i></div>
            </div>-->
        </div>
        <div class="main">
            <#--连麦列表-->
            <div class="video-container">
                <div class="video-item" v-if="item && key != screenId && key != teachId" v-for="(item, key) in remoteStreams" :key="key">
                    <div class="hand-up" v-if="key == userId" @click="closeRemoteVideo(key)"><i class="fa fa-tty"></i></div>
                    <div class="name" v-if="item.name">{{item.name}}</div>
                    <div class="video-player" :id="'video-player-' + key"></div>
                </div>
            </div>
            <#--显示共享白板-->
            <div class="box whiteboard-box" v-show="showWhiteboard">
                <div class="whiteboard" id="whiteboard-box"></div>
            </div>
            <#--大屏显示主播信息-->
            <div class="box max-host-box" v-if="showMaxHost">
                <div class="max-screen" @click="bindCloseMaxHost"><i class="fa fa-arrows"></i></div>
                <div id="max-host-video" style="height:100%;"></div>
            </div>
            <#--共享屏幕-->
            <div class="box share-screen-box" id="share-screen-box" v-if="showShareScreen"></div>
        </div>
        <#--功能列表-->
        <div class="tools">
            <div class="box">
                <div class="item" title="课件" @click="bindOpenAttaments"><i class="fa fa-folder-open"></i></div>
                <div class="item" title="申请连麦" @click="bindHandApply"><i class="fa fa-hand-stop-o"></i></div>
                <div class="item" title="音视频设置" @click="bindToggleSetting"><i :class="showVideoSetting ? 'fa fa-cog' : 'fa fa-cog unactive'"></i></div>
            </div>
        </div>
        <div class="right">
            <#--主播视频显示区域-->
            <div class="video">
                <div class="max-screen" v-if="!showMaxHost && isTeacherIn" @click="bindShowMaxHost"><i class="fa fa-arrows-alt"></i></div>
                <div class="video-player" id="video-player"></div>
                <div class="video-user" v-if="showMaxHost || !isTeacherIn"><#--<i class="fa fa-user"></i>-->等待老师上课</div>
            </div>
            <#--即时聊天-->
            <div class="box">
                <div class="layui-tab layui-tab-brief" style="margin:0px;">
                    <ul class="layui-tab-title" style="background:#fff;">
                        <li class="layui-this">讨论区</li>
                    </ul>
                </div>
                <#--即时聊天信息-->
                <div class="im-msg-box" id="im-msg-box">
                    <div :class="item.active ? 'msg-item this' : 'msg-item'" v-for='(item, index) in imMsgs'>
                        <div class="name">{{item.name}}</div>
                        <div class="msg" v-if="item.msg">{{item.msg}}</div>
                        <div class="msg" v-if="item.img"><img :src="item.img"/></div>
                    </div>
                </div>
                <div class="im-send-box">
                    <input type="text" v-on:keyup.13="bindSendImMsg" v-model="imMsg" :placeholder="isStopWord ? '全体禁言' : '说点什么'" :disabled="isStopWord">
                    <input type="button" @click="bindSendImMsg" class="layui-btn layui-btn-normal" value="发送" :disabled="isStopWord">
                </div>
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

</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showVideoFileBox: false,//是否显示回放记录
            showShareScreen: false,//是否显示共享屏幕
            showWhiteboard: true,//是否显示白板
            showMaxHost: false,//是否显示主播大屏
            showVideoSetting: false,//是否显示音视频设置信息

            isLinkCamera: true,//是否可以连麦
            isStopWord: false,//是否全体禁言

            isTeacherIn: false,//老师频道是否加入

            imMsg: '',//input中聊天信息
            imMsgs: [],//聊天信息

            userId: '${(user.id)!}',//当前用户ID
            userName: "${(user.name)!}",
            videoClient: null,//视频端
            videoStream: null,//视频流
            remoteStreams: {},//远程订阅流，包含自己

            cId: '${params.cid!}',
            webrtcId: ${params.videoKey!0},
            roomId: ${params.rid!''},
            videoSig: '${params.s!}',
            screenId: '${params.t!}_screen',
            teachId: '${params.t!}',

            attachmentList: [],
            showAttachment: false,

            RTT: '--',//网络延时

            videoinputs: [],//摄像头
            audioinputs: [],//麦克风
            audiooutputs: [],//扬声器

            rtmClient:null,

            teduBoard: null,
            boardAppId:${params._bk!0},
            boardSig:'${params._bs!}',
        },
        mounted: function () {
            this.initVideo();
            this.initWebSocket();
            this.initBoard();
            //this.getDevices();

            setInterval(this.getNetworkTT, 1000);
            $(window).resize();

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

                this.rtmClient.on("im", function (data) {
                    var result = data.msg;
                    that.imMsgs.push({
                        name: result.u,
                        msg: result.msg,
                        img: result.img,
                        active: (result.uid == that.userId)
                    });
                    that.$nextTick(function () {
                        var imContainer = document.getElementById('im-msg-box') // 获取对象
                        imContainer.scrollTop = that.imMsgs.length * 1000 // 滚动高度
                    });
                });

                this.rtmClient.on("hand_speak", function (data) {
                    that.publishStream();
                });

                this.rtmClient.on("speak_over", function (data) {
                    that.closeRemoteVideo(that.userId);
                });

                this.rtmClient.on("link_camera", function (data) {
                    that.isLinkCamera = data.msg === "true";
                });

                this.rtmClient.on("stop_word", function (data) {
                    that.isStopWord = data.msg === "true";
                });

                this.rtmClient.on("teduboard", function (data) {
                    that.teduBoard.addSyncData(data.msg);
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
            initVideo: function () {//初始化视频
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
                this.videoClient.join({roomId: this.roomId, role: 'audience'}).then(function () {
                    $.message('加入直播间成功');
                    that.subscribeVideoEvents();
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
                this.videoClient.switchRole("anchor").then(function () {
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
                }).catch(function (error) {
                    $.message('切换角色失败：' + JSON.stringify(error));
                    console.error('切换角色失败 ' + error);
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
            leaveRoom: function () {//离开频道
                this.videoClient && this.videoClient.leave(function () {
                    console.log("client leaves channel");
                }, function (err) {
                    console.log("client leave failed ", err);
                });
                this.videoClient = null;
            },
            subscribeVideoEvents: function () {
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
                }
                if (streamId == this.screenId) {
                    this.showShareScreen = true;
                    this.showWhiteboard = false;
                    if (this.showMaxHost) {
                        this.showMaxHost = false;
                        this.$nextTick(function () {
                            var stream = this.remoteStreams[this.teachId];
                            stream && stream.stop();
                            stream && stream.play("video-player", {objectFit1: "contain"});
                        });
                    }
                }
                this.$set(this.remoteStreams, streamId, stream);
                this.$nextTick(function () {
                    for (var key in this.remoteStreams) {
                        var stream = this.remoteStreams[key];
                        if (!stream || stream.isPlaying_) {
                            continue;
                        }
                        if (key == this.teachId) {
                            stream.play("video-player", {objectFit1: "contain"});
                            continue;
                        }
                        if (key == this.screenId) {
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
                    this.showMaxHost = false;
                }

                if (streamId == this.userId) {
                    stream && stream.close();
                    this.videoClient.unpublish(stream, function (err) {
                        console.log("取消发布本地音视频流 error: " + err);
                    });
                    this.videoStream == null;
                    this.videoClient.switchRole("audience");
                }
            },
            changeVideoinput: function (e) {
                var deviceId = e.target.value;
                if (this.videoStream) {
                    this.videoStream.switchDevice('video', deviceId).then(function () {
                        $.message("切换摄像头成功！");
                    }).catch(function (err) {
                        $.message("切换摄像头失败：" + JSON.stringify(err));
                    });
                }
            },
            changeAudioinput: function (e) {
                var deviceId = e.target.value;
                if (this.videoStream) {
                    this.videoStream.switchDevice('audio', deviceId).then(function () {
                        $.message("切换麦克风成功！");
                    }).catch(function (err) {
                        $.message("切换麦克风失败：" + JSON.stringify(err));
                    });
                }
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
            bindSendImMsg: function () {//发送聊天信息
                if (!this.imMsg) {
                    $.message("不能发送空信息");
                    return;
                }
                if (this.imMsg.length > 500) {
                    $.message("聊天字符超过500，无法发送");
                    return;
                }
                var data = {roomId: this.cId, type: 'im', msg: {msg: this.imMsg, u: "${user.name!}", uid: '${user.id!}'}};
                this.imMsg = "";
                this.rtmClient.send(data);
            },
            bindCloseMaxHost: function () {//关闭主播大屏显示
                this.showMaxHost = false;
                this.showWhiteboard = true;
                this.$nextTick(function () {
                    var stream = this.remoteStreams[this.teachId];
                    stream && stream.stop();
                    stream && stream.play("video-player", {objectFit1: "contain"});
                });
            },
            bindShowMaxHost: function () {//开启主播大屏显示
                if (this.showShareScreen) {
                    $.message("正在共享屏幕");
                    return;
                }
                this.showWhiteboard = false;
                this.showMaxHost = true;
                this.$nextTick(function () {
                    var stream = this.remoteStreams[this.teachId];
                    stream && stream.stop();
                    stream && stream.play("max-host-video", {objectFit1: "contain"});
                });
            },
            bindHandApply: function () {
                if (!this.isLinkCamera) {
                    $.message("老师未开启连麦");
                    return;
                }
                var data = {roomId: this.cId, deviceIds: this.teachId, type: 'hand_apply', msg: {uid: this.userId, u: "${user.name!}"}};
                this.rtmClient.send(data);
                $.message("连麦请求发送成功");
            },
            bindOpenAttaments: function () {
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
            }
        }
    });
</script>
</body>

</html>
