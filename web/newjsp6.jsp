<%-- 
    Document   : table
    Created on : 2018-6-29, 17:48:10
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html>
<html>
    <head>
         <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style></head>

    <script type="text/javascript" src="js/genel.js"></script>

    <script>

        var websocket = null;

        $(function () {
            var bb = $(window).height() - 20;
            console.log(bb);
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
                        field: 'model',
                        title: '型号',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'name',
                        title: '名称',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'comaddr',
                        title: '通信地址',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'Longitude',
                        title: '经度',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'latitude',
                        title: '纬度',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'online',
                        title: '在线状态',
                        width: 25,
                        align: 'center',
                        valign: 'middle',
                        formatter: function (value, row, index) {
                            return "<img  src='img/off.png'/>";  //onclick='hello()'
                        },
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
                showRefresh: true,
                showToggle: true,
                // 设置默认分页为 50
                pageList: [5, 10, 15, 20, 25],
                onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                    console.info("加载成功");
                    console.log(websocket.readyState);
                    if (websocket != null && websocket.readyState == 1) {
                        var allTableData = $("#gravidaTable").bootstrapTable('getData'); //获取表格的所有内容行
                        console.log(allTableData);
                        for (i = 0; i < allTableData.length; i++)
                        {
                            var obj = allTableData[i];
                            var addrArea = Str2Bytes(obj.comaddr);
                            var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrArea[3]) + sprintf("%02d", addrArea[2]);
                            var user = new Object();
                            user.msg = "getStatus";
                            user.res = 1;
                            user.row = i;
                            user.addr = straddr; //"02170101";
                            user.data = false;
                            var datajson = JSON.stringify(user);
                            websocket.send(datajson);
                        }
                    }
                },
                url: 'test1.f5.h1.action',
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


            $("#shanchu").click(function () {

                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                console.log(selects);
                var num = ""
                if (selects.length == 1) {
                    num = selects[0];
                } else {
                    for (var i = 0; i < selects.length; i++) {
                        num += selects[i].id + ",";
                    }
                }

                console.log(num);
                if (num == 0) {
                    layer.alert('请选择您要删除的记录', {
                        icon: 6,
                        offset: 'center'
                    });
                } else {
                    layer.confirm('您确定要删除吗？', {
                        btn: ['确定', '取消'], //按钮
                        icon: 3,
                        offset: 'center',
                        title: '提示'
                    }, function (index) {

                        if (selects.length == 1) {

                            $.ajax({
                                url: "test1.f5.deleteGateway.action",
                                type: "POST",
                                datatype: "JSON",
                                data: {
                                    id: num.id
                                },
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        layer.open({
                                            content: '删除成功',
                                            icon: 1,
                                            yes: function (index, layero) {
                                                $("#gravidaTable").bootstrapTable('refresh');
                                                layer.close(index);
                                                // layer.close(index) window.parent.document.getElementsByClassName('J_iframe')[0].src = "device/gatewayConfig.action";
                                            }
                                        });
                                    }
                                    layer.close(index);
//                                    
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });
                        } else {
                            layer.alert('只能选择一行进行修改', {
                                icon: 6,
                                offset: 'center'
                            });
                        }


                    });
                }


            });

            //添加时触发
            $('#pjj').on('show.bs.modal', function () {

                $('#mode').combobox({
                    url: 'test1.f5.h2.action',
                    valueField: 'id',
                    textField: 'text'
                });
                $.ajax({
                    url: "test1.f5.h2.action",
                    type: "get",
                    datatype: "JSON",
                    data: {parameter_A: $("#parameter_A").val(), parameter_B: $("#parameter_B").val()},
                    success: function (data) {

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            })

            //修改时触发


            $("#xiugai1").click(function () {
                
                var selectRow1 = $("#gravidaTable").bootstrapTable("getSelections");
                if (selectRow1.length > 1) {
                    layer.alert('只能选择一行进行修改', {
                        icon: 6,
                        offset: 'center'
                    });
                } else if (selectRow1.length == 0) {
                    layer.alert('请先选择', {
                        icon: 6,
                        offset: 'center'
                    });
                } else {
                    selectRow = $("#gravidaTable").bootstrapTable("getSelections")[0];
                    console.log(selectRow);
                    $("#name_").val(selectRow.name);
                    $("#model_").combobox('setText', selectRow.model);
                    $("#model_").combobox('setValue', selectRow.model);
                    $("#id_").val(selectRow.id);
                    $("#comaddr_").val(selectRow.comaddr);

                    var arrlatitude = selectRow.latitude.split(".");
                    var arrLongitude = selectRow.Longitude.split(".");
                    console.log(arrlatitude[0]);
                    console.log(arrLongitude);
                    $("#longitudem26d_").val(arrLongitude[0]);
                    $("#longitudem26m_").val(arrLongitude[1]);
                    $("#longitudem26s_").val(arrLongitude[2]);



                    $("#latitudem26d_").val(arrlatitude[0]);
                    $("#latitudem26m_").val(arrlatitude[1]);
                    $("#latitudem26s_").val(arrlatitude[2]);

                    $("#pjj2").modal();
                }
            });


        })

    </script>
</head>
<body>

    <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
        <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj">
            <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
        </button>
        <button class="btn btn-primary ctrol" id="xiugai1">
            <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
        </button>
        <button class="btn btn-danger ctrol" id="shanchu">
            <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
        </button>
    </div>

    <div style="width:100%;">
        <div class="bootstrap-table">
            <div class="fixed-table-container" style="height: 214px; padding-bottom: 0px;">
                <div class="fixed-table-header">
                    <table></table>
                </div>
                <div class="fixed-table-body">
                    <div class="fixed-table-loading" style="top: 42px; display: none;">正在努力地加载数据中，请稍候……</div>
                    <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                    </table>
                </div>
            </div>
        </div>
    </div>


    <!-- 添加 -->
    <div class="modal"  id="pjj" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog"  >
            <div class="modal-content" style="min-width:700px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span style="font-size:20px ">×</span></button>
                    <span class="glyphicon glyphicon-plus-sign" style="font-size: 20px"></span>
                    <h4 class="modal-title" style="display: inline;">添加网关配置</h4></div>

                <form action="" method="POST" id="eqpTypeForm" onsubmit="return checkAdd()">      
                    <div class="modal-body">
                        <table>
                            <tbody>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">网关名称</span>&nbsp;
                                        <input id="name" class="form-control" name="name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">
                                    </td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">网关型号&nbsp;</span>


                                        <span class="menuBox">

                                            <input id="model" class="easyui-combobox" name="model" style="width:150px; height: 34px" data-options="editable:true,valueField:'id', textField:'text',url:'test1.f5.h2.action'" />

                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">安装位置</span>&nbsp;
                                        <input id="roadaddr" class="form-control" name="roadaddr" style="width:150px;display: inline;" placeholder="请输入网关位置" type="text">
                                    </td>

                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">网关地址&nbsp;</span>
                                        <input id="comaddr" class="form-control" name="comaddr" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">通信方式</span>&nbsp;


                                        <span class="menuBox">
                                            <select name="connecttype" id="connecttype" class="input-sm" style="width:150px;">
                                                <option value="GPRS" selected="selected">GPRS</option>
                                                <option value="net" selected="selected">网线</option>
                                                <option value="485" selected="selected">485</option>
                                            </select>
                                        </span>

                                    </td>

                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">倍&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;</span>
                                        <input id="powerrate" class="form-control" name="powerrate" style="width:150px;display: inline;" placeholder="请输入倍率" type="text"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">区域经度</span>&nbsp;
                                        <input id="longitudem26d" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                        <input id="longitudem26m" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                        <input id="longitudem26s" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">区域纬度&nbsp;</span>
                                        <input id="latitudem26d" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                        <input id="latitudem26m" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                        <input id="latitudem26s" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 添加按钮 -->
                        <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                </form>
            </div>
        </div>
    </div>


    <!-- 修改 -->
    <div class="modal" id="pjj2">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width:700px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span style="font-size:20px ">×</span></button>
                    <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                    <h4 class="modal-title" style="display: inline;">修改网关配置</h4></div>
                <form action="" method="POST" id="modifyTypeForm" onsubmit="return checkcheckModifyModify()">   
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">网关名称</span>&nbsp;
                                        <input id="name_" class="form-control" name="name_" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">
                                        <input id="id_" name="id_" type="hidden">
                                    </td>
                                    <td>

                                    </td>
                                    <td>
                                        <span style="margin-left:10px;">网关型号&nbsp;</span>


                                        <span class="menuBox">

                                            <input id="model_" class="easyui-combobox" name="model_" style="width:150px; height: 34px" data-options="editable:true,valueField:'id', textField:'text',url:'test1.f5.h2.action'" />

                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">安装位置</span>&nbsp;
                                        <input id="roadaddr_" class="form-control" name="roadaddr_" style="width:150px;display: inline;" placeholder="请输入网关位置" type="text">
                                    </td>

                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">网关地址&nbsp;</span>
                                        <input id="comaddr_" readonly="true"  class="form-control" name="comaddr_" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">通信方式</span>&nbsp;


                                        <span class="menuBox">
                                            <select name="connecttype_" id="connecttype_" class="input-sm" style="width:150px;">
                                                <option value="GPRS" selected="selected">GPRS</option>
                                                <option value="net" selected="selected">网线</option>
                                                <option value="485" selected="selected">485</option>
                                            </select>
                                        </span>

                                    </td>

                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">倍&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;</span>
                                        <input id="powerrate_" class="form-control" name="powerrate_" style="width:150px;display: inline;" placeholder="请输入倍率" type="text"></td>
                                </tr>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">区域经度</span>&nbsp;
                                        <input id="longitudem26d_" class="form-control" name="longitudem26d_" style="width:51px;display: inline;" type="text">&nbsp;°
                                        <input id="longitudem26m_" class="form-control" name="longitudem26m_" style="width:45px;display: inline;" type="text">&nbsp;'
                                        <input id="longitudem26s_" class="form-control" name="longitudem26s_" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">区域纬度&nbsp;</span>
                                        <input id="latitudem26d_" class="form-control" name="latitudem26d_" style="width:51px;display: inline;" type="text">&nbsp;°
                                        <input id="latitudem26m_" class="form-control" name="latitudem26m_" style="width:45px;display: inline;" type="text">&nbsp;'
                                        <input id="latitudem26s_" class="form-control" name="latitudem26s_" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                                </tr>

                            </tbody>
                        </table>

                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 添加按钮 -->
                        <button id="xiugai" class="btn btn-primary">确定</button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </form>
            </div>
        </div>
    </div>


</body>
</html>