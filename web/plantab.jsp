<%-- 
    Document   : plantab
    Created on : 2018-7-20, 0:44:46
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <script src="select2-developr/dist/js/select2.js"></script>
        <link href="select2-develop/dist/css/select2.css" rel="stylesheet" />



        <link rel="stylesheet" type="text/css" href="gatewayconfig_files/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="gatewayconfig_files/bootstrap-table.css">
        <script type="text/javascript" src="gatewayconfig_files/jquery.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap-table.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap-table-zh-CN.js"></script>
        <link type="text/css" href="gatewayconfig_files/basicInformation.css" rel="stylesheet">
        <!-- easyui -->
        <link href="gatewayconfig_files/easyui.css" rel="stylesheet" type="text/css" switch="switch-style">
        <link href="gatewayconfig_files/icon.css" rel="stylesheet" type="text/css">
        <script src="gatewayconfig_files/jquery_002.js" type="text/javascript"></script>
        <script src="gatewayconfig_files/easyui-lang-zh_CN.js" type="text/javascript"></script>
        <script type="text/javascript" src="gatewayconfig_files/selectAjaxFunction.js"></script>
        <script type="text/javascript" src="gatewayconfig_files/bootstrap-multiselect.js"></script>
        <link rel="stylesheet" href="gatewayconfig_files/bootstrap-multiselect.css" type="text/css">
        <link rel="stylesheet" type="text/css" href="gatewayconfig_files/layer.css">
        <script type="text/javascript" src="gatewayconfig_files/layer.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>

        <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
        <link rel="stylesheet" href="./bootstrap-tab/css/bootstrap-tab.css">
        <script src="./bootstrap-tab/js/bootstrap-tab.js"></script>
        <script>
            $(function () {
                $("#tabContainer").tabs({
                    data: [{
                            id: 'LOOP',
                            text: '回路方案',
                            url: "loopplan.jsp"
                        }, {
                            id: 'LAMP',
                            text: '灯具方案',
                            url: "lampplan.jsp"
                        }],
                    showIndex: 0,
                    loadAll: false
                })
            })
        </script>
    </head>
    <body>
        <div id="tabContainer"></div>
    </body>
</html>
