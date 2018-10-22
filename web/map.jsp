<%-- 
    Document   : map
    Created on : 2018-8-2, 15:29:53
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <script src="layer/layer.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <style type="text/css">
            body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
            .search>tr>td {
                padding-top: 20px;
            }
            #showtext{
                width: 230px;
                height: 50px;
                font-size: 20px;
            }
            #fdiv{
                width: 70%;
                margin-left: -20%;
            }
            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 

            #up-map-div{
                width:300px;
                top:10%;
                left:60%;
                position:absolute;
                z-index:9999;
                border:1px solid blue;
                background-color:#FFFFFF;
            }
        </style>
        <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Uppxai1CT7jTHF9bjKFx0WGTs7nCyHMr"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script type="text/javascript" src="bootstrap-table/dist/bootstrap-table.js"></script>
        <script type="text/javascript" src="bootstrap-table/dist/locale/bootstrap-table-zh-CN.min.js"></script>
        <script type="text/javascript" src="bootstrap-table/dist/locale/bootstrap-table-zh-CN.js"></script>

    </head>
    <body>

        <div id="allmap">

        </div>
        <div id="up-map-div" style=" display: none">
            <table style=" margin-left: 10%; width: 80%;">
                <tr style=" border-bottom:1px solid green">
                    <th><span id="12" name="xxx">状态</span></th>
                    <th></th>
                    <th><spn name="xxx" id="283">标识</spn></th>
                </tr>
                <tr>
                    <td><span name="xxx" id="401">灯具亮灯</span>:</td>
                    <td style=" color: yellow;">-----------------</td>
                    <td><img src="img/lyello.png" style=" margin-left:-7px;"></td>
                </tr>
                <tr>
                    <td><span name="xxx" id="298">灯具在线</span>:</td>
                    <td style=" color: green;">-----------------</td>
                    <td><img src="img/yl.png" style=" margin-left:-7px;"></td>
                </tr>
                <tr>
                    <td><span name="xxx" id="299">灯具离线</span>:</td>
                    <td style=" color: #93a1a1;">-----------------</td>
                    <td><img src="img/lhui.png"></td>
                </tr>
                <tr>
                    <td><span name="xxx" id="300">灯具异常</span>:</td>
                    <td style=" color: red;">-----------------</td>
                    <td><img src="img/lred3.png"></td>
                </tr>
                <tr>
                    <td><span name="xxx" id="296">网关在线</span>:</td>
                    <td style=" color: green;">-----------------</td>
                    <td><img src="img/wzx.png"></td>
                </tr>
                <tr>
                    <td><span name="xxx" id="297">网关离线</span>:</td>
                    <td style=" color: #93a1a1;">-----------------</td>
                    <td><img src="img/wlx.png"></td>
                </tr>
            </table>
        </div>
        <!-- 添加 网关-->
        <div  id="addwanguang" class="bodycenter"  style=" display: none" >
            <div class="">
                <div class="">
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
                                    <button class="btn btn-sm btn-success" onclick="getInfoByComaddr()" style="margin-left:10px;"><span id="34" name="xxx">搜索</span></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <hr>
                <div>
                    <table id="wgtable">

                    </table>
                </div>
            </div>
        </div>
        <!--添加灯具-->
        <div  id="addlamp" class="bodycenter"  style=" display: none" >
            <div class="">
                <div  style="min-width:700px;">   
                    <div class="">
                        <table>
                            <tbody class="search">
                                <tr>
                                    <td>
                                        <span style="margin-left:30px;" id="54" name="xxx">
                                            灯具名称
                                        </span>&nbsp;
                                        <input type='text' id='lampname'>
                                    <td>
                                        <span style="margin-left:50px;">
                                            <span id="55" name="xxx">所属网关</span>
                                            &nbsp;</span>
                                        <input id="lampcomaddrlist" data-options='editable:false,valueField:"id", textField:"text"' class="easyui-combobox"/>
                                    </td>
                                    <td>
                                        <!-- <input type="button" class="btn btn-sm btn-success" onclick="selectlamp()" value="搜索" style="margin-left:10px;">-->
                                        <button class="btn btn-sm btn-success" onclick="selectlamp()" style="margin-left:10px;"><span id="34" name="xxx">搜索</span></button>
                                    </td>
                                </tr>                                   
                            </tbody>
                        </table>
                    </div>
                    <hr>
                    <div>
                        <table id="lamptable">

                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            //创建网关在线图标
            var wggreenicon = new BMap.Icon('./img/wgreen.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建网关离线图标
            var wghuiicon = new BMap.Icon('./img/wlx.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建灯具离线图标
            var lhui = new BMap.Icon('./img/lhui.png', new BMap.Size(27, 32), {//20，30是图片大小
                // anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建灯具在线图标
            var lgreen = new BMap.Icon('./img/yl.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });
            //创建灯具异常图标
            var lred = new BMap.Icon('./img/lred3.png', new BMap.Size(27, 32), {//20，30是图片大小
                //anchor: new BMap.Size(0, 0)      //这个是信息窗口位置（可以改改看看效果）
            });

           
            function lightCB1(obj) {
                console.log("ojbk");
                if (obj.status == "success") {
                   
                    if (obj.fn == 301) {
                        //layerAler(langs1[313][lang]);  //单灯调光成功
                       
                        var param = obj.param;
                        var o = {};
                        o.l_value = obj.val;
                        o.id = param.id;
//                        $.ajax({async: false, url: "test1.lamp.modifyvalue.action", type: "get", datatype: "JSON", data: o,
//                            success: function (data) {
//                                var arrlist = data.rs;
//                                if (arrlist.length == 1) {
//                                    $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_value", value: obj.val});
//                                }
//                            },
//                            error: function () {
//                                alert("提交失败！");
//                            }
//                        });
                    } else if (obj.fn == 302) {
                        var param = obj.param;
                        var o = {};
                        o.l_value = obj.val;
                        o.l_comaddr = obj.comaddr;
                        o.l_groupe = param.l_groupe;
                        if (obj.type == 3) {
//                            $.ajax({async: false, url: "lamp.lampform.modifygroupevalAll.action", type: "get", datatype: "JSON", data: o,
//                                success: function (data) {
//                                    if (data != null) {
//                                        $('#gravidaTable').bootstrapTable('refresh');
//                                    }
//                                },
//                                error: function () {
//                                    alert("提交失败！");
//                                }
//                            });
                        } else {
//                            $.ajax({async: false, url: "lamp.lampform.modifygroupeval.action", type: "get", datatype: "JSON", data: o,
//                                success: function (data) {
//                                    var arrlist = data.rs;
//                                    if (arrlist.length >= 1) {
//                                        $('#gravidaTable').bootstrapTable('refresh');
//                                    }
//                                },
//                                error: function () {
//                                    alert("提交失败！");
//                                }
//                            });
                        }

                    }
                }

            }
            //调用父页面的方法获取用户名
            var u_name = parent.getusername();

            var lans = parent.parent.getLnas();
            var lang = "${param.lang}";
            //加载所有灯具信息
            function  getAllLampInfo(pid) {

                $('#lamptable').bootstrapTable({
                    url: 'login.map.lamp.action?pid=' + pid,
                    columns: [
                        {
                            title: 'id',
                            field: 'id',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            visible: false, //不显示
                            class: 'lampId'
                        },
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_name',
                            title: lans[54][lang], //灯具名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_comaddr',
                            title: lans[55][lang], //所属网关
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'Longitude',
                            title: lans[59][lang], //经度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: lans[60][lang], //纬度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'presence',
                            title: lans[61][lang], //在线状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value == 1) {
                                    return "<img  src='img/online1.png'/>";
                                } else {
                                    return "<img  src='img/off.png'/>";
                                }

                            }
                        }],
                    method: "post",
                    contentType: "application/x-www-form-urlencoded",
                    singleSelect: false, //设置单选还是多选，true为单选 false为多选
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 15,
                    showRefresh: false,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
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
            }
            //加载所有所属网关信息
            function getAllInfo() {
                var pid = parent.getpojectId();
                $("#wgtable").bootstrapTable({
                    url: 'login.map.map.action?pid=' + pid,
                    columns: [
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'model',
                            title: lans[62][lang], //型号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'name',
                            title: lans[63][lang], //名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'comaddr',
                            title: lans[25][lang], //网关地址
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'Longitude',
                            title: lans[59][lang], //经度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: lans[60][lang], //纬度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'presence',
                            title: lans[61][lang], //在线状态
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value == 1) {
                                    return "<img  src='img/online1.png'/>";
                                } else {
                                    return "<img  src='img/off.png'/>";
                                }

                            }
                        }],
                    singleSelect: false,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    // minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: false, //是否显示刷新
                    // showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
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
            }

            //根据所属网关查询网关信息
            function getInfoByComaddr() {

                var comaddr = $("#comaddrlist").val();
                var area = $("#area").val();
                var obj = {};
                obj.type = "ALL";
                if (comaddr != "") {
                    obj.comaddr = comaddr;
                }
                if (area != "") {
                    obj.area = encodeURI(area);
                }
                var pid = parent.getpojectId();
                obj.pid = pid;

                var opt = {
                    //method: "post",
                    url: "login.map.map.action",
                    silent: true,
                    query: obj
                };
                $("#wgtable").bootstrapTable('refresh', opt);
            }
            //关闭添加灯具弹窗
            function  lampout() {
                $("#lamptable input:checkbox").each(function () {
                    if ($(this).is(":checked")) {
                        $(this).prop("checked", false);
                    }
                });
                layer.close(layer.index);
            }
            //关闭添加网关弹窗
            function closeAddComaddr() {
                $("#wgtable input:checkbox").each(function () {
                    if ($(this).is(":checked")) {
                        $(this).prop("checked", false);
                    }
                });
                layer.close(layer.index);
            }
            // 百度地图API功能
            var map = new BMap.Map("allmap", {enableMapClick: false}); // 创建Map实例
            map.centerAndZoom(new BMap.Point(116.404, 39.915), 11); // 初始化地图,设置中心点坐标和地图级别
            //添加地图类型控件
            map.addControl(new BMap.MapTypeControl({
                mapTypes: [
                    BMAP_NORMAL_MAP,
                    BMAP_HYBRID_MAP
                ]}));
            map.centerAndZoom("湛江", 15); // 设置地图显示的城市 此项是必须设置的
            map.enableScrollWheelZoom(true); //开启鼠标滚轮缩放

            var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT}); // 左上角，添加比例尺
            var top_left_navigation = new BMap.NavigationControl(); //左上角，添加默认缩放平移控件
            var top_right_navigation = new BMap.NavigationControl({anchor: BMAP_ANCHOR_TOP_RIGHT, type: BMAP_NAVIGATION_CONTROL_SMALL}); //右上角，仅包含平移和缩放按钮
            /*缩放控件type有四种类型:
             BMAP_NAVIGATION_CONTROL_SMALL：仅包含平移和缩放按钮；BMAP_NAVIGATION_CONTROL_PAN:仅包含平移按钮；BMAP_NAVIGATION_CONTROL_ZOOM：仅包含缩放按钮*/
            map.addControl(top_left_control);
            map.addControl(top_left_navigation);
            map.addControl(top_right_navigation);
            function ZoomControl() {
                // 默认停靠位置和偏移量
                this.defaultAnchor = BMAP_ANCHOR_TOP_LEFT;
                this.defaultOffset = new BMap.Size(500, 5);
            }

            // 通过JavaScript的prototype属性继承于BMap.Control
            ZoomControl.prototype = new BMap.Control();
            // 自定义控件必须实现自己的initialize方法,并且将控件的DOM元素返回
            // 在本方法中创建个div元素作为控件的容器,并将其添加到地图容器中
            ZoomControl.prototype.initialize = function (map) {
                var o = parent.parent.getLnas();
                var lang = "${param.lang}";
                // 创建一个DOM元素
                var div = document.createElement("div");
                div.setAttribute("id", "fdiv");
                var button1 = document.createElement("input");
                var text = document.createElement("input"); //显示经纬度
                text.setAttribute("type", "text");
                text.setAttribute("value", "");
                text.setAttribute("id", "showtext");
                text.setAttribute("style", "margin-right: 100px");
                div.appendChild(text);
                button1.setAttribute("type", "text");
                button1.setAttribute("value", "");
                button1.setAttribute("id", "seartxt");
                div.appendChild(button1);
                var button2 = document.createElement("input");
                button2.setAttribute("type", "button");
                button2.setAttribute("value", o[34][lang]);//搜索按钮
                button2.setAttribute("style", "margin-left: 5px");
                button2.setAttribute("id", "search");
                div.appendChild(button2);
                var button3 = document.createElement("input");
                button3.setAttribute("type", "button");
                button3.setAttribute("value", o[50][lang]);//网关按钮
                button3.setAttribute("style", "margin-left: 5px");
                button3.setAttribute("id", "jzq");
                div.appendChild(button3);
                var button4 = document.createElement("input");
                button4.setAttribute("type", "button");
                button4.setAttribute("value", o[51][lang]); //灯具按钮
                button4.setAttribute("style", "margin-left: 5px");
                button4.setAttribute("id", "dj");
                div.appendChild(button4);

                var button5 = document.createElement("input");
                button5.setAttribute("type", "button");
                button5.setAttribute("value", o[52][lang]);//状态标识
                button5.setAttribute("style", "margin-left: 5px");
                button5.setAttribute("id", "zt");
                div.appendChild(button5);


                //网关单击事件
                button3.onclick = function (e) {
                    var allOver = map.getOverlays(); //获取全部标注
                    for (var j = 0; j < allOver.length; j++) {
                        if (allOver[j].toString() == "[object Marker]") {
                            //清除所有标记
                            map.removeOverlay(allOver[j]);
                        }
                        if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                            map.removeOverlay(allOver[j]);
                        }
                    }
                    var pid = parent.getpojectId();
                    var objw = {};
                    objw.pid = pid;
                    $.ajax({async: false, url: "login.map.lnglat.action", type: "get", datatype: "JSON", data: objw,
                        success: function (data) {
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                var obj = arrlist[i];
                                var Longitude = obj.Longitude;
                                var latitude = obj.latitude;
                                var comaddr = obj.comaddr;
                                var Iszx = o[285][lang];   //离线                              
                                if (Longitude != "" && latitude != "") {
                                    if (obj.online == 1) {
                                        Iszx = o[284][lang];  //在线
                                    }
                                    var point = new BMap.Point(Longitude, latitude);
                                    var marker1;
                                    if (obj.online == 1) {
                                        marker1 = new BMap.Marker(point, {
                                            icon: wggreenicon
                                        });
                                    } else {
                                        marker1 = new BMap.Marker(point, {
                                            icon: wghuiicon
                                        });
                                    }
                                    marker1.setTitle(comaddr + "," + Iszx);   //这里设置maker的title (鼠标放到marker点上,会出现它的title,所以我这里把name,放到title里)
                                    map.addOverlay(marker1);
                                    map.panTo(point);
                                }
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                };
                //搜索网关
                button2.onclick = function (e) {
                    var pid = parent.getpojectId();
                    var allOver = map.getOverlays(); //获取全部标注
                    for (var j = 0; j < allOver.length; j++) {
                        if (allOver[j].toString() == "[object Marker]") {
                            //清除所有标记
                            map.removeOverlay(allOver[j]);
                        }
                        if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                            map.removeOverlay(allOver[j]);
                        }
                    }
                    var obj = {};
                    var comaddr = $("#seartxt").val();
                    if (comaddr != "") {
                        obj.comaddr = comaddr;
                    }
                    obj.pid = pid;
                    $.ajax({async: false, url: "login.map.lnglat.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                for (var i = 0; i < arrlist.length; i++) {
                                    var obj = arrlist[i];
                                    var Longitude = obj.Longitude;
                                    var latitude = obj.latitude;
                                    var Iszx = o[285][lang];   //离线    
                                    if (obj.online == 1) {
                                        Iszx = o[284][lang];   //在线    
                                    }
                                    if (Longitude != "" && latitude != "") {
                                        var point = new BMap.Point(Longitude, latitude);
                                        var marker1;
                                        var marker1;
                                        if (obj.online == 1) {
                                            marker1 = new BMap.Marker(point, {
                                                icon: wggreenicon
                                            });
                                        } else {
                                            marker1 = new BMap.Marker(point, {
                                                icon: wghuiicon
                                            });
                                        }
                                        marker1.setTitle(obj.comaddr + "," + Iszx);   //这里设置maker的title (鼠标放到marker点上,会出现它的title,所以我这里把name,放到title里)
                                        map.addOverlay(marker1);
                                        map.panTo(point);
                                    }
                                }
                            } else {
                                alert(o[301][lang]);  //不存在该网关
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }

                //灯具
                button4.onclick = function (e) {
                    var allOver = map.getOverlays(); //获取全部标注
                    for (var j = 0; j < allOver.length; j++) {
                        if (allOver[j].toString() == "[object Marker]") {
                            //清除所有标记
                            map.removeOverlay(allOver[j]);
                        }
                        if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                            map.removeOverlay(allOver[j]);
                        }
                    }
                    var pid = parent.getpojectId();
                    var d = new Date();
                    var day = d.toLocaleDateString();
                    var lobj = {};
                    lobj.pid = pid;
                    lobj.f_day = day;
                    $.ajax({async: false, url: "login.map.queryLamp.action", type: "get", datatype: "JSON", data: lobj,
                        success: function (data) {

                            var arrlist = data.rs;
                            var flist = data.rs2;
                            for (var i = 0; i < arrlist.length; i++) {
                                (function (x) {
                                    var obj = arrlist[i];
                                    var Longitude = obj.Longitude;
                                    var latitude = obj.latitude;
                                    //var s = obj.l_name;
                                    var Iszx = lans[285][lang];    //是否离线,离线
                                    var Isfault = lans[13][lang]; //是否有故障,默认正常
                                    var isfault2 = 0;
                                    for (var j = 0; j < flist.length; j++) {
                                        if (arrlist[i].l_code == flist[j].f_setcode && arrlist[i].l_comaddr == flist[j].f_comaddr) {
                                            Isfault = lans[14][lang]; //异常
                                            isfault2 = 1;
                                            break;
                                        }
                                    }
                                    if (obj.presence == 1) {
                                        Iszx = lans[284][lang];  //在线
                                    }
                                    //lans[][]代表的文字依次是：亮度、名称、灯具编号、网关地址、在线情况、状态
                                    var textvalue = "<div style='line-height:1.8em;font-size:12px;'>\n\
                                   \n\
                                    <table style='text-align:center'>\n\
                                        <tr>\n\
                                            <td>" + lans[290][lang] + ":</td>\n\
                                            <td>" + arrlist[i].l_value + "</td>\n\
                                            <td></td>\n\
                                            <td>" + lans[63][lang] + ":</td>\n\
                                            <td>" + arrlist[i].l_name + "</td>\n\
                                        </tr>\n\
                                        <tr>\n\
                                            <td>" + lans[292][lang] + ":</td>\n\
                                            <td>" + arrlist[i].l_factorycode + "</td>\n\
                                             <td>&nbsp&nbsp</td>\n\
                                            <td>" + lans[25][lang] + ":</td>\n\
                                            <td>" + arrlist[i].l_comaddr + "</td>\n\
                                        </tr>\n\ \n\
                                        <tr>\n\
                                            <td>" + lans[294][lang] + ":</td>\n\
                                            <td>" + Iszx + "</td>\n\
                                             <td>&nbsp&nbsp</td>\n\
                                            <td>" + lans[12][lang] + ":</td>\n\
                                            <td>" + Isfault + "</td>\n\
                                        </tr>\n\ \n\
                                    </table></div>";
                                    if ((Longitude != "" && latitude != "") && (Longitude != null && latitude != null)) {
                                        var point = new BMap.Point(Longitude, latitude);
                                        var marker1;
                                        if (isfault2 == 1) {
                                            marker1 = new BMap.Marker(point, {
                                                icon: lred
                                            });
                                        } else if (obj.presence == 1) {
                                            marker1 = new BMap.Marker(point, {
                                                icon: lgreen
                                            });
                                        } else {
                                            marker1 = new BMap.Marker(point, {
                                                icon: lhui
                                            });
                                        }
                                        var opts = {title: '<span style="font-size:14px;color:#0A8021">' + lans[404][lang] + '</span>', width: 300, height: 120, };//设置信息框、信息说明
                                        var infoWindow = new BMap.InfoWindow(textvalue, opts); // 创建信息窗口对象，引号里可以书写任意的html语句。
                                        marker1.addEventListener("mouseover", function () {
                                            this.openInfoWindow(infoWindow);
                                        });
                                        //标注点点击事件
                                        marker1.addEventListener("click", function () {
                                            var textvalue2 = "<button id='kd'>开灯</button><button id='gd'>关灯</button>";
                                            var opts2 = {title: '<span style="font-size:14px;color:#0A8021">' + lans[404][lang] + '</span>', width: 300, height: 120, };//设置信息框、信息说明
                                            var infoWindow2 = new BMap.InfoWindow(textvalue2, opts2); // 创建信息窗口对象，引号里可以书写任意的html语句。
                                            this.openInfoWindow(infoWindow2);
                                            $("#kd").click(function () {
                                                var vv = new Array();
                                                var l_comaddr = obj.l_comaddr;
                                                var lampval = 100;


                                                var c = parseInt(obj.l_code);
                                                var h = c >> 8 & 0x00ff;
                                                var l = c & 0x00ff;
                                                vv.push(l);
                                                vv.push(h); //装置序号  2字节

                                                vv.push(parseInt(lampval));
                                                var num = randnum(0, 9) + 0x70;
                                                var param = {};
//                                                param.id = select.id;
//                                                param.row = select.index;
                                                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 301, vv); //01 03
                                                //dealsend(sss, o1);
                                                dealsend3("A5", data, 301, "lightCB1", l_comaddr, 0, 0, lampval);
                                                
                                            });
                                            $("#gd").click(function () {
                                                var vv = new Array();
                                                var l_comaddr = obj.l_comaddr;
                                                var lampval = 0;


                                                var c = parseInt(obj.l_code);
                                                var h = c >> 8 & 0x00ff;
                                                var l = c & 0x00ff;
                                                vv.push(l);
                                                vv.push(h); //装置序号  2字节

                                                vv.push(parseInt(lampval));
                                                var num = randnum(0, 9) + 0x70;
                                                var param = {};
//                                                param.id = select.id;
//                                                param.row = select.index;
                                                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 301, vv); //01 03
                                                //dealsend(sss, o1);
                                                dealsend2("A5", data, 301, "lightCB1", l_comaddr, 0, 0, lampval);
                                            });
                                        });
                                        map.addOverlay(marker1);
                                        map.panTo(point);
                                    }
                                })(i);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                };
                var ij = 0;
                button5.onclick = function (e) {
                    if (ij == 0) {
                        $("#up-map-div").show();
                        ij = 1;
                    } else {
                        $("#up-map-div").hide();
                        ij = 0;
                    }
                };


                // 添加DOM元素到地图中
                map.getContainer().appendChild(div);
                // 将DOM元素返回
                return div;
            };

            var txtMenuItem = [
                {
                    text: lans[53][lang], //添加灯具
                    callback: function () {
                        var allOver = map.getOverlays(); //获取全部标注
                        for (var j = 0; j < allOver.length; j++) {
                            if (allOver[j].toString() == "[object Marker]") {
                                //清除所有标记
                                map.removeOverlay(allOver[j]);
                            }
                            if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                                map.removeOverlay(allOver[j]);
                            }
                        }

                        //加载所有灯具信息
                        var porjectId = parent.getpojectId();
                        var obj = {};
                        obj.pid = porjectId;
                        var opt = {
                            method: "post",
                            contentType: "application/x-www-form-urlencoded",
                            url: "login.map.lamp.action",
                            silent: true,
                            query: obj
                        };
                        $("#lamptable").bootstrapTable('refresh', opt);
                        var id = "#lampcomaddrlist";
                        combobox(id, porjectId);
                        //清空标记
                        draw = false;
                        idlist = [];
                        onedraw = false;
                        wgdraw = false;
                        wgonedraw = false;
                        wgidlist = [];
                        $("#addlamp").dialog("open");


                    }
                },
                {
                    text: lans[58][lang], //添加网关
                    callback: function () {

                        var allOver = map.getOverlays(); //获取全部标注
                        for (var j = 0; j < allOver.length; j++) {
                            if (allOver[j].toString() == "[object Marker]") {
                                //清除所有标记
                                map.removeOverlay(allOver[j]);
                            }
                            if (allOver[j].toString().indexOf("Polyline") > 0) {//删除折线
                                map.removeOverlay(allOver[j]);
                            }
                        }
                        var porjectId = parent.getpojectId();
                        var obj = {};
                        obj.pid = porjectId;
                        //加载所有网关信息
                        var opt = {
                            method: "post",
                            contentType: "application/x-www-form-urlencoded",
                            url: "login.map.map.action",
                            silent: true,
                            query: obj
                        };
                        $("#wgtable").bootstrapTable('refresh', opt);
                        //加载所属网关
                        var id = "#comaddrlist";
                        combobox(id, porjectId);
                        //清空标记
                        wgdraw = false;
                        wgonedraw = false;
                        wgidlist = [];
                        draw = false;
                        idlist = [];
                        onedraw = false;
                        $('#addwanguang').dialog('open');
                    }
                }
            ];
            //灯具选点绘线
            var draw = false;   //标记是否多点绘线
            var onedraw = false;  //勾选单个灯具
            var lampchecck;   //勾选单个灯具对象
            var idlist = new Array();  //标记选中的id
            function  Drawing() {
                var lampchecck2 = $("#lamptable").bootstrapTable('getSelections');
                if (lampchecck2.length > 1) {
                    draw = true;
                    for (var i = 0; i < lampchecck2.length; i++) {
                        idlist.push(lampchecck2[i].id);
                    }
                    $("#lamptable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#lamptable").bootstrapTable('refresh');
                    $('#addlamp').dialog("close");
                } else if (lampchecck2.length == 1) {
                    onedraw = true;
                    lampchecck = lampchecck2[0];
                    $("#lamptable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#lamptable").bootstrapTable('refresh');
                    $('#addlamp').dialog("close");
                } else {
                    alert(lans[73][lang]);  //请勾选表格数据
                }
            }
            //网关选点绘线
            var wgdraw = false;   //标记网关是否多点绘线
            var wgonedraw = false;  //勾选单个网关
            var wgchecck;   //勾选单个网关对象
            var wgidlist = new Array();  //标记选中网关的id
            function  wgDrawing() {
                var wgcheck2 = $("#wgtable").bootstrapTable('getSelections');
                if (wgcheck2.length > 1) {
                    wgdraw = true;
                    for (var i = 0; i < wgcheck2.length; i++) {
                        wgidlist.push(wgcheck2[i].comaddr);
                    }
                    $("#wgtable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#wgtable").bootstrapTable('refresh');
                    $('#addwanguang').dialog("close");
                } else if (wgcheck2.length == 1) {
                    wgonedraw = true;
                    wgchecck = wgcheck2[0];
                    $("#wgtable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            $(this).prop("checked", false);
                        }
                    });
                    $("#wgtable").bootstrapTable('refresh');
                    $('#addwanguang').dialog("close");
                } else {
                    alert(lans[73][lang]);  //请勾选表格数据
                }
            }
            //根据条件查询灯具
            function selectlamp() {
                var porjectId = parent.getpojectId();
                var lampname = $("#lampname").val();
                var l_commadr = $("#lampcomaddrlist").val();
                var obj = {};
                obj.type = "ALL";
                if (lampname != "") {
                    obj.l_name = encodeURI(lampname);
                }
                obj.l_comaddr = l_commadr;
                obj.pid = porjectId;
                var opt = {
                    url: "login.map.lamp.action",
                    silent: true,
                    query: obj
                };
                $("#lamptable").bootstrapTable('refresh', opt);
            }
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(lans[e][lang]);
                }
                var porjectId = parent.getpojectId();
                //加载所有网关信息
                getAllInfo();
                //加载灯具信息
                getAllLampInfo(porjectId);
                $("#addwanguang").dialog({
                    autoOpen: false,
                    modal: false,
                    width: 650,
                    height: 550,
                    position: ["top", "top"],
                    buttons: {
                        选点绘线: function () {
                            wgDrawing();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#addlamp").dialog({
                    autoOpen: false,
                    modal: false,
                    width: 720,
                    height: 550,
                    position: ["top", "top"],
                    buttons: {
                        选点绘线: function () {   //选点绘线
                            Drawing();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });


                var marker; //创建标注对象
                // 创建控件
                var myZoomCtrl = new ZoomControl();
                // 添加到地图当中
                map.addControl(myZoomCtrl);
                var menu = new BMap.ContextMenu();
                for (var i = 0; i < txtMenuItem.length; i++) {
                    menu.addItem(new BMap.MenuItem(txtMenuItem[i].text, txtMenuItem[i].callback, 100));
                }
                map.addContextMenu(menu);
                //鼠标移动事件
                map.addEventListener("mousemove", function (e) {
                    var str = e.point.lng + "," + e.point.lat;
                    $("#showtext").val(str);
                });
                //修改网关经纬度
                function updatelnglat(lng, lat, comaddr) {
                    var porjectId = parent.getpojectId();
                    var nobj = {};
                    nobj.name = u_name;
                    var day = getNowFormatDate2();
                    nobj.time = day;
                    nobj.type = "修改";
                    nobj.comment = "修改网关经纬度";
                    nobj.pid = porjectId;
                    nobj.page = "地图导航";
                    $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {

                            }
                        }
                    });
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.comaddr = comaddr;
                    $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var obj = {};
                                obj.pid = porjectId;
                                //加载所有网关信息
                                var opt = {
                                    //method: "post",
                                    url: "login.map.map.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#wgtable").bootstrapTable('refresh', opt);
                                var now_point = new BMap.Point(lng, lat);
                                marker = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                                var label = new BMap.Label(comaddr, {offset: new BMap.Size(20, 0)}); //创建marker点的标记,这里注意下,因为百度地图可以对label样式做编辑,所以我这里吧重要的id放在了label(然后再隐藏)   
                                label.setStyle({display: "none"}); //对label 样式隐藏    
                                marker.setLabel(label); //把label设置到maker上 
                                marker.enableDragging(); //标注可拖拽
                                map.addOverlay(marker); // 添加标注
                                // 开启事件监听,标注移动事件
                                marker.addEventListener("dragend", function (e) {
                                    var x = e.point.lng; //经度
                                    var y = e.point.lat; //纬度
                                    if (confirm(lans[288][lang])) {  //该设备已有经纬度了，您确定更改吗?
                                        var obj2 = {};
                                        obj2.Longitude = x;
                                        obj2.latitude = y;
                                        obj2.comaddr = e.target.getLabel().content; //获取标注隐藏的值
                                        $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                            success: function (data) {
                                                var arrlist = data.rs;
                                                if (arrlist.length == 1) {
                                                    var obj = {};
                                                    obj.pid = porjectId;
                                                    //加载所有网关信息
                                                    var opt = {
                                                        //method: "post",
                                                        url: "login.map.map.action",
                                                        silent: true,
                                                        query: obj
                                                    };
                                                    $("#wgtable").bootstrapTable('refresh', opt);

                                                } else {
                                                    alert(lans[281][lang]);  //修改失败
                                                }
                                            },
                                            error: function () {
                                                alert("提交添加失败！");
                                            }
                                        });
                                    }

                                });
                            } else {
                                alert(lans[281][lang]);  //修改失败
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                }
                //修改多个灯具的经纬度
                function updateMayLamplnglat(lng, lat, id) {
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.id = id;
                    $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });

                }
                //修改单个灯具经纬度
                function updateLamplnglat(lng, lat, id) {
                    var porjectId = parent.getpojectId();
                    var nobj2 = {};
                    nobj2.name = u_name;
                    var day = getNowFormatDate2();
                    nobj2.time = day;
                    nobj2.type = "修改";
                    nobj2.comment = "修改灯具经纬度";
                    nobj2.page = "地图导航";
                    nobj2.pid = porjectId;
                    $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj2,
                        success: function (data) {
                            var arrlist = data.rs;
                        }
                    });
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.id = id;
                    $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var obj = {};
                                obj.pid = porjectId;
                                var opt = {
                                    //method: "post",
                                    url: "login.map.lamp.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#lamptable").bootstrapTable('refresh', opt);
                                var now_point = new BMap.Point(lng, lat);
                                marker = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                                var label = new BMap.Label(id, {offset: new BMap.Size(20, 0)}); //创建marker点的标记,这里注意下,因为百度地图可以对label样式做编辑,所以我这里吧重要的id放在了label(然后再隐藏)   
                                label.setStyle({display: "none"}); //对label 样式隐藏    
                                marker.setLabel(label); //把label设置到maker上 
                                marker.enableDragging(); //标注可拖拽
                                map.addOverlay(marker); // 添加标注
                                // 开启事件监听,标注移动事件
                                marker.addEventListener("dragend", function (e) {
                                    var x = e.point.lng; //经度
                                    var y = e.point.lat; //纬度
                                    if (confirm(lans[288][lang])) {  //该设备已有经纬度了，您确定更改吗?
                                        var obj2 = {};
                                        obj2.Longitude = x;
                                        obj2.latitude = y;
                                        obj2.id = e.target.getLabel().content; //获取标注隐藏的值
                                        $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                            success: function (data) {
                                                var arrlist = data.rs;
                                                if (arrlist.length == 1) {
//                                                    var obj = {};
//                                                    obj.pid = porjectId;
//                                                    var opt = {
//                                                        //method: "post",
//                                                        url: "login.map.lamp.action",
//                                                        silent: true,
//                                                        query: obj
//                                                    };
//                                                    $("#lamptable").bootstrapTable('refresh', opt);
                                                    alert(langs[143][lang]);  //修改成功
                                                } else {
                                                    alert(lans[281][lang]);  //修改失败
                                                }
                                            },
                                            error: function () {
                                                alert("提交添加失败！");
                                            }
                                        });
                                    }

                                });
                            } else {
                                alert(lans[281][lang]);  //修改失败
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                }
                //给地图添加点击事件
                var array = [];   //存储排练标注的经纬度数组
                var wgarray = []; //存储排练标注网关的经纬度数组
                map.addEventListener("click", function (e) {
                    var isboole = false; //判断弹出框是否选中数据
                    var comaddr; //存储选中数据的通信地址
                    var lng; //经度
                    var lat; //纬度
//                    //网关的修改
//                    $("#wgtable input:checkbox").each(function () {
//                        if ($(this).is(":checked")) {
//                            var select = $("#wgtable").bootstrapTable('getSelections');
//                            comaddr = select[0].comaddr;
//                            lng = select[0].Longitude;
//                            lat = select[0].latitude;
//                            isboole = true;
//                        }
//                    });

                    //修改单个网关
                    if (wgonedraw) {
                        if (wgchecck.Longitude != null && wgchecck.latitude != null) {
                            if (confirm(lans[288][lang])) {  //该设备已有经纬度了，您确定更改吗?
                                updatelnglat(e.point.lng, e.point.lat, wgchecck.comaddr);
                                var allOver = map.getOverlays(); //获取全部标注
                                for (var j = 0; j < allOver.length; j++) {
                                    if (allOver[j].toString() == "[object Marker]") {
                                        if (allOver[j].getPosition().lng == lng && allOver[j].getPosition().lat == lat) {
                                            map.removeOverlay(allOver[j]);
                                        }
                                    }
                                }
                            }
                        } else {
                            updatelnglat(e.point.lng, e.point.lat, wgchecck.comaddr);
                        }
                        wgonedraw = false;
                        wgchecck = [];
                    }

                    //修改多个网关
                    if (wgdraw) {
                        var obj3 = {};
                        obj3.x = e.point.lng;
                        obj3.y = e.point.lat;
                        wgarray.push(obj3);
                        var now_point = new BMap.Point(e.point.lng, e.point.lat);
                        var marker2 = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                        map.addOverlay(marker2); // 添加标注

                        if (wgarray.length > 1) {
                            var polyline = new BMap.Polyline([
                                new BMap.Point(wgarray[wgarray.length - 2].x, wgarray[wgarray.length - 2].y), //起始点的经纬度
                                new BMap.Point(wgarray[wgarray.length - 1].x, wgarray[wgarray.length - 1].y)//终止点的经纬度
                            ], {strokeColor: "red", //设置颜色
                                strokeWeight: 3, //宽度
                                strokeOpacity: 0.5});//透明度
                            map.addOverlay(polyline);

                            if (confirm(lans[289][lang])) {  //你还要继续选点吗？

                            } else {
                                for (var i = 0; i < wgidlist.length; i++) {
                                    updatelnglat(wgarray[i].x, wgarray[i].y, wgidlist[i]);
                                }
                                alert(lans[295][lang]); //配置经纬度成功
                                var nobj = {};
                                nobj.name = u_name;
                                var day = getNowFormatDate2();
                                nobj.time = day;
                                nobj.type = "修改";
                                nobj.pid = porjectId;
                                nobj.comment = "批量修改网关的经纬度";
                                nobj.page = "地图导航";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                //刷新，重置
                                wgarray = [];
                                wgdraw = false;
                                wgidlist = [];
                            }
                        }
                    }

                    //单灯修改经纬度
                    if (onedraw) {
                        if (lampchecck.Longitude != null && lampchecck.latitude != null) {
                            if (confirm(lans[288][lang])) {  //该设备已有经纬度了，您确定更改吗?
                                updateLamplnglat(e.point.lng, e.point.lat, lampchecck.id);
                                var allOver = map.getOverlays(); //获取全部标注
                                for (var j = 0; j < allOver.length; j++) {
                                    if (allOver[j].toString() == "[object Marker]") {
                                        if (allOver[j].getPosition().lng == lampchecck.Longitude && allOver[j].getPosition().lat == lampchecck.latitude) {
                                            map.removeOverlay(allOver[j]);
                                        }
                                    }
                                }
                            }
                        } else {
                            updateLamplnglat(e.point.lng, e.point.lat, lampchecck.id);
                        }
                        lampchecck = [];
                        onedraw = false;
                    }
                    if (draw) {
                        var obj3 = {};
                        obj3.x = e.point.lng;
                        obj3.y = e.point.lat;
                        array.push(obj3);
                        var now_point = new BMap.Point(e.point.lng, e.point.lat);
                        var marker2 = new BMap.Marker(now_point); //addMarker(now_point, myIcon, comaddr);
                        map.addOverlay(marker2); // 添加标注

                        if (array.length > 1) {
                            var polyline = new BMap.Polyline([
                                new BMap.Point(array[array.length - 2].x, array[array.length - 2].y), //起始点的经纬度
                                new BMap.Point(array[array.length - 1].x, array[array.length - 1].y)//终止点的经纬度
                            ], {strokeColor: "red", //设置颜色
                                strokeWeight: 3, //宽度
                                strokeOpacity: 0.5});//透明度
                            map.addOverlay(polyline);

                            if (confirm(lans[289][lang])) {  //你还要继续选点吗？

                            } else {
                                for (var i = 0; i < idlist.length; i++) {
                                    //alert("id:" + idlist[i] + "lng:" + array[i].x + "lat:" + array[i].y);
                                    updateMayLamplnglat(array[i].x, array[i].y, idlist[i]);
                                }
                                alert(lans[295][lang]); //配置经纬度成功
                                var nobj = {};
                                nobj.name = u_name;
                                var day = getNowFormatDate2();
                                nobj.time = day;
                                nobj.type = "修改";
                                nobj.pid = porjectId;
                                nobj.comment = "批量修改灯具的经纬度";
                                nobj.page = "地图导航";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                //刷新，重置
                                array = [];
                                draw = false;
                                idlist = [];
                            }
                        }
                    }
                });
            });


            //网关下拉框
            function combobox(id, pid) {
                $(id).combobox({
                    url: "login.map.getallcomaddr.action?pid=" + pid,
                    onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                        $(this).val(data[0].text);
                    }
                });
            }
        </script>
    </body>
</html>
