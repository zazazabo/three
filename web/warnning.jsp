<%-- 
    Document   : warnning
    Created on : 2018-8-6, 9:10:54
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src ="layer/layer.js"></script>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/js/select2.min.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <title>JSP Page</title>
        <style>
            table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; }
        </style>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid =  parent.parent.getpojectId();
            $(function () {
                $("#add").attr("disabled", true);
                $("#update").attr("disabled", true);
                $("#del").attr("disabled", true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {
                                if (rs[i].code == "700101" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "700102" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "700103" && rs[i].enable != 0) {
                                    $("#del").attr("disabled", false);
                                    continue;
                                }
                            }
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                //初始化select2
                $("#sel_menu1").select2();
                $("#sel_menu2").select2();
                //获取所有项目
                $.ajax({async: false, url: "login.usermanage.getProject.action", type: "get", datatype: "JSON",
                    success: function (data) {
                        $("#sel_menu2").empty();//清空下拉框
                        $.each(data, function (i, item) {
                            $("#sel_menu2").append("<option value='" + item.id + "'>&nbsp;" + item.text + "</option>");
                            $("#sel_menu1").append("<option value='" + item.id + "'>&nbsp;" + item.text + "</option>");
                        });

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                $('#gravidaTable').bootstrapTable({
                    url: 'login.warnning.queryData.action',
                    columns: [[{
                                field: '',
                                title: '告警配置',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 6
                            }],[
                            {
                                title: '单选',
                                field: 'select',
                                //复选框
                                checkbox: true,
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            },
                            {
                                field: 'u_name',
                                title: '姓名',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_phone',
                                title: '联系电话',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_email',
                                title: '邮箱',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_warntype',
                                title: '告警类型',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }, {
                                field: 'u_pid',
                                title: '管理项目',
                                width: 25,
                                align: 'center',
                                valign: 'middle'
                            }]
                    ],
                    clickToSelect: true,
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

                $("#update2").click(function () {
                    var uname = $("#updname").val();
                    var uphone = $("#updphone").val();
                    var uid = $("#updid").val();
                    var uemail = $("#updemail").val();
                    var uwarntype = $("#upd_warntype").val();
                    var upid = $("#sel_menu2").val();
                    if (uname == "") {
                        alert("用户名不能为空");
                        return;
                    }
                    if (uphone == "") {
                        alert("手机不能为空");
                        return;
                    }
                    if (uemail == "") {
                        alert("邮箱不能为空");
                        return;
                    }
                    if (uwarntype == "") {
                        alert("警告类型不能为空");
                        return;
                    }
                    if (upid == "") {
                        alert("项目不能为空");
                        return;
                    }
                    var pids = "";
                    for (var i = 0; i < upid.length; i++) {
                        if (i == upid.length - 1) {
                            pids += upid[i];
                        } else {
                            pids += upid[i] + ",";
                        }

                    }
                    addlogon(u_name, "修改", o_pid, "报警设置", "修改报警管理人员");
                    var obj = {};
                    obj.u_name = uname;
                    obj.u_phone = uphone;
                    obj.u_email = uemail;
                    obj.u_warntype = uwarntype;
                    obj.u_id = uid;
                    obj.u_pid = pids;
                    $.ajax({url: "login.warnning.update.action", async: false, type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                alert("修改成功");
                                $("#gravidaTable").bootstrapTable('refresh');
                                $("#updatetable").modal('hide');  //手动关闭
                            }
                        },
                        error: function () {
                            alert("提交添加失败！");
                        }
                    });
                });
               
            });

            function updatepeople() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length < 1) {
                    alert("请勾选要编辑的数据");
                    return;
                }
                var select = selects[0];
                $("#updname").val(select.u_name);
                $("#updphone").val(select.u_phone);
                $("#updemail").val(select.u_email);
                $("#updid").val(select.u_id);
                $("#upd_warntype").combobox('setValue', select.u_warntype);
                var pid = select.u_pid;
                var pid2 = pid.split(",");
                $('#sel_menu2').val(pid2).trigger('change');
                $("#updatetable").modal();
            }
            //添加警告配置
            function  add() {
                var phone = $("#adphone").val();
                var name = $("#adname").val();
                var email = $("#ademail").val();
                var warntype = $("#adu_warntype").val();
                var content = $("#adu_content").val();
                var pid = $("#sel_menu1").val();
                if (name == "") {
                    alert("请输入名字");
                    return;
                }
                if (phone == "") {
                    alert("请输入电话");
                    return;
                }
                if (email == "") {
                    alert("请输入Email");
                    return;
                }
                if (warntype == "") {
                    alert("请输选择警告类型");
                    return;
                }
                if (pid == "") {
                    alert("请输选择项目");
                    return;
                }
                var pids = "";
                for (var i = 0; i < pid.length; i++) {
                    if (i == pid.length - 1) {
                        pids += pid[i];
                    } else {
                        pids += pid[i] + ",";
                    }

                }
                addlogon(u_name, "添加", o_pid, "报警设置", "添加报警管理人员");
                var obj = {};
                obj.u_phone = phone;
                obj.u_name = name;
                obj.u_email = email;
                obj.u_warntype = warntype;
                obj.u_content = content;
                obj.u_pid = pids;
                $.ajax({url: "login.warnning.addpeople.action", async: false, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            alert("添加成功");
                            $("#gravidaTable").bootstrapTable('refresh');
                            $("#addtable").modal('hide');  //手动关闭
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });

            }

            //删除告警配置
            function deletepeople() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length < 1) {
                    alert("请勾选要编辑的数据");
                    return;
                }
                layer.confirm('确认要删除吗？', {
                    btn: ['确定', '取消']//按钮
                }, function (index) {
                    addlogon(u_name, "删除", o_pid, "报警设置", "删除报警管理人员");
                    var select = selects[0];
                    $.ajax({async: false, url: "login.warnning.deletepeople.action", type: "POST", datatype: "JSON", data: {u_id: select.u_id},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                $("#gravidaTable").bootstrapTable('refresh');
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    layer.close(index);
                    //此处请求后台程序，下方是成功后的前台处理……
                });

            }
        </script>
    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#addtable" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol"   onclick="updatepeople()" id="update" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deletepeople();"  id="del">
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button> 
           
        </div>
        <div class="bootstrap-table">
            <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">
                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>  
            </div>
        </div>
        <div class="modal" id="addtable" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">添加告警配置人员</h4></div>

                    <form action="" method="POST" id="Form_User" onsubmit="return checkUserAdd()">      
                        <div class="modal-body">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">名字</span>&nbsp;
                                            <input id="adname"    class="form-control"   style="width:150px;display: inline;" placeholder="请输入名字" type="text">
                                        </td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:50px;">内容</span>&nbsp;
                                            <input id="adu_content"    class="form-control"   style="width:150px;display: inline;" placeholder="请输入警告类型内容" type="text">
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">电话</span>&nbsp;
                                            <input id="adphone" class="form-control"  name="phone" style="width:150px;display: inline;" placeholder="请输入电话" type="text"></td>
                                        <td></td>
                                        <td>
                                            <span style="margin-left:20px;">警告类型</span>&nbsp;
                                            <input id="adu_warntype" class="easyui-combobox" name="u_warntype" style="width:150px; height: 34px" data-options="editable:true,valueField:'w_id', textField:'w_name',url:'login.warnning.warntype.action'"/>
                                        </td>
                                    </tr> 
                                    <tr>
                                        <td>
                                            <span style="margin-left:20px;">邮箱&nbsp;</span>
                                            <input id="ademail" class="form-control" name="email" style="width:150px;display: inline;" placeholder="请输入邮箱" type="text">
                                        </td>
                                        <td></td>
                                    </tr> 
                                    <tr>                                
                                        <td colspan='3' >
                                            <span style="margin-left:20px;">项目&nbsp;</span>
                                            <select id="sel_menu1" multiple="multiple" style="width: 360px;">

                                            </select>
                                        </td>
                                    </tr>


                                </tbody>
                            </table>
                        </div>
                        <!-- 注脚 -->
                        <div class="modal-footer">
                            <!-- 添加按钮 -->
                            <button id="tianjia1" type="button" class="btn btn-primary" onclick="add()">添加</button>
                            <!-- 关闭按钮 -->
                            <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                    </form>
                </div>
            </div>
        </div>
        <div class="modal" id="updatetable" data-backdrop="static">
            <div class="modal-dialog">
                <div class="modal-content" style="min-width:700px;">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span style="font-size:20px ">×</span></button>
                        <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                        <h4 class="modal-title" style="display: inline;">修改告警配置人员信息</h4></div>   
                    <div class="modal-body">
                        <input type="hidden" id="updid" name="id" />
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">名字</span>&nbsp;
                                        <input id="updname"    class="form-control"  name="name" style="width:150px;display: inline;" placeholder="请输入名字" type="text">
                                    </td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:20px;">警告类型</span>&nbsp;
                                        <input id="upd_warntype" class="easyui-combobox"  style="width:150px; height: 34px" data-options="editable:true,valueField:'w_id', textField:'w_name',url:'login.warnning.warntype.action'">
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">电话</span>&nbsp;
                                        <input id="updphone" class="form-control"  style="width:150px;display: inline;" placeholder="请输入电话" type="text">
                                    </td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:48px;">邮箱&nbsp;</span>
                                        <input id="updemail" class="form-control"  style="width:175px;display: inline;" placeholder="请输入邮箱" type="text">
                                    </td>
                                </tr>   
                                <tr>                                
                                    <td colspan='3' >
                                        <span style="margin-left:20px;">项目&nbsp;</span>
                                        <select id="sel_menu2" multiple="multiple" style="width: 360px;">

                                        </select>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer">
                        <!-- 修改按钮 -->
                        <button id="update2" type="button" class="btn btn-success">修改</button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button></div>
                </div>
            </div>
        </div>



    </body>
</html>
