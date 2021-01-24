<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${params.websitName!}</title>
    <#if params.faviconImagePath??>
        <link rel="shortcut icon" href="${params.fileRequestUrl!}${params.faviconImagePath!}" type="image/x-icon">
        <link rel="icon" href="${params.fileRequestUrl!}${params.faviconImagePath!}" type="image/x-icon">
    </#if>
    <link rel="stylesheet" href="https://www.layuicdn.com/layui/css/layui.css" />
    <script type="text/javascript" src="https://www.layuicdn.com/layui/layui.js"></script>
    <style>
        ::-webkit-scrollbar-track-piece{width:6px;background-color1:#4e4e5a;}
        ::-webkit-scrollbar{width:6px;height:6px ; }
        ::-webkit-scrollbar-thumb{height:50px;background:#aaa;cursor:pointer;}
        ::-webkit-scrollbar-thumb:hover{background:#4e4e5a; cursor:pointer;}
        .layui-nav{background-color:#fff;color:#2F4056;}
        .layui-nav .layui-nav-item a{color:#2F4056;font-size:18px;}
        .layui-nav .layui-nav-item a:hover{color:#2F4056;background-color:rgba(0,0,0,0.2)}
        .banner{background-repeat:no-repeat;background-size:cover;}
        .zb .img img{height:155px;}
        .zb .text{margin-top:30px;}
        .op .header{color:#333;text-align:center;margin-bottom:20px;font-size:18px;}
        .op .text{color:#999;}
        .op .item{-webkit-box-shadow: 4px 6px 21px 2px rgba(14,101,243,0.22);
            box-shadow: 4px 6px 21px 2px rgba(14,101,243,0.22);
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
        padding:20px;
        height:120px;}
    </style>
</head>
<body>
<#--菜单-->
<div style="position:fixed;top:0;right:0;left:0;border-bottom:1px solid #F2F2F2;z-index:10;background:#fff;">
    <div class="layui-container" style="padding:10px 0px;">
        <div class="layui-row layui-col-space10">
            <div class="layui-col-sm2 layui-col-md2" style="overflow:hidden;line-height:60px;">
                <#if params.logoImagePath??>
                    <img src="${params.fileRequestUrl!}${params.logoImagePath!}" style="height:40px;max-width:100%;" />
                <#else>
                    <img src="${params.contextPath}/images/logo.png" style="height:40px;max-width:100%;" />
                </#if>
            </div>
            <div class="layui-col-sm8 layui-col-md8">
                <ul class="layui-nav">
                    <li class="layui-nav-item">
                        <a href="#index">首页</a>
                    </li>
                    <li class="layui-nav-item">
                        <a href="#zbxq">直播需求</a>
                    </li>
                    <li class="layui-nav-item">
                        <a href="#jykt">教育课堂</a>
                    </li>
                    <li class="layui-nav-item">
                        <a href="#fwnr">服务内容</a>
                    </li>
                    <li class="layui-nav-item">
                        <a href="#lxwm">联系我们</a>
                    </li>
                </ul>
            </div>
            <div class="layui-col-sm6 layui-col-md2" style="line-height:60px;text-align:right;">
                <a target="_blank" href="${params.contextPath!}/login.htm" class="layui-btn layui-btn-normal">立即体验</a>
            </div>
        </div>
    </div>
</div>

<#--宣传图片-->
<div class="layui-fluid banner" id="index" style="margin-top:80px;background-image: url('${params.contextPath!}/images/banner1.jpg');">
    <div class="layui-container" style="height:560px;color:#fff;padding-top:150px;">
        <h1 style="font-size:48px;margin-bottom:10px;font-weight:lighter">${params.websitName!}</h1>
        <h2 style="font-size:34px;margin-bottom:20px;font-weight:lighter">零距离授课，低延时不卡顿，屏幕共享、电子白板，还原真实教学课堂</h2>
        <h3 style="font-size:18px;font-weight:lighter">提供完整的在线互动直播解决方案，打破空间限制，满足各类教育直播场景，快速完成线下和线上的直播需求</h3>
    </div>
</div>
<#--直播需求-->
<div class="layui-container zb" id="zbxq" style="margin-top: 60px;text-align: center;background: #1E9FFF;padding:60px 0px;color:#fff;">
    <h1 style="font-size:48px;margin-bottom:10px;font-weight:lighter">满足各种在线教育场景的直播需求</h1>
    <h3 style="font-size:18px;font-weight:lighter">支持老师多端实景直播互动教学、课程实景录播存储、内容在线分享，为教育培训机构、企业院校、政府单位等提供更个性化的直播服务</h3>
    <div class="layui-row layui-col-space10" style="margin-top:30px;">
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon1.png" alt="">
            </div>
            <div class="text">互动大班课</div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon2.png" alt="">
            </div>
            <div class="text">精品小班课</div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon3.png" alt="">
            </div>
            <div class="text">一对一私教</div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon4.png" alt="">
            </div>
            <div class="text">大型公开课</div>
        </div>
    </div>
    <div class="layui-row layui-col-space10" style="margin-top:30px;">
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon5.png" alt="">
            </div>
            <div class="text">教育培训</div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon6.png" alt="">
            </div>
            <div class="text">企业内训</div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon7.png" alt="">
            </div>
            <div class="text">视频会议</div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="img">
                <img src="${params.contextPath!}/images/icon8.png" alt="">
            </div>
            <div class="text">院校教学</div>
        </div>
    </div>
</div>
<#--教育课堂-->
<div class="layui-fluid banner" id="jykt" style="margin-top:80px;background-image: url('${params.contextPath!}/images/banner3.jpg');">
    <div class="layui-container zb" style="margin-top: 60px;text-align: center;padding:60px 0px;color:#fff;">
        <h1 style="font-size:48px;margin-bottom:10px;font-weight:lighter">海量教育直播场景 做专业的教育课堂</h1>
        <h3 style="font-size:18px;font-weight:lighter">我们不仅提供互动教育直播产品，还可依托${params.websitName!}教育直播的成熟基础，塑造属于您的特色的教育直播世界</h3>
        <div class="layui-row layui-col-space10" style="margin-top:30px;">
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon9.png" alt="">
                </div>
                <div class="text">K12教育</div>
            </div>
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon10.png" alt="">
                </div>
                <div class="text">职业教育</div>
            </div>
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon11.png" alt="">
                </div>
                <div class="text">学历教育</div>
            </div>
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon12.png" alt="">
                </div>
                <div class="text">兴趣培训</div>
            </div>
        </div>
        <div class="layui-row layui-col-space10" style="margin-top:30px;">
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon13.png" alt="">
                </div>
                <div class="text">企业培训</div>
            </div>
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon14.png" alt="">
                </div>
                <div class="text">政府单位</div>
            </div>
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon15.png" alt="">
                </div>
                <div class="text">商业直播</div>
            </div>
            <div class="layui-col-sm3 layui-col-md3">
                <div class="img">
                    <img src="${params.contextPath!}/images/icon16.png" alt="">
                </div>
                <div class="text">语言培训</div>
            </div>
        </div>
    </div>
</div>
<#--直播介绍-->
<div class="layui-container op" id="fwnr" style="margin-top:60px;padding:60px 0px;">
    <h1 style="font-size:48px;margin-bottom:10px;font-weight:lighter;text-align: center;">具体服务内容</h1>
    <div class="layui-row layui-col-space30" style="margin-top:30px;">
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">浏览器、小程序 直接教学</div>
                <div class="text">不依赖app方便简单
                    老师、学生使用谷歌浏览器简单方便.
                    手机端可使用小程序（正规过审）
                </div>
            </div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">1对1、1对N教学</div>
                <div class="text">老师学学全程可以实时看到彼此，
                    最大限度的还原教室真实性
                </div>
            </div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">万人大课可视频连麦</div>
                <div class="text">万人大课学生举手即可连麦老师沟通交流</div>
            </div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">共享桌面（无需插件）</div>
                <div class="text">有了他，老师想展示桌面就展示什、ppt、表格、图片、教案、等等</div>
            </div>
        </div>
    </div>
    <div class="layui-row layui-col-space30" style="margin-top:30px;">
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">白板功能（老师的小黑板）</div>
                <div class="text">老师上课的好帮手</div>
            </div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">多媒体播放</div>
                <div class="text">方便老师多媒体教学，
                    实时把视频、音频推到学生桌面
                    </div>
            </div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">课堂纪律管控</div>
                <div class="text">举手、禁麦克风、加人、踢人、禁言等全都有</div>
            </div>
        </div>
        <div class="layui-col-sm3 layui-col-md3">
            <div class="item">
                <div class="header">教学录制功能</div>
                <div class="text">录制老师画面、录制桌面、视频拼接合成
                    方便日后回放学习</div>
            </div>
        </div>
    </div>
</div>

<#--联系我们-->
<div class="layui-container op" id="lxwm" style="margin-top:60px;padding:60px 0px;">
    <h1 style="font-size:48px;margin-bottom:10px;font-weight:lighter;text-align: center;">联系我们</h1>
    <div class="layui-row layui-col-space30" style="margin-top:30px;">
        <div class="layui-col-sm4 layui-col-md4">
            <div class="item">
                <div class="header">商务咨询</div>
                <div class="text">${params.businessConsult!}</div>
            </div>
        </div>
        <div class="layui-col-sm4 layui-col-md4">
            <div class="item">
                <div class="header">技术支持</div>
                <div class="text">${params.technicalSupport!}</div>
            </div>
        </div>
        <div class="layui-col-sm4 layui-col-md4">
            <div class="item">
                <div class="header">联系电话</div>
                <div class="text">${params.contactNumber!}</div>
            </div>
        </div>
    </div>
</div>
<div style="color:#2F4056;text-align:center;font-size:14px;padding:40px;">微小智提供技术支持</div>
</body>

</html>
