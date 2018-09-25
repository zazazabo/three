<%-- 
    Document   : ecchart
    Created on : 2018-8-1, 11:12:39
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="js/genel.js"></script>
        <script src="echarts/dist/echarts_3.8.5_echarts.min.js"></script>
        <style>

            @charset "utf-8";
            .clear {
                clear: both;
            }
            /* text-align */
            .tleft {
                text-align: left;
            }
            .tright {
                text-align: right;
            }
            .tcenter {
                text-align: center;
            }
            /* display */
            .dis {
                display: block;
            }
            .undis {
                display: none;
            }
            .w {
                width: 100%;
            }
            .h {
                height: 100%;
            }
            .minw {
                min-width: 1050px;
            }
            .fontFamily {
                font-family: "microsoft yahei";
                font-weight: normal;
            }
            .form-control {
                border: 1px solid #ccc;
                font-size: 14px;
            }
            .widMid {
                width: 120px !important;
            }
            .widBig {
                width: 150px !important;
            }
            .btn {
                height: 30px;
            }
            select {
                border: 1px solid #ccc;
            }
            * {
                margin: 0;
                padding: 0;
            }
            body,
            html {
                width: 100%;
                height: 100%;
                overflow: auto;
                font-family: "microsoft yahei";
                font-weight: normal;
            }
            .top {
                overflow: hidden;
                width: 100%;
                height: 45%;
                background: #f8f8f8;
            }
            .topLeft {
                float: left;
                display: inline;
                overflow: hidden;
                width: 18%;
                margin-left: 3%;
                height: 90%;
            }
            .topLeftOneBox {
                overflow: hidden;
                width: 100%;
                height: 30%;
                margin-top: 3%;
            }
            .redius {
                display: block;
                border-radius: 50%;
                -moz-border-radius: 50%;
                -webkit-border-radius: 50%;
                -ms-border-radius: 50%;
                -o-border-radius: 50%;
                float: left;
                display: inline;
                width: 50px;
                height: 50px;
                margin: 8% 10px 0 10px;
            }
            .redius img {
                width: 30px;
                height: 30px;
                display: block;
                margin: 10px;
            }
            .Mess {
                float: left;
                display: inline;
                height: 100%;
                width: 90px;
                padding-top: 8%;
            }
            .Mess span {
                display: block;
                color: #666666;
                font-size: 16px;
            }
            .topCenter1 {
                overflow: hidden;
                float: left;
                display: inline;
                width: 25%;
                height: 90%;
                margin-left: 3%;
                margin-top: 20px;
            }
            .topCenter2 {
                overflow: hidden;
                float: left;
                display: inline;
                width: 17%;
                height: 90%;
                margin-top: 20px;
            }
            .topCenter2Mess {
                height: 70%;
                width: 100%;
                margin-top: 40%;
            }
            .nenghao {
                width: 100%;
                height: 20%;
                line-height: 30px;
                color: gray;
            }
            .nenghao1 {
                width: 100%;
                height: 30%;
                line-height: 30px;
                color: gray;
            }
            .tongbi {
                color: #90c948;
            }
            .topCenter3 {
                float: left;
                display: inline;
                width: 18%;
                height: 90%;
                margin-left: 2%;
                margin-top: 20px;
            }
            .topCenter3Mess {
                position: relative;
                width: 10%;
                float: left;
                display: inline;
                height: 90%;
                margin-top: 20px;
            }
            .topCenter3Mess .topCenter3MessMM {
                height: 60%;
                margin-top: 50%;
                width: 100%;
                color: gray;
            }
            .topCenter3Mess .topCenter3MessMM div{
                float:left;
            }
            .topCenter3Mess .topCenter3MessMM .first {
                width: 250px;
                /* float: left;
                display: inline;
                text-align: right; */
                line-height: 30px;
            }
            .topCenter3Mess .topCenter3MessMM .second {
                width: 250px;
                /*   text-align: left;
                  float: left;
                  display: inline; */
                line-height: 30px;
            }
            .bottom {
                width: 100%;
                height: 50%;
                background: #f8f8f8;
            }

            .bottom1 {
                height: 480px;
                background: #fff;
            }
            .echarts3 {
                width: 45%;
                height: 95%;
                float: left;
                display: inline;
                margin-top: 20px;
                margin-left: 20px;
            }
            .bottomRight {
                float: left;
                display: inline;
                width: 44%;
                height: 95%;
                margin-top: 20px;
                margin-left: 80px;
            }
            .echarts4 {
                width: 90%;
                height: 47%;
                float: right;
                display: inline;
            }
            .echarts5 {
                width: 90%;
                height: 46%;
                margin-top: 17px;
                float: right;
                display: inline;
            }
            .paraValue {
                font-size: 16px;
                color: #666;
            }
            .subPara {
                color: #999;
                font-size: 14px;
            }
            /*# sourceMappingURL=home.css.map */

        </style>

        <script>

            var myChart, myChart2, myChart3, myChart4, myChart5;
            var echarts;
            $(function () {
                //alert();
                console.log("a:"+"${param.pid}");
                var truevalmap;
                var status1 = "";
            <c:if test="${fn:length(rs3)==0 }">
                var fend = 0;
                var planpower = parseFloat(${rs4[0].power});
                $("#actualConsumption").html("0");  //实际用能
                truevalmap = 0;
                var diff = planpower - fend;
                $("#differenceConsumption").html(diff.toString());

                $("#jnl").html("100%");
                status1 = "正常";

            </c:if>
            <c:if test="${fn:length(rs3)==1 }">

                var power =${rs3[0].power};
                var powerArr = power.A.split("|");
                var val = powerArr[power.len - 1];
                console.log(val);
                var planpower = parseFloat(${rs4[0].power});
                var fstart = 0;
                var fend = parseFloat(val);
                truevalmap = fend;
                var trueval = fend / planpower * 100;
                var jnl = (1 - trueval) * 100;
                var str = jnl.toFixed(2).toString() + "%";
                $("#jnl").html(str);


                $("#actualConsumption").html(fend.toString());  //实际用能

                var planpower = parseFloat(${rs4[0].power});
                var diff = planpower - fend;
                $("#differenceConsumption").html(diff.toString());      //差值


                if (diff < 0) {
                    $("#status").html("异常");
                    status1 = "异常";
                } else {
                    $("#status").html("正常");
                    status1 = "正常";
                }
            </c:if>
            <c:if test="${fn:length(rs3)>1 }">
                var power1 =${rs3[0].power}; //最近一日
                var power2 =${rs3[fn:length(rs3)-1].power}; //最远一日
                var a1 = power1.A.split("|");
                var a2 = power2.A.split("|");

                var p1 = a1[power1.len - 1];
                var p2 = a2[0];

                var fend = parseFloat(p1);
                var fstart = a2[0];


                var planpower = parseFloat(${rs4[0].power});
                var trueval = fend - fstart;
                truevalmap = trueval;
                $("#actualConsumption").html(trueval.toFixed(2).toString());

                var diff = planpower - trueval;
                $("#differenceConsumption").html(diff.toFixed(2).toString());


                var jnl = (1 - trueval / planpower) * 100;
                var str = jnl.toFixed(2).toString() + "%";
                $("#jnl").html(str);

                if (diff < 0) {
                    $("#status").html("异常");
                    status1 = "异常";
                } else {
                    $("#status").html("正常");
                    status1 = "正常";
                }
            </c:if>



                var aa = new Array();
                var obj = new Object();
                obj.Month = ${rs3[0].month};
                obj.plan_value =${rs4[0].power};
                obj.num = truevalmap.toFixed(2);
                obj.energy = ${rs4[0].power};
                obj.status = status1;
                aa.push(obj);
                data = aa;
                var pieData = [{value: data[0].plan_value, name: '计划能耗'}, {value: data[0].num, name: '实际能耗'}];
                pieChart("echarts2", "", pieData, "用能计划");
            })




            function dealsend() {

                var user = new Object();
                user.count = 0;
                user.res = 1;
                user.afn = 0;
                user.status = "";
                user.function = "getCount";
                user.errcode = 0;
                user.frame = 0;
                user.msg = "Online";
                user.res = 1;
                user.page = 1;
                parent.sendData(user);

            }



            $(function () {
                var a3 = new Array();
                var o3 = new Object();

                var yearobj = {"2018": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "2017": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], "2016": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]};
                var yearbar = {"2018": 0, "2017": 0, "2016": 0};
            <c:forEach items="${rs6}" var="t">
                var year = ${t.year};
                var month = ${t.monty};
                <c:if test="${t.power ne  null }">
                var power =${t.power};
                var energy = power.energy;
