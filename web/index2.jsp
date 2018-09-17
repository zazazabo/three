<%-- 
    Document   : index
    Created on : 2014-7-17, 22:06:14
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <%
            String path = request.getContextPath();
        %>
        <link rel="stylesheet" type="text/css" href="js3.4/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="js3.4/themes/icon.css">
        <link href="jquery.uploadify/uploadify.css" type="text/css" rel="stylesheet" />
        <script type="text/javascript" src="js3.4/jquery.min.js"></script>
        <script type="text/javascript" src="js3.4/jquery.easyui.min.js"></script>
        <script type="text/javascript" src="js3.4/locale/easyui-lang-zh_CN.js"></script>  
        <script type="text/javascript" src="jquery.uploadify/jquery.uploadify-3.1.min.js"></script>  
        <script type="text/javascript" src="jquery.uploadify/jquery.uploadify-3.1.js"></script>  
        <script type="text/javascript" src="myjs.js"></script>  
        <script type="text/javascript" src="jquery.md5.js"></script>  
        <script>

            $(function () {













                $("#uploadmobile").uploadify({
                    //指定swf文件
                    'swf': 'jquery.uploadify/uploadify.swf',
                    //后台处理的页面
                    'uploader': 'test1.UPLOAD.h1.action',
                    //按钮显示的文字
                    'buttonText': '上传图片',
                    //显示的高度和宽度，默认 height 30；width 120
                    //'height': 15,
                    //'width': 80,
                    //上传文件的类型  默认为所有文件    'All Files'  ;  '*.*'
                    //在浏览窗口底部的文件类型下拉菜单中显示的文本
                    'fileTypeDesc': 'Image Files',
                    //允许上传的文件后缀
                    'fileTypeExts': '*.gif; *.jpg; *.png',
                    //发送给后台的其他参数通过formData指定
                    //'formData': { 'someKey': 'someValue', 'someOtherKey': 1 },
                    //上传文件页面中，你想要用来作为文件队列的元素的id, 默认为false  自动生成,  不带#
                    //'queueID': 'fileQueue',
                    //选择文件后自动上传
                    'auto': true,
                    //设置为true将允许多文件上传
                    'multi': true,
                    'onUploadSuccess': function (file, data, response) {
                        alert(data);
                        var jsonDatas = eval("(" + data + ")");
                        var rs = jsonDatas[0];
                        var img1 = rs['attach'];
                        $("#imetest").attr("src", "<%=path%>/upload/" + img1);
                        rs['attach'];
                        //循环遍历数据
                        //                        $.each(jsonDatas, function(item) {
                        //                            alert(jsonDatas[0]['guid']);
                        //                            //循环
                        //                        });


                    }
                });

            });

            function fromtojson() {
                var url = "test1.f4.h4.action";
                window.location = url;
            }
            function out() {
                var url = "test1.f3.h1.action?aid=1111&apassword=222";
                window.location = url;
            }
            function totable1() {

                var url = "test1.f4.h1.action";
                window.location = url;

            }
            function ToThree() {
                //                var url = "test1.Tree.h1.action";
                //                window.location = url;


            }
            function CheckCode() {

            }
            function importhm() {

                //
                //                var url = "test1.f2.h1.action?aid=在此&apassword=b";
                //                var url="/second/AdminLogin.action";
                //               window.location = url;
                //                $.ajax({
                //                    url: "test1.f2.h2.action",
                //                    data: $('#fm1').serialize(),
                //                    type: "post",
                //                    success: function(data) {
                //                        alert(data);
                //                    }
                //                })

                //             $('#fm1').submit();

                //                $.get("test1.f1.h2.action", "acct=" + "aa", function(data) {
                //                    for (var m in data[0]) {
                //                    }
                //                }, "json");

            }
            function sendMail() {
                $.ajax({
                    url: "test1.Mail.h1.action",
                    data: $('#sendMail1').serialize(),
                    type: "post",
                    success: function (data) {
                        alert(data);
                    }
                });
            }
            function download1() {
                alert("sdfsdfdsf");
                window.location = "test1.DownLoad.h1.action?filename_=1ur.txt";
            }
            function getTree() {
                $('#tree1').tree({
                    url: 'test1.Tree.h1.action'
                });
            }
            function md5_pass() {


                var val1 = $("input[name=md5]").val();
                val1 = $.md5(val1);
                alert(val1);

            }
            function getcheckcode() {
                var data = getURLData("test1.Module.h1.action?rs=getCheckCode");
                alert(data[0]['checkcode']);
            }
            function getssion() {
                var data = getURLData("test1.Module.h1.action?rs=dealPost");


            }
        </script>

        <style type="text/css">

        </style>
    </head>
    <body>

        <h1>Hello World!</h1>sdfsdf
        <!--        <form action="test1.f1.h1.action" method="post">
                    <input type = "text" name = "aid"/>
                    <input type = "text" name = "apassword"/>
                    <input type = "submit" name = "login" value = "注册"/>
                </form>-->
        <form id="fm1" action="test1.f2.h2.action" method="post">
            <input type = "text" name = "aid"/>
            <input type = "text" name = "apassword"/>
            <input type = "submit" name = "login" value = "注册"/>
        </form>
        <a id="A1"  href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="importhm()">导入</a>
        <a id="A1"  href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="out()">第一个easyuigrid</a>
        <a id="A1"  href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="totable1()">第一个easyuigrid</a>
        <a id="A1"  href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="fromtojson();">formToJson</a>
        <a id="A1"  href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="ToThree();">进入树形菜单</a>
        <div id="imge1" style=" width: 100px; height: 100px;">

            <img id="imetest" style=" width: 100%; height: 100" src="<%=path%>/upload/界面.png"/>
        </div>

        <table>
            <tr class="editrow">
                <td align="right" valign="top"><font class="redtext"></font>手机图片上传：</td>
                <td>
                    <input id="uploadmobile" type="file" upload="uploadify" />
                </td>
            </tr>    

        </table>
        <form id="sendMail1">
            <input type="text" value="aaaaaaaaa" name="subject_"/>
            <input type="text" value="bbbbbbbb" name="content_"/>
            <input type="text" value="277402131@qq.com" name="to_"/>
            <input type="text" value="D:\\1.txt" name="attach_"/>
            <input type="button" value="发送email" onclick="sendMail();"/>
        </form>
        <object align=middle classid="CLSID:22d6f312-b0f6-11d0-94ab-0080c74c7e95" class=OBJECT id=MediaPlayer width=196 height=196> 
            <param name=ShowStatusBar value=0> 
            <param name=Filename value="http://202.116.*.*/video/story/chinese/hynh/b.wmv"> 
            <embed type=application/x-oleobject codebase="http://activex.microsoft.com/activex/con ... n/nsmp2inf.cab#Version=5,1,52,701" > 
            </embed> 
        </object> 
        <form id="downLoadfm">
            <input type="text" value="logol.jpg" name="filename_"/>
            <input type="text" value="upload" name="filepath_"/>
            <input type="button" value="下截例子" onclick="download1();"/>
        </form>      
        <div >
            <input type="button" value="树形列表" onclick="getTree();"/>
            <ul id="tree1" class="easyui-tree"></ul>  
        </div>
    </body>

    <input type="text" value="ddd" id="md5" name="md5"/>
    <input type="button" value="md5加密"  onclick="md5_pass();"/>
    <div>  
        <input type = "text" id="code"/>  
        <input type = "button" id="code" value="生成验证码" onclick="createCode();"/>  
        <input type = "button" value = "验证" onclick = "validate();"/>  
    </div> 


    <input type="button" value="取sseion" onclick="getcheckcode();">

    <input type="button" value="季托调用取sseion值" onclick="getssion();"> 

    <div id="img1">
        <input id="checkcode1" type="text"/>
        <iframe id="iframe1"  style=" border: 1px #11777C dashed;" src="test1.Module.h1.action?rs=setCheckCode" width="150" height="50">      
        </iframe>

    </div>
</html>
