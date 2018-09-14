<%-- 
    Document   : oplog
    Created on : 2018-9-13, 17:50:48
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>操作日志</title>
        <script>
            $(function(){
                 $('#oplogtabel').bootstrapTable({
                    url: 'login.oplog.oplogInfo.action',
                    columns: [
                        {
                            field: 'o_name',
                            title: '用户名',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'o_time',
                            title: '时间',
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'o_comment',
                            title: '操作内容',
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
                    pageSize: 10,
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
            });
        </script>
    </head>
    
    <body>
         <div style="float:left;position:relative;z-index:100;margin:12px 0 20px 50px; font-size: 18px">
            <span>搜索时间：<input type="date" id="startime"/></span>
            <span style="margin-left: 10px">至：<input type="date" id="endtime"/></span>
            <span><input type="button" class="btn btn-sm btn-success" value="查询" id="select"></span>
        </div>
        <div>
            <table id="oplogtabel">

            </table>
        </div>
    </body>
</html>