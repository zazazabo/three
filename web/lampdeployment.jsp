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
        <script>
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }



            function dealsend(data, type) {
                var selects = $('#lampTable').bootstrapTable('getSelections');
                var comaddr1 = $("#l_comaddr").combobox('getValue');
                var arr = new Array();
                for (var i = 0; i < selects.length; i++) {
                    arr.push(selects[i].uid);
                }
                var user = new Object();
                user.begin = '6A'
                user.res = 1;
                user.afn = 102;
                user.status = "";
                user.function = "setLamp";
                user.parama = arr;
                user.page = 2;
                user.type = type;    //0移除   1是部署
                user.msg = "A4";   //设置参数
                user.res = 1;
                user.addr = getComAddr(comaddr1); //"02170101";
                user.data = data;
                user.end = '6A';
                parent.parent.sendData(user);
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


            //  var websocket = null;
            function setLamp(obj) {
                if (obj.status == "fail") {
                    if (obj.type == 0) {
                        layerAler("移除失败");
                    } else if (obj.type == 1) {
                        if (obj.errcode == 2) {
                            layerAler("重复设备序号");
                            var ar = obj.parama;
                            for (var i = 0; i < ar.length; i++) {
                                var o1 = {};
                                var o = ar[i];
                                o1.id = ar[i];
                                o1.l_deplayment = 1;
                                $.ajax({async: false, url: "test1.lamp.modifyDepayment.action", type: "get", datatype: "JSON", data: o1,
                                    success: function (data) {
                                        $("#lampTable").bootstrapTable('refresh');
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });

                            }


                        } else if (obj.errcode == 6) {
                            layerAler("未查询到此设备或信息");
                        }

                    }

                } else if (obj.status == "success") {
                    if (obj.type == 0) {
                        layerAler("移除成功");
                        obj.l_deplayment = 0;
                    } else if (obj.type == 1) {
                        layerAler("部署成功");
                        obj.l_deplayment = 1;
                    }

                    var ar = obj.parama;
                    for (var i = 0; i < ar.length; i++) {
                        var o1 = {};
                        var o = ar[i];
                        o1.id = ar[i];
                        o1.l_deplayment = obj.l_deplayment;
                        console.log(o1);
                        $.ajax({async: false, url: "test1.lamp.modifyDepayment.action", type: "get", datatype: "JSON", data: o1,
                            success: function (data) {
                                $("#lampTable").bootstrapTable('refresh');
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });

                    }


                }
            }


            $(function () {
                $('#p_plan').combobox({
                    onSelect: function (record) {

                        console.log(record);
                        $('#type' + record.p_type).show();

                        var v = 1 - parseInt(record.p_type);
                        $('#type' + v.toString()).hide();

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
                                console.log(o);
                            }
                        }


                        if (record.p_type == 1) {

                            for (var i = 0; i < 8; i++) {
                                var a = "p_scene" + (i + 1).toString();
                                $("#" + a).val(record[a]);
                            }
                        }

                    }
                });
                
                $('#l_comaddr').combobox({
                    onSelect: function (record) {
                        var obj = {};
                        obj.l_comaddr = record.id;
                        console.log(obj);
                        var opt = {
                            url: "test1.lamp.getlamp1.action",
                            silent: true,
                            query: obj
                        };
                        $("#lampTable").bootstrapTable('refresh', opt);
                    }
                });
                $('#lampTable').bootstrapTable({
                    clickToSelect: true,
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
                            title: '所属网关',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: '通信地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_name',
                            title: '名称',
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
                                console.log(value);
                                if (value == 0) {
                                    value = "0(时间)";
                                    return value;
                                } else if (value == 1) {
                                    value = "1";
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
                                return  row.l_groupe;

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
                                } else if (row.l_deplayment == "1") {
                                    var str = "<span class='label label-success'>已部署</span>"
                                    return  str;
                                }
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
                $("#btndeploylamp").click(function () {
                    var selects = $('#lampTable').bootstrapTable('getSelections');
                    var comaddr1 = $("#l_comaddr").combobox('getValue');

                    var vv = new Array();
                    if (selects.length == 0) {
                        layerAler("请勾选表格数据");
                        return;
                    }


                    for (var i = 0; i < selects.length; i++) {
                        if (selects[i].l_deplayment == "1") {
                            layerAler(selects[i] + "此装置已经部署过");
                            continue;
                        }
                        if (i == 0) {
                            var len = sprintf("%04d", selects.length);
                            var vvbyte = Str2BytesH(len);
                            vv.push(vvbyte[1]);
                            vv.push(vvbyte[0]);
                        }
                        var setcode = selects[i].l_code;
                        var factorycode = selects[i].l_factorycode;
                        var dd = get2byte(setcode);
                        var set1 = Str2BytesH(dd);
                        var factor = Str2BytesH(factorycode);
                        vv.push(set1[1]);
                        vv.push(set1[0]); //装置序号  2字节
                        vv.push(set1[1]);
                        vv.push(set1[0]); //测量点号  2字节 
                        vv.push(factor[5]); //通信地址
                        vv.push(factor[4]); //通信地址
                        vv.push(factor[3]); //通信地址
                        vv.push(factor[2]); //通信地址
                        vv.push(factor[1]); //通信地址
                        vv.push(factor[0]); //通信地址

                        var iworktype = parseInt(selects[i].l_worktype);
                        vv.push(iworktype); //工作方式

                        var igroupe = parseInt(selects[i].l_groupe); //组号
                        vv.push(igroupe); //组号
                    }
                    var num = randnum(0, 9) + 0x70;
                    var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 102, vv); //0320
                    dealsend(sss, 1);
                });

                $("#btnremovelamp").click(function () {
                    var selects = $('#lampTable').bootstrapTable('getSelections');
                    var comaddr1 = $("#l_comaddr").combobox('getValue');
                    console.log(comaddr1);
                    var vv = [];
                    if (selects.length == 0) {
                        layerAler("请勾选表格数据");
                        return;
                    }

                    for (var i = 0; i < selects.length; i++) {
                        if (selects[i].l_deplayment == "0") {
                            layerAler("此装置已经移除");
                            continue;
                        }
                        if (i == 0) {
                            var len = sprintf("%04d", selects.length);
                            var lenbyte = Str2BytesH(len);
                            vv.push(lenbyte[1]);
                            vv.push(lenbyte[0]);
                        }
                        var setcode = selects[i].l_code;
                        var factorycode = selects[i].l_factorycode;
                        var dd = get2byte(setcode);
                        var set1 = Str2BytesH(dd);
                        var factor = Str2BytesH(factorycode);
                        vv.push(set1[1]);
                        vv.push(set1[0]); //装置序号  2字节
                        vv.push(0);
                        vv.push(0); //测量点号  2字节 


                        vv.push(factor[5]); //通信地址
                        vv.push(factor[4]); //通信地址
                        vv.push(factor[3]); //通信地址
                        vv.push(factor[2]); //通信地址
                        vv.push(factor[1]); //通信地址
                        vv.push(factor[0]); //通信地址

                        var iworktype = parseInt(selects[i].l_worktype);
                        vv.push(iworktype); //工作方式
                        var igroupe = parseInt(selects[i].l_groupe); //组号
                        vv.push(igroupe); //组号
                    }
                    var num = randnum(0, 9) + 0x70;
                    var sss = buicode(comaddr1, 0x04, 0xA4, num, 0, 102, vv); //0320
                    dealsend(sss, 0);

                });

            })
        </script>
    </head>
    <body>

        <form id="form1">
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
                                               data-options="onLoadSuccess:function(data){
                                               if(Array.isArray(data)&&data.length>0){
                                               $(this).combobox('select', data[0].id);

                                               }else{
                                               $(this).combobox('select',);
                                               }
                                               console.log(data);
                                               },editable:false,valueField:'id', textField:'text',url:'test1.lamp.getlampcomaddr.action' " />

                                        <!--<select name="l_comaddr_lamp" id="l_comaddr_lamp" placeholder="回路" class="input-sm" style="width:150px;">-->
                                    </span>   
                                </td>

                                <td>
                                    <!--&nbsp;&nbsp;  <button id="btndeploy" onclick="deployloop()" class="btn btn-success">部署回路</button>-->
                                </td>
                                <td>
                                    &nbsp;    <button id="btndeploylamp" class="btn btn-success">部署灯具</button>
                    <button id="btnremovelamp" class="btn btn-success">移除灯具</button>
                                    <!--&nbsp;&nbsp;  <button id="btnremove" onclick="removeloop()" class="btn btn-success">移除回路</button>-->
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="col-xs-6">
<!--                    <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                        <tr>
                            <td colspan="4" align="right">
                                <span style=" margin-left: 20px;" >方案列表</span>
                                <span class="menuBox">

                                    <input id="p_plan" class="easyui-combobox" name="p_plan" style="width:150px; height: 30px" 
                                           data-options="onLoadSuccess:function(data){
                                           if(Array.isArray(data)&&data.length>0){
                                           $(this).combobox('select', data[0].id);

                                           }else{
                                           $(this).combobox('select',);
                                           }
                                           console.log(data);
                                           },editable:false,valueField:'id', textField:'text',url:'test1.plan.getPlanlist.action?attr=1' " />
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
                            <td> <input id="time2"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
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
                            <td> <input id="time3"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
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
                            <td> <input id="time4"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
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
                            <td> <input id="time5"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
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
                            <td> <input id="time6"  name="time1" style=" height: 30px; width: 150px" class="easyui-timespinner">
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
                        <tr >
                            <td>
                                <span style="margin-left:20px;">场景1</span>&nbsp;

                            </td> 
                            <td>
                                <input id="p_scene1" class="form-control" name="p_scene1" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                            <td>
                                &nbsp;&nbsp;&nbsp;
                                <span style="margin-left:22px;">场景2</span>&nbsp;

                            </td>
                            <td> <input id="p_scene2" class="form-control" name="p_scene2" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">&nbsp;</td>
                        </tr> 
                        <tr>
                            <td>
                                <span style="margin-left:20px;">场景3</span>&nbsp;

                            </td> 
                            <td><input id="p_scene3" class="form-control" name="p_scene3" style="width:150px;display: inline;" placeholder="请输入场景值" type="text"></td>
                            <td>

                                &nbsp;&nbsp;&nbsp;
                                <span style="margin-left:22px;">场景4</span>&nbsp;

                            </td>
                            <td><input id="p_scene4" class="form-control" name="p_scene4" style="width:150px;display: inline;" placeholder="请输入场景值" type="text"></td>
                        </tr> 
                        <tr >
                            <td>
                                <span style="margin-left:20px;">场景5</span>&nbsp;

                            </td> 
                            <td><input id="p_scene5" class="form-control" name="p_scene5" style="width:150px;display: inline;" placeholder="请输入场景值" type="text"></td>
                            <td>
                                &nbsp;&nbsp;&nbsp;
                                <span style="margin-left:22px;">场景6</span>&nbsp;

                            </td>
                            <td><input id="p_scene6" class="form-control" name="p_scene6" style="width:150px;display: inline;" placeholder="请输入场景值" type="text"></td>
                        </tr> 
                        <tr >
                            <td>
                                <span style="margin-left:20px;">场景7</span>&nbsp;

                            </td> 
                            <td><input id="p_scene7" class="form-control" name="p_scene7" style="width:150px;display: inline;" placeholder="请输入场景值" type="text"></td>
                            <td>
                                &nbsp;&nbsp;&nbsp;
                                <span style="margin-left:22px;">场景8</span>&nbsp;

                            </td>
                            <td>
                                <input id="p_scene8" class="form-control" name="p_scene8" style="width:150px;display: inline;" placeholder="请输入场景值" type="text">
                            </td>
                        </tr> 
                    </table>-->

                </div>
            </div>
            <div class="row"  style=" margin-top: 20px;">
                <div class="col-xs-6">
