<%-- 
    Document   : table
    Created on : 2018-6-29, 17:48:10
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <style>
            .modal-body {
                position: relative;
                padding: 20px;
            }
        </style>

        <script type="text/javascript" src="js/genel.js"></script>

        <script>
            function isValidIP(ip) {
                var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
                return reg.test(ip);
            }
            var websocket = null;
            var vvvv = 0;
            var flag = null;
            function setsiteinfo(obj) {
                console.log(obj);
                var v1 = [];
                var num = randnum(0, 9) + 0x70;
                var data1 = buicode(obj.comaddr, 0x04, 0x00, num, 0, 1, v1); //01 03 F24    
                dealsend2("00", data1, 1, "", obj.comaddr, 0, 0, 0);
            }

            function getMessage(obj) {
                console.log("getMessage");
                console.log(obj);
                if (obj.hasOwnProperty("msg")) {
                    if (obj.msg = "getStatus" && obj.data == true) {
                        var trarr = $("#gravidaTable").find("tr"); //所有tr数组
                        var child = $(trarr[obj.row + 1]).children('td:eq(7)');
                        console.log(child);
                        if (child.length == 1) {
                            var jqimg = child.children();
                            if (jqimg.prop("tagName") == "IMG") {
                                jqimg.attr("src", "img/online1.png");
                            }
                        }
                    }
                }
            }

            function gettime(obj) {

                obj.id = obj.val;
                if (obj.status == "success") {
                    $.ajax({async: false, url: "param.param.updatetime.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                layerAler("读取换日时间成功");
                                var opt = {
                                    url: "test1.f5.h1.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#gravidaTable").bootstrapTable('refresh', opt);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }

            }
            function  getsite(obj) {
                obj.id = obj.val;
                console.log(obj.domain)

                if (obj.status == "success") {
                    $.ajax({async: false, url: "param.param.updatesite.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                layerAler("读取站点信息成功");
                                var opt = {
                                    url: "test1.f5.h1.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#gravidaTable").bootstrapTable('refresh', opt);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }

            }
            function getchgtime(obj) {
                console.log(obj)
                if (obj.status == "success") {
                    layerAler("设置换日时间和冻结时间成功");
                }
            }
            function getAPN(obj) {
                if (obj.status == "success") {
                    layerAler("设置运营商APN成功");
                }
            }
            function dealsend2(msg, data, fn, func, comaddr, type, param, val) {
                var user = new Object();
                user.begin = '6A';
                user.res = 1;
                user.status = "";
                user.comaddr = comaddr;
                user.fn = fn;
                user.function = func;
                user.param = param;
                user.page = 2;
                user.msg = msg;
                user.val = val;
                user.type = type;
                user.addr = getComAddr(comaddr); //"02170101";
                user.data = data;
                user.len = data.length;
                user.end = '6A';
                console.log(user);
                parent.parent.sendData(user);
            }






            $(function () {

                //flag = setInterval("dealsend()", 1000);

                $('#time4').timespinner('setValue', '00:00');
                $('#time3').timespinner('setValue', '00:00');
                $('#gravidaTable').bootstrapTable({
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
                            field: 'pid',
                            title: '所属项目',
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
                            field: 'dnsip',
                            title: '域名解析的IP',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value != null) {
                                    var str = value + ":" + row.dnsport.toString();
                                    return str;
                                }

                            },
                        }, {
                            field: 'siteip',
                            title: '主站ip',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value != null) {
                                    var str = value + ":" + row.siteport.toString();
                                    return str;
                                }
                            }
                        }, {
                            field: 'domain',
                            title: '域名',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'apn',
                            title: 'APN',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'chgdaytime',
                            title: '换日时间',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'flozetime',
                            title: '冻结时间',
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
                            },
                        }],
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
                        console.info("加载成功");
                        //                    console.log(websocket.readyState);
                        //                    if (websocket != null && websocket.readyState == 1) {
                        //
                        //                    }
                    },
                    url: 'test1.f5.h1.action',
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
                $("#gravidaTable").on('refresh.bs.table', function (data) {
                    // flag = setInterval("dealsend()", 1000);
                });
                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                });
            })

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function dealsend() {

                //            if (websocket != null && websocket.readyState == 1) {
                var allTableData = $("#gravidaTable").bootstrapTable('getData'); //获取表格的所有内容行
                if (allTableData.length > vvvv) {
                    var obj = allTableData[vvvv];
                    var addrArea = Str2Bytes(obj.comaddr);
                    var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrArea[3]) + sprintf("%02d", addrArea[2]);
                    var user = new Object();
                    var ele = {};
                    user.msg = "getStatus";
                    user.res = 1;
                    user.row = vvvv;
                    user.parama = ele;
                    user.page = 2;
                    user.function = "getMessage";
                    user.addr = straddr; //"02170101";
                    user.data = false;
                    parent.parent.sendData(user);
                    //  console.log(user);
                    // var datajson = JSON.stringify(user);
                    // websocket.send(datajson);
                    vvvv += 1;
                } else {
                    // clearInterval(flag);
                    vvvv = 0;
                }
            }

            function readsite() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length > 1) {
                    layerAler("只能选一条");
                    return;
                }
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }

                var select = selects[0];
                var comaddr = select.comaddr;
                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 1, vv); //01 03 F24    
                console.log(data);
                dealsend2("AA", data, 1, "getsite", comaddr, select.index, 0, select.id);
            }


            function readtime() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length > 1) {
                    layerAler("只能选一条");
                    return;
                }
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }
                var select = selects[0];
                var comaddr = select.comaddr;
                // 00 00 01 00 
                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 4, vv); //01 03 F24    

                console.log(data);
                dealsend2("AA", data, 4, "gettime", comaddr, select.index, 0, select.id);
            }

            function setsite() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }

                var obj = $("#form1").serializeObject();
                if (obj.port == "") {
                    layerAler("端口不能为空");
                    return;
                }
                if (obj.apn.length > 16) {
                    layerAler("apn长度不能超过16");
                    return;
                }
                if (isNumber(obj.port) == false) {
                    layerAler("端口不能为空");
                    return;
                }
                var hexport = parseInt(obj.port);
                var u1 = hexport >> 8 & 0x00ff;
                var u2 = hexport & 0x000ff;
                console.log(obj);
                var vv = [];
                if (isValidIP(obj.ip) == false) {
                    // layerAler("不是合法ip");
                    if (obj.ip != "") {
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(u2);
                        vv.push(u1);

                        for (var i = 0; i < 18; i++) {
                            vv.push(0);
                        }


                        for (var i = 0; i < 16; i++) {
                            var apn = obj.apn.trim();
                            var len = apn.length;
                            if (len <= i) {
                                vv.push(0);
                            } else {
                                var c = apn.charCodeAt(i);
                                vv.push(c);
                            }

                        }

                        var ip = obj.ip.trim();
                        var len = ip.length;
                        vv.push(len);
                        for (var i = 0; i < len; i++) {
                            var c = ip.charCodeAt(i);
                            vv.push(c);
                        }
                    }
                }

                if (isValidIP(obj.ip) == true) {
                    for (var i = 0; i < 12; i++) {
                        vv.push(0);
                    }
                    var iparr = obj.ip.split(".");
                    for (var i = 0; i < iparr.length; i++) {
                        vv.push(parseInt(iparr[i]));
                    }
                    vv.push(u2);
                    vv.push(u1);

                    for (var i = 0; i < 6; i++) {
                        vv.push(0);
                    }


                    for (var i = 0; i < 16; i++) {
                        var apn = obj.apn;
                        var len = apn.length;
                        if (len <= i) {
                            vv.push(0);
                        } else {
                            var c = apn.charCodeAt(i);
                            vv.push(c);
                        }

                    }

                    vv.push(0);
                }


                if (vv.length > 0) {
                    var select = selects[0];
                    var comaddr = select.comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 1, vv); //01 03 F24    

                    dealsend2("A4", data, 1, "setsiteinfo", comaddr, select.index, 0, select.id);

                }


            }

            function setchgtime() {


                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }

                var obj = $("#form1").serializeObject();
                var o4 = obj.time4;
                var o3 = obj.time3;
                var oo = {"o4": o4, "o3": o3};
                var a = o4.split(":");
                var b = o3.split(":");

                var h1 = parseInt(a[0], 16);
                var m1 = parseInt(a[1], 16);

                var h2 = parseInt(b[0], 16);
                var m2 = parseInt(b[1], 16);
                var vv = [];
                vv.push(h1);
                vv.push(m1);
                vv.push(h2);
                vv.push(m2);



                console.log(h1);
                console.log(m1);
                console.log(h2);
                console.log(m2);

                var select = selects[0];
                var comaddr = select.comaddr;

                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 4, vv); //01 03 F24    

                dealsend2("A4", data, 4, "getchgtime", comaddr, select.index, oo, select.id);





            }
            function setAPN() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }

                var obj = $("#form1").serializeObject();
                if (obj.apn == "") {
                    layerAler("apn不能为空");
                    return;
                }
                if (obj.apn.length > 16) {
                    layerAler("apn长度不能超过16");
                    return;
                }
                var vv = [];
                for (var i = 0; i < 16; i++) {
                    var apn = obj.apn;
                    var len = apn.length;
                    if (len <= i) {
                        vv.push(0);
                    } else {
                        var c = apn.charCodeAt(i);
                        vv.push(c);
                    }

                }
                console.log(vv);
                //            console.log(obj);
                var select = selects[0];
                var comaddr = select.comaddr;
                //
                //
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 2, vv); //01 03 F24    
                dealsend2("A4", data, 4, "getAPN", comaddr, select.index, apn, select.id);
            }

            function setinspectcb(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler("灯具通信失联巡检次数成功");
                }
                if (obj.status == "fail") {
                    layerAler("灯具通信失联巡检次数失败");
                }
            }
            function setinspect() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }
                var obj = $("#form1").serializeObject();
                var o = obj.inspect;
                if (o == "") {
                    layerAler("请填写巡检次数");
                    return;
                }
                var vv = [];
                vv.push(parseInt(o));


                //            console.log(obj);
                var select = selects[0];
                var comaddr = select.comaddr;
                //
                //
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 202, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setinspectcb", comaddr, select.index, apn, select.id);
            }

            function readinspectcb(obj) {
                console.log(obj);
            }
            function readinspect() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }
                var vv = [];

                var select = selects[0];
                var comaddr = select.comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 202, vv); //01 03 F24    
                dealsend2("AA", data, 4, "readinspectcb", comaddr, select.index, apn, select.id);
            }


        </script>
    </head>
    <body>


        <!--    <div class="panel panel-success" >
                <div class="panel-heading">
                    <h3 class="panel-title">网关参数设置</h3>
                </div>-->
        <!--        <div class="panel-body" >-->
        <div class="container"  >

            <form id="form1">
                <div class="row">
                    <div class="col-xs-4">

                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                            <tbody>
                                <tr>
                                    <td>
                                        <span class="label label-success " style=" float: right; margin-right: 2px;" >主站ip或域名</span>
                                    </td>
                                    <td>
                                        <input id="ip" class="form-control" name="ip"  style="width:150px; " placeholder="输入主站域名" type="text">
                                    </td>
                                </tr>

                                <tr >
                                    <td>
                                        <span class="label label-success" style=" float: right; margin-right: 2px;" >端口</span>
                                    <td>

                                        <input id="port" class="form-control" name="port" style="width:150px;"  placeholder="输入端口" type="text">
                                    </td>

                                </tr>                                   

                                <tr>
                                    <td>
                                        <span class="label label-success" style=" float: right; margin-right: 2px;" >运营商APN</span>
                                    </td>

                                    <td >
                                        <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;" placeholder="输入APN" type="text">
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <button type="button"  onclick="setsite()" class="btn  btn-success btn-xs" style="margin-left: 2px;">设置主站信息</button>
                                        <button  type="button" onclick="readsite()" class="btn btn-success btn-xs">读取主站信息 </button>
                                        <button  type="button"  onclick="setAPN()" class="btn btn-success btn-xs">设置运营商APN </button>
                                    </td>

                            </tbody>
                        </table>



                    </div>
                    <div class="col-xs-3">

                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                            <tbody>
                                <tr>
                                    <td>
                                        <span class="label label-success " style=" float: right; margin-right: 2px;" >换日时间</span>
                                    </td>
                                    <td>
                                        <input id="time4" name="time4" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                                    </td>
                                </tr>

                                <tr >
                                    <td>
                                        <span class="label label-success" style=" float: right; margin-right: 2px;" >冻结时间</span>
                                    <td>

                                        <input id="time3" name="time3" style=" height: 34px; width: 150px;"  class="easyui-timespinner">
                                    </td>

                                </tr>                                   

                                <tr>
                                    <td colspan="2">
                                        <button style="margin-left: 2px;"  type="button" onclick="setchgtime()" class="btn btn-success btn-xs">设置换日冻结时间</button>

                                        <button  type="button" onclick="readtime()" class="btn btn-success btn-xs">读取换日冻结时间</button>

                                    </td>

                            </tbody>
                        </table>
                    </div>
                    <div class="col-xs-3">


                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                            <tbody>
                                <tr>
                                    <td>

                                        <span class="label label-success " style=" float: right; margin-right: 2px;" >通信巡检次数</span>
                                    </td>
                                    <td>

                                        <input id="inspect" class="form-control" name="inspect" value="" style="width:150px;" placeholder="灯具通信失联巡检次数" type="text">
                                    </td>
                                </tr>



                                <tr>
                                    <td colspan="2">
                                        <button  type="button" style="margin-left:20px;" onclick="setinspect()" class="btn btn-success btn-xs">设置巡检次数</button>
                                        <button  type="button" style="margin-left:20px;" onclick="readinspect()" class="btn btn-success btn-xs">读取巡检次数</button>
                                    </td>

                            </tbody>
                        </table>
                    </div>


                </div>

            </form>


            <!--                
                    
                    <div class="row" style=" margin-top: 3px;">
                        <div class="col-xs-1" >
                            <span class="label label-success" >主站ip或域名</span>
        
                        </div>
                        <div class="col-xs-2">
        
                            <input id="ip" class="form-control" name="ip" style=" width: 150px; "  placeholder="输入主站域名" type="text">
        
                        </div>
                        <div class="col-xs-1"> 
                            <span class="label label-success" style="margin-left: 10px;" >端口</span>
        
        
                        </div>
                        <div class="col-xs-2">
                            <input id="port" class="form-control" name="port" style="width:150px;" value="18414" placeholder="输入端口" type="text">
                        </div>
                        <div class="col-xs-1">
                            <span class="label label-success" style="margin-left: 10px;" >APN</span>
                        </div>
                        <div class="col-xs-2">
                            <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入APN" type="text">
                        </div>
                        <div class="col-xs-1" >
                            <button  type="button"  onclick="setsite()" class="btn btn-success" >设置主站信息</button>
                        </div>
                        <div class="col-xs-1" >
                            <button  type="button"  onclick="readsite()" class="btn btn-success" >读取主站信息 </button>
                        </div>
                        <div class="col-xs-1">
                            <button  type="button"  onclick="setAPN()" class="btn btn-success" >设置APN </button>
                        </div>
        
                    </div>
                  
                    <div class="row" style=" margin-top: 3px;">
                        <div class="col-xs-1" >
        
                            <span class="label label-success" >&nbsp;&nbsp;换日时间</span>
                        </div>
                        <div class="col-xs-2">
                            <input id="time4" name="time4" style=" height: 34px; width: 150px; "  class="easyui-timespinner">
                        </div>
                        <div class="col-xs-1"> 
                            <span class="label label-success" style="margin-left: 10px;" >冻结时间</span>
        
        
                        </div>
                        <div class="col-xs-2">
                            <input id="time3" name="time3" style=" height: 34px; width: 150px;"  class="easyui-timespinner">
                        </div>
                        <div class="col-xs-1">
        
                        </div>
                        <div class="col-xs-2">
        
                        </div>
                        <div class="col-xs-1" >
                            <button  type="button" style="margin-left:20px;" onclick="setchgtime()" class="btn btn-success">设置换日冻结时间</button>
                        </div>
                        <div class="col-xs-1">
        
                        </div>
                        <div class="col-xs-1">
                            <button  type="button" style="margin-left:20px;" onclick="readtime()" class="btn btn-success">读取换日冻结时间</button>
                        </div>
        
                    </div>
        
        
                    <div class="row" style=" margin-top: 3px;">
                        <div class="col-xs-1" >
                            <span class="label label-success" style="margin-left: 10px;" >通信巡检次数</span>
        
                        </div>
                        <div class="col-xs-2">
                            <input id="inspect" class="form-control" name="inspect" value="" style="width:150px;" placeholder="灯具通信失联巡检次数" type="text">
                        </div>
                        <div class="col-xs-1"> 
        
        
        
                        </div>
                        <div class="col-xs-2">
        
                        </div>
                        <div class="col-xs-1">
        
                        </div>
                        <div class="col-xs-2">
        
                        </div>
                        <div class="col-xs-1" >
                            <button  type="button" style="margin-left:20px;" onclick="setinspect()" class="btn btn-success">设置巡检次数</button>
                        </div>
                        <div class="col-xs-1">
        
                        </div>
                        <div class="col-xs-1">
                            <button  type="button" style="margin-left:20px;" onclick="readinspect()" class="btn btn-success">读取巡检次数</button>
                        </div>
        
                    </div>    -->





        </div>
        <!--        </div>
            </div>-->




        <!--<form id="form1">-->
        <!--        
                <table>
                    <tbody>
        
                        <tr>
                            <td><span class="label label-success" style="margin-left: 10px;" >主站ip或域名</span></td>
                            <td>
                                &nbsp; <input id="ip" class="form-control" name="ip" value="103.46.128.47" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入主站域名" type="text">
                            </td>
                            <td><span class="label label-success" style="margin-left: 10px;" >端口</span></td>
                            <td>
                                <input id="port" class="form-control" name="port" style="width:150px;display: inline; margin-left: 3px;" value="18414" placeholder="输入端口" type="text">
                            </td>
                            <td><span class="label label-success" style="margin-left: 10px;" >APN</span></td>
                            <td>
                                <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入APN" type="text">
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="setsite()" class="btn btn-success">设置主站信息</button>
                            </td>
                            <td> <button  type="button" style="margin-left:20px;" onclick="readsite()" class="btn btn-success">读取主站信息 </button></td>
                            <td> <button  type="button" style="margin-left:20px;" onclick="setAPN()" class="btn btn-success">设置运营商APN </button></td>
                        </tr>
                    </tbody>
                </table>
        
        
                <table  style=" margin-top: 10px;">
                    <tbody>
                        <tr >
                            <td><span class="label label-success" style="margin-left: 10px;" >换日时间参数</span></td>
                            <td>
                                &nbsp;
        
                                <input id="time4" name="time4" style=" height: 34px; width: 150px; margin-left: 20px;"  class="easyui-timespinner">
                            </td>
                            <td><span class="label label-success" style="margin-left: 10px;" >冻结时间</span></td>
                            <td>
                                &nbsp;
        
                                <input id="time3" name="time3" style=" height: 34px; width: 130px; margin-left: 20px;"  class="easyui-timespinner">
                            </td>
                            <td></td>
                            <td>
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="setchgtime()" class="btn btn-success">设置换日冻结时间</button>
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="readtime()" class="btn btn-success">读取换日冻结时间</button>
                            </td>
                        </tr> 
                    </tbody>
                </table>
        
        
        
                <table  style=" margin-top: 10px;">
                    <tbody>
                        <tr >
                            <td><span class="label label-success" style="margin-left: 10px;" >通信巡检次数</span></td>
                            <td>
                                &nbsp;  <input id="inspect" class="form-control" name="inspect" value="" style="width:150px;display: inline; margin-left: 3px;" placeholder="灯具通信失联巡检次数" type="text">
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="setinspect()" class="btn btn-success">设置巡检次数</button>
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="readinspect()" class="btn btn-success">读取巡检次数</button>
                            </td>
                        </tr> 
                    </tbody>
                </table>
        -->



        <!--</form>-->

        <div style="width:100%; margin-top: 10px;">

            <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
            </table>
        </div>


        <!-- 添加 -->

        <!-- 修改 -->

    </body>
</html>
