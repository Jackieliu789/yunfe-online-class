<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${params.websitName!}</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <#if params.faviconImagePath??>
        <link rel="shortcut icon" href="${params.fileRequestUrl!}${params.faviconImagePath!}" type="image/x-icon">
        <link rel="icon" href="${params.fileRequestUrl!}${params.faviconImagePath!}" type="image/x-icon">
    </#if>

    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/layui/css/layui.css?_t=${params.pageRandom!}"/>
    <link rel="stylesheet" href="${params.contextPath}/adminui/ui/global/bootstrap/css/bootstrap.min.css?_t=${params.pageRandom!}">
    <link rel="stylesheet" href="${params.contextPath}/adminui/ui/global/font-awesome/css/font-awesome.css?_t=${params.pageRandom!}" />
    <!-- Theme style -->
    <link rel="stylesheet" href="${params.contextPath}/adminui/adminlte/dist/css/AdminLTE.css?_t=${params.pageRandom!}">
    <link rel="stylesheet" href="${params.contextPath}/adminui/adminlte/dist/css/skins/_all-skins.css?_t=${params.pageRandom!}">
    <link rel="stylesheet" type="text/css" href="${params.contextPath}/common/layui/css/modules/layim/layim.css?_t=${params.pageRandom!}"/>
    <link rel="stylesheet" href="${params.contextPath}/adminui/min/css/supershopui.common.min.css?_t=${params.pageRandom!}"/>
    <style type="text/css">
        html {overflow: hidden;}
        .layui-edge{display:block;}
    </style>
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body class="hold-transition skin-blue sidebar-mini fixed">
<div class="wrapper">
    <!-- Main Header -->
    <header class="main-header" id="main-header">
        <a href="" class="logo">
            <!-- mini logo for sidebar mini 50x50 pixels -->
            <span class="logo-mini"><b>${params.websitShortName!}</b></span>
            <!-- logo for regular state and mobile devices -->
            <span class="logo-lg">${params.websitShortName!}</span>
        </a>

        <!-- Header Navbar -->
        <nav class="navbar navbar-static-top" role="navigation">
            <!-- Sidebar toggle button-->
            <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
                <span class="sr-only">切换导航</span>
            </a>
            <!-- Navbar Right Menu -->
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown user user-menu">
                        <!-- Menu Toggle Button -->
                        <a href="javascript:void(0)" class="dropdown-toggle" data-toggle="dropdown">
                            <!-- The user image in the navbar-->
                            <#--<img src="${params.contextPath}/adminui/ui/img/photos/user.png" class="user-image" alt="User Image">-->
                            <img src="${params.contextPath}/images/default.jpg" class="user-image" alt="User Image"/>
                            <!-- hidden-xs hides the username on small devices so only the image appears. -->
                            <span class="hidden-xs">TZHSWEET</span>
                        </a>
                        <ul class="dropdown-menu">
                            <!-- The user image in the menu -->
                            <li class="user-header">
                                <#--<img src="${params.contextPath}/adminui/ui/img/photos/user.png" class="img-circle" alt="User Image">-->
                                <img src="${params.contextPath}/images/default.jpg" class="img-circle" alt="User Image">
                                <p>
                                    <span>--</span>
                                    <#--<small>2016年注册</small>-->
                                </p>
                            </li>
                            <!-- Menu Body -->
                            <li class="user-body" style="display: none;">
                                <div class="row">
                                    <div class="col-xs-4 text-center">
                                        <a href="#">个人信息</a>
                                    </div>
                                    <div class="col-xs-4 text-center">
                                        <a href="#">设置</a>
                                    </div>
                                    <div class="col-xs-4 text-center">
                                        <a href="#">主题</a>
                                    </div>
                                </div>
                                <!-- /.row -->
                            </li>
                            <!-- Menu Footer-->
                            <li class="user-footer">
                                <div class="pull-left">
                                    <a href="javascript:void(0)" onclick="addTabs(({ id: 'user_center', title: '个人中心', close: true, url: '${params.contextPath}/view/user/user_center.htm' }))" class="btn btn-default btn-flat">个人中心</a>
                                </div>
                                <div class="pull-right">
                                    <a href="javascript:void(0)" reurl="${params.contextPath}/loginOut.json" class="btn btn-default btn-flat login-out">退出</a>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <!-- Control Sidebar Toggle Button -->
                    <li>
                        <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <!-- Left side column. contains the logo and sidebar -->
    <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
            <!-- Sidebar Menu -->
            <ul class="sidebar-menu"></ul>
            <!-- /.sidebar-menu -->
        </section>
        <!-- /.sidebar -->
    </aside>
    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper"  id="content-wrapper">
        <div class="content-tabs">
            <button class="roll-nav roll-left tabLeft" onclick="scrollTabLeft()">
                <i class="fa fa-backward"></i>
            </button>
            <nav class="page-tabs menuTabs tab-ui-menu" id="tab-menu">
                <div class="page-tabs-content" style="margin-left: 0px;">

                </div>
            </nav>
            <button class="roll-nav roll-right tabRight" onclick="scrollTabRight()">
                <i class="fa fa-forward" style="margin-left: 3px;"></i>
            </button>
            <div class="btn-group roll-nav roll-right">
                <button class="dropdown tabClose" data-toggle="dropdown">
                    页签操作<i class="fa fa-caret-down" style="padding-left: 3px;"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-right" style="min-width: 128px;">
                    <li><a class="tabReload" href="javascript:refreshTab();">刷新当前</a></li>
                    <li><a class="tabCloseCurrent" href="javascript:closeCurrentTab();">关闭当前</a></li>
                    <li><a class="tabCloseAll" href="javascript:closeOtherTabs(true);">全部关闭</a></li>
                    <li><a class="tabCloseOther" href="javascript:closeOtherTabs();">除此之外全部关闭</a></li>
                </ul>
            </div>
            <button class="roll-nav roll-right fullscreen" ><i class="fa fa-arrows-alt"></i></button>
        </div>
        <div class="content-iframe " style="background-color: #eaedef; ">
            <div class="tab-content " id="tab-content"></div>
        </div>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
    <!-- Main Footer -->
    <!-- <footer class="main-footer">
        <div class="pull-right hidden-xs">技术支持：安徽新华博信息技术股份有限公司</div>
        Copyright 2017 AHPSD All Rights Reserved ©安徽省公安厅版权所有     皖ICP备05015515号
    </footer> -->
    <!-- Control Sidebar -->
    <aside class="control-sidebar control-sidebar-dark">
        <ul class="nav nav-tabs nav-justified control-sidebar-tabs"></ul>
        <div class="tab-content">
            <div class="tab-pane" id="control-sidebar-home-tab"></div>
        </div>
    </aside>
    <!-- /.control-sidebar -->
    <!-- Add the sidebar's background. This div must be placed immediately after the control sidebar -->
    <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->
