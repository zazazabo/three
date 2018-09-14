<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns:f="http://java.sun.com/jsf/core">
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
            function deleteLamp() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请选择您要删除的记录");
                    return;
                }
                var select = selects[0];
                if (select.l_deplayment == "1") {
                    layerAler("已部署的不能删除");
                    return;
                }
                layer.confirm('确认要删除吗？', {
                    btn: ['确定', '取消']//按钮
                }, function (index) {
                    $.ajax({url: "test1.lamp.deleteLamp.action", type: "POST", datatype: "JSON", data: {id: select.uid},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#gravidaTable").bootstrapTable('refresh');
                                layerAler("删除成功");
                                layer.close(index);
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    layer.close(index);
                    //此处请求后台程序，下方是成功后的前台处理……
                });
            }

            function  editlamp() {
                var o = $("#form2").serializeObject();

                console.log(o);
                $.ajax({async: false, url: "test1.lamp.modifylamp.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        var a = data.rs;
                        if (a.length == 1) {
                            layerAler("修改成功");
                        }
                        console.log(data);
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            function editlampInfo() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length <= 0) {
                    layerAler("请选择数据编辑");
                    return;
                }
                var s = selects[0];
                console.log(s);
                $("#l_deployment1").val(s.l_deplayment);
                $("#l_code").val(s.l_code);
                $("#l_worktype1").combobox('setValue', s.l_worktype);

                if (s.l_deplayment == "1") {    //判断是否部署
                    $("#trlamp").show();
                    $("#trlamp1").show();

                    $("#l_groupe1").combobox("readonly", true);
                    $("#l_worktype1").combobox("readonly", true);
                } else if (s.l_deplayment == "0") {
                    $("#trlamp").hide();
                    $("#trlamp1").hide();
                    $("#l_groupe1").combobox("readonly", false);
                    $("#l_worktype1").combobox("readonly", false);

                }

                $("#l_factorycode1").val(s.l_factorycode);
                $("#l_comaddr1").val(s.l_comaddr);

                $("#name").val(s.name);
                $("#l_name1").val(s.l_name);
                $("#hide_id").val(s.id);
                $("#pjj2").modal();



            }

            function checkLampAdd() {

                var o = $("#form1").serializeObject();
                o.name = o.comaddrname;

                console.log(o);
                if (o.l_factorycode == "" || o.l_comaddr == "") {
                    layerAler("灯具编号不能为空,或网关地址不能为空");
                    return  false;
                }

                var isflesh = false;
                $.ajax({url: "test1.lamp.getlamp.action", async: false, type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        console.log(data);
                        if (data.total > 0) {
                            layerAler("灯具编号已存在");
                        } else if (data.total == 0) {
                            console.log("adddd");
                            $.ajax({url: "test1.lamp.addlamp.action", async: false, type: "get", datatype: "JSON", data: o,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        isflesh = true;
                                        $("#gravidaTable").bootstrapTable('refresh');
                                    }

                                },
                                error: function () {
                                    alert("提交添加失败！");
                                }
                            });

                        }
                    },
                    error: function () {
                        alert("提交查询失败！");
                    }
                });
                return  isflesh;

            }

            function resetWowktypeCB(obj) {
                if (obj.status == "success") {
                    layerAler("修改灯具组号成功");
                }
            }
            function resetWowktype() {
                var o = $("#form2").serializeObject();
                console.log(o);


                var vv = [];
                vv.push(parseInt(o.type));  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器
                if (o.type == "3") {
                    var l_code = parseInt(o.l_code);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b);//装置序号  2字节            
                    vv.push(a);//装置序号  2字节      
                } else if (o.type == "2") {
                    vv.push(parseInt(o.l_groupe)); //新组号
                }

                vv.push(parseInt(o.worktype1)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 120, vv); //01 03 F24    
                dealsend2("A4", data, 120, "resetWowktypeCB", comaddr, o.type, 0, 0);
            }
            function resetGroupeCB(obj) {
                if (obj.status == "success") {
                    layerAler("修改灯具组号成功");
                }
            }
            function resetGroupe() {

                var o = $("#form2").serializeObject();
                console.log(o);


                var vv = [];
                vv.push(parseInt(o.type));

                if (o.type == "3") {
                    var l_code = parseInt(o.l_code);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b);//装置序号  2字节            
                    vv.push(a);//装置序号  2字节      
                } else if (o.type == "2") {
                    vv.push(parseInt(o.l_groupe)); //新组号
                }


