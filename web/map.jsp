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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <style type="text/css">
            body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";}
        </style>
        <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=Uppxai1CT7jTHF9bjKFx0WGTs7nCyHMr"></script>

    </head>
    <body>
        <!--<a style=" margin-left: 5px"></a>-->
        <!--        <div id="findSheBei" style="z-index: 0; position: absolute; right: 0px; top: 0px;">
                    <div class="findSheBei1 findSheBeis" style="width: 59px;">
                        <div class="imgShebeiLittle" style="background:url(imgs/mapSearch/eqp2.png) center center no-repeat;">
        
                        </div>
                        <div class="SheMess">网关</div>
        
                    </div>
                    <div class="findSheBei2 findSheBeis" style="width: 67px;">
                        <div class="imgShebeiLittle" style="background:url(imgs/mapSearch/maplight.jpg) center center no-repeat;">
        
                        </div><div class="SheMess">灯具</div>
        
                    </div>
                    <div class="findSheBei3 findSheBeis" style="width: 123px;">
                        <div class="imgShebeiLittle" style="background:url(imgs/mapSearch/mapGroup.png) center center no-repeat;"></div>
                        <div class="SheMess">分组</div>
                        <select id="group" style="float: left;width: 61px;margin-top: 10px;margin-left: 4px;">
                            <option value="">全部</option><option value="5ab89bf81d41ec4263e12ac4">第二组</option><option value="5b4806f21d41ec5474c3e952">233</option>
                        </select>
                    </div>
                    <div class="findSheBei5 findSheBeis">
                        <div class="imgShebeiLittle" style="background:url(imgs/mapSearch/mapLamppost.png) center center no-repeat;"></div>
                        <div class="SheMess">灯杆</div>
                    </div>
        
                </div>-->
        <div id="allmap">

        </div>
        <script type="text/javascript">
            // 百度地图API功能
            var map = new BMap.Map("allmap");    // 创建Map实例
            map.centerAndZoom(new BMap.Point(116.404, 39.915), 11);  // 初始化地图,设置中心点坐标和地图级别
            //添加地图类型控件
            map.addControl(new BMap.MapTypeControl({
                mapTypes: [
                    BMAP_NORMAL_MAP,
                    BMAP_HYBRID_MAP
                ]}));
            map.centerAndZoom("湛江", 15);          // 设置地图显示的城市 此项是必须设置的
            map.enableScrollWheelZoom(true);     //开启鼠标滚轮缩放


            var top_left_control = new BMap.ScaleControl({anchor: BMAP_ANCHOR_TOP_LEFT});// 左上角，添加比例尺
            var top_left_navigation = new BMap.NavigationControl();  //左上角，添加默认缩放平移控件
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

                var button1 = document.createElement("input");
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

                button3.onclick = function (e) {
                    $.ajax({async: false, url: "test1.map.queryData.action", type: "get", datatype: "JSON", data: {},
                        success: function (data) {
                            console.log(data);
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                var obj = arrlist[i];
                                var Longitude = obj.Longitude;
                                var latitude = obj.latitude;
                                if (Longitude != "" && latitude != "") {
                                    var point = new BMap.Point(Longitude, latitude);
                                    var marker1 = new BMap.Marker(point);
                                    map.addOverlay(marker1);
                                    map.panTo(point);
                                }
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }


                button2.onclick = function (e) {
                    var comaddr = $("#seartxt").val();
                    console.log(comaddr);
                    $.ajax({async: false, url: "test1.map.queryData.action", type: "get", datatype: "JSON", data: {comaddr: comaddr},
                        success: function (data) {
                            console.log(data);
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                var obj = arrlist[i];
                                var Longitude = obj.Longitude;
                                var latitude = obj.latitude;
                                if (Longitude != "" && latitude != "") {
                                    var point = new BMap.Point(Longitude, latitude);
                                    var marker1 = new BMap.Marker(point);
                                    map.addOverlay(marker1);
                                    map.panTo(point);
                                }
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }


                button4.onclick = function (e) {
                    $.ajax({async: false, url: "test1.map.queryLamp.action", type: "get", datatype: "JSON", data: {},
                        success: function (data) {
                            console.log(data);
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                var obj = arrlist[i];
                                var Longitude = obj.Longitude;
                                var latitude = obj.latitude;
                                if (Longitude != "" && latitude != "") {
                                    var point = new BMap.Point(Longitude, latitude);
                                    var marker1 = new BMap.Marker(point);
                                    map.addOverlay(marker1);
                                    map.panTo(point);
                                }
                            }
                        },
                        error: function () {
                            alert("提交失败！");

                        }
                    });
                }
                // 添加DOM元素到地图中
                map.getContainer().appendChild(div);
                // 将DOM元素返回
                return div;
            }
            // 创建控件
            var myZoomCtrl = new ZoomControl();
            // 添加到地图当中
            map.addControl(myZoomCtrl);



            var menu = new BMap.ContextMenu();
            var txtMenuItem = [
                {
                    text: '添加灯具',
                    callback: function () {
                        //alert("ddd");
                        // map.zoomIn()
                    }
                },
                {
                    text: '添加网关',
                    callback: function () {
                        // map.zoomOut()
                    }
                }
            ];
            for (var i = 0; i < txtMenuItem.length; i++) {
                menu.addItem(new BMap.MenuItem(txtMenuItem[i].text, txtMenuItem[i].callback, 100));
            }
            map.addContextMenu(menu);

        </script>
    </body>
</html>
