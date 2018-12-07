<%-- 
    Document   : ecchart
    Created on : 2018-8-1, 11:12:39
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tld/fn.tld" prefix="fn" %>

<!--<!DOCTYPE html>-->
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="echarts/dist/echarts_3.8.5_echarts.min.js"></script>
        <script src="js/chart/chart.js"></script>
        <script type="text/javascript" src="js/genel.js"></script>
        <style>
            @charset "utf-8";
            .yc{ color: red;}
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
                /*                width: 18%;*/
                width: 260px;
                margin-left: 3%;
                height: 90%;

            }
            .topLeftOneBox {
                overflow: visible;
                width: 100%;
                height: 24%;
                margin-top: 1%;
            }
            .topLeftOneBox2 {
                overflow: visible;
                width: 100%;
                height: 25%;
                margin-top: 1%;
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
                width: 180px;
                padding-top: 8%;
            }
            .Mess1 {
                float: left;
                display: inline;
                height: 100%;
                width: 180px;
                padding-top: 4%;
            }
            .Mess2 {
                float: left;
                display: inline;
                height: 100%;
                width: 180px;
                padding-top: 0;
            }
            .Mess span {
                display: block;
                color: #666666;
                font-size: 16px;
            }
            .Mess1 span {
                display: block;
                color: #666666;
                font-size: 16px;
            }
            .Mess2 span {
                display: block;
                color: #666666;
                font-size: 16px;
            }
            .topCenter1 {
                /*                overflow: hidden;*/
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
                /*                height: 20%;*/
                line-height: 30px;
                color: gray;
            }
            .nenghao1 {
                width: 100%;
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
                width: 9%;
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
                width: 40%;
                height: 95%;
                float: left;
                /*                float: right;*/
                display: inline;
                margin-top: 20px;
                /*                margin-left: 20px;*/
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

            .info{
                background-color:  #bdebee;
            }
            /*# sourceMappingURL=home.css.map */

        </style>

        <script>
            var myChart, myChart2, myChart3, myChart4, myChart5;
            var echarts;
            var lang = '${param.lang}';
            var langs1 = parent.parent.getLnas();
            var pid = parent.parent.getpojectId();
            $(function () {

                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);

                }
                var gzdj = 0;   //异常灯具数
                $.ajax({async: false, url: "login.mainsub.alllamp.action", type: "get", datatype: "JSON", data: {pid: pid},
                    success: function (data) {
                        var list = data.rs;
                        if (list.length > 0) {
                            for (var i = 0; i < list.length; i++) {
                                var obj = list[i];
                                if (obj.f_Isfault == 1) {
                                    gzdj = gzdj + 1;
                                } else {
                                    var obj2 = {};
                                    obj2.f_comaddr = obj.l_comaddr;
                                    obj2.l_factorycode = obj.l_factorycode;
                                    $.ajax({async: false, url: "login.lightval.isfault.action", type: "get", datatype: "JSON", data: obj2,
                                        success: function (data) {
                                            var list = data.rs;
                                            if (list.length > 0) {
                                                gzdj = gzdj + 1;
                                            }
                                        },
                                        error: function () {
                                            alert("提交失败！");
                                        }
                                    });

                                }
                            }
                        }
                    },
                    error: function () {
                        alert("提交失败！");
                    }
                });
                var truevalmap = "";
                var status1 = "";
                var planvalue = "";
                var atualvalue = "";
                var date = new Date;
                var year = date.getFullYear();
                var month = date.getMonth() + 1;

                var wgsum = ${rs[0].num}; //网关总数
                var wgzx = ${onlineNumber[0].num};  //网关在线数
                var wglx = wgsum - wgzx;  //网关不在线数
                // var gzdj = ${djgzs[0].num};  //灯具异常数
                var djzxs = ${djzxs[0].num}; //灯具在线数
                var lampNumber = ${lampNumber[0].num};  //灯具总数
                var djlxs = lampNumber - gzdj - djzxs;  //灯具离线数
                $("#wsum").html(langs1[494][lang] + ":" + wgsum);  //网关总数
                $("#wonlin").html(langs1[284][lang] + ":" + wgzx);  //网关在线
                $("#wlin").html(langs1[285][lang] + ":" + wglx);   //网关离线
                $("#lampNumber").html(langs1[493][lang] + ":" + lampNumber);   //灯具总数
                $("#lonlin").html(langs1[284][lang] + ":" + djzxs);//灯具在线数
                $("#llin").html(langs1[285][lang] + ":" + djlxs);  //灯具离线
                $("#lyc").html(langs1[286][lang] + ":" + gzdj);  //异常灯具
                if (gzdj > 0) {
                    $("#lyc").css("color", "red");
                }
                if ((${ybsdj[0].num-djgzs[0].num} - djlxs) <= 0) {
                    $("#ldl").html("0%");
                } else {
                    var ldl = ((${ybsdj[0].num} - gzdj) /${ybsdj[0].num}) * 100;
                    $("#ldl").html(ldl.toFixed(2) + "%");
                }
                //计划能耗
            <c:if test="${fn:length(rs4)==0}">
                planvalue = "";
            </c:if>
            <c:if test="${fn:length(rs4)>0}">
                planvalue = ${rs4[0].power eq null?"":rs4[0].power};
            </c:if>

            <c:if test="${fn:length(rs3)==0 }">
                atualvalue = 0;
            </c:if>
            <c:if test="${fn:length(rs3)==1 }">
                atualvalue =${rs3[0].mpower==NULL?0.00:rs3[0].mpower};

            </c:if>

                var fplanpower = parseFloat(planvalue); //计划能耗
                var fatualpower = parseFloat(atualvalue);
                var diffpower = fplanpower - fatualpower;
                $("#actualConsumption").html(atualvalue);
                diffpower = isNaN(diffpower) == true ? 0 : diffpower;

                $("#differenceConsumption").html(diffpower.toFixed(2));
                var status = diffpower < 0 ? langs1[286][lang] : langs1[13][lang];    //异常、正常
                $("#status").html(status);

                var jnl = 1 - fatualpower / fplanpower
                jnl = isNaN(jnl) == true ? 0 : jnl;
                $("#jnl").html((jnl * 100).toFixed(2) + "%");


                var aa = new Array();
                var obj = new Object();
                obj.Month = month;
                obj.plan_value = fplanpower;
                obj.num = fatualpower;
                obj.status = status;
                aa.push(obj);
                var data = aa;
                var pieData = [{value: data[0].plan_value, name: langs1[9][lang]}, {value: data[0].num, name: langs1[10][lang]}];  //计划能耗、实际能耗
                pieChart("echarts2", "", pieData, langs1[27][lang]);  //用能计划
            });


            $(function () {

                var a3 = new Array();
                var o3 = new Object();
                var date = new Date;
                var year = date.getFullYear();
                var month = date.getMonth() + 1;
                var yearobj = {};
                yearobj[year] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                yearobj[year - 1] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                yearobj[year - 2] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
                var yearbar = {};
                yearbar[year] = 0;
                yearbar[year - 1] = 0;
                yearbar[year - 2] = 0;
            <c:forEach items="${rs6}" var="t">
                var y = ${t.y};
                var m = ${t.m};

                var power =${t.val==null?0.00:t.val};
                console.log(power);
                if (yearobj.hasOwnProperty(y.toString())) {
                    yearobj[y.toString()][m - 1] = parseFloat(power);
                    yearbar[y.toString()] += power;
                }
            </c:forEach>
                console.log(yearbar);
                var a3 = new Array();
                var o3 = new Object();
                var titlearr = [];

                for (x in yearobj)
                {
                    titlearr.push(x);
                }
                o3.thisYear3 = yearobj[year];
                o3.thisYear2 = yearobj[year - 1];
                o3.thisYear1 = yearobj[year - 2];
//                console.log(o3);
                a3.push(o3);
                var data = a3;
                var dataTitleArray = titlearr;
                var echarts3DataX = ["1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"];
                var numberY0 = data[0].thisYear1;
                var numberY1 = data[0].thisYear2;
                var numberY2 = data[0].thisYear3;
//                echarts3("echarts3", "横向对比分析", dataTitleArray, echarts3DataX, dataTitleArray[0], numberY0, dataTitleArray[1], numberY1, dataTitleArray[2], numberY2, "kW·h");


                var a4 = new Array();
                var o4 = new Object();
                o4.thisYear3 = Math.floor(yearbar[year] * 100) / 100;
                o4.thisYear2 = Math.floor(yearbar[year - 1] * 100) / 100;
                o4.thisYear1 = Math.floor(yearbar[year - 2] * 100) / 100;
                o4.date3 = year;
                o4.date2 = year - 1;
                o4.date1 = year - 2;
//                console.log(o4);
                a4.push(o4);
                var data = a4;
//                var echarts4DataX = [data[0].date1, data[0].date2, data[0].date3];
//                var echarts4DataY = [data[0].thisYear1, data[0].thisYear2, data[0].thisYear3];
                //var sjqs = $("#16").html();
                // ech4('echarts4', langs1[16][lang], langs1[302][lang], echarts4DataX, echarts4DataY, 'bar', 'kW·h', "#337dd7"); //数据趋势、能耗


                var date = new Date();
                var year1 = date.getFullYear();
                var year2 = year1 - 1;
//                var month1 = date.getMonth() + 1;
//                var month2 = month1 - 1;
                var thisM = langs1[18][lang];  //本月耗能
                var latM = langs1[19][lang];  //上月耗能
                var latY = langs1[21][lang];  //去年同期
                var dataX = [thisM, latM, latY];

                var nowmonth = yearobj[year.toString()][month - 1]; //Math.floor(yearobj[year.toString()][month - 1] * 100) / 100;  //当月
                var premonth = yearobj[year.toString()][month - 2]; //Math.floor(yearobj[year1.toString()][month2 - 1] * 100) / 100;  //前个月

                var preyear = yearobj[(year - 1).toString()][month - 1];          //Math.floor(yearobj[year2.toString()][month1 - 1] * 100) / 100;  //去年当月
                var dataY = [nowmonth, premonth, preyear];
                var nhfx = langs1[17][lang];//能耗分析
                ech('echarts1', nhfx, '能耗', dataX, dataY, 'bar', 'kW·h', "#68b928");

                $("#benyue").html(nowmonth);
                $("#shangyue").html(premonth);
                var huanbi = nowmonth - premonth;
                var hh = Math.floor(huanbi * 100) / 100;
                $("#lastMonth").html(hh);
                var qiantb = nowmonth - preyear;
                qiantb = Math.floor(qiantb * 100) / 100;
                $("#lastYearSameMonth").html(qiantb);

                $("#qunian").html(preyear);
                $('#gayway').on('click-row.bs.table', function (row, element) {

                    var l_comaddr = element.comaddr;
                    $("#head").html("[" + element.name + ":" + element.comaddr + "]");
                    $("#headtime").html(langs1[428][lang] + ":xx:xx &nbsp;" + langs1[429][lang] + ":xx:xx");

                    var fmobj = $("#forminfo").serializeObject();
                    for (let attr in fmobj) {
                        var str = "input[name='" + attr + "']";
                        $(str).val("");
                    }
                    $("#l_comaddr").val(l_comaddr);
                    if (element.online != 1) {
                        return;
                    }
                    var obj = {};
                    obj.l_comaddr = l_comaddr;
                    var vv = [];
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 602, vv); //01 03 F24   
                    dealsend("AC", data, 602, "collectinfo", l_comaddr, 0, 0, 0, 0);
                    hittable(l_comaddr);

                });

                setInterval('getcominfo()', 3000);
            });

            function  hittable(comaddr) {
                $.ajax({async: false, url: "loop.loopForm.getloopway.action", type: "get", datatype: "JSON", data: {l_comaddr: comaddr},
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length > 0) {
                            var info = rs[0];
                            var worktype = info.l_worktype;

                            if (worktype == 0) {   //时间表
                                $("#headtime").html(langs1[428][lang] + ":" + info.l_intime  + "&nbsp;" + langs1[429][lang] + ":" + info.l_outtime );
                            } else if (worktype == 1) {  //经纬度
                                var o1 = {jd: info.longitude, wd: info.latitude};
                                var outoffset = parseInt(info.outoffset);
                                console.log(outoffset);
                                var inoffset = parseInt(info.inoffset);
                                console.log(inoffset);
                                if (o1.jd == "" || o1.wd == "" || o1.jd == null || o1.wd == null) {
                                    return;
                                }
                                $.ajax({async: false, url: "login.rc.r.action", type: "get", datatype: "JSON", data: o1,
                                    success: function (data) {
                                        var list = data.cl[0];
                                        var rcarr = list.rc.split(":");
                                        console.log(rcarr);
                                        //var min1 = rcarr[0] * 60 + rcarr[1] + outoffset;
                                        var min1 = parseInt(rcarr[0]) * 60 + parseInt(rcarr[1]) + outoffset;

                                        var h1 = parseInt(min1 / 60);
                                        var m1 = min1 % 60;


                                        var rlarr = list.rl.split(":");
                                        console.log(rlarr);
                                        var min2 = parseInt(rlarr[0]) * 60 + parseInt(rlarr[1]) + inoffset;

                                        var h2 = parseInt(min2 / 60);
                                        var m2 = min2 % 60;
                                        if(h1<10){
                                            h1 = "0"+h1;
                                        }
                                        if(m1<10){
                                            m1 = "0"+m1;
                                        }
                                        if(h2<10){
                                            h2 = "0"+h2;
                                        }
                                        if(m2<10){
                                            m2 = "0"+m2;
                                        }
                                        var outtime = h1.toString() + ":" + m1.toString();
                                        var intime = h2.toString() + ":" + m2.toString();
                                        

                                        $("#headtime").html(langs1[428][lang] + ":" + intime + "&nbsp;" + langs1[429][lang] + ":" + outtime);
                                    },
                                    error: function () {
                                        //  alert("提交失败！2");
                                    }
                                });
                            }
                        }
                    },
                    error: function () {
                        //  alert("提交失败！3");
                    }
                });
            }
            function readlooptimeCB(obj) {

                console.log(obj);
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {

                    v = v + sprintf("%02x", data[i]) + " ";
                }
                if (obj.status == "success") {
                    if (obj.fn == 320) {
                        var m = sprintf("%02x", data[21]);
                        var h = sprintf("%02x", data[22]);
                        var m1 = sprintf("%02x", data[23]);
                        var h1 = sprintf("%02x", data[24]);
                        var intime1 = sprintf("%s:%s", h, m);
                        var outtime1 = sprintf("%s:%s", h1, m1);
                        $("#headtime").html(langs1[428][lang] + ":" + intime1 + "&nbsp;" + langs1[429][lang] + ":" + outtime1);
                    }
                }
            }
            function getcominfo() {

                var obj = $("#forminfo").serializeObject();
                var o1 = {pid: "${param.pid}", comaddr: obj.l_comaddr};
                $.ajax({async: false, url: "gayway.GaywayForm.info.action", type: "get", datatype: "JSON", data: o1,
                    success: function (data) {
                        var rs = data.rs;
                        if (rs.length == 1) {
                            var info = rs[0].energyinfo;
                            if (isJSON(info)) {
                                var o = eval('(' + info + ')');
                                var fmobj = $("#forminfo").serializeObject();
                                for (let attr in fmobj) {
                                    var str = "input[name='" + attr + "']";
                                    if (attr.charAt(attr.length - 1) == "*") {
                                        var temp = attr.replace("*", "");
                                        var p = (o[temp] * 1000).toFixed(2);
                                        $(str).val(p);
                                    } else if (attr.charAt(attr.length - 1) == "#") {
                                        //计算有功功率和无功功率
                                        var multpower = rs[0].multpower;
                                        if (multpower == "" || multpower == null || multpower == 0) {
                                            multpower = 1;
                                        }
                                        var temp = attr.replace("#", "");
                                        var p = (o[temp] * 1000 * multpower).toFixed(2);
                                        $(str).val(p);
                                    } else if (attr.charAt(attr.length - 1) == "@") {
                                        var multpower = rs[0].multpower;
                                        if (multpower == "" || multpower == null || multpower == 0) {
                                            multpower = 1;
                                        }
                                        var temp = attr.replace("@", "");
                                        var p = (o[temp] * multpower).toFixed(2);
                                        $(str).val(p);
                                    } else {
                                        $(str).val(o[attr]);
                                    }
                                }
                            }


                        }
                    },
                    error: function () {
                        //alert("提交失败！1");
                    }
                });

            }
            window.onresize = function () {

                myChart.resize();

                myChart2.resize();

            };
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
                //var vvv = document.getElementById(id);
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
                            name: langs1[303][lang], //访问来源
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
                console.log(obj);
                var count = obj.count;
                var a = count /${rs5[0].count} * 100;
                var str = a.toString() + '%';
                $('#online').html(str);
            }

            function  formartcomaddr(value, row, index, field) {
                var val = value;
                console.log(index);
                if (index == 0) {
                    var l_comaddr = row.comaddr;

                    $("#head").html("[" + row.name + ":" + row.comaddr + "]");
                    $("#l_comaddr").val(l_comaddr);
                    if (row.online == 1) {
                        var vv = [];
                        // var num = randnum1(0, 9) + 0x70;
                        var num = 0;
                        // aaa();
//                        var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 602, vv); //01 03 F24   
//                        dealsend("AC", data, 602, "collectinfo", l_comaddr, 0, 0, 0);
                    }
                    //hittable(l_comaddr);
////                    console.log(l_comaddr);
//
                }
                var v1 = row.online == 1 ? "&nbsp;<img src='img/online1.png'>" : "&nbsp;<img src='img/off.png'>";
                return   v1;
            }

            function collectinfo(obj) {
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {

                    v = v + sprintf("%02x", data[i]) + " ";
                }
                console.log(v);
            }
