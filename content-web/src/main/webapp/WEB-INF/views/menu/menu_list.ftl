<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="${params.contextPath}/common/ztree/css/zTreeStyle/zTreeStyle.css"/>
<title>菜单列表</title> <#include "/common/resource.ftl">
<script type="text/javascript" src="${params.contextPath}/common/ztree/js/jquery.ztree.all.min.js"></script>
</head>
<body>
<div class="layui-row">
    <div class="layui-col-md3 ui-table-left">
        <!-- ** 左侧栏 ** -->
        <div class="ui-head">
            <span>菜单结构树</span>
			<span class="right"><i class="fa fa-remove"></i>&nbsp;取消选中</span>
        </div>
        <div class="ui-body">
            <ul id="treeDemo" class="ztree"></ul>
        </div>
    </div>
    <div class="layui-col-md9">
        <!-- 右侧栏 -->
        <div class="ui-operation">
            <div class="ui-buttons">
                <div class="layui-btn-group tools">
                    <button class="layui-btn layui-btn-normal open-dialog" p="url:'${params.contextPath}/view/menu/menu_edit.htm',title:'添加菜单',width:'800px',height:'90%'">
                        <i class="fa fa-plus"></i>添加
                    </button>
                    <button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/menu/menu_edit.htm',title:'编辑菜单',width:'800px',height:'90%'">
                        <i class="fa fa-pencil"></i>修改
                    </button>
                    <button class="layui-btn layui-btn-normal remove-button" reurl="${params.contextPath}/web/menu/delete.json">
                        <i class="fa fa-remove"></i>删除
                    </button>
                    <button class="layui-btn layui-btn-normal  accept-button" reurl="${params.contextPath}/web/menu/accept.json">
                        <i class="fa fa-play"></i>启用
                    </button>
                    <button class="layui-btn layui-btn-normal  stop-button" reurl="${params.contextPath}/web/menu/stop.json">
                        <i class="fa fa-stop"></i>停用
                    </button>
                </div>
                <div class="ui-searchs">
                    <div class="value" style="">
                        <input type="text" placeholder="名称  编号" name="searchInput" value="" />
                        <input type="hidden" name="parentId" value=""/>
                    </div>
                    <input type="button" value="搜索" class="layui-btn layui-btn-danger search-button" />
                </div>
            </div>
        </div>
        <div class="ui-content" style="padding-left: 10px;padding-right:10px;">
            <table id="datagrid" options="url:'${params.contextPath}/web/menu/list.json',params:'getSearchParams'">
                <thead>
                <tr>
                    <th data-options="field:'ck',checkbox:true"></th>
                    <th data-options="field:'name',width:100,align1:'center'">菜单名称</th>
                    <th data-options="field:'code',width:100,align1:'center'">菜单编号</th>
                    <th data-options="field:'orderBy',width:60,align1:'center'">排序</th>
                    <th data-options="field:'url',width:180,align1:'center'">请求路径</th>
                    <th data-options="field:'categoryStr',width:60,align1:'center'">菜单类型</th>
                    <th data-options="field:'icon',width:60,align:'center',formatter:formatIcon">图标</th>
                    <th data-options="field:'stateStr',width:60,align:'center',formatter:formatState">状态</th>
                </tr>
                </thead>
            </table>
        </div>
    </div>
</div>
	<#--<table class="ui-table">
		<tr>
			<td class="ui-table-left">
				<!-- ** 左侧栏 ** &ndash;&gt;
				<div class="ui-head">
					<span>菜单结构树</span> <span class="right"> <i
						class="fa fa-remove"></i>&nbsp;取消选中
					</span>
				</div>
				<div class="ui-body">
					<ul id="treeDemo" class="ztree"></ul>
				</div>
			</td>
			<td class="ui-table-right" >
				

				<div class="ui-operation">

					<div class="ui-buttons">
						<div class="layui-btn-group tools">
							<button class="layui-btn layui-btn-normal open-dialog" p="url:'${params.contextPath}/view/menu/menu_edit.htm',title:'添加菜单',width:'800px',height:'90%'">
								<i class="fa fa-plus"></i>添加
							</button>
							<button class="layui-btn layui-btn-normal singleSelected" p="url:'${params.contextPath}/view/menu/menu_edit.htm',title:'编辑菜单',width:'800px',height:'90%'">
								<i class="fa fa-pencil"></i>修改
							</button>
							<button class="layui-btn layui-btn-normal remove-button" reurl="${params.contextPath}/web/menu/delete.json">
								<i class="fa fa-remove"></i>删除
							</button>
							<button class="layui-btn layui-btn-normal  accept-button" reurl="${params.contextPath}/web/menu/accept.json">
								<i class="fa fa-play"></i>启用
							</button>
							<button class="layui-btn layui-btn-normal  stop-button" reurl="${params.contextPath}/web/menu/stop.json">
								<i class="fa fa-stop"></i>停用
							</button>
						</div>
						<div class="ui-searchs">
							<div class="value" style="">
								<input type="text" placeholder="名称  编号" name="searchInput" value="" />
								<input type="hidden" name="parentId" value=""/>
							</div>
							<input type="button" value="搜索" class="layui-btn layui-btn-danger search-button" />
						</div>
					</div>
				</div>
				<div class="ui-content" style="padding-left: 10px;padding-right:10px;">
					<table id="datagrid" options="url:'${params.contextPath}/web/menu/list.json',params:'getSearchParams'">
						<thead>
							<tr>
								<th data-options="field:'ck',checkbox:true"></th>
								<th data-options="field:'name',width:100,align1:'center'">菜单名称</th>
								<th data-options="field:'code',width:100,align1:'center'">菜单编号</th>
								<th data-options="field:'orderBy',width:60,align1:'center'">排序</th>
								<th data-options="field:'url',width:180,align1:'center'">请求路径</th>
								<th data-options="field:'categoryStr',width:60,align1:'center'">菜单类型</th>
								<th data-options="field:'icon',width:60,align:'center',formatter:formatIcon">图标</th>
 								<th data-options="field:'stateStr',width:60,align:'center',formatter:formatState">状态</th>
 							</tr>
						</thead>
					</table>
				</div>
			</td>
		</tr>
	</table>-->