//                    console.log(energy);
//                    console.log(year);
//                    console.log(month);
                if (yearobj.hasOwnProperty(year.toString())) {
//                    var f1 = parseFloat(energy);
                    var f1 = Math.floor(energy * 100) / 100;
//                    console.log(f1);
                    yearobj[year.toString()][month - 1] += f1;
                    yearbar[year.toString()] += f1;
                }
                </c:if>
            </c:forEach>
                console.log(yearobj);
//                console.log(yearobj);

//                var resultYear = "";
//                resultYear = yeararr.filter(function (item, index, self) {
//                    return self.indexOf(item) == index;
//                });
//                console.log(resultYear);


                var a3 = new Array();
                var o3 = new Object();
                var titlearr = [];

                for (x in yearobj)
                {
                    titlearr.push(x);
                }






                o3.thisYear3 = yearobj[2018];
                o3.thisYear2 = yearobj[2017];
                o3.thisYear1 = yearobj[2016];
//                console.log(o3);
                a3.push(o3);
                var data = a3;
                var dataTitleArray = titlearr;
                var echarts3DataX = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];
                var numberY0 = data[0].thisYear1;
                var numberY1 = data[0].thisYear2;
                var numberY2 = data[0].thisYear3;
                echarts3("echarts3", "横向对比分析", dataTitleArray, echarts3DataX, dataTitleArray[0], numberY0, dataTitleArray[1], numberY1, dataTitleArray[2], numberY2, "kW·h");


                var a4 = new Array();
                var o4 = new Object();
                o4.thisYear3 = Math.floor(yearbar[2018] * 100) / 100;
                o4.thisYear2 = Math.floor(yearbar[2017] * 100) / 100;
                o4.thisYear1 = Math.floor(yearbar[2016] * 100) / 100;
                o4.date3 = 2018;
                o4.date2 = 2017;
                o4.date1 = 2016;
