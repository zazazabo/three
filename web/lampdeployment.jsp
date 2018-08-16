<%-- 
    Document   : deplayment
    Created on : 2018-7-4, 15:32:48
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
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            var websocket = null;
            function setLamp(obj) {
                console.log(obj)
                if (obj.status == "fail") {
                    if (obj.errcode == 2) {
                        layerAler("重复设备序号");
                        obj.l_deplayment = 1;
                        console.log(obj);
                        $.ajax({async: false, url: "test1.lamp.modifyDepayment.action", type: "get", datatype: "JSON", data: obj,
                            success: function (data) {
                                $("#lampTable").bootstrapTable('refresh');
                            },
                            error: function () {
                                alert("提交修改部署属性失败！");
                            }
                        });
                    } else if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {
                    if (obj.l_deplayment == 1) {
                        layerAler("移除成功");
                    } else if (obj.l_deplayment == 0) {
                        layerAler("部署成功");
                    }
                    obj.l_deplayment = 1 - obj.l_deplayment;

                    $.ajax({async: false, url: "test1.lamp.modifyDepayment.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            $("#lampTable").bootstrapTable('refresh');
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }

            }



            $(function () {


                $('#lampTable').bootstrapTable({
                    clickToSelect: true,
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
                            field: 'l_comaddr',
                            title: '所属网关',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: '通信地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_name',
                            title: '名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_code',
                            title: '装置序号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_worktype',
                            title: '控制方式',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                console.log(value);
                                if (value == 0) {
                                    value = "0(时间)";
                                    return value;
                                } else if (value == 1) {
                                    value = "1";
                                    return value;
                                }
                            }
                        }, {
                            field: 'l_groupe',
                            title: '组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  row.l_groupe;

                            }
                        }, {
                            field: 'l_deployment',
                            title: '部署情况',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.l_deplayment == "0") {
                                    var str = "<span class='label label-warning'>末部署</span>"
                                    return  str;
                                } else if (row.l_deplayment == "1") {
                                    var str = "<span class='label label-success'>已部署</span>"
                                    return  str;
                                }
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
                    },
                });

                $.ajax({
                    async: false,
                    url: "test1.lamp.comaddr.action",
                    type: "get",
                    datatype: "JSON",
                    data: {},
                    success: function (data) {
                        $("#l_comaddr_lamp").empty();
                        var arrlist = data.rs;
                        console.log(arrlist);
                        for (var i = 0; i < arrlist.length; i++) {
                            var objlist = arrlist[i];
                            var str = "<option value='" + objlist.comaddr + "'>" + objlist.comaddr + "</option>";
                            $("#l_comaddr_lamp").append(str); //添加option
                        }

                        var comaddr = $("#l_comaddr_lamp").children('option:selected').val();
                        console.log(comaddr);
                        var url = "test1.lamp.getlamp1.action?l_comaddr=" + comaddr;
                        console.log(url);
                        var opt = {url: url};
                        $('#lampTable').bootstrapTable('refresh', opt);
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

                $("#l_comaddr_lamp").change(function () {
                    var comaddr = $(this).children('option:selected').val();
                    var url = "test1.lamp.getlamp.action?l_comaddr=" + comaddr;
                    var opt = {
                        url: url
                    };
                    $('#gravidaTable').bootstrapTable('refresh', opt);
                })


                $("#btndeploylamp").click(function () {

                    if (websocket.readyState == 3) {
                        layerAler("服务端没连接上");
                        return;
                    }
                    var selects = $('#lampTable').bootstrapTable('getSelections');
                    var comaddr1 = $("#l_comaddr_lamp").val();
                    var select = selects[0];
                    console.log(select);

                    var vv = new Array();
                    if (selects.length == 0) {
                        layerAler("请勾选表格数据");
                        return;
                    }

                    if (select.l_deplayment == 1) {
                        layerAler("已经部署")
                        return;
                    }

                    for (var i = 0; i < selects.length; i++) {
                        if (selects[i].l_deplayment == "1") {
                            layerAler(selects[i] + "此装置已经部署过");
                            continue;
                        }
                        if (i == 0) {
                            var len = sprintf("%04d", selects.length);
                            var vvbyte = Str2BytesH(len);
                            vv.push(vvbyte[1]);
                            vv.push(vvbyte[0]);
                        }
                        var setcode = selects[i].l_code;
                        var factorycode = selects[i].l_factorycode;
                        var dd = get2byte(setcode);
                        var set1 = Str2BytesH(dd);
                        var factor = Str2BytesH(factorycode);
                        vv.push(set1[1]);
                        vv.push(set1[0]); //装置序号  2字节
                        vv.push(set1[1]);
                        vv.push(set1[0]); //测量点号  2字节 


                        vv.push(factor[5]); //通信地址
                        vv.push(factor[4]); //通信地址
                        vv.push(factor[3]); //通信地址
                        vv.push(factor[2]); //通信地址
                        vv.push(factor[1]); //通信地址
                        vv.push(factor[0]); //通信地址

                        var iworktype = parseInt(selects[i].l_worktype);
                        vv.push(iworktype); //工作方式

                        var igroupe = parseInt(selects[i].l_groupe); //组号
                        vv.push(igroupe); //组号
                    }
                    var num = randnum(0, 9) + 0x70;

                    var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 102, vv); //0320
                    var setelect = selects[0];
                    var ele = {id: setelect.uid, l_deplayment: select.l_deplayment};
                    var user = new Object();
                    user.res = 1;
                    user.afn = 102;
                    user.status = "";
                    user.function = "setLamp";
                    user.parama = ele;
                    user.msg = "setParam";
                    user.addr = getComAddr(comaddr1); //"02170101";
                    user.data = sss;
                    $datajson = JSON.stringify(user);
                    console.log(websocket.readyState);
                    console.log(user);
                    websocket.send($datajson);

                });
                $("#btnremovelamp").click(function () {

                    if (websocket.readyState == 3) {
                        layerAler("服务端没连接上");
                        return;
                    }
                    var selects = $('#lampTable').bootstrapTable('getSelections');
                    var comaddr1 = $("#l_comaddr_lamp").val();
                    console.log(selects);
                    var vv = new Array();
                    if (selects.length == 0) {
                        layerAler("请勾选表格数据");
                        return;
                    }
                    for (var i = 0; i < selects.length; i++) {
                        if (selects[i].l_deplayment == "0") {
                            layerAler("此装置已经移除");
                            continue;
                        }
                        if (i == 0) {
                            var len = sprintf("%04d", selects.length);
                            var lenbyte = Str2BytesH(len);
                            vv.push(lenbyte[1]);
                            vv.push(lenbyte[0]);
                        }
                        var setcode = selects[i].l_code;
                        var factorycode = selects[i].l_factorycode;
                        var dd = get2byte(setcode);
                        var set1 = Str2BytesH(dd);
                        var factor = Str2BytesH(factorycode);
                        vv.push(set1[1]);
                        vv.push(set1[0]); //装置序号  2字节
                        vv.push(0);
                        vv.push(0); //测量点号  2字节 


                        vv.push(factor[5]); //通信地址
                        vv.push(factor[4]); //通信地址
                        vv.push(factor[3]); //通信地址
                        vv.push(factor[2]); //通信地址
                        vv.push(factor[1]); //通信地址
                        vv.push(factor[0]); //通信地址

                        var iworktype = parseInt(selects[i].l_worktype);
                        vv.push(iworktype); //工作方式
                        var igroupe = parseInt(selects[i].l_groupe); //组号
                        vv.push(igroupe); //组号
                    }
                    var num = randnum(0, 9) + 0x70;
                    var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 102, vv); //0320
                    var select = selects[0];
                    var ele = {id: select.uid, l_deplayment: select.l_deplayment};
                    var user = new Object();
                    user.res = 1;
                    user.afn = 102;
                    user.status = "";
                    user.function = "setLamp";
                    user.parama = ele;
                    user.msg = "setParam";
                    user.res = 1;
                    user.addr = getComAddr(comaddr1); //"02170101";
                    user.data = sss;

                    $datajson = JSON.stringify(user);
                    console.log(websocket.readyState);
                    console.log(user);
                    websocket.send($datajson);
                });

                $('#gravidaTable').on("click-cell.bs.table", function (field, value, row, element) {
                    if (value == "l_plan") {
                        $.ajax({
                            url: "test1.loop.getPlan.action",
                            type: "get",
                            datatype: "JSON",
                            data: {p_code: row, p_attr: 0},
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    var jsonstr = arrlist[0].p_content;
                                    var obj = eval('(' + jsonstr + ')');
                                    if (obj.hasOwnProperty("loop")) {
                                        var val = obj.loop[0];
                                        var str = "闭合时间:" + val.start + "<br>断开时间:" + val.end;
                                        layer.alert(str, {
                                            icon: 6,
                                            offset: 'center'
                                        });
                                    }
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    }


                })

                $("#l_comaddr_lamp").change(function () {
                    var comaddr = $(this).children('option:selected').val();
                    var url = "test1.lamp.h1.action?l_comaddr=" + comaddr;
                    var opt = {
                        url: url
                    };
                    $('#gravidaTable').bootstrapTable('refresh', opt);
                })


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
        <div class="modal-body">
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
                                <select name="l_comaddr_lamp" id="l_comaddr_lamp" placeholder="回路" class="input-sm" style="width:150px;">
                            </span>    
                        </td>
                        <td> 
                            &nbsp;
                        </td>
                        <td>
                            <button id="btndeploylamp" class="btn btn-success">部署灯具</button>
                        </td>
                        <td> 
                            &nbsp;&nbsp;&nbsp;
                        </td>
                        <td>
                            <button id="btnremovelamp" class="btn btn-success">移除灯具</button>
                        </td>



                        <td>
                        </td>




                    </tr>


                </tbody>
            </table>
        </div>
        <table id="lampTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>



    </body>
</html>
