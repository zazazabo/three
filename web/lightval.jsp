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
        <style>
            .btn{ margin-left: 10px;}
        </style>
        <script>
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function search() {
                var o = $("#formsearch").serializeObject();
                 console.log(o);
                var opt = {
                    url: "lamp.lampform.getlampList.action",
                    query: o
     
                };
                $('#gravidaTable').bootstrapTable('refresh', opt);

            }
            function onlamp(){

            }
            function offlamp(){
                
            }
            function sceneCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    if (obj.fn == 304) {
                        layerAler("单灯场景调光成功");
                    } else if (obj.fn == 308) {
                        layerAler("按组场景调光成功");
                    }
                }
            }

            function restoreCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler("恢复成功");
                }
            }

            function restore() {

                var o = $("#formsearch").serializeObject();
                if (o.type == "3") {
                    if (o.l_comaddr == "") {
                        layerAler("请选择网关");
                        return;
                    }
                    var vv = new Array();
                    var l_comaddr = o.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 180, vv); //01 03
                    //dealsend(sss, o1);
                    dealsend2("A4", data, 180, "restoreCB", l_comaddr, 0, 0, 0);
                } else if (o.type == 2) {

                    if (o.l_comaddr == "" || o.l_groupe == "") {
                        layerAler("请选择网关或组号");
                        return;
                    }

                    var vv = new Array();
                    var l_comaddr = o.l_comaddr;
                    vv.push(1);
                    var groupe = o.l_groupe;
                    var l_groupe = parseInt(groupe, "10");
                    vv.push(l_groupe); //组号
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 140, vv); //01 03
                    dealsend2("A4", data, 180, "restoreCB", l_comaddr, o.type, 0, groupe);
                } else if (o.type == 1) {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');

                    if (selects.length == 0) {
                        layerAler("请勾选灯具数据");
                        return;
                    }
                    var select = selects[0];

                    var vv = new Array();
                    var l_comaddr = select.l_comaddr;
                    var c = parseInt(select.l_code);
                    var h = c >> 8 & 0x00ff;
                    var l = c & 0x00ff;
                    vv.push(l);
                    vv.push(h); //装置序号  2字节
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 140, vv); //01 03
                    dealsend2("A5", data, 180, "restoreCB", l_comaddr, o.type, 0, select.l_code);
                }

            }
            function scenegroupe() {
                var obj = $("#formsearch").serializeObject();
                if (isNumber(obj.scennum) == false) {
                    layerAler("场景号必须数字")
                    return;
                }

                if (isNumber(obj.l_comaddr) == false || isNumber(obj.l_groupe) == false) {
                    layerAler("网关或组号不是数字");
                    return
                }


                var vv = new Array();
                var l_comaddr = obj.l_comaddr;
                vv.push(1);
                var groupe = obj.l_groupe;
                var l_groupe = parseInt(groupe, "10");
                vv.push(l_groupe); //组号


                var scenenum = obj.scennum;
                vv.push(parseInt(obj.scennum));
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 308, vv); //01 03
                //dealsend(sss, o1);
                dealsend2(data, 308, "sceneCB", l_comaddr, obj.lighttype, groupe, scenenum);
            }

            function scenesingle() {
                var obj = $("#formsearch").serializeObject();
                if (isNumber(obj.scennum) == false) {
                    layerAler("场景号必须数字")
                    return;
                }
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var select = selects[0];
                if (selects.length == 0) {
                    layerAler("请勾选灯具数据");
                    return;
                }

                var vv = new Array();
                var l_comaddr = select.l_comaddr;
                var c = parseInt(select.l_code);
                var h = c >> 8 & 0x00ff;
                var l = c & 0x00ff;

                vv.push(l);
                vv.push(h); //装置序号  2字节
                var scenenum = obj.scennum;
                vv.push(parseInt(obj.scennum));
                var param = {};
                param.id = select.id;
                param.row = select.index;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 304, vv); //01 03
                dealsend2("A5", data, 304, "sceneCB", l_comaddr, obj.lighttype, param, scenenum);
            }

            function lightCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    if (obj.fn == 301) {
                        layerAler("单灯调光成功");
                        var param = obj.param;
                        var o = {};
                        o.l_value = obj.val;
                        o.id = param.id;
                        $.ajax({async: false, url: "test1.lamp.modifyvalue.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length == 1) {
                                    $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_value", value: obj.val});
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    } else if (obj.fn == 302) {

                        var param = obj.param;
                        var o = {};
                        o.l_value = obj.val;
                        o.l_comaddr = obj.comaddr;
                        o.l_groupe = param.l_groupe;
                        $.ajax({async: false, url: "test1.lamp.modifygroupeval.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                var arrlist = data.rs;
                                if (arrlist.length >= 1) {

                                    $('#gravidaTable').bootstrapTable('refresh');
                                }
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });








                    }
                }
            }

            function  lightsingle() {

                var o = $("#formsearch").serializeObject();
                var selects = $('#gravidaTable').bootstrapTable('getSelections');

                if (selects.length == 0) {
                    layerAler("请勾选灯具数据");
                    return;
                }
                var vv = new Array();
                var l_comaddr = $("#l_comaddr").combobox('getValue');
                var select = selects[0];
                console.log(select);
                var l_comaddr = select.l_comaddr;
                var lampval = $("#val").val();
                var setcode = select.l_code;
                var dd = get2byte(setcode);
                var set1 = Str2BytesH(dd);
                vv.push(set1[1]);
                vv.push(set1[0]); //装置序号  2字节
                vv.push(parseInt(lampval));
                var num = randnum(0, 9) + 0x70;
                var param = {};
                param.id = select.id;
                param.row = select.index;
                var data = buicode(l_comaddr, 0x04, 0xA5, num, 0, 301, vv); //01 03
                //dealsend(sss, o1);
                dealsend2("A5", data, 301, "lightCB", l_comaddr, o.groupetype, param, lampval);

            }

            function lightgroupe() {
                var obj = $("#formsearch").serializeObject();
                if (isNumber(obj.l_comaddr) == false || isNumber(obj.l_groupe) == false) {
                    layerAler("网关或组号不是数字");
                    return
                }

                var vv = new Array();
                vv.push(1);
                var comaddr = obj.l_comaddr;
                var groupe = obj.l_groupe;
                var l_groupe = parseInt(groupe, "10");
                vv.push(l_groupe); //组号
                var groupeval = $("#val").val();
                vv.push(parseInt(groupeval, "10")); //组亮度值
                var num = randnum(0, 9) + 0x70;

                var param = {};
                param.l_groupe = l_groupe;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 302, vv); //01 03 F24     
                dealsend2("A5", data, 302, "lightCB", comaddr, obj.groupetype, param, groupeval);
            }


