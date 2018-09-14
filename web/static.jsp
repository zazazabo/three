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

            $(function () {
                $('#gravidaTable').bootstrapTable({
                    url: 'test1.report.staticpower.action',
                    columns: [
                        {
                            field: 'dayalis',
                            title: '日期',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'power',
                            title: '电能',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'lightrate',
                            title: '亮灯率',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }
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
                    pageSize: 5,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function (data) {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                        console.log(data);
                        var obj = new Object();
                        var rows = data.rows;
                        var a = new Array();
                        for (var i = 0; i < rows.length; i++) {







                            var row = rows[i];




                            var p = row.power;
                            if (p != null) {
                                josonp = eval('(' + p + ')');
                            }
                            if (josonp != null) {
                                if (i == 0) {
                                    var powerArr = josonp.A.split("|");
                                    var o = new Object();
                                    o.dayalis = row.dayalis;
                                    o.power = powerArr[0];
                                    a.push(o);
                                } else if (i > 0) {
                                    var rowfirst = rows[i - 1];
                                    var pfirstarr = new Array();
                                    var pfirst = rowfirst.power;
                                    var josonpfirst = null;
                                    if (pfirst != null) {
                                        josonpfirst = eval('(' + pfirst + ')');
                                        pfirstarr = josonpfirst.A.split("|");
                                    }

                                    if (pfirstarr.length > 0) {
                                        var powerArr = josonp.A.split("|");
                                        var o = new Object();
                                        o.dayalis = row.dayalis;
                                        var len1 = pfirstarr.length;
                                        var f1 = parseFloat(powerArr[0]);
                                        var f2 = parseFloat(pfirstarr[josonpfirst.len - 1]);
                                        var fstr = f1 - f2;
                                        o.power = fstr.toString();
                                        a.push(o);
                                    } else {
                                        var powerArr = josonp.A.split("|");
                                        var o = new Object();
                                        o.dayalis = row.dayalis;
                                        o.power = powerArr[0];
                                        a.push(o);
                                    }
                                }



                                obj.rows = a;
                                obj.total = a.length;
                                $("#gravidaTable").bootstrapTable("load", obj)
                                var data = $('#gravidaTable').bootstrapTable('getData', true);







                            }

                        }

                        //
//                        console.info("加载成功");
//                        var data = $('#gravidaTable').bootstrapTable('getData', true);
//                        // 合并单元格
//                        var fieldList = ["name"];
//                        mergeCells(data, "name", 1, $('#gravidaTable'), fieldList);
//
//                        var fieldListarr = ["detail", "name", "l_comaddr", "l_name", "l_factorycode"];
//                        mergeColspan(data, fieldListarr, $("#gravidaTable"));


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

            function aaa() {
                var data = $('#gravidaTable').bootstrapTable('getData', true);
                console.log(data);


                //合并单元格
                mergeCells(data, "l_factorycode", 0, $('#gravidaTable'));

//                alert("ddd");
            }

        </script>

        <link rel="stylesheet" href="gatewayconfig_files/layer.css" id="layui_layer_skinlayercss" style="">
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>

    </head>

    <body>

        <div style="width:100%;">

            <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
            </table>
        </div>




        <!-- 添加 -->

        <!-- 修改 -->

        <!--修改组号-->

    </body>
</html>