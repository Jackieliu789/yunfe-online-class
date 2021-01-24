<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>用户列表</title>
    <#include "/common/resource.ftl">
    <style type="text/css">
        .search-input{border-radius:2px;border:1px solid #aaa;height:25px;line-height:25px;padding:0px 5px;width:96%;}
        .role-list{margin-top:10px;}
        .role-list li, .select-list li{display:inline-block;height:28px;line-height:28px;padding:0px 5px;cursor:pointer;margin-bottom:5px;border-radius:2px;background:#eee;margin-right:5px;}
    </style>
</head>
<body>
    <div class="ui-body">
        <ul class="role-list all-list"></ul>
    </div>
    <script type="text/javascript">
        var addSecUser = function(id, name) {
            var content = '<li userId="'+id+'"><span>'+name+'</span>&nbsp;<i class="fa fa-remove"></i></li>';
            $("ul.all-list").append(content);
            $("ul.all-list li i.fa-remove").unbind().click(function(){
                var parent = $(this).parent();
                var userId = parent.attr("userId");
                layer.confirm('是否确定删除', function () {
	                $.ajaxRequest({
	                    url:"${params.contextPath}/web/role/removeUser.json",
	                    data:{roleId:'${params.roleId!}', userId:userId},
	                    success:function(data){
	                        if (!data.success) {
	                            $.message(data.message);
	                            return;
	                        }
	                        parent.remove();
	                        $.message("删除成功");
	                    }
	                });
                });
            });
        };

        //获取当前登录用户所有可用的角色列表
        var init_all_users = function(){
            $.ajaxRequest({
                url:"${params.contextPath}/web/user/queryByRoleId.json",
                data:{roleId:"${params.roleId!}"},
                success:function(data){
                    $("ul.all-list").html("");
                    var list = data.data || "";
                    if (list != "") {
                        for (var i = 0; i < list.length; i ++) {
                            var item = list[i];
                            addSecUser(item.id, item.name);
                        }
                    }
                }
            });
        };
        $(document).ready(function(){
            init_all_users();
        });
    </script>
</body>
</html>
