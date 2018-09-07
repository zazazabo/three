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
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function checkPlanLampAdd() {

                var a = $("#Form_Add").serializeObject();
                var obj1 = {"time": a.time1, "value": parseInt(a.val1)};
                var obj2 = {"time": a.time2, "value": parseInt(a.val2)};
                var obj3 = {"time": a.time3, "value": parseInt(a.val3)};
                var obj4 = {"time": a.time4, "value": parseInt(a.val4)};
                var obj5 = {"time": a.time5, "value": parseInt(a.val5)};
                var obj6 = {"time": a.time6, "value": parseInt(a.val6)};
                a.p_name = a.txt_p_name;
                a.p_type = a.select_type;
                a.p_time1 = JSON.stringify(obj1);
                a.p_time2 = JSON.stringify(obj2);
                a.p_time3 = JSON.stringify(obj3);
                a.p_time4 = JSON.stringify(obj4);
                a.p_time5 = JSON.stringify(obj5);
                a.p_time6 = JSON.stringify(obj6);
                var ret = false;
                ;
                $.ajax({async: false, url: "test1.plan.addlamp.action", type: "get", datatype: "JSON", data: a,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            ret = true;
                            $("#table_lamp").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

                return ret;
            }


            function editlampplan_finish() {

                $("#select_type_edit").attr("disabled", false);
                var a = $("#Form_EDIT").serializeObject();
                console.log(a);
                var obj1 = {"time": a.time1_edit, "value": parseInt(a.val1)};
                var obj2 = {"time": a.time2_edit, "value": parseInt(a.val2)};
                var obj3 = {"time": a.time3_edit, "value": parseInt(a.val3)};
                var obj4 = {"time": a.time4_edit, "value": parseInt(a.val4)};
                var obj5 = {"time": a.time5_edit, "value": parseInt(a.val5)};
                var obj6 = {"time": a.time6_edit, "value": parseInt(a.val6)};
                a.p_name = a.txt_p_name_edit;

                a.p_time1 = JSON.stringify(obj1);
                a.p_time2 = JSON.stringify(obj2);
                a.p_time3 = JSON.stringify(obj3);
                a.p_time4 = JSON.stringify(obj4);
                a.p_time5 = JSON.stringify(obj5);
                a.p_time6 = JSON.stringify(obj6);
                a.id = a.txt_hidden_id_edit;

                var ret = false;
                $.ajax({async: false, url: "test1.plan.editlamp.action", type: "get", datatype: "JSON", data: a,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            ret = true;
                            $("#table_lamp").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });

                return ret;

            }

            function editlampplan() {
                var selects = $('#table_lamp').bootstrapTable('getSelections');
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
                $("#txt_hidden_id_edit").val(select.id);
                $("#txt_p_name_edit").val(select.p_name);
                var obj1 = eval('(' + select.p_time1 + ')');
                var obj2 = eval('(' + select.p_time2 + ')');
                var obj3 = eval('(' + select.p_time3 + ')');
                var obj4 = eval('(' + select.p_time4 + ')');
                var obj5 = eval('(' + select.p_time5 + ')');
                var obj6 = eval('(' + select.p_time6 + ')');

                var valinput = $("input[name='val1']")[1];
                $(valinput).val(obj1.value);
                var valinput = $("input[name='val2']")[1];
                $(valinput).val(obj2.value);
                var valinput = $("input[name='val3']")[1];
                $(valinput).val(obj3.value);
                var valinput = $("input[name='val4']")[1];
                $(valinput).val(obj4.value);
                var valinput = $("input[name='val5']")[1];
                $(valinput).val(obj5.value);
                var valinput = $("input[name='val6']")[1];
                $(valinput).val(obj6.value);
                $('#time1_edit').timespinner('setValue', obj1.time);
                $('#time2_edit').timespinner('setValue', obj2.time);
                $('#time3_edit').timespinner('setValue', obj3.time);
                $('#time4_edit').timespinner('setValue', obj4.time);
                $('#time5_edit').timespinner('setValue', obj5.time);
                $('#time6_edit').timespinner('setValue', obj6.time);


                // $('#ss').timespinner('setValue', '17:45');  
                // $('#box').timespinner
                // $("input[name='time1']")[1].timespinner('setValue','10:11');
                // var inputtime=$(".easyui-timespinner'")[
                // $(inputtime).timespinner('setValue','10:20');
                // $(valinput).val(obj1.time);
                // var valinput= $("input[name='time2']")[1];
                // $(valinput).val(obj2.time);
                // var valinput= $("input[name='time3']")[1];
                // $(valinput).val(obj3.time);
                // var valinput= $("input[name='time4']")[1];
                // $(valinput).val(obj4.time);
                // var valinput= $("input[name='time5']")[1];
                // $(valinput).val(obj5.time);
                // var valinput= $("input[name='time6']")[1];
                // $(valinput).val(obj6.time);
                $("#MODAL_EDIT").modal();
                return false;
            }

            function deletelampplan() {
                var selects = $('#table_lamp').bootstrapTable('getSelections');
                for (var i = 0; i < selects.length; i++) {
                    var select = selects[i];
                    $.ajax({async: false, url: "test1.plan.deleteloop.action", type: "get", datatype: "JSON", data: {id: select.id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $('#table_lamp').bootstrapTable('refresh');
                            }

                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
            }


            $(function () {

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

                                if (rs[i].code == "400201" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400202" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "400203" && rs[i].enable != 0) {
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
                $("#modal_add").on("hidden.bs.modal", function () {
                    $(this).removeData("bs.modal");
                });




                $('#table_lamp').bootstrapTable({
                    url: 'test1.plan.getLoopPlan.action?p_attr=1',
                    clickToSelect: true,
                    columns: [
                        [
                            {
                                title: '单选',
                                field: 'select',
                                //复选框
                                checkbox: true,
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1

                            },
                            {
                                field: 'p_name',
                                title: '方案名',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_code',
                                title: '方案编号',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2,
                                colspan: 1
                            },
                            {
                                field: 'p_time',
                                title: '时间一',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间二',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间三',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间四',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间五',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            },
                            {
                                field: 'p_time',
                                title: '时间六',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 2,
                                rowspan: 1

                            }
                        ], [
                            {
                                field: 'p_time1',
                                title: '时间',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val1',
                                title: '调光值',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time1)) {
                                        var obj = eval('(' + row.p_time1 + ')');
                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }


                                    }

                                }

                            }, {
                                field: 'p_time2',
                                title: '时间',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val2',
                                title: '调光值',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time2)) {
                                        var obj = eval('(' + row.p_time2 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time3',
                                title: '时间',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val3',
                                title: '调光值',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time3)) {
                                        var obj = eval('(' + row.p_time3 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time4',
                                title: '时间',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val4',
                                title: '调光值',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time4)) {
                                        var obj = eval('(' + row.p_time4 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time5',
                                title: '时间',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val5',
                                title: '调光值',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time5)) {
                                        var obj = eval('(' + row.p_time5 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }, {
                                field: 'p_time6',
                                title: '时间',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {

                                    if (isJSON(value)) {
                                        var obj = eval('(' + value + ')');
                                        return obj.time;
                                    }

                                }
                            },
                            {
                                field: 'p_val6',
                                title: '调光值',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 1,
                                formatter: function (value, row, index, field) {
                                    // console.log(row);
                                    if (isJSON(row.p_time6)) {
                                        var obj = eval('(' + row.p_time6 + ')');

                                        if (obj.value != null) {
                                            return obj.value.toString();
                                        }
                                    }

                                }
                            }
                        ]
                    ],
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


            })

        </script>

        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>

    </head>

    <body>







        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#modal_add" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol"   onclick="editlampplan()"  id="update">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deletelampplan();" id="del" >
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <span style="margin-left:20px;">方案类型&nbsp;</span>
            <span class="menuBox">
                <select name="select_type_query" id="select_type_query" class="input-sm" style="width:150px;">
                    <option value="0">时间</option>
                    <option value="1">场景</option>
                </select>
            </span> 
        </div>
        <div class="bootstrap-table">
            <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">
                <table id="table_lamp" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>  
            </div>
        </div>


        <!-- 添加灯具方案 -->
        <div class="modal" id="modal_add">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">灯具方案添加</h4>
                    </div>

                    <form action="" method="POST" id="Form_Add" onsubmit="return checkPlanLampAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">方案类型&nbsp;</span>
                                            <span class="menuBox">
                                                <select name="select_type" id="select_type" class="input-sm" style="width:150px;">
                                                    <option value="0">时间</option>
                                                    <option value="1">场景</option>
                                                </select>
                                            </span>  
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">方案名字</span>&nbsp;
                                            <input id="txt_p_name" class="form-control"  name="txt_p_name" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间一</span>&nbsp;

                                            <input id="time1"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val1" class="form-control" name="val1" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr>                                   
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间二</span>&nbsp;
                                            <input id="time2" name="time2" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val2" class="form-control" name="val2" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间三</span>&nbsp;
                                            <input id="time3" name="time3" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val3" class="form-control" name="val3" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间四</span>&nbsp;
                                            <input id="time4" name="time4" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val4" class="form-control" name="val4" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间五</span>&nbsp;
                                            <input id="time5" name="time5" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val5" class="form-control" name="val5" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间六</span>&nbsp;
                                            <input id="time6" name="time6" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val6" class="form-control" name="val6" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                </tbody>
                            </table>
                        </div>
                        <!--注脚--> 
                        <div class="modal-footer">
                            <!--添加按钮--> 
                            <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>
                            <!--                                     关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>



                </div>
            </div>
        </div> 

        <!--修改灯具方案-->
        <div class="modal" id="MODAL_EDIT">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">灯具方案修改</h4>
                    </div>

                    <form action="" method="POST" id="Form_EDIT" onsubmit="return checkPlanLampEdit()">  
                        <input type="hidden" id="txt_hidden_id_edit" name="txt_hidden_id_edit">    
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">方案类型&nbsp;</span>
                                            <span class="menuBox">
                                                <select name="select_type_edit" disabled="true" id="select_type_edit" class="input-sm" style="width:150px;">
                                                    <option value="0">时间</option>
                                                    <option value="1">场景</option>
                                                </select>
                                            </span>  
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">方案名字</span>&nbsp;
                                            <input id="txt_p_name_edit" class="form-control"  name="txt_p_name_edit" style="width:150px;display: inline;" placeholder="请输入方案名" type="text"></td>

                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间一</span>&nbsp;

                                            <input id="time1_edit"  name="time1_edit" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val1" value="" class="form-control" name="val1" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr>                                   
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间二</span>&nbsp;
                                            <input id="time2_edit" name="time2_edit" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val2" class="form-control" name="val2" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间三</span>&nbsp;
                                            <input id="time3_edit" name="time3_edit" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val3" class="form-control" name="val3" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间四</span>&nbsp;
                                            <input id="time4_edit" name="time4_edit" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val4" class="form-control" name="val4" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间五</span>&nbsp;
                                            <input id="time5_edit" name="time5_edit" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val5" class="form-control" name="val5" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">时 &nbsp; 间六</span>&nbsp;
                                            <input id="time6_edit" name="time6_edit" style=" height: 30px; width: 150px" class="easyui-timespinner">
                                        </td> 
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                                            <input id="val6" class="form-control" name="val6" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">
                                        </td>
                                    </tr> 
                                </tbody>
                            </table>
                        </div>
                        <!--注脚--> 
                        <div class="modal-footer">
                            <!--添加按钮--> 
                            <button  type="button" class="btn btn-primary" onclick="editlampplan_finish()"  >修改</button>
                            <!--                                     关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>


                </div>
            </div>
        </div>

    </body>
</html>