//                console.log(o4);
                a4.push(o4);
                var data = a4;
                var echarts4DataX = [data[0].date1, data[0].date2, data[0].date3];
                var echarts4DataY = [data[0].thisYear1, data[0].thisYear2, data[0].thisYear3];
                ech4('echarts4', '数据趋势', '能耗', echarts4DataX, echarts4DataY, 'bar', 'kW·h', "#337dd7");


                var date = new Date();
                var year1 = date.getFullYear();
                var year2 = year1 - 1;
                var month1 = date.getMonth() + 1;
                var month2 = month1 - 1;
//                console.log(year1);
//                console.log(month1);

                var a5 = [0.0, 4.5, 0.0, -100.0, 0.0];
                var data = a5;
                var dataX = ["当月能耗", "上月能耗", "去年同期"];

                var nowmonth = Math.floor(yearobj[year1.toString()][month1 - 1] * 100) / 100;  //当月
                var premonth = Math.floor(yearobj[year1.toString()][month2 - 1] * 100) / 100;  //前个月


                var preyear = Math.floor(yearobj[year2.toString()][month1 - 1] * 100) / 100;  //去年当月
                var dataY = [nowmonth, premonth, preyear];
                ech('echarts1', '能耗分析', '能耗', dataX, dataY, 'bar', 'kW·h', "#68b928");
                $("#benyue").html(nowmonth);
                $("#shangyue").html(premonth);
                var huanbi = nowmonth - premonth;
                var hh = Math.floor(huanbi * 100) / 100;
                $("#lastMonth").html(hh);
                var qiantb = nowmonth - preyear;
                qiantb = Math.floor(qiantb * 100) / 100;
                $("#lastYearSameMonth").html(qiantb);

                window.onresize = function () {
//                    myChart.resize();
//                    myChart2.resize();
//                    myChart3.resize();
//                    myChart4.resize();
//                    myChart5.resize();
                }
            })

            function ech(id, title, titleY, signXAxis, signYAxis, type, danwei, bg) {

                myChart = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title
                    },
                    grid: {
                        left: '90',
                        x: 50,
                        x2: 10,
                        y2: 30
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var tar = params[0];
                            return tar.name + ' : ' + tar.value + ' kW·h';
                        }
                    },
                    legend: {
                        data: titleY
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            restore: {},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false, //去掉X轴辅助线
                        },
                        axisLabel: {
                            textStyle: {
                                fontSize: 12, //刻度大小
                            },
                        },
                        data: signXAxis
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            itemStyle: {
                                normal: {
                                    color: bg
                                }
                            },
                            name: titleY,
                            type: type,
                            data: signYAxis
                        }]
                };
                myChart.setOption(option);
            }

            //环状图
            function pieChart(id, title, dataY, zongbi) {
                var vvv = document.getElementById(id);
                myChart2 = echarts.init(document.getElementById(id));

                var option = {
                    title: {
                        text: title,
                        subtext: zongbi,
                        x: 'center',
                        y: 'center',
                        subtextStyle: {
                            fontSize: 18,
                            color: "skyblue"
                        }
                    },
//                                        legend: {
//                                            orient: 'vertical',
//                                            x: 'left',
//                                            data: ['计划能耗', '实际能耗']
//                                        },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} kW·h ({d}%)"
                    },
                    color: ["#4fcdfd", "#fdd237"],
                    toolbox: {
                        show: true,
                        feature: {
                            mark: {show: true},
                            dataView: {show: true, readOnly: false},
                            restore: {show: true},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    calculable: true,
                    series: [
                        {
                            name: '访问来源',
                            type: 'pie',
                            radius: ['40%', '70%'], //圈圈的边框粗细
                            itemStyle: {
                                normal: {
                                    label: {
                                        show: true
                                    },
                                    labelLine: {
                                        show: true
                                    }
                                },
                                emphasis: {

                                }
                            },
                            data: dataY
                        }
                    ]
                };
                myChart2.setOption(option);
            }

            //折线图
            function echarts3(id, title, dataTitle, dataX, title0, number0, title1, number1, title2, number2, danwei) {
                myChart3 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: ""
                    },
                    grid: {
                        containLabel: true,
                        x: 50,
                        x2: 30,
                        y2: 20
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            return params[0].seriesName + '-' + params[0].name + ' : ' + params[0].value + ' kW·h' + '<br/>' +
                                    +params[1].seriesName + '-' + params[1].name + ' : ' + params[1].value + ' kW·h' + '<br/>' +
                                    +params[2].seriesName + '-' + params[2].name + ' : ' + params[2].value + ' kW·h';
                        }
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    legend: {
                        data: dataTitle
                    },
                    xAxis: {
                        data: dataX
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            name: title0,
                            type: 'line',
                            data: number0
                        },
                        {
                            name: title1,
                            type: 'line',
                            data: number1
                        },
                        {
                            name: title2,
                            type: 'line',
                            data: number2
                        }
                    ]
                };
                myChart3.setOption(option);
            }

            function ech4(id, title, titleY, signXAxis, signYAxis, type, danwei, bg) {
                myChart4 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title
                    },
                    grid: {
                        left: '90',
                        x: 50,
                        x2: 10,
                        y2: 30
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var tar = params[0];
                            return tar.seriesName + "</br>" + tar.name + ' : ' + tar.value + ' kW·h';
                        }
                    },
                    legend: {
                        data: titleY
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            restore: {},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false, //去掉X轴辅助线
                        },
                        axisLabel: {
                            textStyle: {
                                fontSize: 12, //刻度大小
                            },
                        },
                        data: signXAxis
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            itemStyle: {
                                normal: {
                                    color: bg
                                }
                            },
                            name: titleY,
                            type: type,
                            data: signYAxis
                        }]
                };
                myChart4.setOption(option);
            }

            function ech5(id, title, titleY, signXAxis, signYAxis, type, danwei, bg) {
                myChart5 = echarts.init(document.getElementById(id));
                var option = {
                    title: {
                        text: title
                    },
                    grid: {
                        left: '90',
                        x: 50,
                        x2: 10,
                        y2: 30
                    },
                    tooltip: {
                        trigger: 'axis',
                        formatter: function (params) {
                            var tar = params[0];
                            return tar.seriesName + "</br>" + tar.name + ' : ' + tar.value + ' kW·h';
                        }
                    },
                    legend: {
                        data: titleY
                    },
                    toolbox: {
                        show: true,
                        feature: {
                            magicType: {type: ['line', 'bar']},
                            restore: {},
                            saveAsImage: {show: true, title: '保存为图片'}
                        }
                    },
                    xAxis: {
                        type: 'category',
                        splitLine: {
                            show: false, //去掉X轴辅助线
                        },
                        axisLabel: {
                            textStyle: {
                                fontSize: 12, //刻度大小
                            },
                        },
                        data: signXAxis
                    },
                    yAxis: {
                        type: 'value',
                        axisLabel: {
                            formatter: '{value} ' + danwei
                        }
                    },
                    series: [{
                            itemStyle: {
                                normal: {
                                    color: bg
                                }
                            },
                            name: titleY,
                            type: type,
                            data: signYAxis
                        }]
                };
                myChart5.setOption(option);
            }

            function getCount(obj) {
                console.log(obj)
                var count = obj.count;
                var a = count /${rs5[0].count} * 100;
                var str = a.toString() + '%';
                $('#online').html(str);
            }
            $(function () {
                dealsend();
            })

        </script>


    </head>


    <body>



        <br>
        <div class="top" style="width:100%;height:450px;position:relative;">
            <div class="topTitle" style="position:absolute;top:2%;left:2%;color:#000;font-size:20px;font-weight:600;">设备分析</div>
            <div class="topLeft" style="height:400px;padding-top:60px;">
                <div class="topLeftOneBox">
                    <span class="redius" style="background:#fdd237;">
                        <img src="img/dp.png"></span>
                    <div class="Mess lightingRate">
                        <span>
                            <c:if test="${rs1[0].count-rs2[0].count<=0}">
                                0%
                            </c:if>

                            <c:if test="${rs1[0].count-rs2[0].count>0}">
                                ${(rs1[0].count-rs2[0].count)/rs1[0].count * 100}%
                            </c:if> 


                        </span>
                        <span>亮灯率</span>
                    </div>
                </div>
                <div class="topLeftOneBox">
                    <span class="redius" style="background:#42bcec;"><img src="img/jien.png"></span>
                    <div class="Mess energySavingRate">
                        <span id="jnl">
                        </span>
                        <span>节能率</span>
                    </div>
                </div>
                <!--                <div class="topLeftOneBox">
                                    <span class="redius" style="background:#68b928;"><img src="img/online.png"></span>
                                    <div class="Mess AlarmTimes">
                                        <span id="online">10%</span>
                                        <span>在线率</span>
                                    </div>
                                </div>-->
            </div>

            <!--用能计划-->
            <div class="topTitle" style="position:absolute;top:2%;left:24%;color:#000;font-size:20px;font-weight:600;">用能计划
                <br><br>
                <span style="color:#777;font-size:18px;font-weight:500;">单位：kW·h</span>
            </div>
            <div class="topCenter3" id="echarts2"  style="height: 400px;">    

            </div>
            <div class="topCenter3Mess" style="height:400px;">

                <div class="topCenter3MessMM" style="margin-top:40%;">
                    <div class="first">
                        <span class="subPara">计划能耗：</span>
                        <span class="paraValue" id="planConsumption">${rs4[0].power}</span>
                    </div>
                    <!-- <div class="second"></div> -->
                    <div class="first">
                        <span class="subPara">实际能耗：</span>
                        <span class="paraValue" id="actualConsumption">

                        </span>
                    </div>
                    <!-- <div class="second">1000</div> -->
                    <div class="first">
                        <span class="subPara">差值：</span>
                        <span class="paraValue" id="differenceConsumption"></span>
                    </div>
                    <!-- <div class="second">250</div> -->
                    <div class="first">
                        <span class="subPara">状态：</span>
                        <span class="subPara" id="status">

                        </span>
                    </div>

                </div>
            </div>

            <!--横向对比分析-->
            <div class="topTitle" style="position:absolute;top:2%;left:61%;color:#000;font-size:20px;font-weight:600;">横向对比分析</div>
            <div class="echarts3" id="echarts3" style="height: 430px;">
            </div>

        </div>



        <div class="bottom1">
            <div class="echarts4" id="echarts4" style="width: 35%; height: 85%; float: left; margin: 20px 0px 20px 30px;">


            </div>

            <div class="topCenter4" style="width:10%;height:85%;float:right;">
                <div class="topCenter2Mess">	
                    <div class="nenghao">
                        <span class="subPara">本月能耗:</span><br>
                        <span id="benyue" class="paraValue"></span>kW·h</div>
                    <div class="nenghao1">
                        <span class="subPara">上月能耗:</span><br>
                        <span id="shangyue" class="paraValue"></span>kW·h<br>
                        <span>环比：</span>
                        <span class="tongbi" id="lastMonth"></span>
                        kW·h
                    </div>
                    <div class="nenghao1">
                        <span class="subPara">去年同期:</span><br>
                        <span id="qunian" class="paraValue"></span>
                        <span>同比：</span>
                        <span class="tongbi" id="lastYearSameMonth"></span>
                        kW·h
                    </div>
                    <div class="nenghao1">
                        <span class="subPara">每盏灯平均能耗:</span>
                        <span id="pingjun" class="paraValue">0</span>kW·h
                    </div>
                </div>
            </div> 


            <div class="topCenter1" id="echarts1" style="width: 45%; height: 85%; float: left;">

            </div>
        </div>			
        <!--子项分析-->
        <!--                <div style="width: 100%; overflow: hidden; height: 480px; display: none;" id="sub">
                            <div class="echarts5" id="echarts5" style="width: 85%; height: 450px; -moz-user-select: none; position: relative; background-color: transparent;" _echarts_instance_="ec_1530234242293"><div style="position: relative; overflow: hidden; width: 85px; height: 450px;">
                                    <canvas style="position: absolute; left: 0px; top: 0px; width: 85px; height: 450px; -moz-user-select: none;" width="85" height="450" data-zr-dom-id="zr_0">
                
                                    </canvas>
                                </div>
                                <div>
                
                                </div>
                            </div>
                        </div>	-->

        <!--<div id="qb-sougou-search" style="display: none; opacity: 0;"><p>搜索</p><p class="last-btn">复制</p><iframe src=""></iframe></div>-->

    </body>
</html>
