<%-- 
    Document   : modifyloop
    Created on : 2018-7-16, 16:35:02
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

            var websocket = null;
            $(function () {
                for (var i = 1; i < 19; i++) {

                    var temp
                    if ("${param.l_groupe}" == i.toString()) {
                        var str = "<option selected='true'  value='" + i.toString() + "'>" + i.toString() + "</option>";
                        $("#select_l_groupe").append(str);
                    } else {
                        var str = "<option   value='" + i.toString() + "'>" + i.toString() + "</option>";
                        $("#select_l_groupe").append(str);
                    }
                }
            })


            function  checkLoopModify() {
                //  alert("aaa");
            }


            function modifygroupe() {

            }


        </script>


    </head>
    <body>
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">
                <span style="font-size:20px ">×</span></button>
            <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
            <h4 class="modal-title" style="display: inline;">修改回路配置</h4>
        </div>
        <!--
                <form action="#" method="POST" id="eqpTypeForm" onsubmit="return checkLoopModify()">      
                    <input type="hidden" id="txt_hide_id" name="txt_hide_id" value="${param.id}"/>
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">网关名称</span>&nbsp;
                                        <input id="txt_name" readonly="true" value="${param.name}"   class="form-control"  name="txt_name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">网关地址&nbsp;</span>
                                        <span class="menuBox">
                                            <input id="txt_l_comaddr" readonly="true" value="${param.comaddr}"   class="form-control"  name="txt_l_comaddr" style="width:150px;display: inline;" placeholder="网关地址" type="text"></td>
        
                                        </span>    
                                    </td>
                                </tr>
        
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">回路名称</span>&nbsp;
                                        <input id="l_name" class="form-control" value="${param.l_name}"  name="l_name" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">回路编号&nbsp;</span>
                                        <input id="l_code" readonly="true" class="form-control" value="${param.l_code}" name="l_code" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">
                                    </td>
                                    </td>
                                </tr>                                   
        
                                <tr>
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
                                            
                                                <input id="l_groupe" readonly="true" class="form-control" value="${param.l_groupe}" name="l_groupe" style="width:150px;display: inline;" placeholder="请输入回路名称" type="text">
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
                        <button id="modifygourpe" type="button" onclick="modifygroupe();" class="btn btn-primary">修改组号</button>
        
                        <button id="modifyworktype" type="button" onclick="modifyworktype();" class="btn btn-primary">修改工作方式</button>
        
                        <button id="modifyplan" type="button" onclick="modifyplan();" class="btn btn-primary">设定工作方案</button>
        
                        <button type="button"  onclick="modifyLoopName();"  class="btn btn-primary">修改</button>
                                                             关闭按钮 
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </form>
        -->
    </body>
</html>
