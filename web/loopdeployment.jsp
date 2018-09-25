<%-- 
    Document   : deplayment
    Created on : 2018-7-4, 15:32:48
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/genel.js"></script>
        <style>
            .btn { margin-left: 10px;} 

        </style>
        <script>



            function deployloopCB(obj) {
                var param = obj.param;
                if (obj.status == "success") {
                    if (obj.type == 0) {
                        layerAler("移除成功");
                    } else if (obj.type == 1) {
                        layerAler("部署成功");
                    }
                    var o = {l_deplayment: obj.val, id: param.id};
                    $.ajax({async: false, url: "loop.loopForm.modifyDepayment.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            $("#gravidaTable").bootstrapTable('refresh');
                            $("#gravidaTable").bootstrapTable('check', param.row);
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
                if (obj.status == "fail") {
                    if (obj.type == 0) {
                        layerAler("部署失败");
                    } else if (obj.type == 1) {
                        if (obj.errcode == 2) {
                            layerAler("重复设备序号");
                            var ar = obj.parama;
                            var o = {l_deplayment: obj.val, id: param.id};
                            $.ajax({async: false, url: "loop.loopForm.modifyDepayment.action", type: "get", datatype: "JSON", data: o,
                                success: function (data) {
                                    $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_deployment", value: obj.val});
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                        } else if (obj.errcode == 6) {
                            layerAler("未查询到此设备或信息");
                        }

                    }

                }
            }
            function deployloop() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }

                var vv = [];

                var ele = selects[0];
                var comaddr = ele.l_comaddr;
                var setcode = ele.l_code;
                var l_code = parseInt(setcode);
                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(1);
                vv.push(b);//装置序号  2字节            
                vv.push(a);//装置序号  2字节     
                vv.push(b);//测量点号  2字节            
                vv.push(a);//测量点号  2字节  

//                    var dd = get2byte(setcode);
//                    var set1 = Str2BytesH(dd);
//                    vv.push(set1[1]);
//                    vv.push(set1[0]); //装置序号  2字节
//                    vv.push(set1[1]);
//                    vv.push(set1[0]); //测量点号  2字节 

                vv.push(parseInt(setcode, 16)); //通信地址
                var iworktype = parseInt(ele.l_worktype);
                vv.push(iworktype); //工作方式
                var igroupe = parseInt(ele.l_groupe); //组号
                vv.push(igroupe); //组号                      
                var param = {row: ele.index, id: ele.id};
                var num = randnum(0, 9) + 0x70; //随机帧序列号
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 320, vv); //0320    
                dealsend2("A4", data, 320, "deployloopCB", comaddr, 1, param, 1);
                //  
//                dealsend(sss, 1);
            }

            function removeloop() {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }


                var vv = [];
                var ele = selects[0];
                var comaddr = ele.l_comaddr;
                var setcode = ele.l_code;
                var l_code = parseInt(setcode);
                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(1);
                vv.push(b);//装置序号  2字节            
                vv.push(a);//装置序号  2字节                   
                vv.push(0);
                vv.push(0); //测量点号  2字节 
                vv.push(parseInt(setcode, 16)); //通信地址
                var iworktype = parseInt(ele.l_worktype);
                vv.push(iworktype); //工作方式
                var igroupe = parseInt(ele.l_groupe); //组号
                vv.push(igroupe); //组号                      

                var param = {row: ele.index, id: ele.id};
                var num = randnum(0, 9) + 0x70; //随机帧序列号
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 320, vv); //0320    
                dealsend2("A4", data, 320, "deployloopCB", comaddr, 0, param, 0);
            }

            function setLoopPlanCB(obj) {
                var param = obj.param;
                console.log(param);
                if (obj.status == "success") {
                    layerAler("设置成功");
                    $.ajax({async: false, url: "loop.planForm.editlooptimeA.action", type: "get", datatype: "JSON", data: param,
                        success: function (data) {
                            console.log(data);
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var url = "loop.planForm.getPlanlist.action?attr=0&pid=${param.pid}";
                                $('#p_plan').combobox('reload', url);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });


                    return;
                }
            }
            function setLoopPlan() {
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
                    layerAler("部署后的回路才能设置回路运行方案");
                    return;
                }
                if (v == "0") {
                    console.log('部署时间');
                    var vv = [];
                    vv.push(1);
                    var c = parseInt(s.l_code);
                    var h = c >> 8 & 0x00ff;
                    var l = c & 0x00ff;

                    vv.push(l);
                    vv.push(h);

                    var intime = obj.intime.split(":");
                    var outtime = obj.outtime.split(":");
                    var m = parseInt(intime[1], '16');
                    var h = parseInt(intime[0], '16');

                    var m1 = parseInt(outtime[1], '16');
                    var h1 = parseInt(outtime[0], '16');
                    vv.push(m);
                    vv.push(h);
                    vv.push(m1);
                    vv.push(h1);
                }

                var comaddr = s.l_comaddr;
                var param = {p_intime: obj.intime, p_outtime: obj.outtime, p_code: obj.p_plan};
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 401, vv); //01 03 F24    
                dealsend2("A4", data, 401, "setLoopPlanCB", comaddr, obj.p_type, param, 0);
            }

            function readLoopPlanCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {

                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (obj.fn == 320) {
                        var m = sprintf("%02x", data[21]);
                        var h = sprintf("%02x", data[22]);
                        var m1 = sprintf("%02x", data[23]);
                        var h1 = sprintf("%02x", data[24]);
                        var intime1 = sprintf("%s:%s", h, m);
                        var outtime1 = sprintf("%s:%s", h1, m1);

                        $('#intime').timespinner('setValue', intime1);
                        $('#outtime').timespinner('setValue', outtime1);
                    }

                }
            }
            function readLoopPlan() {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选列表读取");
                    return;
                }
                var obj = $("#form1").serializeObject();
                console.log(obj);
                var v = obj.p_type;
                var s = selects[0];
                if (s.l_deplayment == 0) {
                    layerAler("部署后的回路才能设置回路运行方案");
                    return;
                }

                if (v == "0") {
                    console.log('读取时间表');
                    var vv = [];
                    vv.push(1);
                    var c = parseInt(s.l_code);
                    var h = c >> 8 & 0x00ff;
                    var l = c & 0x00ff;

                    vv.push(l);
                    vv.push(h);
                }

                var comaddr = s.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 320, vv); //01 03 F24    
                console.log(data);
                dealsend2("AA", data, 320, "readLoopPlanCB", comaddr, s.index, obj.p_type, 0, s.id);


