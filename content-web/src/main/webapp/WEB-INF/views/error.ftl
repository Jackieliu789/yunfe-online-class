<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>系统异常</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <link rel="stylesheet" href="${params.contextPath}/adminui/ui/global/bootstrap/css/bootstrap.min.css">
    <link href="${params.contextPath}/adminui/ui/global/font-awesome/css/font-awesome.css" rel="stylesheet" />
    <link rel="stylesheet" href="${params.contextPath}/adminui/adminlte/dist/css/AdminLTE.css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>
<body class="hold-transition skin-blue sidebar-mini content-wrapper" style="margin-left:0px;">
        <!-- Main content -->
        <section class="content">

            <div class="error-page">
                <h2 class="headline text-red">500</h2>

                <div class="error-content">
                    <h3><i class="fa fa-warning text-red"></i> Oops! 系统出现错误了.</h3>

                    <p>
                        <br/>我们将尽快解决这个问题。<br/><br/>
                        现在您可以回到工作台继续其他的工作。
                    </p>

                    <#--<p>错误消息：${message!}</p>-->
                </div>
            </div>
            <!-- /.error-page -->

        </section>
        <!-- /.content -->
</body>
</html>
