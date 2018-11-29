<%-- 
    Document   : loopmanage
    Created on : 2018-7-4, 14:39:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tld/fn.tld" prefix="fn" %>
<!DOCTYPE html>
<html xmlns:f="http://java.sun.com/jsf/core">
    <head>
        <%@include  file="js.jspf" %>
        <script type="text/javascript" src="js/genel.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="bootstrap-datetimepicker/bootstrap-datetimepicker.css">
        <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.js"></script>
        <c:if test="${param.lang=='zh_CN'}">
            <script src="bootstrap-datetimepicker/bootstrap-datetimepicker.zh-CN.js"></script>
        </c:if>


    </head>
    <script>
        var lang = '${param.lang}';//'zh_CN';
        var langs1 = parent.parent.getLnas();
        $(function () {
            var aaa = $("span[name=xxx]");
            for (var i = 0; i < aaa.length; i++) {
                var d = aaa[i];
                var e = $(d).attr("id");
                $(d).html(langs1[e][lang]);
            }
            $('#project').combobox({
                onSelect: function (record) {
                    if (record.id == "1") {
                        $("#g1").show();
                    } else {
                        $("#g1").hide();
                    }

                },
                formatter: function (row) {
                    var langid = parseInt(row.id);
                    if (langid == 0) {
                        langid = 1;
                    } else if (langid == 1) {
                        langid = 50;
                    }
                    row.text = langs1[langid][lang];
                    var opts = $(this).combobox('options');
                    return row[opts.textField];
                }
            });

            $('#comaddr').combobox({
                url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                onLoadSuccess: function (data) {
                    if (Array.isArray(data) && data.length > 0) {
                        $(this).combobox("select", data[0].id);
                        $("#comaddrname").val(data[0].name);
                    }
                }
            });
            $('#querytype').combobox({
                onLoadSuccess: function (data) {
                    if (Array.isArray(data) && data.length > 0) {
                        $(this).combobox("select", data[0].id);
                    }

                },
                onSelect: function (record) {
//                    for (var i = 0; i < 3; i++) {
//                        var temp = (i + 1).toString();
//                        if (temp == record.id) {
//                            $("#divv" + temp).show();
//                        } else {
//                            $("#divv" + temp).hide();
//                        }
//                    }
                    if (record.id == 1) {
                        $("#divv1").hide();
                        $("#divv2").hide();
                        $("#divv3").show();
                    } else if (record.id == 2) {
                        $("#divv1").hide();
                        $("#divv2").show();
                        $("#divv3").hide();
                    } else {
                        $("#divv1").show();
                        $("#divv2").hide();
                        $("#divv3").hide();
                    }

                    var v = parseInt(record.id);
                    switchDate(v);

                },
                formatter: function (row) {
                    var langid = parseInt(row.id) + 568;
                    row.text = langs1[langid][lang];
                    var opts = $(this).combobox('options');
                    return row[opts.textField];
                }
            });

            $("#div1").hide();
            $("#div2").hide();
            $("#div3").show();
            $(".form_datetime").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm-dd', //显示格式
                todayHighlight: 1, //今天高亮
                minView: "month", //设置只显示到月份
                startView: 2,
                forceParse: 0,
                showMeridian: 1,
                autoclose: 1//选择后自动关闭
            });
            $(".form_datetime2").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy-mm', //显示格式
                todayHighlight: 1, //今天高亮
                minView: 3, //设置只显示到月份
                startView: 4,
                forceParse: 0,
                showMeridian: 1,
                autoclose: 1//选择后自动关闭
            });

            $(".form_datetime3").datetimepicker({
                language: 'zh-CN',
                format: 'yyyy', //显示格式
                todayHighlight: 1, //今天高亮
                minView: 4, //设置只显示到月份
                startView: 4,
                forceParse: 0,
                showMeridian: 1,
                autoclose: 1//选择后自动关闭
            });

        });


        function changeTime(num) {
            switch (num) {
                case 1:
                    $("#timeMin").val($("#timeMin1").val());
                    break;
                case 2:
                    $("#timeMax").val($("#timeMax1").val());
                    break;
                case 3:
                    $("#timeMin").val($("#timeMin2").val());
                    break;
                case 4:
                    $("#timeMax").val($("#timeMax2").val());
                    break;
                case 5:
                    $("#timeMin").val($("#timeMin3").val());
                    break;
                case 6:
                    $("#timeMax").val($("#timeMax3").val());
                    break;
            }
        }

        function clearDate()
        {
            $("#timeMin").val('');
            $("#timeMax").val('');
            $("#timeMin1").val('');
            $("#timeMax1").val('');
            $("#timeMin2").val('');
            $("#timeMax2").val('');
            $("#timeMin3").val('');
            $("#timeMax3").val('');
        }
        function switchDate(num) {
            var switchDay = $("#switchDay");
            var switchMonth = $("#switchMonth");
            var switchYear = $("#switchYear");
            clearDate();
            $("#timeType").val(num);
//            switch (num) {
//                case 1:
//                    switchDay.css("background-color", "#cccccc");
//                    switchMonth.css("background-color", "#ffffff");
//                    switchYear.css("background-color", "#ffffff");
//                    $("#div1").show();
//                    $("#div2").hide();
//                    $("#div3").hide();
//                    break;
//                case 2:
//                    switchDay.css("background-color", "#ffffff");
//                    switchMonth.css("background-color", "#cccccc");
//                    switchYear.css("background-color", "#ffffff");
//                    $("#div1").hide();
//                    $("#div2").show();
//                    $("#div3").hide();
//                    break;
//                case 3:
//                    switchDay.css("background-color", "#ffffff");
//                    switchMonth.css("background-color", "#ffffff");
//                    switchYear.css("background-color", "#cccccc");
//                    $("#div1").hide();
//                    $("#div2").hide();
//                    $("#div3").show();
//                    break;
//            }
            if (num == 1) {
                $("#div1").hide();
                $("#div2").hide();
                $("#div3").show();
            } else if (num == 2) {
                $("#div1").hide();
                $("#div2").show();
                $("#div3").hide();
            } else {
                $("#div1").show();
                $("#div2").hide();
                $("#div3").hide();
            }
            //search();
        }


        $(function () {
            $('#getYearTable').bootstrapTable({
                // url: "login.reportmanage.getyear.action?pid=${param.pid}",
                columns: [[{
                            field: '',
                            title: langs1[111][lang], //年用电量
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 6
                        }], [
                        {
                            field: 'years',
                            title: langs1[113][lang], //年份
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'val',
                            title: langs1[112][lang] + '(KW·h)', //用电量
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'lampsum',
                            title:  langs1[576][lang], //灯具总数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'bugsum',
                            title:langs1[576][lang], //灯具异常数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'Lamppost',
                            title: langs1[578][lang], //灯杆总数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'bugsum',
                            title: langs1[6][lang]+ '（%）', //量灯率
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.lampsum == 0) {
                                    return 0;
                                } else {
                                    var s = (row.lampsum - row.bugsum) / row.lampsum;
                                    return  (s * 100).toFixed(2);
                                }
                            }
                        }]
                ],
                showExport: true, //是否显示导出
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 15]
            });
            var pid = '${param.pid}';
            $.ajax({async: false, url: "login.reportmanage.getyear.action", type: "get", datatype: "JSON", data: {pid: pid},
                success: function (data) {
                    var nhnrs = data.nhnrs;   //耗能集合
                    var nsbrs = data.nsbrs;   //设备 统计
                    var pent = [];
                    for (var i = 0; i < nhnrs.length; i++) {
                        var obj = {};
                        obj.years = nhnrs[i].years;
                        obj.val = nhnrs[i].val;
                        obj.lampsum = 0;
                        obj.bugsum = 0;
                        obj.Lamppost = 0;
                        for (var j = 0; j < nsbrs.length; j++) {
                            if (nhnrs[i].years == nsbrs[j].time) {
                                obj.lampsum = nsbrs[j].lampsum;
                                obj.bugsum = nsbrs[j].bugsum;
                                obj.Lamppost = nsbrs[j].Lamppost;
                            }
                        }
                        pent.push(obj);
                    }
                    $("#getYearTable").bootstrapTable('load', []);
                    if (pent.length > 0) {
                        $('#getYearTable').bootstrapTable('load', pent);

                    }
                },
                error: function () {
                    alert("提交失败！");
                }
            });




            $('#getMotherTable').bootstrapTable({
                columns: [[{
                            field: '',
                            title: langs1[114][lang], //月用电量
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 6
                        }], [
                        {
                            field: 'mother',
                            title: langs1[115][lang], //月份
                            width: 25,
                            align: 'center',
                            valign: 'middle'

                        }, {
                            field: 'val',
                            title: langs1[112][lang] + '(KW·h)', //用电量
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'lampsum',
                            title:  langs1[576][lang], //灯具总数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'bugsum',
                            title: langs1[576][lang], //灯具异常数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'Lamppost',
                            title: langs1[578][lang], //灯杆总数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'bugsum',
                            title: langs1[6][lang]+ '（%）', //量灯率
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.lampsum == 0) {
                                    return 0;
                                } else {
                                    var s = (row.lampsum - row.bugsum) / row.lampsum;
                                    return  (s * 100).toFixed(2);
                                }
                            }
                        }]
                ],
                showExport: true, //是否显示导出
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 15]
            });

            $('#getdayTable').bootstrapTable({
                columns: [[{
                            field: '',
                            title: langs1[116][lang], //日用电量
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            colspan: 6
                        }], [
                        {
                            field: 'd',
                            title: langs1[93][lang], //日期
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'val',
                            title: langs1[112][lang] + '(KW·h)', //用电量
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'lampsum',
                            title: langs1[576][lang], //灯具总数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'bugsum',
                            title:langs1[576][lang], //灯具异常数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'Lamppost',
                            title: langs1[578][lang], //灯杆总数
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'bugsum',
                            title: langs1[6][lang]+ '（%）', //量灯率
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.lampsum == 0) {
                                    return 0;
                                } else {
                                    var s = (row.lampsum - row.bugsum) / row.lampsum;
                                    return  (s * 100).toFixed(2);
                                }
                            }
                        }
                    ]
                ],
                showExport: true, //是否显示导出
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 15]
            });

        });

        function search() {
            var timeobj = $("#searchForm").serializeObject();
            var o = $("#form1").serializeObject();
            var obj = {};
            if (o.project == "0") {
                obj.pid = "${param.pid}";
            } else if (o.project == "1") {
                obj.comaddr = o.comaddr;
            }


            switch (parseInt(o.querytype)) {
                case 1:
                    {
                        obj.star = timeobj.y1;
                        obj.end = timeobj.y2;
                        var pent = [];
                        $.ajax({async: false, url: "login.reportmanage.getyear.action", type: "get", datatype: "JSON", data: obj,
                            success: function (data) {
                                var nhnrs = data.nhnrs;   //耗能集合
                                var nsbrs = data.nsbrs;   //设备 统计
                                for (var i = 0; i < nhnrs.length; i++) {
                                    var obj = {};
                                    obj.years = nhnrs[i].years;
                                    obj.val = nhnrs[i].val;
                                    obj.lampsum = 0;
                                    obj.bugsum = 0;
                                    obj.Lamppost = 0;
                                    for (var j = 0; j < nsbrs.length; j++) {
                                        if (nhnrs[i].years == nsbrs[j].time) {
                                            obj.lampsum = nsbrs[j].lampsum;
                                            obj.bugsum = nsbrs[j].bugsum;
                                            obj.Lamppost = nsbrs[j].Lamppost;
                                        }
                                    }
                                    pent.push(obj);
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        $("#getYearTable").bootstrapTable('load', []);
                        if (pent.length > 0) {
                            $('#getYearTable').bootstrapTable('load', pent);

                        }
                    }
                    break;
                case 2:
                    {
                        obj.star = timeobj.m1;
                        obj.end = timeobj.m2;
                        //加载所有网关信息
//                        var opt = {
//                            url: "login.reportmanage.getmother.action",
//                            silent: false,
//                            query: obj
//                        };
                        var pent = [];
                        $.ajax({async: false, url: "login.reportmanage.getmother.action", type: "get", datatype: "JSON", data: obj,
                            success: function (data) {
                                var yhnrs = data.yhnrs;   //耗能集合
                                var ysbrs = data.ysbrs;   //设备 统计
                                for (var i = 0; i < yhnrs.length; i++) {
                                    var obj = {};
                                    obj.mother = yhnrs[i].mother;
                                    obj.val = yhnrs[i].val;
                                    obj.lampsum = 0;
                                    obj.bugsum = 0;
                                    obj.Lamppost = 0;
                                    for (var j = 0; j < ysbrs.length; j++) {
                                        if (yhnrs[i].mother == ysbrs[j].time) {
                                            obj.lampsum = ysbrs[j].lampsum;
                                            obj.bugsum = ysbrs[j].bugsum;
                                            obj.Lamppost = ysbrs[j].Lamppost;
                                        }
                                    }
                                    pent.push(obj);
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        // $("#getdayTable").bootstrapTable('refresh', opt);
                        $("#getMotherTable").bootstrapTable('load', []);
                        if (pent.length > 0) {
                            $('#getMotherTable').bootstrapTable('load', pent);

                        }
                        //  $("#getMotherTable").bootstrapTable('refresh', opt);
                    }
                    break;
                case 3:
                    {
                        obj.star = timeobj.d1;
                        obj.end = timeobj.d2;
                        var pent = [];
                        $.ajax({async: false, url: "login.reportmanage.getday.action", type: "get", datatype: "JSON", data: obj,
                            success: function (data) {
                                var hnrs = data.hnrs;   //耗能集合
                                var sbrs = data.sbrs;   //设备 统计
                                for (var i = 0; i < hnrs.length; i++) {
                                    var obj = {};
                                    obj.d = hnrs[i].d;
                                    obj.val = hnrs[i].val;
                                    obj.lampsum = 0;
                                    obj.bugsum = 0;
                                    obj.Lamppost = 0;
                                    for (var j = 0; j < sbrs.length; j++) {
                                        if (hnrs[i].d == sbrs[j].time) {
                                            obj.lampsum = sbrs[j].lampsum;
                                            obj.bugsum = sbrs[j].bugsum;
                                            obj.Lamppost = sbrs[j].Lamppost;
                                        }
                                    }
                                    pent.push(obj);
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        // $("#getdayTable").bootstrapTable('refresh', opt);
                        $("#getdayTable").bootstrapTable('load', []);
                        if (pent.length > 0) {
                            $('#getdayTable').bootstrapTable('load', pent);

                        }
                    }
                    break;
                default:

                    break;
            }
            console.log(o);
            console.log(timeobj);
        }

    </script>
    <body>

        <div class="row" >
            <div class="col-sm-12">
                <form id="form1">
                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>

                                <td>
                                    <span style="margin-left:10px;" id="117" name="xxx">查询方式</span>&nbsp;
                                </td>

                                <td>
                                    <select class="easyui-combobox" id="querytype" data-options='editable:false,valueField:"id", textField:"text" ' name="querytype" style="width:150px; height: 30px">
                                        <option value="1">按年查询</option>
                                        <option value="2">按月查询</option>
                                        <option value="3">按日查询</option>
                                    </select>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;" id="118" name="xxx">查询范围</span>&nbsp;
                                </td>

                                <td>
                                    <select class="easyui-combobox" id="project" name="project" data-options="editable:true,valueField:'id', textField:'text' " style="width:150px; height: 30px">
                                        <option value="0">项目</option>
                                        <option value="1">集控器</option>           
                                    </select>
                                    &nbsp;
                                </td>
                                <td id="g1"  style=" display: none">

                                    <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;

                                    <span class="menuBox">
                                        <input id="comaddr" class="easyui-combobox" name="comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                    &nbsp;
                                </td>
                            </tr>


                        </tbody>
                    </table> 
                </form>
            </div>
        </div>



        <form id="searchForm">
            <div class="row" style=" border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; "  >
                <div class="col-sm-3" id="div1" style="display:none">  
                    <div class="input-group input-inline-sm col-sm-12" >  
                        <span class="input-group-addon " id="82" name="xxx" >时间</span>  
                        <input type="text" class="form-control form_datetime" name="d1"  readOnly id="timeMin1" onchange="changeTime(1)">  
                        <span class="input-group-addon" id="119" name="xxx">至</span>  
                        <input type="text" class="form-control form_datetime" name="d2"   readOnly id="timeMax1" onchange="changeTime(2)">
                    </div>
                </div>

                <div class="col-sm-3" id="div2" style="display:none">  
                    <div class="input-group input-inline-sm col-sm-12" >  
                        <span class="input-group-addon " id="82" name="xxx" >时间</span>  
                        <input type="text" class="form-control form_datetime2" name="m1"  readOnly id="timeMin2" onchange="changeTime(3)">  
                        <span class="input-group-addon" id="119" name="xxx">至</span>  
                        <input type="text" class="form-control form_datetime2"  name="m2"   readOnly id="timeMax2" onchange="changeTime(4)">
                    </div>
                </div>

                <div class="col-sm-3" id="div3">  
                    <div class="input-group input-inline-sm col-sm-12" >  
                        <span class="input-group-addon " id="82" name="xxx" >时间</span>  
                        <input type="text" class="form-control form_datetime3" name="y1"  readOnly id="timeMin3" onchange="changeTime(5)">  
                        <span class="input-group-addon" id="119" name="xxx">至</span>  
                        <input type="text" class="form-control form_datetime3" name="y2"   readOnly id="timeMax3" onchange="changeTime(6)">
                    </div>
                </div>

                <div class="col-sm-3">
                    <button type="button" class="btn btn-success btn-sm" onclick="search();">
                        <span id="34" name="xxx">搜索</span>
                    </button>
                </div>
            </div>
        </form>


        <div  id="divv1">
            <table id="getdayTable">
            </table>
        </div>
        <div id="divv2" style="">
            <table id="getMotherTable">
            </table>
        </div>
        <div id="divv3">          
            <table id="getYearTable">
            </table>
        </div>
    </body>
</html>