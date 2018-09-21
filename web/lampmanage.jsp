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

            function showDialog() {

                $('#dialog-add').dialog('open');
                return false;
            }

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
                    $.ajax({url: "test1.lamp.deleteLamp.action", type: "POST", datatype: "JSON", data: {id: select.id},
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
                            $("#gravidaTable").bootstrapTable('refresh');
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
                $("#l_groupe1").combobox('setValue', s.l_groupe);

                if (s.l_deplayment == "1") {    //判断是否部署
                    $("#trlamp").show();
                    $("#trlamp1").show();

                    $("#l_groupe1").combobox("readonly", true);
                    $("#l_worktype1").combobox("readonly", true);
                } else {
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
//                $("#pjj2").modal();
                $('#dialog-edit').dialog('open');
                return false;


            }

            function checkLampAdd() {

                var o = $("#formadd").serializeObject();
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

                var o = {};
                o.l_comaddr = obj.comaddr;
                o.l_worktype = obj.val;
                if (obj.status == "success") {
                    if (obj.type == "1") {

                    } else if (obj.type == "2") {
                        o.l_groupe = obj.param;  //旧组号
                    } else if (obj.type == "3") {
                        o.l_code = obj.param;      //装置序号
                    }
                    console.log(o);

                    $.ajax({async: false, url: "test1.lamp.modifyworktype.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#gravidaTable").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    layerAler("修改灯具组号成功");

                }
            }
            function resetWowktype() {
                var o = $("#form2").serializeObject();
                console.log(o);

                var oldlgroupe = ""
                var vv = [];
                vv.push(parseInt(o.type));  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器

                if (o.type == "3") {
                    var l_code = parseInt(o.l_code);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b);//装置序号  2字节            
                    vv.push(a);//装置序号  2字节      
                    oldlgroupe = o.l_code;
                } else if (o.type == "2") {
                    vv.push(parseInt(o.l_groupe)); //新组号
                    oldlgroupe = o.l_groupe;
                }

                vv.push(parseInt(o.l_worktype1)); //新工作方式  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 120, vv); //01 03 F24    

                dealsend2("A4", data, 120, "resetWowktypeCB", comaddr, o.type, oldlgroupe, o.l_worktype1);
            }
            function resetGroupeCB(obj) {

                var o = {};
                o.l_comaddr = obj.comaddr;
                o.l_groupe = obj.val;
                if (obj.status == "success") {
                    if (obj.type == "1") {
                        o.l_groupe = obj.val;
                    } else if (obj.type == "2") {
                        o.oldlgroupe = obj.param;  //旧组号
                    } else if (obj.type == "3") {
                        o.l_code = obj.param;      //装置序号
                    }

//                    console.log(obj);
                    console.log(o);

                    $.ajax({async: false, url: "test1.lamp.modifygroup.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#gravidaTable").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                    layerAler("修改灯具组号成功");

                }
            }
            function resetGroupe() {

                var o = $("#form2").serializeObject();
                o.type=3;
                console.log(o);


                var vv = [];
                vv.push(parseInt(o.type));
                var oldlgroupe = ""
                if (o.type == "3") {
                    oldlgroupe = o.l_code;
                    var l_code = parseInt(o.l_code);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b);//装置序号  2字节            
                    vv.push(a);//装置序号  2字节      
                } else if (o.type == "2") {
                    vv.push(parseInt(o.l_groupe)); //新组号
                    oldlgroupe = o.l_groupe;
                }


//                vv.push(3);  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器

                vv.push(parseInt(o.l_groupe2)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 110, vv); //01 03 F24    

                dealsend2("A4", data, 110, "resetGroupeCB", comaddr, o.type, oldlgroupe, o.l_groupe2);

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

                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 300,
                    position: ["top", "top"],
                    buttons: {
                        添加: function () {
                            $("#formadd").submit();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $("#dialog-edit").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 350,
                    position: "top",
                    buttons: {
                        修改: function () {
                            modifyLoopName();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });


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
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
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
                                if (value != null) {
                                    return value.toString();
                                }

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
                                if (value != null) {
                                    if (value == 0) {
                                        value = "0(时间)";
                                        return value;
                                    } else if (value == 1) {
                                        value = "1(经纬度)";
                                        return value;
                                    } else if (value == 2) {
                                        value = "1(场景)";
                                        return value;
                                    }

                                }

//                                console.log(value);

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

            });
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
                        template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel"' +
                        'xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>'
                        + '<x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets>'
                        + '</x:ExcelWorkbook></xml><![endif]-->' +
                        ' <style type="text/css">' +
                        '.excelTable  {' +
                        'border-collapse:collapse;' +
                        ' border:thin solid #999; ' +
                        '}' +
                        '   .excelTable  th {' +
                        '   border: thin solid #999;' +
                        '  padding:20px;' +
                        '  text-align: center;' +
                        '  border-top: thin solid #999;' +
                        ' background-color: #E6E6E6;' +
                        ' }' +
                        ' .excelTable  td{' +
                        ' border:thin solid #999;' +
                        '  padding:2px 5px;' +
                        '  text-align: center;' +
                        ' }</style>' +
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



        </script>

        <style>
            
            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; }        

        </style>

    </head>

    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol"  onclick="showDialog();" data-toggle="modal" data-target="#pjj33" id="add">
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



        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>


        <!-- 添加 -->

        <!--        <div id="dialog_simple" title="Dialog Simple Title">
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                </div>-->

        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="灯具添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkLampAdd()">      
                <table>
                    <tbody>
                        <tr>
                            <td>
                                                                <span style="margin-left:20px;">网关地址&nbsp;</span>
                                <span class="menuBox">

                                    <input id="l_comaddr"  class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span>  
                                                                
   
                                <!--                                            <span style="margin-left:20px;">网关名称</span>&nbsp;
                                                                            <input id="txt_gayway_name" readonly="true"  class="form-control"  name="txt_gayway_name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>-->
                            <td></td>
                            <td>
                             <span style="margin-left:10px;">网关名称</span>&nbsp;
                                <input id="comaddrname" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">

                            </td>
                        </tr>

                        <tr>
                            <td>
                                                             <span style="margin-left:20px;">灯具编号&nbsp;</span>
                                <input id="l_factorycode" class="form-control" name="l_factorycode" style="width:150px;display: inline;" placeholder="请输入灯具装置编号" type="text">
                        
                                
          
                            </td>
                            <td></td>
                            <td>
                            <span style="margin-left:10px;">灯具名称</span>&nbsp;
                                <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入灯具名称" type="text">
                           
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
            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="灯具修改">
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hide_id" name="hide_id" />
                <input type="hidden" id="l_deployment" name="l_deployment" />
                <table>
                    <tbody>
                        <tr>
                            <td>
                                                           <span style="margin-left:20px;">网关地址&nbsp;</span>
                                <span class="menuBox">
                                    <input  readonly="true"  id="l_comaddr1" readonly="true"  class="form-control"  name="l_comaddr" style="width:150px;display: inline;" placeholder="网关地址" type="text"></td>     
                                </span>    
                          
             
                            <td></td>
                            <td>
                         <span style="margin-left:20px;">网关名称</span>&nbsp;
                                <input  id="name" readonly="true"  class="form-control"  name="nam" style="width:150px;display: inline;" placeholder="网关名称" type="text"></td>
                           
                            </td>
                        </tr>

                        <tr>
                            <td>
                                              <span style="margin-left:20px;">灯具编号&nbsp;</span>
                                <input id="l_factorycode1" readonly="true" class="form-control" name="l_factorycode" style="width:150px;display: inline;" placeholder="灯具编号" type="text"></td>
                          
                            
                  
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">灯具名称</span>&nbsp;
                                <input id="l_name1"  class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="灯具名称" type="text"></td>
                          
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
<!--                            <td colspan="4">
                                <label class="radio-inline">
                                    <input type="radio"  value="1" name="type">集中器下的所有灯具
                                </label>
                                <label class="radio-inline">
                                    <input type="radio"  value="2" name="type">集中器下以组为单位的灯具
                                </label>
                                <label class="radio-inline">
                                    <input type="radio"  value="3" checked="true" name="type">灯控器为单位
                                </label>
                            </td>-->

                        </tr> 

                    </tbody>
                </table>   
            </form>
        </div>  








    </body>
</html>