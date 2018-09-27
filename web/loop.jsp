<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="SheetJS-js-xlsx/dist/xlsx.core.min.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script>
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function excel() {
                $('#dialog-excel').dialog('open');
                return false;

            }

            //导入excel的添加按钮事件
            function addexcel() {
                var selects = $('#warningtable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请选择您要保存的数据");
                    return;
                }
                var pid = parent.parent.getpojectId();
                for (var i = 0; i <= selects.length - 1; i++) {
                    var comaddr = selects[i].网关地址;
                    var l_code = selects[i].回路编号;
                    var obj = {};
                    obj.pid = pid;
                    obj.comaddr = comaddr;
                    $.ajax({async: false, url: "login.loop.isporject.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                $.ajax({async: false, url: "login.loop.getl_code.action", type: "POST", datatype: "JSON", data: {l_code: l_code},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 0) {
                                            var cmdname = selects[i].网关名称;
                                            var lname = selects[i].回路名称;
                                            var groupe = selects[i].回路组号;
                                            var adobj = {};
                                            adobj.l_name = lname;
                                            adobj.l_code = l_code;
                                            adobj.l_worktype = 0;
                                            adobj.l_comaddr = comaddr;
                                            adobj.l_deplayment = 0;
                                            adobj.l_groupe = groupe;
                                            adobj.name = cmdname;
                                            $.ajax({url: "login.loop.addloop.action", async: false, type: "get", datatype: "JSON", data: adobj,
                                                success: function (data) {
                                                    var arrlist = data.rs;
                                                    if (arrlist.length == 1) {
                                                        
                                                        var ids = [];//定义一个数组
                                                        var xh = selects[i].序号;        
                                                        ids.push(xh);//将要删除的id存入数组
                                                        $("#warningtable").bootstrapTable('remove', {field: '序号', values: ids});
                                                    }
                                                },
                                                error: function () {
                                                    alert("提交添加失败！");
                                                }
                                            });
                                        }
                                    },
                                    error: function () {
                                        layerAler("提交失败");
                                    }
                                });

                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });

                }
            }

            function showDialog() {

                $('#dialog-add').dialog('open');
                return false;
            }

            function checkLoopAdd() {
                var o = $("#formadd").serializeObject();
                if (o.l_code == "" || o.l_comaddr == "") {
                    layerAler("网关或回路和编号不能为空");
                    return  false;
                }
                o.name = o.comaddrname;
                var namesss = false;

                $.ajax({async: false, cache: false, url: "loop.loopForm.getLoopList.action", type: "GET", data: o,
                    success: function (data) {

                        if (data.total > 0) {
                            layerAler("此回路已存在");
                            return false;
                        }
                        if (data.total == 0) {
                            $.ajax({async: false, cache: false, url: "loop.loopForm.addloop.action", type: "GET", data: o,
                                success: function (data) {
                                    $("#gravidaTable").bootstrapTable('refresh');
                                    namesss = true;
                                },
                                error: function () {
                                    layerAler("系统错误，刷新后重试");
                                }
                            });
                            return  false;
                        }

                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {icon: 6, offset: 'center'
                        });

                    }

                })

                return  namesss;
            }



            function switchWorkTypeCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler("切换成功");
                }

            }
            function switchWorkType() {
                var o = $("#form2").serializeObject();
                if (o.l_deployment == "0") {
                    layerAler("部署后能能切换");
                    return;
                }
                console.log(o);
                var vv = [];

                var l_code = parseInt(o.l_code);
                console.log(l_code);

                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(b);
                vv.push(a);
                vv.push(parseInt(o.l_worktype));
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 380, vv); //01 03 F24    
                dealsend2("A4", data, 380, "switchWorkTypeCB", comaddr, o.l_worktype, 0, 0);
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


            function modifyLoopName() {
                var o = $("#form2").serializeObject();
                o.id = o.hide_id;
                console.log(o);
                $.ajax({async: false, url: "loop.loopForm.modifyname.action", type: "get", datatype: "JSON", data: o,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            layer.open({content: '修改成功', icon: 1,
                                yes: function (index, layero) {
                                    $("#gravidaTable").bootstrapTable('refresh');
                                    layer.close(index);
                                }
                            });
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                return  false;
            }


            function modifyModal() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');

                if (selects.length == 0) {
                    layer.alert('请选择您要编辑的记录', {
                        icon: 6,
                        offset: 'center'
                    });
                    return;
                }
                var select = selects[0];
                console.log(select);

                $("#l_code1").val(select.l_code);
                $("#l_comaddr1").combobox('setValue', select.l_comaddr);
                $("#l_deployment").val(select.l_deplayment);
                $("#comaddrname1").val(select.name);
                $("#l_name1").val(select.l_name);

                $("#hide_id").val(select.id);
                $('#l_worktype1').combobox('setValue', select.l_worktype);
                $("#l_groupe1").combobox('setValue', select.l_groupe);
                if (select.l_deplayment == "1") {

                    $("#l_groupe1").combobox('readonly', true);
                } else if (select.l_deplayment == "0") {
                    $("#l_groupe1").combobox('readonly', false);
                }

                $('#dialog-edit').dialog('open');
                return false;

//                $("#pjj2").modal();


            }

            $(function () {

                $('#warningtable').bootstrapTable({
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
                            title: '序号',
                            field: '序号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: '网关名称',
                            field: '网关名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '网关地址',
                            title: '网关地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '回路名称',
                            title: '回路名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '回路编号',
                            title: '回路编号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '回路组号',
                            title: '回路组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }
                    ],
                    singleSelect: false,
                    locale: 'zh-CN', //中文支持,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 40,
                    pageList: [20, 40, 80, 160]

                });

                $('#excel-file').change(function (e) {
                    var files = e.target.files;
                    var fileReader = new FileReader();
                    fileReader.onload = function (ev) {
                        try {
                            var data = ev.target.result,
                                    workbook = XLSX.read(data, {
                                        type: 'binary'
                                    }), // 以二进制流方式读取得到整份excel表格对象
                                    persons = []; // 存储获取到的数据
                        } catch (e) {
                            alert('文件类型不正确');
                            return;
                        }
                        // 表格的表格范围，可用于判断表头是否数量是否正确
                        var fromTo = '';
                        // 遍历每张表读取
                        for (var sheet in workbook.Sheets) {
                            if (workbook.Sheets.hasOwnProperty(sheet)) {
                                fromTo = workbook.Sheets[sheet]['!ref'];
                                console.log(fromTo);
                                persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
                                // break; // 如果只取第一张表，就取消注释这行
                            }
                        }
                        var headStr = '序号,网关名称,网关地址,回路名称,回路编号,回路组号';
                        for (var i = 0; i < persons.length; i++) {
                            if (Object.keys(persons[i]).join(',') !== headStr) {
                                alert("导入文件格式不正确");
                                persons = [];
                            }
                        }
                        console.log("p2:" + persons.length);
                        $("#warningtable").bootstrapTable('load', []);
                        if (persons.length > 0) {
                            $('#warningtable').bootstrapTable('load', persons);

                        }
                    };
                    // 以二进制方式打开文件
                    fileReader.readAsBinaryString(files[0]);
                });
                //####### Dialogs
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
                    height: 300,
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

                $("#dialog-excel").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 750,
                    height: 500,
                    position: "top",
                    buttons: {
                        保存: function () {
                            addexcel();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });

                $('#comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
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
                for (var i = 0; i < 19; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }

                $("#l_groupe").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });

                $("#l_groupe1").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });


                $("#add").attr("disabled", true);
                $("#update").attr("disabled", true);
                $("#shanchu").attr("disabled", true);
                $("#addexcel").attr("disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {

                                if (rs[i].code == "600201" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    $("#addexcel").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "600202" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "600203" && rs[i].enable != 0) {
                                    $("#shanchu").attr("disabled", false);
                                    continue;
                                }
                            }
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });



                $('#gravidaTable').bootstrapTable({url: 'loop.loopForm.getLoopList.action',
                    //服务器url
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
                            title: '回路名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_code',
                            title: '回路编号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_groupe',
                            title: '回路组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }
                            }
                        }, {
                            field: 'l_worktype',
                            title: '控制方式',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "0(时间)";
                                    return value;
                                } else if (value == 1) {
                                    value = "1(经纬度)";
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
                    singleSelect: true,
                    clickToSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
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
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            pid: "${param.pid}"   
                        };      
                        return temp;  
                    },
                });


                $("#shanchu").click(function () {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler("请选择要删除的数据");
                        return;
                    }
                    layer.confirm('您确定要删除吗？', {
                        btn: ['确定', '取消'], //按钮
                        icon: 3,
                        offset: 'center',
                        title: '提示'
                    }, function (index) {
                        for (var i = 0; i < selects.length; i++) {
                            var select = selects[i];
                            var l_deployment = select.l_deplayment;
                            if (l_deployment == 1) {
                                layerAler("已部署不能删除");
                                continue;
                            } else {
                                $.ajax({url: "loop.loopForm.deleteLoop.action", type: "POST", datatype: "JSON", data: {id: select.id},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            layer.open({
                                                content: '删除成功',
                                                icon: 1,
                                                yes: function (index, layero) {
                                                    $("#gravidaTable").bootstrapTable('refresh');
                                                    layer.close(index);
                                                }
                                            });
                                        }
                                        layer.close(index);
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                            }




                        }

                        layer.close(index);

                    });
                });

            })



        </script>


        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } 

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


        <!--        <a data-toggle="modal" href="lamp.jsp" data-target="#modal">Click me</a>-->


        <!-- 页面中的弹层代码 -->
        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" onclick="showDialog();" data-toggle="modal" data-target="#pjj5" id="add" >  
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>

            <button class="btn btn-primary ctrol"  onclick="modifyModal();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;导入Excel
            </button>
        </div>
        <!--        <form id="importForm" action="importGateway.action" method="post" enctype="multipart/form-data" onsubmit="return check()">
                    <div style="float:left;margin:12px 0 0 10px;border-radius:5px 0 0 5px;position:relative;z-index:100;width:230px;height:30px;">
                        <a href="javascript:;" class="a-upload" style="width:130px;">
                            <input name="excel" id="excel" type="file">
                            <div class="filess">点击这里选择文件</div></a>
                        <input style="float:right;" class="btn btn-default" value="导入Excel" type="submit"></div>
                </form>
                
                <form id="exportForm" action="exportGateway.action" method="post" style="display: inline;">
                    <input id="daochu" class="btn btn-default" style="float:left;margin:12px 0 0 20px;" value="导出Excel" type="button">
                </form>-->

        <div style="width:100%;">
            <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
            </table>
        </div


        <!-- 添加 -->

        <!--        <div id="dialog_simple" title="Dialog Simple Title">
                    <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
                </div>-->

        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="回路添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkLoopAdd()">    
                <input type="hidden" name="pid" value="${param.pid}"/>
                <table >
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">网关地址&nbsp;</span>
                                <span class="menuBox">

                                    <input id="comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span>  


                            <td></td>
                            <td>
                                <span style="margin-left:10px;">网关名称</span>&nbsp;
                                <input id="comaddrname" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;">回路编号&nbsp;</span>
                                <input id="l_code" class="form-control" name="l_code" style="width:150px;display: inline;" placeholder="请输入回路编号" type="text">

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">回路名称</span>&nbsp;
                                <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                            </td>
                            </td>
                        </tr>                                   
                        <tr>
                            <td>

                                <span style="margin-left:20px;">控制方式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="switch" name="l_worktype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0" selected="true">走时间</option>
                                        <!--<option value="1">走经纬度</option>-->           
                                    </select>
                                </span>



                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;">所属组号</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" id="l_groupe" name="l_groupe"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                    </select>
                                </span>
                            </td>
                        </tr>                 


                    </tbody>
                </table> 
            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="回路修改">
            <form action="" method="POST" id="form2" onsubmit="return modifyLoopName()">  
                <input type="hidden" id="hide_id" name="hide_id" />
                <input type="hidden" name="pid" value="${param.pid}"/>
                <input type="hidden" id="l_deployment" name="l_deployment" />
                <table >
                    <tbody>
                        <tr>
                            <td>

                                <span style="margin-left:20px;">网关地址&nbsp;</span>
                                <span class="menuBox">

                                    <input id="l_comaddr1" readonly="true" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                           data-options='editable:false,valueField:"id", textField:"text"' />
                                </span>  


                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;">网关名称</span>&nbsp;
                                <input id="comaddrname1" readonly="true"   class="form-control"  name="comaddrname" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">

                            </td>
                        </tr>

                        <tr>
                            <td>
                                <span style="margin-left:20px;">回路编号&nbsp;</span>
                                <input id="l_code1" readonly="true" class="form-control" name="l_code"  style="width:150px;display: inline;" placeholder="回路编号" type="text">

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">回路名称</span>&nbsp;
                                <input id="l_name1" class="form-control"   name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                            </td>
                            </td>
                        </tr>                                   
                        <tr>
                            <td>

                                <span style="margin-left:20px;">控制方式</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" readonly="true" id="l_worktype1" name="l_worktype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0" selected="true">走时间</option>
                                        <!--<option value="1">走经纬度</option>-->           
                                    </select>
                                </span>

                            </td>
                            <td>
                                <!--<span style=" margin-left: 10px;" class="label label-success" onclick="switchWorkType()" >切换控制方式</span>-->
                            </td>
                            <td>


                                <span style="margin-left:10px;">所属组号</span>&nbsp;
                                <span class="menuBox">
                                    <select class="easyui-combobox" readonly="true" id="l_groupe1" name="l_groupe"  data-options='editable:false,valueField:"id", textField:"text"' style="width:150px; height: 30px">          
                                    </select>
                                </span>
                            </td>
                        </tr>                 


                    </tbody>
                </table>


            </form>
        </div>

        <div id="dialog-excel"  class="bodycenter"  style=" display: none" title="导入Excel">
            <input type="file" id="excel-file" style=" height: 40px;">
            <table id="warningtable"></table>

        </div>


    </body>
</html>
