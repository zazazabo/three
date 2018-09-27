<%-- 
    Document   : table
    Created on : 2018-6-29, 17:48:10
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <script type="text/javascript" src="js/genel.js"></script>

        <style>
            .btn{ margin-left: 10px; }
             .pull-right.pagination-detail{display:none;}
        </style>
    </head>

    <script type="text/javascript" src="js/genel.js"></script>

    <script>
        function layerAler(str) {
            layer.alert(str, {
                icon: 6,
                offset: 'center'
            });
        }



        $(function () {

                $('#l_comaddr').combobox({
                    url: "gayway.GaywayForm.getComaddr.action?pid=${param.pid}",
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        }
                    },
                    onSelect: function (record) {
                    }
                });



            $('#time4').timespinner('setValue', '00:00');
            $('#time3').timespinner('setValue', '00:00');

            var data1 = [{"name": "灯杆倾斜预警开关"}, {"name": "温度预警故障开关"}, {"name": "漏电流预警故障开关"}, {"name": "相位不符预警故障开关"}, {"name": "线路不符预警故障开关"}, {"name": "台区不符预警故障开关"}, {"name": "使用寿命到期预警"}, {"name": "灯具状态改变上报"}];


            var data2 = [{"name": "灯控器故障开关"}, {"name": "温度故障开关"}, {"name": "超负荷故障开关"}, {"name": "功率因数过低故障开关"}, {"name": "时钟故障开关"}, {"name": "集中器与灯控器通信中断"}, {"name": "灯珠故障"}, {"name": "电源故障"}];



            $('#prewarningtable').bootstrapTable({
                columns: [
                    {
                        title: '单选',
                        field: 'select',
                        //复选框
                        checkbox: true,
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'name',
                        title: '预警参数',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }
                ],
                 paginationDetailHAlign:'right',
                data: data1,
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 20, 15, 20, 25],

            });


            $('#warningtable').bootstrapTable({
                columns: [
                    {
                        title: '单选',
                        field: 'select',
                        //复选框
                        checkbox: true,
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }, {
                        field: 'name',
                        title: '报警参数',
                        width: 25,
                        align: 'center',
                        valign: 'middle'
                    }
                ],
                 paginationDetailHAlign:'right',
                data: data2,
                singleSelect: false,
                locale: 'zh-CN', //中文支持,
                pagination: true,
                pageNumber: 1,
                pageSize: 10,
                pageList: [10, 20, 15, 20, 25],

            });


        })

        function lampwarnningCb(obj){
             if (obj.status == "success") {

                if (obj.msg=="A4"&&obj.fn==602) {
                     layerAler("预警参数设置成功");
                 }else if (obj.msg=="A4"&&obj.fn==604) {
                    layerAler("报警参数设置成功");
                 }
              
            }
        }

        function setPreWarning() {
            var obj = $("#form1").serializeObject();
         if (obj.l_comaddr=="") {
            layerAler("请选择网关");
            return;
         }  
            var arr = $("#prewarningtable").bootstrapTable('getData');
            var vv = [];
            var u = 0x00;
            var ss2 = 0;
            var ss = "";
            for (var i = 0; i < arr.length; i++) {
                if (i == 1) {
                    ss = "0" + ss;
                }
                var a = arr[i];
                var s = a.select;
                var ii = s == true ? 0 : 1;
                var s = ii.toString(2);
                ss = s + ss;
                if (i == arr.length - 1) {
                    ss2 = ii;
                    break;
                }
            }
            var u = parseInt(ss, 2);
            vv.push(u);
            vv.push(ss2);
            var comaddr = obj.l_comaddr;
            var num = randnum(0, 9) + 0x70;
            var data = buicode(comaddr, 0x04, 0xA4, num, 0, 602, vv); //01 03 F24    
            dealsend2("A4", data, 602, "lampwarnningCb", comaddr, 0, 0, 0);
        }

        function setWarning() {
         var obj = $("#form1").serializeObject();
         if (obj.l_comaddr=="") {
            layerAler("请选择网关");
            return;
         }

            var arr = $("#warningtable").bootstrapTable('getData');
            var vv = [];
            var u = 0x00;
            var ss2 = 0;
            var ss = "";
            for (var i = 0; i < arr.length; i++) {

                var a = arr[i];
                var s = a.select;
                var ii = s == true ? 0 : 1;
                var s = ii.toString(2);
                ss = s + ss;
            }
            var u = parseInt(ss, 2);
            vv.push(u);
            vv.push(ss2);
            var comaddr = obj.l_comaddr;
            var num = randnum(0, 9) + 0x70;
            var data = buicode(comaddr, 0x04, 0xA4, num, 0, 604, vv); //01 03 F24    
            dealsend2("A4", data, 604, "lampwarnningCb", comaddr, 0, 0, 0);
        }


    </script>
</head>
<body>

    <div class="panel panel-success" >
        <div class="panel-heading">
            <h3 class="panel-title">路灯预报警参数设置</h3>
        </div>
        <div class="panel-body" >
            <div class="container"  >


            <div class="row" style=" padding-top: 20px; padding-bottom: 20; width: 700px;" align="center" >
                <div class="col-xs-12">
                    <form id="form1">
                        <table style="">
                            <tbody>
                                <tr>

                                    <td>
                                        <span style="margin-left:10px;">网关地址&nbsp;</span>

                                        <span class="menuBox">
                                            <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                   data-options="editable:true,valueField:'id', textField:'text' " />
                                        </span>  
                                        <button  type="button"  onclick="setPreWarning()" class="btn btn-success btn-sm">设置灯具预警参数</button>
                                    <button  style=" float: right;" type="button"  onclick="setWarning()" class="btn btn-success btn-sm">设置灯具报警参数</button>
                                    &nbsp;
                                    </td>
            
                                </tr>
                            </tbody>
                        </table> 
                    </form>
                </div>
            </div>



                <div class="row" style=" margin-top: 10px;">
                    <div class="col-xs-5">

                        <table id="prewarningtable"> 

                        </table> 
                    </div>
                    <div class="col-xs-5">
                        <table id="warningtable"  > 
                        </table> 
                    </div>

                </div>

        <div style=" margin-top: 20px;">

        </div>

            </div>
        </div>
    </div>


</body>
</html>
