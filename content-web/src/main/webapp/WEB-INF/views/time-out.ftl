<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>会话超时</title>
    <script>
    	top.location.href='${params.contextPath}/login.htm';
    </script>
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
        <h2 class="headline text-aqua">205</h2>

        <div class="error-content">
            <h3><i class="fa fa-warning text-aqua"></i> Oops! 会话超时.</h3>

            <p>
                <br/>您当前的会话已超时，请重新登录。<br/><br/>
                <a href="${params.contextPath}/login.htm" target="_top" class="btn btn-info">回到登录页</a>
            </p>
        </div>
    </div>
    <!-- /.error-page -->

</section>
<!-- /.content -->
</body>
</html>
