<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${params.websitName!}</title>
    <#include "/common/vue_resource.ftl">
    <script type="text/javascript" src="${params.contextPath}/js/reconnecting-websocket.js"></script>
    <script type="text/javascript" src="${params.contextPath}/js/yunfei-socket.js?_t=${params.pageRandom!}"></script>
    <script src="https://resources-tiw.qcloudtrtc.com/board/third/cos/5.1.0/cos.min.js"></script>
    <script src="https://resources-tiw.qcloudtrtc.com/board/2.4.6/TEduBoard.min.js"></script>
    <script type="text/javascript" src="https://res.wx.qq.com/open/js/jweixin-1.3.2.js"></script>
    <style>
        body, html, #app {margin: 0;height: 100%;}
        [v-cloak]{display:none !important;}
        ::-webkit-scrollbar-track-piece{width:6px;background-color1:#4e4e5a;}
        ::-webkit-scrollbar{width:6px;height:6px ; }
        ::-webkit-scrollbar-thumb{height:50px;background:#aaa;cursor:pointer;}
        ::-webkit-scrollbar-thumb:hover{background:#4e4e5a; cursor:pointer;}
        .container{display:flex;flex-direction:column;height:100%;}
        #whiteboard-box{flex-grow:1;flex-basis:0;overflow:auto;}
        .container .btn{padding:5px 10px;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="container">
        <div id="whiteboard-box">aaa</div>
        <div class="btn">
            <button type="button" class="layui-btn layui-btn-fluid" @click="close">关闭</button>
        </div>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            cId: '${params.cid!}',
            roomId: ${params.rid!"''"},
            rtmClient: null,
            teduBoard: null,
            boardAppId:${params._bk!0},
            boardSig: '${params._bs!}',
            userId:'${params.uid!}'
        },
        mounted: function () {
            this.initWebSocket();
            this.initBoard();

            var height = $("#whiteboard-box").height();
            var width = $("#whiteboard-box").width();
            $("#whiteboard-box").height(height);
            $("#whiteboard-box").width(width);
        },
        methods: {
            initWebSocket: function () {
                if (!this.cId || !this.userId) {
                    $.message("参数不全，无法初始化链接");
                    return;
                }
                var that = this;
                this.rtmClient = YunfeiRTM.createInstance({
                    url: '${params.webSocketUrl!}',
                    roomId: this.cId,
                    deviceId: this.userId + "_board"
                });

                this.rtmClient.on("teduboard", function (data) {
                    that.teduBoard.addSyncData(data.msg);
                });
            },
            initBoard: function () {
                if (!this.boardSig || this.boardAppId <= 0) {
                    $.message("参数不全，无法初始化白板");
                    return;
                }
                var params = {
                    id: 'whiteboard-box',
                    classId: this.roomId,
                    sdkAppId: this.boardAppId,
                    userId: this.userId,
                    drawEnable: false,
                    userSig: this.boardSig,
                };
                this.teduBoard = new TEduBoard(params);
            },
            close: function () {
                var data = {roomId: this.cId, deviceIds: this.userId, type: 'board_close', msg: 'ok'};
                this.rtmClient.send(data);
            }
        }
    });
</script>
</body>

</html>
