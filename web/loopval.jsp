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

            function switchloopCB(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    var param = obj.param;
                    var o = {};
                    o.id = param.id;
                    o.l_switch = obj.val;
                    $.ajax({async: false, url: "test1.loop.modifySwitch.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            $("#gravidaTable").bootstrapTable('updateCell', {index: param.row, field: "l_switch", value: obj.val});
                            //$("#gravidaTable").bootstrapTable('refresh');
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
            }
            function switchloop() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }
                var select = selects[0];

                var comaddr = select.l_comaddr;
                var switchval = $("#switch").combobox('getValue');

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
                dealsend2(data, 302, "switchloopCB", comaddr, 0, param, switchval);

//                var sss = buicode(comaddr, 0x04, 0xA5, num, 0, 208, vv); //0320    
//                dealsend(sss, switchval);
            }

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
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


            $(function () {
                $('#gravidaTable').on("check.bs.table", function (field, value, row, element) {
                    var index = row.data('index');
                    value.index = index;
                    console.log(value);
                });

                $('#gravidaTable').bootstrapTable({
                    url:"loop.loopForm.getLoopList.action",
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
                                console.log(value);
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
                    url: "loop.loopForm.getComaddr.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);

                        } else {
                            $(this).combobox('select', );
                        }
//                        console.log(data);
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

        <div class="modal-body">
            <table>
                <tbody>
                    <tr>
                        <td></td>
                        <td></td>
                        <td>
                            <span style="margin-left:10px;">网关地址&nbsp;</span>
                            <span class="menuBox">

                                <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 34px" 
                                       data-options="editable:false,valueField:'id', textField:'text' " />

                                <!--                                <select name="l_comaddr" id="l_comaddr" placeholder="回路" class="input-sm" style="width:150px;">-->
                            </span>    
                        </td>

                        <td>
                            &nbsp;&nbsp; 
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>

                        <td>
                            <span style="margin-left:10px;">合闸开关&nbsp;</span>

                            <select class="easyui-combobox" id="switch" name="switch" style="width:150px; height: 34px">
                                <option value="170">闭合</option>
                                <option value="85">断开</option>           
                            </select>

                            <!--                            <span class="menuBox">
                                                            <select name="select_switch" id="select_switch" placeholder="开关闸" class="input-sm" style="width:150px;">
                                                                <option value="170">关</option>
                                                                <option value="85">开</option>
                                                            </select>
                                                        </span>   -->
                        </td>

                        <td>
                            &nbsp;&nbsp;
                            <button id="btnswitch" onclick="switchloop()" class="btn btn-success">合闸开关</button>
                        </td>


                    </tr>


                </tbody>
            </table>
        </div>
        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>

    </body>
</html>
