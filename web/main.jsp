<%-- 
    Document   : newjsp
    Created on : 2018-8-6, 18:02:51
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link type="text/css" href="layer/layui.css" rel="stylesheet">
        <link type="text/css" href="layer/animate.css" rel="stylesheet">
        <link type="text/css" href="layer/indexNavigation.css" rel="stylesheet">
        <!--<script type="text/javascript" src="abc.action_files/jquery.js"></script>-->
        <!--<script type="text/javascript" src="abc.action_files/layui.js"> </script>-->
        <!--<link id="layuicss-laydate" rel="stylesheet" href="abc.action_files/laydate.css" media="all">-->
        <!--<link id="layuicss-layer" rel="stylesheet" href="abc.action_files/layer.css" media="all">-->
        <!--<link id="layuicss-skincodecss" rel="stylesheet" href="abc.action_files/code.css" media="all">-->
        <!--<script type="text/javascript" src="abc.action_files/utils.js"></script>-->
        <!--<script type="text/javascript" src="abc.action_files/ajaxUtils.js"></script>--> 

        <script>

            /**
             *  先把父亲节点取出来，放进一个数组dataArray
             * @param {Object} datas 所有数据
             */
            function data2tree(datas) {
                var dataArray = [];
                datas.forEach(function (data) {
                    var CATL_PARENT = data.m_parent;
                    if (CATL_PARENT == '0') {
                        var CATL_CODE = data.m_code;
                        var CATL_NAME = data.m_title;
                        var action = data.m_action;
                        var icon = data.m_icon;
                        var objTemp = {
                            parent: CATL_PARENT,
                            code: CATL_CODE,
                            title: CATL_NAME,
                            action: action,
                            icon: icon
                        }
                        dataArray.push(objTemp);
                    }
                });
                console.log(dataArray);
                return data2treeDG(datas, dataArray);
            }


            /**
             * 
             * @param {Object} datas  所有数据
             * @param {Object} dataArray 父节点组成的数组
             */
            function data2treeDG(datas, dataArray) {
                for (var j = 0; j < dataArray.length; j++) {
                    var dataArrayIndex = dataArray[j];
                    var childrenArray = [];
                    var CATL_CODEP = dataArrayIndex.code;

                    for (var i = 0; i < datas.length; i++) {
                        var data = datas[i];
                        var CATL_PARENT = data.m_parent;
                        if (CATL_PARENT == CATL_CODEP) {//判断是否为儿子节点
                            var CATL_CODE = data.m_code;
                            var CATL_NAME = data.m_title;
                            var action = data.m_action;
                            var icon = data.m_icon;
                            var objTemp = {
                                parent: CATL_PARENT,
                                code: CATL_CODE,
                                title: CATL_NAME,
                                action: action,
                                icon: icon
                            }
                            childrenArray.push(objTemp);
                        }

                    }
                    dataArrayIndex.children = childrenArray;
                    if (childrenArray.length > 0) {//有儿子节点则递归
                        data2treeDG(datas, childrenArray);
                    }

                }
                return dataArray;
            }
            //退出
            function getout() {
                if (confirm("确定退出吗？")) {
                    window.location = "${pageContext.request.contextPath }/login.jsp";
                }
            }



        </script>

    </head>
    <body>
        <div class="wraper"> 
            <div class="bodyLeft" style="background: rgb(14, 98, 199) none repeat scroll 0% 0%;">
                <div class="bodyLeftTop listdisplayNone" style="background: rgb(92, 183, 92) none repeat scroll 0% 0%">
                    <span class="menuMessage" style="width:80px;margin-left:30px;">智慧照明</span>
                </div>
                <ul class="layui-nav layui-nav-tree layui-nav-side MenuBox ">
                    <!--                    
                                        <li class="layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                    
                    
                                            <a class="list listdisplayNone active" name="mainsub.jsp">
                                                <i class=yui-icon-home"></i>"layui-icon layui-icon-home"></i>
                                                <span class="menuMessage">综合首页</span>
                    
                                            </a>
                                        </li>
                                        <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                            <a class="list listdisplayNone" href="javascript:;" name="lightTab.jsp"><span class="menuMessage">照明控制</span></a>
                                        </li>
                                        <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                            <a class="list listdisplayNone" href="javascript:;" name="map.jsp"><span class="menuMessage">地图导航</span></a>
                                        </li>
                                          <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                                 <a class="list listdisplayNone" href="javascript:;" name="strategyTab.jsp"><span class="menuMessage">策略管理</span></a>
                                             </li>                   
                                             <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                                 <a class="list listdisplayNone" href="javascript:;" name="reporttab.jsp"><span class="menuMessage">报表管理</span></a>
                                             </li>                   
                                             <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                                 <a class="list listdisplayNone" href="javascript:;" name="devicetab.jsp"><span class="menuMessage">设备管理</span></a>
                                             </li>
                                             <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                                 <a class="list listdisplayNone" href="javascript:;" name="warntab.jsp"><span class="menuMessage">参数设置</span></a>
                                             </li>         
                                             <li class="eachMenu layui-nav-item" style="background: rgb(66, 72, 91) none repeat scroll 0% 0%;">
                                                 <a class="list listdisplayNone" href="javascript:;" name="authortab.jsp"><span class="menuMessage">权限管理</span></a>
                                             </li>             -->
                </ul>
            </div>

            <div class="bodyRight" style="padding-left: 140px;">
                <div id="navTop" style="width: 100%; height: 60px; border-bottom: 0px solid rgb(204, 204, 204); background: rgb(92, 183, 92) none repeat scroll 0% 0%">
                    <div class="CCIOT-logo" style="display:none;height:60px;float:left;padding-top:7px;padding-left:15px;box-sizing:border-box;">
                        <img src="abc.action_files/sz-tit.png" style="min-width:50px;height:50px;float:left;" id="logoImg">
                    </div>
                    <ul class="navTop" style="left: 200px; display: none;">
                        <!-- 首页顶部导航 -->
                        <li title="照明" name="abc/device.action" style="background:url(&quot;imgs/indexNav/2.png&quot;)"></li>
                        <li title="地图" name="abc/map.action" style="background:url(&quot;imgs/indexNav/3.png&quot;)"></li>
                    </ul>
                    <ul class="controlMessage animated fadeInRight">
                        <li class="one imgM Home" style="display: none;">
                            <img alt="" src="abc.action_files/home_s.png" style="height:21px;width:21px;margin-top:2px;">
                        </li>
                        <li class="one imgM">
                            <img src="abc.action_files/alarm_s.png" class="alarmLi">
                            <div class="alarmNub alarmLi" id="alarmNumber">0</div>
                        </li>
                        <!--                        <li class="one setName" style="width: 74px; display: block;">
                                                    <i class="layui-icon indexIcon"></i>   
                                                    <span class="Till" style="width: 74px; text-align: center; color: rgb(255, 255, 255);">配置</span>
                                                    <ul class="two animated fadeInDown language setMenu" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                        
                                                        <li action="config/paramConfig.action">参数配置</li><li action="config/gateway.action">网关配置</li>
                                                        <li action="config/alarmConfig.action">项目配置</li>
                                                    </ul>
                                                </li>-->
                        <li class="one" style="width:74px;">
                            <i class="layui-icon indexIcon"></i>   
                            <span class="Till" style="width: 74px; text-align: center; color: rgb(255, 255, 255);">语言</span>
                            <ul class="two animated fadeInDown language" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                <li language="zh_CN" id="chinese">中文</li>
                                <li language="en_US" id="english">英文</li>
                            </ul>
                        </li>
                        <!--                        <li class="one themeItem" style="width:74px;">
                                                    <i class="layui-icon indexIcon"></i>   
                                                    <span class="Till" style="width: 74px; text-align: center; color: rgb(255, 255, 255);">主题</span>
                                                    <ul class="two animated fadeInDown abcStyle" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                                        <li class="classic">经典</li>
                                                        <li class="ocean">海洋</li>
                                                        <li class="green">翡翠</li>
                                                    </ul>
                                                </li>-->
                        <li class="one" style="width:140px;">
                            <i class="layui-icon indexIcon"></i>  
                            <span class="Till" style="width: 140px; padding-left: 24px; box-sizing: border-box; color: rgb(255, 255, 255);">
                                <span class="admin" style="color: rgb(255, 255, 255);">${rs[0].name}</span>
                            </span>
                            <ul class="two animated fadeInDown twoL" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                <li id="out" onclick="getout()">退出</li>
                                <li style="display:none;">修改密码</li>
                            </ul>
                        </li>
                    </ul> 
                </div>
                <input  id="names" value="" type="hidden">
                <!--<input id="configurations" value="[{&quot;title&quot;:&quot;参数配置&quot;,&quot;action&quot;:&quot;config/paramConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/paramConfiguration.png&quot;},{&quot;title&quot;:&quot;网关配置&quot;,&quot;action&quot;:&quot;config/gateway.action&quot;,&quot;icon&quot;:&quot;imgs/manager/gatewayConfiguration.png&quot;},{&quot;title&quot;:&quot;项目配置&quot;,&quot;action&quot;:&quot;config/alarmConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/alarmConfiguration.png&quot;}]" type="hidden">-->
                <iframe id="iframe" src="" seamless="" style="height: 886px;" width="100%" frameborder="0">
                </iframe>
            </div>
        </div>

        <iframe id="alarmTable" src="abc.action_files/warningToday.htm" name="alarmTable" frameborder="0">
        </iframe>
        <script type="text/javascript">
            $(function () {
                $(".alarmLi").click(function () {
                    $("#alarmTable").css("display", "block");
                    document.getElementById('alarmTable').contentWindow.document.location.reload();
                });

                $("body").delegate(".list", "click", function () {
                    if ($(this).siblings(".secondMenu").length != 0) {
                        if ($(this).parent(".eachMenuSmaller").length == 0) {
                            if ($(this).siblings(".secondMenu").css("display") == "block") {
                                $(this).siblings(".secondMenu").css("display", "none");
                                $(this).parent().removeClass('layui-nav-itemed');
                            } else {
                                $(this).siblings(".secondMenu").css("display", "block");
                                $(this).parent().addClass('layui-nav-itemed');
                            }
                        } else {
                        }
                    } else {
                        $(this).addClass("active");
                        $(this).parent(".eachMenu").siblings(".eachMenu").children(".list").removeClass("active");
                        $(this).parent(".eachMenu").siblings(".eachMenu").children(".secondMenu").children(".secondMenuList").removeClass("active");
                        var iframesrc = $(this).attr("name");
                        $("#iframe").attr("src", iframesrc);
                        var _this = $('#navTop');
                        actionColor(iframesrc, _this);
                    }
                });

                $("body").delegate(".secondMenu .secondMenuList", "click", function () {
                    $(this).addClass("active");
                    $(this).parent(".secondMenu").siblings(".list").addClass("active");
                    $(this).siblings(".secondMenuList").removeClass("active");
                    $(this).parent(".secondMenu").parent(".eachMenu").siblings(".eachMenu").children(".list").removeClass("active");
                    $(this).parent(".secondMenu").parent(".eachMenu").siblings(".eachMenu").children(".secondMenu").children(".secondMenuList").removeClass("active");
                    var iframesrc = $(this).attr("name");
                    $("#iframe").attr("src", iframesrc);
                    var _this = $('#navTop');
                    actionColor(iframesrc, _this);
                });

                function size() {
                    var iframeHeight = $(window).height() - 57;
                    $("#iframe").css("height", iframeHeight);
                }
                size();
                window.onresize = function () {
                    size();
                }

                /*  登录注销   */
                /*	CCIOT
                 **针对于地球仪首页点击返回的逻辑
                 */
                $(".Home").click(function () {
                    $("#iframe").attr("src", "abc/homeIntelligent.action");
                    changeColor("#071519");
                })

                /* 登录注销 */
                $(".twoL li:eq(0)").click(function () {
                    doPostRequest({}, "user/userLogout.action", function (retult) {
                        layer.alert('注销成功!', {icon: 4, offset: 'center'});
                        window.top.location.href = "forward.jsp";
                    },
                            function (error) {
                                alert(error.message);
                            });
                })
                /* 加载左边菜单 */

                $.ajax({
                    type: "post",
                    url: "formuser.mainmenu.query.action",
                    dataType: "json",
                    data: {m_type: 0},
                    success: function (data) {
                        var htmls = '';
                        var isIntelligentLampPoleProject = "4";
                        data = data2tree(data);
                        for (var i = 0; i < data.length; i++) {
                            if (data[i].children.length == 0) {
                                var lang = "zh_CN";
                                var obj = eval('(' + data[i].title + ')');
                                console.log(obj);
                                console.log(obj[lang]);
                                htmls += '<li class="eachMenu layui-nav-item" >'
                                        + '<a class="list listdisplayNone" href="javascript:;" name="' + data[i].action + '">'
                                        + '<span class="' + data[i].icon + '">' + '</span>'
                                        + '<span class="menuMessage" style=" padding-left: 3px;" >' + obj[lang] + '</span>'
                                        + '</a>'
                                        + '</li>';
                                if (data[i].code == 6) {
//                                        names[names.length] = {title: data[i].title, code: data[i].code};
                                    //显示首页顶部导航中的图标
                                    /* $(".navTop").append('<li title="' + data[i].children[j].title +'" name="' + data[i].children[j].action 
                                     +'" style=background:url("imgs/indexNav/' + data[i].children[j].code + '.png")></li>'); */
                                }
                            } else {
//                                    htmls += '<li class="eachMenu layui-nav-item" >'
//                                            + '<a class="list listdisplayNone" href="javascript:;" name="' + data[i].action + '">'
//                                            /*     							 +			'<img src="'+data[i].icon+'"/>' */
//                                            + '<span class="menuMessage">' + data[i].title + '</span>'
//                                            + '<span class="layui-nav-more"></span>'
//                                            + '</a>'
//                                            + '<dl class="secondMenu layui-nav-child">';
//                                    for (var j = 0; j < data[i].children.length; j++) {
//                                        htmls += '<dd class="secondMenuList" name="' + data[i].children[j].action + '"><a href="javascript:;">' + data[i].children[j].title + '</a></dd>';
//                                        if (data[i].code == 5) {
//                                            if (2 != -1) {
//                                                isIntelligentLampPoleProject = true;
//                                            }
//                                            if (data[i].children.length == 2) {
//                                                if (data[i].children[0].code == '5b' && data[i].children[1].code == '5c') {
//                                                    isIntelligentLampPoleProject = false;
//                                                }
//                                            }
//                                            names[j] = {title: data[i].children[j].title, code: data[i].children[j].code};
//                                            //显示首页顶部导航中的图标
//                                            $(".navTop").append('<li title="' + data[i].children[j].title + '" name="' + data[i].children[j].action
//                                                    + '" style=background:url("imgs/indexNav/' + data[i].children[j].code + '.png")></li>');
//                                        } else if (data[i].code == 4) {
//                                            configurations[j] = {title: data[i].children[j].title, action: data[i].children[j].action, icon: data[i].children[j].icon};
//                                        }
//                                    }
//                                    htmls += '</dl></li>';
                            }

//                                if (data[i].code == 2) {//显示首页顶部导航中的“照明”图标
//                                    $(".navTop").append('<li title="' + data[i].title + '" name="' + data[i].action + '" style=background:url("imgs/indexNav/' + data[i].code + '.png")></li>');
//                                }
//                                if (data[i].code == 3) {//显示首页顶部导航中的“地图”图标
//                                    $(".navTop").append('<li title="' + data[i].title + '" name="' + data[i].action + '" style=background:url("imgs/indexNav/' + data[i].code + '.png")></li>');
//                                }           
                        }

//                        console.log(htmls)
                        /*
                         **是否是智慧灯杆项目
                         **isIntelligentLampPoleProject
                         */
//                        if (isIntelligentLampPoleProject) {
//                            $(".bodyRight").css("padding-left", "0px");
//                            htmls = '<li class="eachMenu layui-nav-item" >'
//                                    + '<a class="list listdisplayNone" name="abc/homeIntelligent.action">'
//                                    /*                          +          '<img src="imgs/index/home.png"/>' */
//                                    + '<span class="menuMessage">首页</span>'
//                                    + '</a>'
//                                    + '</li>' + htmls;
//                            $(".themeItem").css("display", "none");
//                        } else {

//                            $(".bodyRight").css("padding-left", "140px");
//                            $(".bodyLeft").css("display", "");
//                            $(".navTop").css("left", "200px");//顶部导航
//                            $("#changeSize").css("display", 'none');
//                            $(".Home").css("display", 'none');
//                            

//                            if (includesHome) {
//                                htmls = '<li class="eachMenu layui-nav-item" >'
//                                        + '<a class="list listdisplayNone" name="abc/home.action">'
//                                        /*                              +          '<img src="imgs/index/home.png"/>' */
//                                        + '<span class="menuMessage">首页</span>'
//                                        + '</a>'
//                                        + '</li>' + htmls;
//                            }
                        //initTheme(); //初始化主题

//                        }


//                        if (names.length != 0) {
//                            $("#names").val(JSON.stringify(names));
//                        }
//                        if (configurations.length != 0) {
//                            $("#configurations").val(JSON.stringify(configurations));
//                        }



                        $(".MenuBox").html(htmls);
                        $(".list:eq(0)").addClass("active");
                        var ifrsrc = $(".list:eq(0)").attr("name");
                        $("#iframe").attr("src", ifrsrc);

//                        var user = false;
//                        if (user && ($("#iframe").attr("src") == 'abc/homeIntelligent.action')) {								//针对于地球平台logo
//                            $(".CCIOT-logo").css('display', '');
//                            var logoWidth = $(".CCIOT-logo img").width() + 20;
//                            $(".navTop").css("left", logoWidth);
//                        }


//                        var navStand = $("#iframe").attr("src");
//                        if (navStand == 'abc/home.action') {		   //针对于root权限的顶部背景
//                            $('.navTop').css("display", "none");
//                            $("#changeSize").css("display", "none");
//                            initTheme(); //初始化主题
//                        } else if (navStand == 'abc/device.action') {//针对于照明平台初始化导航栏变色
//                            initTheme(); //初始化主题
//                        }

//                        var _configurations = $('#configurations').val();
//                        if (_configurations != '') {
//                            $(".setName").css("display", "block");
//                            var configurationsObj = JSON.parse(_configurations);
//                            $.each(configurationsObj, function (i, item) {
//                                var li = $('<li action="' + item.action + '">' + item.title + '</li>');
//                                $(".setMenu").append(li);
//                                li.click(function () {
//                                    $('#iframe').attr("src", $(this).attr('action'));
//                                    $(".navCon").hide();
//                                    $(".logo").hide();
//                                });
//                            });
//                        }
                    }


                });




                $(".language li:eq(0)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                });
                $(".language li:eq(1)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                });

                //语言切换
                function changeLanguage(language) {
                    console.log(language);
                    var obj = {m_type: 0};
                    $.ajax({
                        type: "post",
                        url: "formuser.mainmenu.query.action",
                        dataType: "json",
                        data: obj,
                        success: function (data) {
                            $(".MenuBox").children('li').remove();
                            var htmls = '';
                            data = data2tree(data);
                            for (var i = 0; i < data.length; i++) {
                                if (data[i].children.length == 0) {
                                    var lang = language;
                                    var obj = eval('(' + data[i].title + ')');

                                    htmls += '<li class="eachMenu layui-nav-item" >'
                                            + '<a class="list listdisplayNone" href="javascript:;" name="' + data[i].action + '">'
                                            + '<span class="' + data[i].icon + '">' + '</span>'
                                            + '<span class="menuMessage" style=" padding-left: 3px;" >' + obj[lang] + '</span>'
                                            + '</a>'
                                            + '</li>';

                                }
                            }

                            $(".MenuBox").html(htmls);
                            $(".list:eq(0)").addClass("active");
                            var ifrsrc = $(".list:eq(0)").attr("name");
                            $("#iframe").attr("src", ifrsrc);
                        }


                    });

                }


            });
            $(function () {
                $(".navTop").delegate("li", "click", function () {
                    var html = $(this).attr('name');
                    $("#iframe").attr('src', html);
                    //导航栏颜色
                    var standSrc = $("#iframe").attr("src");
                    if (standSrc == 'abc/homeIntelligent.action') {
                        changeColor('#0E122D');
                    } else {
                        changeColor('#0E122D');
                    }
                });
            });
            function changeColor(color) {
                $("#navTop").css("background", color);
            }

            function themeColor(theme) {
                $("#navTop").css("background", theme[0]);
                $('.controlMessage span').css("color", theme[1]);
                $(".controlMessage .two").css({
                    "background": theme[0],
                    "color": theme[1]
                });
                $(".bodyLeftTop").css("background", theme[2]);
                $(".bodyLeft").css("background", theme[3]);
                $(".eachMenu").css("background", theme[4]);
            }
            //切换页面设置相应背景色
            function actionColor(src, $this) {
                var themeName = localStorage.getItem('theme');
                var deepColor = ['abc/device.action', 'forward/ledProgramSetUp.action', 'forward/videoRightSetUp.action', 'deviceChargingPile.action', 'forward/meteorologicalSensorSetUp.action', 'forward/keyAlarmSetUp.action', 'forward/loudSpeakerSetUp2.action', 'forward/wifitApSetUp.action', 'forward/ledProgramSetUp2.action', 'forward/direct_con_magne.action', 'forward/direct_con_smoke_detec.action'];
                for (var i = 0; i < deepColor.length; i++) {
                    if (src == deepColor[i]) {
                        $this.css('background', '#0E122D');
                        return;
                    } else {
                        changeTheme(themeName);
                    }
                }
            }
            function initTheme() {
                var getItem = localStorage.getItem('theme');
                if (getItem != undefined) {
                    changeTheme(getItem);
                } else {
                    localStorage.setItem('theme', 'classic');
                    changeTheme('classic');
                }
            }
        </script>

    </body>
</html>
