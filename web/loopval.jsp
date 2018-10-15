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
        <style>
            .btn { margin-left: 10px;}
        </style>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
        <script>

            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();


            function switchloopCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    var param = obj.param;
                    var o = {};
                    o.id = param.id;
                    o.l_switch = obj.val;
                    $.ajax({async: false, url: "loop.loopForm.modifySwitch.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_switch", value: obj.val});
                            layerAler("回路控制成功")
                            //$("#gravidaTable").bootstrapTable('refresh');
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });

                }
            }
            function switchloop() {

                var o1 = $("#form1").serializeObject();
                if (o1.l_comaddr == "") {
                    layerAler("网关地址不能为空");
                    return;
                }
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }
                var select = selects[0];
                if (select.l_deplayment == "0") {
                    layerAler("请部署后再操作");
                    return;
                }
                addlogon(u_name, "合闸开关", o_pid, "回路断合闸", "回路断合闸");
                var comaddr = select.l_comaddr;
                var switchval = o1.switch;

                var vv = new Array();
                var c = parseInt(select.l_code);
                var h = c >> 8 & 0x00ff;
                var l = c & 0x00ff;
                vv.push(l);
                vv.push(h); //装置序号  2字节

                vv.push(parseInt(switchval));
                var num = randnum(0, 9) + 0x70;
                var param = {};

                param.row = select.index;
                param.id = select.id;

                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 208, vv); //01 03 F24     
                dealsend2("A5", data, 208, "switchloopCB", comaddr, o1.type, param, switchval);

            }
            function restoreloopCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler("恢复成功");
                }

            }
            function restoreloop() {
                var o1 = $("#form1").serializeObject();
                if (o1.l_comaddr == "") {
                    layerAler("网关地址不能为空");
                    return;
                }
                addlogon(u_name, "恢复自动运行", o_pid, "回路断合闸", "恢复回路自动运行");
                if (o1.type == "0") {
                    var selects = $('#gravidaTable').bootstrapTable('getSelections');
                    if (selects.length == 0) {
                        layerAler("请勾选表格数据");
                        return;
                    }
                    var select = selects[0];
                    var comaddr = select.l_comaddr;
                    var vv = new Array();
                    var c = parseInt(select.l_code);
                    var h = c >> 8 & 0x00ff;
                    var l = c & 0x00ff;
                    vv.push(l);
                    vv.push(h); //装置序号  2字节
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA5, num, 0, 280, vv); //01 03 F24     
                    dealsend2("A5", data, 280, "restoreloopCB", comaddr, o1.type, 0, 0);
                } else if (o1.type == "1") {
                    var comaddr = o1.l_comaddr;
                    var vv = new Array();
                    var switchval = o1.switch;
                    vv.push(parseInt(switchval));
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA5, num, 0, 240, vv); //01 03 F24     
                    dealsend2("A5", data, 240, "restoreloopCB", comaddr, o1.type, 0, 0);
                }
            }
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {
                var lang = '${param.lang}';//'zh_CN';
                var langs1 = parent.parent.getLnas();
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                });

                $('#gravidaTable').bootstrapTable({
                    showExport: true, //是否显示导出
                    exportDataType: "basic", //basic', 'a
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
                            field: 'l_switch',
                            title: '合闸参数',
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                if (value == 170) {
                                    return "断开"
                                } else if (value == 85) {
                                    return "闭合";
                                }

//                                var groupe = value.toString();
//                                return  groupe;
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
                                    var obj1 = {index: index, data: row};
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
                            pid: "${param.pid}"  
                        };      
                        return temp;  
                    },
                });

                $('#l_comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    formatter: function (row) {
                        var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                        var v = row.text + v1;
                        row.id = row.id;
                        row.text = v;
                        var opts = $(this).combobox('options');
                        console.log(row[opts.textField]);
                        return row[opts.textField];
                    },
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            for (var i = 0; i < data.length; i++) {
                                data[i].text = data[i].id;
                            }

                            $(this).combobox('select', data[0].id);

                        }
                    },
                    onSelect: function (record) {
                        var obj = {};
                        obj.l_comaddr = record.id;
               
                        obj.pid = "${param.pid}";
                        console.log(obj);
                        var opt = {
                            url: "loop.loopForm.getLoopList.action",
                            silent: true,
                            query: obj
                        };
                        $("#gravidaTable").bootstrapTable('refresh', opt);
                    }
                });
            })


        </script>
    </head>
    <body>

        <form id="form1">
            <table>
                <tbody>
                    <tr>
                        <td>
                            <span style="margin-left:10px;">
                                <!-- 网关地址-->
                                <span id="25" name="xxx"></span>
                                &nbsp;</span>
                            <span class="menuBox">

                                <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 34px" 
                                       data-options="editable:false,valueField:'id', textField:'text' " />
                            </span>    
                        </td>
                        <td>
                            <span style="margin-left:10px;">
                                <!-- 合闸开关-->
                                <span id="77" name="xxx"></span>
                                &nbsp;</span>

                            <select class="easyui-combobox" id="switch" name="switch" style="width:100px; height: 30px">
                                <option value="170">断开</option>
                                <option value="85">闭合</option>           
                            </select>

                            <button type="button" id="btnswitch" onclick="switchloop()" class="btn btn-success btn-sm">
                                <!--合闸开关-->
                                <span id="49" name="xxx"></span>
                            </button>
                            
                            
                            <span style="margin-left:10px;" id="48" name="xxx">
                                <!--回路-->
                            </span>
                            <select class="easyui-combobox" id="type" name="type" style="width:100px; height: 30px">
                                <option value="0">单个回路</option>
                                <option value="1">所有回路</option>           
                            </select>

                        </td>

                        <td>

                            <button type="button" id="btnswitch" onclick="restoreloop()" class="btn btn-success btn-sm">
                                <!--恢复自动运行-->
                                <span id="41" name="xxx"></span>
                            </button>

                        </td>
                    </tr>


                </tbody>
            </table>
        </form>

        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>

    </body>
</html>
