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

            .btn { margin-left: 20px;}
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

            function readTrueTimeCB(obj) {
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {

                        v = v + sprintf("%02x", data[i]) + " ";
                    }

                    var yh = data[23] >> 4 & 0x0F;
                    var yl = data[23] & 0x0F;
                    var mh = data[22] >> 4 & 0x03;
                    var ml = data[22] & 0x0F;
                    var dh = data[21] >> 4 & 0x0F;
                    var dl = data[21] & 0x0F;
                    var hh = data[20] >> 4 & 0x0F;
                    var hl = data[20] & 0x0F;
                    var minh = data[19] >> 4 & 0x0F;
                    var minl = data[19] & 0x0F;
                    var sh = data[18] >> 4 & 0x0F;
                    var sl = data[18] & 0x0F;
                    var y = sprintf("%d%d", yh, yl);
                    var m = sprintf("%d%d", mh, ml);
                    var d = sprintf("%d%d", dh, dl);
                    var h = sprintf("%d%d", hh, hl);
                    var min = sprintf("%d%d", minh, minl);
                    var s = sprintf("%d%d", sh, sl);
                    var timestr = sprintf("%s-%s-%s %s:%s:%s", y, m, d, h, min, s);
                    $("#gaytime").val(timestr);
                    console.log(timestr);
                }

            }
            function readTrueTime() {
                var o1 = $("#form1").serializeObject();
                var vv = [];
                var l_comaddr = o1.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 1, vv); //01 03
                dealsend2("AC", data, 1, "readTrueTimeCB", l_comaddr, 0, 0, 0);
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
            function  setchgtimeCB(obj) {
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
            function setAPNCB(obj) {
                if (obj.status == "success") {
                    layerAler("设置运营商APN成功");
                }
            }


            $(function () {

                //flag = setInterval("dealsend()", 1000);

                $('#time4').timespinner('setValue', '00:00');
                $('#time3').timespinner('setValue', '00:00');

//                $('#gravidaTable').bootstrapTable({
//                    columns: [
//                        {
//                            title: '单选',
//                            field: 'select',
//                            //复选框
//                            checkbox: true,
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'pid',
//                            title: '所属项目',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'comaddr',
//                            title: '通信地址',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'dnsip',
//                            title: '域名解析的IP',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle',
//                            formatter: function (value, row, index) {
//                                if (value != null) {
//                                    var str = value + ":" + row.dnsport.toString();
//                                    return str;
//                                }
//
//                            },
//                        }, {
//                            field: 'siteip',
//                            title: '主站ip',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle',
//                            formatter: function (value, row, index) {
//                                if (value != null) {
//                                    var str = value + ":" + row.siteport.toString();
//                                    return str;
//                                }
//                            }
//                        }, {
//                            field: 'domain',
//                            title: '域名',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'apn',
//                            title: 'APN',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'chgdaytime',
//                            title: '换日时间',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'flozetime',
//                            title: '冻结时间',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }, {
//                            field: 'online',
//                            title: '在线状态',
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle',
//                            formatter: function (value, row, index) {
//                                return "<img  src='img/off.png'/>"; //onclick='hello()'
//                            },
//                        }],
//                    singleSelect: true,
//                    sortName: 'id',
//                    locale: 'zh-CN', //中文支持,
//                    showColumns: true,
//                    sortOrder: 'desc',
//                    pagination: true,
//                    sidePagination: 'server',
//                    pageNumber: 1,
//                    pageSize: 5,
//                    showRefresh: true,
//                    showToggle: true,
//                    // 设置默认分页为 50
//                    pageList: [5, 10, 15, 20, 25],
//                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
//                        //                    console.log(websocket.readyState);
//                        //                    if (websocket != null && websocket.readyState == 1) {
//                        //
//                        //                    }
//                    },
//                    url: 'test1.f5.h1.action',
//                    //服务器url
//                    queryParams: function (params)  {   //配置参数     
//                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
//                            search: params.search,
//                            skip: params.offset,
//                            limit: params.limit,
//                            type_id: "1"   
//                        };      
//                        return temp;  
//                    },
//                });
//                $("#gravidaTable").on('refresh.bs.table', function (data) {
//                    // flag = setInterval("dealsend()", 1000);
//                });
//                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
//                    var index = row.data('index');
//                    value.index = index;
//                });
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

            function setsiteCB(obj) {

            }



            function setSite() {
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

                if (obj.sitetype == "1") {
                    if (isValidIP(obj.ip) == false) {
                        layerAler("不是合法ip");
                        return;
                    }
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


                } else if (obj.sitetype == "0") {
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
                    var comaddr = obj.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 1, vv); //01 03 F24    
                    dealsend2("A4", data, 1, "setsiteinfo", comaddr, 0, 0, 0);

                }


            }

            function setchgtime() {
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
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 4, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setchgtimeCB", comaddr, 0, oo, 0);
            }
            function setAPN() {

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

                var comaddr = obj.l_comaddr;
                //
                //
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 2, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setAPN", comaddr, 0, apn, 0);
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

                var obj = $("#form1").serializeObject();
                var o = obj.inspect;
                if (o == "") {
                    layerAler("请填写巡检次数");
                    return;
                }
                var vv = [];
                vv.push(parseInt(o));

                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 202, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setinspectcb", comaddr, select.index, apn, select.id);
            }

            function readinspectcb(obj) {
                console.log(obj);
            }
            function readinspect() {
                var vv = [];
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 202, vv); //01 03 F24    
                dealsend2("AA", data, 4, "readinspectcb", comaddr, select.index, apn, select.id);
            }

            $(function () {
                $('#l_comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        }
                    },
                    onSelect: function (record) {
                    }
                });

                $('#type').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        }
                    },
                    onSelect: function (record) {
                        var rowdiv = $(".row");
                        console.log(rowdiv);
                        for (var i = 0; i < rowdiv.length; i++) {
                            var row = rowdiv[i];
                            if (i == 0) {
                                continue;
                            }
                            $(row).hide();
                        }

                        var v = parseInt(record.id);
                        $(rowdiv[v]).show();

                    }
                });

            })
        </script>
    </head>
    <body>


        <!--    <div class="panel panel-success" >
                <div class="panel-heading">
                    <h3 class="panel-title">网关参数设置</h3>
                </div>-->
        <!--        <div class="panel-body" >-->
        <div class="container"  >



            <div class="row" style=" padding-bottom: 20px;" >
                <div class="col-xs-12">
                    <form id="form1">
                        <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629;">
                            <tbody>
                                <tr>

                                    <td>
                                        <span style="margin-left:10px;">网关地址&nbsp;</span>

                                        <span class="menuBox">
                                            <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                   data-options="editable:true,valueField:'id', textField:'text' " />
                                        </span>  
                                    </td>
                                    <td>
                                        <span style="margin-left:10px;">功能选择&nbsp;</span>

                                        <span class="menuBox">
                                            <select class="easyui-combobox" id="type" name="type" data-options="editable:false,valueField:'id', textField:'text' " style="width:200px; height: 30px">
                                                <option value="1" >主站域名或IP设置</option>
                                                <option value="2">设置换日冻结时间参数</option>    
                                                <option value="3">设置通信巡检次数</option> 
                                                <option value="4">读取网关时间</option> 
                                                <option value="5">设置灯具</option> 
                                                <option value="6">设置回路</option> 
                                            </select>
                                        </span>  
                                    </td>
                                </tr>
                            </tbody>
                        </table> 
                    </form>
                </div>
            </div>









            <form id="form2">
                <div class="row">
                    <div class="col-xs-12" id="row1">

                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                            <tbody>
                                <tr>
                                    <td>
                                        <span  style=" float: right; margin-right: 2px;" >域名IP选择:</span>
                                    </td>
                                    <td>

                                        <select class="easyui-combobox" id="sitetype" name="sitetype" style="width:150px; height: 30px">
                                            <option value="0">域名</option>
                                            <option value="1">ip地址</option>            
                                        </select>   

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span  style=" float: right; margin-right: 2px;" >主站ip或域名:</span>
                                    </td>
                                    <td>
                                        <input id="ip" class="form-control" name="ip"  style="width:150px; " placeholder="输入主站域名" type="text">
                                    </td>
                                </tr>

                                <tr >
                                    <td>
                                        <span  style=" float: right; margin-right: 2px;" >端口:</span>
                                    <td>

                                        <input id="port" class="form-control" name="port" style="width:150px;"  placeholder="输入端口" type="text">
                                    </td>

                                </tr>                                   

                                <tr>
                                    <td>
                                        <span  style=" float: right; margin-right: 2px;" >运营商APN:</span>
                                    </td>

                                    <td >
                                        <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;" placeholder="输入APN" type="text">
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <button type="button"  onclick="setSite()" class="btn  btn-success btn-sm" style="margin-left: 2px;">设置主站信息</button>
                                        <button  type="button" onclick="readsite()" class="btn btn-success btn-sm">读取主站信息 </button>
                                        <button  type="button"  onclick="setAPN()" class="btn btn-success btn-sm">设置运营商APN </button>
                                    </td>

                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="row" id="row2" style=" display: none">
                    <div class="col-xs-12">
                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                            <tbody>
                                <tr>
                                    <td>
                                        <span  style="margin-left:10px;" >换日时间</span>
                                        <input id="time4" name="time4" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                                        <span  style="margin-left:10px;" >冻结时间</span>
                                        <input id="time3" name="time3" style=" height: 30px; width: 100px;"  class="easyui-timespinner">
                                        <button   type="button" onclick="setchgtime()" class="btn btn-success btn-sm">设置换日冻结时间</button>
                                        <button  type="button" onclick="readtime()" class="btn btn-success btn-sm">读取换日冻结时间</button>
                                    </td>

                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="row" id="row3"  style=" display: none">
                    <div class="col-xs-12">
                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                            <tbody>
                                <tr>
                                    <td>


                                        <span style="margin-left:10px;  ">通信巡检次数&nbsp;</span>
                                        <input id="inspect" class="form-control" name="inspect" value="" style="width:100px;" placeholder="灯具通信失联巡检次数" type="text">
                                        <button  type="button" onclick="setinspect()" class="btn btn-success btn-sm">设置巡检次数</button>
                                        <button  type="button"  onclick="readinspect()" class="btn btn-success btn-sm">读取巡检次数</button>
                                    </td>

                                </tr>


                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="row" id="row"  style=" display: none">
                    <div class="col-xs-12">
                        <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:10px;  ">网关终端时间&nbsp;</span>
                                        <input id="gaytime" readonly="true" class="form-control" name="gaytime" value="" style="width:150px;" placeholder="网关终端时间" type="text">
                                        <button  type="button" onclick="readTrueTime()" class="btn btn-success btn-sm">读取时间</button>&nbsp;
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

        </div>

    </form>






</div>


<div style="width:100%; margin-top: 10px;">

    <!--    <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>-->
</div>


</body>
</html>
