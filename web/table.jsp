<%-- 
    Document   : table
    Created on : 2018-9-12, 0:15:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <!--<script type="text/javascript" src="bootstrap-table/src/extensions/export/bootstrap-table-export.js"></script>-->
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <!--<script type="text/javascript" src="tableExport.jquery.plugin/tableExport.js"></script>-->
        <script>


//            $(function () {
//                $('#toolbar').find('select').change(function () {
//                    $('#gravidaTable').bootstrapTable('refreshOptions', {
//                        exportDataType: $(this).val()
//                    });
//                });
//            })







//
//            function detailFormatter(index, row) {
//                var html = [];
//                $.each(row, function (key, value) {
//                    html.push('<p><b>' + key + ':</b> ' + value + '</p>');
//                });
//                return html.join('');
//            }
//
//            function DoOnCellHtmlData(cell, row, col, data) {
//                var result = "";
//                if (typeof data != 'undefined' && data != "") {
//                    var html = $.parseHTML(data);
//
//                    $.each(html, function () {
//                        if (typeof $(this).html() === 'undefined')
//                            result += $(this).text();
//                        else if (typeof $(this).attr('class') === 'undefined' || $(this).hasClass('th-inner') === true)
//                            result += $(this).html();
//                    });
//                }
//                return result;
//            }

//            $(function () {
//                $('#toolbar').find('select').change(function () {
//                    $('#table').bootstrapTable('refreshOptions', {
//                        exportDataType: $(this).val()
//                    });
//                });
//            })







            $(document).ready(function ()
            {

//                $('#gravidaTable').bootstrapTable('refreshOptions', {
//                    exportOptions: {ignoreColumn: [0, 1], // or as string array: ['0','checkbox']
//                        onCellHtmlData: DoOnCellHtmlData}
//                });
            });

            var colums = [{
                    title: '单选',
                    field: 'select',
                    checkbox: true,
                    width: 25,
                    align: 'center',
                    valign: 'middle'
                }, {
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
                }, {
                    field: 'pid',
                    title: '所属项目',
                    width: 25,
                    align: 'center',
                    valign: 'middle'
                }]

            $(function () {
                $('#gravidaTable').bootstrapTable({
                    url: 'formuser.user.query.action',
                    columns: colums,
                    clickToSelect: true,
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    showExport: true, //是否显示导出
                    exportDataType: "all", //basic', 'a
                    pageNumber: 1,
                    pageSize: 5,
                    togglePagination: true,
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
                            page: "ALL",
                            type_id: "1"    
                        };      
                        return temp;  
                    },
                });

//                 $('#gravidaTable').bootstrapTable('togglePagination');

            })
        </script>
    </head>
    <body>
        <button type="button" id="download" style="margin-left:50px" id="btn_download" class="btn btn-primary" onClick ="$('#tb_departments').tableExport({type: 'excel', escape: 'false'})">数据导出</button>
        <div id="toolbar">
            <select class="form-control">
                <option value="">Export Basic</option>
                <option value="all">Export All</option>
                <option value="selected">Export Selected</option>
            </select>
        </div>
        <table id="gravidaTable" style="width:100%;" >
        </table>  
    </body>
</html>
