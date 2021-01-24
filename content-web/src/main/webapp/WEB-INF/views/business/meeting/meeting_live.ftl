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
    <style>
        body, html, #app {margin: 0;height: 100%;}
        [v-cloak]{display:none !important;}
        .header{height:30px;line-height:30px;color:#fff;font-size:14px;position:fixed;top:10px;right:240px;left:0;text-align:center;z-index:10}
        .header .title{background:rgba(0,0,0,0.5);text-align:center;margin:0 auto;display:inline-block;padding:0 30px;border-radius:15px;}
        .body, .main-box, .video-list{height:100%;}
        .body{display:flex;flex-direction:row;}
        .main-box{flex-grow:1;flex-basis:0;}
        .video-list{width:220px;padding:0 10px;overflow:auto;}
        .video-item{height:180px;border:1px solid #F2F2F2;position:relative;margin-top:10px;}
        .video-item:last-child{margin-bottom:10px;}
        .video-item .video{height:100%;}
        .video-item .name, .video-item .voice, .video-item .camera{position:absolute;background:rgba(0,0,0,0.2);}
        .video-item .name{top:10px;left:10px;color:#FF5722;line-height:25px;font-size:12px;padding:0 10px;border-radius:30px;}
        .video-item .voice, .video-item .camera{bottom:10px;color:#FF5722;height:30px;line-height:30px;width:30px;border-radius:50%;text-align:center;cursor:pointer;}
        .video-item .voice{right:50px;}
        .video-item .camera{right:10px;}
        .tools-box{position:fixed;bottom:20px;right:240px;left:0;z-index:10}
        .tools-container{margin:0 auto;text-align:center;background:rgba(0,0,0,0.5);width:500px;border-radius:5px;}
        .tools-container .item{display:inline-block;color:#fff;padding:10px 15px;font-size:12px;color:#ddd;cursor:pointer;}
        .tools-container .item img{width:20px;margin-bottom:5px;}
        .tools-container .item > div{font-size:12px;}
        .white-show{background: rgba(255,255,255,0.5) !important;}
        .white-show .item > div{color:#2F4056;}
        .my-video, .my-screen{position:absolute;border:1px solid #F2F2F2;width:200px;height:150px;top:10px;left:10px;z-index:10;}
        .my-screen{top:170px;}
        .video-setting{position:absolute;top:50%; left:50%;margin-top:-250px;margin-left:-350px;z-index:210;border:5px solid #009688;border-radius:8px;}
        .setting-row{box-shadow:0 6px 18px 0 rgba(0,0,0,.2);background:#fff;border-radius:8px;width:700px;height:500px;}
        .setting{padding:50px 40px;}
        .setting .item{margin-bottom:40px;}
        .setting .title{color:rgba(0, 0, 0, 0.54);font-size:12px;margin-bottom:5px;}
        .setting .input select{width:100%;font-size:18px;line-height:40px;height:40px;border:none;border-bottom:1px solid #eee;color:rgba(0, 0, 0, 0.8);}
        #setting-video{height:100%;}
        #setting-video .warn-msg{margin-top: 20px;}
        @media screen and (max-width:768px ) {
            .right .video{height:100px;}
            .video-setting{top:0;right:0;bottom:0;left:0;overflow:auto;background:#fff;margin-top:0;margin-left:0;position:fixed;}
            .setting-row{width:100%;}
        }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="header">
        <div :class="mainStream ? 'title white-show' : 'title'">${params.n!'-'}</div>
    </div>
    <div class="body">
        <div class="main-box" id="main-box"></div>
        <div class="video-list">
            <div class="video-item" v-if="item" v-for="(item, key) in remoteStreams" :key="key" @click="playToMain(key)">
                <div class="video" :id="'video-player-' + item.getUserId()"></div>
                <div class="name white-show">{{item.name}}</div>
                <div class="voice white-show" v-if="hostId == userId && !item.isScreen"><i class="fa fa-microphone"></i></div>
                <div class="camera white-show" v-if="hostId == userId && !item.isScreen"><i class="fa fa-video-camera"></i></div>
            </div>
        </div>
    </div>
    <div class="my-video" id="my-video" v-if="videoStream"></div>
    <div class="my-screen" id="my-screen" v-if="screenStream"></div>
    <div class="tools-box">
        <div :class="mainStream ? 'tools-container white-show' : 'tools-container'">
            <div class="item" @click="allMuteMicrophone" v-if="isAllOpenMicrophone && hostId == userId">
                <div><img src="${params.contextPath!}/images/microphone_close.png" alt=""></div>
                <div>全部静音</div>
            </div>
            <div class="item" @click="allUnMuteMicrophone" v-if="!isAllOpenMicrophone && hostId == userId">
                <div><img src="${params.contextPath!}/images/microphone.png" alt=""></div>
                <div>全部启用</div>
            </div>
            <div class="item" @click="bindShowShareScreen">
                <div><img src="${params.contextPath!}/images/screen.png" alt=""></div>
                <div>共享屏幕</div>
            </div>
            <div class="item" @click="muteAudio" v-if="isOpenMicrophone">
                <div><img src="${params.contextPath!}/images/microphone_close.png" alt=""></div>
                <div>关闭音频</div>
            </div>
            <div class="item" @click="unmuteAudio" v-if="!isOpenMicrophone">
                <div><img src="${params.contextPath!}/images/microphone.png" alt=""></div>
                <div>启用音频</div>
            </div>
            <div class="item" @click="bindMuteVideo" v-if="isOpenCarema">
                <div><img src="${params.contextPath!}/images/camera_close.png" alt=""></div>
                <div>关闭视频</div>
            </div>
            <div class="item" @click="bindMuteVideo" v-if="!isOpenCarema">
                <div><img src="${params.contextPath!}/images/camera.png" alt=""></div>
                <div>启用视频</div>
            </div>
            <div class="item" @click="bindToggleSetting">
                <div><img src="${params.contextPath!}/images/seeting.png" alt=""></div>
                <div>设置</div>
            </div>
            <div class="item" @click="signOut">
                <div><img src="${params.contextPath!}/images/signout.png" alt=""></div>
                <div>退出</div>
            </div>
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
            isOpenCarema: true,
            isOpenMicrophone:true,
            isAllOpenMicrophone:true,
            showVideoSetting:false,

            mainStream: null,

            videoClient: null,//视频端
            videoStream: null,//视频流

            screenClient: null,//桌面端
            screenStream: null,//屏幕流

            remoteStreams: {},//远程订阅流，包含自己

            mId: '${params.mid!}',
            userId:'${(user.id)!}',
            webrtcId: ${params.videoKey!0},
            roomId: ${params.rid!''},
            videoSig:'${params.s!}',
            screenSig:'${params.sc!}',
            screenId:'${(user.id)!}_screen',
            hostId:'${params.h!}',
            userList:[],

            videoinputs:[],//摄像头
            audioinputs:[],//麦克风
            audiooutputs:[],//扬声器

            rtmClient:null,
        },
        mounted: function () {
            this.loadUsers();
            this.initWebSocket();
        },
        methods: {
            initWebSocket: function () {
                this.rtmClient = YunfeiRTM.createInstance({
                    url: '${params.webSocketUrl!}',
                    roomId: this.mId,
                    deviceId: this.userId
                });

                if (this.userId == this.hostId) {
                    return;
                }

                var that = this;
                this.rtmClient.on("muteVoice", function (data) {
                    that.muteAudio();
                });

                this.rtmClient.on("unmuteVoice", function (data) {
                    that.unmuteAudio();
                });
            },
            loadUsers: function () {
                if (!this.mId) {
                    $.message("参数错误，无法初始化数据");
                    return;
                }
                var that = this;
                $.http.post("${params.contextPath}/web/meeting/queryUsers.json", {
                    meetingId: this.mId,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.userList = data.data;
                    that.initVideo();
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
                this.videoClient.join({roomId: this.roomId, role: 'anchor'}).then(function () {
                    console.log('进房成功');
                    that.subscribeVideoEvents();
                    that.videoStream = TRTC.createStream({userId: that.userId, audio: true, video: true});
                    that.videoStream.setVideoProfile('480p');
                    that.videoStream.initialize().then(function () {
                        that.getDevices();
                        that.publishVideo();
                        console.log('初始化本地流成功');
                    }).catch(function (error) {
                        that.videoClient && that.videoClient.leave();
                        that.videoClient = null;
                        that.videoStream = null;
                        console.error('初始化本地流失败 ' + error);
                    });
                }).catch(function (error) {
                    that.videoClient = null;
                    $.message('进房失败：' + JSON.stringify(error));
                    console.error('进房失败 ' + error);
                });
            },
            publishVideo: function () {
                var that = this;
                this.videoClient.publish(this.videoStream).then(function () {
                    $.message('本地音视频流发布成功');
                    that.videoStream.play("my-video", {objectFit1: "contain"});
                }).catch(function (error) {
                    that.videoStream = null;
                    $.message('本地流发布失败：' + JSON.stringify(error));
                    console.error('本地流发布失败：' + error);
                });
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
                //远端用户退房通知
                /*this.videoClient.on('stream-removed', function (event) {
                    var userId = event.userId;
                });*/
            },
            screenLeave:function(){
                this.showShareScreen = false;
                this.screenClient && this.screenClient.leave();
                this.screenClient = null;
                this.screenStream = null;
            },
            initScreen: function () {
                var that = this;
                if (!this.webrtcId) {
                    $.message("音视频Key未配置，无法初始化音视频");
                    return;
                }
                alert("请不要共享当前窗口，防止出现画中画现象");
                this.showShareScreen = true;
                this.screenClient = TRTC.createClient({
                    mode: 'live',
                    sdkAppId: this.webrtcId,
                    userId: this.screenId,
                    userSig: this.screenSig
                });
                this.screenClient.join({roomId: this.roomId, role: 'anchor'}).catch(function (error) {
                    that.screenClient = null;
                    $.message('进房失败：' + JSON.stringify(error));
                    console.error('进房失败 ' + error);
                }).then(function () {
                    console.log('进房成功');
                    that.screenStream = TRTC.createStream({userId: that.userId, audio: false, screen: true});
                    that.screenStream.on('screen-sharing-stopped', function (event) {
                        that.closeScreen();
                        console.log('screen sharing was stopped');
                    });
                    that.screenStream.setScreenProfile('720p_2');
                    that.screenStream.initialize().then(function () {
                        that.screenClient.publish(that.screenStream).then(function () {
                            $.message('本地共享桌面流发布成功');
                            that.screenStream.play("my-screen", {objectFit1: "contain"});
                        }).catch(function (error) {
                            that.closeScreen();
                            $.message('本地共享桌面流发布失败：' + JSON.stringify(error));
                            console.error('本地共享桌面流发布失败：' + error);
                        });
                        console.log('初始化本地流成功');
                    }).catch(function (error) {
                        console.error('初始化本地流失败 ' + error);
                        that.closeScreen();
                    });
                });
            },
            closeScreen:function(){
                this.screenStream && this.screenStream.close();
                this.screenClient && this.screenClient.leave();
                this.screenClient = null;
                this.screenStream = null;
                this.showShareScreen = false;
            },
            muteAudio:function () {//静音
                if (!this.videoStream) {
                    $.message("音频不存在");
                    return false;
                }
                this.isOpenMicrophone = false;
                this.videoStream.muteAudio();
                $.message("已被静音");
                return true;
            },
            unmuteAudio:function () {//启用音频
                if (!this.videoStream) {
                    $.message("音频不存在");
                    return false;
                }
                this.isOpenMicrophone = true;
                this.videoStream.unmuteAudio();
                $.message("已被启用音频");
            },
            bindMuteVideo:function () {//是否关闭掉视频
                if (!this.isOpenCarema) {
                    this.isOpenCarema = true;
                    this.videoStream.unmuteVideo();
                    return;
                }
                this.isOpenCarema = false;
                this.videoStream.muteVideo();
            },
            leaveRoom: function () {//离开频道
                var that = this;
                this.videoStream && this.videoStream.close();
                this.screenStream && this.screenStream.close();
                this.videoClient && this.videoClient.leave().then(function () {
                    that.videoClient = null;
                    console.log("退出成功");
                }).catch(function (error) {
                    console.error('leaving room failed: ' + error);
                });

                this.screenClient && this.screenClient.leave().then(function () {
                    that.screenClient = null;
                    console.log("退出成功");
                }).catch(function (error) {
                    console.error('leaving room failed: ' + error);
                });
            },
            addRemoteVideo: function (stream) {//添加远程连麦视频流
                if (!stream) {
                    console.log("该远程视频流不存在，无法添加");
                }
                var streamId = stream.getUserId();
                if (streamId == this.screenId || streamId == this.userId) {
                    return;
                }
                if (streamId.indexOf("_screen") >= 0) {
                    stream.isScreen = true;
                    stream.name = (this.getUserField(streamId.replace("_screen", ""), "userName") || "") + "屏幕";
                } else {
                    stream.name = this.getUserField(streamId, "userName") || "";
                }
                if (!this.mainStream) {
                    this.mainStream = stream;
                    stream.play("main-box", {objectFit1: "contain"});
                    return;
                }
                this.$set(this.remoteStreams, streamId, stream);
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
            closeRemoteVideo: function (streamId) {
                if (!streamId) {
                    console.log("该远程视频流不存在，无法关闭");
                    return;
                }
                if (this.mainStream && this.mainStream.getUserId() == streamId) {
                    this.mainStream.stop();
                    this.mainStream = null;
                }
                var stream = this.remoteStreams[streamId];
                stream && stream.stop();
                this.$set(this.remoteStreams, streamId, null);
                if (!this.mainStream) {
                    this.$nextTick(function () {
                        for (var key in this.remoteStreams) {
                            var stream = this.remoteStreams[key];
                            if (!stream) {
                                continue;
                            }
                            this.mainStream = stream;
                            stream.stop();
                            stream.play("main-box", {objectFit1: "contain"});
                        }
                    });
                }
            },
            playToMain: function (streamId) {
                var stream = this.remoteStreams[streamId];
                if (!stream) {
                    return;
                }
                stream && stream.stop();
                if (this.mainStream) {
                    this.mainStream.stop();
                    this.$set(this.remoteStreams, this.mainStream.getUserId(), this.mainStream);
                    this.$set(this.remoteStreams, streamId, null);
                    this.mainStream = stream;
                    stream.play("main-box", {objectFit1: "contain"});
                    this.$nextTick(function () {
                        for (var key in this.remoteStreams) {
                            var stream = this.remoteStreams[key];
                            if (!stream || stream.isPlaying_) {
                                continue;
                            }
                            console.log("aa = " + stream.isPlaying_);
                            stream.play("video-player-" + key, {objectFit1: "contain"});
                        }
                    });
                    return;
                }
                this.$set(this.remoteStreams, streamId, null);
                this.mainStream = stream;
                stream.play("main-box", {objectFit1: "contain"});
            },
            bindShowShareScreen:function(){
                if (this.screenStream) {
                    $.message("屏幕真正共享中");
                    return;
                }
                this.showShareScreen = true;
                this.$nextTick(function () {
                    this.initScreen();
                });
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
                });
            },
            bindCloseSetting: function () {
                this.videoStream && this.videoStream.stop();
                this.videoStream && this.videoStream.play("my-video", {objectFit1: "contain"});
                this.showVideoSetting = false;
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
            changeAudioinput:function(e){
                var deviceId = e.target.value;
                if (this.videoStream) {
                    this.videoStream.switchDevice('audio', deviceId).then(function () {
                        $.message("切换麦克风成功！");
                    }).catch(function (err) {
                        $.message("切换麦克风失败：" + JSON.stringify(err));
                    });
                }
            },
            signOut:function () {
                this.leaveRoom();
                window.close();
                alert("退出成功，请关闭浏览器");
            },
            allMuteMicrophone: function () {
                this.isAllOpenMicrophone = false;
                var data = {roomId: this.mId, type: 'muteVoice', msg: 'ok'};
                this.rtmClient.send(data);
                $.message("静音指令已发送");
            },
            allUnMuteMicrophone: function () {
                this.isAllOpenMicrophone = true;
                var data = {roomId: this.mId, type: 'unmuteVoice', msg: 'ok'};
                this.rtmClient.send(data);
                $.message("启用音频指令已发送");
            }
        }
    });
</script>
</body>

</html>
