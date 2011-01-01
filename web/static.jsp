<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<!DOCTYPE html>
<html xmlns:f="http://java.sun.com/jsf/core">
    <head>
        <%@include  file="js.jspf" %>
        <script type="text/javascript" src="js/genel.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <link rel="stylesheet" type="text/css" href="bootstrap-3.3.7-dist/css/bootstrap.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        <style type="text/css">
            #div2{
                display: none;
            }
            #div1{
                display: none;
            }
            #gravidaMonthTable{
                border: 1px solid;
                text-align:center;
                vertical-align:middle;
                margin-left: 10%;
            }
            #gravidaMonthTable tr th{
                border: 1px solid #ccc;
                text-align:center;
                height: 50px;
                font-size: 24px;
            }
            /*            #gravidaMonthTable tr:nth-of-type(even){ background:#ffcc00;}偶数行 */
            #gravidaMonthTable tr td{
                border: 1px solid #ccc;
                height: 40px;
            }
            #sum{
                font-size: 18px;
                color: red;
            }
            #year{
                height: 30px;
                border: 1px solid #01AAED;
                border-radius:5px;
            }
        </style>
        <script>
            function getyear() {
                //按年查询
                $('#getYearTable').bootstrapTable({
                    //url: 'login.reportmanage.getyear.action?pid=' + pid2,
                    columns: [[{
                                field: '',
                                title: '年消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 5
                            }], [
                            {
                                field: 'years',
                                title: '年份',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
//                                        formatter: function (value, row, index) {
//                                           
//                                        }

                            }, {
                                field: 'val',
                                title: '消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }]
                    ],
                    showExport: true, //是否显示导出
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    // minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
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
                    }
                });
                var porjectId = parent.parent.getpojectId();
                var obj = {};

                if ($("#fs").val() == "2") {
                    obj.comaddr = $("#comaddrlist").val();
                } else {
                    obj.pid = porjectId;
                }

                if ($("#syear").val() != "" && $("#eyear").val() != "") {
                    obj.star = $("#syear").val();
                    obj.end = $("#eyear").val();
                }
                //加载所有网关信息
                var opt = {
                    //method: "post",
                    url: "login.reportmanage.getyear.action",
                    silent: true,
                    query: obj
                };
                $("#getYearTable").bootstrapTable('refresh', opt);

                $("#div1").hide();
                $("#div2").hide();
                $("#div3").show();
            }

            //按日查询
            function getday() {
                 $('#getdayTable').bootstrapTable({
                    // url: 'login.reportmanage.getday.action?pid=' + pid2,
                    columns: [[{
                                field: '',
                                title: '日消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 5
                            }], [
                            {
                                field: 'd',
                                title: '日期',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'val',
                                title: '消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }]
                    ],
                    showExport: true, //是否显示导出
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    // minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
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
                    }
                });
                var porjectId = parent.parent.getpojectId();
                var obj = {};

                if ($("#fs").val() == "2") {
                    obj.comaddr = $("#comaddrlist").val();
                } else {
                    obj.pid = porjectId;
                }

                if ($("#sday").val() != "" && $("#eday").val() != "") {
                    obj.star = $("#sday").val();
                    obj.end = $("#eday").val();
                }
                //加载所有网关信息
                var opt = {
                    //method: "post",
                    url: "login.reportmanage.getday.action",
                    silent: true,
                    query: obj
                };
                $("#getdayTable").bootstrapTable('refresh', opt);
                $("#div1").show();
                $("#div2").hide();
                $("#div3").hide();
            }
            ;

            function getMoth() {
                //按月查询
                $('#getMotherTable').bootstrapTable({
                    //url: 'login.reportmanage.getmother.action?pid=' + pid2,
                    columns: [[{
                                field: '',
                                title: '月消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 5
                            }], [
                            {
                                field: 'mother',
                                title: '月份',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
//                                        formatter: function (value, row, index) {
//                                           
//                                        }

                            }, {
                                field: 'val',
                                title: '消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }]
                    ],
                    showExport: true, //是否显示导出
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    // minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
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
                    }
                });
                var porjectId = parent.parent.getpojectId();
                var obj = {};

                if ($("#fs").val() == "2") {
                    obj.comaddr = $("#comaddrlist").val();
                } else {
                    obj.pid = porjectId;
                }
                if ($("#smother").val() != "" && $("#emother").val() != "") {
                    obj.star = $("#smother").val();
                    obj.end = $("#emother").val();
                }
                //加载所有网关信息
                var opt = {
                    //method: "post",
                    url: "login.reportmanage.getmother.action",
                    silent: true,
                    query: obj
                };
                $("#getMotherTable").bootstrapTable('refresh', opt);
                $("#div1").hide();
                $("#div2").show();
                $("#div3").hide();
            }
        </script>

        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
        <style>
            * { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; }
        </style>

    </head>

    <body>
        <div style="width: 100%;">
            <br>
            <span style="margin-top: 10px; font-size: 18px;margin-left: 28px;">
                查看方式：
                <select  style="width:100px;border-radius:5px;" id="fs">
                    <option value="1">项目</option>
                    <option value="2">网关</option>
                </select>
            </span>
            <span id="list" style="display:none; margin-top: 10px;">
                <input id="comaddrlist" data-options='editable:false,valueField:"id", textField:"text"' class="easyui-combobox"/>
            </span>
        </div>
        <div style=" margin-top: 10px;">
            <span style="margin-top: 10px; font-size: 18px;margin-left: 10px;">
                年—月—日：
                <select  style="width:100px;border-radius:5px;" id="YMD">
                    <option value="1">按年查询</option>
                    <option value="2">按月查询</option>
                    <option value="3">按日查询</option>
                </select>
            </span>
            <div style="margin-top:15px; font-size: 18px;margin-left: 10px; display: none;" id="Day">
                <form action="" id="day1" class="form-horizontal" role="form" style="float:left;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date col-md-2 day" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                        <input id="sday" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>
                <span style=" font-size: 18px; float: left; margin-top: 4px;">&nbsp;至&nbsp;</span>
                <form action="" id="day2" class="form-horizontal" role="form" style="float:left;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date col-md-2 day" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                        <input id="eday" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>
                <span style="font-size: 18px; margin-left: 10px;">
                    <button type="button" class="btn btn-sm btn-success" onclick="getday()" >按日显示数据</button>
                </span>
            </div>

            <div style="margin-top:15px; font-size: 18px;margin-left: 10px; display: none" id="MOth">
                <form action="" id="Mother1" class="form-horizontal" role="form" style="float:left;width: 166px;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date col-md-2 m" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                        <input id="smother" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>
                <span style=" font-size: 18px; float: left; margin-top: 4px;">&nbsp;至&nbsp;</span>
                <form action="" id="Mother2" class="form-horizontal" role="form" style="float:left;width: 166px;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date col-md-2 m" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                        <input id="emother" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>
                <span style="font-size: 18px; margin-left: 10px;">
                    <button type="button" class="btn btn-sm btn-success" onclick="getMoth()" >按月显示数据</button>
                </span>
            </div>

            <div style="margin-top:15px; font-size: 18px;margin-left: 10px;" id="Year">
                <form action="" id="formyear" class="form-horizontal" role="form" style="float:left;width: 166px;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date form_date col-md-2" style="float:initial;" data-date="" data-date-format="yyyy" data-link-field="dtp_input2" data-link-format="yyyy">
                        <input id="syear" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>
                <span style="font-size: 18px;float: left; margin-top: 4px;">&nbsp;至&nbsp;</span>
                <form action="" id="formyear2" class="form-horizontal" role="form" style="float:left;width: 166px;">
                    <label for="dtp_input2" class="control-label" style="float: left;"></label>
                    <input id="dtp_input2" value="" type="hidden">
                    <span class="input-group date form_date col-md-2" style="float:initial;" data-date="" data-date-format="yyyy" data-link-field="dtp_input2" data-link-format="yyyy">
                        <input id="eyear" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                    </span>
                </form>
                <span style=" margin-left: 10px;">
                    <button type="button" class="btn btn-sm btn-success" onclick="getyear()" >按年份显示数据</button>
                </span>
            </div>
        </div>

        <hr>
        <div style="" id="div1">
            <table id="getdayTable">
            </table>
        </div>
        <div id="div2" style="">
            <table id="getMotherTable">
            </table>
        </div>
        <div id="div3">          
            <table id="getYearTable"   class="text-nowrap table table-hover table-striped">
            </table>
        </div>

        <script>
            $(function () {
                var pid2 = parent.parent.getpojectId();
//                $('#getdayTable').bootstrapTable({
//                    // url: 'login.reportmanage.getday.action?pid=' + pid2,
//                    columns: [[{
//                                field: '',
//                                title: '日消耗量',
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle',
//                                colspan: 5
//                            }], [
//                            {
//                                field: 'd',
//                                title: '日期',
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle'
//                            }, {
//                                field: 'val',
//                                title: '消耗量',
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle'
//                            }]
//                    ],
//                    showExport: true, //是否显示导出
//                    singleSelect: true,
//                    sortName: 'id',
//                    locale: 'zh-CN', //中文支持,
//                    // minimumCountColumns: 7, //最少显示多少列
//                    showColumns: true,
//                    sortOrder: 'desc',
//                    pagination: true,
//                    sidePagination: 'server',
//                    pageNumber: 1,
//                    pageSize: 10,
//                    showRefresh: true,
//                    showToggle: true,
//                    // 设置默认分页为 50
//                    pageList: [5, 10, 15, 20, 25],
//                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
//                    },
//                    //服务器url
//                    queryParams: function (params)  {   //配置参数     
//                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
//                            search: params.search,
//                            skip: params.offset,
//                            limit: params.limit,
//                            type_id: "1"   
//                        };      
//                        return temp;  
//                    }
//                });
//                //按月查询
//                $('#getMotherTable').bootstrapTable({
//                    //url: 'login.reportmanage.getmother.action?pid=' + pid2,
//                    columns: [[{
//                                field: '',
//                                title: '月消耗量',
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle',
//                                colspan: 5
//                            }], [
//                            {
//                                field: 'mother',
//                                title: '月份',
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle'
////                                        formatter: function (value, row, index) {
////                                           
////                                        }
//
//                            }, {
//                                field: 'val',
//                                title: '消耗量',
//                                width: 25,
//                                align: 'center',
//                                valign: 'middle'
//                            }]
//                    ],
//                    showExport: true, //是否显示导出
//                    singleSelect: true,
//                    sortName: 'id',
//                    locale: 'zh-CN', //中文支持,
//                    // minimumCountColumns: 7, //最少显示多少列
//                    showColumns: true,
//                    sortOrder: 'desc',
//                    pagination: true,
//                    sidePagination: 'server',
//                    pageNumber: 1,
//                    pageSize: 10,
//                    showRefresh: true,
//                    showToggle: true,
//                    // 设置默认分页为 50
//                    pageList: [5, 10, 15, 20, 25],
//                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
//                    },
//                    //服务器url
//                    queryParams: function (params)  {   //配置参数     
//                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
//                            search: params.search,
//                            skip: params.offset,
//                            limit: params.limit,
//                            type_id: "1"   
//                        };      
//                        return temp;  
//                    }
//                });
//                //按年查询
                $('#getYearTable').bootstrapTable({
                    url: 'login.reportmanage.getyear.action?pid=' + pid2,
                    columns: [[{
                                field: '',
                                title: '年消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 5
                            }], [
                            {
                                field: 'years',
                                title: '年份',
                                width: 25,
                                align: 'center',
                                valign: 'middle'

                            }, {
                                field: 'val',
                                title: '消耗量',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }]
                    ],
                    showExport: true, //是否显示导出
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    // minimumCountColumns: 7, //最少显示多少列
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.info("加载成功");
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
                    }
                });
                var id = "#comaddrlist";
                var pid = parent.parent.getpojectId();
                combobox(id, pid);

                $("#fs").change(function () {
                    if ($(this).val() == "2") {
                        $("#list").show();
                    }
                    if ($(this).val() == "1") {
                        $("#list").hide();
                    }
                });
                 $("#YMD").change(function () {
                    if ($(this).val() == "1") {
                        $("#Year").show();
                        $("#MOth").hide();
                        $("#Day").hide();
                    }else if ($(this).val() == "2") {
                        $("#Year").hide();
                        $("#MOth").show();
                        $("#Day").hide();
                    } else if ($(this).val() == "3") {
                         $("#Year").hide();
                        $("#MOth").hide();
                        $("#Day").show();
                    }
                });
            });
            $('.form_date').datetimepicker({
                language: 'zh',
                weekStart: 1,
                todayBtn: 1,
                autoclose: 1,
                startView: 'decade',
                minView: 'decade',
                format: 'yyyy',
                maxViewMode: 2,
                minViewMode: 2
            });
            $(".m").datetimepicker({
                format: 'yyyy-mm',
                autoclose: true,
                todayBtn: true,
                startView: 'year',
                minView: 'year',
                maxView: 'decade',
                language: 'zh-CN'

            });

            $(".day").datetimepicker({
                format: 'yyyy/mm/dd',
                language: 'zh-CN',
                minView: "month",
                todayBtn: 1,
                autoclose: 1
            });

            //网关下拉框
            function combobox(id, pid) {
                $(id).combobox({
                    url: "login.map.getallcomaddr.action?pid=" + pid,
                    onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                        $(this).val(data[0].text);
                    }
                });
            }
        </script>

    </body>
</html>