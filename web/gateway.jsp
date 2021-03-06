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

            .mb{
                top:-60%;
                position:absolute;
                z-index:9999;
                background-color:#FFFFFF;
            }
        </style>

        <script type="text/javascript" src="SheetJS-js-xlsx/dist/xlsx.core.min.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            function excel() {
                $('#dialog-excel').dialog('open');
                return false;
                
            }
            
            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }
            function deleteGateway() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[263][lang]);//请选择您要删除的数据
                } else {
                    layer.confirm(langs1[145][lang], {//确定要删除吗？
                        btn: [langs1[146][lang], langs1[147][lang]], //按钮、取消按钮
                        icon: 3,
                        offset: 'center',
                        title: langs1[174][lang]  //提示
                    }, function (index) {
                        addlogon(u_name, "删除", o_pid, "网关管理", "删除网关", selects[0].comaddr);
                        var o = {l_comaddr: selects[0].comaddr, id: selects[0].id};
                        $.ajax({url: "gayway.GaywayForm.existcomaddr.action", async: false, type: "POST", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data.length >= 1) {
                                    layerAler(langs1[341][lang]); //此网关在灯具或回路有数据,请先清空回路和灯具的网关
                                } else if (data.length == 0) {
                                    $.ajax({url: "gayway.GaywayForm.deleteGateway.action", type: "POST", datatype: "JSON", data: o,
                                        success: function (data) {
                                            var arrlist = data.rs;
                                            if (arrlist.length == 1) {
                                                //删除成功
                                                layer.open({content: langs1[342][lang], icon: 1,
                                                    yes: function (index, layero) {
                                                        $("#gravidaTable").bootstrapTable('refresh');
                                                        layer.close(index);
                                                    }
                                                });
                                            }
                                            
                                            //                                    
                                        },
                                        error: function () {
                                            alert("提交失败！");
                                        }
                                    });
                                }
                            }
                            
                        });
                        layer.close(index);
                        
                    });
                }
            }
            
            
            
            function showDialog() {
                
                $('#dialog-add').dialog('open');
                return false;
            }
            
            function modifyModal() {
                
                var selectRow1 = $("#gravidaTable").bootstrapTable("getSelections");
                if (selectRow1.length > 1) {
                    //只能选择一行进行修改
                    layer.alert(langs1[74][lang], {
                        icon: 6,
                        offset: 'center'
                    });
                } else if (selectRow1.length == 0) {
                    //请勾选表格数据
                    layer.alert(langs1[73][lang], {
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
                    $("#bz1").val(s.bz);
                    $("#id_").val(s.id);
                    $("#comaddr_").val(s.comaddr);
//                    $("#multpower_").val(s.multpower);
                    
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
                addlogon(u_name, "修改", o_pid, "网关管理", "修改网关", obj.comaddr);
                $.ajax({async: false, cache: false, url: "gayway.GaywayForm.modifyGateway.action", type: "GET", data: obj,
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
            
            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                
                $('#warningtable').bootstrapTable({
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
                            title: langs1[345][lang], //序号
                            field: '序号',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: langs1[25][lang], //网关地址
                            field: '网关地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: langs1[314][lang],
                            field: '名称', //网关名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            title: langs1[59][lang], //经度
                            field: '经度',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '纬度', //纬度
                            title: langs1[60][lang],
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: '安装位置',
                            title: langs1[347][lang], //安装位置
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },{
                            field: '备注',
                            title: langs1[149][lang], //安装位置
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }
                    ],
                    singleSelect: false,
                    locale: 'zh-CN', //中文支持,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 40,
                    pageList: [20, 40, 80, 160]
                            
                });
                
                $('#excel-file').change(function (e) {
                    var files = e.target.files;
                    var fileReader = new FileReader();
                    fileReader.onload = function (ev) {
                        try {
                            var data = ev.target.result,
                                    workbook = XLSX.read(data, {
                                        type: 'binary'
                                    }), // 以二进制流方式读取得到整份excel表格对象
                                    persons = []; // 存储获取到的数据
                        } catch (e) {
                            alert(langs1[348][lang]);  //文件类型不正确
                            return;
                        }
                        // 表格的表格范围，可用于判断表头是否数量是否正确
                        var fromTo = '';
                        // 遍历每张表读取
                        for (var sheet in workbook.Sheets) {
                            if (workbook.Sheets.hasOwnProperty(sheet)) {
                                fromTo = workbook.Sheets[sheet]['!ref'];
                                persons = persons.concat(XLSX.utils.sheet_to_json(workbook.Sheets[sheet]));
                                // break; // 如果只取第一张表，就取消注释这行
                            }
                        }
                        var headStr = '序号,名称,网关地址,经度,纬度,安装位置,备注';
                        var headStr2 = '序号,名称,网关地址,安装位置,备注';
                        var headStr3 = '序号,名称,网关地址,经度,纬度,安装位置';
                        var headStr4 = '序号,名称,网关地址,安装位置';
                        for (var i = 0; i < persons.length; i++) {
                            if (Object.keys(persons[i]).join(',') !== headStr && Object.keys(persons[i]).join(',') !== headStr2 && Object.keys(persons[i]).join(',') !== headStr3 && Object.keys(persons[i]).join(',') !== headStr4) {
                                alert(langs1[366][lang]); //导入文件格式不正确
                                persons = [];
                            }
                        }
                        $("#warningtable").bootstrapTable('load', []);
                        if (persons.length > 0) {
                            $('#warningtable').bootstrapTable('load', persons);
                            
                        }
                    };
                    // 以二进制方式打开文件
                    fileReader.readAsBinaryString(files[0]);
                });
                
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
                
                $("#dialog-excel").dialog({
                    autoOpen: false,
                    modal: true,
                    width: 750,
                    height: 500,
                    position: "top",
                    buttons: {
                        保存: function () {
                            addexcel();
                        }, 关闭: function () {
                            $(this).dialog("close");
                        }
                    }
                });
                
                
                $('#pid').combobox({
                    url: "gayway.GaywayForm.getProject.action?code=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox('select', data[0].id)
                        }
                    }
                });
                
                $("#add").attr("disabled", true);
                $("#xiugai").attr("disabled", true);
                $("#shanchu").attr("disabled", true);
                $("#addexcel").attr("disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {
                                
                                if (rs[i].code == "600101" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    $("#addexcel").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "600102" && rs[i].enable != 0) {
                                    $("#xiugai").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "600103" && rs[i].enable != 0) {
                                    $("#shanchu").attr("disabled", false);
                                    continue;
                                }
                            }
                            
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                
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
                        }
//                        , {
//                            field: 'pid',
//                            title: langs1[349][lang],  //所属项目
//                            width: 25,
//                            align: 'center',
//                            valign: 'middle'
//                        }
                        , {
                            field: 'model',
                            title: langs1[62][lang], //型号
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'name',
                            title: langs1[63][lang], //名称
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'comaddr',
                            title: langs1[25][lang], //网关地址
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'Longitude',
                            title: langs1[59][lang], //经度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'latitude',
                            title: langs1[60][lang], //纬度
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'online',
                            title: langs1[61][lang], //在线状态
                            width: 50,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index) {
                                if (value == 1) {
                                    return "<img  src='img/online1.png'/>";  //onclick='hello()'
                                    
                                } else {
                                    return "<img  src='img/off.png'/>";  //onclick='hello()'
                                }
                                
                            },
                        },{
                            field: 'bz',
                            title: langs1[149][lang], //备注
                            width: 100,
                            align: 'center',
                            valign: 'middle'
                        }],
                    showExport: true, //是否显示导出
                    singleSelect: true,
                    clickToSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 10,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function (data) {  //加载成功时执行  表格加载完成时 获取集中器在线状态
                    },
                    url: 'gayway.GaywayForm.List.action',
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
                
                
            });
            
            //导入excel的添加按钮事件
            function addexcel() {
                var selects = $('#warningtable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler(langs1[350][lang]);  //请选择您要保存的数据
                    return;
                }
                addlogon(u_name, "添加", o_pid, "网关管理", "导入excel文件添加网关");
                var pid = parent.parent.getpojectId();
                for (var i = 0; i <= selects.length - 1; i++) {
                    var comaddr = selects[i].网关地址;
                    var obj = {};
                    obj.comaddr = comaddr;
                    $.ajax({async: false, url: "login.gateway.iscomaddr.action", type: "POST", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 0) {
                                var adobj = {};
                                adobj.model = "LC001";
                                adobj.comaddr = comaddr;
                                adobj.name = selects[i].名称;
                                adobj.Longitude = selects[i].经度;
                                adobj.latitude = selects[i].纬度;
                                adobj.area = selects[i].安装位置;
                                adobj.pid = pid;
                                adobj.bz = selects[i].备注;
                                //adobj.multpower = selects[i].倍率;
                                adobj.presence = 0;
                                adobj.connecttype = 0;
                                $.ajax({url: "login.gateway.addbase.action", async: false, type: "get", datatype: "JSON", data: adobj,
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length == 1) {
                                            var ids = [];//定义一个数组
                                            var xh = selects[i].序号;
                                            ids.push(xh);//将要删除的id存入数组
                                            $("#warningtable").bootstrapTable('remove', {field: '序号', values: ids});
                                        }
                                    },
                                    error: function () {
                                        alert("提交添加失败！");
                                    }
                                });
                                
                                
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    
                }
                $("#gravidaTable").bootstrapTable('refresh'); 
            }
            
            
            function checkAdd() {
                
                
                if (/^[0-9A-F]{8}$/.test($("#comaddr").val().trim()) == false) {
                    //网关地址应为八位有效十六进制字符
                    layer.alert(langs1[351][lang], {
                        icon: 6,
                        offset: 'center'
                    });
                    return false;
                }
                var obj = $("#formadd").serializeObject();
                if (obj.pid == "") {
                    layerAler("项目不能为空");
                    return false;
                }
                var namesss = false;
                $.ajax({async: false, cache: false, url: "gayway.GaywayForm.queryGateway.action", type: "GET", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            //此网关已存在
                            layer.alert(langs1[352][lang], {
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
                            obj.latitude = obj.latitude == ".." ? "" : obj.latitude;
                            obj.longitude = obj.longitude == ".." ? "" : obj.longitude;
                            obj.multpower = obj.multpower == "" ? 0 : obj.multpower;
                            console.log(obj);
                            $.ajax({async: false, cache: false, url: "gayway.GaywayForm.addGateway.action", type: "GET", data: obj,
                                success: function (data) {
                                    namesss = true;
                                    addlogon(u_name, "添加", o_pid, "网关管理", "添加网关", $("#comaddr").val().trim());
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
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;<span name="xxx" id="65">添加</span>
            </button>
            <button class="btn btn-primary ctrol" onclick="modifyModal()" id="xiugai1">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;<span name="xxx" id="66">编辑</span>
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteGateway()" id="shanchu">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;<span name="xxx" id="67">删除</span>
            </button>
            <button class="btn btn-success ctrol" onclick="excel()" id="addexcel" >
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;<span name="xxx" id="353">导入Excel</span>
            </button>
            <button type="button" id="download" id="btn_download" class="btn btn-primary" onClick ="$('#gravidaTable').tableExport({type: 'excel', escape: 'false'})">
                <span name="xxx" id="110">导出Excel</span>
            </button>
            <button class="btn btn-success ctrol" onclick="$('#wgmb').tableExport({type: 'excel', escape: 'false'})" id="addexcel" >
                <span name="xxx" id="472">导出Excel模板</span>
            </button>


        </div>
        <table id="gravidaTable" style="width:100%;">
        </table>




        <div id="dialog-add"  class="bodycenter"  style=" display: none" title="网关添加">

            <form action="" method="POST" id="formadd" onsubmit="return checkAdd()">   
                <input id="id" name="id" type="hidden">
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="354">项目列表</span>&nbsp;
                                <input id="pid" class="easyui-combobox" name="pid" style="width:150px; height: 30px" data-options="editable:false,valueField:'id', textField:'text' " />
                            </td>
                            <td>
                            </td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="357">通信方式</span>&nbsp;


                                <span class="menuBox">


                                    <select class="easyui-combobox" id="connecttype" name="connecttype" data-options='editable:false' style="width:150px; height: 30px">
                                        <option value="0" selected="true">GPRS</option>
                                        <option value="1">网线</option>    
                                        <option value="2">485</option>           
                                    </select>
                                </span>

                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:0px;" name="xxx" id="314">网关名称</span>&nbsp;
                                <input id="name" class="form-control" name="name" style="width:150px;display: inline;" placeholder="请输入集控器名称" type="text">
                            </td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="355">网关型号</span>&nbsp;


                                <span class="menuBox">

                                    <!--<input id="model" class="easyui-combobox" readonly="true" name="model" style="width:150px; height: 30px" data-options="editable:false" />-->
                                    <select class="easyui-combobox" readonly="true" id="model" name="model" style="width:150px; height: 30px">
                                        <option value="LC001">LC001</option>
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="356">安装位置</span>&nbsp;
                                <input id="setupaddr" class="form-control" name="setupaddr" style="width:150px;display: inline;" placeholder="请输入网关位置" type="text">
                            </td>

                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;
                                <input id="comaddr" class="form-control" name="comaddr" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text">
                            </td>
                        </tr>
                        <tr>
                             <td>
                                <span style="margin-left:35px;" name="xxx" id="149">备注</span>&nbsp;
                                <input id="bz" class="form-control" name="bz" style="width:150px;display: inline;" placeholder="请输入备注信息" type="text">
                            </td>

                            <td></td>
                            <td>
                               
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:35px;"name="xxx" id="59">经度</span>&nbsp;
                                <input id="longitudem26d" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="longitudem26m" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="longitudem26s" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="60">纬度</span>&nbsp;
                                <input id="latitudem26d" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="latitudem26m" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="latitudem26s" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"
                            </td>
                        </tr>

                    </tbody>
                </table>
            </form>                        
        </div>

        <div id="dialog-edit"  class="bodycenter" style=" display: none"  title="网关修改">
            <form action="" method="POST" id="form2" onsubmit="return editComplete()">  
                <table>
                    <tbody>

                        <tr>
                            <td>
                                <span style="margin-left:20px;" name="xxx" id="314">网关名称</span>&nbsp;
                                <input id="name_" class="form-control" name="name" style="width:150px;display: inline;" placeholder="请输入网关名称" type="text">
                                <input id="id_" name="id" type="hidden">
                            </td>
                            <td>

                            </td>
                            <td>
                                <span style="margin-left:25px;" name="xxx" id="355">网关型号</span>&nbsp;


                                <span class="menuBox">

                                    <!--<input id="model_" class="easyui-combobox" name="model" style="width:150px; height: 30px" data-options="editable:true,valueField:'id', textField:'text',url:'test1.f5.h2.action'" />-->
                                    <select class="easyui-combobox" readonly="true" id="model_" name="model" style="width:150px; height: 30px">
                                        <option value="LC001">LC001</option>
                                    </select>
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:30px;" name="xxx" id="356">安装位置</span>&nbsp;
                                <input id="setupaddr_" class="form-control" name="setupaddr" style="width:150px;display: inline;" placeholder="请输入网关位置" type="text">
                            </td>

                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;
                                <input id="comaddr_" readonly="true"  class="form-control" name="comaddr" style="width:150px;display: inline;" placeholder="请输入网关地址" type="text"></td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:30px;" name="xxx" id="357">通信方式</span>&nbsp;


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
                                <span style="margin-left:50px;" nane="xxx" id="149">备注</span>&nbsp;
                                <input id="bz1" class="form-control" name="bz" style="width:150px;display: inline;" placeholder="请输入备注" type="text">
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span style="margin-left:50px;"name="xxx" id="59">经度</span>&nbsp;
                                <input id="longitudem26d_" class="form-control" name="longitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="longitudem26m_" class="form-control" name="longitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="longitudem26s_" class="form-control" name="longitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                            <td></td>
                            <td>
                                <span style="margin-left:10px;" name="xxx" id="60">纬度</span>&nbsp;
                                <input id="latitudem26d_" class="form-control" name="latitudem26d" style="width:51px;display: inline;" type="text">&nbsp;°
                                <input id="latitudem26m_" class="form-control" name="latitudem26m" style="width:45px;display: inline;" type="text">&nbsp;'
                                <input id="latitudem26s_" class="form-control" name="latitudem26s" style="width:45px;display: inline;" type="text">&nbsp;"</td>
                        </tr>

                    </tbody>
                </table>
            </form>
        </div>

        <div id="dialog-excel"  class="bodycenter"  style=" display: none" title="导入Excel">
            <input type="file" id="excel-file" style=" height: 40px;">
            <table id="warningtable"></table>

        </div>

        <div class="mb">
            <table id="wgmb" style=" border: 1px">
                <tr>
                    <td>序号</td>
                    <td>名称</td>
                    <td>网关地址</td>
                    <td>经度</td>
                    <td>纬度</td>
                    <td>安装位置</td>
                    <td>备注</td>
                </tr>
                <tr>
                    <td>如1、2、3</td>
                    <td>网关名称</td>
                    <td>网地址不可重复</td>
                    <td>可以不输入</td>
                    <td>可以不输入</td>
                    <td>安装位置</td>
                    <td>可以不输入</td>
                </tr>
            </table>
        </div>




    </body>
</html>
