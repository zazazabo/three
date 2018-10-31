
<%-- 
   Document   : newjsp
   Created on : 2018-8-6, 18:02:51
   Author     : Administrator
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tld/fn.tld" prefix="fn" %>
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
        <script type="text/javascript"  src="js/getdate.js"></script>
        <style>
            .menuMessage{
                padding-left: 5px;
            }
        </style>
        <script>
            var eventobj = {
                "ERC44": {
                    "status1": {
                        "0": "灯具故障",
                        "1": "温度故障",
                        "2": "超负荷故障",
                        "3": "功率因数过低故障",
                        "4": "时钟故障",
                        "5": "",
                        "6": "灯珠故障",
                        "7": "电源故障"
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC43": {
                    "status1": {
                        "0": "灯杆倾斜",
                        "1": "",
                        "2": "温度预警",
                        "3": "漏电流预警",
                        "4": "相位不符",
                        "5": "线路不符",
                        "6": "台区不符",
                        "7": "使用寿命到期"
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC46": {
                    "status1": {
                        "0": "A相超限",
                        "1": "B相超限",
                        "2": "C相超限",
                        "3": "A相过载",
                        "4": "A相欠载",
                        "5": "B相过载",
                        "6": "B相欠载",
                        "7": "C相过载"
                    },
                    "status2": {
                        "0": "C相欠载",
                        "1": "A相功率因数过低",
                        "2": "B相功率因数过低",
                        "3": "C相功率因数过低",
                        "4": "D相功率因数过低",
                        "5": "",
                        "6": "",
                        "7": ""
                    }
                },
                "ERC47": {
                    "status1": {
                        "0": "配电箱后门开",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC48": {
                    "status1": {
                        "0": "PM2.5设备通信故障",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }

                },
                "ERC51": {
                    "status1": {
                        "0": "线路负荷突增",
                        "1": "线路缺相",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }

                }
            };
            var o = {};
            var lang = getCookie("lang");
            var websocket = null;
            var conectstr = "ws://103.46.128.47:18414/";
            var timestamp = 0;
            function sendData(obj) {

                console.log("通信状态:", websocket.readyState);
                if (websocket.readyState == 3) {

                    layer.confirm("通迅已断开,重连吗?", {//确认要删除吗？
                        btn: [o[146][lang], o[147][lang]] //确定、取消按钮
                    }, function (index) {
                        websocket = new WebSocket(conectstr);
                        // 连接成功建立的回调方法

                        // 连接成功建立的回调方法
                        websocket.onopen = onopen;
                        //接收到消息的回调方法
                        websocket.onmessage = onmessage;
                        //连接关闭的回调方法
                        websocket.onclose = onclose;
                        //连接发生错误的回调方法
                        websocket.onerror = onerror;
                        //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
                        window.onbeforeunload = onbeforeunload;

                        layer.close(index);
                        //此处请求后台程序，下方是成功后的前台处理……
                    });
                }
                if (websocket != null && websocket.readyState == 1) {

                    //delete obj.msg;
                    if (timestamp == 0) {
                        timestamp = (new Date()).valueOf();
                        console.log(obj);
                        var datajson = JSON.stringify(obj);
                        websocket.send(datajson);

                    } else {
                        var timestamptemp = (new Date()).valueOf();
                        console.log(timestamp, timestamptemp);
                        if ((timestamptemp - timestamp) / 1000 < 1) {
                            //layerAler("请不要连续发送");
                        } else {
                            timestamp = timestamptemp;
                            console.log(obj);
                            var datajson = JSON.stringify(obj);
                            websocket.send(datajson);
                        }
                    }


                }
            }

            function  getuserId() {
                var userid = $("#userid").val();
                return  userid;
            }

            function getpojectId() {
                var pojectid = $("#pojects").val();
                return  pojectid;
            }

            function  getusername() {
                var name = $("#u_name").text();
                return name;
            }

            function  getupid() {
                var upid = $("#upid").val();
                return upid;
            }

            //退出
            function getout() {
                layer.confirm(o[282][lang], {//确认要删除吗？
                    btn: [o[146][lang], o[147][lang]]//确定、取消按钮
                }, function (index) {
                    window.location = "${pageContext.request.contextPath }/login.jsp";
                    var nobj = {};
                    var name = $("#u_name").text();
                    nobj.name = name;
                    var day = getNowFormatDate2();
                    nobj.time = day;
                    nobj.type = "退出系统";
                    nobj.pid = $("#upid").val();
                    nobj.page = "首页";
                    $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {

                            }
                        }
                    });

                    layer.close(index);

                });


            }

            //修改密码
            function  updatepwd() {
                var pwd = $("#pwd").val();
                var oldpwd = $("#oldPwd").val();
                var oldpwd2 = hex_md5(oldpwd);
                var newpwd = $("#newPwd").val();
                var okpwd = $("#okPwd").val();
                if (oldpwd == "") {
                    layerAler(o[276][lang]);  //请输入原密码
                    return;
                }
                if (newpwd == "") {
                    layerAler(o[277][lang]);  //请输入新密码
                    return;
                }
                if (okpwd == "") {
                    layerAler(o[278][lang]);  //请确认密码
                    return;
                }
                if (oldpwd2 != pwd) {
                    layerAler(o[279][lang]);  //原密码不正确
                    return;
                }

                if (newpwd != okpwd) {
                    layerAler(o[280][lang]);  //密码不一致
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
                            layerAler(o[143][lang]); //修改成功
                            window.location = "${pageContext.request.contextPath }/login.jsp";
                        } else {
                            layerAler(o[281][lang]);  //修改失败
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });

            }

            //查看警异常信息总数
            function fualtCount() {
                var pid = $("#pojects").val();
                var obj = {};
                obj.pid = pid;
                //obj.f_day = d.toLocaleDateString();
                $.ajax({url: "login.main.fualtCount.action", async: false, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        if (data.rs[0].number == 0) {
                            $("#alarmNumber").html("0");
                            $("#alarmNumber").css("color", "white");
                        } else {
                            $("#alarmNumber").html(data.rs[0].number);
                            $("#alarmNumber").css("color", "red");

                        }
                    },
                    error: function () {
                        alert("出现异常！");
                    }
                });
            }

            function callback() {

                var obj = $("iframe").eq(0);
                var win = obj[0].contentWindow;
                if (win.hasOwnProperty("callchild")) {
                    var obj1 = {};
                    obj1.name = "aaa";
                    win.callchild(obj1);
                }
            }
            //点击告警信息
            function imgM() {
                $("#faultDiv").modal("show");
                var pid = $("#pojects").val();
                var obj = {};
                obj.pid = pid;
                var opt = {
                    method: "post",
                    contentType: "application/x-www-form-urlencoded",
                    url: "login.main.faultInfo.action",
                    silent: true,
                    query: obj
                };
                $("#fauttable").bootstrapTable('refresh', opt);

            }

            //获取语言
            function getLnas() {
                return o;
            }

            function onopen(e) {
            }
            function onmessage(e) {
                var info = eval('(' + e.data + ')');
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
            }

            function onclose(e) {
                console.log(e);
                console.log("websocket close");
                websocket.close();
            }
            function  onerror(e) {
                console.log("Webscoket连接发生错误");
            }
            function onbeforeunload(e) {
                websocket.close();
            }
            $(function () {

            <c:forEach items="${lans}" var="t" varStatus="i">
                var id =${t.id};
                var zh_CN1 = "${empty t.zh_CN?"":t.zh_CN}";
                var en_US1 = "${empty t.en_US?"":t.en_US}";
                var e_BY1 = "${empty t.e_BY?"":t.e_BY}";

                o[id] = {zh_CN: zh_CN1, en_US: en_US1, e_BY: e_BY1};
            </c:forEach>
                //  console.log(o);
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(o[e][lang]);
                }
                var bbb = $("label[name=xxx]");
                for (var i = 0; i < bbb.length; i++) {
                    var d = bbb[i];
                    var e = $(d).attr("id");
                    $(d).html(o[e][lang]);
                }



            <c:if test="${empty param.id }">
                window.location = "${pageContext.request.contextPath }/login.jsp";
                return;
            </c:if>

                if ('WebSocket' in window) {
                    websocket = new WebSocket(conectstr);
//                    websocket = new WebSocket("ws://localhost:5050/");
                } else {
                    alert('当前浏览器不支持websocket');
                }
                // 连接成功建立的回调方法
                websocket.onopen = onopen;
                //接收到消息的回调方法
                websocket.onmessage = onmessage;
                //连接关闭的回调方法
                websocket.onclose = onclose;
                //连接发生错误的回调方法
                websocket.onerror = onerror;
                //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
                window.onbeforeunload = onbeforeunload;
            });
        </script>
    </head>
    <body>

        <div class="wraper"> 
            <div class="bodyLeft" style="background: rgb(14, 98, 199) none repeat scroll 0% 0%;">
                <div class="bodyLeftTop listdisplayNone" style="background:#5cb75c ">
                    <span  style="width:80px;margin-left:30px;"><label name="xxx" id="275">智慧城市照明管理系统</label></span>
                </div>

                <ul class="layui-nav layui-nav-tree  MenuBox " >
                    <c:forEach items="${menulist}" var="t" varStatus="i">
                        <c:if test="${t.m_parent==0}">
                            <c:if test="${i.index==0}">
                                <li class="eachMenu layui-nav-item">
                                    <a class="list listdisplayNone active" href="javascript:;" name="${t.m_action}?m_parent=${t.m_code}&role=${t.roletype}&lang=${empty cookie.lang.value?"zh_CN":cookie.lang.value}">
                                        <span class="${t.m_icon}"></span>
                                        <span class="menuMessage" >
                                            <script>
                                                var temp =${t.m_title};
                                                var lan = "${empty cookie.lang.value?"zh_CN":cookie.lang.value}";
                                                document.write(temp[lan]);
                                            </script>

                                        </span>
                                    </a>
                                </li>         
                            </c:if>
                            <c:if test="${i.index>0}">  
                                <li class="eachMenu layui-nav-item">
                                    <a class="list listdisplayNone" href="javascript:;" name="${t.m_action}?m_parent=${t.m_code}&role=${t.roletype}&lang=${empty cookie.lang.value?"zh_CN":cookie.lang.value}">
                                        <span class="${t.m_icon}"></span>
                                        <span class="menuMessage" >
                                            <script>
                                                var temp =${t.m_title};
                                                var lan = "${empty cookie.lang.value?"zh_CN":cookie.lang.value}";
                                                document.write(temp[lan]);
                                            </script>
                                        </span>
                                    </a>
                                </li>
                            </c:if>
                        </c:if>

                    </c:forEach>
                </ul>
            </div>

            <div class="bodyRight" style="padding-left: 140px;">
                <div id="navTop" style="width: 100%; height: 60px; border-bottom: 0px solid rgb(204, 204, 204); background: rgb(92, 183, 92) none repeat scroll 0% 0%">
                    <div class="CCIOT-logo" style="display:none;height:60px;float:left;padding-top:7px;padding-left:15px;box-sizing:border-box;">
                        <img src="abc.action_files/sz-tit.png" style="min-width:50px;height:50px;float:left;" id="logoImg">
                    </div>
                    <ul class="controlMessage animated fadeInRight">
                        <li class="one">
                            <span id="1" name="xxx">项目</span>&nbsp;&nbsp;
                            <select style="width: 200px; height: 30px; margin-top:0px; font-size: 16px; border: 1px solid;" id="pojects">

                            </select>
                        </li>
                        <li class="one imgM" id ="imgM" onclick="imgM()" title="告警信息">
                            <img src="img/xx.png" class="alarmLi">
                            <div class="alarmNub alarmLi" id="alarmNumber">0</div>
                        </li>

                        <li class="one" style="width:74px;">

                            <i class="layui-icon  indexIcon"></i>   
                            <!--                            <span class="glyphicon glyphicon-tags indexIcon"/>-->
                            <span class="Till" style="width: 74px; text-align: center; color: rgb(255, 255, 255);" name="xxx" id="2">语言</span>



                            <ul class="two animated fadeInDown language" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                <li language="zh_CN"><label name="xxx" id="268">中文</label></li>
                                <li language="en_US"><label name="xxx" id="269">英文</label></li>
                                <li language="e_BY"><label  name="xxx" id="270">俄文</label></li>
                            </ul>
                        </li>
                        <li class="one" style=" margin-right: 10px;">
                            <i class="layui-icon indexIcon"></i>  
                            <!--<span class="glyphicon glyphicon-user"></span>-->
                            <span class="Till" style=" padding-left: 24px; box-sizing: border-box; color: rgb(255, 255, 255);">
                                <span id="u_name" class="admin" style="color: rgb(255, 255, 255);">${rs[0].name}</span>
                                <input id="m_code" type="hidden" value="${rs[0].m_code}"/>
                                <input id="pwd" type="hidden" value="${rs[0].password}"/>
                                <input id="userid" type="hidden" value="${rs[0].id}"/>
                                <input id="upid" type="hidden" value="${rs[0].pid}"/>
                            </span>
                            <ul class="two animated fadeInDown twoL" style="background: rgb(57, 61, 73) none repeat scroll 0% 0%; color: rgb(255, 255, 255);">
                                <li id="out" onclick="getout()"><label name="xxx" id="3">退出</label></li>
                                <li data-toggle="modal" data-target="#updpwdDiv" ><label name="xxx" id="4">修改密码</label></li>
                            </ul>
                        </li>
                    </ul> 
                </div>
                <input  id="names" value="" type="hidden">
                <!--<input id="configurations" value="[{&quot;title&quot;:&quot;参数配置&quot;,&quot;action&quot;:&quot;config/paramConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/paramConfiguration.png&quot;},{&quot;title&quot;:&quot;网关配置&quot;,&quot;action&quot;:&quot;config/gateway.action&quot;,&quot;icon&quot;:&quot;imgs/manager/gatewayConfiguration.png&quot;},{&quot;title&quot;:&quot;项目配置&quot;,&quot;action&quot;:&quot;config/alarmConfig.action&quot;,&quot;icon&quot;:&quot;imgs/manager/alarmConfiguration.png&quot;}]" type="hidden">-->
                <iframe id="iframe" name="iframe" src="formuser.mainsub.home.action?pid=${fn:split(param.pid,",")[0]}&lang=${empty cookie.lang.value?"zh_CN":cookie.lang.value}" seamless="" style="height: 886px;" width="100%" frameborder="0">
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
                        <h4 class="modal-title" style="display: inline;"><label name="xxx" id="4">修改密码</label></h4></div>    
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:92px;"><label name="xxx" id="271">密码</label>：</span>&nbsp;
                                        <input id="oldPwd" class="form-control" style="width:150px;display: inline;" placeholder="请输入密码" type="password">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:35px;"><label id="272" name="xxx">请输入新密码</label>：</span>&nbsp;
                                        <input id="newPwd" class="form-control" style="width:150px;display: inline;" placeholder="请输入新密码" type="password">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:49px;"><label id="273" name="xxx">请确认密码</label>：</span>&nbsp;
                                        <input id="okPwd" class="form-control" style="width:150px;display: inline;" placeholder="请确认密码" type="password">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer" id="modal_footer_edit" >
                        <!-- 添加按钮 -->
                        <button id="xiugai" type="button" onclick="updatepwd()" class="btn btn-primary"><label name="xxx" id="151">修改</label></button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal"><label name="xxx" id="57">关闭</label></button>
                    </div>

                </div>
            </div>
        </div>

        <div class="modal" id="faultDiv" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:750px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;"><label name="xxx" id="274">告警信息</label></h4></div>    
                    <div class="modal-body">
                        <table>
                            <tbody class="search">
                                <tr>
                                    <td>
                                        <span style="margin-left:0px;" id="64" name="xxx">
                                            所属区域
                                        </span>&nbsp;
                                        <input type="text" id ="area" style="width:150px; height: 30px;">
                                    </td>
                                    <td>
                                        <span style="margin-left:30px;">                                     
                                            <span id="25" name="xxx">网关地址</span>
                                            &nbsp;</span>
                                        <input id="comaddrlist" data-options='editable:false,valueField:"id", textField:"text"' class="easyui-combobox"/>
                                    </td>
                                    <td>
                                        <!-- <input type="button" class="btn btn-sm btn-success" onclick="selectlamp()" value="搜索" style="margin-left:10px;">-->
                                        <button class="btn btn-sm btn-success" onclick="" style="margin-left:10px;"><span id="34" name="xxx">搜索</span></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <table id="fauttable">

                        </table>
                        <!--                        <table id="peopletable"></table>-->
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer" id="modal_footer_edit" >
                        <!-- 添加按钮 -->
                        <!--                        <button id="xiugai" type="button" onclick="handle()" class="btn btn-primary">处理报警</button>-->
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal"><label name="xxx" id="57">关闭</label></button>
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


            function changeLanguage(language) {
                setCookie("lang", language);
                $(".MenuBox").children().remove();
                var lang = language;
            <c:forEach items="${menulist}" var="t" varStatus="i">
                <c:if test="${t.m_parent==0}">
                var title =${t.m_title};
                    <c:if test="${i.index==0}">
                var li = document.createElement("li");
                $(li).addClass("eachMenu layui-nav-item");
                var a = document.createElement("a");
                $(a).addClass("list listdisplayNone active");
                $(a).attr("href", "javascript:;");
                $(a).attr("name", "${t.m_action}?m_parent=${t.m_code}&role=${t.roletype}&lang=" + lang);
                var spanicon = document.createElement("span");
                var spantext = document.createElement("span");
                $(spanicon).addClass("${t.m_icon}");
                $(spantext).addClass("menuMessage");
                $(spantext).append(title[lang]);
                $(a).append(spanicon);
                $(a).append(spantext);
                $(li).append(a);
                $(".MenuBox").append(li);


                    </c:if>
                    <c:if test="${i.index>0}">
                var li = document.createElement("li");
                $(li).addClass("eachMenu layui-nav-item");
                var a = document.createElement("a");
                $(a).addClass("list listdisplayNone active");
                $(a).attr("href", "javascript:;");

                $(a).attr("name", "${t.m_action}?m_parent=${t.m_code}&role=${t.roletype}&lang=" + lang);
                var spanicon = document.createElement("span");
                var spantext = document.createElement("span");
                $(spanicon).addClass("${t.m_icon}");
                $(spantext).addClass("menuMessage");
                $(spantext).append(title[lang]);
                $(a).append(spanicon);
                $(a).append(spantext);
                $(li).append(a);
                $(".MenuBox").append(li);
                    </c:if>
                </c:if>

            </c:forEach>
                $(".MenuBox .list:eq(0)").click();
            }











            $(function () {
                var pid = '${rs[0].pid}';
                var pids = pid.split(",");   //项目编号
                // $("#pojects").val(pids[0]);
                var pname = [];   //项目名称
                for (var i = 0; i < pids.length; i++) {
                    var obj = {};
                    obj.code = pids[i];
                    $.ajax({url: "login.main.getpojcetname.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            pname.push(data.rs[0].name);
                        },
                        error: function () {
                            alert("出现异常！");
                        }
                    });
                }

                for (var i = 0; i < pids.length; i++) {
                    var options;
                    options += "<option value=\"" + pids[i] + "\">" + pname[i] + "</option>";
                    $("#pojects").html(options);
                }
                //查看警异常信息总数
                fualtCount();
                $('#fauttable').bootstrapTable({
                    url: 'login.main.faultInfo.action',
                    columns: [
                        {
                            field: 'f_comaddr',
                            title: o[120][lang], //设备名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_day',
                            title: o[82][lang], //时间
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_type',
                            title: o[121][lang], //异常类型
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_comment',
                            title: o[123][lang], //异常说明
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_setcode',
                            title: o[236][lang], //装置号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: '',
                            title: '详情', //状态字2
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                //console.log(row);
                                var str = "";
                                var info = eventobj[row.f_type];
                                if (typeof info == "object") {
                                    var s1 = info.status1;
                                    var s2 = info.status2;
                                    for (var i = 0; i < 8; i++) {
                                        var temp = Math.pow(2, i);
                                        if ((row.f_status1 & temp) == temp) {
                                            if (s1[i] != "") {
                                                str = str + s1[i] + "|";
                                            }

                                        }
                                    }

                                    for (var i = 0; i < 8; i++) {
                                        var temp = Math.pow(2, i);
                                        if ((row.f_status2 & temp) == temp) {
                                            if (s1[i] != "") {
                                                str = str + s1[i] + "|";
                                            }

                                        }
                                    }

                                    return str.substr(0, str.length - 1);
                                } else if (row.f_type == "ERC49") {
                                    var d = Str2BytesH(row.f_data);
                                    var count = d[21] << 8 + d[20];
                                }


                                // console.log(len1);

                            }
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 5,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },

                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1"            
                        };      
                        return temp;  
                    }
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
                        }
                    } else {
                        $(this).addClass("active");
                        $(this).parent(".eachMenu").siblings(".eachMenu").children(".list").removeClass("active");
                        $(this).parent(".eachMenu").siblings(".eachMenu").children(".secondMenu").children(".secondMenuList").removeClass("active");
                        var iframesrc = $(this).attr("name");
//                        if (iframesrc.indexOf("map.jsp") != -1) {
//                            var user = new Object();
//                            user.begin = '6A';
//                            user.res = 1;
//                            user.status = "";
//                            user.msg = "CheckLamp";
//                            user.val = getpojectId();
//                            user.data = "aa";
//                            user.end = '6A';
//                            console.log(user);
//                            sendData(user);
//                        } 
                        iframesrc = iframesrc + "&pid=" + getpojectId();
                        console.log(iframesrc);
                        $("#iframe").attr("src", iframesrc);


                    }
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
                });

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

                $(".language li:eq(0)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                    lang = language;
                    $("#1").html(o[1][language]);  //项目
                    $("#2").html(o[2][language]);  //语言
                    var bbb = $("label[name=xxx]");
                    for (var i = 0; i < bbb.length; i++) {
                        var d = bbb[i];
                        var e = $(d).attr("id");
                        $(d).html(o[e][language]);
                    }
                });
                $(".language li:eq(1)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                    lang = language;
                    $("#1").html(o[1][language]);  //项目
                    $("#2").html(o[2][language]);  //语言
                    var bbb = $("label[name=xxx]");
                    for (var i = 0; i < bbb.length; i++) {
                        var d = bbb[i];
                        var e = $(d).attr("id");
                        $(d).html(o[e][language]);
                    }
                });
                $(".language li:eq(2)").click(function () {
                    var language = $(this).attr("language");
                    changeLanguage(language);
                    lang = language;
                    $("#1").html(o[1][language]);  //项目
                    $("#2").html(o[2][language]);  //语言
                    var bbb = $("label[name=xxx]");
                    for (var i = 0; i < bbb.length; i++) {
                        var d = bbb[i];
                        var e = $(d).attr("id");
                        $(d).html(o[e][language]);
                    }
                });

                //语言切换
                var obj = {type: 1};



            });

            $(function () {

                $(".navTop").delegate("li", "click", function () {
                    var html = $(this).attr('name');
                    //console.log(html);
                    // $("#iframe").attr('src', html);
                    //导航栏颜色
                });

                $("#pojects").change(function () {
                    var user = new Object();
                    user.begin = '6A';
                    user.res = 0;
                    user.status = "";
                    user.msg = "CheckLamp";
                    user.val = getpojectId();
                    user.data = "aa";
                    user.end = '6A';
                    console.log(user);
                    sendData(user);
                    fualtCount();
                    $(".MenuBox .list:eq(0)").click();

                });
            });

        </script>

    </body>
</html>
