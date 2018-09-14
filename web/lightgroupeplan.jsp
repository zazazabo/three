<%-- 
    Document   : lightval
    Created on : 2018-7-23, 7:54:25
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/genel.js"></script>
        <script>
            var websocket = null;
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }


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
            
            function deployPlan(obj) {
                console.log(obj)
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {
                    layerAler("成功");
                }
            }

            function  sendPlan() {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选分组数据");
                    return;
                }




                var vv = new Array();
                var eleArray = new Array();
                var len = selects.length;
                vv.push(len);
                for (var i = 0; i < len; i++) {
                    var select = selects[i];
                    console.log(select);
                    var l_groupe = parseInt(select.l_groupe, "10");
                    vv.push(l_groupe);
                    eleArray.push(l_groupe);
                    var param = select.detail;
                    var time1 = param.p_time1;
                    var time2 = param.p_time2;
                    var time3 = param.p_time3;
                    var time4 = param.p_time4;
                    var time5 = param.p_time5;
                    var time6 = param.p_time6;
                    var str = "";
                    if (isJSON(time1)) {
                        var obj = eval('(' + time1 + ')');
                        var targetArr = obj.time.split(":");
                        if (targetArr.length == 2) {
                            var h = parseInt(targetArr[0], "16");
                            var m = parseInt(targetArr[1], "16");
                            vv.push(m);
                            vv.push(h);
                            var v = parseInt(obj.value, "10");
                            vv.push(v);
                        }
                    }
                    if (isJSON(time2)) {
                        var obj = eval('(' + time2 + ')');
                        var targetArr = obj.time.split(":");
                        if (targetArr.length == 2) {
                            var h = parseInt(targetArr[0], "16");
                            var m = parseInt(targetArr[1], "16");
                            vv.push(m);
                            vv.push(h)
                            var v = parseInt(obj.value, "16");
                            vv.push(v);
                        }
                    }
                    if (isJSON(time3)) {
                        var obj = eval('(' + time3 + ')');
                        var targetArr = obj.time.split(":");
                        if (targetArr.length == 2) {
                            var h = parseInt(targetArr[0], "16");
                            var m = parseInt(targetArr[1], "16");
                            vv.push(m);
                            vv.push(h)
                            var v = parseInt(obj.value, "10");
                            vv.push(v);
                        }
                    }
                    if (isJSON(time4)) {
                        var obj = eval('(' + time4 + ')');
                        var targetArr = obj.time.split(":");
                        if (targetArr.length == 2) {
                            var h = parseInt(targetArr[0], "16");
                            var m = parseInt(targetArr[1], "16");
                            vv.push(m);
                            vv.push(h)
                            var v = parseInt(obj.value, "10");
                            vv.push(v);
                        }
                    }
                    if (isJSON(time5)) {
                        var obj = eval('(' + time5 + ')');
                        var targetArr = obj.time.split(":");
                        if (targetArr.length == 2) {
                            var h = parseInt(targetArr[0], "16");
                            var m = parseInt(targetArr[1], "16");
                            vv.push(m);
                            vv.push(h)
                            var v = parseInt(obj.value, "10");
                            vv.push(v);
                        }
                    }
                    if (isJSON(time6)) {
                        var obj = eval('(' + time6 + ')');
                        var targetArr = obj.time.split(":");
                        if (targetArr.length == 2) {
                            var h = parseInt(targetArr[0], "16");
                            var m = parseInt(targetArr[1], "16");
                            vv.push(m);
                            vv.push(h)
                            var v = parseInt(obj.value, "10");
                            vv.push(v);
                        }
                    }

                }
                var comaddr1 = selects[0].l_comaddr;
                var ele = {id: eleArray};
                var user = new Object();
                user.res = 1;
                user.afn = 140;
                user.status = "";
                user.function = "deployPlan";
                user.parama = ele;
                user.msg = "setParam";
                user.res = 1;
                user.addr = getComAddr(comaddr1); //"02170101";
                var num = randnum(0, 9) + 0x70;
                num = 0x71;
                var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 140, vv); //01 03 F24        
                user.data = sss;
                $datajson = JSON.stringify(user);
                console.log("websocket readystate:" + websocket.readyState);
                console.log(user);
                websocket.send($datajson)
            }
            function setPlan() {
                var data = $("#txt_l_plan").combobox('getValue');
                if (data == "") {
                    layerAler("请选择方案列表");
                    return;
                }
                var obj = $("#eqpTypeForm").serializeObject();

                obj.l_comaddr = obj.txt_l_comaddr;
                obj.l_groupe = obj.txt_l_groupe;
                obj.l_plan = obj.txt_l_plan;

                $.ajax({async: false, url: "test1.plan.editlampplan.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
//                            $("#gravidaTable").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
            function groupeLampValue(obj) {
                console.log(obj)
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {

                }

            }
            function setLampTimePlanCB(obj) {
                console.log(obj);
//                               console.log(obj)
                if (obj.status == "success") {

                }
            }

            function readLampPlanCB(obj) {
                console.log(obj);
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {

                    v = v + sprintf("%02x", data[i]) + " ";
                }
                console.log(v);
                if (obj.status == "success") {
                    if (obj.fn == 402) {
                        //读场景方案
                        for (var i = 0; i < 8; i++) {
                            var t0 = 20 + (i * 2);
                            var t1 = 20 + (i * 2) + 1;
                            $("#__num" + (i + 1).toString()).val(data[t0].toString());
                            $("#__val" + (i + 1).toString()).val(data[t1].toString());
                        }

                    } else if (obj.fn == 401) {
                        //读时间方案
                        for (var i = 0; i < 6; i++) {
                            var t0 = 20 + (i * 3);
                            var t1 = 20 + (i * 3) + 1;
                            var t2 = 20 + (i * 3) + 2;
                            var time=sprintf("%02x:%02x",data[t1],data[t0]);
                            $("#time" + (i + 1).toString()).timespinner('setValue', time);
                            $("#val" + (i + 1).toString()).val(data[t2].toString());     
                                  
                        }

                    }
                }
            }


            function readLampPlan() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }
                var obj = $("#form1").serializeObject();
                console.log(obj);
                var v = obj.p_type;
                var s = selects[0];
//                console.log(s);
                if (s.l_deplayment == 0) {
                    layerAler("部署后的灯具才能设置回路运行方案");
                    return;
                }
                if (v == "0") {
                    console.log('读取分组时间方案');
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(s.l_groupe));
                    var comaddr = s.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xAA, num, 0, 401, vv); //01 03 F24    
                    dealsend2("AA", data, 401, "readLampPlanCB", comaddr, 0, obj.p_type, 0, 0);
                }

                if (v == "1") {
                    console.log('读取分组场景方案');
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(s.l_groupe));
                    var comaddr = s.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xAA, num, 0, 402, vv); //01 03 F24    
                    dealsend2("AA", data, 402, "readLampPlanCB", comaddr, 0, obj.p_type, 0, 0);
                }
            }



            function setLampPlan() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }
                var obj = $("#form1").serializeObject();
                console.log(obj);
                var v = obj.p_type;
                var s = selects[0];
