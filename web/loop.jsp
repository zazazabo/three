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
<!--
        <script src="select2-developr/dist/js/select2.js"></script>
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
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            var websocket = null;
            function gz(param) {
                if (websocket.readyState == 3) {
                    layerAler("服务端没连接上");
                    return;
                }
                if (param == 0) {

                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    console.log(selects);
                } else if (param == 1) {
                }
                //alert(param);
            }

            function addLoopModal() {
                $("#modal_addloop").modal({
                    remote: "addloop.jsp"
                });
            }

            function modifyLoopName() {
                var formobj = $("#Form_Modify").serializeObject();
                console.log(formobj.select_l_groupe);
                formobj.id = formobj.txt_hide_id
                formobj.l_name = formobj.txt_l_name;
                formobj.l_groupe = formobj.select_l_groupe;

                $.ajax({
                    url: "test1.loop.modifyname.action",
                    type: "POST",
                    datatype: "JSON",
                    data: formobj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            layer.open({
                                content: '修改成功',
                                icon: 1,
                                yes: function (index, layero) {
                                    $("#gravidaTable").bootstrapTable('refresh');
                                    layer.close(index);
                                    // layer.close(index) window.parent.document.getElementsByClassName('J_iframe')[0].src = "device/gatewayConfig.action";
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
                var num = ""
                if (selects.length == 1) {
                    num = selects[0];
                } else {
                    for (var i = 0; i < selects.length; i++) {
                        num += selects[i].id + ",";
                    }
                }

                if (num == 0) {
                    layer.alert('请选择您要编辑的记录', {
                        icon: 6,
                        offset: 'center'
                    });
                } else if (num > 1) {
                    layerAler("只能选一条数据");
                } else {
                    var select = selects[0];
                    $("#txt_l_code").val(select.l_code);
                    $("#txt_l_comaddr").val(select.comaddr);

                    $("#txt_name").val(select.name);
                    $("#txt_l_name").val(select.l_name);
                    $("#txt_hide_id").val(select.id);
                    if (select.l_deplayment == 0) {
                        $("#tr_iddeploy").hide();
                    }

                    $("#select_l_groupe").empty();
                    for (var i = 1; i < 19; i++) {
                        if (select.l_groupe == i.toString()) {
                            var str = "<option selected='true'  value='" + i.toString() + "'>" + i.toString() + "</option>";
                            $("#select_l_groupe").append(str);
                        } else {
                            var str = "<option   value='" + i.toString() + "'>" + i.toString() + "</option>";
                            $("#select_l_groupe").append(str);
                        }
                    }
                    $("#select_l_groupe").attr("enabled", false);


                    //$("#txt_l_groupe").val(select.l_groupe);
                    $("#pjj2").modal();


                }

            }




            $(function () {

                $("#pjj2").on("show.bs.modal", function () {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    var num = ""
                    if (selects.length == 1) {
                        num = selects[0];
                    } else {
                        for (var i = 0; i < selects.length; i++) {
                            num += selects[i].id + ",";
                        }
                    }

                    if (num == 0) {
                        layer.alert('请选择您要编辑的记录', {
                            icon: 6,
                            offset: 'center'
                        });
                    } else if (num > 1) {
                        layerAler("只能选一条数据");
                    } else {

                        var select = selects[0];
                        console.log(select);

//                        console.log(select);
//                        var param = "id=" + select.id + "&comaddr=" + select.comaddr + "&name=" + select.name + "&l_code=" + select.l_code + "&l_deplayment=" + select.l_deplayment
//                                + "&l_name=" + select.l_name + "&.l_worktype=" + select.l_worktype + "&l_plan=" + select.l_plan + "&l_groupe=" + select.l_groupe;
//
//                        param = encodeURI(param);
//                        console.log(param);

                    }
                })


                $('#gravidaTable').bootstrapTable({url: 'test1.f5.loop.action',
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
                            title: '组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {

                                if (value == 0) {
                                    value = "0";
                                    return value;
                                } else {
                                    value = value.toString()
                                    return value;
                                }
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
                                    value = "1(经纬度)";
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
                    singleSelect: true,
                    clickToSelect: true,
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
                
                    
                 
           
                
                
                $("#select_l_comaddr").change(function () {
                    var name1 = $(this).find("option:selected").attr("detail");
                    $("#txt_name").val(name1);
                })
                $("#select_p_plan").change(function () {
                    var val1 = $("#select_l_worktype").val();
                    $("#txt_plan_detail").val("");
                    var options = $("#select_p_plan option:selected");
                    var detail = $(options).attr("detail");
                    if (detail == undefined) {
                        return;
                    }
                    var obj = eval('(' + detail + ')');
                    if (obj.hasOwnProperty("loop")) {
                        var obj1 = obj.loop[0];
                        if (val1 == 0) {   //回路的时间方案
                            var str = "闭合时间:" + obj1.start + "断开时间:" + obj1.end;
                            $("#txt_plan_detail").val(str);
                        } else if (val1 == 1) {

                        }

                    }
                });
                $("#select_l_worktype").change(function () {

                    var val1 = $("#select_l_worktype").val();
                    $.ajax({
                        url: "test1.gayway.comaddr.action", type: 'get', dataType: 'JSON', data: {p_type: val1},
                        error: function () {
                            layerAler("获取方案列表制作")
                        },
                        success: function (data) {
                            $("#select_p_plan").empty();
                            console.log(data.pl);
                            var arrlist = data.pl;
                            for (var i = 0; i < arrlist.length; i++) {
                                var objlist = arrlist[i];
                                var str = "<option detail='" + objlist.p_content + "' value='" + objlist.p_code + "'>" + objlist.p_name + "</option>";
                                console.log(str);
                                $("#select_p_plan").append(str); //添加option

                            }
                            $("#txt_plan_detail").val("");
                            var options = $("#select_p_plan option:selected");
                            var detail = $(options).attr("detail");
                            var obj = eval('(' + detail + ')');
                            console.log(obj);
                            if (obj.hasOwnProperty("loop")) {
                                var obj1 = obj.loop[0];
                                if (val1 == 0) {   //回路的时间方案
                                    var str = "闭合时间:" + obj1.start + "断开时间:" + obj1.end;
                                    $("#txt_plan_detail").val(str);
                                } else if (val1 == 1) {

                                }

                            }
                        }
                    })




                });
                $('#pjj').on('show.bs.modal', function () {
                    $("#select_l_groupe").empty();
                    for (var i = 1; i < 19; i++) {
                        var str = "<option value=\"" + i.toString() + "\">" + i.toString() + "</option>";
                        $("#select_l_groupe").append(str);
                    }
                    $("#select_l_groupe").find("option[value=\"1\"]").attr("selected", true);
                    $.ajax({
                        url: "test1.gayway.comaddr.action",
                        type: "get",
                        datatype: "JSON",
                        data: {p_type: 0},
                        success: function (data) {
                            console.log(data);
                            $("#select_l_comaddr").empty();
                            var arrlist = data.rs;
                            for (var i = 0; i < arrlist.length; i++) {
                                var objlist = arrlist[i];
                                console.log(objlist.model); //comaddr
                                // var str = "<option value='" + objlist.name + "'>" + objlist.comaddr + "</option>";
                                var str = "<option detail='" + objlist.name + "' value='" + objlist.comaddr + "'>" + objlist.comaddr + "</option>";
                                $("#select_l_comaddr").append(str); //添加option
                            }
                            $("#txt_name").val($("#select_l_comaddr option:selected").attr("detail")); //设置网关名


                            $("#select_p_plan").empty();
                            var arrlist = data.pl;
                            for (var i = 0; i < arrlist.length; i++) {
                                var objlist = arrlist[i];
                                var str = "<option detail='" + objlist.p_content + "' value='" + objlist.p_code + "'>" + objlist.p_name + "</option>";
                                console.log(str);
                                $("#select_p_plan").append(str); //添加option
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                })

                $("#shanchu").click(function () {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    console.log(selects);
                    var num = ""
                    if (selects.length == 1) {
                        num = selects[0];
                    } else {
                        for (var i = 0; i < selects.length; i++) {
                            num += selects[i].id + ",";
                        }
                    }

                    if (num == 0) {
                        layer.alert('请选择您要删除的记录', {
                            icon: 6,
                            offset: 'center'
                        });
                    } else {
                        layer.confirm('您确定要删除吗？', {
                            btn: ['确定', '取消'], //按钮
                            icon: 3,
                            offset: 'center',
                            title: '提示'
                        }, function (index) {

                            if (selects.length == 1) {

                                if (num.l_deployment == 1) {
                                    layer.alert('此回路已部署,不能', {
                                        icon: 6,
                                        offset: 'center'
                                    });
                                }

                                $.ajax({
                                    url: "test1.loop.deleteLoop.action",
                                    type: "POST",
                                    datatype: "JSON",
                                    data: {
                                        id: num.uid
                                    },
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            layer.open({
                                                content: '删除成功',
                                                icon: 1,
                                                yes: function (index, layero) {
                                                    $("#gravidaTable").bootstrapTable('refresh');
                                                    layer.close(index);
                                                    // layer.close(index) window.parent.document.getElementsByClassName('J_iframe')[0].src = "device/gatewayConfig.action";
                                                }
                                            });
                                        }
                                        layer.close(index);
//                                    
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                            } else {
                                layer.alert('只能选择一行进行修改', {
                                    icon: 6,
                                    offset: 'center'
                                });
                            }


                        });
                    }


                });
                $("#btnmodify1").click(function () {

                    var l_id = $("#txt_hide_id").val();
                    var l_plan = $("#select_p_plan1").val();
                    $.ajax({
                        url: "test1.loop.modifyplan.action", type: 'get', dataType: 'JSON', data: {id_: l_id, l_plan: l_plan},
                        success: function (data) {

                            $("#gravidaTable").bootstrapTable('refresh');
//                            $('#timestrategy').modal('hide');
                        },
                        error: function () {
                            layerAler("修改回路方案错误");
                        }
                    });
//                      $('#timestrategy').modal('hide');
                });
                $('#select_p_plan1').change(function () {
                    var p_code = $(this).val();
                    $.ajax({
                        url: "test1.loop.getPlan.action", type: 'get', dataType: 'JSON', data: {p_code: p_code},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var objlist = arrlist[0];
                                var jsonstr = objlist.p_content;
                                var obj = eval('(' + jsonstr + ')');
                                if (obj.hasOwnProperty("loop")) {
                                    var val = obj.loop[0];
                                    $("#txttimein").val(val.start);
                                    $("#txttimeout").val(val.end);
                                }


                            }
                        }, error: function () {

                        }
                    })

                });
                $('#gravidaTable').on("dbl-click-cell.bs.table", function (field, value, row, element) {

                    if (value == "l_plan") {

                        if (element.l_deplayment != 1) {
                            layerAler("请部署好回路,才能更改方案");
                            return;
                        }
                        console.log(element);
                        $("#txt_hide_id").val(element.uid);
                        $.ajax({
                            url: "test1.loop.getPlan.action", type: 'get', dataType: 'JSON', data: {p_attr: 0, p_type: element.l_worktype},
                            success: function (data) {
                                var arrlist = data.rs;
                                $('#select_p_plan1').empty();
                                for (var i = 0; i < arrlist.length; i++) {
                                    var objlist = arrlist[i];
                                    var jsonstr = objlist.p_content;
                                    var strselect = "";
                                    if (element.l_plan == objlist.p_code) {

                                        var obj = eval('(' + jsonstr + ')');
                                        if (obj.hasOwnProperty("loop")) {
                                            var val = obj.loop[0];
                                            $("#txttimein").val(val.start);
                                            $("#txttimeout").val(val.end);
                                        }
                                    }
                                    var str = "<option   +  value='" + objlist.p_code + "' >" + objlist.p_name + "</option>";
                                    console.log(str);
                                    $("#select_p_plan1").append(str);
                                }

                                // $("#select_p_plan1").find("option[value=\"" + element.l_plan +"\"]").attr("selected",true);
                                var strattr = "option[value=\"" + element.l_plan + "\"]";
                                //console.log(strattr);
                                $("#select_p_plan1").find(strattr).attr("selected", true);
                            }, error: function () {
                                layerAler("获取回路列表失败");
                            }
                        })
                        $("#timestrategy").modal();
                    }



                    console.log(element);
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
                    console.log("loop onmessage");
                    var ArrData = JSON.parse(e.data);
                    console.log(ArrData);
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


        <!--        <a data-toggle="modal" href="lamp.jsp" data-target="#modal">Click me</a>-->


        <!-- 页面中的弹层代码 -->
        <div class="modal" id="modal_addloop">
            <div class="modal-dialog">
                <div class="modal-content"></div>
            </div>
        </div>


        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <!--data-toggle="modal" data-target="#pjj"-->
            <!--onclick="addLoopModal()-->
            <button class="btn btn-success ctrol" onclick="addLoopModal()" >  
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <!--id="xiugai1"-->
            <!--onclick="modifyModal()-->
            <button class="btn btn-primary ctrol"  onclick="modifyModal();" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <!--        <button class="btn btn-danger ctrol" id="closews">
                        <span class="glyphicon glyphicon-trash"></span>&nbsp;关闭websocket
                    </button>         
                    <button class="btn btn-danger ctrol" id="addback">
                        <span class="glyphicon glyphicon-trash"></span>&nbsp;添加回路
                    </button>       -->


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

            <div class="bootstrap-table">

                <div class="fixed-table-container" style="height: 214px; padding-bottom: 0px;">

                    <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                    </table>


                    <!--                    <div class="fixed-table-header">
                                            <table></table>
                                        </div>
                                        <div class="fixed-table-body">
                                            <div class="fixed-table-loading" style="top: 42px; display: none;">正在努力地加载数据中，请稍候……</div>
                          
                                        </div>-->
                </div
            </div>
        </div>




        <!-- 添加 -->
        <!--        <div class="modal" id="pjj">
                    <div class="modal-dialog">
                        <div class="modal-content" style="min-width:700px;">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">
                                    <span style="font-size:20px ">×</span></button>
                                <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                                <h4 class="modal-title" style="display: inline;">添加回路配置</h4></div>
        
                            <form action="" method="POST" id="eqpTypeForm" onsubmit="return checkLoopAdd()">      
                                <div class="modal-body">
                                    <table>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <span style="margin-left:20px;">网关名称</span>&nbsp;
                                                    <input id="txt_name" readonly="true"   class="form-control"  name="txt_name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>
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
                                                    <span style="margin-left:20px;">回路名称</span>&nbsp;
                                                    <input id="l_name" class="form-control"  name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                                                <td></td>
                                                <td>
                                                    <span style="margin-left:10px;">回路编号&nbsp;</span>
                                                    <input id="l_code" class="form-control" name="l_code" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">
                                                </td>
                                                </td>
                                            </tr>                                   
        
                                            <tr>
                                                <td>
                                                    <span style="margin-left:20px;">控制方式</span>&nbsp;
                                                    <span class="menuBox">
                                                        <select name="select_l_worktype" id="select_l_worktype" class="input-sm" style="width:150px;">
                                                            <option value="0" selected="selected">走时间</option>
                                                            <option value="1" >走经纬度</option>
                                                        </select>
                                                    </span> 
        
                                                </td>
                                                <td></td>
                                                <td>
                                                    <span style="margin-left:10px;">控制方案&nbsp;</span>
                                                    <span class="menuBox">
                                                        <select name="select_p_plan" id="select_p_plan" class="input-sm" style="width:150px;">
                                                        </select>
                                                    </span>    
                                                </td>
                                            </tr>                                   
        
                                            <tr>
                                                <td>
                                                    <span style="margin-left:20px;">回路组号</span>&nbsp;
                                                    <span class="menuBox">
                                                        <select name="select_l_groupe" id="select_l_groupe" class="input-sm" style="width:150px;">
                                                        </select>
                                                    </span> 
        
                                                </td>
                                                <td></td>
                                                <td>
                                                    <span style="margin-left:10px;">方案内容&nbsp;</span>
                                                    <input id="txt_plan_detail" readonly="true" class="form-control" name="txt_plan_detail" style="width:150px;display: inline;" placeholder="方案详情" type="text">
                                                </td>
                                            </tr>                 
        
        
                                        </tbody>
                                    </table>
                                </div>
                                注脚 
                                <div class="modal-footer">
                                    添加按钮 
                                    <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>
                                                                         关闭按钮 
                                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                            </form>
                        </div>
                    </div>
                </div>-->




        <!-- 修改 -->


        <div class="modal" id="pjj2">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                    </div>
                    <form action="" method="POST" id="Form_Modify" onsubmit="return modifyLoopName()">  
                        <input type="hidden" id="txt_hide_id" name="txt_hide_id" />
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">网关名称</span>&nbsp;
                                            <input id="txt_name" readonly="true" value=""   class="form-control"  name="txt_name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">网关地址&nbsp;</span>
                                            <span class="menuBox">
                                                <input id="txt_l_comaddr" readonly="true" value=""   class="form-control"  name="txt_l_comaddr" style="width:150px;display: inline;" placeholder="网关地址" type="text"></td>

                                            </span>    
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">回路名称</span>&nbsp;
                                            <input id="txt_l_name" class="form-control" value=""  name="txt_l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">回路编号&nbsp;</span>
                                            <input id="txt_l_code" readonly="true" class="form-control" value="" name="txt_l_code" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">
                                        </td>
                                        </td>
                                    </tr>                                   

                                    <tr id="tr_iddeploy" >
                                        <td>
                                            <span style="margin-left:20px;">控制方式</span>&nbsp;
                                            <span class="menuBox">
                                                <select name="select_l_worktype" id="select_l_worktype"  class="input-sm" style="width:150px;">
                                                    <option value="0" selected="selected">走时间</option>
                                                    <option value="1" >走经纬度</option>
                                                </select>
                                            </span> 

                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:10px;">控制方案&nbsp;</span>
                                            <span class="menuBox">
                                                <select name="select_p_plan" id="select_p_plan" class="input-sm" style="width:150px;">
                                                </select>
                                            </span>    
                                        </td>
                                    </tr>                                   

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">回路组号</span>&nbsp;
                                            <span class="menuBox">

                                                <!--                                                <input id="txt_l_groupe" readonly="true" class="form-control" value="" name="txt_l_groupe" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">-->
                                                <select name="select_l_groupe" id="select_l_groupe" class="input-sm" style="width:150px;">
                                                </select>
                                            </span> 

                                        </td>
                                        <td></td>
                                        <td>
                                            <!--                                <span style="margin-left:10px;">方案内容&nbsp;</span>
                                                                            <input id="txt_plan_detail" readonly="true" class="form-control" name="txt_plan_detail" style="width:150px;display: inline;" placeholder="方案详情" type="text">-->
                                        </td>
                                    </tr>                 


                                </tbody>
                            </table>
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer">
                            <!-- 添加按钮 -->
                            <button id="btn_modify"  class="btn btn-primary">修改</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>



        <!-- 修改时间方案 -->
        <div class="modal" id="timestrategy">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">修改时间方案</h4></div>



                    <div class="modal-body">
                        <table>
                            <tbody>
                            <input type="hidden" name="txt_hide_comaddr" id="txt_hide_comaddr" value=""> 
                            <input type="hidden" name="txt_hide_loopcode" id="txt_hide_loopcode" value=""> 
                            <input type="hidden" name="txt_hide_id" id="txt_hide_id" value=""> 
                            <tr>
                                <td>
                                    <span style="margin-left:20px;">方案列表&nbsp;</span>
                                    <span class="menuBox">
                                        <select name="select_p_plan1" id="select_p_plan1" class="input-sm" style="width:150px;">
                                        </select>
                                    </span>  

                                </td>

                                <td>


                                </td>
                            </tr>     

                            <tr>
                                <td>
                                    <span style="margin-left:20px;">闭合时间</span>&nbsp;
                                    <input id="txttimein" class="form-control" readonly="true" name="txttimein" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>
                                <td></td>
                                <td>
                                    <span style="margin-left:10px;">断开时间&nbsp;</span>
                                    <input id="txttimeout" class="form-control" name="txttimeout" readonly="true" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text">
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 添加按钮 -->
                        <button id="btnmodify1"  class="btn btn-primary">修改</button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                </div>
            </div>
        </div> 


        <!-- 修改时间方案 -->
        <div class="modal" id="jwstrategy">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">修改方案</h4></div>
                    <div class="modal-body">
                        <table>
                            <tbody>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">日落偏移</span>&nbsp;
                                        <input id="timein" class="form-control" name="timein" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">日出偏移&nbsp;</span>
                                        <input id="timeout" class="form-control" name="timeou  t" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text">
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 添加按钮 -->
                        <button id="xiugai" class="btn btn-primary">确定</button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                </div>
            </div>
        </div> 
        <div id="planconten">

        </div>
    </body>
</html>
