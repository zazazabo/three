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
            var websocket = null;

            $(function () {

            })
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            /**
             * 合并单元格
             * 
             * @param data
             *            原始数据（在服务端完成排序）
             * @param fieldName
             *            合并参照的属性名称
             * @param colspan
             *            合并开始列
             * @param target
             *            目标表格对象	 
             * @param fieldList
             *            要合并的字段集合
             */
            function mergeCells(data, fieldName, colspan, target, fieldList) {
// 声明一个map计算相同属性值在data对象出现的次数和
                var sortMap = {};
                for (var i = 0; i < data.length; i++) {
                    for (var prop in data[i]) {
                        //例如people.unit.name
                        var fieldArr = fieldName.split(".");
                        getCount(data[i], prop, fieldArr, 0, sortMap);
                    }
                }
                var index = 0;
                for (var prop in sortMap) {
                    var count = sortMap[prop];
                    for (var i = 0; i < fieldList.length; i++) {
                        $(target).bootstrapTable('mergeCells', {index: index, field: fieldList[i], colspan: colspan, rowspan: count});
                    }
                    index += count;
                }
            }


            /**
             * 递归到最后一层 统计数据重复次数
             * 比如例如people.unit.name 就一直取到name
             * 类似于data["people"]["unit"]["name"]
             */
            function getCount(data, prop, fieldArr, index, sortMap) {
                if (index == fieldArr.length - 1) {
                    if (prop == fieldArr[index]) {
                        var key = data[prop];
                        if (sortMap.hasOwnProperty(key)) {
                            sortMap[key] = sortMap[key] + 1;
                        } else {
                            sortMap[key] = 1;
                        }
                    }
                    return;
                }
                if (prop == fieldArr[index]) {
                    var sdata = data[prop];
                    index = index + 1;
                    getCount(sdata, fieldArr[index], fieldArr, index, sortMap);
                }

            }


            /**
             * 合并列
             * @param data 原始数据（在服务端完成排序）
             * @param fieldName 合并属性数组
             * @param target 目标表格对象
             */
            function mergeColspan(data, fieldNameArr, target) {
                if (data.length == 0) {
                    alert("不能传入空数据");
                    return;
                }
                if (fieldNameArr.length == 0) {
                    alert("请传入属性值");
                    return;
                }
                var num = -1;
                var index = 0;
                for (var i = 0; i < data.length; i++) {
                    num++;
                    for (var v in fieldNameArr) {
                        index = 1;
                        if (data[i][fieldNameArr[v]] != data[i][fieldNameArr[0]]) {
                            index = 0;
                            break;
                        }
                    }
                    if (index == 0) {
                        continue;
                    }
                    $(target).bootstrapTable('mergeCells', {index: num, field: fieldNameArr[0], colspan: fieldNameArr.length, rowspan: 1});
                }
            }
            function myformatter(date) {
                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                var d = date.getDate() - 1;
                return m + '/' + d + '/' + y;
            }
            $(function () {

                var curr_time = new Date();
                $("#dd").datebox("setValue", myformatter(curr_time));




                var val = $("#dd").datebox("getValue");

                $('#gravidaTable').bootstrapTable({
                    url: 'test1.report.queryRecord.action', //test1.report.queryRecord.action
                    columns: [
                        [
                            {
                                field: 'detail',
                                title: '详细数据',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 16
                            }
                        ],
                        [
                            {
                                field: 'dayalis',
                                title: '日期',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2
                            }, {
                                field: 'time',
                                title: '时间点',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2
                            }, {
                                field: 'voltage',
                                title: '电压',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 3,
                                rowspan: 1
                            }, {
                                field: 'electric',
                                title: '电流',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 3,
                                rowspan: 1
                            }, {
                                field: 'activepower',
                                title: '有功功率',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 3,
                                rowspan: 1
                            }, {
                                field: 'powerfactor',
                                title: '功率因数',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 4,
                                rowspan: 1
                            }, {
                                field: 'power',
                                title: '正向有功电能量',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                rowspan: 2
                            }
                        ],
                        [

                            {
                                field: 'VAField',
                                title: 'A相',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'VBField',
                                title: 'B相',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'VCField',
                                title: 'C相',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'EAField',
                                title: 'A相',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'EBField',
                                title: 'B相',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ECField',
                                title: 'C相',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ACTIVEAField',
                                title: 'A相有功功率',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ACTIVEBField',
                                title: 'B相有功功率',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'ACTIVECField',
                                title: 'C相有功功率',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORAField',
                                title: 'A相功率因数',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORBField',
                                title: 'B相功率因数',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORCField',
                                title: 'C相功率因数',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'FACTORDField',
                                title: '总功率因数',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }
                        ]



                    ],
                    clickToSelect: true,
                    singleSelect: false,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 64,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [64, 128],
                    onLoadSuccess: function (data) {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.log(data);
                        var obj = new Object();
                        var rows = data.rows;
                        var a = new Array();
                        obj.total = 0;
                        obj.rows = new Array();
                        for (var i = 0; i < rows.length; i++) {

                            var row = rows[i];
                            var v = row.voltage;
                            var e = row.electric;
                            var pf = row.powerfactor;
                            var pa = row.activepower;
                            var p = row.power;
                            console.log(p);
                            var josonv = null;
                            var josone = null;
                            var josonpf = null;
                            var josonpa = null;
                            var josonp = null;
                            if (v != null) {
                                josonv = eval('(' + v + ')');
                            }
                            if (e != null) {
                                josone = eval('(' + e + ')');
                            }

                            if (pa != null) {
                                josonpa = eval('(' + pa + ')');
                            }

                            if (pf != null) {
                                josonpf = eval('(' + pf + ')');
                            }

                            if (p != null) {
                                josonp = eval('(' + p + ')');
                            }


                            if (josonv != null) {
                                var voltageArrA = josonv.A.split("|");
                                var voltageArrB = josonv.B.split("|");
                                var voltageArrC = josonv.C.split("|");
                                var z = 0;
                                for (var j = 0; j < josonv.len; j++) {

                                    var o = new Object();
                                    // var o={"VAField":voltageArr[j],"dayalis":row.dayalis};
                                    o.VAField = voltageArrA[j];
                                    o.VBField = voltageArrB[j];
                                    o.VCField = voltageArrC[j];
                                    o.dayalis = row.dayalis;
                                    var a1 = z * 15 % 60;
                                    var a2 = z * 15 / 60;
                                    var time = sprintf("%02d:%02d", a2, a1);
                                    o.time = time;
                                    a.push(o);
                                    z++;

                                }

                            }

                            if (josone != null) {
                                var electricArrA = josone.A.split("|");
                                var electricArrB = josone.B.split("|");
                                var electricArrC = josone.C.split("|");
                                var len1 = a.length >= josone.len ? a.length : josone.len;
                                z = 0;
                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].EAField = electricArrA[j];
                                        a[j].EBField = electricArrB[j];
                                        a[j].ECField = electricArrC[j];
                                    } else {
                                        var o = new Object();
                                        o.EAField = electricArrA[j];
                                        o.EBField = electricArrB[j];
                                        o.ECField = electricArrC[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);

                                    }
                                    z++;

                                }
                            }

                            if (josonpa != null) {
                                var activeArrA = josonpa.A.split("|");
                                var activeArrB = josonpa.B.split("|");
                                var activeArrC = josonpa.C.split("|");
                                var len1 = a.length >= josonpa.len ? a.length : josonpa.len;
                                z = 0;
                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].ACTIVEAField = activeArrA[j];
                                        a[j].ACTIVEBField = activeArrB[j];
                                        a[j].ACTIVECField = activeArrC[j];
                                    } else {
                                        var o = new Object();
                                        o.ACTIVEAField = activeArrA[j];
                                        o.ACTIVEBField = activeArrB[j];
                                        o.ACTIVECField = activeArrC[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);

                                    }
                                    z++;

                                }
                            }

                            if (josonpf != null) {
                                var factorArrA = josonpf.A.split("|");
                                var factorArrB = josonpf.B.split("|");
                                var factorArrC = josonpf.C.split("|");
                                var factorArrD = josonpf.D.split("|");
                                var len1 = a.length >= josonpf.len ? a.length : josonpf.len;
                                z = 0;


                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].FACTORAField = factorArrA[j];
                                        a[j].FACTORBField = factorArrB[j];
                                        a[j].FACTORCField = factorArrC[j];
                                        a[j].FACTORDField = factorArrD[j];

                                    } else {
                                        var o = new Object();
                                        o.FACTORAField = factorArrA[j];
                                        o.FACTORBField = factorArrB[j];
                                        o.FACTORCField = factorArrC[j];
                                        o.FACTORDField = factorArrD[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);
                                    }
                                    z++;
                                }




                            }

                            if (josonp != null) {
                                var powerArrA = josonp.A.split("|");
                                console.log(powerArrA);
                                var len1 = a.length >= josonpf.len ? a.length : josonp.len;
                                z = 0;
                                for (var j = 0; j < len1; j++) {
                                    if (a.length >= j) {
                                        a[j].power = powerArrA[j];

                                    } else {
                                        var o = new Object();
                                        o.power = powerArrA[j];
                                        o.dayalis = row.dayalis;
                                        var a1 = z * 15 % 60;
                                        var a2 = z * 15 / 60;
                                        var time = sprintf("%02d:%02d", a2, a1);
                                        o.time = time;
                                        a.push(o);
                                    }
                                    z++;
                                }
                            }

                        }
                        obj.rows = a;
