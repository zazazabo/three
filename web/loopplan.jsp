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
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function editloopplan_finish() {
//                $("#select_type_edit").attr("disabled", false);
                var obj = $("#Form_edit").serializeObject();

                obj.p_outtime = obj.outtime_edit;
                obj.p_name = obj.txt_p_name_edit;
                obj.p_intime = obj.intime_edit;
                obj.id = obj.txt_hidden_id;
                obj.p_Longitude = obj.longitudem26d_edit + "." + obj.longitudem26m_edit + "." + obj.longitudem26s_edit;
                obj.p_latitude = obj.latitudem26d_edit + "." + obj.latitudem26m_edit + "." + obj.latitudem26s_edit;
                var code = $("#p_code").val();
                var url = "";
                if (obj.select_type_edit == "0") {
                    url = "test1.plan.editlooptime.action";
                }
                if (obj.select_type_edit == "1") {
                    url = "test1.plan.editloopjw.action";
                }

                $.ajax({async: false, url: url, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            var nobj2 = {};
                            nobj2.name = u_name;
                            var day = getNowFormatDate2();
                            nobj2.time = day;
                            nobj2.comment = "对方案编号为：" + code + "进行修改";
                            $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj2,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length > 0) {

                                    }
                                }
                            });
                            var url = "test1.plan.getLoopPlan.action";
                            var obj1 = {p_type: obj.select_type_edit};
                            var opt = {
                                url: url,
                                silent: true,
                                query: obj1
                            };
                            $("#table_loop").bootstrapTable('refresh', opt);
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
//                console.log(obj);
//                ,p_intime,

            }

            function editloopplan() {
                var selects = $('#table_loop').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请选择表格数据");
                    return false;
                } else if (selects.length > 1) {
                    layerAler("只能编辑单行数据");
                    return false;
                }
                $("#select_type_edit").combobox('readonly', true);

