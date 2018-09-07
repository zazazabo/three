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
                
                var v1=88;
                var vv2=v1<<2|2;
                
                var vvv=[];
                var a= vv2>>8&0x000F;
                var b=vv2&0x00ff;
                
                console.log(a.toString(16));
                console.log(b.toString(16));
                
                console.log(vv2.toString(16));
                
                
                
                
                
                
                
//                $.ajax({async: false, url: "formuser.reportmanage2.getMoth.action", type: "get", datatype: "JSON", data: {year:2018},
//                    success: function (data) {
//                        var obj = eval('(' + data + ')');
//                        console.log(obj)
//                    },
//                    error: function () {
//                        alert("提交失败！");
//                    }
//                });
            }
        </script>
    </head>
    <body>
        <h1>Hello World!</h1>

        <input type="checkbox" id="aa" value="222"/>
        <input type="button" value="hit" onclick="hit()"/>


    </body>
</html>
