<%-- 
    Document   : tab1
    Created on : 2018-8-6, 15:48:58
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="pragma" content="no-cache">
        <meta http-equiv="cache-control" content="no-cache"> 

        <title>参数配置</title>
        <link rel="stylesheet" type="text/css" href="layer/layui.css">
        <link rel="stylesheet" type="text/css" href="layer/subNavStyle.css">

        <link id="layuicss-laydate" rel="stylesheet" href="layer/laydate.css" media="all">
        <link id="layuicss-layer" rel="stylesheet" href="layer/layer.css" media="all">
        <link id="layuicss-skincodecss" rel="stylesheet" href="layer/code.css" media="all">
    </head>

    <body>
        <div class="contents">
            <div class="top" style=" height: 50px;" >
                <ul class="secondMenu layui-nav">
                    <li name="usermanage.jsp" class="layui-nav-item layui-this active"><a href="javascript:;">用户管理</a></li>
                    <li name="author.jsp" class="layui-nav-item"><a href="javascript:;">权限管理</a></li>


                    
                    <span class="layui-nav-bar" style="width: 0px; left: 484px; opacity: 0; top: 45px;"></span></ul>
            </div>
            <div  id="content-main" style="height: 878px;">
                <iframe class="J_iframe" name="iframe0" src="gateway.jsp"  seamless="" width="100%" height="100%" frameborder="0"></iframe>
            </div>
        </div>
        <!--<script type="text/javascript" src="abc_files/jquery.js"></script>-->
        <script type="text/javascript" src="layer/layui.js"></script>  

        <script>
            $(function () {
                /* 初始化加载三级菜单 */
                var htmlFirst = $(".secondMenu li:eq(0)").attr('name');
                $(".J_iframe").attr('src', htmlFirst);
                $(".secondMenu li:eq(0)").addClass("active").siblings("li").removeClass("active");
                /* 结束 */

                $(".secondMenu li").click(function () {
                    $(this).addClass("active").siblings("li").removeClass("active");
                    var html = $(this).attr('name');
                    $(".J_iframe").attr('src', html);
                })
                function size() {
                    var height = $(document.body).height() - 65;
                    $(".J_mainContent").height(height);
                }
                size();
                window.onresize = function () {
                    size();
                }
            })

        </script>
    </body>
</html>
