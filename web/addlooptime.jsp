<%-- 
    Document   : addloop
    Created on : 2018-7-16, 15:08:00
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <script src="select2-developr/dist/js/select2.js"></script>
        <link href="select2-develop/dist/css/select2.css" rel="stylesheet" />


        <link rel="stylesheet" type="text/css" href="gatewayconfig_files/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="gatewayconfig_files/bootstrap-table.css">
        <script type="text/javascript" src="gatewayconfig_files/jquery.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap-table.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap-table-zh-CN.js"></script>
        <link type="text/css" href="gatewayconfig_files/basicInformation.css" rel="stylesheet">
        <!-- easyui -->
        <link href="gatewayconfig_files/easyui.css" rel="stylesheet" type="text/css" switch="switch-style">
        <link href="gatewayconfig_files/icon.css" rel="stylesheet" type="text/css">
        <script src="gatewayconfig_files/jquery_002.js" type="text/javascript"></script>
        <script src="gatewayconfig_files/easyui-lang-zh_CN.js" type="text/javascript"></script>
        <script type="text/javascript" src="gatewayconfig_files/selectAjaxFunction.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap-multiselect.js"></script>
        <link rel="stylesheet" href="gatewayconfig_files/bootstrap-multiselect.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="gatewayconfig_files/layer.css">
        <script type="text/javascript" src="gatewayconfig_files/layer.js"></script>

        <script type="text/javascript" src="js/genel.js"></script>
        <script>
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {
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

            })

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


        </script>
    </head>
    <body>
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
            <!--注脚--> 
            <div class="modal-footer">
                <!--添加按钮--> 
                <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>
                <!--                                     关闭按钮 -->
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </form>


    </body>
</html>
