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


        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style></head>

    <script type="text/javascript" src="js/genel.js"></script>

    <script>

        var websocket = null;
        var vvvv = 0;
        var flag = null;


        function getMessage(obj) {
            console.log("getMessage");
            console.log(obj);
            if (obj.hasOwnProperty("msg")) {
                if (obj.msg = "getStatus" && obj.data == true) {
                    var trarr = $("#gravidaTable").find("tr");  //所有tr数组
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
            console.log(obj);

            obj.id = obj.val;
            console.log(obj.domain)
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

        function getAPN(obj) {
            if (obj.status == "success") {
                layerAler("设置运营商APN成功");
            }
        }
        function dealsend2(data, fn, func, comaddr, type, param, val) {
            var user = new Object();
            user.begin = '6A';
            user.res = 1;
            user.status = "";
            user.comaddr = comaddr;
            user.fn = fn;
            user.function = func;
            user.param = param;
            user.page = 2;
            user.msg = "AA";
            user.res = 1;
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
                            console.log(row);
                            console.log(value);
                            var str = value + ":" + row.dnsport.toString();
                            return str;
                        },
                    }, {
                        field: 'dnsip_',
                        title: '域名解析的IP(备用)',
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            var str = value + ":" + row.dnsport_.toString();
                            return str;
                        }
                    }, {
                        field: 'siteip',
                        title: '主站ip',
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            console.log(row);
                            console.log(value);
                            var str = value + ":" + row.siteport.toString();
                            return str;
                        }
                    }, {
                        field: 'siteip_',
                        title: '主站ip(备用)',
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            var str = value + ":" + row.siteport_.toString();
                            return str;
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
                        field: 'online',
                        title: '在线状态',
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            return "<img  src='img/off.png'/>";  //onclick='hello()'
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


            $("#addback").click(function () {
                alert("aaa");
            })

            $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                var index = row.data('index');
                value.index = index;
                console.log(value);
            });


            $('#groupegravidaTable').on("check.bs.table", function (field, value, row, element) {
                var index = row.data('index');
                value.index = index;
            });


            //添加时触发

            //修改时触发
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


// 00 00 01 00 
            var vv = [];
            var num = randnum(0, 9) + 0x70;
            var data = buicode(comaddr, 0x04, 0xAA, num, 0, 1, vv); //01 03 F24    

            console.log(data);
            dealsend2(data, 1, "getsite", comaddr, select.index, 0, select.id);

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
            dealsend2(data, 4, "gettime", comaddr, select.index, 0, select.id);
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




            // console.log(v1.toString(16));
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
                    //主站ip 主站备用ip 
                    for (var i = 0; i < 12; i++) {
                        vv.push(0);
                    }

                    //APN

                }
            }

            if (vv.length > 0) {
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
                
                
            }

















        }

        function setchgtime() {
            var obj = $("#form1").serializeObject();


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
            dealsend2(data, 4, "getAPN", comaddr, select.index, apn, select.id);
        }
    </script>
</head>
<body>


    <form id="form1">
        <table>
            <tbody>

                <tr>
                    <td><span class="label label-success" style="margin-left: 10px;" >主站ip或域名</span></td>
                    <td>
                        <input id="ip" class="form-control" name="ip" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入主站域名" type="text">
                    </td>
                    <td><span class="label label-success" style="margin-left: 10px;" >端口</span></td>
                    <td>
                        <input id="port" class="form-control" name="port" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入端口" type="text">
                    </td>
                    <td><span class="label label-success" style="margin-left: 10px;" >APN</span></td>
                    <td>
                        <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入APN" type="text">
                    </td>
                    <td>
                        <button  type="button" style="margin-left:20px;" onclick="setsite()" class="btn btn-success">设置主站信息</button>
                    </td>
                    <td> <button  type="button" style="margin-left:20px;" onclick="readsite()" class="btn btn-success">读取主站信息 </button></td>
                    <td> <button  type="button" style="margin-left:20px;" onclick="setAPN()" class="btn btn-success">设置APN </button></td>
                </tr>

                <tr>
                    <td><span class="label label-success" style="margin-left: 10px;" >换日时间</span></td>
                    <td>
                        <input id="time4" name="time4" style=" height: 34px; width: 150px; margin-left: 3px;" class="easyui-timespinner">
                        <!--<input id="multpower" class="form-control" name="multpower" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入主站域名" type="text">-->
                    </td>
                    <td></td>
                    <td>
                        <!--<input id="multpower" class="form-control" name="multpower" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入端口" type="text">-->
                    </td>
                    <td></td>
                    <td>
                        <!--<input id="multpower" class="form-control" name="multpower" value="cmnet" style="width:150px;display: inline; margin-left: 3px;" placeholder="输入APN" type="text">-->
                    </td>
                    <td>
                        <button  type="button" style="margin-left:20px;" onclick="setchgtime()" class="btn btn-success">设置换日时间</button>
                    </td>
                    <td>
                        <button  type="button" style="margin-left:20px;" onclick="readtime()" class="btn btn-success">读取换日时间</button>
                    </td>
                </tr>             

            </tbody>
        </table>
    </form>

    <div style="width:100%; margin-top: 10px;">

        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>
    </div>


    <!-- 添加 -->

    <!-- 修改 -->

</body>
</html>