<!--                    <button id="btndeploylamp" class="btn btn-success">部署灯具</button>
                    <button id="btnremovelamp" class="btn btn-success">移除灯具</button>-->
                </div>
<!--                <div class="col-xs-6">
                    <button style=" margin-left: 40px;" type="button" onclick="setPlan()" class="btn btn-success">设置</button>

                    <button style=" margin-left: 40px;" onclick="setLampTimePlan()" type="button" class="btn btn-success">部署灯具时间方案</button>
                    <button style=" margin-left: 40px;" onclick="setLampScenePlan()" type="button" class="btn btn-success">部署灯具场景方案</button>
                </div>-->
            </div>

        </form> 






        <!--
        
                <div class="modal-body">
                    <table>
                        <tbody>
                            <tr>
                                <td>
                                </td>
                                <td>
        
                                </td>
                                <td>
                                    <span style="margin-left:10px;">网关地址&nbsp;</span>
                                    <span class="menuBox">
        
                                        <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                               data-options="onLoadSuccess:function(data){
                                               if(Array.isArray(data)&&data.length>0){
                                               $(this).combobox('select', data[0].id);
        
                                               }else{
                                               $(this).combobox('select',);
                                               }
                                               console.log(data);
                                               },editable:false,valueField:'id', textField:'text',url:'test1.lamp.getlampcomaddr.action' " />
        
                                        <select name="l_comaddr_lamp" id="l_comaddr_lamp" placeholder="回路" class="input-sm" style="width:150px;">
                                    </span>    
                                </td>
                                <td> 
                                    &nbsp;
                                </td>
                                <td>
                                    <button id="btndeploylamp" class="btn btn-success">部署灯具</button>
                                </td>
                                <td> 
                                    &nbsp;&nbsp;&nbsp;
                                </td>
                                <td>
                                    <button id="btnremovelamp" class="btn btn-success">移除灯具</button>
                                </td>
        
        
        
                                <td>
                                </td>
        
        
        
        
                            </tr>
        
        
                        </tbody>
                    </table>
                </div>-->

        <table id="lampTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>



    </body>
</html>
