<%-- 
    Document   : newjsp1
    Created on : 2018-11-23, 13:03:35
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <link rel="stylesheet" type="text/css" href="Huploadify.css"/>
    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/jquery.Huploadify.js"></script>
    <style type="text/css">
    </style>
    <script type="text/javascript">
        $(function () {
            $('#upload').Huploadify({
                auto: false,
                fileTypeExts: '*.jpg;*.png;*.exe;*.jsp;*.xml',
                multi: true,
                formData: {fname: 'uu.txt', fpath: 'upload1', filedesc: 'aaaa'},
                fileSizeLimit: 9999,
                showUploadedPercent: true, //是否实时显示上传的百分比，如20%
                showUploadedSize: true,
                removeTimeout: 9999999,
                uploader: 'test1.UPLOAD.h1.action',
                onUploadStart: function () {
                    //alert('开始上传');
                    var fpath = $("#path").val();
                    option.formData = {fname: 'uu.txt', fpath: fpath, filedesc: 'aaaa'};
                },
                onInit: function () {
                    //alert('初始化');
                },
                onUploadComplete: function () {
                    //alert('上传完成');
                },
                onUploadSuccess: function (file, data, response) {
                    alert(data);
                },
                onDelete: function (file) {
                    console.log('删除的文件：' + file);
                    ;
                }
            });
        });
    </script>
</head>

<body>
    <div id="upload"></div>
    <form id="form1">
        上传的路径:<input type="text" id="path" name="path" value="" >
    </form>

</body>
</html>
