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
        <!--        <script src="select2-developr/dist/js/select2.js"></script>
                <link href="select2-develop/dist/css/select2.css" rel="stylesheet" />
        
        
        
                <link rel="stylesheet" type="text/css" href="gatewayconfig_files/bootstrap.css">
                <link rel="stylesheet" type="text/css" href="gatewayconfig_files/bootstrap-table.css">
                <script type="text/javascript" src="gatewayconfig_files/jquery.js"></script>
                <script type="text/javascript" src="gatewayconfig_files/bootstrap.js"></script>
                <script type="text/javascript" src="gatewayconfig_files/bootstrap-table.js"></script>
                <script type="text/javascript" src="gatewayconfig_files/bootstrap-table-zh-CN.js"></script>
                <link type="text/css" href="gatewayconfig_files/basicInformation.css" rel="stylesheet">
                 easyui 
                <link href="gatewayconfig_files/easyui.css" rel="stylesheet" type="text/css" switch="switch-style">
                <link href="gatewayconfig_files/icon.css" rel="stylesheet" type="text/css">
                <script src="gatewayconfig_files/jquery_002.js" type="text/javascript"></script>
                <script src="gatewayconfig_files/easyui-lang-zh_CN.js" type="text/javascript"></script>
                <script type="text/javascript" src="gatewayconfig_files/selectAjaxFunction.js"></script>
                <script type="text/javascript" src="gatewayconfig_files/bootstrap-multiselect.js"></script>
                <link rel="stylesheet" href="gatewayconfig_files/bootstrap-multiselect.css" type="text/css">
                <link rel="stylesheet" type="text/css" href="gatewayconfig_files/layer.css">
                <script type="text/javascript" src="gatewayconfig_files/layer.js"></script>-->
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
            function editlampInfo() {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length <= 0) {
                    layerAler("请选择数据编辑");
                    return;
                }
                var select = selects[0];
                console.log(select);
                $("#txt_l_factorycode").val(select.l_factorycode);
                $("#txt_l_comaddr").val(select.l_comaddr);

                $("#name").val(select.name);
                $("#txt_l_name").val(select.l_name);

                $("#txt_hide_id").val(select.id);
                $("#txt_lamp_setcode").val(select.l_code);
                $("#select_l_groupe_edit").empty();
                $("#select_l_groupe_edit_new").empty();
                for (var i = 1; i < 19; i++) {
                    if (select.l_groupe == i.toString()) {
                        var str = "<option selected='true'  value='" + i.toString() + "'>" + i.toString() + "</option>";
                        $("#select_l_groupe_edit").append(str);
                        $("#select_l_groupe_edit_new").append(str);
                    } else {
                        var str = "<option   value='" + i.toString() + "'>" + i.toString() + "</option>";
                        $("#select_l_groupe_edit").append(str);
                        $("#select_l_groupe_edit_new").append(str);
                    }
                }
                if (select.l_deplayment == "1") {    //判断是否部署
                    $("#select_l_groupe_edit").attr("disabled", true);
                    $("#tr_neweditlamp").show();
                    $("#span_worktype").hide();
                    $("#span_worktype").show();
                    $("#modal_footer_edit").hide();
                } else if (select.l_deplayment == "0") {
                    $("#select_l_groupe_edit").attr("disabled", false);
                    $("#tr_neweditlamp").hide();
                    $("#modal_footer_edit").show();
                    $("#span_worktype").hide();
                }


                $("#pjj2").modal();



            }

            function checkLampModify() {
                return false;
            }
            function configGroupe(obj) {
                console.log(obj)
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {
                    layerAler("成功");
                }
            }
            function configWorkType(obj) {
                console.log(obj)
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {
                    layerAler("成功");
                }
            }
            function changeLampWorkType() {

                var obj = $("#Form_Lamp_modify").serializeObject();
                console.log(obj);

                var vv = new Array();
                vv.push(3);  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器
                var l_code = obj.txt_lamp_setcode;
                var dd = get2byte(l_code);
                var set1 = Str2BytesH(dd);
                vv.push(set1[1]);
                vv.push(set1[0]); //装置序号  2字节    

                var l_worktype = obj.l_worktype;  //工作方式
                vv.push(parseInt(l_worktype, "10"));

                var comaddr1 = obj.txt_l_comaddr;
                var ele = {id: obj.txt_hide_id};
                var user = new Object();
                user.res = 1;
                user.afn = 120;
                user.status = "";
                user.function = "configWorkType";
                user.parama = ele;
                user.msg = "setParam";
                user.res = 1;
                user.addr = getComAddr(comaddr1); //"02170101";
                var num = randnum(0, 9) + 0x70;
                var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 120, vv); //01 03 F24        
                user.data = sss;
                $datajson = JSON.stringify(user);
                console.log("websocket readystate:" + websocket.readyState);
                console.log(user);
                websocket.send($datajson)
            }

            function checkLampAdd() {

                var formobj = $("#Form_Lamp").serializeObject();
                formobj.l_comaddr = formobj.select_l_comaddr;
                formobj.l_groupe = formobj.select_l_groupe;
                console.log(formobj);

                if (formobj.l_code == "" || formobj.l_comaddr == "") {
                    layerAler("灯具编号不能为空,或网关地址不能为空");
                    return  false;
                }
                var isflesh = false;
                $.ajax({url: "test1.lamp.getlamp.action", async: false, type: "get", datatype: "JSON", data: formobj,
                    success: function (data) {
                        console.log(data);
                        if (data.total > 0) {
                            layerAler("灯具编号已存在");
                        } else if (data.total == 0) {
                            $.ajax({url: "test1.lamp.addlamp.action", async: false, type: "get", datatype: "JSON", data: formobj,
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

            function changeLampGroupe() {

                var obj = $("#Form_Lamp_modify").serializeObject();
                console.log(obj);

                var oldgroupe = $("#select_l_groupe_edit").val();
                console.log(oldgroupe);
                var vv = new Array();
                var eleArray = new Array();
                vv.push(3);  //灯控器组号  1 所有灯控器  2 按组   3 个个灯控器
                var l_code = obj.txt_lamp_setcode;
                var dd = get2byte(l_code);
                var set1 = Str2BytesH(dd);
                console.log(set1);
                vv.push(set1[1]);
                vv.push(set1[0]); //装置序号  2字节            
                var l_goupe = $("#select_l_groupe_edit_new").val();
                vv.push(parseInt(l_goupe, "10"));

                var comaddr1 = obj.txt_l_comaddr;
                var ele = {id: obj.txt_hide_id, OldGroupe: oldgroupe, NewGroupe: l_goupe};
                var user = new Object();
                user.res = 1;
                user.afn = 110;
                user.status = "";
                user.function = "configGroupe";
                user.parama = ele;
                user.msg = "setParam";
                user.res = 1;
                user.addr = getComAddr(comaddr1); //"02170101";
                var num = randnum(0, 9) + 0x70;
                var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 110, vv); //01 03 F24        
                user.data = sss;
                $datajson = JSON.stringify(user);
                console.log("websocket readystate:" + websocket.readyState);
                console.log(user);
                websocket.send($datajson)
            }


            $(function () {

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
                            field: 'l_plan',
                            title: '控制方案',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
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



        </script>

        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>

    </head>

    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj">
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
            <input id="daochu" class="btn btn-default" style="float:left;margin:12px 0 0 20px;" value="导出Excel" type="button">
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
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">添加灯具配置</h4></div>

                    <form action="" method="POST" id="Form_Lamp" onsubmit="return checkLampAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">网关名称</span>&nbsp;
                                            <input id="txt_gayway_name" readonly="true"  class="form-control"  name="txt_gayway_name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">网关地址&nbsp;</span>
                                            <span class="menuBox">
                                                <select name="select_l_comaddr" id="select_l_comaddr" class="input-sm" style="width:150px;">
                                            </span>    
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具名称</span>&nbsp;
                                            <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入灯具名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">灯具编号&nbsp;</span>
                                            <input id="l_factorycode" class="form-control" name="l_factorycode" style="width:150px;display: inline;" placeholder="请输入灯具装置编号" type="text"></td>
                                        </td>
                                    </tr>                                   

                                    <!--                                    <tr>
                                                                            <td>
                                                                                <span style="margin-left:20px;">控制方式</span>&nbsp;
                                                                                <span class="menuBox">
                                                                                    <select name="l_worktype" id="l_worktype" class="input-sm" style="width:150px;">
                                                                                        <option value="0" selected="selected">走时间</option>
                                                                                        <option value="1" >走场景</option>
                                                                                    </select>
                                                                                </span> 
                                    
                                                                            </td>
                                                                            <td></td>
                                                                            <td>
                                                                                <span style="margin-left:10px;">控制方案&nbsp;</span>
                                                                                <span class="menuBox">
                                                                                    <select name="p_plan" id="p_plan" class="input-sm" style="width:150px;">
                                                                                    </select>
                                                                                </span>    
                                                                            </td>
                                                                        </tr>                                   -->

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具组号</span>&nbsp;
                                            <span class="menuBox">

                                                <!--                                                <input id="txt_l_groupe" readonly="true" class="form-control" value="" name="txt_l_groupe" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">-->
                                                <select name="select_l_groupe" id="select_l_groupe" class="input-sm" style="width:150px;">
                                                </select>
                                            </span> 
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">控制方式</span>&nbsp;
                                            <span class="menuBox">
                                                <select name="l_worktype" id="l_worktype" class="input-sm" style="width:150px;">
                                                    <option value="0" selected="selected">走时间</option>
                                                    <option value="1" >走场景</option>
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
                    <form action="" method="POST" id="Form_Lamp_modify" onsubmit="return checkLampModify()">     
                        <input type="hidden" id="txt_hide_id" name="txt_hide_id" />
                        <input type="hidden" id="txt_lamp_setcode" name="txt_lamp_setcode" />
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
                                                <input  readonly="true"  id="txt_l_comaddr" readonly="true"  class="form-control"  name="txt_l_comaddr" style="width:150px;display: inline;" placeholder="网关地址" type="text"></td>     
                                            </span>    
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具名称</span>&nbsp;
                                            <input id="txt_l_name"  class="form-control"  name="txt_l_name" style="width:150px;display: inline;" placeholder="灯具名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">灯具编号&nbsp;</span>
                                            <input id="txt_l_factorycode" readonly="true" class="form-control" name="txt_l_factorycode" style="width:150px;display: inline;" placeholder="灯具编号" type="text"></td>
                                        </td>
                                    </tr>                                   


                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">灯具组号</span>&nbsp;
                                            <span class="menuBox">


                                                <select name="select_l_groupe_edit" id="select_l_groupe_edit" class="input-sm" style="width:150px;">
                                                </select>
                                            </span> 
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">控制方式</span>&nbsp;

                                            <select name="l_worktype" id="l_worktype" class="input-sm" style="width:150px;">
                                                <option value="0" selected="selected">走时间</option>
                                                <option value="1" >走经纬度</option>
                                                <option value="2" >走场景</option>
                                            </select>
                                            <span id="span_worktype" style=" margin-left: 2px;" onclick="changeLampWorkType()" class="label label-info" >更换</span>
                                        </td>
                                    </tr>                  

                                    <tr id="tr_neweditlamp">
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;&nbsp;新组号</span>&nbsp;

                                            <select name="select_l_groupe_edit_new" id="select_l_groupe_edit_new" class="input-sm" style="width:150px;">
                                            </select>

                                            <span style=" margin-left: 2px;" onclick="changeLampGroupe()" class="label label-info" >更换</span>
                                        </td>
                                        <td></td>
                                        <td>
                                            <!--                                            <span style="margin-left:15px;">控制方式</span>&nbsp;
                                                                                        <span class="menuBox">
                                                                                            <select name="l_worktype" id="l_worktype" class="input-sm" style="width:150px;">
                                                                                                <option value="0" selected="selected">走时间</option>
                                                                                                <option value="1" >走场景</option>
                                                                                            </select>
                                                                                        </span>    -->
                                        </td>
                                    </tr> 


                                </tbody>
                            </table>                            
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer" id="modal_footer_edit" >
                            <!-- 添加按钮 -->
                            <button id="xiugai" class="btn btn-primary">修改</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!--修改组号-->

    </body>
</html>