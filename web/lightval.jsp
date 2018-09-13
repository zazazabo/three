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



            function groupeval(obj) {
                console.log(obj);
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("按组调光失败");
                    }
                } else if (obj.status == "success") {
                    layerAler("调光成功");
                    var o = {};
                    o.l_value = obj.val;
                    o.l_comaddr = obj.comaddr;
                    o.l_groupe = obj.param;
                    console.log(o);
                    $.ajax({async: false, url: "test1.lamp.modifygroupeval.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                var obj = $("#tosearch").serializeObject();
                                var opt = {
                                    url: "test1.lamp.Groupe.action",
                                    silent: true,
                                    query: obj
                                };
                                $('#groupegravidaTable').bootstrapTable('refresh', opt);

                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                }
            }
            function controlLamp(obj) {
                console.log(obj)
                var param = obj.param;
                if (obj.status == "fail") {
                    if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }
                } else if (obj.status == "success") {
                    layerAler("调光成功");
                    var o = {};
                    o.l_value = param.val;
                    o.id = param.id;
                    $.ajax({async: false, url: "test1.lamp.modifyvalue.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                if (param.type == 0) {
                                    $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_value", value: param.val});
                                }

                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                }

            }
            function dealsend(data, param) {
                var comaddr = param.comaddr;


                var user = new Object();
                user.begin = '6A';

                user.res = 1;
                user.afn = 301;
                user.status = "";
                user.function = "controlLamp";
                user.param = param;
                user.page = 2;
                user.msg = "A5";
                user.res = 1;
                user.type = param.type;
                user.addr = getComAddr(comaddr); //"02170101";
                user.data = data;
                user.len = data.length;
                user.end = '6A';
                parent.parent.sendData(user);
            }

            function dealsend2(data, fn, func, comaddr, type, param, val) {
                var user = new Object();
                user.begin = '6A';
                user.res = 1;
                user.status = "";
                user.comaddr = comaddr;
                user.fn = fn;
                user.function = func;
                user.param = param;
                user.page = 2;
                user.msg = "A5";
                user.res = 1;
                user.val = val;
                user.type = type;
                user.addr = getComAddr(comaddr); //"02170101";
                user.data = data;
                user.len = data.length;
                user.end = '6A';
                console.log(user);
                parent.parent.sendData(user);
            }



            function lightgroupe() {
                var obj = $("#tosearch").serializeObject();

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (obj.l_comaddr == "") {
                    layerAler("请选择好网关");
                    return;
                }

                var num = $("#l_groupe").combobox("getValue");
                if (num == "") {
                    layerAler("请组号");
                    return;
                }
                var v1 = $("#groupeval").val();
                if (isNumber(v1) == false) {
                    layerAler("调光值必须是数字");
                    return;
                }
                var vv = new Array();
                vv.push(1);
                var comaddr = obj.l_comaddr;
                var groupe = obj.l_groupe;
                var l_groupe = parseInt(groupe, "10");
                vv.push(l_groupe);          //组号

                vv.push(parseInt(obj.groupeval, "10"));     //组亮度值
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 302, vv); //01 03 F24     
                dealsend2(data, 302, "groupeval", comaddr, obj.lighttype, l_groupe, obj.groupeval);


            }

            $(function () {

                $('#groupegravidaTable').bootstrapTable({
                    url: 'test1.lamp.Groupe.action',
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
                            field: 'l_value',
                            title: '调光值',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                console.log(value)
                                if (value != null) {
                                    return  value.toString();
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
//                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态

//                        $('.easyui-slider').slider({
//                            min: 0,
//                            max: 100,
//                            step: 1,
//                            showTip: true
//                        });

//                        var obj = $("#slide_lamp_val");
//                        console.log(obj);
//                        console.info("加载成功");
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

                $('#gravidaTable').bootstrapTable({
                    url: 'test1.lamp.getlamp1.action',
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
                            title: '网关名称',
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
                            title: '灯具名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: '灯具编号',
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
                            field: 'l_value',
                            title: '调光值',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value != null) {
                                    return value.toString();
                                }


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
                    singleSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 5,
//                    showRefresh: true,
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
                            l_deplayment: 1  
                        };      
                        return temp;  
                    },
                });

                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                    console.log(value);
                });


                $('#groupegravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                });


// 组号方式

                $('#switchgroupe').combobox({
                    onSelect: function (record) {
//                        console.log(record.value);
                        var obj = $("#tosearch").serializeObject();
                        obj.l_comaddr = record.id;
                        obj.l_deplayment = 1;
                        console.log(obj);
                        if (record.value == 0) {
                            $("#groupeshowtr").hide();
                            var v = $(".bootstrap-table");
                            console.log(v);
                            $(v[0]).show();
                            $(v[1]).hide();
                        } else if (record.value == 1) {
                            $("#groupeshowtr").show();
                            var v = $(".bootstrap-table");
                            $(v[1]).show();
                            $(v[0]).hide();
                        }
                    }
                })

                $('#l_comaddr').combobox({
                    onSelect: function (record) {
                        var obj = $("#tosearch").serializeObject();
                        var url = "test1.lamp.getGroupe.action?l_comaddr=" + record.id + "&l_deplayment=1";
                        obj.l_comaddr = record.id;
                        obj.l_deplayment = 1;
                        $('#l_groupe').combobox('reload', url);


                        if (obj.lighttype == 0) {
                            var opt = {
                                url: "test1.lamp.getlamp1.action",
                                silent: true,
                                query: obj
                            };
                            $('#gravidaTable').bootstrapTable('refresh', opt);


                        } else if (obj.lighttype == 1) {
                            var opt = {
                                url: "test1.lamp.Groupe.action",
                                silent: true,
                                query: obj
                            };
                            $('#groupegravidaTable').bootstrapTable('refresh', opt);

                        }


                    }
                });


                $("#btn_reset_auto_run").click(function () {

                    if (websocket.readyState != 1) {
                        layerAler("服务端没连接上");
                        return;
                    }

                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler("请勾选灯具数据");
                        return;
                    }
                    var vv = new Array();
                    for (var i = 0; i < selects.length; i++) {
                        var select = selects[i];
                        var comaddr1 = select.l_comaddr;
                        var setcode = select.l_code;
                        var dd = get2byte(setcode);
                        var set1 = Str2BytesH(dd);
                        vv.push(set1[1]);
                        vv.push(set1[0]); //装置序号  2字节
                        var num = randnum(0, 9) + 0x70;
                        var sss = buicode(comaddr1, 0x04, 0xA5, num, 0, 280, vv); //01 03 F24


                        var ele = {id: select.uid, l_code: select.l_code};
                        var user = new Object();
                        user.res = 1;
                        user.afn = 280;
                        user.status = "";
                        user.function = "resetLamp";
                        user.parama = ele;
                        user.msg = "contrParam";
                        user.res = 1;
                        user.addr = getComAddr(comaddr1); //"02170101";
                        user.data = sss;
                        $datajson = JSON.stringify(user);
                        console.log("websocket readystate:" + websocket.readyState);
                        console.log(user);
                        websocket.send($datajson);
                    }
                });


                $("#slide_lamp_val").slider({onComplete: function (value) {
                        var obj = $("#tosearch").serializeObject();
                        var selects = $('#gravidaTable').bootstrapTable('getSelections');
                        if (obj.l_comaddr == "") {
                            layerAler("请选择好网关");
                            $(this).slider('reset');
                            return;
                        }
                        if (obj.lighttype != 0) {
                            layerAler("请控制只能在单灯模式使用");
                            $(this).slider('reset');
                            return;
                        }
                        if (selects.length == 0) {
                            layerAler("请勾选灯具数据");
                            $(this).slider('reset');
                            return;
                        }
                        layer.confirm('您确定要发送指令吗？', {
                            btn: ['确定', '取消'], //按钮
                            icon: 3,
                            offset: 'center',
                            title: '提示'
                        }, function (index) {

                            var vv = new Array();
                            var l_comaddr = $("#l_comaddr").combobox('getValue');
                            var select = selects[0];
                            console.log(select);
                            var lampval = value;
                            var setcode = select.l_code;
                            var dd = get2byte(setcode);
                            var set1 = Str2BytesH(dd);
                            vv.push(set1[1]);
                            vv.push(set1[0]); //装置序号  2字节
                            vv.push(parseInt(lampval));
                            var num = randnum(0, 9) + 0x70;
                            var o1 = {};
                            o1.id = select.uid;
                            o1.comaddr = l_comaddr;
                            o1.val = lampval;
                            o1.type = obj.lighttype;
                            o1.row = select.index;
                            var sss = buicode(l_comaddr, 0x04, 0xA5, num, 0, 301, vv); //01 03
                            dealsend(sss, o1);
                            layer.close(index);
                        });

                    }});


            })
        </script>
    </head>
    <body>

        <div style="width:100%;">

            <form id="tosearch">
                <table>
                    <tbody>
                        <tr>
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
                                           },editable:true,valueField:'id', textField:'text',url:'test1.lamp.getComaddr.action' " />
                                </span>  
                            </td>
                            <td>
                                <span style="margin-left:10px;">调光方式&nbsp;</span>

                                <select class="easyui-combobox" id="switch" name="switch" style="width:150px; height: 30px">
                                    <option value="0">立即调光</option>
                                    <option value="1">场景调光</option>           
                                </select>

                            </td>
                            <td>
                                <span style="margin-left:10px;">分组方式&nbsp;</span>

                                <select class="easyui-combobox" id="switchgroupe" id="lighttype" name="lighttype" style="width:150px; height: 30px">
                                    <option value="0">单灯调光</option>
                                    <option value="1">组号调光</option>           
                                </select>   



                            </td>

                            <td>
                                <span style="margin-left:10px; padding-right: 10px;">立即调光:&nbsp;</span>
                            </td>

                            <td>
                                <span style="margin-left:10px; padding-right: 10px;" >
                                    <div id="slide_lamp_val"  class="easyui-slider"    data-options="showTip:true,min:0,rule:[0,'|',25,'|',50,'|',75,'|',100],max:100,step:1" style="width:150px; "></div>
                                </span>




                            </td>
                            <td>
                                <button id="btn_reset_auto_run" type="button" style="margin-left:20px;" class="btn btn-success">恢复自动运行</button>
                            </td>
                        </tr>
                        <tr id="groupeshowtr" style="display: none;">
                            <td>
                                <span style="margin-left:10px;">灯具组号&nbsp;</span>
                                <span class="menuBox">
                                    <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:150px; height: 30px" 
                                           data-options="editable:false,valueField:'id', textField:'text',url:'test1.lamp.getGroupe.action' " />
                                </span>  
                            </td>
                            <td>
                                <span style="margin-left:10px;">调光亮度&nbsp;</span>
                                <input id="groupeval" class="form-control" name="groupeval" style="width:150px;display: inline;" placeholder="灯具组号亮度值" type="text">
                                <!--<input id="groupeval" class="easyui-validatebox" data-options="required:true,validType:'number'" >-->

                            </td>
                            <td>
                                <button  type="button" style="margin-left:20px;" onclick="lightgroupe()" class="btn btn-success">按组调光 </button>
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                            <td>

                            </td>                           
                        </tr>

                    </tbody>
                </table>
            </form>
            <!--<div class="bootstrap-table">-->
            <!--<div class="fixed-table-container" style="height: 214px; padding-bottom: 0px;">-->     
            <div class="panel panel-success" style="margin-top: 60px;" >
                <div class="panel-heading">
                    <h3 class="panel-title">灯具表</h3>
                </div>
                <div class="panel-body" >
                    <div class="container"  >
                        <table id="gravidaTable" style="width:100%;"  class="text-nowrap table table-hover table-striped">
                        </table>
                        <table id="groupegravidaTable" style="width:100%;"  class="text-nowrap table table-hover table-striped">
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </body>
</html>
