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
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function editloopplan_finish() {
                $("#select_type_edit").attr("disabled", false);
                var obj = $("#Form_edit").serializeObject();
                obj.p_outtime = obj.txt_p_outtime_edit;
                obj.p_name = obj.txt_p_name_edit;
                obj.p_intime = obj.txt_p_intime_edit;
                obj.id = obj.txt_hidden_id;
                $.ajax({async: false, url: "test1.plan.editloop.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            $("#table_loop").bootstrapTable('refresh');
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

                var select = selects[0];
                $("#select_type_edit").attr("disabled", false);
                $("#select_type_edit").val(select.p_type);
                $("#select_type_edit").attr("disabled", true);
                $("#txt_hidden_id").val(select.id);
                if (select.p_type == "0") {
                    $("#tr_jw_hide").hide();
                } else if (select.p_type == 1) {
                    $("#tr_time_hide").hide();
                }

//                 p_outtime,p_intime,p_name
                $("#txt_p_intime_edit").val(select.p_intime);

                $("#txt_p_outtime_edit").val(select.p_outtime);
                $("#txt_p_name_edit").val(select.p_name);

                $("#modal_plan_loop").modal();
                return false;
            }

            function deleteloopplan() {
                var selects = $('#table_loop').bootstrapTable('getSelections');
                for (var i = 0; i < selects.length; i++) {
                    var select = selects[i];

                    $.ajax({async: false, url: "test1.plan.deleteloop.action", type: "get", datatype: "JSON", data: {id: select.id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
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
                var obj = $("#eqpTypeForm").serializeObject();
                console.log(obj);
                obj.p_outtime = obj.txt_p_outtime;
                obj.p_intime = obj.txt_p_intime;
                obj.p_name = obj.txt_p_name;
                obj.p_type = obj.select_type;
                if (obj.p_type == 0) {
                    if (obj.p_intime == "" || obj.p_outtime == "") {
                        layerAler("断开和闭合时间不能为空");
                        return false;
                    }

                }
                var ret = false;

                $.ajax({async: false, url: "test1.plan.addloop.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            ret = true;
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                return ret;
            }



            $(function (){ 
                
                $("#add").attr("disabled", true);
                $("#update").attr("disabled", true);
                $("#del").attr("disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {

                                if (rs[i].code == "400101" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400102" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400103" && rs[i].enable != 0) {
                                    $("#del").attr("disabled", false);
                                    continue;
                                }
                            }
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
               
                $("#tr_jw_hide_add").hide();

                $("#select_type").change(function () {
                    var val = $(this).val();
                    if (val == 0) {
                        $("#tr_jw_hide_add").hide();
                        $("#tr_time_hide_add").show();
                    } else if (val == 1) {
                        $("#tr_jw_hide_add").show();
                        $("#tr_time_hide_add").hide();
                    }
                });

                var p_type = $("#select_type_query").val();
                var url = "test1.plan.getLoopPlan.action?p_attr=0&p_type=" + p_type;
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
                            type_id: "1"    
                        };      
                        return temp;  
                    },
                });

                $("#table_loop").bootstrapTable('hideColumn', 'p_Longitude');
                $("#table_loop").bootstrapTable('hideColumn', 'p_latitude');

                $("#select_type_query").change(function () {
                    var val = $(this).val();
                    var p_type = $(this).val();
                    var url = "test1.plan.getLoopPlan.action?p_attr=0&p_type=" + p_type;

                    $("#event_table").bootstrapTable('refreshOptions', {url: url});
                    if (val == "0") {
                        $("#table_loop").bootstrapTable('hideColumn', 'p_Longitude');
                        $("#table_loop").bootstrapTable('hideColumn', 'p_latitude');
                        $("#table_loop").bootstrapTable('showColumn', 'p_outtime');
                        $("#table_loop").bootstrapTable('showColumn', 'p_intime');

                    } else if (val == "1") {
                        $("#table_loop").bootstrapTable('hideColumn', 'p_outtime');
                        $("#table_loop").bootstrapTable('hideColumn', 'p_intime');

                        $("#table_loop").bootstrapTable('showColumn', 'p_Longitude');
                        $("#table_loop").bootstrapTable('showColumn', 'p_latitude');
                    }

                });
                console.log(options);

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
                <button class="btn btn-success ctrol" data-toggle="modal" data-target="#modal_add" id="add"  >
                    <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
                </button>
                <button class="btn btn-primary ctrol" type="button"   onclick="editloopplan();" id="update"  >
                    <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
                </button>
                <button class="btn btn-danger ctrol" onclick="deleteloopplan();" id="del" >
                    <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
                </button>
                <span style="margin-left:20px;">方案类型&nbsp;</span>
                <span class="menuBox">
                    <select name="select_type_query" id="select_type_query" class="input-sm" style="width:150px;">
                        <option value="0">时间</option>
                        <option value="1">经纬度</option>
                    </select>
                </span>  

            </div>
            <div class="bootstrap-table">
                <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">
                    <table id="table_loop" style="width:100%;" class="text-nowrap table table-hover table-striped">
                    </table> 
                </div>
            </div>


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

                    <form action="" method="POST" id="eqpTypeForm" onsubmit="return checkPlanLoopAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">方案类型&nbsp;</span>
                                            <span class="menuBox">
                                                <select name="select_type" id="select_type" class="input-sm" style="width:150px;">
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
                                            <input id="txt_p_intime" class="form-control"  name="txt_p_intime" style="width:150px;display: inline;" placeholder="请输入闭合时间" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">断开时间&nbsp;</span>
                                            <input id="txt_p_outtime" class="form-control" name="txt_p_outtime" style="width:150px;display: inline;" placeholder="请输入断开时间" type="text">
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
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">方案类型&nbsp;</span>
                                            <span class="menuBox">
                                                <select name="select_type_edit" disabled="true" id="select_type_edit" class="input-sm" style="width:150px;">
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
                                            <input id="txt_p_intime_edit" class="form-control"  name="txt_p_intime_edit" style="width:150px;display: inline;" placeholder="请输入闭合时间" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">断开时间&nbsp;</span>
                                            <input id="txt_p_outtime_edit" class="form-control" name="txt_p_outtime_edit" style="width:150px;display: inline;" placeholder="请输入断开时间" type="text">
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