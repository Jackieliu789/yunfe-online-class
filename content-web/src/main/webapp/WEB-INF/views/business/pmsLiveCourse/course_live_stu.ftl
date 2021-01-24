<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${params.websitName!}</title>
    <link rel="stylesheet" type="text/css" href="https://www.layuicdn.com/layui-v2.5.6/css/layui.css"/>

    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script type="text/javascript" src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/trtc.js"></script>
    <style>
        body, html, #app {margin: 0;height: 100%;}
        [v-cloak]{display:none !important;}
        .header{height:30px;line-height:30px;color:#fff;font-size:14px;position:fixed;top:10px;right:0;left:0;text-align:center;z-index:10}
        .header .title{background:rgba(255,255,255,0.2);text-align:center;margin:0 auto;display:inline-block;padding:0 30px;border-radius:15px;}
        .video-box, .screen-box{height:100%;}
        .small-box{position:fixed;top:20px;right:20px;width:200px;height:150px;z-index:10}
        .tools-box{position:fixed;bottom:20px;right:0;left:0;z-index:10}
        .tools-container{margin:0 auto;text-align:center;background:rgba(255,255,255,0.2);width:100px;border-radius:5px;}
        .tools-container .item{display:inline-block;color:#fff;padding:10px 15px;font-size:12px;color:#ddd;cursor:pointer;}
        .tools-container .item img{width:20px;margin-bottom:5px;}
        .tools-container .item > div{font-size:12px;}
        .white-show{background: rgba(0,0,0,0.5) !important;}
        .tip-box{position:absolute;top:0;left:0;right:0;}
        .tip{font-size:26px;text-align:center;margin-top:80px;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="header">
        <div :class="techStream ? 'title' : 'title white-show'">${params.n!'-'}</div>
    </div>
    <div :class="screenStream ? 'video-box small-box' : 'video-box'" id="video-box"></div>
    <div class="tip-box" v-if="!techStream"><div class="tip">等待老师上课...</div></div>
    <div class="screen-box" id="screen-box" v-if="screenStream"></div>
    <div class="tools-box">
        <div :class="techStream ? 'tools-container' : 'tools-container white-show'">
            <div class="item" @click="signOut">
                <div><img src="${params.contextPath!}/images/signout.png" alt=""></div>
                <div>退出</div>
            </div>
        </div>
    </div>

</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            videoClient: null,
            techStream: null,
            screenStream: null,

            cId: "${params.cid!}",
            userId: '${(user.id)!}',
            webrtcId: ${params.videoKey!0},
            roomId: ${params.rid!''},
            videoSig: '${params.s!}',
        },
        mounted: function () {
            this.initVideo();
        },
        methods: {
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
                    if (stream.getUserId().indexOf("_screen") >= 0) {
                        that.screenStream = stream;
                        that.$nextTick(function () {
                            this.screenStream.play("screen-box", {objectFit1: "contain"});
                        });
                        return;
                    }
                    that.techStream = stream;
                    that.techStream.play("video-box", {objectFit1: "contain"});
                });
                //远端流移除
                this.videoClient.on('stream-removed', function (event) {
                    var stream = event.stream;
                    if (stream.getUserId().indexOf("_screen") >= 0) {
                        that.screenStream = null;
                        document.getElementById("screen-box").innerHTML = "";
                        return;
                    }
                    document.getElementById("video-box").innerHTML = "";
                    that.techStream = null;
                });
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
        }
    });
</script>
</body>

</html>
