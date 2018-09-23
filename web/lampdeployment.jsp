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
            function deploylampCB(obj) {
                var param = obj.param;
                if (obj.status == "fail") {
                    if (obj.type == 0) {
                        layerAler("移除失败");
                    } else if (obj.type == "1") {
                        layerAler("部署失败")
                    }

                    if (obj.errcode == 2) {
                        layerAler("重复设备序号");
                        var o = {id: param.id, l_deplayment: obj.val};
                        console.log(o);
                        $.ajax({async: false, url: "lamp.lampform.modifyDepayment.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                $("#gravidaTable").bootstrapTable('refresh');
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    } else if (obj.errcode == 6) {
                        layerAler("未查询到此设备或信息");
                    }


                } else if (obj.status == "success") {
                    if (obj.type == 0) {
                        layerAler("移除成功");
                    } else if (obj.type == 1) {
                        layerAler("部署成功");
                    }
                    var o = {id: param.id, l_deplayment: obj.val};
                    $.ajax({async: false, url: "lamp.lampform.modifyDepayment.action", type: "get", datatype: "JSON", data: o,
                        success: function (data) {
                            $("#gravidaTable").bootstrapTable('refresh');
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }
            }


            function deploylamp() {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }
                var len = selects.length;
                var h = len >> 8 & 0x00FF;
                var l = len & 0x00ff;
                vv.push(l);
                vv.push(h);
                var ele = selects[0];
                if (ele.l_comaddr != o.l_comaddr) {
                    layerAler("列表的网关要和下拉的网关不一致");
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
                var param = {row: ele.index, id: ele.id};
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(o.l_comaddr, 0x04, 0xA4, num, 0, 102, vv);
                var num = randnum(0, 9) + 0x70; //随机帧序列号
                dealsend2("A4", data, 102, "deploylampCB", comaddr, 1, param, 1);
            }

            function removelamp() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var o = $("#form1").serializeObject();
                var vv = new Array();
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }
                var len = selects.length;
                var h = len >> 8 & 0x00FF;
                var l = len & 0x00ff;
                vv.push(l);
                vv.push(h);
                var ele = selects[0];
                if (ele.l_comaddr != o.l_comaddr) {
                    layerAler("列表的网关要和下拉的网关不一致");
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
                var param = {row: ele.index, id: ele.id};
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(o.l_comaddr, 0x04, 0xA4, num, 0, 102, vv);
                var num = randnum(0, 9) + 0x70; //随机帧序列号
                dealsend2("A4", data, 102, "deploylampCB", comaddr, 0, param, 0);
            }



            //  var websocket = null;

            $(function () {

                $('#l_comaddr').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id);
                        } else {
                            $(this).combobox('select', );
                        }
                    },
                    url: "lamp.lampform.getComaddr.action?pid=${param.pid}",
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
                                if (value == 0) {
                                    value = "0(时间)";
                                    return value;
                                } else if (value == 1) {
                                    value = "1 ";
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
                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: 1,
                            pid: "${param.pid}",
                            l_comaddr: $("#l_comaddr").combobox('getValue')
                        };      
                        return temp;  
                    },
                });
            })
        </script>
    </head>
    <body>

        <form id="form1">
            <div class="row">
                <div class="col-xs-12">

                    <table  >
                        <tbody>
                            <tr>
                                <td >
                                    <span style="margin-left:10px;">网关地址&nbsp;</span>
                                </td>
                                <td>


                                    <input  style="margin-left:10px;" id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:100px; height: 30px" 
                                           data-options="editable:false,valueField:'id', textField:'text' " />
                                </td>
                                <td>
                                    <button style="margin-left:10px;" id="btndeploylamp" onclick="deploylamp()" type="button" class="btn btn-success btn-sm">部署灯具</button>
                                </td>
                                <td>
                                    <button style="margin-left:10px;" id="btnremovelamp" type="button" onclick="removelamp()" class="btn btn-success btn-sm">移除灯具</button>
                                </td>
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
