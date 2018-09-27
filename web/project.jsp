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
        <script type="text/javascript" src="js/md5.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
        <title>JSP Page</title>

        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>


        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var uid = parent.parent.getuserId();
            $(function () {
                $("#add").attr("disabled", true);
                $("#del").attr("disabled", true);
                $("#update").attr(":disabled",true);
                var obj = {};
                obj.code = ${param.m_parent};
                obj.roletype = ${param.role};
                $.ajax({async: false, url: "login.usermanage.power.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            for (var i = 0; i < rs.length; i++) {

                                if (rs[i].code == "800301" && rs[i].enable != 0) {
                                    $("#add").attr("disabled", false);
                                    continue;
                                }
                                if (rs[i].code == "800302" && rs[i].enable != 0) {
                                    $("#del").attr("disabled", false);
                                    continue;
                                }
                                 if (rs[i].code == "800303" && rs[i].enable != 0) {
                                    $("#update").attr("disabled", false);
                                    continue;
                                }
                            }
                        }

                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                $('#gravidaTable').bootstrapTable({
                    url: 'login.project.queryProject.action',
                    columns: [
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
                            field: 'name',
                            title: '项目名称',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'area',
                            title: '项目地址',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }],
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
            })

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function  checkProjectAdd() {
                var obj = $("#Form_User").serializeObject();
                if (obj.name == "") {
                    layerAler("项目不能为空");
                    return false;
                }
                console.log(obj);
                addlogon(u_name, "添加", o_pid, "项目管理", "添加项目");
                var isflesh = false;
                $.ajax({url: "login.project.queryProject.action", async: false, type: "POST", datatype: "JSON", data: obj,
                    success: function (data) {
                        if (data.total == 0) {
                            $.ajax({async: false, url: "login.project.addProject.action", type: "get", datatype: "JSON", data: obj,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        $.ajax({async: false, url: "login.project.selectlatcode.action", type: "get", datatype: "JSON", data: {},
                                            success: function (data) {
                                                var newcode;
                                                var code = data.codes;

                                                if (code.length == 1) {
                                                    newcode = code[0].code;
                                                    var pidobj = {};
                                                    pidobj.id = uid;
                                                    pidobj.npid = "," + newcode;
                                                    $.ajax({async: false, url: "login.project.addpid.action", type: "get", datatype: "JSON", data: pidobj,
                                                        success: function (data) {

                                                        },
                                                        error: function () {
                                                            alert("提交失败！");
                                                        }
                                                    });
                                                    var pobj = {};
                                                    pobj.id = uid;
                                                    var parentid = 0;
                                                    do {

                                                        $.ajax({async: false, url: "login.project.selectparent.action", type: "get", datatype: "JSON", data: pobj,
                                                            success: function (data) {
                                                                var parentid = data.ups;
                                                                parentid = parentid[0].u_parent_id;
                                                                if (parentid != 0) {
                                                                    var ppobj = {};
                                                                    ppobj.id = parentid;
                                                                    ppobj.npid = "," + newcode;
                                                                    $.ajax({async: false, url: "login.project.addpid.action", type: "get", datatype: "JSON", data: ppobj,
                                                                        success: function (data) {

                                                                        },
                                                                        error: function () {
                                                                            alert("提交失败！");
                                                                        }
                                                                    });
                                                                }
                                                            }
                                                        });
                                                    } while (parentid != 0);
                                                }

                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                        $("#gravidaTable").bootstrapTable('refresh');
                                    }
                                    isflesh = true;
                                },
                                error: function () {
                                    alert("提交失败！");
                                }
                            });



                        } else if (data.total > 0) {
                            layerAler("此项目已存在");
                        }
                        return  false;
//                        var arrlist = data.rs;
//                        if (arrlist.length == 1) {
//                            isflesh = true;
////                            $("#gravidaTable").bootstrapTable('refresh');
//                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });
                return isflesh;
            }

            //编辑
            function editporject() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请选择您要编辑的项目");
                    return;
                }
                $("#pname").val(selects[0].name);
                $("#parea").val(selects[0].area);
                $("#p_id").val(selects[0].id);
                $("#pjj2").modal();
            }

            function update() {
                addlogon(u_name, "修改", o_pid, "项目管理", "修改项目信息");
                var obj = {};
                obj.area = $("#parea").val();
                obj.id = $("#p_id").val();
                $.ajax({async: false, url: "login.project.updProject.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            $("#gravidaTable").bootstrapTable('refresh');
                            $("#pjj2").modal('hide'); //手动关闭
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
            //删除
            function deleteUser() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                var num = selects.length;
                if (num == 0) {
                    layerAler("请选择您要删除的记录");
                    return;
                }
                layer.confirm('确认要删除吗？', {
                    btn: ['确定', '取消']//按钮
                }, function (index) {
                    addlogon(u_name, "删除", o_pid, "项目管理", "删除项目");
                    $.ajax({async: false, url: "login.project.getbase.action", type: "POST", datatype: "JSON", data: {pid: selects[0].code},
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length > 0) {
                                layerAler("该项目下存在网关，不可删除");
                            } else {
                                alert("0");
                                $.ajax({async: false, url: "login.delete.action", type: "POST", datatype: "JSON", data: {id: selects[0].id},
                                    success: function (data) {
                                        var arrlist = data.rs;
                                        if (arrlist.length > 0) {
                                            $("#gravidaTable").bootstrapTable('refresh');
                                        } else {

                                        }
                                    },
                                    error: function () {
                                        layerAler("提交失败");
                                    }
                                });
                            }
                        },
                        error: function () {
                            layerAler("提交失败");
                        }
                    });
                    layer.close(index);

                });
            }




        </script>

    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj" id="add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol"   onclick="editporject()"  id="update">
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteUser();" id="del" >
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button> 
        </div>

        <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped"></table>  


    </div>



    <!-- 添加 -->
    <div class="modal" id="pjj">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width:700px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span style="font-size:20px ">×</span></button>
                    <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                    <h4 class="modal-title" style="display: inline;">添加项目</h4></div>

                <form action="" method="POST" id="Form_User" onsubmit="return checkProjectAdd()">      
                    <div class="modal-body">
                        <table>
                            <tbody>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">项目名称</span>&nbsp;
                                        <input id="name"    class="form-control"  name="name" style="width:150px;display: inline;" placeholder="项目名称" type="text">
                                    </td>

                                    <td></td>
                                </tr>                                

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">项目地址</span>&nbsp;
                                        <input id="area"    class="form-control"  name="area" style="width:150px;display: inline;" placeholder="区域" type="text">
                                    </td>
                                    <td></td>
                                    <td>

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

    <!--编辑-->
    <div class="modal" id="pjj2">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width:700px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span style="font-size:20px ">×</span></button>
                    <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                    <h4 class="modal-title" style="display: inline;">修改项目</h4></div>
                <div class="modal-body">
                    <input type="hidden" id="p_id" name="id" />
                    <table>
                        <tbody>

                            <tr>
                                <td>
                                    <span style="margin-left:20px;">项目名称</span>&nbsp;
                                    <input id="pname"    class="form-control"  name="name" style="width:150px;display: inline; " readonly="readonly" type="text">
                                </td>

                                <td></td>
                            </tr>                                

                            <tr>
                                <td>
                                    <span style="margin-left:20px;">项目地址</span>&nbsp;
                                    <input id="parea"    class="form-control"  name="area" style="width:150px;display: inline;" placeholder="区域" type="text">
                                </td>
                                <td></td>
                                <td>

                                </td>
                            </tr>

                        </tbody>
                    </table>
                </div>
                <!-- 注脚 -->
                <div class="modal-footer">
                    <!-- 添加按钮 -->
                    <button id="tianjia1" type="button" class="btn btn-primary" onclick="update()">修改</button>
                    <!-- 关闭按钮 -->
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                </div>
            </div>
        </div>
    </div>




</body>
</html>