//                console.log(s);
                if (s.l_deplayment == 0) {
                    layerAler("部署后的灯具才能设置回路运行方案");
                    return;
                }
                if (v == "0") {
                    console.log('部署分组时间方案');
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(s.l_groupe));
                    for (var i = 0; i < 6; i++) {
                        var a = "time" + (i + 1).toString();
                        var b = "val" + (i + 1).toString();
                        var time = obj[a];
                        var val = obj[b];
                        var a1 = time.split(":");
                        var m = parseInt(a1[1], 16);
                        var h = parseInt(a1[0], 16);
                        vv.push(m);
                        vv.push(h);
                        vv.push(parseInt(val));
                    }

                    var comaddr = s.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 140, vv); //01 03 F24    
                    dealsend2("A4", data, 140, "setLampTimePlanCB", comaddr, s.index, obj.p_type, 0, s.id);
                }

                if (v == "1") {
                    var vv = [];
                    vv.push(1);
                    vv.push(parseInt(s.l_groupe));
                    console.log(obj);
                    for (var i = 0; i < 8; i++) {
                        var a = "__num" + (i + 1).toString();
                        var b = "__val" + (i + 1).toString();
                        var num = parseInt(obj[a]);
                        var val = parseInt(obj[b]);
                        vv.push(num);
                        vv.push(val);
                    }
                    var comaddr = s.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 480, vv); //01 03 F24    
                    dealsend2("A4", data, 480, "setLampTimePlanCB", comaddr, 0, obj.p_type, 0, s.id);
                }
            }


            $(function () {
                $('#l_comaddr').combobox({
                      onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);

                        } else {
                            $(this).combobox('select', );
                        }
                    },
                    onSelect: function (record) {
                        var obj = {l_comaddr: record.id};
                        var opt = {
                            url: "test1.lamp.Groupe.action",
                            silent: true,
                            query: obj
                        };
                        $('#gravidaTable').bootstrapTable('refresh', opt);
                    }
                });


                $('#p_plan').combobox({
                    formatter: function (row) {
                        var v1 = row.p_type == 0 ? "(时间)" : "(场景)";
                        var v = row.text + v1;
                        row.id = row.id + v1;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);

                        } else {
                            $(this).combobox('select', );
                        }
                    },
                    onSelect: function (record) {
                        $('#type' + record.p_type).show();

                        var v = 1 - parseInt(record.p_type);
                        $('#type' + v.toString()).hide();
                        $('#p_type').val(record.p_type);
                        if (record.p_type == 0) {
                            for (var i = 0; i < 6; i++) {
                                var a = "p_time" + (i + 1).toString();
                                var b = "#time" + (i + 1).toString();
                                var c = "#val" + (i + 1).toString();
                                var o = eval('(' + record[a] + ')');
                                if (o.hasOwnProperty('time') == false || o.hasOwnProperty('value') == false) {
                                    continue;
                                }
                                $(b).timespinner('setValue', o.time);
                                $(c).val(o.value);
                            }
                        }

                        if (record.p_type == 1) {
                            for (var i = 0; i < 8; i++) {
                                var a = "p_scene" + (i + 1).toString();
                                var b = record[a];
                                if (isJSON(b)) {
                                    var obj = eval('(' + b + ')');
                                    var num = "#__num" + (i + 1).toString();
                                    var val = "#__val" + (i + 1).toString();
                                    $(num).val(obj.num);
                                    $(val).val(obj.value);
                                }
                            }
                        }

                    }
                });


                $("#gravidaTable").on("dbl-click-cell.bs.table", function (field, value, row, element) {

                    if (value == "l_plan") {
                        console.log(element);
                        $("#txt_l_comaddr").val(element.l_comaddr);
                        $("#txt_l_groupe").val(element.l_groupe);
                        $("#modal_plan_set").modal();
                    }

                })

                $('#gravidaTable').bootstrapTable({
                    url: 'test1.plan.GroupeLamp.action',
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
                            field: 'l_comaddr',
                            title: '网关地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'l_groupe',
                            title: '组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  value.toString();
                            }
                        },
                        {
                            field: 'l_plan',
                            title: '方案',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_content',
                            title: '内容',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                row.p_code = row.l_plan;
                                var str = "";
                                $.ajax({async: false, url: "test1.plan.getPlanContent.action", type: "get", datatype: "JSON", data: row,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            var param = arrlist[0];
                                            row.detail = param;
                                            if (param.p_type == 0) {
                                                var time1 = param.p_time1;
                                                var time2 = param.p_time2;
                                                var time3 = param.p_time3;
                                                var time4 = param.p_time4;
                                                var time5 = param.p_time5;
                                                var time6 = param.p_time6;

                                                if (isJSON(time1)) {
                                                    var obj = eval('(' + time1 + ')');
                                                    str = str + obj.time + "=" + obj.value + " | ";
                                                }
                                                if (isJSON(time2)) {
                                                    var obj = eval('(' + time2 + ')');
                                                    str = str + obj.time + "=" + obj.value + " | ";
                                                }
                                                if (isJSON(time3)) {
                                                    var obj = eval('(' + time3 + ')');
                                                    str = str + obj.time + "=" + obj.value + " | ";
                                                }
                                                if (isJSON(time4)) {
                                                    var obj = eval('(' + time4 + ')');
                                                    str = str + obj.time + "=" + obj.value + " | ";
                                                }
                                                if (isJSON(time5)) {
                                                    var obj = eval('(' + time5 + ')');
                                                    str = str + obj.time + "=" + obj.value + " | ";
                                                }
                                                if (isJSON(time5)) {
                                                    var obj = eval('(' + time5 + ')');
                                                    str = str + obj.time + "=" + obj.value + " | ";
                                                }

                                            }


                                            // $("#table_loop").bootstrapTable('refresh');
                                            // console.log(data);
                                        }
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });

                                return  str;
