<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>单品列表</title>
    <#include "/common/vue_resource.ftl">
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container" @click="hideMenu">
        <div class="layui-row app-header">
            <div class="layui-col-md3">
                <button type="button" class="layui-btn layui-btn-sm" @click="showType">新建单品</button>
            </div>
            <div class="layui-col-md9 text-right">
                <select name="shelfStatus" class="layui-input" v-model="params.shelfStatus">
                    <option value="">上架状态</option>
                    <option value="1">上架</option>
                    <option value="2">下架</option>
                </select>
                <select name="category" class="layui-input" v-model="params.category">
                    <option value="">类型</option>
                    <option value="1">图文</option>
                    <option value="2">音频</option>
                    <option value="3">视频</option>
                </select>
                <input type="text" v-model="params.name" placeholder="单品名称" class="layui-input">
                <button type="button" class="layui-btn layui-btn-sm layui-btn-primary search-button" @click="seachData">查询</button>
            </div>
        </div>
        <div class="app-list">
            <div class="layui-row">
                <div class="layui-col-md9">
                    <div class="app-table-num"><span class="num">单品列表(共 {{total}} 条)</span><span class="comment">注：这里不显示专栏内容单品</span></div>
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
                        <th style="width:300px;">名称</th>
                        <th>价格</th>
                        <th>订阅量</th>
                        <th>状态</th>
                        <th>类别</th>
                        <th>上架时间</th>
                        <th style="width:200px;">操作</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(item, index) in rows">
                        <td>{{20 * (params.page - 1) + 1 + index}}</td>
                        <td>
                            <div class="layui-row layui-col-space10">
                                <div class="layui-col-xs3 bg-img" :style="{backgroundImage: 'url(${params.fileRequestUrl!}' + item.coverPath + ')' }">
                                </div>
                                <div class="layui-col-xs9 title">
                                    {{item.name}}
                                </div>
                            </div>
                        </td>
                        <td>
                            <span v-if="item.priceStatus == 1">{{item.price}} 元</span>
                            <span class="ui-error" v-if="item.priceStatus == 2">免费</span>
                        </td>
                        <td>{{item.subscribeNum}}</td>
                        <td><span :class="item.shelfStatus != 3 ? 'ui-accept' : 'ui-no'">{{item.shelfStatusStr}}</span></td>
                        <td>{{item.categoryStr}}</td>
                        <td>{{item.shelfTimeStr}}</td>
                        <td class="more-parent">
                            <div class="ui-operating" @click="modify(index)">编辑</div>
                            <div class="ui-split"></div>
                            <div class="ui-operating" v-if="item.shelfStatus != 3" @click="lowerShelf(index)">下架</div>
                            <div class="ui-operating" v-if="item.shelfStatus == 3" @click="upperShelf(index)">上架</div>
                            <div class="ui-split"></div>
                            <div class="ui-operating" @click="share(index)">分享</div>
                            <div class="ui-split"></div>
                            <div class="ui-operating" @click.stop="showMenu(index)">更多</div>
                            <div class="more-container" v-if="item.showMenu">
                                <div class="more-item" @click="showComments(index)">查看评论</div>
                                <div class="more-item" @click="remove(index)">删除</div>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="rows.length <= 0">
                        <td colspan="8" class="text-center">没有更多数据了...</td>
                    </tr>
                </tbody>
            </table>
            <div class="layui-row">
                <div class="layui-col-md6">
                    <div class="app-table-num"><span class="num">共 {{total}} 条</span><span class="comment">注：这里不显示专栏内容单品</span></div>
                </div>
                <div class="layui-col-md6 text-right">
                    <span class="prev" @click="loadPrev">上一页</span>
                    <span class="next" @click="loadNext">下一页</span>
                </div>
            </div>
        </div>
    </div>

    <#--添加时选择类型-->
    <div class="dialog-bg" v-show="showTypes"></div>
    <div class="dialog" v-show="showTypes">
        <div class="close" @click="closeDialog"><i class="fa fa-close"></i></div>
        <div class="text-center" style="margin-top:10px;">选择类型</div>
        <div class="layui-row">
            <div class="layui-col-md4 text-center" @click="addImageProduct">
                <div class="type"><i class="fa fa-image"></i></div>
                <div class="text">图文</div>
            </div>
            <div class="layui-col-md4 text-center" @click="addAudioProduct">
                <div class="type" style="background:#FF5722"><i class="fa fa-music"></i></div>
                <div class="text">音频</div>
            </div>
            <div class="layui-col-md4 text-center" @click="addVideoProduct">
                <div class="type" style="background:#1E9FFF;"><i class="fa fa-video-camera"></i></div>
                <div class="text">视频</div>
            </div>
        </div>
    </div>
</div>
<script>
    var app = new Vue({
        el: '#app',
        data: {
            showTypes: false,
            params: {
                name:'',
                shelfStatus: '',
                category: '',
                page: 1,
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
                $.http.post("${params.contextPath}/web/pmsProduct/list.json", this.params).then(function (data) {
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
            showType: function () {
                this.showTypes = true;
            },
            addImageProduct:function () {
                this.showTypes = false;
                DialogManager.open({url:'${params.contextPath!}/view/business/pmsProduct/pmsProduct_image_edit.htm', width:'90%', height:'100%', title:'添加图文单品'});
            },
            addAudioProduct:function () {
                this.showTypes = false;
                DialogManager.open({url:'${params.contextPath!}/view/business/pmsProduct/pmsProduct_audio_edit.htm', width:'90%', height:'100%', title:'添加音频单品'});
            },
            addVideoProduct:function () {
                this.showTypes = false;
                DialogManager.open({url:'${params.contextPath!}/view/business/pmsProduct/pmsProduct_video_edit.htm', width:'90%', height:'100%', title:'添加视频单品'});
            },
            modify: function (index) {
                var row = this.rows[index];
                var category = row.category;
                var url = {
                    1: '${params.contextPath!}/view/business/pmsProduct/pmsProduct_image_edit.htm?id=',
                    2: '${params.contextPath!}/view/business/pmsProduct/pmsProduct_audio_edit.htm?id=',
                    3: '${params.contextPath!}/view/business/pmsProduct/pmsProduct_video_edit.htm?id=',
                };
                DialogManager.open({url: url[category] + row.id, width: '90%', height: '100%', title: '编辑单品'});
            },
            closeDialog:function () {
                this.showTypes = false;
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
            lowerShelf:function (index) {//下架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsProduct/lowerShelf.json", {id: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            upperShelf:function (index) {//上架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsProduct/upperShelf.json", {id: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            share:function (index) {//分享
                alert("开发中");
            },
            remove:function (index) {//删除
                var that = this;
                $.http.post("${params.contextPath}/web/pmsProduct/delete.json", {ids: this.rows[index].id}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            showComments:function (index) {//查看评论
                alert("开发中");
            }
        }
    });
</script>
</body>

</html>
