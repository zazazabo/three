<%-- 
    Document   : table
    Created on : 2018-6-29, 17:48:10
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">


        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style></head>

    <script type="text/javascript" src="js/genel.js"></script>

    <script>
        function layerAler(str) {
            layer.alert(str, {
                icon: 6,
                offset: 'center'
            });
        }
        var vvvv = 0;
        var flag = null;


        function dealsend2(msg, data, fn, func, comaddr, type, param, val) {
            var user = new Object();
            user.begin = '6A';
            user.res = 1;
            user.status = "";
            user.comaddr = comaddr;
            user.fn = fn;
            user.function = func;
            user.param = param;
            user.page = 2;
            user.msg = msg;
            user.val = val;
            user.type = type;
            user.addr = getComAddr(comaddr); //"02170101";
            user.data = data;
            user.len = data.length;
            user.end = '6A';
            console.log(user);
            parent.parent.sendData(user);
        }

        $(function () {

            //flag = setInterval("dealsend()", 1000);

            $('#time4').timespinner('setValue', '00:00');
            $('#time3').timespinner('setValue', '00:00');
            var data1 = [{"name": "灯杆倾斜预警开关"}, {"name": "温度预警故障开关"}, {"name": "漏电流预警故障开关"}, {"name": "相位不符预警故障开关"}, {"name": "线路不符预警故障开关"}, {"name": "台区不符预警故障开关"}, {"name": "使用寿命到期预警"}, {"name": "灯具状态改变上报"}];


            var data2 = [{"name": "灯控器故障开关"}, {"name": "温度故障开关"}, {"name": "超负荷故障开关"}, {"name": "功率因数过低故障开关"}, {"name": "时钟故障开关"}, {"name": "集中器与灯控器通信中断"}, {"name": "灯珠故障"}, {"name": "电源故障"}];



            $('#prewarningtable').bootstrapTable({
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
                        field: 'name',
                        title: '预警参数',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }
                ],
                data: data1,
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 20, 15, 20, 25],

            });


            $('#warningtable').bootstrapTable({
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
                        field: 'name',
                        title: '报警参数',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }
                ],
                data: data2,
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 20, 15, 20, 25],

            });

            $('#gravidaTable').bootstrapTable({
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
                        field: 'pid',
                        title: '所属项目',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'comaddr',
                        title: '网关',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'online',
                        title: '在线状态',
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            return "<img  src='img/off.png'/>"; //onclick='hello()'
                        },
                    }],
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
                    console.info("加载成功");
//                    console.log(websocket.readyState);
//                    if (websocket != null && websocket.readyState == 1) {
//
//                    }
                },
                url: 'test1.f5.h1.action',
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
            $("#gravidaTable").on('refresh.bs.table', function (data) {
                // flag = setInterval("dealsend()", 1000);
            });
            $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                var index = row.data('index');
                value.index = index;
            });
        })

        function dealsend() {

//            if (websocket != null && websocket.readyState == 1) {
            var allTableData = $("#gravidaTable").bootstrapTable('getData'); //获取表格的所有内容行
            if (allTableData.length > vvvv) {
                var obj = allTableData[vvvv];
                var addrArea = Str2Bytes(obj.comaddr);
                var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrArea[3]) + sprintf("%02d", addrArea[2]);
                var user = new Object();
                var ele = {};
                user.msg = "getStatus";
                user.res = 1;
                user.row = vvvv;
                user.parama = ele;
                user.page = 2;
                user.function = "getMessage";
                user.addr = straddr; //"02170101";
                user.data = false;
                parent.parent.sendData(user);
                //  console.log(user);
                // var datajson = JSON.stringify(user);
                // websocket.send(datajson);
                vvvv += 1;
            } else {
                // clearInterval(flag);
                vvvv = 0;
            }
        }

        function setPreWarningcb(obj) {
            if (obj.status == "success") {
                layerAler("预警参数设置成功");
            }
        }
        function setPreWarning() {
            var selects = $('#gravidaTable').bootstrapTable('getSelections');
            if (selects.length == 0) {
                layerAler("请勾选网关列表");
                return;
            }

            var arr = $("#prewarningtable").bootstrapTable('getData');
//            console.log(arr);
            var vv = [];
            var u = 0x00;
            var ss2 = 0;
            var ss = "";
            for (var i = 0; i < arr.length; i++) {
                if (i == 1) {
                    ss = "0" + ss;
                }
                var a = arr[i];
                var s = a.select;
                var ii = s == true ? 0 : 1;
                var s = ii.toString(2);
                ss = s + ss;
                if (i == arr.length - 1) {
                    ss2 = ii;
                    break;
                }
            }
            var u = parseInt(ss, 2);
            vv.push(u);
            vv.push(ss2);
            var select = selects[0];
            var comaddr = select.comaddr;
            var num = randnum(0, 9) + 0x70;
            var data = buicode(comaddr, 0x04, 0xA4, num, 0, 602, vv); //01 03 F24    

            dealsend2("A4", data, 1, "setPreWarningcb", comaddr, select.index, 0, select.id);

//            console.log(vv);
        }

        function setWarningcb(obj) {
            if (obj.status == "success") {
                layerAler("预警参数设置成功");
            }
        }
        function setWarning() {
            var selects = $('#gravidaTable').bootstrapTable('getSelections');
            if (selects.length == 0) {
                layerAler("请勾选网关列表");
                return;
            }

            var arr = $("#warningtable").bootstrapTable('getData');
//            console.log(arr);
            var vv = [];
            var u = 0x00;
            var ss2 = 0;
            var ss = "";
            for (var i = 0; i < arr.length; i++) {

                var a = arr[i];
                var s = a.select;
                var ii = s == true ? 0 : 1;
                var s = ii.toString(2);
                ss = s + ss;
            }
            var u = parseInt(ss, 2);
            vv.push(u);
            vv.push(ss2);
            var select = selects[0];
            var comaddr = select.comaddr;
            var num = randnum(0, 9) + 0x70;
            var data = buicode(comaddr, 0x04, 0xA4, num, 0, 604, vv); //01 03 F24    
            dealsend2("A4", data, 1, "setWarningcb", comaddr, select.index, 0, select.id);
        }


    </script>