//                                console.log(row.l_plan);
                            }
                        }],
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
                    },
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            l_deplayment: "1"  
                        };      
                        return temp;  
                    },
                });



//                $('#l_groupe').combobox({
//                    onSelect: function (record) {
//                        var obj = $("#tosearch").serializeObject();
//                        obj.l_groupe = record.id;
//                        obj.l_deplayment = 1;
//                        console.log(obj);
//                        var opt = {
//                            url: "test1.lamp.Groupe.action",
//                            silent: true,
//                            query: obj
//                        };
//                        $("#gravidaTable").bootstrapTable('refresh', opt);
//                    }
//                });


            })


        </script>

    </head>
    <body>

        <form id="form1">
            <input name="p_type" type="hidden" id="p_type" />
            <div class="row">
                <div class="col-xs-6">

                    <table>
                        <tbody>
                            <tr>
                                <td></td>
                                <td></td>
                                <td>
                                    <span style="margin-left:10px;">网关地址&nbsp;</span>
                                    <span class="menuBox">

                                        <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:false,valueField:'id', textField:'text',url:'test1.lamp.getlampcomaddr.action' " />

                                        <!--<select name="l_comaddr_lamp" id="l_comaddr_lamp" placeholder="回路" class="input-sm" style="width:150px;">-->
                                    </span>   
                                </td>

                                <td>
                                    <!--&nbsp;&nbsp;  <button id="btndeploy" onclick="deployloop()" class="btn btn-success">部署回路</button>-->
                                </td>
                                <td>
                                    <span style="margin-left:10px;">组号&nbsp;</span>
                                    <span class="menuBox">
                                        <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text',url:'test1.lamp.getGroupe.action' " />
                                    </span> 
                                    <!--&nbsp;&nbsp;  <button id="btnremove" onclick="removeloop()" class="btn btn-success">移除回路</button>-->
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <table id="gravidaTable" style="width:100%;"  class="text-nowrap table table-hover table-striped">
                    </table>
                </div>
                <div class="col-xs-6">
                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                        <tr>
                            <td colspan="4" align="right">
                                <span style=" margin-left: 20px;" >方案列表</span>
                                <span class="menuBox">

                                    <input id="p_plan" class="easyui-combobox" name="p_plan" style="width:150px; height: 30px" 
                                           data-options="editable:false,valueField:'id', textField:'text',url:'test1.plan.getPlanlist.action?attr=1' " />
                                    <span style=" margin-left: 120px;" ></span>
                            </td>
                        </tr>
                    </table>

                    <table id="type0" style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; display: none ">

                        <tr >
                            <td>
                                <span style="margin-left:20px;">时间1</span>&nbsp;
                            </td>
                            <td> <input id="time1"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                            </td>
                            <td>
                                <input id="val1" class="form-control" name="val1" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;">时间2</span>&nbsp;
                            </td>
                            <td> <input id="time2"  name="time2" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                            </td>
                            <td>
                                <input id="val2" class="form-control" name="val2" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;">时间3</span>&nbsp;
                            </td>
                            <td> <input id="time3"  name="time3" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                            </td>
                            <td>
                                <input id="val3" class="form-control" name="val3" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;">时间4</span>&nbsp;
                            </td>
                            <td> <input id="time4"  name="time4" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                            </td>
                            <td>
                                <input id="val4" class="form-control" name="val4" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;">时间5</span>&nbsp;
                            </td>
                            <td> <input id="time5"  name="time5" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                            </td>
                            <td>
                                <input id="val5" class="form-control" name="val5" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>
                        <tr >
                            <td>
                                <span style="margin-left:20px;">时间6</span>&nbsp;
                            </td>
                            <td> <input id="time6"  name="time6" style=" height: 30px; width: 150px" class="easyui-timespinner">
                            </td>
                            <td>
                                <span style="margin-left:20px;">&nbsp;&nbsp;&nbsp;调光值</span>&nbsp;
                            </td>
                            <td>
                                <input id="val6" class="form-control" name="val6" style="width:150px;display: inline;" placeholder="请输入调光值" type="text">&nbsp;
                            </td>
                        </tr>    

                    </table>

                    <table id="type1" style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; display: none ">
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num1" class="form-control" name="__num1" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val1" class="form-control" name="__val1" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num2" class="form-control" name="__num2" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val2" class="form-control" name="__val2" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num3" class="form-control" name="__num3" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val3" class="form-control" name="__val3" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num4" class="form-control" name="__num4" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val4" class="form-control" name="__val4" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num5" class="form-control" name="__num5" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val5" class="form-control" name="__val5" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num6" class="form-control" name="__num6" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val6" class="form-control" name="__val6" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 

                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num7" class="form-control" name="__num7" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val7" class="form-control" name="__val7" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景号</span>&nbsp;
                                <input id="__num8" class="form-control" name="__num8" style="width:150px;display: inline;" placeholder="请输入场景号" type="text">
                            </td> 
                            <td></td>
                            <td>
                                <span style="margin-left:20px;">调光值</span>&nbsp;
                                <input id="__val8" class="form-control" name="__val8" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                    </table>

                </div>
            </div>
            <div class="row"  style=" margin-top: 20px;">
                <div class="col-xs-6">
                    <!--                    <button id="btndeploylamp" class="btn btn-success">部署灯具</button>
                                        <button id="btnremovelamp" class="btn btn-success">移除灯具</button>-->
                </div>
                <div class="col-xs-6">
                    <!--<button style=" margin-left: 40px;" type="button" onclick="setPlan()" class="btn btn-success">设置</button>-->

                    <button style=" margin-left: 40px;" onclick="setLampPlan()" type="button" class="btn btn-success">部署灯具时间方案</button>
                    <button style=" margin-left: 40px;" onclick="readLampPlan()" type="button" class="btn btn-success">读取分组灯具方案</button>
                </div>
            </div>

        </form> 


    </body>
</html>
