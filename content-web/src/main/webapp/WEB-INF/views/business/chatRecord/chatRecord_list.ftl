<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>聊天记录列表</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container" @click="hideMenu">
        <div class="layui-row app-header">
            <div class="layui-col-md3">
                <a class="layui-btn layui-btn-sm" href="${params.contextPath}/web/chatRecord/export.json?roomId=${params.roomId!}" target="_blank">导出</a>
            </div>
            <div class="layui-col-md9 text-right">
                <#--<input type="text" v-model="params.name" placeholder="课程名称" class="layui-input">-->
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary search-button" @click="seachData">查询</button>
            </div>
        </div>
        <div class="app-list">
            <div class="layui-row">
                <div class="layui-col-md9">
                    <div class="app-table-num"><span class="num">聊天记录(共 {{total}} 条)</span></div>
                </div>
                <div class="layui-col-md3 text-right">
                    <span class="prev" @click="loadPrev">上一页</span>
                    <span class="next" @click="loadNext">下一页</span>
                </div>
            </div>
            <table class="layui-table" lay-even lay-skin="nob" lay-size1="sm">
                <thead>
                <tr>
                    <th style="width:20px;">#</th>
                    <th>名称</th>
                    <th>内容</th>
                    <th>时间</th>
                    <th style="width:100px;">操作</th>
                </tr>
                </thead>
                <tbody>
                <tr v-for="(item, index) in rows">
                    <td>{{20 * (params.page - 1) + 1 + index}}</td>
                    <td>{{item.userName}}</td>
                    <td>{{item.content}}</td>
                    <td>{{item.createTimeStr}}</td>
                    <td class="more-parent">
                        <div class="ui-operating" @click="remove(index)">删除</div>
                    </td>
                </tr>
                <tr v-if="rows.length <= 0">
                    <td colspan="5" class="text-center">没有更多数据了...</td>
                </tr>
                </tbody>
            </table>
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="app-table-num"><span class="num">共 {{total}} 条</span></div>
                </div>
                <div class="layui-col-md6 text-right">
                    <span class="prev" @click="loadPrev">上一页</span>
                    <span class="next" @click="loadNext">下一页</span>
                </div>
            </div>
        </div>
    </div>

</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            params: {
                name: '',
                page: 1,
                roomId: "${params.roomId!}"
            },
            rows: [],
            total: 0,
        },
        mounted: function () {
            this.loadData();
        },
        methods: {
            seachData:function(){
                this.params.page = 1;
                this.$nextTick(function () {
                    this.loadData();
                });
            },
            loadData: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/chatRecord/list.json", this.params).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.rows = data.rows;
                    that.total = data.total;
                });
            },
            loadNext: function () {
                if (this.rows.length < 20 && this.rows.length > 0) {
                    return;
                }
                this.params.page = this.params.page + 1;
                this.loadData();
            },
            loadPrev: function () {
                if (this.params.page <= 1) {
                    return;
                }
                this.params.page = this.params.page - 1;
                this.loadData();
            },
            showMenu:function (index) {
                this.hideMenu();
                this.$set(this.rows[index], "showMenu", true);
            },
            hideMenu: function () {
                var that = this;
                this.rows.forEach(function (item) {
                    that.$set(item, 'showMenu', false);
                });
            },
            remove:function (index) {//删除
                var that = this;
                $.http.post("${params.contextPath}/web/chatRecord/delete.json", {ids: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
        }
    });
</script>
</body>

</html>