</head>
<body>

    <div class="panel panel-success" >
        <div class="panel-heading">
            <h3 class="panel-title">路灯预报警参数设置</h3>
        </div>
        <div class="panel-body" >
            <div class="container"  >
                <div class="row">
                    <div class="col-xs-4">
                        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                        </table>

                    </div>
                    <div class="col-xs-4">

                        <table id="prewarningtable"> 

                        </table> 
                    </div>
                    <div class="col-xs-4">
                        <table id="warningtable"  > 
                        </table> 
                    </div>


                </div>
                <div class="row" style=" margin-top: 10px;">
                    <div class="col-xs-4"> 

                    </div>
                    <div class="col-xs-4"> 
                        <button  type="button" style="margin-left:20px;" onclick="setPreWarning()" class="btn btn-success">设置灯具预警参数</button>
                    </div>
                    <div class="col-xs-4">
                        <button  type="button" style="margin-left:20px;" onclick="setWarning()" class="btn btn-success">设置灯具报警参数</button>
                    </div>
                </div>
                <!--                <div class="row" style=" margin-top: 10px;">
                                    <div class="col-xs-12">
                         
                                    </div>
                                </div>-->

                <!--                    <div style="width:100%; margin-top: 10px;">
                
                
                    </div>-->

            </div>
        </div>
    </div>







    <form id="form1">






        <!--
        
                <table  style=" margin-top: 10px;">
                    <tbody>
                        <tr >
        
                            <td>
                                <input type="checkbox" id="radio1" checked="checked" name="group1" />灯控器故障预警开关参数设置 
                                <input type="checkbox" id="radio2"  name="group1" />温度预警故障开关 
                                <input type="checkbox" id="radio3" name="group1" />漏电流预警故障开关
                                <input type="checkbox" id="radio3" name="group1" />相位不符预警故障开关
        
                                <input type="checkbox" id="radio3" name="group1" />线路不符预警故障开关
                            </td>
                            <td><span class="label label-success" style="margin-left: 10px;" >灯具故障预警</span></td>
                            <td>
                                &nbsp;
                                <select class="easyui-combobox" id="prewarning" name="prewarning" style="width:150px; height: 34px">
                                    <option value="0">开启</option>
                                    <option value="1">关闭</option>           
                                </select>
        
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="setPreWarning()" class="btn btn-success">设置灯具预警</button>
                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="setWarning()" class="btn btn-success">设置灯具报警</button>
                            </td>
                        </tr> 
                    </tbody>
                </table>-->




    </form>




    <!-- 添加 -->

    <!-- 修改 -->

</body>
</html>
