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
        .select-list1 li{background:#5fb878;color:#fff;}
        .sys{color:#FF5722;}
    </style>
</head>
<body>
    <table class="ui-table">
        <tr>
            <td class="ui-table-left" style="width:365px;height:450px;">
                <!-- ** 左侧栏 ** -->
                <div class="ui-head">
                    <span>可选角色列表</span>
                </div>
                <div class="ui-body">
                    <input type="text" class="search-input" value="" placeholder="搜索"/>
                    <ul class="role-list all-list">
                        <#--<li roleid=""><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>
                        <li><i class="fa fa-plus"></i>&nbsp;<span>市局管理员角色</span></li>-->
                    </ul>

                </div>
            </td>
            <td class="ui-table-right" style="padding-top:10px;padding-left:5px;">
                <div class="ui-head">
                    <span>已选角色列表</span>
                    <span class="right submit-button">
                        <i class="fa fa-plus-circle"></i>&nbsp;保存
                    </span>
                </div>
                <div class="ui-content">
                    <ul class="role-list select-list">
                        <#--<li roleid=""><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>
                        <li><span>市局管理员角色</span>&nbsp;<i class="fa fa-remove"></i></li>-->
                    </ul>
                </div>
            </td>
        </tr>
    </table>
    <script type="text/javascript">
        //添加可角色列
        var addAllRole = function(id, name, isSys) {
            var exists = false;
            $("ul.all-list li").each(function(){
                var roleId = $(this).attr("roleId") || "";
                if (roleId == id) {
                    exists = true;
                    return false;
                }
            });
            if (exists) {
                return;
            }

            var sys = "";
            if (isSys && isSys == 1) {
                sys = "sys";
            }
            var content = '<li class="'+sys+'" roleId="'+id+'" isSys="'+isSys+'"><i class="fa fa-plus"></i>&nbsp;<span>'+name+'</span></li>';
            $("ul.all-list").append(content);
            $("ul.all-list li").unbind().click(function(){
                var roleId = $(this).attr("roleId");
                var name = $(this).find("span").html();
                addSelectRole(roleId, name, $(this).attr("isSys"));
            });
        };

        //添加已选角色列
        var addSelectRole = function(id, name, isSys) {
            var exists = false;
            $("ul.select-list li").each(function(){
                var roleId = $(this).attr("roleId") || "";
                if (roleId == id) {
                    exists = true;
                    return false;
                }
            });
            if (exists) {
                return;
            }

            var sys = "";
            if (isSys && isSys == 1) {
                sys = "sys";
            }

            var content = '<li class="'+sys+'" roleId="'+id+'"><span>'+name+'</span>&nbsp;<i class="fa fa-remove"></i></li>';
            $("ul.select-list").append(content);
            $("ul.select-list li i.fa-remove").unbind().click(function(){
                $(this).parent().remove();
            });
        };

        //获取当前登录用户所有可用的角色列表
        var init_all_roles = function(){
            $.ajaxRequest({
                url:"${params.contextPath}/web/role/availableList.json",
                success:function(data){
                    $("ul.all-list").html("");
                    var list = data.data || "";
                    if (list != "") {
                        for (var i = 0; i < list.length; i ++) {
                            var item = list[i];
                            addAllRole(item.id, item.name, item.isSys);
                        }
                    }
                }
            });
        };

        //获取该用户已有的可以用的角色列表
        var init_exist_roles = function(){
            $.ajaxRequest({
                url:"${params.contextPath}/web/role/queryByUserId.json",
                data:{userId:'${params.userId!}'},
                success:function(data){
                    $("ul.select-list").html("");
                    var list = data.data || "";
                    if (list != "") {
                        for (var i = 0; i < list.length; i ++) {
                            var item = list[i];
                            addSelectRole(item.id, item.name, item.isSys);
                        }
                    }
                }
            });
        };

        //保存表单
        var save_form = function() {
            $(".submit-button").click(function(){
                var array = new Array();
                $("ul.select-list li").each(function(){
                    var roleId = $(this).attr("roleId") || "";
                    array.push(roleId);
                });
                $.ajaxRequest({
                    url:"${params.contextPath}/web/role/addUserRole.json",
                    data:{userId:'${params.userId!}', roleIds:array.join(",")},
                    success:function(data){
                        if (!data.success) {
                            $.message(data.message);
                            return;
                        }
                        layer.alert("保存成功", function(){
                            //parent.DataGrid.refresh();
                            parent.layer.closeAll();
                        });
                    }
                });
            });
        };
        $(document).ready(function(){
            init_all_roles();
            init_exist_roles();
            save_form();

            $("input.search-input").keyup(function(){
                var value = $(this).val() || "";
                if (value == "") {
                    $("ul.all-list li").show();
                    return;
                }
                $("ul.all-list li span").each(function(){
                    var name = $(this).html();
                    if (name.indexOf(value) >= 0) {
                        $(this).parent().show();
                    } else {
                        $(this).parent().hide();
                    }
                });
            });
        });
    </script>
</body>
</html>
