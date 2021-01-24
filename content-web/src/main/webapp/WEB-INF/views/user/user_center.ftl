<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>个人中心</title>
    <#include "/common/resource.ftl">
    <style type="text/css">
		.set-nav li {line-height:34px;height:34px;padding-left:22px;cursor:pointer;border-bottom:1px solid #e6e6e6;border-left:1px solid #e6e6e6;border-right:1px solid #e6e6e6;}
        .set-nav li:first-child{border-top:1px solid #e6e6e6;border-radius:2px 2px 0px 0px;}
        .set-nav li:last-child{border-radius:0px 0px 2px 2px;}
		.set-nav li.active {border-color:#3c8dbc;background:#3c8dbc;color:#fff;}
	</style>
</head>
<body>
    <table class="ui-table">
        <tr>
            <td class="ui-table-left" style="width:200px;">
                <!-- ** 左侧栏 ** -->
                
                <div class="ui-body set-nav" style="border-top: 1px solid #ddd;">
                    <ul style="padding-top1: 20px;">
						<li onclick="profileSwitch('profile',this)" class="active">个人资料</li>
						<li onclick="profileSwitch('password',this)" class="">修改密码</li>
					</ul>
                </div>
            </td>
            <td class="ui-table-right" style="padding-top: 10px;padding-left: 10px;">
    
                <div class="ui-body profile-form"  id="profile" style="border-top: 1px solid #ddd;">
                    <div class="ui-form">
				        <form class="layui-form ajax-form" action="${params.contextPath!}/web/user/modifyInfo.json" method="post">
				            <div class="layui-form-item">
				                <label class="layui-form-label">姓名<span class="ui-required">*</span></label>
				                <div class="layui-input-block">
				                    <input type="text" name="name" placeholder="请输入姓名" class="layui-input">
				                </div>
				            </div>
				            
				            <div class="layui-form-item">
				                <label class="layui-form-label">手机号码<span class="ui-required">*</span></label>
				                <div class="layui-input-block">
				                    <input type="text" name="phone" placeholder="请输入手机号码" class="layui-input">
				                </div>
				            </div>

				            <div class="layui-form-item">
				                <label class="layui-form-label">性别</label>
				                <div class="layui-input-block">
				                    <select name="gender" class="layui-select">
				                        <option value="3">未知</option>
				                        <option value="1">男</option>
				                        <option value="2">女</option>
				                    </select>
				                </div>
				            </div>
				            <div class="layui-form-item">
				                <label class="layui-form-label">Email</label>
				                <div class="layui-input-block">
				                    <input type="text" name="email" placeholder="请输入Email" class="layui-input">
				                </div>
				            </div>
				            <div class="layui-form-item">
				                <label class="layui-form-label">座机号码</label>
				                <div class="layui-input-block">
				                    <input type="text" name="telephone" placeholder="请输入座机号码" class="layui-input">
				                </div>
				            </div>
				            <div class="layui-form-item">
				                <div class="layui-input-block">
				                    <input type="button" value="保存" class="layui-btn info-button"/>
				                </div>
				            </div>
				        </form>
				    </div>
                </div>
                <div class="ui-body profile-form"  id="password" style="display: none;border-top: 1px solid #ddd;">
                    <div class="ui-form">
				        <form class="layui-form ajax-form" action="${params.contextPath}/web/user/modifyPass.json" method="post">
			                <div class="layui-form-item">
			                    <label class="layui-form-label">原密码<span class="ui-required">*</span></label>
			                    <div class="layui-input-block">
			                        <input type="password" name="oldPass" placeholder="请输入原密码" class="layui-input">
			                    </div>
			                </div>
				            <div class="layui-form-item">
			                    <label class="layui-form-label">新密码<span class="ui-required">*</span></label>
			                    <div class="layui-input-block">
			                        <input type="password" name="newPass" placeholder="请输入新密码" class="layui-input">
                                    <small style="color:#f33;margin-top:5px;display:block;font-size:12px;">规则为：大写字母、小写字母、特殊字符、数字 两种或两种以上组合匹配，6-18位</small>
			                    </div>
			                </div>
			                <div class="layui-form-item">
			                    <label class="layui-form-label">确认密码<span class="ui-required">*</span></label>
			                    <div class="layui-input-block">
			                        <input type="password" name="confirmPass" placeholder="请输入确认密码" class="layui-input">
			                    </div>
			                </div>
				            
				            <div class="layui-form-item">
				                <div class="layui-input-block">
				                    <input type="button" value="保存" class="layui-btn pass-button"/>
				                </div>
				            </div>
				        </form>
				    </div>
                </div>
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        $(document).ready(function(){
            $(".ui-body").height($(window).height() - 50);
			//初始化数据
			$.ajaxRequest({
				url:"${params.contextPath}/web/user/query.json",
				data:{id:"${user.id!}"},
				async:true,
				success:function(data) {
					if (!data.success) {
						$.message(data.message);
						return;
					}
					var record = data.data;
					for (var key in record) {
						$("[name='"+key+"']").val(record[key]);
					}
				}
			});
			//保存个人资料
			$(".info-button").click(function () {
				var form = $(this).parents("form");
                $.ajaxRequest({
                    url:form.attr("action"),
                    data:form.serialize(),
                    async:true,
                    success:function(data) {
                        $.message(data.message);
                    }
                });
            });
            //修改密码
            $(".pass-button").click(function () {
                var form = $(this).parents("form");
                $.ajaxRequest({
                    url:form.attr("action"),
                    data:form.serialize(),
                    async:true,
                    success:function(data) {
                        $.message(data.message);
						if (data.success) {
							$("[name='oldPass']").val("");
							$("[name='newPass']").val("");
							$("[name='confirmPass']").val("");
						}
                    }
                });
            });
        });
        
        function profileSwitch(type,obj){
        	$(".profile-form").hide();
        	$("#"+type).show();
        	$(".set-nav").find("li").removeClass("active");
        	$(obj).addClass("active");
        }
    </script>
</body>
</html>