//
                var select = selects[0];
                console.log(select);
                $("#txt_p_name_edit").val(select.p_name);
                $('#intime_edit').timespinner('setValue', select.p_intime);
                $('#outtime_edit').timespinner('setValue', select.p_outtime);
                $("#txt_hidden_id").val(select.id);
                $("#p_code").val(select.p_code);
                if (select.p_type == "0") {
                    $("#tr_time_hide").show();
                    $("#tr_jw_hide").hide();
                    $('#select_type_edit').combobox('select', '0');

                } else if (select.p_type == "1") {
                    $("#tr_time_hide").hide();
                    $("#tr_jw_hide").show();
                    $('#select_type_edit').combobox('select', "1");
                    var long = select.p_Longitude;
                    var lati = select.p_latitude;
                    var l1 = long.split(".");
                    var l2 = lati.split(".");
                    $("#longitudem26d_edit").val(l1[0]);
                    $("#longitudem26m_edit").val(l1[1]);
                    $("#longitudem26s_edit").val(l1[2]);

                    $("#latitudem26d_edit").val(l2[0]);
                    $("#latitudem26m_edit").val(l2[1]);
                    $("#latitudem26s_edit").val(l2[2]);


                }
                $("#modal_plan_loop").modal();
                return false;
            }

            function deleteloopplan() {
                var selects = $('#table_loop').bootstrapTable('getSelections');
                for (var i = 0; i < selects.length; i++) {
                    var select = selects[i];
                    var code = select.p_code;
                    $.ajax({async: false, url: "test1.plan.deleteloop.action", type: "get", datatype: "JSON", data: {id: select.id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var nobj2 = {};
                                nobj2.name = u_name;
                                var day = getNowFormatDate2();
                                nobj2.time = day;
                                nobj2.comment = "删除方案编号为：" + code + "的回路方案";
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj2,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                                $('#table_loop').bootstrapTable('refresh');
                            }

                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
            }

            function checkPlanLoopAdd() {
                var obj = $("#addform").serializeObject();
                console.log(obj);


                obj.p_name = obj.txt_p_name;
                obj.p_type = obj.select_type;
                obj.p_outtime = obj.outtime;
                obj.p_intime = obj.intime;
                obj.p_Longitude = obj.longitudem26m + "." + obj.longitudem26s + "." + obj.latitudem26d;
                obj.p_latitude = obj.latitudem26d + "." + obj.latitudem26m + "." + obj.latitudem26s;


                var url = "";
                if (obj.p_type == 1) {

                    if (obj.longitudem26m == "" || obj.longitudem26s == "" || obj.latitudem26d == "") {
                        layerAler("经度不能为空");
                        return;
                    }

                    if (obj.latitudem26d == "" || obj.latitudem26m == "" || obj.latitudem26s == "") {
                        layerAler("纬度不能为空");
                        return;
                    }
                    url = "test1.plan.addlooplt.action";

                }
                if (obj.p_type == 0) {
                    if (obj.p_intime == "" || obj.p_outtime == "") {
                        layerAler("断开和闭合时间不能为空");
                        return false;
                    }
                    url = "test1.plan.addlooptime.action";
                }

                var ret = false;
                $.ajax({async: false, url: url, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                             var nobj2 = {};
                                nobj2.name = u_name;
                                var day = getNowFormatDate2();
                                nobj2.time = day;
                                nobj2.comment = "添加回路方案：" + obj.p_name;
                                $.ajax({async: false, url: "login.oplog.addoplog.action", type: "get", datatype: "JSON", data: nobj2,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {

                                        }
                                    }
                                });
                            ret = false;
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
//                return ret;
            }



            $(function () {


//                $("#add").attr("disabled", true);
//                $("#update").attr("disabled", true);
//                $("#del").attr("disabled", true);
//                var obj = {};
//                obj.code = ${param.m_parent};
//                obj.roletype = ${param.role};
//                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
//                    success: function (data) {
//                        var rs = data.rs;
//                        if (rs.length > 0) {
//                            for (var i = 0; i < rs.length; i++) {
//                                if (rs[i].code == "400101" && rs[i].enable != 0) {
//                                    $("#add").attr("disabled", false);
//                                    continue;
//                                }
//                                if (rs[i].code == "400102" && rs[i].enable != 0) {
//                                    $("#update").attr("disabled", false);
//                                    continue;
//                                }
//                                if (rs[i].code == "400103" && rs[i].enable != 0) {
//                                    $("#del").attr("disabled", false);
//                                    continue;
//                                }
//                            }
//                        }
//                    },
//                    error: function () {
//                        alert("提交失败！");
//                    }
//                });




                $('#intime').timespinner('setValue', '00:00');
                $('#outtime').timespinner('setValue', '23:00');


                $("#tr_jw_hide_add").hide();

                $('#select_type').combobox({
                    onSelect: function (record) {
                        if (record.value == "0") {
                            $("#tr_jw_hide_add").hide();
                            $("#tr_time_hide_add").show();
                        }
                        if (record.value == "1")
                        {
                            $("#tr_jw_hide_add").show();
                            $("#tr_time_hide_add").hide();
                        }
                        console.log(record);
                    }
                });


                $("#select_type_query").combobox({
                    onSelect: function (record) {
                        var url = "test1.plan.getLoopPlan.action";
                        var obj = {p_type: record.value};
                        var opt = {
                            url: url,
                            silent: true,
                            query: obj
                        };

                        $("#table_loop").bootstrapTable('refresh', opt);


//                        if (record.value == "0") {
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_Longitude');
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_latitude');
//                            $("#table_loop").bootstrapTable('showColumn', 'p_outtime');
//                            $("#table_loop").bootstrapTable('showColumn', 'p_intime');
//                        }
//                        if (record.value == "1")
//                        {
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_outtime');
//                            $("#table_loop").bootstrapTable('hideColumn', 'p_intime');
//
//                            $("#table_loop").bootstrapTable('showColumn', 'p_Longitude');
//                            $("#table_loop").bootstrapTable('showColumn', 'p_latitude');
//                        }
//                        console.log(record);
                    }
                })
                $("#select_type_query").combobox('select', '0');
                var p_type = $("#select_type_query").combobox('getValue');
//                console.log(p_type);
                var url = "test1.plan.getLoopPlan.action";
                $('#table_loop').bootstrapTable({
                    url: url,
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
                            field: 'p_name',
                            title: '方案名',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_code',
                            title: '方案编号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_intime',
                            title: '闭合时间',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_outtime',
                            title: '断开时间',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_Longitude',
                            title: '经度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_latitude',
                            title: '纬度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'p_attr',
                            title: '方案类型',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.p_type == "0") {
                                    return "时间方案";
                                } else if (row.p_type == "1") {
                                    return "经纬度方案";
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
                            type_id: "1",
                            p_attr: "0",
                            p_type: p_type   
                        };      
                        return temp;  
                    },
                });
            })

        </script>

        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>

    </head>

    <body>
        <!--<div style=" margin-left: 10px" class="panel panel-info">-->
        <!--<div class="panel-heading">回路方案</div>-->





        <div class="btn-group zuheanniu" id="btn_add" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <!-- data-toggle="modal" data-target="#pjj" -->
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#modal_add" id="add" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol" type="button"   onclick="editloopplan();" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteloopplan();" id="del">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>

            <span style="margin-left:20px;">方案类型&nbsp;</span>
            <span class="menuBox">

                <select class="easyui-combobox" data-options="editable:false" id="select_type_query" name="select_type_query" style="width:150px; height: 30px">
                    <option value="0">时间</option>
                    <option value="1">经纬度</option>           
                </select>

                <!--                <select name="select_type_query" id="select_type_query" class="input-sm" style="width:150px;">
                                    <option value="0">时间</option>
                                    <option value="1">经纬度</option>
                                </select>-->
            </span>  

        </div>
        <!--        <div class="bootstrap-table">
                    <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">-->
        <table id="table_loop" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table> 
        <!--            </div>
                </div>-->


        <!--</div>-->




        <!-- 添加 -->

        <div class="modal" id="modal_add">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">回路方案添加</h4>
                    </div>

                    <form action="" method="POST" id="addform" onsubmit="return checkPlanLoopAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">方案类型&nbsp;</span>
                                            <span class="menuBox">
                                                <select class="easyui-combobox" data-options="editable:false" id="select_type" name="select_type" style="width:150px; height: 30px">
                                                    <option value="0">时间</option>
                                                    <option value="1">经纬度</option>           
                                                </select>
                                            </span>  
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">方案名字</span>&nbsp;
                                            <input id="txt_p_name" class="form-control"  name="txt_p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                                        </td>
                                    </tr>

                                    <tr id="tr_time_hide_add">
                                        <td>
                                            <span style="margin-left:20px;">闭合时间</span>&nbsp;
                                            <!--<input id="intime" class="form-control"  name="intime" style="width:150px;display: inline;" placeholder="请输入闭合时间" type="text">-->
                                            <input id="intime" name="intime" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">断开时间&nbsp;</span>
                                            <input id="outtime" name="outtime" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                                        </td>
                                        </td>
                                    </tr>                                   

                                    <tr id="tr_jw_hide_add">
                                        <td>
                                            <span style="margin-left:20px;">区域经度</span>&nbsp;
                                            <input id="longitudem26d" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                            <input id="longitudem26m" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                            <input id="longitudem26s" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">区域纬度&nbsp;</span>
                                            <input id="latitudem26d" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                            <input id="latitudem26m" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                            <input id="latitudem26s" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                                        </td>
                                    </tr>



                                </tbody>
                            </table>
                        </div>

                        <div class="modal-footer">

                            <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>

                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>



                </div>
            </div>
        </div> 

        <!--修改回路方案-->
        <div class="modal" id="modal_plan_loop">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">回路方案修改</h4>
                    </div>

                    <form action="" method="POST" id="Form_edit" onsubmit="return checkPlanLoopAdd()">      
                        <input type="hidden" id="txt_hidden_id" name="txt_hidden_id" />
                        <input type="hidden" id="p_code"  />
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">方案类型&nbsp;</span>
                                            <span class="menuBox">


                                                <select class="easyui-combobox" data-options="editable:false" id="select_type_edit" name="select_type_edit" style="width:150px; height: 34px">
                                                    <option value="0">时间</option>
                                                    <option value="1">经纬度</option>           
                                                </select>

                                            </span>  
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">方案名字</span>&nbsp;
                                            <input id="txt_p_name_edit" class="form-control"  name="txt_p_name_edit" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                                        </td>
                                    </tr>

                                    <tr id="tr_time_hide">
                                        <td>
                                            <span style="margin-left:20px;">闭合时间</span>&nbsp;
                                            <!--<input id="intime_edit" class="form-control"  name="intime_edit" style="width:150px;display: inline;" placeholder="请输入闭合时间" type="text">-->
                                            <input id="intime_edit" name="intime_edit" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">

                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">断开时间&nbsp;</span>
                                            <!--<input id="outtime_edit" class="form-control" name="outtime_edit" style="width:150px;display: inline;" placeholder="请输入断开时间" type="text">-->
                                            <input id="outtime_edit" name="outtime_edit" style=" height: 34px; width: 150px;  "  class="easyui-timespinner">
                                        </td>
                                        </td>
                                    </tr>                                   

                                    <tr id="tr_jw_hide" >
                                        <td>
                                            <span style="margin-left:20px;">区域经度</span>&nbsp;
                                            <input id="longitudem26d_edit" class="form-control" name="longitudem26d_edit" style="width:51px;display: inline;" type="text">&nbsp;°
                                            <input id="longitudem26m_edit" class="form-control" name="longitudem26m_edit" style="width:45px;display: inline;" type="text">&nbsp;'
                                            <input id="longitudem26s_edit" class="form-control" name="longitudem26s_edit" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">区域纬度&nbsp;</span>
                                            <input id="latitudem26d_edit" class="form-control" name="latitudem26d_edit" style="width:51px;display: inline;" type="text">&nbsp;°
                                            <input id="latitudem26m_edit" class="form-control" name="latitudem26m_edit" style="width:45px;display: inline;" type="text">&nbsp;'
                                            <input id="latitudem26s_edit" class="form-control" name="latitudem26s_edit" style="width:45px;display: inline;" type="text">&nbsp;"
                                        </td>
                                    </tr>



                                </tbody>
                            </table>
                        </div>
                        <!--注脚--> 
                        <div class="modal-footer">
                            <!--添加按钮--> 
                            <button onclick="editloopplan_finish()" type="button" class="btn btn-primary">修改</button>
                            <!--                                     关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>

                </div>
            </div>
        </div>

    </body>
</html>