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
    <link href="${params.contextPath}/adminui/ui/css/layout.css" rel="stylesheet" />
    <link href="${params.contextPath}/adminui/ui/css/login.css" rel="stylesheet"/>
    <style>
        .ibar {display: none;}
        input[name="yzmCode"]{width:50%;display:inline-block;vertical-align:top;}
        #yzmImage{width:40%;height:40px;border-radius:5px;display:inline-block;border:1px solid #ccc;cursor:pointer;}
    </style>
</head>

<body class="login-bg">
<div class="main ">
    <!--登录-->
    <div class="login-dom login-max">
        <div class="logo text-center">
            <a href="#">
                <#--<img src="${params.contextPath}/adminui/ui/img/logo.png" width="180px" height="180px" />-->
                <#if params.logoImagePath??>
                    <img src="${params.fileRequestUrl!}${params.logoImagePath!}" style="height:150px;border-radius:33px;" />
                <#else>
                    <img src="${params.contextPath}/images/logo.png" style="height:180px;border-radius:33px;" />
                </#if>
            </a>
        </div>
        <div class="login container " id="login">
            <p class="text-big text-center logo-color" style="font-size:36px !important;line-height:50px;">
                ${params.websitName!}
            </p>
            <#--<p class="text-center margin-small-top logo-color text-small">小程序电商框架</p>-->
            <form class="login-form" action="${params.contextPath}/loginIn.json" method="get" autocomplete="off">
                <div class="login-box border text-small" id="box" style="height: auto;">
                    <div class="name border-bottom">
                        <input type="text" placeholder="账号" name="account"/>
                    </div>
                    <div class="pwd border-bottom">
                        <input type="password" placeholder="密码" name="pass"/>
                    </div>
                    <#--<div class="pwd" style="margin-bottom:5px;margin-top:5px;">
                        <input type="text" placeholder="验证码" name="yzmCode"/>
                        <img src="${params.contextPath}/yzm.json" data-src="${params.contextPath}/yzm.json" id="yzmImage" title="看不清，点击换一张"/>
                    </div>-->
                </div>
                <input type="submit" class="btn text-center login-btn" value="立即登录" />
            </form>
            <!-- 
            <div class="forget">
                <a href="#" class="forget-pwd text-small fl"> 忘记登录密码？</a><a href="#" class="forget-new text-small fr" id="forget-new">注册账号</a>
            </div>
             -->
        </div>
    </div>
    <div class="footer text-center text-small ie">
        <#--<div style="font-size: 14px;">为获得良好的使用体验，推荐您下载使用<a style="color: orange;text-decoration: underline;" target="_blank" href="http://rj.baidu.com/soft/detail/14744.html?ald">Chrome浏览器</a></div>-->
        <div style="font-size: 14px;">
            为获得良好的使用体验，推荐您下载使用
            <a style="color: orange;text-decoration: underline;" target="_blank" href="https://www.baidu.com/s?wd=%E8%B0%B7%E6%AD%8C%E6%B5%8F%E8%A7%88%E5%99%A8&rsv_spt=1&rsv_iqid=0xf6559ff50003fd10&issp=1&f=8&rsv_bp=0&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=1&rsv_sug3=14&rsv_sug1=12&rsv_sug7=101">
                Chrome浏览器
            </a>
        </div>
        ${params.copyright!}
        <#--<span class="margin-left margin-right">|</span>
        <script src="#" language="JavaScript"></script>-->
    </div>
    <div class="popupDom">
        <div class="popup text-default">
        </div>
    </div>
</div>
</body>

<script src="${params.contextPath}/adminui/ui/global/jQuery/jquery.min.js"></script>
<script type="text/javascript">
    function popup_msg(msg) {
        $(".popupDom").css("top", "-40px");
        $(".popupDom").animate({
            "top": "0px"
        }, 400, function () {
            $(".popup").html(msg);
        });
        /*setTimeout(function () {
            $(".popupDom").animate({
                "top": "-40px"
            }, 400);
        }, 2000);*/
    }

    function isIE() {
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
            return true;
        }
        return false;
    }

    function close_popup() {
        $(".popupDom").animate({
            "top": "-40px"
        }, 400);
    }

    /*动画（注册）*/
    $(document).ready(function (e) {
        /*if (isIE() || !window.applicationCache) {
            location.href = "browser.htm";
            return;
        }*/
        $("form").submit(function () {
            popup_msg("正在登录...");
            var account = $("[name='account']").val() || "";
            var pass = $("[name='pass']").val() || "";
            var yzmCode = $("[name='yzmCode']").val() || "";
            $.ajax({
                url:$(this).attr("action"),
                data:{account:account,pass:pass,yzmCode:yzmCode},
                type:"post",
                dataType:"json",
                async:true,
                success:function(data){
                    close_popup();
                    if (data.success) {
                        location.href = "${params.contextPath}" + data.data;
                        return;
                    }
                    popup_msg(data.message);
                    $("#yzmImage").click();
                    $("[name='yzmCode']").val("");
                }
            });
            return false;
        });
        $("#yzmImage").click(function () {
            var url = $(this).attr("data-src") + "?_t=" + new Date().getTime();
            $(this).prop("src", url);
        });
    });
</script>
</html>