<%-- 
    Document   : eccharttest
    Created on : 2018-8-1, 15:02:57
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="echarts/dist/echarts_3.8.5_echarts.min.js"></script>
        <!--<script src="https://cdn.bootcss.com/echarts/3.8.5/echarts.min.js"></script>-->
        <script>

            var myChart2, myChart3, myChart4, myChart5, myChart;
//环状图
            function quanquan(id, title, dataY, zongbi) {
                var vvv = document.getElementById(id);
                myChart2 = echarts.init(document.getElementById(id));
                console.log(myChart2);
                var option = {
                    title: {
                        text: "",
                        subtext: zongbi,
                        x: 'center',
                        y: 'center',
                        subtextStyle: {
                            fontSize: 18,
                            color: "skyblue"
                        }
                    }, legend: {
                        orient: 'vertical',
                        x: 'left',
                        data: ['计划能耗', '实际能耗']
                    },
                    tooltip: {
                        trigger: "item",
                        formatter: "{a} <br/>{b} : {c} kW·h ({d}%)"
                    },
                    color: ["#4fcdfd", "#fdd237"],
                    toolbox: {

                        feature: {
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
                            avoidLabelOverlap: false,
                            label: {//设置饼状图圆心属性
                                //normal,emphasis分别对应正常情况下与悬停效果
                                normal: {
                                    show: false,
                                    position: 'center'
                                },
                                emphasis: {
                                    show: false,
                                    textStyle: {
                                        fontSize: '20',
                                        fontWeight: 'bold'
                                    }
                                }
                            },
                            labelLine: {
                                normal: {
                                    show: false
                                }
                            },
                            itemStyle: {
                                normal: {
                                    label: {
                                        show: false
                                    },
                                    labelLine: {
                                        show: false
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





//            var echarts;
            $(function () {


                var aa = new Array();
                var obj = new Object();
                obj.Month = 3;
                obj.plan_value = 10;
                obj.num = 10;
                obj.energy = 100;
                obj.status = "正常";
                aa.push(obj);
                data = aa;
                console.log(data);
//                        [{"Month":0,"plan_value":10,"num":10,"energy":100,"status":"正常"}]  ec2


                var quanquanData = [{value: data[0].plan_value, name: '计划能耗'}, {value: data[0].Month, name: '实际能耗'}];
                console.log(quanquanData);
                quanquan("echarts2", "用能计划", quanquanData, "");


                var a3 = new Array();
                var o3 = new Object();
                o3.thisYear3 = [0, 0, 0.56, 0.04, 0, 3.08, 4.5, 0, 0, 0, 0, 0];
                o3.thisYear2 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                o3.date3 = 2018;
                o3.date2 = 2017;
                o3.date1 = 2016;
                o3.thisYear1 = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                a3.push(o3);
                var data = a3;
                var dataTitleArray = [data[0].date1.toString(), data[0].date2.toString(), data[0].date3.toString()];
                var echarts3DataX = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];
                var numberY0 = data[0].thisYear1;
                var numberY1 = data[0].thisYear2;
                var numberY2 = data[0].thisYear3;
                //dataTitleArray=["2015","2016","2017"];
                echarts3("echarts3", "横向对比分析", dataTitleArray, echarts3DataX, dataTitleArray[0], numberY0, dataTitleArray[1], numberY1, dataTitleArray[2], numberY2, "kW·h");



                var a4 = new Array();
                var o4 = new Object();

                o4.thisYear3 = 8.18;
                o4.thisYear2 = 0;
                o4.thisYear1 = 0;
                o4.date3 = 2018;
                o4.date2 = 2017;
                o4.date1 = 2016;
                a4.push(o4);
                var data = a4;
                var echarts4DataX = [data[0].date1, data[0].date2, data[0].date3];
                var echarts4DataY = [data[0].thisYear1, data[0].thisYear2, data[0].thisYear3];
                ech4('echarts4', '数据趋势', '能耗', echarts4DataX, echarts4DataY, 'bar', 'kW·h', "#0e62c7");

                var a5 = [0.0, 4.5, 0.0, -100.0, 0.0];
                var data = a5;
                var dataX = ["当月能耗", "上月能耗", "去年同期"];
                var dataY = [data[0], data[1], data[2]];
                ech('echarts1', '能耗分析', '能耗', dataX, dataY, 'bar', 'kW·h', "#68b928");

            })


        </script>




    </head>
    <body>
        <h1>Hello World!</h1>

        <div id="echarts2" style="height:400px; width: 400px">
        </div>

        <div id="echarts3" style="height:400px; width: 600px">
        </div>     

        <div id="echarts4" style="height:400px; width: 600px">
        </div>   

      <div id="echarts1" style="height:400px; width: 600px">
        </div>   
        <!--<script src="http://echarts.baidu.com/build/dist/echarts.js"></script>-->


        <script type="text/javascript">

        </script>      


    </body>
</html>
