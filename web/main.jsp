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
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/md5.js"></script>
        <script>
            var websocket = null;

            function sendData(obj) {
                console.log(websocket.readyState);
                if (websocket.readyState == 3) {
                    layerAler("通迅已断开");
                }
                if (websocket != null && websocket.readyState == 1) {
                    console.log(obj);
                    var datajson = JSON.stringify(obj);
                    websocket.send(datajson);
                }
            }
            
            function  getuserId(){
                var userid = $("#userid").val();
                return  userid;
            }
            
            //退出
            function getout() {
                if (confirm("确定退出吗？")) {
                    window.location = "${pageContext.request.contextPath }/login.jsp";
                }
            }
            
            //修改密码
            function  updatepwd(){
                var pwd = $("#pwd").val();
                var oldpwd = $("#oldPwd").val();
                var oldpwd2 = hex_md5(oldpwd);
                var newpwd = $("#newPwd").val();
                var okpwd = $("#okPwd").val();
                if(oldpwd==""){
                    layerAler("请输入原密码");
                    return;
                }
                if(newpwd==""){
                    layerAler("请输入新密码");
                    return;
                }
                if(okpwd==""){
                    layerAler("请确认密码");
                    return;
                }
                if(oldpwd2 != pwd){
                    layerAler("原密码不正确");
                    return;
                }
                
                if(newpwd != okpwd){
                    layerAler("确认密码不一致");
                    return;
                }
                
                var okpwd2 = hex_md5(okpwd);
                var obj = {};
                obj.password = okpwd2;
                obj.id = $("#userid").val();
                $.ajax({url: "login.usermanage.updatePwd.action", async: false, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            layerAler("修改成功");
                            window.location ="${pageContext.request.contextPath }/login.jsp";
                        }else{
                            layerAler("修改失败");
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });
               
            }



            $(function () {

                if ('WebSocket' in window) {
                    websocket = new WebSocket("ws://zhizhichun.eicp.net:18414/");
                } else {
                    alert('当前浏览器不支持websocket')
                }
//                // 连接成功建立的回调方法
                websocket.onopen = function (e) {

                }

                //接收到消息的回调方法
                websocket.onmessage = function (e) {
                    var info = JSON.parse(e.data);
                    console.log("main onmessage");
                    console.log(info);

                    if (info.hasOwnProperty("page")) {
                        console.log(info.page);
                        var obj = $("iframe").eq(0);
                        var win = obj[0].contentWindow;
                        if (info.page == 1) {
                            var func = info.function;
                            console.log(func);
                            win[func](info);
                        } else if (info.page == 2) {
                            win.callchild(info);
                        }
                    }


//                    if (jsoninfo.hasOwnProperty("function")) {
////                        var vvv = jsoninfo.function;
////                        var obj = jsoninfo.parama;
////                        obj.status = jsoninfo.status;
////                        obj.errcode = jsoninfo.errcode;
////                        obj.frame = jsoninfo.frame;
//
//                        if (win.hasOwnProperty("callchild")) {
//                            win.callchild(jsoninfo);
//                        }
//
//
//                        //window[vvv](obj);
//                    }

                }
                //连接关闭的回调方法
                websocket.onclose = function () {
                    console.log("websocket close");
                    websocket.close();
                }

                //连接发生错误的回调方法
                websocket.onerror = function () {
                    console.log("Webscoket连接发生错误");
                }

                //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
                window.onbeforeunload = function () {
                    websocket.close();
                }

            })



            function callback() {

                var obj = $("iframe").eq(0);
                var win = obj[0].contentWindow;
                if (win.hasOwnProperty("callchild")) {
                    var obj1 = {};
                    obj1.name = "aaa";
                    win.callchild(obj1);
                }

                //  console.log(win.isPrototypeOf("callchild"));
                //win.callchild(obj1);
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
                            <img src="img/alarm_s.png" class="alarmLi">
                            <div class="alarmNub alarmLi" id="alarmNumber">0</div>
                        </li>

                        <li class="one" style="width:74px;">

                            <i class="layui-icon indexIcon"></i>   
                            <!--<span class="glyphicon glyphicon-tags indexIcon"/>-->
                            <span class="Till" style="width: 74px; text-align: center; color: rgb(255, 255, 255);">语言</span>



                            <ul class="two animated fadeInDown language" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                <li language="zh_CN" id="chinese">中文</li>
                                <li language="en_US" id="english">英文</li>
                            </ul>
                        </li>
                        <li class="one" style="width:140px;">
                            <i class="layui-icon indexIcon"></i>  
                            <!--<span class="glyphicon glyphicon-user"></span>-->
                            <span class="Till" style="width: 140px; padding-left: 24px; box-sizing: border-box; color: rgb(255, 255, 255);">
                                <span class="admin" style="color: rgb(255, 255, 255);">${rs[0].name}</span>
                                <input id="m_code" type="hidden" value="${rs[0].m_code}"/>
                                <input id="pwd" type="hidden" value="${rs[0].password}"/>
                                <input id="userid" type="hidden" value="${rs[0].id}"/>
                            </span>
                            <ul class="two animated fadeInDown twoL" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                <li id="out" onclick="getout()">退出</li>
                                <li data-toggle="modal" data-target="#updpwdDiv" >修改密码</li>
                            </ul>
                        </li>
                    </ul> 
                </div>
                <input  id="names" value="" type="hidden">
                <!--<input id="configurations" value="[{&quot;title&quot;:&quot;参数配置&quot;,&quot;action&quot;:&quot;config/paramConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/paramConfiguration.png&quot;},{&quot;title&quot;:&quot;网关配置&quot;,&quot;action&quot;:&quot;config/gateway.action&quot;,&quot;icon&quot;:&quot;imgs/manager/gatewayConfiguration.png&quot;},{&quot;title&quot;:&quot;项目配置&quot;,&quot;action&quot;:&quot;config/alarmConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/alarmConfiguration.png&quot;}]" type="hidden">-->
                <iframe id="iframe" name="iframe" src="" seamless="" style="height: 886px;" width="100%" frameborder="0">
                </iframe>
            </div>
        </div>
        <div class="modal" id="updpwdDiv" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">修改密码</h4></div>    
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:35px;">原密码：</span>&nbsp;
                                            <input id="oldPwd" class="form-control" style="width:150px;display: inline;" placeholder="请输入原密码" type="password">
                                        </td>
                                    </tr>
                                     <tr>
                                        <td>
                                            <span style="margin-left:35px;">新密码：</span>&nbsp;
                                            <input id="newPwd" class="form-control" style="width:150px;display: inline;" placeholder="请输入原密码" type="password">
                                        </td>
                                    </tr>
                                     <tr>
                                        <td>
                                            <span style="margin-left:20px;">确定密码：</span>&nbsp;
                                            <input id="okPwd" class="form-control" style="width:150px;display: inline;" placeholder="请输入原密码" type="password">
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer" id="modal_footer_edit" >
                            <!-- 添加按钮 -->
                            <button id="xiugai" type="button" onclick="updatepwd()" class="btn btn-primary">修改</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    
                </div>
            </div>
        </div>

        <iframe id="alarmTable" src="abc.action_files/warningToday.htm" name="alarmTable" frameborder="0">
        </iframe>
        <script type="text/javascript">

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {
//                $(".alarmLi").click(function () {
//                    $("#alarmTable").css("display", "block");
//                    document.getElementById('alarmTable').contentWindow.document.location.reload();
//                });

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
                        console.log(iframesrc);
                        $("#iframe").attr("src", iframesrc);


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
                //传角色权限 获取菜单 
                var rotype =1;// $("#m_code").val(); //角色id
                var objrole = {role: rotype};
                var u_id = $("#userid").val(); //用户id
                var objrole = {role: rotype,uid:u_id};
                $.ajax({type: "post", url: "formuser.mainmenu.querysub.action", dataType: "json", data: objrole,
                    success: function (data) {
                        var htmls = '';
                        data = data2tree(data);

                        for (var i = 0; i < data.length; i++) {

                            var action = data[i].action;
                            if (data[i].children.length > 0) {
                                console.log(objrole);
                                
                                action = action + "?m_parent=" + data[i].code + "&role=" + objrole.role;
                            }


//                            if (data[i].children.length == 0) {
                            var lang = "zh_CN";
                            var obj = eval('(' + data[i].title + ')');
                            console.log(obj);
                            console.log(obj[lang]);
                            htmls += '<li class="eachMenu layui-nav-item" >'
                                    + '<a class="list listdisplayNone" href="javascript:;" name="' + action + '">'
                                    + '<span class="' + data[i].icon + '">' + '</span>'
                                    + '<span class="menuMessage" style=" padding-left: 3px;" >' + obj[lang] + '</span>'
                                    + '</a>'
                                    + '</li>';
                            if (data[i].code == 6) {
                            }
//                            } else {
//                            }         
                        }

                        $(".MenuBox").html(htmls);
                        $(".list:eq(0)").addClass("active");
                        var ifrsrc = $(".list:eq(0)").attr("name");
                        $("#iframe").attr("src", ifrsrc);
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
                var obj = {type: 1};
                function changeLanguage(language) {
                    console.log(language);
//                    var obj = obj;
//                    $.ajax({
//                        type: "post",
//                        url: "formuser.mainmenu.query.action",
//                        dataType: "json",
//                        data: obj,
//                        success: function (data) {
//                            $(".MenuBox").children('li').remove();
//                            var htmls = '';
//                            data = data2tree(data);
//                            console.log(data);
//                            for (var i = 0; i < data.length; i++) {
//                                if (data[i].children.length == 0) {
//                                    var lang = language;
//                                    var obj = eval('(' + data[i].title + ')');
//
//                                    htmls += '<li class="eachMenu layui-nav-item" >'
//                                            + '<a class="list listdisplayNone" href="javascript:;" name="' + data[i].action + '">'
//                                            + '<span class="' + data[i].icon + '">' + '</span>'
//                                            + '<span class="menuMessage" style=" padding-left: 3px;" >' + obj[lang] + '</span>'
//                                            + '</a>'
//                                            + '</li>';
//
//                                }
//                            }
//
//                            $(".MenuBox").html(htmls);
//                            $(".list:eq(0)").addClass("active");
//                            var ifrsrc = $(".list:eq(0)").attr("name");
//                            $("#iframe").attr("src", ifrsrc);
//                        }
//
//
//                    });

                }


            });

            $(function () {
                $(".navTop").delegate("li", "click", function () {
                    var html = $(this).attr('name');
                    //console.log(html);
                    // $("#iframe").attr('src', html);
                    //导航栏颜色
                });
            });

        </script>

    </body>
</html>
