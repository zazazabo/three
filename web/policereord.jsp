<%-- 
    Document   : policereord
    Created on : 2018-9-13, 15:40:10
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>报警记录</title>
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <link rel="stylesheet" type="text/css" href="bootstrap-3.3.7-dist/css/bootstrap.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <script>
            $(function () {
                $('#reordtabel').bootstrapTable({
                    url: 'login.policereord.reordInfo.action',
                    columns: [
                        {
                            field: 'f_comaddr',
                            title: '设备名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_type',
                            title: '异常类型',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_day',
                            title: '时间',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_status1',
                            title: '处理状态',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "已处理";
                                    return  value;
                                }
                                if (value == 1) {
                                    value = "未处理";
                                    return  value;
                                }
                            }
                        }, {
                            field: 'f_comment',
                            title: '异常说明',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                        }, {
                            field: 'f_state',
                            title: '信息发送状态',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "已发送";
                                    return value;
                                } else if (value == 1) {
                                    value = "未发送";
                                    return value;
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
                $("#select").click(function () {
                    var statr = $("#sday").val();
                    var end = $("#eday").val();
                    var obj = {};

                    if (statr == "" && end == "") {
                        alert("请选择要查询的时间段");
                        return;
                    }
                    if (statr == "") {
                       
                        obj.statr = "2017-01-01";
                    } else {
                        obj.statr = statr;
                    }
                    if (end == "") {
                        var d = new Date();
                        end = d.toLocaleDateString();
                        obj.end = end;
                    } else {
                        obj.end = end;
                    }
                    var opt = {
                        url: "login.policereord.reordInfo.action",
                        silent: true,
                        query: obj
                    };
                    $("#reordtabel").bootstrapTable('refresh', opt);
                });
                 $(".day").datetimepicker({
                    format: 'yyyy/mm/dd',
                    language: 'zh-CN',
                    minView: "month",
                    todayBtn: 1,
                    autoclose: 1
                });
            });
        </script>
    </head>
    <body>
<!--        <div style="float:left;position:relative;z-index:100;margin:12px 0 20px 50px; font-size: 18px">
            <span>搜索时间：<input type="date" id="startime"/></span>
            <span style="margin-left: 10px">至：<input type="date" id="endtime"/></span>
            <span><input type="button" class="btn btn-sm btn-success" value="查询" id="select"></span>
        </div>-->
        <div style="margin-top:15px; font-size: 18px;margin-left: 10px;" id="Day">
            <form action="" id="day1" class="form-horizontal" role="form" style="float:left; width: 166px;">
                <label for="dtp_input2" class="control-label" style="float: left;"></label>
                <input id="dtp_input2" value="" type="hidden">
                <span class="input-group date col-md-2 day" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                    <input id="sday" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </span>
            </form>
            <span style=" font-size: 18px; float: left; margin-top: 4px;">&nbsp;至&nbsp;</span>
            <form action="" id="day2" class="form-horizontal" role="form" style="float:left; width: 166px;">
                <label for="dtp_input2" class="control-label" style="float: left;"></label>
                <input id="dtp_input2" value="" type="hidden">
                <span class="input-group date col-md-2 day" style="float:initial;" data-date=""  data-link-field="dtp_input2">
                    <input id="eday" name="day"  class="form-control" style="width:90px;" size="16" readonly="readonly" type="text">
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </span>
            </form>
            <span style="font-size: 18px; margin-left: 10px;">
                <button type="button" class="btn btn-sm btn-success" id="select" >查询</button>
            </span>
            <button style=" height: 30px;" type="button" id="btn_download" class="btn btn-primary" onClick ="$('#reordtabel').tableExport({type: 'excel', escape: 'false'})">导出Excel</button>
        </div>
        <div>
            <table id="reordtabel">

            </table>
        </div>
    </body>
</html>