//            function   rowstyle(row,index){
//              
//                return row;
//            }

        </script>

        <style type="text/css">
            table.hovertable {
                font-family: verdana,arial,sans-serif;
                font-size:12px;
                color:#333333;
                border-width: 1px;
                border-color: #999999;
                border-collapse: collapse;
                margin-top: 5px;
            }
            table.hovertable th {
                background-color:#c3dde0;
                border-width: 1px;
                padding: 8px;
                border-style: solid;
                border-color: #a9c6c9;
            }
            table.hovertable tr {
                background-color:#ffff66;
            }
            table.hovertable td {
                border-width: 1px;
                padding: 8px;
                border-style: solid;
                border-color: #a9c6c9;

            }
            table.hovertable tr:hover{
                background-color: #d4e3e5;
            }

            table.hovertable tr td span{
                font-size: 14px;
            }
            table.hovertable tr th{
                font-size: 16px;
                vertical-align: middle;
                text-align: center; 
            }
        </style>
    </head>


    <body>
        <div class="top" style="width:100%;height:450px;position:relative; margin-top: 10px;">
            <div class="topTitle" style="position:absolute;top:2%;left:2%;color:#000;font-size:20px;font-weight:600;">
                <span id="5" name="xxx">设备分析</span>
                <!-- 设备分析-->
            </div>
            <div class="topLeft" style="height:400px;padding-top:0px; margin-top: 40px;">
                <div class="topLeftOneBox">
                    <span class="redius" style="background:#fdd237;">
                        <img src="img/dp.png"></span>
                    <div class="Mess lightingRate">
                        <span id="ldl">0.00%</span>
                        <span name="xxx" id="6"> 亮灯率</span>
                    </div>
                </div>
                <div class="topLeftOneBox">
                    <span class="redius" style="background: lawngreen;"><img src="img/jien.png"></span>
                    <div class="Mess energySavingRate">
                        <span id="jnl"></span>
                        <span name="xxx" id="7">节能率</span>
                    </div>
                </div>
                <div class="topLeftOneBox">
                    <span class="redius" style="background:#42bcec;"><img src="img/jien.png"></span>
                    <div class="Mess1 energySavingRate">
                        <span id="wsum">集控器数量：0</span>
                        <!--                        <span style="font-size: 14px;" id="wgms"></span>-->
                        <span id="wonlin">在线：0</span>
                        <span id="wlin">离线：0</span>
                    </div>
                </div>
                <div class="topLeftOneBox2">
                    <span class="redius" style="background: #bdebee;"><img src="img/dp.png"></span>
                    <div class="Mess2 energySavingRate">
                        <span id="lampNumber">灯具数量：0</span>
                        <!--                        <span style="font-size: 14px;" id="djms"></span>-->
                        <span id="lonlin">在线：0</span>
                        <span id="llin">离线：0</span>
                        <span id="lyc">异常：0</span>
                    </div>
                </div>
            </div>

            <!--用能计划-->
            <div class="topTitle" style="position:absolute;top:2%;left:24%;color:#000;font-size:20px;font-weight:600;">
                <!--用能计划-->
                <span id="27" name="xxx">用能计划</span>

                <br><br>
                <span style="color:#777;font-size:18px;font-weight:500;">
                    <!--单位-->
                    <span id="8" name="xxx">单位</span>
                    ：kW·h</span>
            </div>
            <div class="topCenter3" id="echarts2"  style="height: 400px;">    

            </div>
            <div class="topCenter3Mess" style="height:400px;" >

                <div class="topCenter3MessMM" style="margin-top:40%;">
                    <div class="first">
                        <span class="subPara">
                            <!-- 计划能耗-->
                            <span id="9" name="xxx">计划能耗</span>
                            ：</span>
                        <span class="paraValue" id="planConsumption">${rs4[0].power}</span>
                    </div>
                    <!-- <div class="second"></div> -->
                    <div class="first">
                        <span class="subPara">
                            <!--实际能耗-->
                            <span id="10" name="xxx">实际能耗</span>
                            ：</span>
                        <span class="paraValue" id="actualConsumption">

                        </span>
                    </div>
                    <!-- <div class="second">1000</div> -->
                    <div class="first">
                        <span class="subPara">
                            <!--差值-->
                            <span id="11" name="xxx">差值</span>
                            ：</span>
                        <span class="paraValue" id="differenceConsumption"></span>
                    </div>
                    <!-- <div class="second">250</div> -->
                    <div class="first">
                        <span class="subPara">
                            <!-- 状态-->
                            <span name="xxx" id="12">状态</span>
                            ：</span>
                        <span class="subPara" id="status">

                        </span>
                    </div>

                </div>
            </div>
            <div class="topTitle" style="position:absolute;top:2%;left:60%;color:#000;font-size:20px;font-weight:600;">
                <!--                <span id="17" name="xxx"></span>-->
            </div>
            <div class="topCenter1" id="echarts1" style="width: 27%; height: 85%; float: left;">

            </div>
            <div class="topCenter4" style=" width: 9%; height:85%;float:left;margin-left: 1%; font-size: 0.9em;">
                <div class="topCenter2Mess">	
                    <div class="nenghao">
                        <span class="subPara">
                            <span name="xxx" id="18">本月耗能</span>
                            :</span><br>
                        <span id="benyue" class="paraValue"></span>kW</div>
                    <div class="nenghao1">
                        <span class="subPara">
                            <span id="19" name="xxx">上月耗能</span>
                            :</span><br>
                        <span id="shangyue" class="paraValue"></span>kW
                    </div>
                    <div class="nenghao1" >
                        <span><span id="20" name="xxx">环比</span>：</span><br>
                        <span class="tongbi" id="lastMonth" style=" font-size: 16px;"></span>
                        kW
                    </div>
                    <div class="nenghao1">
                        <span class="subPara">
                            <span id="21" name="xxx">去年同期</span>
                            :</span><br>
                        <span id="qunian" class="paraValue">0</span>kW  
                    </div>
                    <div class="nenghao1">
                        <span>
                            <span id="22" name="xxx">同比</span>
                            ：</span><br>
                        <span class="tongbi" id="lastYearSameMonth" style=" font-size: 16px;"></span>
                        kW·h
                    </div>
                </div>
            </div> 
        </div>


        <div class="bottom1">

            <div class="row "   >
                <div class="col-xs-2 "  >
                    <table id="gayway" style="width:100%;"   data-toggle="table" 
                           data-height="400"
                           data-single-select="true"
                           data-striped="true"
                           data-click-to-select="true"
                           data-search="false"
                           data-checkbox-header="true"
                           data-show-header='false'
                           data-search-align='right'
                           data-silent-sort='true'
                           data-row-style="rowstyle"
                           data-url="gayway.GaywayForm.getComaddrList.action?pid=${param.pid}&page=ALL"  >
                        <thead >
                            <tr >
                                <th data-width="5" data-field="online"  data-formatter='formartcomaddr'   >在线状态</th>
                                <!-- <th data-width="60" data-align="center"  data-field="comaddr"   >网关地址</th>-->

                                <!--<th data-width="25"  data-visible="true"   data-select="false" data-align="center"  data-checkbox="true"  ></th>-->
                                <th data-width="100" data-field="name" data-align="center"    >网关名称</th>
                            </tr>
                        </thead>       

                    </table>
                    <!--                    </div>
                                    </div>    -->

                </div>
                <div class="col-xs-10">


                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <p  >
                                    <span id="head" style="font-size: 18px;"></span>
                                    <span style=" margin-left: 10px; font-size: 18px;" id="headtime">
                                        <span name="xxx" id="428"   >开灯时间</span>
                                        :xx:xx &nbsp; 
                                        <span name="xxx" id="429"   >关灯时间</span>
                                        :xx:xx</span>
                                </p>
                            </h3>
                        </div>
                        <div class="panel-body" style=" height: 360px;" align="center">
                            <form id="forminfo">
                                <input type="hidden" id="l_comaddr" name="l_comaddr" />
                                <table class="hovertable" style=" text-align: center;" >
                                    <tr>
                                        <th colspan="2"><span name="xxx" id="495">有功功率</span>(W)</th>
                                        <th colspan="2"><span name="xxx" id="496">无功功率</span>(W)</th>
                                        <th colspan="2"><span name="xxx" id="497">视在功率</span>(VA)</th>
                                        <th colspan="2"><span name="xxx" id="498">功率因数</span></th>
                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="499">A相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="aactpwr#"/></td>
                                        <td><span name="xxx" id="499">A相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="anopwr#"/></td>
                                        <td><span name="xxx" id="499">A相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="aviewpwr#"/></td>
                                        <td><span name="xxx" id="499">A相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="apwrfactor"/></td>

                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="500">B相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="bactpwr#"/></td>
                                        <td><span name="xxx" id="500">B相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="bnopwr#"/></td>
                                        <td><span name="xxx" id="500">B相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="bviewpwr#"/></td>
                                        <td><span name="xxx" id="500">B相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="bpwrfactor"/></td>
                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="501">C相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="cactpwr#"/></td>
                                        <td><span name="xxx" id="501">C相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="cnopwr#"/></td>
                                        <td><span name="xxx" id="501">C相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="cviewpwr#"/></td>  
                                        <td><span name="xxx" id="501">C相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="cpwrfactor"/></td>
                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="436">总有功功率</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="sumactpwr#"/></td>
                                        <td><span name="xxx" id="437">总无功功率</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="sumnopwr#"/></td>
                                        <td><span name="xxx" id="438">总视在功率</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="sumviewpwr#"/></td>
                                        <td><span name="xxx" id="109">总功率因数</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="pwrfactor"/></td> 
                                    </tr>
                                    <tr>
                                        <th colspan="2"><span name="xxx" id="95">电压</span>(V)</th>
                                        <th colspan="2"><span name="xxx" id="96">电流</span>(A)</th>
                                        <th colspan="2"><span name="xxx" id="502">有功电能量</span>(kWh)</th>
                                        <th colspan="2"><span name="xxx" id="503">无功电能量</span>(kvarh)</th>
                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="499">A相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="avol"/></td>
                                        <td><span name="xxx" id="499">A相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="aelectric@"/></td>
                                        <td><span name="xxx" id="448">正向有功总电能量</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="actenergy@"/></td>
                                        <td><span name="xxx" id="449">正向无功总电能量</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="reactenergy@"/></td>  
                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="500">B相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="bvol"/></td>
                                        <td><span name="xxx" id="500">B相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="belectric@"/></td>
                                        <td><span name="xxx" id="450">反向有功总电能量</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="diractenergy@"/></td>  
                                        <td><span name="xxx" id="451">反向无功总电能量</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="dirreactenergy@"/></td>  
                                    </tr>
                                    <tr>
                                        <td><span name="xxx" id="501">C相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="cvol"/></td> 
                                        <td><span name="xxx" id="501">C相</span></td>
                                        <td><input type="text" readonly="true" class="form-control" style="width:100px; height: 22px "  name="celectric@"/></td> 
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>

                                </table>   

                            </form>
                        </div>
                    </div>              
                </div>
            </div>
        </div>			
    </body>
</html>