<!-- REQUIRED JS SCRIPTS -->
<!-- jQuery 2.2.3 -->
<script type="text/javascript" src="${params.contextPath}/adminui/ui/global/jQuery/jquery.min.js?_t=${params.pageRandom!}"></script>
<!-- Bootstrap 3.3.6 -->
<script type="text/javascript" src="${params.contextPath}/adminui/ui/global/bootstrap/js/bootstrap.min.js?_t=${params.pageRandom!}"></script>
<script type="text/javascript" src="${params.contextPath}/adminui/min/js/supershopui.common.js?_t=${params.pageRandom!}"></script>
<script type="text/javascript" src="${params.contextPath}/common/layui/layui.all.js?_t=${params.pageRandom!}"></script>
<script type="text/javascript" src="${params.contextPath}/js/tools.js?_t=${params.pageRandom!}"></script>
<script type="text/javascript" src="${params.contextPath}/js/support.js?_t=${params.pageRandom!}"></script>
<script type="text/javascript">
    top.domain = '${params.contextPath}';
    var Application = {
        toStanardMenu: function (menuTree) {
            for (var i = 0; i < menuTree.length; i++) {
                var menu = menuTree[i];
                menu.text = menu.name;
                menu.targetType = "iframe-tab";
                menu.icon = "fa " + menu.icon;
                menu.url = "${params.contextPath!}" + menu.url;
                if (menu.children) {
                    menu.url = "";
                    this.toStanardMenu(menu.children);
                }
            }
        },
        getMenus: function (menuArray) {
            var temp = {}, tree = [];
            for (var i = 0; i < menuArray.length; i++) {
                var menu = menuArray[i];
                temp[menu.id] = menu;
            }
            for (var i = 0; i < menuArray.length; i++) {
                var menu = menuArray[i];
                var parent = temp[menu.parentId];
                if (parent) {
                    if (!parent.children) {
                        parent.children = [];
                    }
                    parent.children.push(menu);
                    continue;
                }
                tree.push(menu);
            }
            this.toStanardMenu(tree);
            $('.sidebar-menu').sidebarMenu({data: tree, param: {strUser: 'admin'}});
        },
        getUser: function () {
            $(".user-header p span").html("${user.name!'--'}");
            $(".user-menu .hidden-xs").html("${user.name!'--'}");

            var menuArray = eval('(${user.menuJsonArray!})');
            Application.getMenus(menuArray);
        },
        modifySimplePass: function () {
            layer.open({
                type: 2, shade: 0.3, title: "修改密码",
                closeBtn: 0,
                shadeClose: false,
                area: ['650px', '450px'],
                content: '${params.contextPath!}/view/user/user_pass.htm?_t=' + new Date().getTime()
            });
        },
        init: function () {
            this.getUser();

            <#if (user.simplePass)??>
                this.modifySimplePass();
            </#if>
        }
    };

    $(function () {
        App.setbasePath("${params.contextPath}/adminui/");
        $(".login-out").click(function () {
            App.blockUI({target: '#main-header', boxed: true, message: '退出中......'});
            var url = $(this).attr("reurl");
            $.post(url, function (data) {
                if (data.success) {
                    location.href = "${params.contextPath}/login.htm";
                    return;
                }
                App.unblockUI("#main-header");
                alert(data.message);
            });
        });
        Application.init();
        addTabs(({id: '10008', title: '工作台', close: false, url: '${params.contextPath}/view/frame/workbench.htm'}));
        App.fixIframeCotent();
        setInterval(keepAlive, 1000 * 60 * 10);

        $(".alarm-btn").click(function () {
            Application.alarm();
        });
    });

    function keepAlive() {
        $.ajax({
            url: '${params.contextPath}/web/keepAlive.json',
            type: 'GET',
            success: function (resp) {
                if (!resp.success) {
                    window.location.href = '${params.contextPath}/login.htm';
                }
            },
            dataType: 'json'
        });
    }
</script>
</body>
</html>