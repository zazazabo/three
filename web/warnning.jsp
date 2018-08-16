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
        <title>JSP Page</title>
        <script>
            $(function () {
                $('#gravidaTable').bootstrapTable({
                    url: 'formuser.warn.queryData.action',
                    columns: [[{
                                field: '',
                                title: '告警配置',
                                width: 25,
                                align: 'center',
                                valign: 'middle',
                                colspan: 4
                            }], [
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
            })
        </script>
    </head>
    <body>

        <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
            <button class="btn btn-success ctrol" data-toggle="modal" data-target="#modal_add">
                <span class="glyphicon glyphicon-plus-sign"></span>&nbsp;添加
            </button>
            <button class="btn btn-primary ctrol"   onclick="editlampplan()" >
                <span class="glyphicon glyphicon-pencil"></span>&nbsp;编辑
            </button>
            <button class="btn btn-danger ctrol" onclick="deletelampplan();" >
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


</body>
</html>