//                var v1 = [];
//                var num = randnum(0, 9) + 0x70;
//                var data1 = buicode(obj.comaddr, 0x04, 0x00, num, 0, 1, v1); //01 03 F24    
//                dealsend2("00", data1, 1, "", obj.comaddr, 0, 0, 0);
            }

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {

                $('#gravidaTable').bootstrapTable({
                    url: "loop.loopForm.getLoopList.action",
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
                        }, {
                            field: 'l_name',
                            title: '回路名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_code',
                            title: '装置序号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_worktype',
                            title: '控制方式',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "0(时间)";
                                    return value;
                                } else if (value == 1) {
                                    value = "1(经纬度)";
                                    return value;
                                }
                            }
                        }, {
                            field: 'l_groupe',
                            title: '组号',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                var groupe = value.toString();
                                return  groupe;
                            }
                        }, {
                            field: 'l_deployment',
                            title: '部署情况',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.l_deplayment == "0") {
                                    var str = "<span class='label label-warning'>末部署</span>"
                                    return  str;
//                                    var obj1 = {index: index, data: row};
//                                    var ele = '<span class=\"label label-success\"  onclick="gz(\'' + JSON.stringify(obj1).replace(/"/g, '&quot;') + '\');">挂载</span>';
//                                    return ele;
                                } else if (row.l_deplayment == "1") {
                                    var obj1 = {index: index, data: row};
//                                    var ele = '<span class=\"label label-warning\"  onclick="gz(\'' + JSON.stringify(obj1).replace(/"/g, '&quot;') + '\');">移除</span>';
                                    var str = "<span class='label label-success'>已部署</span>"
                                    return  str;
                                }
                            }
                        }],
                    clickToSelect: true,
                    singleSelect: true,
                    search: true,
                    locale: 'zh-CN', //中文支持,
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
                            type_id: "1",
                            pid: "${param.pid}",
                            l_comaddr: $("#l_comaddr").combobox('getValue') 
                        };      
                        return temp;  
                    },
                });
                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                });

                $('#l_comaddr').combobox({
                    url: "loop.loopForm.getComaddr.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        } else {
                            $(this).combobox("select", );
                        }
                    },
                    onSelect: function (record) {
                        $("#gravidaTable").bootstrapTable('refresh');
                    }
                });
                $('#p_plan').combobox({
                    url: "loop.planForm.getPlanlist.action?attr=0&pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.p_type == 0 ? "(时间)" : "(经纬度)";
                        var v = row.text + v1;
                        row.id = row.id;
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
//                      
                        $("#p_type").val(record.p_type);
                        console.log(record);
                        if (record.p_type == "1") {
                            var strArr1 = record.p_Longitude.split(".");
                            var strArr2 = record.p_latitude.split(".");
                            $("#longitudem26d").val(strArr1[0]);
                            $("#longitudem26m").val(strArr1[1]);
                            $("#longitudem26s").val(strArr1[2]);

                            $("#latitudem26d").val(strArr2[0]);
                            $("#latitudem26m").val(strArr2[1]);
                            $("#latitudem26s").val(strArr2[2]);
                        } else if (record.p_type == "0") {
                            $("#intime").val(record.intime);
                            $('#intime').timespinner('setValue', record.p_intime);
                            $('#outtime').timespinner('setValue', record.p_outtime);
                        }





                    }
                });
            })



        </script>
    </head>
    <body>
        <form id="form1">
            <div class="row">


                <table>
                    <tbody>
                        <tr>
                            <td> <span style="margin-left:40px;">网关地址&nbsp;</span></td>
                            <td>        <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                               data-options='editable:false,valueField:"id", textField:"text" ' /></td>
                            <td>
                                <button id="btndeploy" type="button" onclick="deployloop()" class="btn btn-success btn-sm">部署回路</button>
                            </td>


                            <td>
                                <button id="btnremove" type="button" onclick="removeloop()" class="btn btn-success btn-sm">移除回路</button>

                            </td>

                        </tr>
                    </tbody>
                </table>
            </div>


            <!--                <div class="col-xs-6">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                                    <tr>
                                        <td colspan="4" align="center">
                                            <span >方案列表&nbsp;</span>
                                            <span class="menuBox">
            
                                                <input id="p_plan" class="easyui-combobox" name="p_plan" style="width:150px; height: 30px" 
                                                       data-options="editable:false,valueField:'id', textField:'text' " />
                                        </td>
                                    </tr>
                                    <input type="hidden" id="p_type" name="p_type" />
                                    <tr id="type0">
                                        <td>
                                            <span style="margin-left:20px;">闭合时间</span>&nbsp;
                                        </td>
                                        <td> <input id="intime" name="intime" style=" height: 30px; width: 150px;  "  class="easyui-timespinner">
                                        </td>
                                        <td>
                                            <span style="margin-left:20px;">断开时间&nbsp;</span>
                                        </td>
                                        <td>
                                            <input id="outtime" name="outtime" style=" height: 30px; width: 150px;  "  class="easyui-timespinner">
                                        </td>
                                    </tr>
            
                                    <tr id="type1" style=" display: none" >
                                        <td>
                                            <span style="margin-left:20px;">区域经度</span>&nbsp;
                                        </td>
                                        <td>
                                            <input id="longitudem26d" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                            <input id="longitudem26m" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                            <input id="longitudem26s" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                                        </td>
                                        <td>
                                            <span style="margin-left:20px;">区域纬度&nbsp;</span>
            
                                        </td>
                                        <td>
                                            <input id="latitudem26d" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                            <input id="latitudem26m" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                            <input id="latitudem26s" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                                        </td>
                                    </tr>
                                </table>
            
                            </div>-->
        </div>



        <div class="row"  style=" margin-top: 20px;">
            <div class="col-xs-1 " align="right"  style=" padding: 4px;">
                <span >方案列表</span>
            </div>
            <div align="left" class="col-xs-2"  style=" padding: 0px; width: 140px;">
                <input id="p_plan" class="easyui-combobox" name="p_plan" style="width:150px; height: 30px; " 
                       data-options="editable:false,valueField:'id', textField:'text' " />
            </div>
            <div id="type0">
                <div class="col-xs-1" align="right"  style=" padding: 0px; padding-top: 4px; padding-left: 20px;" >
                    <span  >闭合时间</span>&nbsp;
                </div>
                <div class="col-xs-1"  align="left" style=" padding: 0px; padding-top: 0px;" >
                    <input id="intime" name="intime" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                </div>

                <div class="col-xs-1" align="right"  style=" padding-left: 5px; padding-top: 4px;">
                    <span  style=" margin-left: 10px;" >断开时间</span>
                </div>
                <div class="col-xs-1"  align="left" style=" padding: 0px; padding-top: 0px; padding-left: 0px;" >
                    <input id="outtime" name="outtime" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                </div>
                <!--                <div class="col-xs-1"  align="left" style=" padding: 0px; padding-top: 4px;" >
                                    <input id="outtime" name="outtime" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                                </div>-->
            </div>

            <div id="type1" style=" display: none">
                <div class="col-xs-6" align="left" style=" width: 600px;">
                    <table >
                        <tr  >
                            <td>
                                <span style="margin-left:20px;">区域经度</span>&nbsp;
                            </td>
                            <td>
                                <input id="longitudem26d" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="longitudem26m" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="longitudem26s" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                            </td>
                            <td>
                                <span style="margin-left:20px;">区域纬度&nbsp;</span>

                            </td>
                            <td>
                                <input id="latitudem26d" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="latitudem26m" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="latitudem26s" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="col-xs-3" align="left" >
                <button  onclick="setLoopPlan()" type="button" class="btn btn-success btn-sm">部署回路方案</button>

                <button  onclick="readLoopPlan()" type="button" class="btn btn-success btn-sm">读取回路时间表</button>
            </div>   




            <input type="hidden" id="p_type" name="p_type" />
            <!--            <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                            <tr>
                                <td> <span style="margin-left:20px;">方案列表</span>&nbsp;</td>
                                <td>
                                    <input id="p_plan" class="easyui-combobox" name="p_plan" style="width:150px; height: 30px" 
                                           data-options="editable:false,valueField:'id', textField:'text' " />
                                </td>
            
                                <td>
                                    <span style="margin-left:20px;">闭合时间</span>&nbsp;
                                </td>
                                <td> <input id="intime" name="intime" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                                </td>
                                <td>
                                    <span style="margin-left:20px;">断开时间&nbsp;</span>
                                </td>
                                <td>
                                    <input id="outtime" name="outtime" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                                </td>
                                <td >
                                    <button style=" margin-left: 40px;" onclick="setLoopPlan()" type="button" class="btn btn-success btn-sm">部署回路方案</button>
                                </td>
                                <td>
                                    <button  onclick="readLoopPlan()" type="button" class="btn btn-success btn-sm">读取回路时间表</button>
                                </td>
                            </tr>
            
                                                <tr id="type0">
                                                    <td>
                                                        <span style="margin-left:20px;">闭合时间</span>&nbsp;
                                                    </td>
                                                    <td> <input id="intime" name="intime" style=" height: 30px; width: 150px;  "  class="easyui-timespinner">
                                                    </td>
                                                    <td>
                                                        <span style="margin-left:20px;">断开时间&nbsp;</span>
                                                    </td>
                                                    <td>
                                                        <input id="outtime" name="outtime" style=" height: 30px; width: 150px;  "  class="easyui-timespinner">
                                                    </td>
                                                </tr>
            
                                                <tr id="type1" style=" display: none" >
                                                    <td>
                                                        <span style="margin-left:20px;">区域经度</span>&nbsp;
                                                    </td>
                                                    <td>
                                                        <input id="longitudem26d" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                                        <input id="longitudem26m" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                                        <input id="longitudem26s" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                                                    </td>
                                                    <td>
                                                        <span style="margin-left:20px;">区域纬度&nbsp;</span>
                            
                                                    </td>
                                                    <td>
                                                        <input id="latitudem26d" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                                        <input id="latitudem26m" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                                        <input id="latitudem26s" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                                                    </td>
                                                </tr>
                            
                                                <tr>
                                                    <td colspan="4">
                                                        <button style=" margin-left: 40px;" onclick="setLoopPlan()" type="button" class="btn btn-success btn-sm">部署回路方案</button>
                            
                                                        <button  onclick="readLoopPlan()" type="button" class="btn btn-success btn-sm">读取回路时间表</button>
                                                    </td>
                                                </tr>
                        </table> 
            
            -->




            <!--                            <div class="col-xs-6">
                        
                                            <button style=" margin-left: 40px;" onclick="setLoopPlan()" type="button" class="btn btn-success">部署回路方案</button>
                        
                                            <button  onclick="readLoopPlan()" type="button" class="btn btn-success">读取回路时间表</button>
                                        </div>-->
        </div>

    </form>




    <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
    </table>

</body>
</html>
