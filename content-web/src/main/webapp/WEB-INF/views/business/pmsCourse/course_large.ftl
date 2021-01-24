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
        .whiteboard-tools .box{background:rgba(0,0,0,0.6);color:#fff;margin-top:20px;border-radius:0 10px 10px 0;}
        .whiteboard-tools .box .item{font-size:22px;text-align:center;padding:5px;cursor:pointer;position:relative;}
        .whiteboard-tools .box .item:first-child{border-radius:0 10px 0 0;}
        .whiteboard-tools .box .item:last-child{border-radius:0 0 10px 0;}
        .whiteboard-tools .box img{width:20px;}
        .right .video{height:240px;background:#999;position:relative;}
        .max-screen, .mute-voice, .mute-video{z-index:10;position:absolute;cursor:pointer;background:#fff;width:30px;height:30px;text-align:center;line-height:30px;border-radius:30px;}
        .max-screen{right:10px;top:10px;}
        .mute-voice{bottom:10px;left:10px;color:#1E9FFF;}
        .mute-video{bottom:10px;left:50px;color:#1E9FFF;}
        .video-player{height:100%;}
        .video-user{position:absolute;bottom1:0;font-size1:200px;color:#fff;left1:85px;width:90%;text-align:center;top:20px;}
        .right .box{display:flex;flex-direction:column;flex-grow:1;flex-basis:0;}
        .im-msg-box, .user-box, .record-box{flex-grow:1;flex-basis:0;padding:10px;overflow:auto;}
        .im-send-box{border-top:1px solid #fff;padding:10px;}
        .im-send-box input[type="text"]{height:30px;border:0;border-radius: 15px;padding:0 10px;margin:0 5px;vertical-align:top;flex-grow:1;flex-basis:0;width:100%;background: #f2f2f2;}
        .im-send-box input[type="button"]{height:30px;line-height:30px;vertical-align:top;border-radius: 15px;}
        .video-container{position:absolute;left:0;top:0;z-index:10;}
        .video-item{position:relative;width:200px;height:120px;display:inline-block;margin-right:10px;margin-bottom:10px;background:#000;}
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
        .user-item, .record-item{display:flex;flex-direction:row;line-height:35px;}
        .user-item > div, .record-item > div{flex-grow:1}
        .user-item > div:last-child, .record-item > div:last-child{text-align:right;cursor:pointer;}
        .radius-user-text{background:rgba(0,0,0,0.2);color:#2F4056;padding:5px 10px;border-radius:20px;font-size:12px;margin-right:5px;}
        .unactive{color:#c2c2c2;}
        .active{color:#fff;background:#FF5722;}
        .main .box{height:100%;position:relative;}
        .color-box{position:absolute;top:-180px;left:54px;border:none;display:block;border-bottom:1px solid #f2f2f2;z-index:100;}
        .color-box .color{line-height:30px;color:#fff;border-bottom:1px solid #f2f2f2;background:#01AAED;padding:0 5px;min-height:30px;min-width:20px;}
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
                <span class="radius-text">用户：{{userName || "--"}}</span>
            </div>
            <div class="layui-col-md2 layui-col-xs2 text-center" style="font-weight:bold;color:#2F4056;">${params.n!'-'}</div>
            <div class="layui-col-md5 layui-col-xs3 text-right" style="padding-right:20px;">
                <span class="recording" v-if="!videoStream">
                    分辨率：
                    <select style="border:none;background:rgba(0,0,0,0);color:#FFB800;" v-model="videoProfile">
                        <option value="360p">360p (640 x 360)</option>
                        <option value="480p">480p (640 x 480)</option>
                        <option value="720p">720p (1280 x 720)</option>
                        <option value="1080p">1080p (1920 x 1080)</option>
                        <option value="1440p">1440p (2560 x 1440)</option>
                    </select>
                </span>
                <#--<span class="recording" v-if="isRecording"><i class="fa fa-circle"></i>正在录制</span>-->
                <span class="recording" style="background:#FF5722;cursor:pointer;" @click="bindAttendClass" v-if="!videoStream">上课</span>
                <span class="recording" style="background:#1E9FFF;cursor:pointer;" @click="bindOverClass" v-if="videoStream">下课</span>
                <span class="class-out" @click="bindLeaveOut"><i class="fa fa-sign-out"></i></span>
            </div>
        </div>
    </div>
    <div class="body">
        <#--共享白板功能列表-->
        <div class="whiteboard-tools">
            <div class="box" v-if="showWhiteboard && boardAppId > 0 && boardSig">
                <div :class="currentTool == 'mouse' ? 'item active' : 'item'" @click="whiteboardSelect('mouse')" title="鼠标">
                    <img src="${params.contextPath!}/images/pointer.png" alt="">
                </div>
                <div :class="currentTool == 'pencil' ? 'item active' : 'item'" @click="whiteboardSelect('pencil')" title="画笔">
                    <img src="${params.contextPath!}/images/pencil.png" alt="">
                </div>
                <div :class="currentTool == 'line' ? 'item active' : 'item'" @click="whiteboardSelect('line')" title="直线">
                    <img src="${params.contextPath!}/images/line.png" alt="">
                </div>
                <div :class="currentTool == 'ellipse' ? 'item active' : 'item'" @click="whiteboardSelect('ellipse')" title="椭圆">
                    <img src="${params.contextPath!}/images/ellipse.png" alt="">
                </div>
                <div :class="currentTool == 'rectangle' ? 'item active' : 'item'" @click="whiteboardSelect('rectangle')" title="空心矩形">
                    <img src="${params.contextPath!}/images/rectangle.png" alt="">
                </div>
                <div :class="currentTool == 'rectangle2' ? 'item active' : 'item'" @click="whiteboardSelect('rectangle2')" title="实心矩形">
                    <img src="${params.contextPath!}/images/rectangle2.png" alt="">
                </div>
                <div :class="currentTool == 'text' ? 'item active' : 'item'" @click="whiteboardSelect('text')" title="文字">
                    <img src="${params.contextPath!}/images/text.png" alt="">
                </div>
                <div :class="currentTool == 'eraser' ? 'item active' : 'item'" @click="whiteboardSelect('eraser')" title="橡皮">
                    <img src="${params.contextPath!}/images/eraser.png" alt="">
                </div>
                <div :class="currentTool == 'select' ? 'item active' : 'item'" @click="whiteboardSelect('select')" title="点选">
                    <img src="${params.contextPath!}/images/select.png" alt="">
                </div>
                <div :class="currentTool == 'selects' ? 'item active' : 'item'" @click="whiteboardSelect('selects')" title="框选">
                    <img src="${params.contextPath!}/images/selects.png" alt="">
                </div>
                <div :class="currentTool == 'move' ? 'item active' : 'item'" @click="whiteboardSelect('move')" title="移动">
                    <img src="${params.contextPath!}/images/move.png" alt="">
                </div>
                <div class="item" @click="whiteboardSelect('file')" title="ppt,word,pdf文件">
                    <img src="${params.contextPath!}/images/ppt.png" alt="">
                </div>
                <div class="item" @click="whiteboardSelect('img')" title="图片文件">
                    <img src="${params.contextPath!}/images/img.png" alt="">
                </div>
                <div class="item" @click="whiteboardSelect('color')" title="颜色">
                    <img src="${params.contextPath!}/images/color.png" alt="">
                    <div class="color-box" v-if="showColor" style="top:-90px;">
                        <div class="color" @click.stop="bindSelectColor('#009688')" data="#009688" style="background:#009688"></div>
                        <div class="color" @click.stop="bindSelectColor('#2F4056')" data="#2F4056" style="background:#2F4056"></div>
                        <div class="color" @click.stop="bindSelectColor('#FF5722')" data="#FF5722" style="background:#FF5722"></div>
                        <div class="color" @click.stop="bindSelectColor('#1E9FFF')" data="#1E9FFF" style="background:#1E9FFF"></div>
                    </div>
                </div>
                <div class="item" @click="whiteboardSelect('size')" title="画笔尺寸">
                    <img src="${params.contextPath!}/images/size.png" alt="">
                    <div class="color-box" v-if="showSize">
                        <div class="color" @click.stop="bindSelectSize(4)">4</div>
                        <div class="color" @click.stop="bindSelectSize(5)">5</div>
                        <div class="color" @click.stop="bindSelectSize(6)">6</div>
                        <div class="color" @click.stop="bindSelectSize(7)">7</div>
                        <div class="color" @click.stop="bindSelectSize(8)">8</div>
                        <div class="color" @click.stop="bindSelectSize(9)">9</div>
                        <div class="color" @click.stop="bindSelectSize(10)">10</div>
                    </div>
                </div>
                <div class="item" @click="whiteboardSelect('trash')" title="清屏">
                    <img src="${params.contextPath!}/images/clear.png" alt="">
                </div>
            </div>
        </div>
        <div class="main">
            <#--连麦列表-->
            <div class="video-container">
                <div class="video-item" v-if="item" v-for="(item, key) in remoteStreams" :key="key">
                    <div class="hand-up" @click="bindCancelRemoteVideo(key)"><i class="fa fa-tty"></i></div>
                    <div class="name" v-if="item.name">{{item.name}}</div>
                    <div class="video-player" :id="'video-player-' + item.getUserId()"></div>
                </div>
            </div>
            <#--显示共享白板-->
            <div class="box whiteboard-box" v-show="showWhiteboard && boardAppId > 0 && boardSig">
                <div class="whiteboard" id="whiteboard-box" @wheel.prevent="boardScale"></div>
                <div class="whiteboard-image-tools" v-if="transcodeFileTotal > 0">
                    <div class="action prev" @click="prevPpt"><i class="fa fa-backward"></i></div>
                    <div class="num"><span>{{transcodeFileCurrentNum}}</span>/<span>{{transcodeFileTotal}}</span></div>
                    <div class="action after" @click="nextPpt"><i class="fa fa-forward"></i></div>
                </div>
            </div>
            <#--大屏显示主播信息-->
            <div class="box max-host-box" v-if="showMaxHost">
                <div class="max-screen" @click="bindCloseMaxHost"><i class="fa fa-arrows"></i></div>
                <div id="max-host-video" style="height:100%"></div>
            </div>
            <#--共享屏幕-->
            <div class="box share-screen-box" id="share-screen-box" v-if="showShareScreen">
                <#--<div style="text-align:center;font-size:40px;padding-top:20px;">正在共享屏幕</div>
                <div id="share-screen-box" style="height:200px;width:200px;margin:0 auto;margin-top:20px;"></div>-->
            </div>
        </div>
        <#--功能列表-->
        <div class="tools">
            <div class="box">
                <#--<div class="item" title="打开/关闭共享白板" @click="bindShowWhiteboard"><i :class="showWhiteboard ? 'fa fa-bandcamp' : 'fa fa-bandcamp unactive'"></i></div>-->
                <div class="item" title="课件" @click="bindOpenAttaments"><i class="fa fa-folder-open"></i></div>
                <div class="item" title="关闭/共享屏幕" @click="bindShowShareScreen"><i :class="showShareScreen ? 'fa fa-tv' : 'fa fa-tv unactive'"></i></div>
                <div class="item" title="开启/关闭连麦" @click="bindToggleLinkCamera"><i :class="isLinkCamera ? 'fa fa-video-camera' : 'fa fa-video-camera unactive'"></i></div>
                <div class="item" title="是否全部静音" @click="bindAllMuteVoice2"><i :class="isAllMuteVoice ? 'fa fa-microphone unactive' : 'fa fa-microphone'"></i></div>
                <div class="item" title="是否全体禁言" @click="bindToggleStopWord"><i :class="isStopWord ? 'fa fa-commenting unactive' : 'fa fa-commenting'"></i></div>
                <div class="item" title="音视频设置" @click="bindToggleSetting"><i :class="showVideoSetting ? 'fa fa-cog' : 'fa fa-cog unactive'"></i></div>
                <div class="item" title="视频监控" @click="bindToggleMonitor"><i :class="showMonitor ? 'fa fa-eye' : 'fa fa-eye unactive'"></i></div>
                <div class="item" title="视频监控上一页" v-if="showMonitor" @click="bindPrevMonitor"><i class="fa fa-chevron-up"></i></div>
                <div class="item" title="视频监控下一页" v-if="showMonitor" @click="bindNextMonitor"><i class="fa fa-chevron-down"></i></div>
            </div>
        </div>
        <div class="right">
            <#--主播视频显示区域-->
            <div class="video">
                <div class="max-screen" v-if="!showMaxHost && videoStream" @click="bindShowMaxHost"><i class="fa fa-arrows-alt"></i></div>
                <div class="video-player" id="video-player"></div>
                <div class="mute-voice" @click="bindMuteVoice"><i :class="isMuteVoice ? 'fa fa-microphone unactive' : 'fa fa-microphone'"></i></div>
                <div class="mute-video" @click="bindMuteVideo"><i :class="isMuteVideo ? 'fa fa-video-camera unactive' : 'fa fa-video-camera'"></i></div>
                <div class="video-user" v-if="showMaxHost || !videoStream"><#--<i class="fa fa-user"></i>-->等待老师上课</div>
            </div>
            <#--即时聊天和用户列表-->
            <div class="box">
                <div class="layui-tab layui-tab-brief" style="margin:0px;">
                    <ul class="layui-tab-title" style="background:#fff;">
                        <li :class="showImBox ? 'layui-this' : ''" @click="bindShowImBox">讨论区</li>
                        <li :class="showUserBox ? 'layui-this' : ''" @click="bindShowUserBox">用户({{userList.length}})</li>
                    </ul>
                </div>
                <#--即时聊天信息-->
                <div class="im-msg-box" v-if="showImBox" id="im-msg-box">
                    <div :class="item.active ? 'msg-item this' : 'msg-item'" v-for='(item, index) in imMsgs'>
                        <div class="name">{{item.name}}</div>
                        <div class="msg" v-if="item.msg">{{item.msg}}</div>
                        <div class="msg" v-if="item.img"><img :src="item.img"/></div>
                    </div>
                </div>
                <#--用户列表-->
                <div class="user-box" v-if="showUserBox">
                    <div class="user-item" v-for='(item, index) in userList'>
                        <div>
                            <span :class="item.isHand ? 'radius-user-text active' : 'radius-user-text'"><i class="fa fa-hand-stop-o"></i></span>
                            <span :class="item.isOnline ? 'radius-user-text active' : 'radius-user-text'"><i class="fa fa-user"></i></span>
                            <span>{{item.userName}}</span>
                        </div>
                        <div>
                            <span @click="bindLinkCamera(item.userId)" :class="item.isCamera ? 'radius-user-text active' : 'radius-user-text'"><i class="fa fa-video-camera"></i></span>
                        </div>
                    </div>
                </div>
                <div class="im-send-box" v-if="showImBox">
                    <#--<span class="im-image" title="上传图片" @click="uploadImImage"><i class="fa fa-image"></i></span>-->
                    <input type="text" v-on:keyup.13="bindSendImMsg" v-model="imMsg" placeholder="说点什么">
                    <input type="button" @click="bindSendImMsg" class="layui-btn layui-btn-normal" value="发送">
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
                <button type="button" class="layui-btn layui-btn-normal" @click="uploadAttachment"><i class="fa fa-cloud-upload"></i> 上传</button>
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
                        <td><a href="javascript:void(0)" @click="removeAttachment(item.id)">删除</a></td>
                    </tr>
                    <tr v-if='attachmentList.length == 0'>
                        <td colspan="2" style="text-align:center;">暂无课件</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <#--上传课件-->
    <div style="display:none">
        <form class="attachment-upload-form" action="${params.contextPath}/web/pmsCourseItem/uploadAttachment.json?courseItemId=${params.cid!}" enctype="multipart/form-data" method="post">
            <input type="file" name="files" multiple/>
        </form>
    </div>
    <#--聊天图片-->
    <div style="display:none">
        <form class="image-form" action="${params.contextPath}/web/attachment/upload.json" enctype="multipart/form-data" method="post">
            <input type="file" id="board-image" name="files" accept="image/*" @change="addBoardImage"/>
        </form>
    </div>
    <#--白板文件上传-->
    <div style="display:none">
        <form class="ppt-form" action="${params.contextPath}/web/attachment/upload.json" enctype="multipart/form-data" method="post">
            <input type="file" id="ppt-file" name="files" @change="addBoardPPT" accept="application/msword,application/pdf,application/vnd.ms-powerpoint,application/vnd.openxmlformats-officedocument.wordprocessingml.document,application/vnd.openxmlformats-officedocument.presentationml.presentation"/>
        </form>
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
            showUserBox: false,//是否显示用户列表
            showImBox: true,//是否显示聊天列表
            showVideoFileBox: false,//是否显示回放记录
            showWhiteboard: true,//是否显示白板
            showShareScreen: false,//是否显示共享屏幕
            showMaxHost: false,//是否显示主播大屏

            showVideoSetting: false,//是否显示音视频设置信息
            showMonitor: false,//是否音视频监控
            monitorPage: 0,//音视频监控翻页
            monitorPageNum: 20,//音视频监控每页视屏数量
            monitorNums: 0,
            monitorLimit: 0,

            isMuteVoice: false,//是否关闭掉声音
            isMuteVideo: false,//是否关闭掉摄像头

            isLinkCamera: true,//是否可以连麦
            isStopWord: false,//是否全体禁言
            isAllMuteVoice: false,//是否全体静音

            imMsg: '',//input中聊天信息

            userName: "${(user.name)!}",
            userList: [],//用户列表
            imMsgs: [],//聊天信息

            userId: '${(user.id)!}',

            videoClient: null,//视频端
            videoStream: null,//视频流

            screenClient: null,//桌面端
            screenStream: null,//屏幕流

            remoteStreams: {},//远程订阅流，包含自己

            webrtcId: ${params.videoKey!0},
            cId: '${params.cid!}',
            roomId: ${params.rid!''},
            videoSig: '${params.s!}',
            screenSig: '${params.sc!}',
            screenId: '${(user.id)!}_screen',

            isVideoRecord: false,

            isRecording: false,//是否正在录制
            videoRecordList: [],

            attachmentList: [],
            showAttachment: false,

            RTT: '--',//网络延时

            videoinputs: [],//摄像头
            audioinputs: [],//麦克风
            audiooutputs: [],//扬声器

            rtmClient: null,

            teduBoard: null,
            boardAppId:${params._bk!0},
            boardSig:'${params._bs!}',
            currentTool: 'pencil',
            showColor: false,
            showSize: false,
            transcodeFileTotal: 0,
            transcodeFileCurrentNum: 0,

            videoProfile:'480p',
        },
        mounted: function () {
            this.loadUsers();
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

                this.rtmClient.on("online", function (data) {
                    var deviceId = data.msg;
                    var user = that.setActiveUserField(deviceId, "isOnline");
                    if (user) {
                        var userName = user.userName || '--';
                        $.message("[" + userName + "]上线了");
                    }
                });

                this.rtmClient.on("offline", function (data) {
                    var deviceId = data.msg;
                    var user = that.setUnActiveUserField(deviceId, "isOnline");
                    if (user) {
                        var userName = user.userName || '--';
                        $.message("[" + userName + "]下线了");
                    }
                });

                this.rtmClient.on("im", function (data) {
                    var result = data.msg;
                    that.checkOrAddUser(data);
                    that.imMsgs.push({name: result.u, msg: result.msg, img: result.img, active: (result.uid == that.userId)});
                    that.$nextTick(function () {
                        var imContainer = document.getElementById('im-msg-box') // 获取对象
                        imContainer.scrollTop = imContainer.scrollHeight // 滚动高度
                    });
                });

                this.rtmClient.on("hand_apply", function (data) {
                    var result = data.msg;
                    that.checkOrAddUser(data);
                    that.setActiveUserField(result.uid, "isHand");
                    $.message(result.u + " 请求连麦");
                    showNotice(result.u + " 请求连麦");
                });

                /*this.rtmClient.on("teduboard", function (data) {
                    that.teduBoard.addSyncData(data.msg);
                });*/
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
                    drawEnable:true,
                    progressEnable:true,
                    userSig: this.boardSig, // 字符串
                };
                var that = this;
                this.teduBoard = new TEduBoard(params);
                this.teduBoard.on(TEduBoard.EVENT.TEB_INIT, function () {
                    that.teduBoard.setGlobalBackgroundColor("#F4F8FB");
                    $.message("白板初始化成功");
                });
                this.teduBoard.on(TEduBoard.EVENT.TEB_SYNCDATA, function (data) {
                    var tdata = {roomId: that.cId, type: 'teduboard', msg: data};
                    that.rtmClient.send(tdata);
                });
                this.teduBoard.on(TEduBoard.EVENT.TEB_FILEUPLOADPROGRESS, function (data) {
                    var p = CalculateFloat.floatMul(data.percent, 100);
                    $.message("上传进度：" + p + "%");
                });
                this.teduBoard.on(TEduBoard.EVENT.TEB_TRANSCODEPROGRESS, function (res) {
                    if (res.code) {
                        $.message('转码失败code:' + res.code + ' message:' + res.message);
                        return;
                    }
                    var status = res.status;
                    if (status === 'ERROR') {
                        $.message('转码失败');
                    } else if (status === 'UPLOADING') {
                        $.message('上传中，当前进度:' + parseInt(res.progress) + '%');
                    } else if (status === 'CREATED') {
                        $.message('创建转码任务');
                    } else if (status === 'QUEUED') {
                        $.message('正在排队等待转码');
                    } else if (status === 'PROCESSING') {
                        $.message('转码中，当前进度:' + res.progress + '%');
                    } else if (status === 'FINISHED') {
                        $.message('转码完成');
                        var config = {url: res.resultUrl, title: res.title,  pages: res.pages, resolution: res.resolution};
                        console.log('transcodeFile:', config);
                        that.teduBoard.addTranscodeFile(config);
                        that.transcodeFileTotal = res.pages;
                        that.transcodeFileCurrentNum = 1;
                    }
                });
                this.teduBoard.on(TEduBoard.EVENT.TEB_ADDTRANSCODEFILE, function (fildId) {
                    console.log("######2 = " + fildId);//#1587691269275
                });
            },
            rgbToHex: function (color) {
                var arr = [],
                    strHex;
                if (/^(rgb|RGB)/.test(color)) {
                    arr = color.replace(/(?:\(|\)|rgb|RGB)*/g, "").split(",");
                    strHex = '#' + ((1 << 24) + (arr[0] << 16) + (arr[1] << 8) + parseInt(arr[2])).toString(16).substr(1);
                } else {
                    strHex = color;
                }
                return strHex;
            },
            checkOrAddUser: function (socketData) {
                var result = socketData.msg;
                var users = this.userList;
                for (var i = 0; i < users.length; i++) {
                    var meetingUser = users[i];
                    if (meetingUser.userId == result.uid) {
                        return;
                    }
                }
                var userData = {courseId: this.cId, userId: result.uid, type: 1, userName: result.u};
                users.push(userData);
                this.userList = users;
            },
            loadUsers: function () {//加载课程信息
                if (!this.cId) {
                    $.message("参数错误，无法初始化数据");
                    return;
                }
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/queryUsers.json", {
                    id: this.cId,
                }).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.userList = data.data || [];
                });
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
            removeAttachment: function (id) {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsCourseItem/removeAttachment.json", {
                    attachmentId: id,
                }).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadAttachments();
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
                this.videoClient.join({roomId: this.roomId, role: 'anchor'}).then(function () {
                    console.log('进房成功');
                    that.subscribeVideoEvents();
                    that.videoStream = TRTC.createStream({ userId:that.userId, audio: true, video: true });
                    that.videoStream.setVideoProfile(that.videoProfile);
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
                    that.videoStream.play("video-player", {objectFit1: "contain"});
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
                            that.screenStream.play("share-screen-box", {objectFit1: "contain"});
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
                this.showWhiteboard = true;
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
                var that = this;
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
                if (streamId.indexOf("_screen") >= 0) {
                    return;
                }
                stream.name = this.getUserField(streamId, "userName") || "";
                this.$set(this.remoteStreams, streamId, stream);
                this.setUnActiveUserField(streamId, "isHand");
                this.setActiveUserField(streamId, "isCamera");
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
                this.setUnActiveUserField(streamId, "isHand");
                this.setUnActiveUserField(streamId, "isCamera");
                this.$set(this.remoteStreams, streamId, null);

                if (streamId == this.screenId) {
                    this.showShareScreen = false;
                }
            },
            uploadAttachment:function(){
                var that = this;
                $(".attachment-upload-form").unbind().submit(function () {
                    $.loading();
                    $(this).ajaxSubmit({
                        type: "post",
                        url: $(this).attr("action"),
                        dataType: "json",
                        success: function (data) {
                            $.closeLoading();
                            if (!data.success) {
                                $.message(data.message);
                                return false;
                            }
                            that.loadAttachments();
                        }
                    });
                    return false;
                });

                $(".attachment-upload-form input").val("").unbind().change(function () {
                    var value = $(this).val();
                    if (!value) {
                        $.message("请选择图片");
                        return;
                    }
                    $(".attachment-upload-form").submit();
                }).click();
            },
            setActiveUserField: function (id, field) {
                var users = this.userList;
                for (var i = 0; i < users.length; i++) {
                    var meetingUser = users[i];
                    if (meetingUser.userId == id) {
                        meetingUser[field] = true;
                        this.$set(this.userList, i, meetingUser);
                        return meetingUser;
                    }
                }
            },
            setUnActiveUserField: function (id, field) {
                var users = this.userList;
                for (var i = 0; i < users.length; i++) {
                    var meetingUser = users[i];
                    if (meetingUser.userId == id) {
                        meetingUser[field] = false;
                        this.$set(this.userList, i, meetingUser);
                        return meetingUser;
                    }
                }
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
            bindCancelRemoteVideo:function(streamId){
                var data = {roomId:this.cId, deviceIds:streamId, type:'speak_over', msg:'ok'};
                this.rtmClient.send(data);
                $.message("取消连麦指令已发送");
            },
            bindShowShareScreen: function () {
                if (this.screenStream) {
                    $.message("屏幕真正共享中");
                    return;
                }
                if (this.showMaxHost) {
                    this.bindCloseMaxHost();
                }
                this.showWhiteboard = false;
                this.showShareScreen = true;
                this.$nextTick(function () {
                    this.initScreen();
                });
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
                });
            },
            bindToggleMonitor: function () {
                if (this.showMonitor) {
                    this.showMonitor = false;
                    //close video
                    return;
                }
                this.showMonitor = true;
                this.bindNextMonitor();
            },
            bindPrevMonitor: function () {
                if (this.monitorPage * this.monitorPageNum <= this.monitorPageNum) {
                    $.message("已是第一页");
                    return;
                }
                var userList = this.userList;
                for (var i = this.monitorLimit; i < this.monitorNums; i++) {
                    var user = userList[i];
                    var data = {roomId: this.cId, deviceIds: user.userId, type: 'speak_over', msg: 'ok'};
                    this.rtmClient.send(data);
                }
                $.message("取消指令已经发送");

                this.monitorPage = this.monitorPage - 1;
                var nums = this.monitorPage * this.monitorPageNum;
                var limit = (this.monitorPage - 1) * this.monitorPageNum;
                limit = limit <= 0 ? 0 : limit;
                this.monitorLimit = limit;
                this.monitorNums = nums;
                //console.log(limit + " ==> " + nums);
                for (var i = limit; i < nums; i++) {
                    var user = userList[i];
                    var data = {roomId: this.cId, deviceIds: user.userId, type: 'hand_speak', msg: "ok"};
                    this.rtmClient.send(data);
                }
                $.message("连麦指令已发送");
            },
            bindNextMonitor: function () {
                var size = this.userList.length;
                if (this.monitorPage * this.monitorPageNum >= size) {
                    $.message("已是最后一页");
                    return;
                }
                var userList = this.userList;
                for (var i = this.monitorLimit; i < this.monitorNums; i++) {
                    var user = userList[i];
                    var data = {roomId: this.cId, deviceIds: user.userId, type: 'speak_over', msg: 'ok'};
                    this.rtmClient.send(data);
                }

                var limit = this.monitorPage * this.monitorPageNum;
                this.monitorPage = this.monitorPage + 1;
                var nums = this.monitorPage * this.monitorPageNum;
                nums = nums >= size ? size : nums;
                this.monitorLimit = limit;
                this.monitorNums = nums;
                //console.log(limit + " => " + nums);
                for (var i = limit; i < nums; i++) {
                    var user = userList[i];
                    var data = {roomId: this.cId, deviceIds: user.userId, type: 'hand_speak', msg: "ok"};
                    this.rtmClient.send(data);
                }
                $.message("连麦指令已发送");
            },
            bindCloseSetting: function () {
                this.videoStream && this.videoStream.stop();
                if (this.showMaxHost) {
                    this.videoStream && this.videoStream.play("max-host-video", {objectFit1: "contain"});
                } else {
                    this.videoStream && this.videoStream.play("video-player", {objectFit1: "contain"});
                }
                this.showVideoSetting = false;
            },
            bindShowUserBox: function () {//显示聊天区域
                this.showVideoFileBox = false;
                this.showUserBox = true;
                this.showImBox = false;
            },
            bindShowImBox: function () {//显示用户列表
                this.showVideoFileBox = false;
                this.showUserBox = false;
                this.showImBox = true;
            },
            bindShowVideoFileBox: function () {//显示用户列表
                this.showVideoFileBox = true;
                this.showImBox = false;
                this.showUserBox = false;
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
                var data = {roomId:this.cId, type:'im', msg:{msg: this.imMsg, u: "${user.name!}", uid: '${user.id!}'}};
                this.imMsg = "";
                this.rtmClient.send(data);
            },
            bindCloseMaxHost: function () {//关闭主播大屏显示
                this.showMaxHost = false;
                this.showWhiteboard = true;
                this.$nextTick(function () {
                    if (!this.videoStream) {
                        return;
                    }
                    this.videoStream.stop();
                    this.videoStream.play("video-player", {objectFit1: "contain"});
                });
            },
            bindShowMaxHost: function () {//开启主播大屏显示
                if (this.showShareScreen) {
                    $.message("请先关闭共享屏幕");
                    return;
                }
                this.showWhiteboard = false;
                this.showMaxHost = true;
                this.$nextTick(function () {
                    this.videoStream.stop();
                    this.videoStream.play("max-host-video", {objectFit1: "contain"});
                });
            },
            bindMuteVoice:function () {//是否关闭掉声音
                if (this.isMuteVoice) {
                    this.unmuteAudio();
                    return;
                }
                this.muteAudio();
            },
            bindMuteVideo:function () {//是否关闭掉视频
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
            bindToggleLinkCamera: function () {
                if (this.isLinkCamera) {
                    this.isLinkCamera = false;
                } else {
                    this.isLinkCamera = true;
                }
                var data = {roomId: this.cId, type: 'link_camera', msg: this.isLinkCamera.toString()};
                this.rtmClient.send(data);
                $.message("开启/关闭连麦指令已发送");
            },
            bindAllMuteVoice2: function () {
                var category = this.isAllMuteVoice ? "unmute_voice" : "mute_voice";
                this.isAllMuteVoice = !this.isAllMuteVoice;
                var data = {roomId: this.cId, type: category, msg: "ok"};
                this.rtmClient.send(data);
                $.message("音频指令已发送");
            },
            bindToggleStopWord: function () {
                if (this.isStopWord) {
                    this.isStopWord = false;
                } else {
                    this.isStopWord = true;
                }
                var data = {roomId: this.cId, type: 'stop_word', msg: this.isStopWord.toString()};
                this.rtmClient.send(data);
                $.message("开启/关闭全体禁言指令已发送");
            },
            bindLinkCamera: function (userId) {//连麦
                if (userId == this.userId) {
                    return;
                }
                var isCamera = this.getUserField(userId, "isCamera");
                if (isCamera) {
                    $.message("该用户正在连麦中");
                    return;
                }
                var data = {roomId: this.cId, deviceIds: userId, type: 'hand_speak', msg: "ok"};
                this.rtmClient.send(data);
                $.message("连麦指令已发送");
            },
            bindLeaveOut:function () {
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
            bindAttendClass:function () {
                this.initVideo();
            },
            bindOverClass:function () {
                var that = this;
                that.screenStream && that.screenStream.close();
                that.screenStream = null;
                that.videoStream && that.videoStream.close();
                that.videoStream = null;
                that.remoteStreams = [];
                that.leaveRoom();
            },
            bindSelectColor:function(color){
                this.showColor = false;
                this.showSize = false;
                this.teduBoard.setBrushColor(color);
            },
            addBoardImage:function() {
                this.teduBoard.addImageElement({
                    data: document.getElementById('board-image').files[0],
                    userData: 'xxx'
                });
            },
            addBoardPPT: function () {
                this.teduBoard.applyFileTranscode({
                    data: document.getElementById('ppt-file').files[0],
                    userData: 'xxx'
                }, {isStaticPPT: true});
            },
            bindSelectSize:function(size){
                this.showColor = false;
                this.showSize = false;
                this.teduBoard.setBrushThin(size * 10);
            },
            boardScale:function(e) {
                var delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)));
                if (delta > 0) {//向上滚动
                    var scale = this.teduBoard.getBoardScale() + 10;
                    scale = scale > 300 ? 300 : scale;
                    this.teduBoard.setBoardScale(scale);
                    console.log(scale);
                    return;
                }
                var scale = this.teduBoard.getBoardScale() - 10;
                scale = scale < 100 ? 100 : scale;
                this.teduBoard.setBoardScale(scale);
                console.log(delta > 0 ? "向上滚动" : "向下滚动");
                console.log(scale);
            },
            whiteboardSelect: function (toolName) {
                if (!this.teduBoard) {
                    $.message("白板还没有初始化成功！");
                    return;
                }
                if (toolName == "file") {
                    $(".ppt-form input").val("").click();
                    return;
                }
                if (toolName == "color") {
                    this.showColor = true;
                    return;
                }
                if (toolName == "size") {
                    this.showSize = true;
                    return;
                }
                if (toolName == "trash") {
                    this.teduBoard.clear(false, false);
                    return;
                }
                if (toolName == "img") {
                    $(".image-form input").val("").click();
                    //var url = "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1208538952,1443328523&fm=26&gp=0.jpg";
                    //this.teduBoard.addImageElement(url);
                    return;
                }
                var tools = {
                    "mouse": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_MOUSE,
                    "pencil": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_PEN,
                    "line": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_LINE,
                    "ellipse": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_OVAL,
                    "rectangle": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_RECT,
                    "rectangle2": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_RECT_SOLID,
                    "text": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_TEXT,
                    "eraser": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_ERASER,
                    "select": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_POINT_SELECT,
                    "selects": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_RECT_SELECT,
                    "move": TEduBoard.TOOL_TYPE.TEDU_BOARD_TOOL_TYPE_ZOOM_DRAG,
                };
                this.currentTool = toolName;
                this.teduBoard.setToolType(tools[toolName]);
            },
            nextPpt:function() {
                this.teduBoard.nextStep();
                if (this.transcodeFileCurrentNum < this.transcodeFileTotal) {
                    this.transcodeFileCurrentNum++;
                }
            },
            prevPpt:function() {
                this.teduBoard.prevStep();
                if (this.transcodeFileCurrentNum > 1) {
                    this.transcodeFileCurrentNum --;
                }
            },
        }
    });

    var showNotice = function (msg) {
        try {
            Notification.requestPermission(function (permission) {
                if (permission == "granted") {
                    new Notification('连麦提醒', {body: msg, tag: 'yunfeiTag'});
                }
            });
        } catch (e) {
            console.log(e);
        }
    };
</script>
</body>

</html>