//                vv.push(3);  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器

                vv.push(parseInt(o.l_groupe2)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 110, vv); //01 03 F24    
                dealsend2("A4", data, 110, "resetGroupeCB", comaddr, o.type, 0, 0);

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

//                
//                
//                $("#add").attr("disabled", true);
//                $("#xiugai1").attr("disabled", true);
//                $("#shanchu").attr("disabled", true);
//                var obj = {};
//                obj.code = ${param.m_parent};
//                obj.roletype = ${param.role};
//                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
//                    success: function (data) {
//                        var rs = data.rs;
//                        if (rs.length > 0) {
//                            for (var i = 0; i < rs.length; i++) {
//
//                                if (rs[i].code == "600301" && rs[i].enable != 0) {
//                                    $("#add").attr("disabled", false);
//                                    continue;
//                                }
//                                if (rs[i].code == "600302" && rs[i].enable != 0) {
//                                    $("#xiugai1").attr("disabled", false);
//                                    continue;
//                                }
//                                if (rs[i].code == "600303" && rs[i].enable != 0) {
//                                    $("#shanchu").attr("disabled", false);
//                                    continue;
//                                }
//                            }
//                        }
//
//                    },
//                    error: function () {
//                        alert("提交失败！");
//                    }
//                });



                $('#l_comaddr').combobox({
                    url: "test1.gayway.comaddr.action",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                            $("#comaddrname").val(data[0].name);
                        }
                    },
                    onSelect: function (record) {
                        $("#comaddrname").val(record.name);

                    }
                });


                var d = [];
                for (var i = 0; i < 18; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }
                $("#l_groupe").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });
                $("#l_groupe1").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });

                $("#l_groupe2").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });


                $('#gravidaTable').bootstrapTable({
                    url: 'test1.lamp.getlamp1.action',
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
                        }, {
                            field: 'l_name',
                            title: '灯具名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: '灯具编号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_groupe',
                            title: '组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return value.toString();
                            }
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
                                    value = "1(场景)";
                                    return value;
                                }
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
                    },
                });

