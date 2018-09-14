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


            $(function () {
                $("#select_l_groupe").empty();
                for (var i = 1; i < 19; i++) {
                    var str = "<option value=\"" + i.toString() + "\">" + i.toString() + "</option>";
                    $("#select_l_groupe").append(str);
                }
                $("#select_l_groupe").find("option[value=\"1\"]").attr("selected", true);
                $("#select_l_comaddr").change(function () {
                    var name1 = $(this).find("option:selected").attr("detail");
                    $("#txt_name").val(name1);
                })



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
                        $("#txt_name").val($("#select_l_comaddr option:selected").attr("detail"));  //设置网关名


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


            function checkLoopAdd() {
                var formdata = $("#eqpTypeForm").serializeObject();
                if (formdata.l_code == "" || formdata.select_l_comaddr == "") {
                    layerAler("网关或回路和编号不能为空");
                }
                var addr = $("#select_l_comaddr").val();
                var code = formdata.l_code;
                console.log(formdata);

                $.ajax({
                    async: false,
                    cache: false,
                    url: "test1.loop.getloop.action",
                    type: "GET",
                    data: {
                        l_code: code,
                        l_comaddr: addr
                    },
                    success: function (data) {
                        console.log(data);

                        if (data.total > 0) {
                            namesss = false;
                            layer.alert('此回路已存在', {
                                icon: 6,
                                offset: 'center'
                            });
                        }
                        if (data.total == 0) {
                            var jsondata = $("#eqpTypeForm").serializeObject();
                            jsondata.l_comaddr = jsondata.select_l_comaddr;
                            jsondata.l_groupe = jsondata.select_l_groupe;
                            jsondata.l_worktype = jsondata.select_l_worktype;
                            console.log(jsondata);
                            $.ajax({async: false, cache: false, url: "test1.loop.addloop.action", type: "GET", data: jsondata,
                                success: function (data) {
                                    $("#gravidaTable").bootstrapTable('refresh');
                                    namesss = true;
                                },
                                error: function () {
                                    layer.alert('系统错误，刷新后重试', {
                                        icon: 6,
                                        offset: 'center'
                                    });
                                }
                            });
                            return  false;
                        }
                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {
                            icon: 6,
                            offset: 'center'
                        });
                        return namesss;
                    }

                })


                return  namesss;
            }


        </script>
    </head>
    <body>
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">
                <span style="font-size:20px ">×</span></button>
            <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
            <h4 class="modal-title" style="display: inline;">添加回路配置</h4>
        </div>

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

                        <!--                        <tr>
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
                                                </tr>                                   -->

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
                                <span style="margin-left:10px;">控制方式</span>&nbsp;
                                <span class="menuBox">
                                    <select name="select_l_worktype" id="select_l_worktype" class="input-sm" style="width:150px;">
                                        <option value="0" selected="selected">走时间</option>
                                        <option value="1" >走经纬度</option>
                                    </select>
                                </span> 
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
