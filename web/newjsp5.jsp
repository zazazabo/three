<%-- 
    Document   : newjsp3
    Created on : 2018-6-21, 17:42:48
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
        <script type="text/javascript">
            $(function () {
                //alert("ddd");
                //$('#myTab a:last').tab('show');
                $('#daohang').on('shown.bs.tab', function (e) {
                    // 获取已激活的标签页的名称
                    var activeTab = $(e.target).text();
                    alert(activeTab);
                    // 获取前一个激活的标签页的名称
//                  var previousTab = $(e.relatedTarget).text(); 
//                  $(".active-tab span").html(activeTab);
//                  $(".previous-tab span").html(previousTab);
                });


                $('.tab-close').on('click', function (ev) {
                    alert("aaa");
                    var ev = window.event || ev;
                    ev.stopPropagation();
                    //先判断当前要关闭的tab选项卡有没有active类，如果有则给下一个选项卡以及内容添加active
                    var gParent = $(this).parent().parent(),
                            parent = $(this).parent();
                    if (gParent.hasClass('active')) {
                        if (gParent.index() == gParent.length) {
                            gParent.prev().addClass('active');
                            $(parent.attr('href')).prev().addClass('active');
                        } else {
                            gParent.next().addClass('active');
                            $(parent.attr('href')).next().addClass('active');
                        }
                    }
                    gParent.remove();
                    $(parent.attr('href')).remove();
                });



            });

            function addTab(btn) {
                console.log($(btn).html());
            }

            var i = 0;

            /**
             * 关闭标签页
             * @param button
             */
            function closeTab(button) {

                //通过该button找到对应li标签的id
                var li_id = $(button).parent().parent().attr('id');
                var id = li_id.replace("tab_li_", "");

                //如果关闭的是当前激活的TAB，激活他的前一个TAB
                if ($("li.active").attr('id') == li_id) {
                    $("li.active").prev().find("a").click();
                }

                //关闭TAB
                $("#" + li_id).remove();
                $("#tab_content_" + id).remove();
            }



            function usermanage() {


                var dh = $("#myTab");
                //.append(" <li value="+industry.xyIndustryId+">"+industry.industryName+"</li>");
                var strli = "<li role='presentation' class='tab-list'>";
                strli = strli + " <a href='#home" + i.toString() + "' aria-controls='home" + i.toString() + "'  role='tab' data-toggle='tab'>hehe<i class='glyphicon glyphicon-asterisk'></i>";
                strli = strli + "</a>" + "</li>";
                dh.append(strli);
                var tabpanel = $("#tabpanel");
                var strpanel = "<div role='tabpanel' class='tab-pane ' id='home" + i.toString() + "'>" + i.toString() + "</div>";
                tabpanel.append(strpanel);
                i += 1;
                $('#myTab a:last').click();
                //  console.log(vvv.html());


            }
        </script>

        <title>JSP Page</title>


        <style type="text/css">
            #main-nav {
                margin-left: 1px;
            }

            #main-nav.nav-tabs.nav-stacked > li > a {
                padding: 10px 8px;
                font-size: 12px;
                font-weight: 600;
                color: #4A515B;
                background: #E9E9E9;
                background: -moz-linear-gradient(top, #FAFAFA 0%, #E9E9E9 100%);
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#FAFAFA), color-stop(100%,#E9E9E9));
                background: -webkit-linear-gradient(top, #FAFAFA 0%,#E9E9E9 100%);
                background: -o-linear-gradient(top, #FAFAFA 0%,#E9E9E9 100%);
                background: -ms-linear-gradient(top, #FAFAFA 0%,#E9E9E9 100%);
                background: linear-gradient(top, #FAFAFA 0%,#E9E9E9 100%);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FAFAFA', endColorstr='#E9E9E9');
                -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr='#FAFAFA', endColorstr='#E9E9E9')";
                border: 1px solid #D5D5D5;
                border-radius: 4px;
            }

            #main-nav.nav-tabs.nav-stacked > li > a > span {
                color: #4A515B;
            }

            #main-nav.nav-tabs.nav-stacked > li.active > a, #main-nav.nav-tabs.nav-stacked > li > a:hover {
                color: #FFF;
                background: #3C4049;
                background: -moz-linear-gradient(top, #4A515B 0%, #3C4049 100%);
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#4A515B), color-stop(100%,#3C4049));
                background: -webkit-linear-gradient(top, #4A515B 0%,#3C4049 100%);
                background: -o-linear-gradient(top, #4A515B 0%,#3C4049 100%);
                background: -ms-linear-gradient(top, #4A515B 0%,#3C4049 100%);
                background: linear-gradient(top, #4A515B 0%,#3C4049 100%);
                filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#4A515B', endColorstr='#3C4049');
                -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr='#4A515B', endColorstr='#3C4049')";
                border-color: #2B2E33;
            }

            #main-nav.nav-tabs.nav-stacked > li.active > a, #main-nav.nav-tabs.nav-stacked > li > a:hover > span {
                color: #FFF;
            }

            #main-nav.nav-tabs.nav-stacked > li {
                margin-bottom: 4px;
            }

            /*定义二级菜单样式*/
            .secondmenu a {
                font-size: 10px;
                color: #4A515B;
                text-align: center;
            }

            .navbar-static-top {
                background-color: #212121;
                margin-bottom: 5px;
            }

            .navbar-brand {
                background: url('') no-repeat 10px 8px;
                display: inline-block;
                vertical-align: middle;
                padding-left: 50px;
                color: #fff;
            }

        </style>



    </head>


    <body>
        <div class="navbar navbar-duomi navbar-static-top" role="navigation">
            <div class="container-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="/Admin/index.html" id="logo">城市路灯管理系统
                    </a>

                </div><!-- /.container -->  


            </div>
        </div>

        <div class="container-fluid">
            <div class="row">
                <div class="col-md-2">
                    <ul id="main-nav" class="nav nav-tabs nav-stacked" style="">
                        <li class="active">
                            <a href="#">
                                <i class="glyphicon glyphicon-th-large"></i>
                                首页         
                            </a>
                        </li>
                        <li>
                            <a href="#systemSetting" class="nav-header collapsed" data-toggle="collapse">
                                <i class="glyphicon glyphicon-cog"></i>
                                系统管理
                                <span class="pull-right glyphicon glyphicon-chevron-down"></span>
                            </a>
                            <ul id="systemSetting" class="nav nav-list collapse secondmenu" style="height: 0px;">
                                <li><a href="#" onclick="usermanage();" ><i class="glyphicon glyphicon-user"></i>用户管理</a></li>
                                <li><a href="#"><i class="glyphicon glyphicon-th-list"></i>菜单管理</a></li>
                                <li><a href="#"><i class="glyphicon glyphicon-asterisk"></i>角色管理</a></li>
                                <li><a href="#"><i class="glyphicon glyphicon-edit"></i>修改密码</a></li>
                                <li><a href="#"><i class="glyphicon glyphicon-eye-open"></i>日志查看</a></li>
                            </ul>
                        </li>
                        <li>
                            <a href="./plans.html">
                                <i class="glyphicon glyphicon-credit-card"></i>
                                物料管理        
                            </a>
                        </li>

                        <li>
                            <a href="./grid.html">
                                <i class="glyphicon glyphicon-globe"></i>
                                分发配置
                                <span class="label label-warning pull-right">5</span>
                            </a>
                        </li>

                        <li>
                            <a href="./charts.html">
                                <i class="glyphicon glyphicon-calendar"></i>
                                图表统计
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <i class="glyphicon glyphicon-fire"></i>
                                关于系统
                            </a>
                        </li>

                    </ul>
                </div>
                <div class="col-md-10">

                    <div class="container-fluid">
                        <div class="row qb-content-wrapper qb-main-content">
                            <div class="col-md-12 col-xs-12">
                                <ul class="nav nav-tabs tabs" role="tablist" id="myTab" >
                                    <li role="presentation" class="tab-list active">
                                        <a href="#home" aria-controls="home" role="tab" data-toggle="tab">信息检索
                                            <i class="fa fa-remove tab-close"></i></a>

                                    </li>
                                    <li role="presentation" class="tab-list"><a href="#profile" aria-controls="profile" role="tab" data-toggle="tab">产品制作
                                            <i class="fa fa-remove tab-close"></i></a>
                                    </li>

                                </ul>
                                <!-- Tab panes -->
                                <div class="tab-content" id="tabpanel">
                                    <div role="tabpanel" class="tab-pane active" id="home">
                                       <iframe class="iframe" src="newjsp.jsp"></iframe>
                                       <br>
                                       <br>
                                       <br>
                                       <br>
                                       <br>
                                       <br>
                                       <br>
                                       <br>
                                       <br>
                                    </div>
                                    <div role="tabpanel" class="tab-pane" id="profile">
                                        产品制作
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>     

                </div>

            </div>
        </div>
    </body>
</html>
