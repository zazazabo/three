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
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            var ErrInfo = {
                "0": {
                    "zh-CN": "正确",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "1": {
                    "zh-CN": "数据内容出错",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "2": {
                    "zh-CN": "重复设备序号",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "3": {
                    "zh-CN": "重复防盗序号",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "4": {
                    "zh-CN": "重复装置序号",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "5": {
                    "zh-CN": "透传超时",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "6": {
                    "zh-CN": "末查询到此设备或信息",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "7": {
                    "zh-CN": "组号超范围或灯号异常",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                },
                "8": {
                    "zh-CN": "集中器忙",
                    "en_US": "ok",
                    "e_BY": "e_ok"
                }
            }
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function tourlampCB(obj) {
                $('#panemask').hideLoading();
                var v = Str2BytesH(obj.data);
                var s = "";
                for (var i = 0; i < v.length; i++) {

                    s = s + sprintf("%02x", v[i]) + " ";
                }
                console.log(s);
                if (v[14] == 0 && v[15] == 0 && v[16] == 0x40 && v[17] == 0) {
                    var z = 19;
                    var len = v[18];
                    console.log(len);
                    for (i = 0; i < len; i++) {


                        var l_code = v[z + 1] * 256 + v[z];
                        //电压
                        console.log(l_code);
                        z = z + 2;
                        var bw = v[z + 1] >> 4 & 0xf;
                        var sw = v[z + 1] & 0xf;
                        var gw = v[z] >> 4 & 0xf;
                        var sfw = v[z] & 0xf;
                        var voltage = sprintf("%d%d%d.%d(V)", bw, sw, gw, sfw);
                        console.log(voltage);

                        //电流
                        z = z + 2;
                        var sw = v[z + 1] >> 4 & 0xf;
                        var gw = v[z + 1] & 0xf;
                        var sfw = v[z] >> 4 & 0xf;
                        var bfw = v[z] & 0xf;
                        var electric = sprintf("%d%d.%d%d(A)", sw, gw, sfw, bfw);
                        console.log(electric);
                        //有功功率
                        z = z + 2;
                        var qw = v[z + 3] >> 4 & 0xf;
                        var bw = v[z + 3] & 0xf;
                        var sw = v[z + 2] >> 4 & 0xf;
                        var gw = v[z + 2] & 0xf;
                        var sfw = v[z + 1] >> 4 & 0xf;
                        var bfw = v[z + 1] & 0xf;
                        var qfw = v[z] >> 4 & 0xf;
                        var wfw = v[z] & 0xf;
                        var activepower = sprintf("%d%d%d.%d%d%d%d(KW)", qw, bw, gw, sfw, bfw, qfw, wfw);
                        console.log(activepower);
                        //灯控器状态
                        z = z + 4;
                        var s1 = v[z];
                        var s2 = v[z + 1];
                        var s3 = v[z + 2];
                        var s4 = v[z + 3];








                        //调光值
                        z = z + 4;
                        var l_value = v[z];
                        console.log(l_value);
                        //温度
                        z = z + 2;
                        var temperature = v[z + 1] == 1 ? -v[z] : v[z];
                        console.log(temperature);
                        var o = {};
                        o.l_comaddr = obj.comaddr;
                        o.l_code = l_code;
                        o.voltage = voltage;
                        o.electric = electric;
                        o.activepower = activepower;
                        o.presence = 1;
                        o.l_value = l_value;
                        o.temperature = temperature;
                        $.ajax({async: false, url: "lamp.lampform.modifylampstatus.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });


                    }

                }
            }
            function tourlamp() {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);   //请勾选表格数据
                    return;
                }
                var vv = [];
                vv.push(0);
                var iii = 0;
                for (var i = 0; i < selects.length; i++) {
                    var ele = selects[i];
                    if (ele.l_deplayment == "1") {
                        iii += 1;
                        var setcode = ele.l_code;
                        var l_code = parseInt(setcode);
                        var a = l_code >> 8 & 0x00FF;
                        var b = l_code & 0x00ff;
                        vv.push(b);//装置序号  2字节            
                        vv.push(a);//装置序号  2字节           
                    }
                }
                vv[0] = iii;
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAC, num, 0, 40, vv);

                dealsend2("AC", data, 40, "tourlampCB", comaddr, 0, 0, 0);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function  readlampCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    if (data[0xe] == 0 && data[0xf] == 0 && data[0x10] == 0x80 && data[0x11] == 0x3) {
                        console.log("读取的数据:", v);
                        var set1 = data[21] * 256 + data[20];
                        var set2 = data[23] * 256 + data[22];
                        var l_factory = "";
                        for (var i = 29; i > 23; i--) {
                            l_factory = l_factory + sprintf("%02x", data[i]) + "";
                        }
                        var worktype = data[30];
                        var l_groupe = data[31];
                        var o = ["时间", "经纬度", "场景"];
                        var str = "装置号：" + set1.toString() + "<br>测量点号:" + set1.toString() + "<br>通信地址:" + l_factory + "<br>工作方式:" + o[worktype] + "<br>组号:" + l_groupe.toString();
                        layerAler(str);
                    }
                    if (data[0xe] == 0 && data[0xf] == 0 && data[0x10] == 04 && data[0x11] == 0) {
                        var set1 = data[19] * 256 + data[18];
                        var err = data[20];
                        var lang = "zh-CN";
                        var str = ErrInfo[err][lang];
                        layerAler(str);
                    }
                }
                console.log(obj);
            }
            function readlamp() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);   //请勾选表格数据
                    return;
                }
                //addlogon(u_name, "读取", o_pid, "回路部署", "读取灯具信息");
                var len = selects.length;
                var h = len >> 8 & 0x00FF;
                var l = len & 0x00ff;
                vv.push(l);
                vv.push(h);
                var ele = selects[0];
                if (ele.l_comaddr != o.l_comaddr) {
                    layerAler(langs1[385][lang]);  //勾选列表的网关要和下拉的网关一致
                    return;
                }
                var setcode = ele.l_code;
                var l_code = parseInt(setcode);
                var a = l_code >> 8 & 0x00FF;
                var b = l_code & 0x00ff;
                vv.push(b);//装置序号  2字节            
                vv.push(a);//装置序号  2字节     
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(o.l_comaddr, 0x04, 0xAA, num, 0, 380, vv);
                dealsend2("AA", data, 380, "readlampCB", comaddr, 0, 0, 0);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }

            function deploylampCB(obj) {
                $('#panemask').hideLoading();
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {
                        v = v + sprintf("%02x", data[i]) + " ";
                    }
                    console.log(v);
                    if (data[0xe] == 0 && data[0xf] == 0 && data[0x10] == 0x1 && data[0x11] == 0x0) {
                        console.log(obj.param);
                        var param = obj.param;
                        for (var i = 0; i < param.length; i++) {
                            var o = {id: param[i].id, l_deplayment: obj.val};
                            $.ajax({async: false, url: "lamp.lampform.modifyDepayment.action", type: "get", datatype: "JSON", data: o,
                                success: function (data) {
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                        }
                        $("#gravidaTable").bootstrapTable('refresh');
                    } else if (data[0xe] == 0 && data[0xf] == 0 && data[0x10] == 0x4 && data[0x11] == 0x0) {
                        var err = data[20];
                        if (err == 2) {
                            var set1 = data[19] * 256 + data[18];
//                            var o = {l_code: set1, l_comaddr: obj.comaddr};
//                            $.ajax({async: false, url: "lamp.lampform.modifyDepaymentByset.action", type: "get", datatype: "JSON", data: o,
//                                success: function (data) {
//                                },
//                                error: function () {
//                                    alert("提交失败！");
//                                }});
                            var lang = "zh-CN";
                            var str = ErrInfo[err][lang] + "<br>" + "装置号:" + set1.toString();
                            layerAler(str);
                            //layerAler("装置号:" + set1.toString() + "重复");
                        }
                    }
                }
            }
            function deploylamp() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);   //请勾选表格数据
                    return;
                }
                addlogon(u_name, "部署", o_pid, "灯具部署", "部署灯具", o.l_comaddr);
                var len = selects.length;
                var h = len >> 8 & 0x00FF;
                var l = len & 0x00ff;
                vv.push(l);
                vv.push(h);
                var param = [];
                for (var i = 0; i < selects.length; i++) {
                    var ele = selects[i];
                    if (ele.l_comaddr != o.l_comaddr) {
                        layerAler(langs1[385][lang]);  //勾选列表的网关要和下拉的网关一致
                        return;
                    }
                    var setcode = ele.l_code;
                    var l_code = parseInt(setcode);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b);//装置序号  2字节            
                    vv.push(a);//装置序号  2字节     
                    vv.push(b);//测量点号  2字节            
                    vv.push(a);//测量点号  2字节  
                    var factorycode = ele.l_factorycode;

                    while (factorycode.length < 12) {
                        factorycode = "0" + factorycode;
                    }
                    if (factorycode.length > 12) {
                        layerAler("通信地址不能大于12");
                        return;
                    }
                    var factor = Str2BytesH(factorycode);
                    vv.push(factor[5]); //通信地址
                    vv.push(factor[4]); //通信地址
                    vv.push(factor[3]); //通信地址
                    vv.push(factor[2]); //通信地址
                    vv.push(factor[1]); //通信地址
                    vv.push(factor[0]); //通信地址
                    var iworktype = parseInt(ele.l_worktype);
                    vv.push(iworktype); //工作方式
                    var igroupe = parseInt(ele.l_groupe); //组号
                    vv.push(igroupe); //组号
                    var ooo = {row: ele.index, id: ele.id};
                    param.push(ooo);
                }
                console.log(param);
                // var param = {row: ele.index, id: ele.id};
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(o.l_comaddr, 0x04, 0xA4, num, 0, 102, vv);
                dealsend2("A4", data, 102, "deploylampCB", comaddr, 1, param, 1);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            function removelamp() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler(langs1[73][lang]);   //请勾选表格数据
                    return;
                }
                var len = selects.length;
                var h = len >> 8 & 0x00FF;
                var l = len & 0x00ff;
                vv.push(l);
                vv.push(h);
                var param = [];
                addlogon(u_name, "移除", o_pid, "灯具部署", "移除灯具", o.l_comaddr);
                for (var i = 0; i < selects.length; i++) {
                    var ele = selects[i];
                    if (ele.l_comaddr != o.l_comaddr) {
                        layerAler(langs1[385][lang]);  //勾选列表的网关要和下拉的网关一致
                        return;
                    }

                    var setcode = ele.l_code;
                    var l_code = parseInt(setcode);
                    var a = l_code >> 8 & 0x00FF;
                    var b = l_code & 0x00ff;
                    vv.push(b);//装置序号  2字节            
                    vv.push(a);//装置序号  2字节     
                    vv.push(0);//测量点号  2字节            
                    vv.push(0);//测量点号  2字节  
                    var factorycode = ele.l_factorycode;
                    while (factorycode.length < 12) {
                        factorycode = "0" + factorycode;
                    }
                    if (factorycode.length > 12) {
                        layerAler("通信地址不能大于12");
                        return;
                    }
                    var factor = Str2BytesH(factorycode);
                    vv.push(factor[5]); //通信地址
                    vv.push(factor[4]); //通信地址
                    vv.push(factor[3]); //通信地址
                    vv.push(factor[2]); //通信地址
                    vv.push(factor[1]); //通信地址
                    vv.push(factor[0]); //通信地址
                    var iworktype = parseInt(ele.l_worktype);
                    vv.push(iworktype); //工作方式
                    var igroupe = parseInt(ele.l_groupe); //组号
                    vv.push(igroupe); //组号
                    var ooo = {row: ele.index, id: ele.id};
                    param.push(ooo);
                }
                console.log(param);
                var comaddr = o.l_comaddr;
                var data = buicode(o.l_comaddr, 0x04, 0xA4, num, 0, 102, vv);
                var num = randnum(0, 9) + 0x70; //随机帧序列号
                dealsend2("A4", data, 102, "deploylampCB", comaddr, 0, param, 0);
                $('#panemask').showLoading({
                    'afterShow': function () {
                        setTimeout("$('#panemask').hideLoading()", 10000);
                    }
                }
                );
            }
            //  var websocket = null;
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $('#l_comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].name;
                            }
                            $(this).combobox('select', data[0].id);
                        }
                    },
                    onSelect: function (record) {
                        var obj = {};
                        obj.l_comaddr = record.id;
                        obj.pid = "${param.pid}";
                        var opt = {
                            url: "lamp.lampform.getlampList.action",
                            query: obj
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });
                $('#gravidaTable').bootstrapTable({
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
                            title: langs1[55][lang], //所属网关
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: langs1[386][lang], //通信地址
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                value = value.replace(/\b(0+)/gi, "");
                                return value.toString();
                            }
                        }, {
                            field: 'l_name',
                            title: langs1[63][lang], //名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
//                        {
//                            field: 'l_code',
//                            title: langs1[315][lang], //装置序号
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        },
                        {
                            field: 'l_worktype',
                            title: langs1[316][lang], //控制方式
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 0) {
                                    value = "时间表";
                                    return value;
                                } else if (value == 1) {
                                    value = "经纬度";
                                    return value;
                                } else if (value == 2) {
                                    value = "场景";
                                    return value;
                                }
                            }
                        }, {
                            field: 'l_groupe',
                            title: langs1[332][lang], //组号
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                return  row.l_groupe;
                            }
                        }, {
                            field: 'l_deployment',
                            title: langs1[317][lang], //部署情况
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (row.l_deplayment == "0") {
                                    var str = "<span class='label label-warning'>" + langs1[318][lang] + "</span>";  //未部署
                                    return  str;
                                } else if (row.l_deplayment == "1") {
                                    var str = "<span class='label label-success'>" + langs1[319][lang] + "</span>";   //已部署
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
                    pageSize: 50,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [50, 100, 150, 200, 250],
                    //服务器url
                    queryParams: function (params) {   //配置参数     
                        var temp = {//这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: 1,
                            pid: "${param.pid}",
                            l_comaddr: $("#l_comaddr").combobox('getValue')
                        };
                        return temp;
                    },
                });
                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                });
            })
        </script>
    </head>
    <body id="panemask">

        <form id="form1">
            <div class="row">
                <div class="col-xs-12">

                    <table  >
                        <tbody>
                            <tr>
                                <td >
                                    <span style="margin-left:10px;" name="xxx" id="50">集控器</span>&nbsp;</td>
                                <td>

                                    <input  style="margin-left:10px;" id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                            data-options="editable:false,valueField:'id', textField:'text' " />
                                </td>
                                <td>
                                    <button style="margin-left:10px;" id="btndeploylamp" onclick="deploylamp()" type="button" class="btn btn-success btn-sm"><span name="xxx" id="387">部署灯具</span></button>
                                </td>
                                <td>
                                    <button style="margin-left:10px;" id="btnremovelamp" type="button" onclick="removelamp()" class="btn btn-success btn-sm"><span name="xxx" id="388">移除灯具</span></button>
                                </td>
                                <td>
                                    <button style="margin-left:10px;"  type="button" onclick="readlamp()" class="btn btn-success btn-sm"><span name="xxx" id="389">读取灯具信息</span></button>
                                </td>
                                <!--                                <td>
                                                                    <button style="margin-left:10px;"  type="button" onclick="tourlamp()" class="btn btn-success btn-sm"><span name="xxxx" id="403">巡测灯具状态</span></button>
                                                                </td>-->
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>

        </form> 





        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>



    </body>
</html>