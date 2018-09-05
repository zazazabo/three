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

            function loopVal(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    var ar = obj.parama;
                    for (var i = 0; i < ar.length; i++) {
                        var o1 = {};
                        var o = ar[i];
                        o1.id = ar[i];
                        o1.l_switch = obj.type;
                        $.ajax({async: false, url: "test1.loop.modifySwitch.action", type: "get", datatype: "JSON", data: o1,
                            success: function (data) {
                                $("#gravidaTable").bootstrapTable('refresh');
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });

                    }
                }
            }
            function dealsend(data, type) {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var comaddr1 = $("#l_comaddr").combobox('getValue');
                var arr = new Array();
                for (var i = 0; i < selects.length; i++) {
                    arr.push(selects[i].id);
                }
                var user = new Object();
                 user.begin = '6A'
                user.res = 1;
                user.afn = 208;
                user.status = "";
                user.function = "loopVal";
                user.parama = arr;
                user.page = 2;
                user.type = type;    //0移除   1是部署
                user.msg = "A5";        //A5
                user.res = 1;
                user.addr = getComAddr(comaddr1); //"02170101";
                user.data = data;
                 user.end = '6A';
                parent.parent.sendData(user);
            }

            function switchloop() {
                var comaddr = $("#l_comaddr").combobox('getValue');
                var selects = $('#gravidaTable').bootstrapTable('getSelections');

                var switchval = $("#switch").combobox('getValue');

                var vv = new Array();
                if (selects.length == 0) {
                    layerAler("请勾选表格数据");
                    return;
                }
                var select = selects[0];
                if (select.l_deplayment == 0) {
                    layerAler("请先部署上回路");
                    return;
                }

                var setcode = select.l_code;
                var dd = get2byte(setcode);
                var set1 = Str2BytesH(dd);
                vv.push(set1[1]);
                vv.push(set1[0]); //装置序号  2字节
                vv.push(parseInt(switchval));
                var num = randnum(0, 9) + 0x70;
                var sss = buicode(comaddr, 0x04, 0xA5, num, 0, 208, vv); //0320    
                dealsend(sss, switchval);
            }

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            $(function () {


                $('#gravidaTable').bootstrapTable({
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
                                    return "关"
                                } else if (value == 85) {
                                    return "开";
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
                            type_id: "1"    
                        };      
                        return temp;  
                    },
                });

                $('#l_comaddr').combobox({
                    onSelect: function (record) {
                        var obj = {};
                        obj.l_comaddr = record.id;
                        console.log(obj);
                        var opt = {
                            url: "test1.loop.getloop.action",
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
                                       data-options="onLoadSuccess:function(data){
                                       if(Array.isArray(data)&&data.length>0){
                                       $(this).combobox('select', data[0].id);

                                       }else{
                                       $(this).combobox('select',);
                                       }
                                       console.log(data);
                                       },editable:false,valueField:'id', textField:'text',url:'test1.loop.getlampcomaddr.action' " />

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
                                <option value="170">关</option>
                                <option value="85">开</option>           
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
