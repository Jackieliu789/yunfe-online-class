<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" href="${params.contextPath}/common/webupload/webuploader.css"/>
<script type="text/javascript" src="${params.contextPath}/common/webupload/webuploader.js"></script>
<script type="text/javascript">
    function UploadFile() {

        this._uploader;//当前WebUploader对象

        this.getWebUploader = function () {
            return this._uploader;
        };

        this.setHeader = function (object, data, headers) {
            var isIE = !!window.ActiveXObject;
            if (isIE) {
                headers['Access-Control-Allow-Origin'] = '*';
                headers['Access-Control-Request-Headers'] = 'content-type';
                headers['Access-Control-Request-Method'] = 'POST';
            }
        };

        this.init = function (_init_param_json) {
            var isIE = !!window.ActiveXObject;
            if (!WebUploader.Uploader.support("flash") && isIE) {
                layer.confirm("当前浏览器的flash版本过旧，请点击如下链接下载并安装<br/><a target='_blank' href='${params.contextPath}/resource/flashplayer_23_ax_debug_23.0.0.185.exe'>点击下载兼容的flash版本</a>", function () {
                    window.location.href = "${params.contextPath}/resource/flashplayer_23_ax_debug_23.0.0.185.exe";
                });
            }
            var _uploader_init = {
                swf: '${params.contextPath}/common/webupload/Uploader.swf',
                server: "${params.contextPath}/web/attachment/upload.json",
                renderId: "#select-file-button",
                renderLabel: "",
                fileVal: "files",
                resize: false,
                auto: true,
                //runtimeOrder:'flash',
                //fileNumLimit:3,
                fileSingleSizeLimit: 500 * 1024 * 1024,//500M
                //accept:null,
                /* accept:{
                    title:'Images',
                    extensions:'gif,jpg,jpeg,bmp,png',
                    mimeTypes:'image/*'
                } */
                formData: {},//自定义参数，初始化后用uploader.options.formData._t = new Date().getTime(); 调用
                remove: true,
                beforeFileQueued: function (uploader, file) {
                    return true;
                },
                uploadSuccess: function (file, data) {
                },
                error: function (type) {
                    $.message(type)
                }
            };
            var param_json = _init_param_json || {};
            _init_param_json.pick = {
                id: _init_param_json.renderId || _uploader_init.renderId,
                label: _init_param_json.renderLabel || _uploader_init.renderLabel
            };
            $.extend(_uploader_init, param_json);
            var _uploader = WebUploader.create(_uploader_init);
            _uploader.on('uploadBeforeSend ', this.setHeader);
            _uploader.on("beforeFileQueued", function (file) {
                if (file.size <= 0) {
                    $.message("该上传文件是空文件，无法上传");
                    return false;
                }
                var options = this.options;
                if (options.fileSingleSizeLimit &&
                        file.size > options.fileSingleSizeLimit) {
                    $.message("该上传文件的大小超过" + (options.fileSingleSizeLimit / (1024 * 1024)) + "M");
                    return false;
                }
                /*var array = file.name.split(".");
                var lastName = array[array.length - 1].toUpperCase();
                var lastNameArray = ['HTML', 'JS', 'EXE', 'JSP', 'JAR'];
                if (lastNameArray.indexOf(lastName) >= 0) {
                    layer.msg("上传图片的格式非法");
                    return false;
                }*/
                var params = options.formData;
                for (var key in  params) {
                    options.formData[key] = params[key];
                }
                //alert(JSON.stringify(_uploader.options.formData));
                var isSuccess = options.beforeFileQueued(_uploader, file);
                /*if (isSuccess && $(".op-upload-loading").length <= 0) {
                    $(_uploader_init.renderId).after("<img src='${resourceUrl!}plugins/layer/skin/default/loading-1.gif' class='op-upload-loading' style='width:30px;margin-left:10px;'/>");
                }*/
                if (isSuccess) {
                    $.loading();
                }
                return isSuccess;
            });
            _uploader.on("uploadSuccess", function (file, data) {
                var files = this.getFiles("progress");
                if (files.length <= 0) {
                    //$(".op-upload-loading").remove();
                    $.closeLoading();
                }
                if (this.options.remove) {
                    this.removeFile(file, true);
                }
                this.options.uploadSuccess(file, data);
            });
            _uploader.on("error", function (type) {
                this.options.error(type);
            });
            this._uploader = _uploader;
        };
    }

    var _upload_obj_cache = {};
    $.upload = function (_init_param_json) {
        var renderId = (_init_param_json.renderId || "#select-file-button").replace("#", "");
        var uploadFile = new UploadFile();
        uploadFile.init(_init_param_json);
        _upload_obj_cache[renderId] = uploadFile;
        return uploadFile;
    };
</script>