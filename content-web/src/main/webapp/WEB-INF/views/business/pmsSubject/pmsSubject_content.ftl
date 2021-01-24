<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>单品列表</title>
    <#include "/common/vue_resource.ftl">
    <style>
        .subject-header .img{background-size:cover;border-radius:10px;background-repeat:no-repeat;}
        .subject-header > div{height:120px;vertical-align:top;}
    </style>
</head>
<body>
<div id="app" v-cloak>
    <div class="app-container" @click="hideMenu">
        <div class="layui-row layui-col-space20 subject-header" style="background-color:#F5F7FA;padding:20px;margin:0 15px;">
            <div class="layui-col-md2 img" v-if="record.coverPath" :style="{backgroundImage: 'url(${params.fileRequestUrl!}' + record.coverPath + ')' }"></div>
            <div class="layui-col-md2 img" v-if="!record.coverPath"></div>
            <div class="layui-col-md7" style="vertical-align:top;">
                <div style="font-size:16px;font-weight:bold;">{{record.name || ""}}</div>
                <div style="color:#f33;margin-top:20px;" v-if="record.priceStatus == 2">免费</div>
                <div style="color:#f33;margin-top:20px;" v-if="record.priceStatus == 1">￥ {{record.price || 0}}</div>
                <div style="margin-top:30px;">
                    订阅量：{{record.subscribeNum || 0}} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;点击量：{{record.clickNum}}
                </div>
            </div>
            <div class="layui-col-md3 text-right">
                <div class="more-parent">
                    <div class="ui-operating" @click="modifySubject()">编辑</div>
                    <div class="ui-split"></div>
                    <div class="ui-operating" v-if="record.shelfStatus != 3" @click="lowerSubjectShelf()">下架</div>
                    <div class="ui-operating" v-if="record.shelfStatus == 3" @click="upperSubjectShelf()">上架</div>
                    <div class="ui-split"></div>
                    <div class="ui-operating" @click.stop="showSubjectMenu()">更多</div>
                    <div class="more-container" style="top:26px;right:-5px;" v-if="showTopMenu">
                        <div class="more-item" @click="shareSubject()">分享</div>
                        <div class="more-item" v-if="record.overStatus == 1" @click="stopUpdate()">停止更新</div>
                        <div class="more-item" v-if="record.overStatus == 2" @click="updating()">更新中</div>
                        <div class="more-item" @click="removeSubject()">删除</div>
                    </div>
                </div>
                <div style="margin-top:70px;" v-if="record.overStatus == 1">更新至第{{record.updateNum}}期(更新中)</div>
                <div style="margin-top:70px;" v-if="record.overStatus == 2">已完结</div>
            </div>
        </div>
        <div class="layui-row app-header">
            <div class="layui-col-md3">
                <div class="layui-btn-group">
                    <button type="button" class="layui-btn layui-btn-sm" @click="showType">新建单品</button>
                    <button type="button" class="layui-btn layui-btn-sm" @click="showSelectProduct">选择已有单品</button>
                </div>
            </div>
            <div class="layui-col-md9 text-right">
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
                    <div class="app-table-num"><span class="num">单品列表(共 {{total}} 条)</span></div>
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
                    <th>试看</th>
                    <th>订阅量</th>
                    <th>访问数据</th>
                    <th>类别</th>
                    <th>排序</th>
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
                        <span class="ui-warn" v-if="item.tryStatus == 1">可试看</span>
                        <span class="ui-accept" v-if="item.tryStatus == 2">付费观看</span>
                    </td>
                    <td>{{item.subscribeNum}}</td>
                    <td>{{item.clickNum}}</td>
                    <td>{{item.categoryStr}}</td>
                    <td>
                        <span v-if="!item.isSort">{{item.sort}}</span>
                        <input v-if="item.isSort" type="text" class="layui-input" @keyup.enter="modifySort(index)" v-model="sortValue" style="width:100px;"/>
                    </td>
                    <td class="more-parent">
                        <div class="ui-operating" @click="showSort(index)">排序</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" v-if="item.tryStatus == 2" @click="modifyTry(index)">设为试看</div>
                        <div class="ui-operating" v-if="item.tryStatus == 1" @click="cancelTry(index)">取消试看</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click="modify(index)">编辑</div>
                        <div class="ui-split"></div>
                        <div class="ui-operating" @click.stop="showMenu(index)">更多</div>
                        <div class="more-container" v-if="item.showMenu">
                            <div class="more-item" @click="showComments(index)">查看评论</div>
                            <div class="more-item" @click="share(index)">分享</div>
                        </div>
                    </td>
                </tr>
                <tr v-if="rows.length <= 0">
                    <td colspan="7" class="text-center">没有更多数据了...</td>
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
                category: '',
                page: 1,
                subjectId:'${params.id!}',
            },
            record:{},
            rows: [],
            total: 0,
            showTopMenu:false,
            sortValue:0,
        },
        mounted: function () {
            this.loadSubject();
        },
        methods: {
            seachData: function () {
                this.params.page = 1;
                this.$nextTick(function () {
                    this.loadData();
                });
            },
            loadSubject: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsSubject/query.json", {id: "${params.id!}"}).then(function (data) {
                    if (!data.success) {
                        $.message(data.message);
                        return;
                    }
                    that.record = data.data;
                    that.loadData();
                });
            },
            loadData: function () {
                var that = this;
                $.http.post("${params.contextPath}/web/pmsProduct/subjectList.json", this.params).then(function (data) {
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
                location.href = "${params.contextPath!}/view/business/pmsProduct/subject_image_edit.htm?subjectId=" + this.params.subjectId;
            },
            addAudioProduct:function () {
                this.showTypes = false;
                location.href = "${params.contextPath!}/view/business/pmsProduct/subject_audio_edit.htm?subjectId=" + this.params.subjectId;
            },
            addVideoProduct:function () {
                this.showTypes = false;
                location.href = "${params.contextPath!}/view/business/pmsProduct/subject_video_edit.htm?subjectId=" + this.params.subjectId;
            },
            showSelectProduct: function () {
                var url = "${params.contextPath!}/view/business/pmsSubject/select_product_list.htm?subjectId=" + this.params.subjectId;
                DialogManager.open({url: url, width: '90%', height: '100%', title: '选择单品'});
            },
            modify: function (index) {
                var row = this.rows[index];
                var category = row.category;
                var url = {
                    1: '${params.contextPath!}/view/business/pmsProduct/subject_image_edit.htm?id=',
                    2: '${params.contextPath!}/view/business/pmsProduct/subject_audio_edit.htm?id=',
                    3: '${params.contextPath!}/view/business/pmsProduct/subject_video_edit.htm?id=',
                };
                location.href = url[category] + row.id;
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
                this.showTopMenu = false;
                this.rows.forEach(function (item) {
                    that.$set(item, 'showMenu', false);
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
            },
            lowerSubjectShelf:function () {//下架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsSubject/lowerShelf.json", {id: this.params.subjectId}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadSubject();
                    parent.app.loadData();
                });
            },
            upperSubjectShelf:function () {//上架
                var that = this;
                $.http.post("${params.contextPath}/web/pmsSubject/upperShelf.json", {id: this.params.subjectId}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadSubject();
                    parent.app.loadData();
                });
            },
            stopUpdate:function () {//停止更新
                var that = this;
                $.http.post("${params.contextPath}/web/pmsSubject/over.json", {id: this.params.subjectId}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadSubject();
                    parent.app.loadData();
                });
            },
            updating: function () {//更新中
                var that = this;
                $.http.post("${params.contextPath}/web/pmsSubject/unover.json", {id: this.params.subjectId}).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadSubject();
                    parent.app.loadData();
                });
            },
            modifySubject: function () {
                var url = "${params.contextPath!}/view/business/pmsSubject/pmsSubject_edit.htm?back=true&id=" + this.params.subjectId;
                location.href = url;
            },
            showSubjectMenu: function () {
                this.showTopMenu = true;
            },
            shareSubject: function () {
                alert("开发中");
            },
            removeSubject: function () {
                $.http.post("${params.contextPath}/web/pmsSubject/delete.json", {ids: this.params.subjectId}).then(function (data) {
                    if (!data.success) {
                        return;
                    }
                    var alt = layer.alert(data.message || "操作成功", function () {
                        parent.app.loadData();
                        parent.layer.closeAll();
                        layer.close(alt);
                    });
                });
            },
            showSort:function (index) {
                var sort = this.rows[index].sort;
                this.sortValue = sort;
                this.$set(this.rows[index], "isSort", true);
            },
            modifySort: function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/pmsProduct/modifySort.json", {
                    id: id,
                    sort: this.sortValue
                }).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.$set(that.rows[index], "isSort", false);
                    that.$set(that.rows[index], "sort", that.sortValue);
                });
            },
            modifyTry:function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/pmsProduct/setTry.json", {
                    id: id
                }).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            },
            cancelTry:function (index) {
                var that = this;
                var id = this.rows[index].id;
                $.http.post("${params.contextPath}/web/pmsProduct/cancelTry.json", {
                    id: id
                }).then(function (data) {
                    $.message(data.message);
                    if (!data.success) {
                        return;
                    }
                    that.loadData();
                });
            }
        }
    });
</script>
</body>

</html>
