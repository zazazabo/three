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


        <!--<style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style></head>-->
        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } 

            input[type="text"],input[type="radio"] { height: 30px; } 
            table td { line-height: 40px; } 
            .menuBox { position: relative; background: skyblue; } 
            .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } 
            .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } 
            .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } 

            .bodycenter { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } 

        </style>


        <script type="text/javascript" src="js/genel.js"></script>

        <script>

            var websocket = null;
            var vvvv = 0;
            var flag = null;


            function getMessage(obj) {
                console.log("getMessage");
                console.log(obj);
                if (obj.hasOwnProperty("msg")) {
                    if (obj.msg = "getStatus" && obj.data == true) {
                        var trarr = $("#gravidaTable").find("tr");  //所有tr数组
                        var child = $(trarr[obj.row + 1]).children('td:eq(7)');
                        console.log(child);
                        if (child.length == 1) {
                            var jqimg = child.children();
                            if (jqimg.prop("tagName") == "IMG") {
                                jqimg.attr("src", "img/online1.png");
                            }
                        }
                    }
                }
            }

            function showDialog() {

                $('#dialog-add').dialog('open');
                return false;
            }
            function modifyModal() {

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
                    var s = $("#gravidaTable").bootstrapTable("getSelections")[0];
                    console.log(s);

                    $("#name_").val(s.name);

                    $("#model_").combobox('setValue', s.model);
                    $("#connecttype_").combobox('setValue', s.connecttype);
                    $("#setupaddr_").val(s.setupaddr);

                    $("#id_").val(s.id);
                    $("#comaddr_").val(s.comaddr);
                    $("#multpower_").val(s.multpower);

                    var arrlatitude = s.latitude.split(".");
                    var arrLongitude = s.Longitude.split(".");
                    $("#longitudem26d_").val(arrLongitude[0]);
                    $("#longitudem26m_").val(arrLongitude[1]);
                    $("#longitudem26s_").val(arrLongitude[2]);



                    $("#latitudem26d_").val(arrlatitude[0]);
                    $("#latitudem26m_").val(arrlatitude[1]);
                    $("#latitudem26s_").val(arrlatitude[2]);

                    $('#dialog-edit').dialog('open');
                    return false;
                }
            }


            function  editComplete() {
                var obj = $("#form2").serializeObject();


                var latitudemstr = obj.latitudem26d + "." + obj.latitudem26m + "." + obj.latitudem26s;
                obj.latitude = latitudemstr;
                var longitudemstr = obj.longitudem26d + "." + obj.longitudem26m + "." + obj.longitudem26s;
                obj.longitude = longitudemstr;
                console.log(obj);

                $.ajax({async: false, cache: false, url: "test1.gayway.modifyGateway.action", type: "GET", data: obj,
                    success: function (data) {
                        // namesss = true;
                        $("#gravidaTable").bootstrapTable('refresh');
                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {
                            icon: 6,
                            offset: 'center'
                        });
                    }
                })

                return false;
            }




            function dealsend() {

                //            if (websocket != null && websocket.readyState == 1) {
                var allTableData = $("#gravidaTable").bootstrapTable('getData'); //获取表格的所有内容行
                if (allTableData.length > vvvv) {
                    var obj = allTableData[vvvv];
                    var addrArea = Str2Bytes(obj.comaddr);
                    var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrArea[3]) + sprintf("%02d", addrArea[2]);
                    var user = new Object();
                    var ele = {};
                    user.begin = '6A';
                    user.msg = "getStatus";
                    user.res = 1;
                    user.row = vvvv;
                    user.parama = ele;
                    user.page = 2;
                    user.function = "getMessage";
                    user.addr = straddr; //"02170101";
                    user.data = false;
                    user.end = '6A';
                    parent.parent.sendData(user);
                    //  console.log(user);
                    // var datajson = JSON.stringify(user);
                    // websocket.send(datajson);
                    vvvv += 1;
                } else {
                    clearInterval(flag);
                    vvvv = 0;
                }
            }

            $(function () {
                $("#dialog-add").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 350,
                    position: ["top", "top"],
                    buttons: {
                        添加: function () {
                            $("#formadd").submit();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });
                $("#dialog-edit").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 700,
                    height: 300,
                    position: "top",
                    buttons: {
                        修改: function () {
                            editComplete();
                            //$(this).dialog("close");
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });


//
//                $("#add").attr("disabled", true);
//                $("#xiugai").attr("disabled", true);
//                $("#shanchu").attr("disabled", true);
//                var obj = {};
//                obj.code = ${param.m_parent};
//                obj.roletype = ${param.role};
//                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
//                    success: function (data) {
//                        var rs = data.rs;
//                        if (rs.length > 0) {
//                            for (var i = 0; i < rs.length; i++) {
//
//                                if (rs[i].code == "600101" && rs[i].enable != 0) {
//                                    $("#add").attr("disabled", false);
//                                    continue;
//                                }
//                                if (rs[i].code == "600102" && rs[i].enable != 0) {
//                                    $("#xiugai").attr("disabled", false);
//                                    continue;
//                                }
//                                if (rs[i].code == "600103" && rs[i].enable != 0) {
//                                    $("#shanchu").attr("disabled", false);
//                                    continue;
//                                }
//                            }
//                        }
//
//                    },
//                    error: function () {
//                        alert("提交失败！");
//                    }
//                });

                flag = setInterval("dealsend()", 1000);

                var bb = $(window).height() - 20;
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
                            field: 'pid',
                            title: '所属项目',
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
                    clickToSelect: true,
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
                    onLoadSuccess: function (data) {  //加载成功时执行  表格加载完成时 获取集中器在线状态
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


                $("#gravidaTable").on('refresh.bs.table', function (data) {
                    flag = setInterval("dealsend()", 1000);
                });

                $('#gravidaTable').on("click-row.bs.table", function (e, row, element) {
                });
                $("#gravidaTable").on('click-cell.bs.table', function (field, value, row, element) {
                    if (value == "online") {
                    }

                })




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

                //修改时触发


            })




            function checkAdd() {


                if (/^[0-9A-F]{8}$/.test($("#comaddr").val().trim()) == false) {
                    layer.alert('网关地址应为八位有效十六进制字符', {
                        icon: 6,
                        offset: 'center'
                    });
                    return false;
                }

                var obj = $("#formadd").serializeObject();

                var namesss = false;
                $.ajax({async: false, cache: false, url: "test1.f5.queryGateway.action", type: "GET", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            layer.alert('此网关已存在', {
                                icon: 6,
                                offset: 'center'
                            });
                            namesss = false;
                            return;
                        } else if (arrlist.length == 0) {
                            var latitudemstr = obj.latitudem26d + "." + obj.latitudem26m + "." + obj.latitudem26s;
                            obj.latitude = latitudemstr;
                            var longitudemstr = obj.longitudem26d + "." + obj.longitudem26m + "." + obj.longitudem26s;
                            obj.longitude = longitudemstr;

                            $.ajax({async: false, cache: false, url: "test1.f5.addGateway.action", type: "GET", data: obj,
                                success: function (data) {
                                    // namesss = true;
                                    $("#gravidaTable").bootstrapTable('refresh');
                                },
                                error: function () {
                                    layer.alert('系统错误，刷新后重试', {
                                        icon: 6,
                                        offset: 'center'
                                    });
                                }
                            })
                        }

                    },
                    error: function () {
                        layer.alert('系统错误，刷新后重试', {
                            icon: 6,
                            offset: 'center'
                        });
                    }
                });

                return namesss;
            }
        </script>
    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" onclick="showDialog()" data-toggle="modal" data-target="#pjj33" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol" onclick="modifyModal()" id="xiugai1">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button>
            <!--        <button class="btn btn-danger ctrol" id="closews">
                        <span class="glyphicon glyphicon-trash"></span>&nbsp;关闭websocket
                    </button>         
                    <button class="btn btn-danger ctrol" id="addback">
                        <span class="glyphicon glyphicon-trash"></span>&nbsp;添加回路
                    </button>       -->


        </div>
        <!--    <form id="importForm" action="importGateway.action" method="post" enctype="multipart/form-data" onsubmit="return check()">
                <div style="float:left;margin:12px 0 0 10px;border-radius:5px 0 0 5px;position:relative;z-index:100;width:230px;height:30px;">
                    <a href="javascript:;" class="a-upload" style="width:130px;">
                        <input name="excel" id="excel" type="file">
                        <div class="filess">点击这里选择文件</div></a>
                    <input style="float:right;" class="btn btn-default" value="导入Excel" type="submit"></div>
            </form>
            <form id="exportForm" action="exportGateway.action" method="post" style="display: inline;">
                <input id="daochu" class="btn btn-default" style="float:left;margin:12px 0 0 20px;" value="导出Excel" type="button">
            </form>-->


        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
        </table>




        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="网关添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkAdd()">   
                <input id="id" name="id" type="hidden">
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">项目列表&nbsp;</span>
                                <input id="pid" class="easyui-combobox" name="pid" style="width:150px; height: 30px" 
                                       data-options="onLoadSuccess:function(data){
                                       if(Array.isArray(data)&&data.length>0){
                                       $(this).combobox('select', data[0].id)
                                       }else{
                                       $(this).combobox('select',);
                                       }
                                       console.log(data);
                                       },editable:false,valueField:'id', textField:'text',url:'formuser.project.getProject.action?code=P00001' " />
                            </td>
                            <td>

                            </td>
                            <td>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">网关名称</span>&nbsp;
                                <input id="name" class="form-control" name="name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;">网关型号&nbsp;</span>


                                <span class="menuBox">

                                    <input id="model" class="easyui-combobox" name="model" style="width:150px; height: 30px" data-options="editable:true,valueField:'id', textField:'text',url:'test1.f5.h2.action'" />

                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">安装位置</span>&nbsp;
                                <input id="setupaddr" class="form-control" name="setupaddr" style="width:150px;display: inline;" placeholder="请输入网关位置" type="text">
                            </td>

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">网关地址&nbsp;</span>
                                <input id="comaddr" class="form-control" name="comaddr" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">通信方式</span>&nbsp;


                                <span class="menuBox">


                                    <select class="easyui-combobox" id="connecttype" name="connecttype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0" selected="true">GPRS</option>
                                        <option value="1">网线</option>    
                                        <option value="2">485</option>           
                                    </select>







                                    <!--                                    <select name="connecttype" id="connecttype" class="input-sm" style="width:150px;">
                                                                            <option value="GPRS" selected="selected">GPRS</option>
                                                                            <option value="net" selected="selected">网线</option>
                                                                            <option value="485" selected="selected">485</option>
                                                                        </select>-->
                                </span>

                            </td>

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">倍&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;</span>
                                <input id="multpower" class="form-control" name="multpower" style="width:150px;display: inline;" placeholder="请输入倍率" type="text">
                            </td>
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
            </form>                        
            <!--                             <button id="tianjia1" type="submit" class="btn btn-primary">添加</button>
                                                                                     关闭按钮 
                                                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>-->


        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="网关修改">
            <form action="" method="POST" id="form2" onsubmit="return editComplete()">  
                <table>
                    <tbody>

                        <tr>
                            <td>
                                <span style="margin-left:20px;">网关名称</span>&nbsp;
                                <input id="name_" class="form-control" name="name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">
                                <input id="id_" name="id" type="hidden">
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:10px;">网关型号&nbsp;</span>


                                <span class="menuBox">

                                    <input id="model_" class="easyui-combobox" name="model" style="width:150px; height: 30px" data-options="editable:true,valueField:'id', textField:'text',url:'test1.f5.h2.action'" />

                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">安装位置</span>&nbsp;
                                <input id="setupaddr_" class="form-control" name="setupaddr" style="width:150px;display: inline;" placeholder="请输入网关位置" type="text">
                            </td>

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">网关地址&nbsp;</span>
                                <input id="comaddr_" readonly="true"  class="form-control" name="comaddr" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text"></td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">通信方式</span>&nbsp;


                                <span class="menuBox">
                                    <select class="easyui-combobox" id="connecttype_" name="connecttype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0" selected="true">GPRS</option>
                                        <option value="1">网线</option>    
                                        <option value="2">485</option>           
                                    </select>
                                </span>

                            </td>

                            <td></td>
                            <td>
                                <span style="margin-left:10px;">倍&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;率&nbsp;</span>
                                <input id="multpower_" class="form-control" name="multpower" style="width:150px;display: inline;" placeholder="请输入倍率" type="text"></td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:20px;">区域经度</span>&nbsp;
                                <input id="longitudem26d_" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="longitudem26m_" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="longitudem26s_" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;">区域纬度&nbsp;</span>
                                <input id="latitudem26d_" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="latitudem26m_" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="latitudem26s_" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                        </tr>

                    </tbody>
                </table>
            </form>
        </div>




    </body>
</html>
