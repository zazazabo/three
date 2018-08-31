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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script>

            function hit() {
                $.ajax({async: false, url: "formuser.reportmanage2.getMoth.action", type: "get", datatype: "JSON", data: {year:2018},
                    success: function (data) {
                        var obj = eval('(' + data + ')');
                        console.log(obj)
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
            }
        </script>
    </head>
    <body>
        <h1>Hello World!</h1>

        <input type="checkbox" id="aa" value="222"/>
        <input type="button" value="hit" onclick="hit()"/>


    </body>
</html>
