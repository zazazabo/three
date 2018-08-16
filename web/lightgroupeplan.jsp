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
                num=0x71;
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

            $(function () {
                $('#txt_l_plan').combobox({
                    onSelect: function (param) {
                        if (param.p_type == 0) {

                            var time1 = param.p_time1;
                            var time2 = param.p_time2;
                            var time3 = param.p_time3;
                            var time4 = param.p_time4;
                            var time5 = param.p_time5;
                            var time6 = param.p_time6;
                            var str = "";
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
                            $("#txt_p_detail").val(str);
                        }
//                        console.log(param);
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
//                $('#l_comaddr').combobox({
//                    onSelect: function (record) {
//                        var obj = $("#tosearch").serializeObject();
//                        obj.l_comaddr = record.id;
//                        obj.l_deplayment = 1;
//                        console.log(obj);
//                        var opt = {
//                            url: "test1.lamp.Groupe.action",
//                            silent: true,
//                            query: obj
//                        };
//                        $('#gravidaTable').bootstrapTable('refresh', opt);
//                    }
//                });


            })


            $(function () {

                if ('WebSocket' in window) {
                    websocket = new WebSocket("ws://zhizhichun.eicp.net:18414/");
                } else {
                    alert('当前浏览器不支持websocket')
                }
//                // 连接成功建立的回调方法
                websocket.onopen = function (e) {

                }

                //接收到消息的回调方法
                websocket.onmessage = function (e) {
                    console.log("onmessage");
                    var jsoninfo = JSON.parse(e.data);
                    console.log(jsoninfo);
                    if (jsoninfo.hasOwnProperty("function")) {
                        var vvv = jsoninfo.function;
                        var obj = jsoninfo.parama;
                        obj.status = jsoninfo.status;
                        obj.errcode = jsoninfo.errcode;
                        obj.frame = jsoninfo.frame;
                        window[vvv](obj);
                    }

                }
                //连接关闭的回调方法
                websocket.onclose = function () {
                    console.log("websocket close");
                    websocket.close();
                }

                //连接发生错误的回调方法
                websocket.onerror = function () {
                    console.log("Webscoket连接发生错误");
                }

                //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
                window.onbeforeunload = function () {
                    websocket.close();
                }

            })

        </script>
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>


    </head>
    <body>
        <div style="width:100%;">

            <form id="tosearch">
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
                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 34px" 
                                           data-options="editable:true,valueField:'id', textField:'text',url:'test1.lamp.getComaddr.action' " />
                                </span>  
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:10px;">组号&nbsp;</span>
                                <span class="menuBox">
                                    <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:150px; height: 34px" 
                                           data-options="editable:true,valueField:'id', textField:'text',url:'test1.lamp.getGroupe.action' " />
                                </span>         
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>

                            <td>

                            </td>
                            <td>
                                <button id="btn_groupe_lamp_val" type="button" style="margin-left:20px;" onclick="sendPlan();" class="btn btn-success">部署灯控方案</button>
                            </td>




                        </tr>


                    </tbody>
                </table>
            </form>
            <!--<div class="bootstrap-table">-->
            <!--<div class="fixed-table-container" style="height: 214px; padding-bottom: 0px;">-->     


            <table id="gravidaTable" style="width:100%;"  class="text-nowrap table table-hover table-striped">

            </table>
            <!--</div>-->
            <!--</div>-->
        </div>

        <!-- 添加灯具方案 -->
        <div class="modal" id="modal_plan_set">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">灯控方案设置</h4>
                    </div>

                    <form action="" method="POST" id="eqpTypeForm" onsubmit="return checkPlanLoopAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr id="tr_time_hide_add">
                                        <td>
                                            <span style="margin-left:20px;">方案列表&nbsp;</span>
                                            <span class="menuBox">
                                                <input id="txt_l_plan" class="easyui-combobox" name="txt_l_plan" style="width:150px; height: 34px" 
                                                       data-options="editable:true,valueField:'id', textField:'text',url:'test1.plan.l_groupe.action?p_attr=1' " />
                                            </span>                                           
                                        </td>
                                        <td>     </td>
                                        <td>

                                        </td>

                                    </tr>
                                    <tr><td></td><td></td><td></td></tr>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">网关地址</span>&nbsp;
                                            <input id="txt_l_comaddr" readonly="true" class="form-control"  name="txt_l_comaddr" style="width:150px;display: inline;" placeholder="网关" type="text">
                                        </td>


                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">灯控组号</span>&nbsp;
                                            <input id="txt_l_groupe" readonly="true" class="form-control"  name="txt_l_groupe" style="width:150px;display: inline;" placeholder="灯控组号" type="text"></td>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <span style="margin-left:20px;">方案详细</span>&nbsp;
                                            <input id="txt_p_detail" readonly="true" class="form-control"  name="txt_p_detail" style="width:400px;display: inline;" placeholder="内容" type="text">
                                        </td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>

                        <div class="modal-footer">

                            <button id="tianjia1" type="button" onclick="setPlan()" class="btn btn-primary">设置</button>

                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        </div>
                    </form>



                </div>
            </div>
        </div> 

    </body>
</html>