//                        data = obj;
                        $("#gravidaTable").bootstrapTable("load", obj)
                        var data = $('#gravidaTable').bootstrapTable('getData', true);
                        // 合并单元格
                        var fieldList = ["dayalis"];
                        mergeCells(data, "dayalis", 1, $('#gravidaTable'), fieldList);
                    },

                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            day: val    
                        };      
                        return temp;  
                    },
                });




            })

            function aaa() {
                var data = $('#gravidaTable').bootstrapTable('getData', true);
                console.log(data);


                //合并单元格
                mergeCells(data, "l_factorycode", 0, $('#gravidaTable'));

//                alert("ddd");
            }
            function search() {
                var val1 = $('#dd').datebox('getValue');
//                alert(val1);
                var opt = {
                    url: "test1.report.queryRecord.action",
                    silent: false,
                    query: {day: val1}
                };
                $("#gravidaTable").bootstrapTable('refresh', opt);



                //              alert(val1);
//                $("#gravidaTable").bootstrapTable('refresh');
//               alert(date);
            }

        </script>

        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>

    </head>

    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <span style="margin-left:20px;">&nbsp;
                <label class="label label-lg label-success ">日&nbsp;&nbsp;期</label>
            </span>
            <span >
                <!--<input id="dd" type="text" class="easyui-datebox" >-->

                <input id="dd" class="easyui-datebox" data-options="formatter:myformatter,parser:myparser"></input>
                <script type="text/javascript">
                    function myformatter(date) {
                        var y = date.getFullYear();
                        var m = date.getMonth() + 1;
                        var d = date.getDate();
                        return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
                    }
                    function myparser(s) {
                        if (!s)
                            return new Date();
                        var ss = (s.split('-'));
                        var y = parseInt(ss[0], 10);
                        var m = parseInt(ss[1], 10);
                        var d = parseInt(ss[2], 10);
                        if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
                            return new Date(y, m - 1, d);
                        } else {
                            return new Date();
                        }
                    }
                </script>
            </span> 
            <span style="margin-left:20px;">
                <button type="button" class="btn btn-sm btn-success" onclick="search()" >查找</button>
            </span>


        </div>

        <div style="width:100%;">

            <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
            </table>
        </div>




        <!-- 添加 -->

        <!-- 修改 -->

        <!--修改组号-->

    </body>
</html>