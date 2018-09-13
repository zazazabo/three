<%-- 
    Document   : newjsp1
    Created on : 2018-8-6, 18:19:59
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <link type="text/css" href="jquery-ui-bootstrap/css/custom-theme/jquery-ui-1.10.0.custom.css" rel="stylesheet" />
        <script src="jquery-ui-bootstrap/assets/js/jquery-ui-1.10.0.custom.min.js" type="text/javascript"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script>

            function hit() {
                $("#dialog").dialog();
            }

            $(function () {

                // Dialog Link
                $('#dialog_link').click(function () {
                    $('#dialog_simple').dialog('open');
                    return false;
                });

                // Modal Link
                $('#modal_link').click(function () {
                    $('#dialog-message').dialog('open');
                    return false;
                });


                // Dialog Simple
                $('#dialog_simple').dialog({
                    autoOpen: false,
                    width: 600,
                    buttons: {
                        "Ok": function () {
                            $(this).dialog("close")
                        },
                        "Cancel": function () {
                            $(this).dialog("close");
                        }
                    }
                });

                //####### Dialogs
                $("#dialog-message").dialog({
                    autoOpen: false,
                    modal: true,
                    buttons: {
                        Ok: function () {
                            $(this).dialog("close");
                        }
                    }
                });


            });


        </script>
    </head>
    <body>
        <h1>Hello World!</h1>

        <input type="checkbox" id="aa" value="222"/>
        <input type="button" value="hit" onclick="hit()"/>
        <div class="container">


            <!-- Dialog -->

            <p class="dialog-button">
                <a href="#" id="dialog_link" class="ui-state-default ui-corner-all">
                    <span class="ui-icon ui-icon-newwin"></span>Open Dialog
                </a>
                &nbsp;
                <a href="#" id="modal_link" class="ui-state-default ui-corner-all">
                    <span class="ui-icon ui-icon-newwin"></span> Open Modal Dialog
                </a>
            </p>


            <div id="dialog_simple" title="Dialog Simple Title">
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
            </div>

            <div id="dialog-message" title="Modal Dialog">
                <p>
                    <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span> 
                    Your files have downloaded successfully into the My Downloads folder.
                </p>

            </div>


        </div>



        <div id="dialog" title="基本的对话框">
            <p>这是一个默认的对话框，用于显示信息。对话框窗口可以移动，调整尺寸，默认可通过 'x' 图标关闭。</p>
        </div>


    </body>
</html>