//            function dealsend2(data, fn, func, comaddr, type, param, val) {
//                var user = new Object();
//                user.begin = '6A';
//                user.res = 1;
//                user.status = "";
//                user.comaddr = comaddr;
//                user.fn = fn;
//                user.function = func;
//                user.param = param;
//                user.page = 2;
//                user.msg = "A5";
//                user.res = 1;
//                user.val = val;
//                user.type = type;
//                user.addr = getComAddr(comaddr); //"02170101";
//                user.data = data;
//                user.len = data.length;
//                user.end = '6A';
//                console.log(user);
//                parent.parent.sendData(user);
//            }

            $(function () {
                $('#gravidaTable').bootstrapTable({
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
                    url: 'lamp.lampform.getlampList.action',
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
                            l_deplayment: 1,
                            pid: "${param.pid}"
                        };      
                        return temp;  
                    },
                });

                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                    console.log(value);
                });


// 组号方式

                $('#groupetype').combobox({
                    onSelect: function (record) {
                        if (record.value == 0) {
                            var valinput1 = $("button[name='btnsingle']");
                            var valinput2 = $("button[name='btngroupe']");
                            $(valinput1[0]).show();
                            $(valinput1[1]).show();
                            $(valinput2[0]).hide();
                            $(valinput2[1]).hide();
                        } else if (record.value == 1) {
                            var valinput1 = $("button[name='btnsingle']");
                            var valinput2 = $("button[name='btngroupe']");
                            $(valinput1[0]).hide();
                            $(valinput1[1]).hide();
                            $(valinput2[0]).show();
                            $(valinput2[1]).show();

                            var o = $("#formsearch").serializeObject();
                            console.log(o);

                        }
                    }
                })

                $('#l_comaddr').combobox({
                    url: "lamp.lampform.getComaddr.action?l_deplayment=1&pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);
                        } else {
                            $(this).combobox('select', );
                        }
                        console.log(data);
                    },
                    onSelect: function (record) {
                        var url = "lamp.GroupeForm.getGroupe.action?l_comaddr=" + record.id + "&l_deplayment=1";
                        $("#l_groupe").combobox("reload", url);
                    }
                });


                $('#scenetype').combobox({
                    onSelect: function (record) {
                        var o = $("#formsearch").serializeObject();
                        $("#light" + record.value).show();
                        var a1 = 1 - parseInt(record.value);
                        $("#light" + a1.toString()).hide();
//                        console.log(o);

//                        var o1 = "#light" + record.value;
//                        $("#light" + record.value).show();
//                        var j = 1 - parseInt(record.value);
//                        $("#light" + j.toString()).hide();

                    }
                });


                $('#slide_lamp_val').slider({
                    onChange: function (v1, v2) {
                        $("#val").val(v1);
                    }
                });


            })
        </script>
    </head>
    <body>


        <form id="formsearch">
            <input type="hidden" name="pid" value="${param.pid}">


            <div class="row" >
                <div class="col-xs-12">
                    <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629; margin-left: 20px; margin-top: 10px; align-content:  center">
                        <tbody>
                            <tr>

                                <td>
                                    <span style="margin-left:10px;">网关地址&nbsp;</span>
                                </td>
                                <td>

                                    <span class="menuBox">
                                        <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                               data-options="editable:true,valueField:'id', textField:'text' " />
                                    </span>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;">灯具组号&nbsp;</span>
                                </td>
                                <td>

                                    <span class="menuBox">
                                        <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:100px; height: 30px" 
                                               data-options="editable:false,valueField:'id', textField:'text' " />
                                    </span>  
                                </td>
                                <td>
                                    <span style="margin-left:10px;">分组方式&nbsp;</span>
                                </td>
                                <td>


                                    <select class="easyui-combobox" id="groupetype" name="groupetype" style="width:150px; height: 30px">
                                        <option value="0">单灯调光</option>
                                        <option value="1">组号调光</option>           
                                    </select>   


                                </td>

                                <td>
                                    <span style="margin-left:10px;">调光模式&nbsp;</span>
                                </td>
                                <td>
                                    <select class="easyui-combobox" id="scenetype" name="scenetype" style="width:150px; height: 30px">
                                        <option value="0">立即调光</option>
                                        <option value="1">场景调光</option>           
                                    </select>
                                </td>



                                <td>
                                    <button  type="button" style="margin-left:20px;" onclick="search()" class="btn btn-success btn-xm">搜索</button>&nbsp;

                                </td>
                                <td>
                                    <button  type="button" style="margin-left:20px;" onclick="onlamp()" class="btn btn-success btn-xm">开灯</button>&nbsp;                                    
                                </td>
                                <td>
                                    <button  type="button" style="margin-left:20px;" onclick="offlamp()" class="btn btn-success btn-xm">关灯</button>&nbsp;
                                </td>

                            </tr>


                        </tbody>
                    </table> 
                </div>
            </div>

            <div class="row" style="  margin-top: 10px;">

                <div class="col-xs-4">
                    <table  style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px;margin-left: 20px;">
                        <tr>
                            <td>
                                <span style="margin-left:10px;">恢复模式&nbsp;</span>
                                <select class="easyui-combobox" id="type" name="type" style="width:150px; height: 30px">
                                    <option value="1">单灯恢复时间控制</option>
                                    <option value="2">按组恢复时间控制</option>    
                                    <option value="3">全部恢复时间控制</option>  
                                </select>
                                <button  type="button" style="margin-left:20px;" onclick="restore()" class="btn btn-success btn-sm">恢复自动运行</button>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="col-xs-6" id="light0">
                    <table  style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px;margin-left: 20px;">
                        <tr>
                            <td>
                                <span style="margin-left:10px;">调光值&nbsp;</span>
                                <input id="val" value="0" class="form-control" readonly="true" name="val" style="width:50px;display: inline; height: 30px; " placeholder="调光值" type="text">

                            </td>
                            <td >
                                <div  id="slide_lamp_val"  class="easyui-slider"     data-options="showTip:true,min:0,max:100,step:1" style="width:100px;    "></div>

                            </td>
                            <td>
                                <button  type="button"  name="btnsingle"  onclick="lightsingle()" class="btn btn-success btn-sm">单灯立即调光</button>
                                <button  type="button" name="btngroupe"  style="display: none"  onclick="lightgroupe()" class="btn btn-success btn-sm">按组立即调光</button>
                            </td>
                        </tr>
                    </table>
                </div>


                <div class="col-xs-6"  id="light1" style="display: none;">
                    <table   style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; width: 350px; margin-left: 20px;">
                        <tbody>
                            <tr>
                                <td>

                                    <span style="margin-left:10px;">场景号&nbsp;</span>
                                    <!--<input id="scennum" class="form-control" name="scennum" style="width:50px;display: inline;" placeholder="场景号" type="text">&nbsp;-->
                                    <select class="easyui-combobox" id="scennum" name="scennum" style="width:150px; height: 30px">
                                        <option value="1">场景1</option>
                                        <option value="2">场景2</option>    
                                        <option value="3">场景3</option> 
                                        <option value="4">场景4</option> 
                                        <option value="5">场景5</option> 
                                        <option value="6">场景6</option> 
                                        <option value="7">场景7</option> 
                                        <option value="8">场景8</option> 
                                    </select>
                                    <button  type="button"  name="btnsingle" style="margin-left:20px;" onclick="scenesingle()" class="btn btn-success btn-sm">立即场景</button>
                                    <button  type="button" name="btngroupe" style="margin-left:20px; display: none" onclick="scenegroupe()" class="btn btn-success btn-sm">按组场景</button>
                                </td>

                            </tr>

                        </tbody>
                    </table> 
                </div>
            </div>


        </form>


        <table id="gravidaTable" style="width:100%;"  class="text-nowrap table table-hover table-striped">
        </table>


    </body>
</html>
