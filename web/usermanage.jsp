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
        <title>JSP Page</title>

        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }</style>


        <script>
            $(function () {
                $('#gravidaTable').bootstrapTable({
                    url: 'formuser.user.query.action',
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
                            title: '姓名',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'department',
                            title: '部门',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'phone',
                            title: '联系电话',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'sex',
                            title: '性别',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'email',
                            title: '邮箱',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }],
                    clickToSelect: true,
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

            function  checkUserAdd() {
                var obj = $("#Form_User").serializeObject();
                if (obj.name == "") {
                    layerAler("用户名不能为空");
                    return false;
                }

                obj.password = hex_md5("123");
                var isflesh = false;
                $.ajax({url: "formuser.user.addUser.action", async: false, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            isflesh = true;
//                            $("#gravidaTable").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });
                return isflesh;
            }

            function edituser() {
                var selects = $('#gravidaTable').bootstrapTable('getSelections');
                if (selects.length <= 0) {
                    layerAler("请选择数据编辑");
                    return;
                }
                var select = selects[0];
                console.log(select);
                $("#name_edit").val(select.name);
                $("#sex_edit").val(select.sex);
                $("#department_edit").val(select.department);
                $("#email_edit").val(select.email);
                $("#phone_edit").val(select.phone);
                $("#id").val(select.id);
                $("#pjj2").modal();
            }

            function editaction() {
                var formobj = $("#Form_Edit").serializeObject();
                formobj.email = formobj.email_edit;
                formobj.department = formobj.department_edit;
                formobj.name = formobj.name_edit;
                formobj.phone = formobj.phone_edit;
                formobj.sex = formobj.sex_edit;

                $.ajax({url: "formuser.user.editUser.action", async: false, type: "get", datatype: "JSON", data: formobj,
                    success: function (data) {
                        var arrlist = data.rs;
                        if (arrlist.length == 1) {
                            $("#gravidaTable").bootstrapTable('refresh');
                        }
                    },
                    error: function () {
                        alert("提交添加失败！");
                    }
                });
            }

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

                    for (var i = 0; i < num; i++) {
                        var select = selects[i];
                        $.ajax({async: false, url: "formuser.user.deleteUser.action", type: "POST", datatype: "JSON", data: {id: select.id},
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

                    }
                    layer.close(index);
                    //此处请求后台程序，下方是成功后的前台处理……
                });
            }




        </script>

    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#pjj">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol"   onclick="edituser()" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deleteUser();" >
                <span class="glyphicon glyphicon-trash"></span>&nbsp;删除
            </button> 
        </div>
        <div class="bootstrap-table">
            <div class="fixed-table-container" style="height: 350px; padding-bottom: 0px;">
                <table id="gravidaTable" style="width:100%;" class="text-nowrap table table-hover table-striped">
                </table>  
            </div>
        </div>
    </div>



    <!-- 添加 -->
    <div class="modal" id="pjj">
        <div class="modal-dialog">
            <div class="modal-content" style="min-width:700px;">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span style="font-size:20px ">×</span></button>
                    <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
                    <h4 class="modal-title" style="display: inline;">添加用户</h4></div>

                <form action="" method="POST" id="Form_User" onsubmit="return checkUserAdd()">      
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">名字</span>&nbsp;
                                        <input id="name"    class="form-control"  name="name" style="width:150px;display: inline;" placeholder="请输入名字" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">姓别&nbsp;</span>
                                        <span class="menuBox">
                                            <select name="sex" id="sex"  style="width:150px;">
                                                <option value="男">男</option>
                                                <option value="女">女</option>
                                            </select>
                                        </span>    
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">电话</span>&nbsp;
                                        <input id="phone" class="form-control"  name="phone" style="width:150px;display: inline;" placeholder="请输入电话" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">邮箱&nbsp;</span>
                                        <input id="email" class="form-control" name="email" style="width:150px;display: inline;" placeholder="请输入邮箱" type="text"></td>
                                    </td>
                                </tr>                                   

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">部门</span>&nbsp;
                                        <input id="department" class="form-control"  name="department" style="width:150px;display: inline;" placeholder="请输入电话" type="text"></td>
                                    <td></td>
                                    <td>
                                        <!--                                        <span style="margin-left:10px;">项目&nbsp;</span>
                                                                                <input id="project" class="form-control" name="project" style="width:150px;display: inline;" placeholder="请输入邮箱" type="text"></td>-->
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
                    <h4 class="modal-title" style="display: inline;">修改灯具配置</h4></div>
                <form action="" method="POST" id="Form_Edit" onsubmit="return checkLampModify()">     
                    <input type="hidden" id="id" name="id" />
                    <div class="modal-body">
                        <table>
                            <tbody>
                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">名字</span>&nbsp;
                                        <input id="name_edit" readonly="true"   class="form-control"  name="name_edit" style="width:150px;display: inline;" placeholder="请输入名字" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">姓别&nbsp;</span>
                                        <span class="menuBox">
                                            <select name="sex_edit" id="sex_edit"  style="width:150px;">
                                                <option value="男">男</option>
                                                <option value="女">女</option>
                                            </select>
                                        </span>    
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">电话</span>&nbsp;
                                        <input id="phone_edit" class="form-control"  name="phone_edit" style="width:150px;display: inline;" placeholder="请输入电话" type="text"></td>
                                    <td></td>
                                    <td>
                                        <span style="margin-left:10px;">邮箱&nbsp;</span>
                                        <input id="email_edit" class="form-control" name="email_edit" style="width:150px;display: inline;" placeholder="请输入邮箱" type="text"></td>
                                    </td>
                                </tr>                                   

                                <tr>
                                    <td>
                                        <span style="margin-left:20px;">部门</span>&nbsp;
                                        <input id="department_edit" class="form-control"  name="department_edit" style="width:150px;display: inline;" placeholder="请输入电话" type="text"></td>
                                    <td></td>
                                    <td>
                                    </td>
                                </tr>                               


                            </tbody>
                        </table>
                    </div>
                    <!-- 注脚 -->
                    <div class="modal-footer" id="modal_footer_edit" >
                        <!-- 添加按钮 -->
                        <button id="xiugai" type="button" onclick="editaction()" class="btn btn-primary">修改</button>
                        <!-- 关闭按钮 -->
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </form>
            </div>
        </div>
    </div>




</body>
</html>