</body>
<script type="text/javascript">
	var getSearchParams = function(){
	    return {
	        searchInput:$("input[name='searchInput']").val() || "",
	        parentId:$("input[name='parentId']").val() || "",
	    };
	}
 
	function treeClick(event, treeId, treeNode, clickFlag) {
        $("input[name='parentId']").val(treeNode.id);
        DataGrid.refresh();
    }
	
	function beforeDrop(treeId, treeNodes, targetNode, moveType, isCopy) {
        var success = false;
        $.ajaxRequest({
            url:"${params.contextPath}/web/menu/drag.json",
            data:{id:treeNodes[0].id, targetId:targetNode.id},
            async:false,
            success:function (data) {
                if (!data.success) {
                    $.message("拖拽失败");
                    return;
                }
                $.message(data.message);
                success = true;
            }
        });
        return success;
    } 
	function formatIcon(val, row) {
		if (row.icon) {
			return '<i class="fa {0}"></i>'.format(row.icon);
		} 
		return "";
	}
	
	function formatState(val, row) {
		if (row.state == 1) {
			return '<span class="ui-accept">' + val + '</span>';
		} else {
			return '<span class="ui-stop">' + val + '</span>';
		}
	}

	function loadTree() {
		var setting = {
			data : {
				simpleData : {
					enable : true,
 				}
			},
			edit : {
				drag : {
					autoExpandTrigger : true
				},
				enable : true,
				showRemoveBtn : false,
				showRenameBtn : false
			} ,
			callback : {onClick : treeClick,beforeDrop : beforeDrop}
  			 
		};

		$.ajaxRequest({
			type : 'post',
			url : '${params.contextPath}/web/menu/tree.json',
			success : function(data) {
			    var treeList = data.data;
			    for (var i = 0; i < treeList.length; i ++) {
			        var node = treeList[i];
			        console.log(node.data.category);
			        if (node.data.category == 1) {
			            node.icon = "${params.contextPath}/images/menu.png";
					} else if (node.data.category == 2) {
                        node.icon = "${params.contextPath}/images/button.png";
					} else if (node.data.category == 3) {
                        node.icon = "${params.contextPath}/images/switch.png";
					} else if (node.data.category == 4) {
                        node.icon = "${params.contextPath}/images/other.png";
					} else if (node.data.category == 5) {
                        node.icon = "${params.contextPath}/images/app-icon.png";
                    }
				}
  				zTree = $.fn.zTree.init($("#treeDemo"), setting, treeList);
				zTree.expandNode(true); //展开根节点
 			}
		});
	}

	$(function() {
		loadTree();
		
		$(".ui-head .right").click(function(){
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.cancelSelectedNode();
            $("input[name='parentId']").val("");
            DataGrid.refresh();
        });
		
		$(".remove-button").click(function() {
			var ids = DataGrid.getCheckedIds();
			if (ids == "") {
				layer.msg("请选择删除记录")
				return false;
			}
			var url = $(this).attr("reurl");
			layer.confirm('确定删除记录', function() {
				$.ajaxRequest({
					url : url,
					data : {
						ids : ids.join(",")
					},
					success : function(data) {
						$.message(data.message);
						if (data.success) {
							DataGrid.reload();
						}
					}
				});
			});
		});

		$(".accept-button").click(function() {
			var ids = DataGrid.getCheckedIds();
			if (ids == "") {
				layer.msg("请选择启用菜单")
				return false;
			}
			var url = $(this).attr("reurl");
			$.ajaxRequest({
				url : url,
				data : {
					ids : ids.join(",")
				},
				success : function(data) {
					$.message(data.message);
					if (data.success) {
						DataGrid.reload();
					}
				}
			});
		});
		$(".stop-button").click(function() {
			var ids = DataGrid.getCheckedIds();
			if (ids == "") {
				layer.msg("请选择停用菜单")
				return false;
			}
			var url = $(this).attr("reurl");
			$.ajaxRequest({
				url : url,
				data : {
					ids : ids.join(",")
				},
				success : function(data) {
					$.message(data.message);
					if (data.success) {
						DataGrid.reload();
					}
				}
			});
		});
	}) 
</script>
</html>
