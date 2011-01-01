<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/md5.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>

        <link rel="stylesheet" href="ztree/css/bootstrapStyle/bootstrapStyle.css" type="text/css">

        <!--<script type="text/javascript" src="ztree/js/jquery.min.js"></script>-->
        <script type="text/javascript" src="ztree/js/jquery.ztree.core.js"></script>
        <script type="text/javascript" src="ztree/js/jquery.ztree.excheck.js"></script>
        <script type="text/javascript" src="ztree/js/jquery.ztree.exedit.js"></script> 
        <script type="text/javascript"  src="js/getdate.js"></script>
        <title>JSP Page</title>

        <style>* { margin: 0; padding: 0; } body, html { width: 100%; height: 100%; } .zuheanniu { margin-top: 2px; margin-left: 10px; } table { font-size: 14px; } .modal-body input[type="text"], .modal-body select, .modal-body input[type="radio"] { height: 30px; } .modal-body table td { line-height: 40px; } .menuBox { position: relative; background: skyblue; } .getMenu { z-index: 1000; display: none; background: white; list-style: none; border: 1px solid skyblue; width: 150px; height: auto; max-height: 200px; position: absolute; left: 0; top: 25px; overflow: auto; } .getMenu li { width: 148px; padding-left: 10px; line-height: 22px; font-size: 14px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; } .getMenu li:hover { background: #eee; cursor: pointer; } .a-upload { padding: 4px 10px; height: 30px; line-height: 20px; position: relative; cursor: pointer; color: #888; background: #fafafa; border: 1px solid #ddd; border-radius: 4px; overflow: hidden; display: inline-block; *display: inline; *zoom: 1 } .a-upload input { position: absolute; font-size: 100px; right: 0; top: 0; opacity: 0; filter: alpha(opacity = 0); cursor: pointer } .a-upload:hover { color: #444; background: #eee; border-color: #ccc; text-decoration: none } .pagination-info { float: left; margin-top: -4px; } .modal-body { text-align: -webkit-center; text-align: -moz-center; width: 600px; margin: auto; } .btn-primary { color: #fff; background-color: #0099CC; border-color: #0099CC; }
        </style>

        <style type="text/css">
            div#rMenu {position:absolute; visibility:hidden; top:0; text-align: left;padding:4px;}
            div#rMenu a{
                padding: 3px 15px 3px 15px;
                background-color:#cad4e6;
                vertical-align:middle;
            }
        </style>




        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            //添加角色
            function addrole() {
                addlogon(u_name, "添加", o_pid, "角色权限管理", "添加角色");
                var name = $("#rolename").val();
                if (name == "") {
                    layerAler("角色名不能为空");
                    return;
                }
                $.ajax({async: false, url: "login.rolemanage.getrole.action", type: "POST", datatype: "JSON", data: {roletype: ${param.role}, name: name, enable: 1},
                    success: function (data) {
                        console.log(data);
                        if (data != null) {
                            var rsname = data.rsname;
                            if (rsname.length > 0) {
                                layerAler("此角色已存在");
                                return;
                            }
                            var list = data.rs;
                            for (var i = 0; i < list.length; i++) {
                                var role = ${param.role}; //当前登陆的用户角色Id
                                var obj = list[i];
                                obj.enable = 0;
                                obj.roletype = parseInt(data.rsmax[0].maxtype) + 1;
                                obj.name = name;
                                obj.parent_id = role;
                                $.ajax({async: false, url: "login.rolemanage.addrole.action", type: "get", datatype: "JSON", data: obj,
                                    success: function (data) {
                                        //console.log(data);
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });

                            }
                            alert("添加成功！");
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }

            function getIdSelections() {
                return $.map($("#gravidaTable").bootstrapTable('getSelections'), function (row) {
                    return row.id
                });
            }
// 在ztree上的右击事件
            function OnRightClick(event, treeId, treeNode) {
                var curName = "";
                if (treeNode == null) {
                    var a = 1; // 什么都不做
                } else if (treeNode && treeNode.name) {
                    curName = treeNode.name;
                    //&& treeNode.isParent == false
                    if (treeNode.checked == true) {
                        //再判断是否为父节点
                        if (treeNode.isParent) {
                            $("#isParent").val("1");
                        } else {
                            $("#isParent").val("2");
                        }
                        //将当前点击的节点id存起来
                        $("#treeid").val(treeNode.id);
                        showRMenu("root", event.clientX, event.clientY);
                    }
                } else {
                    curName = undefined;
                }
            }
//显示右键菜单
            function showRMenu(type, x, y) {
                $("#rMenu ul").show();
                var rMenu = $("#rMenu");
                rMenu.css({"top": y + "px", "left": x + "px", "visibility": "visible"}); //设置右键菜单的位置、可见              
                $("body").bind("mousedown", onBodyMouseDown);
            }
//隐藏右键菜单
            function hideRMenu() {
                var rMenu = $("#rMenu");

                if (rMenu)
                    rMenu.css({"visibility": "hidden"}); //设置右键菜单不可见
                $("body").unbind("mousedown", onBodyMouseDown);
            }
//鼠标按下事件
            function onBodyMouseDown(event) {
                var rMenu = $("#rMenu");
                if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0)) {
                    rMenu.css({"visibility": "hidden"});
                } else {
                    if (event.target.name = "cancel") {
                        var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                        var id = $("#treeid").val();
                        var node = zTreeOjb.getNodeByParam("id", id);
                        if (node.checked == true) {

                            layer.confirm('确认要取消权限吗？', {
                                btn: ['确定', '取消']//按钮
                            }, function (index) {
                                layer.close(index);
                                var role = $("#role").val();
                                var isparent = $("#isParent").val();
                                if (role == "") {
                                    layerAler("请选择要取消权限的角色");
                                    return;
                                }
                                addlogon(u_name, "取消权限", o_pid, "角色权限管理", "取消角色权限");
                                var iscodeobj = {};
                                iscodeobj.code = id;
                                iscodeobj.roletype = role;
                                //判断是否拥有该权限
                                var isok = false;
                                $.ajax({async: false, url: "login.rolemanage.iscode.action", type: "get", datatype: "JSON", data: iscodeobj,
                                    success: function (data) {
                                        if (data.rs.length > 0) {
                                            isok = true;
                                        } else {
                                            layerAler("该角色不拥有该权限");
                                        }
                                        freshenTree(role);
                                    },
                                    error: function () {
                                        alert("提交失败！");
                                    }
                                });
                                if (isok) {
                                    //选中父节点
                                    if (isparent == "1") {
                                        var obj = {};
                                        obj.code = id;
                                        obj.roletype = role;
                                        $.ajax({async: false, url: "login.rolemanage.updateMrole.action", type: "get", datatype: "JSON", data: obj,
                                            success: function (data) {
                                                if (data.rs.length > 0) {
                                                    layerAler("取消成功");
                                                } else {
                                                    layerAler("取消失败");
                                                }
                                                freshenTree(role);
                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                    } else if (isparent == "2") { //选中子节点
                                        var obj = {};
                                        obj.code = id;
                                        obj.roletype = role;
                                        $.ajax({async: false, url: "login.rolemanage.updaterole.action", type: "get", datatype: "JSON", data: obj,
                                            success: function (data) {
                                                if (data.rs.length > 0) {
                                                    layerAler("取消成功");
                                                } else {
                                                    layerAler("取消失败");
                                                }
                                                freshenTree(role);
                                            },
                                            error: function () {
                                                alert("提交失败！");
                                            }
                                        });
                                    }
                                }
                                $("#isParent").val("");
                                $("#treeid").val("");
                            });


                            // layerAler("取消息当明操作的节点");
                        }
                        rMenu.css({"visibility": "hidden"});
                    }
                }


            }


            function addauthor() {
                var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                var nodes = zTreeOjb.getCheckedNodes();
                var roletype = $("#role").combobox('getValue');
                var name = $("#role").combobox('getText');

                if ($("#role").val() == "") {
                    layerAler("请选择要分配权限的角色");
                    return;
                }
                if (nodes.length == 0) {
                    layerAler("请勾选菜单列表");
                    return;
                }

                //console.log(nodes);
                layer.confirm('确认要分配权限吗？', {
                    btn: ['确定', '取消']//按钮
                }, function (index) {

                    addlogon(u_name, "分配权限权限", o_pid, "角色权限管理", "分配权限");
                    for (var i = 0; i < nodes.length; i++) {
                        if (nodes[i].id == "0") {
                            continue;
                        }
                        var obj1 = {};
                        obj1.enable = 1;
                        obj1.name = name;
                        obj1.code = nodes[i].id;
                        obj1.roletype = roletype;
                        //console.log(obj1);
                        $.ajax({async: false, url: "login.rolemanage.getpower.action", type: "POST", datatype: "JSON", data: obj1,
                            success: function (data) {
                                //console.log(data);
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                    }
                    layerAler("权限分配成功！");
                    layer.close(index);
                });
            }


            $(function () {
                var obj = {};
                obj.roletype = ${param.role};
                var zNodes = [
                ];
                var lang = "zh_CN";
                $.ajax({async: false, url: "login.rolemanage.queryZtree.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        for (var i = 0; i < data.length; i++) {
//                            console.log(data[i]);
                            var obj1 = eval('(' + data[i].name + ')');
//                            console.log(obj1);
                            data[i].name = obj1[lang];
                        }
                        var obj2 = {id: "0", pId: 0, name: "菜单目录", open: true};
                        data.push(obj2);
                        zNodes = data;
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                var setting = {
                    callback: {
                        onRightClick: OnRightClick
                    },
                    check: {
                        enable: true
                    },
                    data: {
                        simpleData: {
                            enable: true
                        }
                    }
                };
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);

                $("#btnauthor").show(true);



            })

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }


            $(function () {
                $('#role').combobox({
                    onSelect: function (record) {
                        var objrole = {role: record.id};
                        $.ajax({type: "post", url: "formuser.mainmenu.querysub.action", dataType: "json", data: objrole,
                            success: function (datas) {
                                //console.log(datas);
                                var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                                zTreeOjb.checkAllNodes(false);
                                datas.forEach(function (data) {
                                    //console.log(data);
                                    var m_code = data.m_code;
                                    var node = zTreeOjb.getNodeByParam("id", m_code);
                                    zTreeOjb.checkNode(node, true, false);
                                    zTreeOjb.updateNode(node);
                                });
                            }
                        });
                    }
                });
            })
            //修改权限后刷新权限树形图
            function  freshenTree(roleid) {
                var objrole = {role: roleid};
                $.ajax({type: "post", url: "formuser.mainmenu.querysub.action", dataType: "json", data: objrole,
                    success: function (datas) {
                        //console.log(datas);
                        var zTreeOjb = $.fn.zTree.getZTreeObj("treeDemo");
                        zTreeOjb.checkAllNodes(false);
                        datas.forEach(function (data) {
                            //console.log(data);
                            var m_code = data.m_code;
                            var node = zTreeOjb.getNodeByParam("id", m_code);
                            zTreeOjb.checkNode(node, true, false);
                            zTreeOjb.updateNode(node);
                        });
                    }
                });
            }

        </script>

    </head>
    <body>

        <div class="panel panel-success" >
            <div class="panel-heading">
                <h3 class="panel-title">权限分配</h3>
            </div>
            <div class="panel-body" >
                <div class="container"  >
                    <div class="row">
                        <div class="col-xs-3">
                            <ul id="treeDemo" class="ztree"></ul>
                        </div>
                        <div class="col-xs-2" style="  align-items: center">
                            <div id="btnauthor" style=" display: none;" >

                                <button class="btn btn-success" onclick="addauthor()" style="  margin-top: 20px">分配权限</button>

                            </div>

                        </div>

                        <div class="col-xs-3" style=" width: 20%;">
                            <span class="label label-success label-lg " style=" width: 30%;">角色列表</span>
                            <input id="role" class="easyui-combobox" name="role" style="width:60%; height: 34px" data-options="editable:true,valueField:'id', textField:'text',url:'login.usermanage.rolemenu.action?parent_id=${param.role}'" />
                        </div>
                        <div class="col-xs-4" style=" width: 33%; margin-left: 5%;">
                            <span style=" width: 30%;">角色名称</span>&nbsp;
                            <input id="rolename" class="form-control" name="rolename" style="width:40%;display: inline;" placeholder="请输入角色名称" type="text">
                            <button id="btnrole" onclick="addrole()" class="btn btn-success" style=" width: 30%;">生成角色</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="rMenu">
            <input id="treeid" type="hidden" value="" />
            <input id="isParent" type="hidden" value="" />
            <a href="#" class="list-group-item" type="m_expand" name="cancel" >取消权限</a>
        </div>

    </body>
</html>
