<%-- 
    Document   : echarts1
    Created on : 2018-8-2, 9:45:34
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://cdn.bootcss.com/echarts/3.8.5/echarts.min.js"></script>
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>

        <div id="main" style="width:600px;height:160px;border:2px solid green;"></div>
        <script>
            function Pie(name, CinArray, divId, colorL) {
                // 基于准备好的dom，初始化echarts实例
                var NameArray = CinArray.map(function (cinarray) {
                    return cinarray.name;
                }),
                        DataArray = CinArray.map(function (cinarray) {
                            return cinarray.value;
                        });
                var myChart = echarts.init(document.getElementById(divId));

                // 指定图表的配置项和数据
                option = {
                    title: {//标题设置‘参保情况’
                        x: 'center', //标题位置
                        text: name, //传入标题名称‘参保情况’
                        textStyle: {//标题字体颜色等设置
                            fontSize: 16,
                            fontWeight: 'bold'
                        }
                    },
                    tooltip: {//鼠标hover覆盖提示框
                        show: 'true', //可视
                        trigger: 'item', //根据item提示信息
                        formatter: "{a} <br/>{b}: {c} ({d}%)"//提示内容
                    },
                    legend: {//位于右侧的属性按钮
                        orient: 'vertical', //竖直放置
                        icon: 'circle', //图标为圆形，默认是方形
                        align: 'auto',
                        itemGap: 6, //两个属性的距离
                        itemWidth: 8, //图标的宽度，对应有itemHeight为高度,圆形只有半径
                        x: '60%', //距离左侧位置
                        y: '45%', //距离上面位置
                        data: NameArray, //属性名称‘已参保’，‘未参保’
                        align: 'left', //图标与属性名的相对位置，默认为right，即属性名在左，图标在右
                        selectedMode: true, //可选择
                        formatter: function (v) {
                            return v;
                        },
                        textStyle: {//属性名的字体样式设置
                            fontSize: 10,
                            color: '#666'
                        }
                    },
                    series: [{//饼状图设置
                            name: name, //设置名称，跟数据无相关性
                            type: 'pie', //类型为饼状
                            radius: ['50%', '70%'], //内圈半径，外圈半径
                            center: ['50%', '55%'], //饼状图位置，第一个参数是左右，第二个是上下。
                            avoidLabelOverlap: false,
                            hoverAnimation: false, //鼠标悬停效果，默认是true
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
                                    show: true
                                }
                            },
                            data: CinArray, //对应数据
                            itemStyle: {//元素样式
                                normal: {
                                    //柱状图颜色  
                                    color: function (params) {//对每个颜色赋值
                                        // 颜色列表  
                                        var colorList = colorL;
                                        //返回颜色  
                                        return colorList[params.dataIndex];
                                    },

                                },
                                emphasis: {

                                }
                            }
                        }]
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);
            }
            var cin = [{name: '已参保', value: 80}, {name: '未参保', value: 80}];
            var color = ['rgb(30, 144, 255)', 'rgb(233, 105, 8)', 'rgb(0, 105, 8)'];
            Pie('参保情况', cin, 'main', color);
            //myChart.setOption(option);

        </script>  




    </body>
</html>
