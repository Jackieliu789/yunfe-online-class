<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${params.websitName!}</title>
    <#include "/common/vue_resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/js/trtc.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/reconnecting-websocket.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/yunfei-socket.js?_t=${params.pageRandom!}"></script>
    <style>
        body, html, #app {margin: 0;height: 100%;background:#01AAED;}
        [v-cloak]{display:none !important;}
        .header{height:30px;line-height:30px;color:#fff;font-size:14px;position:fixed;padding:20px 0;top:0;right:0;left:0;text-align:center;z-index:10;background-position:center;background-size:contain;background-repeat:no-repeat;}
        .header .title{background:rgba(0,0,0,0.5);text-align:center;margin:0 auto;display:inline-block;padding:0 30px;border-radius:15px;}
        .tools-box{position:fixed;bottom:20px;right:0;left:0;z-index:10}
        .tools-container{margin:0 auto;text-align:center;background:rgba(0,0,0,0.5);width:200px;border-radius:5px;}
        .tools-container .item{display:inline-block;color:#fff;padding:10px 15px;font-size:12px;color:#ddd;cursor:pointer;}
        .tools-container .item img{width:20px;margin-bottom:5px;}
        .tools-container .item > div{font-size:12px;}
        .tip-box{position:absolute;top:0;left:0;right:0;}
        .tip{font-size:26px;text-align:center;margin-top:80px;}
        .video-list{display:flex;flex-flow:row wrap;align-content:flex-start;width:70%;margin:0 auto;padding-top:80px;}
        .video-item{box-sizing:border-box;flex:0 0 33.33%;height:25vh;}
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
    <div class="header" :style="{backgroundImage:'url(' + coverPath + ')'}">
        <div class="title" v-if="!coverPath">${params.n!'-'}</div>
    </div>
    <div class="video-box" id="video-box">
        <div class="video-list">
            <div class="video-item" v-if="item" v-for="(item, key) in remoteStreams" :key="key" :id="'video-player-' + item.getUserId()"></div>
        </div>
    </div>
    <div class="tip-box" v-if="Object.keys(remoteStreams).length == 0"><div class="tip">等待老师上课...</div></div>
    <#--<div class="screen-box" id="screen-box" v-if="screenStream"></div>-->
    <div class="tools-box">
        <div class="tools-container">
            <div class="item" @click="bindOpenAsk">
                <div><img src="${params.contextPath!}/images/chat.png" alt=""></div>
                <div>讨论</div>
            </div>
            <div class="item" @click="signOut">
                <div><img src="${params.contextPath!}/images/signout.png" alt=""></div>
                <div>退出</div>
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
                <div class="header-photo" v-if="!item.active">
                    <img class="img" :src='item.p'/>
                </div>
                <div class="box" v-if="!item.active">
                    <div class="name">{{item.name}}</div>
                    <div class="msg">{{item.msg}}</div>
                </div>
                <div class="box" v-if="item.active">
                    <div class="name text-right">{{item.name}}</div>
                    <div class="msg">{{item.msg}}</div>
                </div>
                <div class="header-photo" v-if="item.active">
                    <img class="img" :src='item.p'/>
                </div>
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
            videoClient: null,
            remoteStreams: {},//远程订阅流，包含自己
            coverPath:'${params.fileRequestUrl!}${params.cp!}',
            cId: "${params.cid!}",
            userId: '${(user.id)!}',
            webrtcId: ${params.videoKey!0},
            roomId: ${params.rid!''},
            videoSig: '${params.s!}',

            showAsk:false,
            askMsgs:[],
            askMsg:'',
        },
        mounted: function () {
            this.initWebSocket();
            this.initVideo();
        },
        methods: {
            initWebSocket: function () {
                var that = this;
                this.rtmClient = YunfeiRTM.createInstance({
                    url: '${params.webSocketUrl!}',
                    roomId: this.cId,
                    deviceId: this.userId
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
            initVideo: function () {//初始化视频
                if (!this.webrtcId) {
                    alert("音视频Key未配置，无法初始化音视频");
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
                }).catch(function (error) {
                    that.videoClient = null;
                    console.error('进房失败 ' + error);
                    alert('进房失败');
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
            },
            addRemoteVideo: function (stream) {//添加远程连麦视频流
                if (!stream) {
                    console.log("该远程视频流不存在，无法添加");
                }
                var streamId = stream.getUserId();
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
                var stream = this.remoteStreams[streamId];
                stream && stream.stop();
                this.$set(this.remoteStreams, streamId, null);
            },
            leaveRoom: function () {
                var that = this;
                this.videoClient && this.videoClient.leave().then(function () {
                    that.videoClient = null;
                    console.log("退出成功");
                }).catch(function (error) {
                    console.error('leaving room failed: ' + error);
                });
            },
            signOut:function () {
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
                    alert("退出成功，请关闭浏览器");
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
            sendAsk:function () {
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
</script>
</body>

</html>
