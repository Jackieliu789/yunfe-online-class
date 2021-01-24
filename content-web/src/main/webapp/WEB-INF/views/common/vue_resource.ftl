<#if params.faviconImagePath??>
    <link rel="shortcut icon" href="${params.fileRequestUrl!}${params.faviconImagePath!}" type="image/x-icon">
    <link rel="icon" href="${params.fileRequestUrl!}${params.faviconImagePath!}" type="image/x-icon">
</#if>

<link rel="stylesheet" href="${params.contextPath}/adminui/ui/global/font-awesome/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="https://www.layuicdn.com/layui-v2.5.6/css/layui.css"/>
<link rel="stylesheet" type="text/css" href="${params.contextPath}/css/vue-support.css"/>

<#--<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>-->
<script type="text/javascript" src="https://cdn.bootcdn.net/ajax/libs/vue/2.6.11/vue.min.js"></script>
<script type="text/javascript" src="https://cdn.bootcss.com/jquery/3.4.1/jquery.min.js"></script>
<#--<script type="text/javascript" src="https://unpkg.com/axios/dist/axios.min.js"></script>-->
<script type="text/javascript" src="https://cdn.bootcdn.net/ajax/libs/axios/0.19.2/axios.min.js"></script>
<#--<script type="text/javascript" src="https://www.layuicdn.com/layui-v2.5.6/layui.js"></script>-->
<script type="text/javascript" src="${params.contextPath}/common/layui/layui.all.js"></script>
<script type="text/javascript" src="${params.contextPath}/js/tools.js"></script>
<script type="text/javascript" src="${params.contextPath}/js/vue-support.js"></script>