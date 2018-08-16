<%-- 
    Document   : newjsp4
    Created on : 2018-6-22, 10:17:53
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">  
        <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
        <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
   
        <style>
            .tabs ul {
                /* border-bottom: 3px solid #39aef5!important;*/
            }
            .tabs ul li:not(:first-child){
                padding-right:15px!important;

            }
            .tabs ul li{
                border-top:1px solid #ccc!important;
                border-left:1px solid #ccc!important;
                /*border-bottom: 1px solid #39aef5!important;*/
            }
            .tabs ul li a{
                color:#666!important;
            }
            .tabs ul li span:hover{
                color:#C61010!important;
            }
            .tabs ul li a:hover,
            .tabs ul li:hover,
            .tabs ul li:focus{
                border-bottom: 0!important;
            }
            .tabs ul li:last-child{
                border-right:1px solid #ccc!important;
            }
            .tabs ul li.ui-state-active.ui-tabs-active a,
            .tabs ul li.ui-state-active.ui-tabs-active span,
            .tabs ul li.ui-state-active.ui-tabs-active{
                /*border-top:3px solid red!important;*/
                background: #39aef5!important;
                border-bottom: 2px solid #39aef5!important;
                color:#ddd!important;
            }
            .tabs ul li.ui-state-active.ui-tabs-active a:hover,
            .tabs ul li.ui-state-active.ui-tabs-active span:hover
            {
                color:#fff!important;
            }
            .tabs ul li .fa-times-circle{
                position: absolute;
                top: 10px;
                right:18px;
            }
        </style>
        <title>JSP Page</title>
    </head>
    <body>

        <ul class="menu">
            <li id="menu1">
                <a href="#" >菜单1</a>
            </li>
            <li id="menu2">
                <a href="#">菜单2</a>
            </li>
            <li id="menu3">
                <a href="#">菜单3</a>
            </li>
        </ul>
        <div id="tabs3" class="tabs">
            <ul>
                <li>
                    <a href="#tabs-4">主页xxxxx</a>
                </li>

            </ul>
            <div id="tabs-4">主页内容</div>

        </div>
        <div id="tab_content" style="display: none;">
            <div class="tabs-menu1">111</div>
            <div class="tabs-menu2">222</div>
            <div class="tabs-menu3">333</div>
        </div>


    </body>
</html>
