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

        </style>
        <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Uppxai1CT7jTHF9bjKFx0WGTs7nCyHMr"></script>
        <script type="text/javascript" src="js/getdate.js"></script>

    </head>
    <body>
        <div id="allmap">

        </div>
        <!-- 添加 网关-->
        <div  id="addwanguang" style="display: none;">
            <div class="">
                <div  style="min-width:700px;">
                    <br/>

                    <form  id="Form_comaddr">      
                        <div class="">
                            <table>
                                <tbody class="search">
                                    <tr>
                                        <td>
                                            <span style="margin-left:50px;">所属区划</span>&nbsp;
                                            <select name="qh" id="qh"  style="width:150px; height: 30px;">
                                                <option value="1">广东</option>
                                                <option value="2">福建</option>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:70px;">网关名称&nbsp;</span>
                                            <input type="text" id="name" style="width:150px; height: 30px;" >
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="margin-left:50px;">所属项目</span>&nbsp;
                                            <input id="project" class="easyui-combobox" name="up_role" style="width:150px; height: 34px" data-options="editable:true,valueField:'id', textField:'text',url:'login.map.getProject.action'" />
                                        <td></td>
                                        <td>
                                            <span style="margin-left:70px;">所属网关&nbsp;</span>
                                            <input id="comaddrlist" class="easyui-combobox" name="up_role" style="width:150px; height: 34px" data-options="editable:true,valueField:'comaddr', textField:'comaddr',url:'login.map.getallcomaddr.action'"/>
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
                        <!--                        注脚 -->
                        <div class="modal-footer" >
                            <!-- 搜索按钮 -->
                            <button id="tianjia1" type="button" class="btn btn-primary" onclick="getInfoByComaddr()">搜索</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" onclick="closeAddComaddr()">关闭</button></div>
                    </form>
                </div>
            </div>
        </div>
        <!--添加灯具-->
        <div  id="addlamp" style="display: none;">
            <div class="">
                <div  style="min-width:700px;">
                    <form  id="Form_comaddr">      
                        <div class="">
                            <table>
                                <tbody class="search">
                                    <tr>
                                        <td>
                                            <span style="margin-left:50px;">所属区划</span>&nbsp;
                                            <select name="qh" id="qh"  style="width:150px;">
                                                <option value="1">广东</option>
                                                <option value="2">福建</option>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:70px;">所属机构&nbsp;</span>
                                            <select name="sex" id="sex"  style="width:150px;">
                                                <option value="1">华明科技</option>
                                                <option value="2">华明科技</option>
                                            </select> 
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="margin-left:50px;">所属项目</span>&nbsp;
                                            <select name="sex" id="sex"  style="width:150px;">
                                                <option value="1">华明光电</option>
                                                <option value="2">华明科技</option>
                                            </select>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:70px;">所属网关&nbsp;</span>
                                            <select name="comaddr" id="comaddrlist2"  style="width:150px;">

                                            </select>
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
                        <!--                        注脚 -->
                        <div class="modal-footer">
                            <!---->
                            <button  type="button" class="btn btn-primary" onclick="Drawing()">选点绘线</button>
                            <!-- 搜索按钮 -->
                            <button id="tianjia1" type="button" class="btn btn-primary" onclick="">搜索</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" onclick="lampout()">关闭</button></div>
                    </form>
                </div>
            </div>
        </div>

        <script type="text/javascript">
            //调用父页面的方法获取用户名
            var u_name = parent.getusername();

            //加载所有灯具信息
            function  getAllLampInfo() {
                $('#lamptable').bootstrapTable({
                    url: 'login.map.lamp.action',
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
                            title: '灯具名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_comaddr',
                            title: '所属网关',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'Longitude',
                            title: '经度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: '纬度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }],
                    singleSelect: false, //设置单选还是多选，true为单选 false为多选
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    minimumCountColumns: 7, //最少显示多少列
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
                $('#wgtable').bootstrapTable({
                    url: 'login.map.map.action',
                    columns: [
                        {
                            title: '单选',
                            field: 'select',
                            //复选框
                            checkbox: true,
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                        }, {
                            field: 'model',
                            title: '型号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'name',
                            title: '名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'comaddr',
                            title: '通信地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'Longitude',
                            title: '经度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: '纬度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'online',
                            title: '在线状态',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                return "<img  src='img/off.png'/>"; //onclick='hello()'

                            }
                        }],
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    minimumCountColumns: 7, //最少显示多少列
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
            //加载所属网关
            function getComaddr(tagId) {
                $.ajax({async: false, url: "login.map.getallcomaddr.action", type: "get", datatype: "JSON",
                    success: function (data) {
                        console.log(data);
                        if (data.rs != null) {

                            var options = "<option value=\"0\">请选择</option>";
                            for (var i = 0; i < data.rs.length; i++) {
                                options += "<option value=\"" + data.rs[i].comaddr + "\">" + data.rs[i].comaddr + "</option>";
                            }
                            $(tagId).html(options);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            //根据所属网关查询网关信息
            function getInfoByComaddr() {
                var comaddr = $("#comaddrlist").val();
                var name = $("#name").val();
                var poject = $("#project").val();
                var obj = {};
                if (comaddr != "") {
                    obj.comaddr = comaddr;
                }
                if (name != "") {
                    obj.name = name;
                }
                if (poject != "") {
                    obj.pid = poject;
                }

                var opt = {
                    method: "post",
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
            var map = new BMap.Map("allmap"); // 创建Map实例
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
                button2.setAttribute("value", "搜索");
                button2.setAttribute("style", "margin-left: 5px");
                button2.setAttribute("id", "search");
                div.appendChild(button2);
                var button3 = document.createElement("input");
                button3.setAttribute("type", "button");
                button3.setAttribute("value", "网关");
                button3.setAttribute("style", "margin-left: 5px");
                button3.setAttribute("id", "jzq");
                div.appendChild(button3);
                var button4 = document.createElement("input");
                button4.setAttribute("type", "button");
                button4.setAttribute("value", "灯具");
                button4.setAttribute("style", "margin-left: 5px");
                button4.setAttribute("id", "dj");
                div.appendChild(button4);

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
                    $.ajax({async: false, url: "login.map.lnglat.action", type: "get", datatype: "JSON", data: {},
                        success: function (data) {
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                var obj = arrlist[i];
                                var Longitude = obj.Longitude;
                                var latitude = obj.latitude;
                                var comaddr = obj.comaddr;
                                if (Longitude != "" && latitude != "") {
                                    var point = new BMap.Point(Longitude, latitude);
                                    var marker1 = new BMap.Marker(point);
                                    marker1.setTitle(comaddr);   //这里设置maker的title (鼠标放到marker点上,会出现它的title,所以我这里把name,放到title里)
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
                //
                button2.onclick = function (e) {
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
                    var comaddr = $("#seartxt").val();
                    $.ajax({async: false, url: "test1.map.queryData.action", type: "get", datatype: "JSON", data: {comaddr: comaddr},
                        success: function (data) {
                            console.log(data);
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                for (var i = 0; i < arrlist.length; i++) {
                                    var obj = arrlist[i];
                                    var Longitude = obj.Longitude;
                                    var latitude = obj.latitude;
                                    if (Longitude != "" && latitude != "") {
                                        var point = new BMap.Point(Longitude, latitude);
                                        var marker1 = new BMap.Marker(point);
                                        marker1.setTitle(obj.comaddr);   //这里设置maker的title (鼠标放到marker点上,会出现它的title,所以我这里把name,放到title里)
                                        map.addOverlay(marker1);
                                        map.panTo(point);
                                    }
                                }
                            } else {
                                alert("不存在该网关");
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
                    //map.removeOverlay(allOver);
                    $.ajax({async: false, url: "login.map.queryLamp.action", type: "get", datatype: "JSON", data: {},
                        success: function (data) {

                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                (function (x) {
                                    var obj = arrlist[i];
                                    var Longitude = obj.Longitude;
                                    var latitude = obj.latitude;
                                    var s = obj.l_name;
                                    var textvalue = "<div style='line-height:1.8em;font-size:12px;'>\n\
                                   \n\
                                    <table style='text-align:center'>\n\
                                        <tr>\n\
                                            <td>亮度:</td>\n\
                                            <td>" + arrlist[i].l_code + "</td>\n\
                                            <td></td>\n\
                                            <td>名称:</td>\n\
                                            <td>" + arrlist[i].l_name + "</td>\n\
                                        </tr>\n\
                                        <tr>\n\
                                            <td>控制器地址:</td>\n\
                                            <td>" + arrlist[i].l_factorycode + "</td>\n\
                                             <td>&nbsp&nbsp</td>\n\
                                            <td>网关地址:</td>\n\
                                            <td>" + arrlist[i].l_comaddr + "</td>\n\
                                        </tr>\n\ \n\
                                        <tr>\n\
                                            <td>在线情况:</td>\n\
                                            <td>--</td>\n\
                                             <td>&nbsp&nbsp</td>\n\
                                            <td>状态:</td>\n\
                                            <td>--</td>\n\
                                        </tr>\n\ \n\
                                    </table></div>";
                                    if (Longitude != "" && latitude != "") {
                                        var point = new BMap.Point(Longitude, latitude);
                                        var marker1 = new BMap.Marker(point);
                                        var opts = {title: '<span style="font-size:14px;color:#0A8021">信息说明</span>', width: 300, height: 120, };//设置信息框
                                        var infoWindow = new BMap.InfoWindow(textvalue, opts); // 创建信息窗口对象，引号里可以书写任意的html语句。
                                        marker1.addEventListener("mouseover", function () {
                                            this.openInfoWindow(infoWindow);
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
                // 添加DOM元素到地图中
                map.getContainer().appendChild(div);
                // 将DOM元素返回
                return div;
            };
            var txtMenuItem = [
                {
                    text: '添加灯具',
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
                        //加载所属网关
                        var tagid = "#comaddrlist2";
                        getComaddr(tagid);
                        //加载所有灯具信息
                        getAllLampInfo();
                        layer.open({
                            type: 1,
                            closeBtn: 1,
                            shade: false,
                            title: ['添加灯具', 'font-size:18px;'], //显示标题
                            content: $('#addlamp'), //显示内容
                            area: ['700px', '600px'] //设置宽高
                                    // move: '#addlamp'

                        });


                    }
                },
                {
                    text: '添加网关',
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
                        getAllInfo();
                        //加载所属网关
                        var tagid = "#comaddrlist";
                        getComaddr(tagid);
                        layer.open({
                            type: 1,
                            shade: false,
                            title: ['添加网关', 'font-size:18px;'], //显示标题
                            content: $('#addwanguang'), //显示内容
                            shadeClose: true, //右上角显示X
                            area: ['700px', '600px'] //设置宽高
                                    // move: '#addwanguang'
                                    //move: 'true' //是否可以拖动，默认可以拖动
                                    //moveOut: true
                        });
                        // $("#addwanguang").draggable({axis:null,handle:'#addwanguang'});
                    }
                }
            ];
            //选点绘线
            var draw = false;   //标记是否绘线
            var idlist = new Array();  //标记选中的id
            function  Drawing() {
                var lampchecck2 = $("#lamptable").bootstrapTable('getSelections');
                if (String(lampchecck2) != "") {   //选中数据列
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
                        layer.close(layer.index);
                    } else {
                        alert("请选择您要配置经纬度的设备!并且至少两个!");
                    }
                }
            }
            $(function () {
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
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.comaddr = comaddr;
                    $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var nobj = {};
                                nobj.name = u_name;
                                var day = getNowFormatDate2();
                                nobj.time = day;
                                nobj.comment = "修改网关" + obj.comaddr + "的经纬度";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                $("#wgtable").bootstrapTable('refresh');
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
                                    if (confirm("该设备已有经纬度了，您确定更改么?")) {
                                        var obj2 = {};
                                        obj2.Longitude = x;
                                        obj2.latitude = y;
                                        obj2.comaddr = e.target.getLabel().content; //获取标注隐藏的值
                                        $.ajax({url: "login.map.updatelnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                            success: function (data) {
                                                var arrlist = data.rs;
                                                if (arrlist.length == 1) {
                                                    $("#wgtable").bootstrapTable('refresh');

                                                } else {
                                                    alert("修改失败");
                                                }
                                            },
                                            error: function () {
                                                alert("提交添加失败！");
                                            }
                                        });
                                    }

                                });
                            } else {
                                alert("修改失败");
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
                    var obj = {};
                    obj.Longitude = lng;
                    obj.latitude = lat;
                    obj.id = id;
                    $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var nobj2 = {};
                                nobj2.name = u_name;
                                var day = getNowFormatDate2();
                                nobj2.time = day;
                                nobj2.comment = "批量单灯具的经纬度";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj2,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                $("#lamptable").bootstrapTable('refresh');
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
                                    if (confirm("该设备已有经纬度了，您确定更改么?")) {
                                        var obj2 = {};
                                        obj2.Longitude = x;
                                        obj2.latitude = y;
                                        obj2.id = e.target.getLabel().content; //获取标注隐藏的值
                                        $.ajax({url: "login.map.updateLamplnglat.action", async: false, type: "get", datatype: "JSON", data: obj2,
                                            success: function (data) {
                                                var arrlist = data.rs;
                                                if (arrlist.length == 1) {
                                                    $("#lamptable").bootstrapTable('refresh');
                                                } else {
                                                    alert("修改失败");
                                                }
                                            },
                                            error: function () {
                                                alert("提交添加失败！");
                                            }
                                        });
                                    }

                                });
                            } else {
                                alert("修改失败");
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                }
                //给地图添加点击事件
                var array = [];   //存储排练标注的经纬度数组
                map.addEventListener("click", function (e) {
                    var isboole = false; //判断弹出框是否选中数据
                    var comaddr; //存储选中数据的通信地址
                    var lng; //经度
                    var lat; //纬度
                    //网关的修改
                    $("#wgtable input:checkbox").each(function () {
                        if ($(this).is(":checked")) {
                            comaddr = $(this).parent().next().next().next().text();
                            lng = $(this).parent().next().next().next().next().text();
                            lat = $(this).parent().next().next().next().next().next().text();
                            isboole = true;
                        }
                    });
                    if (isboole) {
                        if (lng != null && lat != null) {
                            if (confirm("该设备已有经纬度了，您确定更改么?")) {
                                updatelnglat(e.point.lng, e.point.lat, comaddr);
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
                            updatelnglat(e.point.lng, e.point.lat, comaddr);
                        }
                    }
                    //灯具tabl
                    var lampchecck;  //灯具选中对象
                    $("#lamptable input:checkbox").each(function () {
                        lampchecck = $("#lamptable").bootstrapTable('getSelections');
                    });
                    if (String(lampchecck) == "[object Object]") {
                        if (lampchecck.length == 1) {
                            if (lampchecck[0].Longitude != null && lampchecck[0].latitude != null) {
                                if (confirm("该设备已有经纬度了，您确定更改么?")) {
                                    updateLamplnglat(e.point.lng, e.point.lat, lampchecck[0].id);
                                    var allOver = map.getOverlays(); //获取全部标注
                                    for (var j = 0; j < allOver.length; j++) {
                                        if (allOver[j].toString() == "[object Marker]") {
                                            if (allOver[j].getPosition().lng == lampchecck[0].Longitude && allOver[j].getPosition().lat == lampchecck[0].latitude) {
                                                map.removeOverlay(allOver[j]);
                                            }
                                        }
                                    }
                                }
                            } else {
                                updateLamplnglat(e.point.lng, e.point.lat, lampchecck[0].id);
                            }
                        } else if (lampchecck.length > 1) {
                            //alert(">1");
                        }
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

                            if (confirm("你还要继续选点吗？")) {

                            } else {

                                for (var i = 0; i < idlist.length; i++) {
                                    //alert("id:" + idlist[i] + "lng:" + array[i].x + "lat:" + array[i].y);
                                    updateMayLamplnglat(array[i].x, array[i].y, idlist[i]);
                                }
                                alert("配置经纬度成功！");
                                var nobj = {};
                                nobj.name = u_name;
                                var day = getNowFormatDate2();
                                nobj.time = day;
                                nobj.comment = "批量修改灯具的经纬度";
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
            }



            );
        </script>

    </body>
</html>