<<<<<<< HEAD
                $('#select_l_comaddr').change(function () {
                    var name1 = $(this).find("option:selected").attr("detail");
                    $("#txt_gayway_name").val(name1);
                });

                $("#select_l_groupe").empty();
                for (var i = 1; i < 19; i++) {
                    var str = "<option value=\"" + i.toString() + "\">" + i.toString() + "</option>";
                    $("#select_l_groupe").append(str);
                }

                $("#select_l_groupe").find("option[value=\"1\"]").attr("selected", true);

                $('#pjj').on('show.bs.modal', function () {
                    $.ajax({
                        url: "test1.gayway.comaddr.action",
                        type: "get",
                        datatype: "JSON",
                        data: {},
                        success: function (data) {
                            console.log(data);
                            $("#select_l_comaddr").empty();
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {

                                var objlist = arrlist[i];
//                                console.log(objlist.objlist); //comaddr

                                var str = "<option detail='" + objlist.name + "' value = '" + objlist.comaddr + "'> " + objlist.comaddr + " </option>";
                                console.log(str);
                                $("#select_l_comaddr").append(str); //添加option
                                if (i == 0) {
                                    $("#txt_gayway_name").val(objlist.name);
                                }
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });






                })

                $('#pjj').on('hidden.bs.modal', function () {
                    $(this).removeData("bs.modal");
                });


                $('#gravidaTable').on("click-cell.bs.table", function (field, value, row, element) {

                    if (value == "l_plan") {
                        $.ajax({
                            url: "test1.loop.getPlan.action",
                            type: "get",
                            datatype: "JSON",
                            data: {p_code: row, p_attr: 1},
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {

                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    }


                })

            })
            var namesss = false;


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

            var idTmr;
            function  getExplorer() {
                var explorer = window.navigator.userAgent;
                //ie  
                if (explorer.indexOf("MSIE") >= 0) {
                    return 'ie';
                }
                //firefox  
                else if (explorer.indexOf("Firefox") >= 0) {
                    return 'Firefox';
                }
                //Chrome  
                else if (explorer.indexOf("Chrome") >= 0) {
                    return 'Chrome';
                }
                //Opera  
                else if (explorer.indexOf("Opera") >= 0) {
                    return 'Opera';
                }
                //Safari  
                else if (explorer.indexOf("Safari") >= 0) {
                    return 'Safari';
                }
            }
            function method5(tableid) {
                if (getExplorer() == 'ie')
                {
                    var curTbl = document.getElementById(tableid);
                    var oXL = new ActiveXObject("Excel.Application");
                    var oWB = oXL.Workbooks.Add();
                    var xlsheet = oWB.Worksheets(1);
                    var sel = document.body.createTextRange();
                    sel.moveToElementText(curTbl);
                    sel.select();
                    sel.execCommand("Copy");
                    xlsheet.Paste();
                    oXL.Visible = true;

                    try {
                        var fname = oXL.Application.GetSaveAsFilename("Excel.xls", "Excel Spreadsheets (*.xls), *.xls");
                    } catch (e) {
                        print("Nested catch caught " + e);
                    } finally {
                        oWB.SaveAs(fname);
                        oWB.Close(savechanges = false);
                        oXL.Quit();
                        oXL = null;
                        idTmr = window.setInterval("Cleanup();", 1);
                    }

                } else
                {
                    tableToExcel(tableid);
                }
            }
            function Cleanup() {
                window.clearInterval(idTmr);
                CollectGarbage();
            }
            var tableToExcel = (function () {
                var uri = 'data:application/vnd.ms-excel;base64,',
                        template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"'+
                        'xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
                        +'<x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets>'
                        +'</x:ExcelWorkbook></xml><![endif]-->'+
                        ' <style type="text/css">'+
                        '.excelTable  {'+
                        'border-collapse:collapse;'+
                         ' border:thin solid #999; '+
                        '}'+
                        '   .excelTable  th {'+
                        '   border: thin solid #999;'+
                        '  padding:20px;'+
                        '  text-align: center;'+
                        '  border-top: thin solid #999;'+
                        ' background-color: #E6E6E6;'+
                        ' }'+
                        ' .excelTable  td{'+
                        ' border:thin solid #999;'+
                        '  padding:2px 5px;'+
                        '  text-align: center;'+
                        ' }</style>'+
                        '</head><body ><table class="excelTable">{table}</table></body></html>',
                        base64 = function (s) {
                            return window.btoa(unescape(encodeURIComponent(s)));
                        },
                        format = function (s, c) {
                            return s.replace(/{(\w+)}/g,
                                    function (m, p) {
                                        return c[p];
                                    });
                        };
                return function (table, name) {
                    if (!table.nodeType)
                        table = document.getElementById(table);
                    var ctx = {worksheet: name || 'Worksheet', table: table.innerHTML};
                    window.location.href = uri + base64(format(template, ctx));
                };
            })()

=======
//
//                $('#select_l_comaddr').change(function () {
//                    var name1 = $(this).find("option:selected").attr("detail");
//                    $("#txt_gayway_name").val(name1);
//                });
//
//                $("#select_l_groupe").empty();
//                for (var i = 1; i < 19; i++) {
//                    var str = "<option value=\"" + i.toString() + "\">" + i.toString() + "</option>";
//                    $("#select_l_groupe").append(str);
//                }
//
//                $("#select_l_groupe").find("option[value=\"1\"]").attr("selected", true);
//
//                $('#pjj').on('show.bs.modal', function () {
//                    $.ajax({
//                        url: "test1.gayway.comaddr.action",
//                        type: "get",
//                        datatype: "JSON",
//                        data: {},
//                        success: function (data) {
//                            console.log(data);
//                            $("#select_l_comaddr").empty();
//                            var arrlist = data.rs;
//                            for (var i = 0; i < arrlist.length; i++) {
//
//                                var objlist = arrlist[i];
////                                console.log(objlist.objlist); //comaddr
//
//                                var str = "<option detail='" + objlist.name + "' value = '" + objlist.comaddr + "'> " + objlist.comaddr + " </option>";
//                                console.log(str);
//                                $("#select_l_comaddr").append(str); //添加option
//                                if (i == 0) {
//                                    $("#txt_gayway_name").val(objlist.name);
//                                }
//                            }
//                        },
//                        error: function () {
//                            alert("提交失败！");
//                        }
//                    });
//
//
//
//
//
//
//                })
//
//                $('#pjj').on('hidden.bs.modal', function () {
//                    $(this).removeData("bs.modal");
//                });
//
//
//                $('#gravidaTable').on("click-cell.bs.table", function (field, value, row, element) {
//
//                    if (value == "l_plan") {
//                        $.ajax({
//                            url: "test1.loop.getPlan.action",
//                            type: "get",
//                            datatype: "JSON",
//                            data: {p_code: row, p_attr: 1},
//                            success: function (data) {
//                                var arrlist = data.rs;
//                                if (arrlist.length == 1) {
//
//                                }
//                            },
//                            error: function () {
//                                alert("提交失败！");
//                            }
//                        });
//                    }
//
//
//                })

            })

>>>>>>> 1a711c70b3dc2047355883396ef15637462829c0
        </script>

        <style>

            .table { font-size: 12px; } 
            .modal-body input[type="text"], 
            .modal-body select { height: 30px; } 
            .modal-body input[type="radio"] { height: 30px; } 
            .modal-body table td { line-height: 40px; }
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 
            .pagination-info { float: left; margin-top: -4px; } 
            .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; }
        </style>

    </head>

    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol" onclick="editlampInfo()"   id="xiugai1">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteLamp();" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
        </div>
        <form id="importForm" action="importGateway.action" method="post" enctype="multipart/form-data" onsubmit="return check()">
            <div style="float:left;margin:12px 0 0 10px;border-radius:5px 0 0 5px;position:relative;z-index:100;width:230px;height:30px;">
                <a href="javascript:;" class="a-upload" style="width:130px;">
                    <input name="excel" id="excel" type="file">
                    <div class="filess">点击这里选择文件</div></a>
                <input style="float:right;" class="btn btn-default" value="导入Excel" type="submit"></div>
        </form>
        <form id="exportForm" action="exportGateway.action" method="post" style="display: inline;">
            <input id="daochu" class="btn btn-default" style="float:left;margin:12px 0 0 20px;" value="导出Excel" type="button" onclick="method5('gravidaTable')">
        </form>

        <div style="width:100%;">
            <div class="bootstrap-table">
                <div class="fixed-table-container" style="height: 214px; padding-bottom: 0px;">

                    <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                    </table>
                </div>
            </div>
        </div>


        <!-- 添加 -->
        <div class="modal" id="pjj">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span>
                        </button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">添加灯具配置</h4></div>

                    <form action="" method="POST" id="form1" onsubmit="return checkLampAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">网关名称</span>&nbsp;
                                            <input id="comaddrname" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">

                                            <!--                                            <span style="margin-left:20px;">网关名称</span>&nbsp;
                                                                                        <input id="txt_gayway_name" readonly="true"  class="form-control"  name="txt_gayway_name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>-->
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">网关地址&nbsp;</span>
                                            <span class="menuBox">

                                                <input id="l_comaddr"  class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                       data-options='editable:false,valueField:"id", textField:"text"' />
                                            </span>  
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具名称</span>&nbsp;
                                            <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入灯具名称" type="text">
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">灯具编号&nbsp;</span>
                                            <input id="l_factorycode" class="form-control" name="l_factorycode" style="width:150px;display: inline;" placeholder="请输入灯具装置编号" type="text">
                                        </td>
                                        </td>
                                    </tr>                                   

                                    <tr>
                                        <td>

                                            <span style="margin-left:20px;">灯具组号</span>&nbsp;
                                            <span class="menuBox">
                                                <select class="easyui-combobox" id="l_groupe" name="l_groupe"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                                </select>
                                            </span> 

                                            </span> 
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">控制方式</span>&nbsp;
                                            <span class="menuBox">
                                                <select class="easyui-combobox" id="l_worktype" name="l_worktype" data-options='editable:false' style="width:150px; height: 30px">
                                                    <option value="0" >时间</option>
                                                    <option value="1" >经纬度</option>
                                                    <option value="2">场景</option>           
                                                </select>
                                            </span>
                                        </td>
                                    </tr>                  


                                </tbody>
                            </table>
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer">
                            <!-- 添加按钮 -->
                            <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                    </form>
                </div>
            </div>
        </div>
        <!-- 修改 -->
        <div class="modal" id="pjj2">
            <div class="modal-dialog">

                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">修改灯具配置</h4></div>
                    <form action="" method="POST" id="form2" >     
                        <input type="hidden" id="hide_id" name="id" />
                        <input type="hidden" id="l_code" name="l_code" />
                        <input type="hidden" id="l_deployment1" name="l_deployment" />
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">网关名称</span>&nbsp;
                                            <input  id="name" readonly="true"  class="form-control"  name="nam" style="width:150px;display: inline;" placeholder="网关名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">网关地址&nbsp;</span>
                                            <span class="menuBox">
                                                <input  readonly="true"  id="l_comaddr1" readonly="true"  class="form-control"  name="l_comaddr" style="width:150px;display: inline;" placeholder="网关地址" type="text"></td>     
                                            </span>    
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具名称</span>&nbsp;
                                            <input id="l_name1"  class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="灯具名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">灯具编号&nbsp;</span>
                                            <input id="l_factorycode1" readonly="true" class="form-control" name="l_factorycode" style="width:150px;display: inline;" placeholder="灯具编号" type="text"></td>
                                        </td>
                                    </tr>                                   


                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具组号</span>&nbsp;
                                            <span class="menuBox">
                                                <select class="easyui-combobox" id="l_groupe1"  readonly="true" name="l_groupe"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                                </select>
                                            </span>   
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">控制方式</span>&nbsp;
                                            <span class="menuBox">
                                                <select class="easyui-combobox" readonly="true" id="l_worktype1" name="l_worktype" data-options='editable:false' style="width:150px; height: 30px">
                                                    <option value="0" >时间</option>
                                                    <option value="1">经纬度</option>
                                                    <option value="2">场景</option>           
                                                </select>
                                            </span>  
                                        </td>
                                        <td>

                                        </td>
                                    </tr>                  

                                    <tr id="trlamp">
                                        <td>
                                            <span style="margin-left:8px;">灯具新组号</span>&nbsp;
                                            <span class="menuBox">
                                                <select class="easyui-combobox" id="l_groupe2" name="l_groupe2"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                                </select>
                                            </span>     
                                        </td>
                                        <td>
                                            <span id="span_worktype" style=" margin-left: 2px;"  onclick="resetGroupe()" class="label label-success" >更换</span>
                                        </td>
                                        <td>
                                            <span style="margin-left:20px;">控制方式</span>&nbsp;
                                            <span class="menuBox">
                                                <select class="easyui-combobox" id="l_worktype1" name="l_worktype1" data-options='editable:false' style="width:150px; height: 30px">
                                                    <option value="0" >时间</option>
                                                    <option value="1">经纬度</option>
                                                    <option value="2">场景</option>           
                                                </select>
                                            </span>   
                                        </td>
                                        <td>
                                            <span  onclick="resetWowktype()" style=" margin-left: 2px;" class="label label-success" >更换</span>
                                        </td>
                                    </tr> 
                                    <tr id="trlamp1">
                                        <td colspan="4">
                                            <label class="radio-inline">
                                                <input type="radio"  value="1" name="type">集中器下的所有灯具
                                            </label>
                                            <label class="radio-inline">
                                                <input type="radio"  value="2" name="type">集中器下以组为单位的灯具
                                            </label>
                                            <label class="radio-inline">
                                                <input type="radio"  value="3" checked="true" name="type">灯控器为单位
                                            </label>
                                        </td>

                                    </tr> 

                                </tbody>
                            </table>                            
                        </div>

                        <div class="modal-footer"  >

                            <button id="xiugai" type="button" onclick="editlamp()" class="btn btn-primary">修改</button>

                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>
                </div>

            </div>
        </div>

        <!--修改组号-->

    </body>
</html>