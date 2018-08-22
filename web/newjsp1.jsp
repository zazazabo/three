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
            
            function hit(){
                 // $("#aa").attr('checked',true);
//          $("#aa").prop("checked", true);

            var ooo={"2018":[10,0,0,0,0,0,0,0,0,0,0,0],"2017":[0,0,0,0,0,0,0,0,0,0,0,0],"2016":[0,0,0,0,0,0,0,0,0,0,0,0]};
//                ooo[2018]
                console.log(ooo.2018);
//                var yyy="2018";
//                console.log(ooo[yyy][0]);
                
//                 $("#aa").attr('checked',true);
            }
            $(function () {
                var arr = [1, 2, 3, 1, 2, 3, 4, 5, 5];
                var resultArr;
                resultArr = arr.filter(function (item, index, self) {
                    return self.indexOf(item) == index;
                });
                console.log(resultArr);
                
                var obj={};
                var vv="abc";
                obj[vv]=10;
                
                console.log(obj.abc);
              
//                console.log(resultArr);
//                var ar1 = [2007, 2007, 2008, 2009];
//                console.log(ar1);
            })
        </script>
    </head>
    <body>
        <h1>Hello World!</h1>

        <input type="checkbox" id="aa" value="222"/>
        <input type="button" value="hit" onclick="hit()"/>


    </body>
</html>
