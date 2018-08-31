<%-- 
    Document   : lightval
    Created on : 2018-7-23, 7:54:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/genel.js"></script>
        <script>
            var websocket = null;
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function groupeLampValue(obj) {
                console.log(obj)
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {

                }

            }

            $(function () {

                $('#gravidaTable').bootstrapTable({
                    url: 'test1.lamp.Groupe.action',
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
                            field: 'name',
                            title: '网关名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_comaddr',
                            title: '网关地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'l_groupe',
                            title: '组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.toString();
                            }
                        },
                        {
                            field: 'l_value',
                            title: '调光值',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                //   var str = "<input type='text' value='abc' />";
                                console.log(value);
                                console.log(row);
                                var idval = "'" + "slide_lamp_val" + row.l_groupe.toString() + "'";
                                var str = "<div id=" + idval + " class='easyui-slider' style='width:150px'></div";
                                console.log(str);
//                                var str = " <div id='slide_lamp_val'  class='easyui-slider'    data-options='showTip:true,rule:[0,'|',25,'|',50,'|',75,'|',100],min:0,max:100,step:1' style='width:50px'></div>";
                                return  str;
                                //return  value.toString();
                            }
                        }],
                    singleSelect: false,
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

                        $('.easyui-slider').slider({
                            min: 0,
                            max: 100,
                            step: 1,
                            showTip: true
                        });

//                        var obj = $("#slide_lamp_val");
//                        console.log(obj);
//                        console.info("加载成功");
                    },

                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            l_deplayment: ""  
                        };      
                        return temp;  
                    },
                });



                $('#l_groupe').combobox({
                    onSelect: function (record) {
                        var obj = $("#tosearch").serializeObject();
                        obj.l_groupe = record.id;
                        obj.l_deplayment = 1;
                        console.log(obj);
                        var opt = {
                            url: "test1.lamp.Groupe.action",
                            silent: true,
                            query: obj
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });


                $('#l_comaddr').combobox({
                    onSelect: function (record) {
                        var obj = $("#tosearch").serializeObject();
                        obj.l_comaddr = record.id;
                        obj.l_deplayment = 1;
                        console.log(obj);
                        var opt = {
                            url: "test1.lamp.Groupe.action",
                            silent: true,
                            query: obj
                        };
                        $('#gravidaTable').bootstrapTable('refresh', opt);
                    }
                });



                $("#btn_groupe_lamp_val").click(function () {


//                    if (websocket.readyState != 1) {
//                        layerAler("服务端没连接上");
//                        return;
//                    }

                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler("请勾选分组数据");
                        return;
                    }
                    var vv = new Array();
                    var len = selects.length;
                    vv.push(len);
//                    var comaddr1=$("#")
                    var eleArray = new Array();
                    var comaddr1 = selects[0].l_comaddr;
                    for (var i = 0; i < selects.length; i++) {

                        var select = selects[i];
                        var groupe = select.l_groupe;
                        var l_groupe = parseInt(groupe, "10");
                        vv.push(l_groupe);
                        var valid = "#slide_lamp_val" + groupe;
                        var val = $(valid).slider("getValue");
                        vv.push(val);
                        eleArray.push(l_groupe);
                    }
                    var num = randnum(0, 9) + 0x70;
                    var sss = buicode(comaddr1, 0x04, 0xA5, num, 0, 302, vv); //01 03 F24  
                    var user = {};
                    user.begin = '6A'
                    user.len = sss.length;
                    user.data=sss;
                    var ele = {id: eleArray};
                    user.res = 1;
                    user.afn = 302;
                    user.status = "";
                    user.function = "groupeLampValue";
                    user.parama = ele;
                    user.msg = "A5";
                    user.addr = getComAddr(comaddr1); //"02170101";
                    user.end = '6A';
                    console.log(user);
                    var o1 = JSON.stringify(user);
                    websocket.send(o1);




                });


            })


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
                    console.log("onmessage");
                    var jsoninfo = JSON.parse(e.data);
                    console.log(jsoninfo);
                    if (jsoninfo.hasOwnProperty("function")) {
                        var vvv = jsoninfo.function;
                        var obj = jsoninfo.parama;
                        obj.status = jsoninfo.status;
                        obj.errcode = jsoninfo.errcode;
                        obj.frame = jsoninfo.frame;
                        window[vvv](obj);
                    }

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

        </script>
    </head>
    <body>
        <!--        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
                    <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj">
                        <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
                    </button>
                    <button class="btn btn-primary ctrol"   id="xiugai1">
                        <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
                    </button>
                    <button class="btn btn-danger ctrol" id="shanchu">
                        <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
                    </button>
                </div>-->


        <div style="width:100%;">

            <form id="tosearch">
                <table>
                    <tbody>
                        <tr>
                            <td>
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:10px;">网关地址&nbsp;</span>
                                <span class="menuBox">
                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 34px" 
                                           data-options="editable:true,valueField:'id', textField:'text',url:'test1.lamp.getComaddr.action' " />
                                </span>  
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:10px;">组号&nbsp;</span>
                                <span class="menuBox">
                                    <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:150px; height: 34px" 
                                           data-options="editable:true,valueField:'id', textField:'text',url:'test1.lamp.getGroupe.action' " />
                                </span>         
                            </td>
                            <td>
                                <!--                                <span style="margin-left:10px;">分组方式&nbsp;</span>
                                                                <span class="menuBox">
                                                                    <select name="l_groupe_type" id="l_comaddr_lamp"  class="input-sm" style="width:150px;">
                                                                        <option value="0">单灯调光</option>
                                                                        <option value="1">按组调光</option>
                                                                </span> -->
                            </td>
                            <td>
                                <!--<span style="margin-left:10px; padding-right: 10px;">立即调光:&nbsp;</span>-->
                            </td>

                            <td>

                                <!--<span style="margin-left:10px;">-->
                                <!--                                                                    <div   class="easyui-slider"    data-options="min:0,max:100,step:1" style="width:150px"></div>-->
                                <!--                                                                </span>-->

                            </td>
                            <td>
                                <button id="btn_groupe_lamp_val" type="button" style="margin-left:20px;" class="btn btn-success">按组调光</button>
                            </td>




                        </tr>


                    </tbody>
                </table>
            </form>
            <!--<div class="bootstrap-table">-->
            <!--<div class="fixed-table-container" style="height: 214px; padding-bottom: 0px;">-->     


            <table id="gravidaTable" style="width:100%;"  class="text-nowrap table table-hover table-striped">


            </table>
            <!--</div>-->
            <!--</div>-->
        </div>
    </body>
</html>
