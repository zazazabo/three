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

        <style>

            .btn { margin-left: 20px;}
        </style>

        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript" src="js/getdate.js"></script>
        <script>
            var u_name = parent.parent.getusername();
            var o_pid = parent.parent.getpojectId();
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            function isValidIP(ip) {
                var reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
                return reg.test(ip);
            }

            function setPowerCB(obj) {
                if (obj.status == "success") {
                    layerAler(langs1[377][lang]);   //设置成功
                }
            }
            function setPower() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var reg = /^(\d{3})+(\.\d{1})+$/;
                if (reg.test(obj.voltage) == false) {
                    layerAler(langs1[476][lang]);  //电压限值格式为:xxx.x x为数字
                    return;
                }
                var reg = /^(\d{3})+(\.\d{3})+$/;
                if (reg.test(obj.electric) == false) {
                    layerAler(langs1[477][lang]);   //电流限值格式为:xxx.xxx
                    return;
                }

                var reg = /^(\d{1})+(\.\d{3})+$/;
                if (reg.test(obj.powerfactor) == false) {
                    layerAler(langs1[478][lang]);  //功率因数限值格式为:x.xxx
                    return;
                }

                var reg = /^(\d{1,3})$/;
                if (reg.test(obj.power) == false) {
                    layerAler(langs1[479][lang]);   //倍率为0到256
                    return;
                }
                if (parseInt(obj.power) > 256) {
                    layerAler(langs1[479][lang]);   //倍率为0到256
                    return;
                }

                var vol = obj.voltage
                vol = vol.replace(".", "");
                var volarr = Str2BytesH(vol);


                var elec = obj.electric
                elec = elec.replace(".", "");
                var elecarr = Str2BytesH(elec);

                var factor = obj.powerfactor
                factor = factor.replace(".", "");
                var factorarr = Str2BytesH(factor);


                var vv = [];
                vv.push(volarr[1]);
                vv.push(volarr[0]);
                vv.push(elecarr[2]);
                vv.push(elecarr[1]);
                vv.push(elecarr[0]);
                vv.push(factorarr[1]);
                vv.push(factorarr[0]);
                vv.push(parseInt(obj.power));
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFF, num, 0, 8, vv); //01 03 F24   

                dealsend2("FF", data, 8, "setPowerCB", comaddr, 0, 0, 0, 0);


            }


            function  setTimeNowCB(obj) {
                if (obj.status == "success") {
                    layerAler(langs1[377][lang]);   //设置成功
                }
            }
            function setTimeNow() {
                var time = $('#nowtime').datetimebox('getValue');
                var myDate = new Date(time);

                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var y = sprintf("%d", myDate.getFullYear()).substring(2, 4);


                var m = sprintf("%d", myDate.getMonth() + 1);
                var d = sprintf("%d", myDate.getDate());
                var h = sprintf("%d", myDate.getHours());
                var mm = sprintf("%d", myDate.getMinutes());
                var s = sprintf("%d", myDate.getSeconds());

                console.log(m);
                var vv = [];
                vv.push(parseInt(s, 16));
                vv.push(parseInt(mm, 16));
                vv.push(parseInt(h, 16));
                vv.push(parseInt(d, 16));
                vv.push(parseInt(m, 16));
                vv.push(parseInt(y, 16));

                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 340, vv); //01 03 F24   
                dealsend2("A5", data, 340, "setTimeNowCB", comaddr, 0, 0, 0, 0);

                console.log(myDate);
            }
            function  readPowerCB(obj) {
                if (obj.status == "success") {
                    if (obj.msg == "FE" && obj.fn == 8) {
                        var data = Str2BytesH(obj.data);
                        var v = "";
                        for (var i = 0; i < data.length; i++) {

                            v = v + sprintf("%02x", data[i]) + " ";
                        }
                        console.log(v);
                        var z = 18;
                        //电压超限值
                        var bw = data[z + 1] >> 4 & 0xf;
                        var sw = data[z + 1] & 0x0f;
                        var gw = data[z] >> 4 & 0x0f;
                        var fw = data[z] & 0x0f;
                        var voltage = sprintf("%d%d%d.%d", bw, sw, gw, fw);
                        $("#voltage").val(voltage);

                        //电流超限值
                        z = z + 2;
                        var bw = data[z + 2] >> 4 & 0xf;
                        var sw = data[z + 2] & 0x0f;
                        var gw = data[z + 1] >> 4 & 0x0f;
                        var sfw = data[z + 1] & 0x0f;
                        var bfw = data[z] >> 4 & 0x0f;
                        var qfw = data[z] & 0x0f;
                        var electric = sprintf("%d%d%d.%d%d%d", bw, sw, gw, sfw, bfw, qfw);
                        $("#electric").val(electric);
                        //功率因数限值
                        z = z + 3
                        var gw = data[z + 1] >> 4 & 0xf;
                        var sfw = data[z + 1] & 0x0f;
                        var bfw = data[z] >> 4 & 0x0f;
                        var qfw = data[z] & 0x0f;
                        var powerfactor = sprintf("%d.%d%d%d", gw, sfw, bfw, qfw);
                        $("#powerfactor").val(powerfactor);
                        //电流互感变比
                        z = z + 2;
                        var power = sprintf("%02x", data[z]);
                        $("#power").val(power);
                        var vv1 = data[z];
                        console.log('变比:', vv1);
                    }
                }

            }
            function setNowtime() {
                var myDate = new Date();//获取系统当前时
                var y = myDate.getFullYear();
                var m = myDate.getMonth() + 1;
                var d = myDate.getDate();
                var h = myDate.getHours();
                var mm = myDate.getMinutes();
                var s = myDate.getSeconds();

                var str = y + "-" + m + "-" + d + " " + h + ":" + mm + ":" + s;
                console.log(str);
                $('#nowtime').datetimebox('setValue', str);

            }
            function readpower() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFE, num, 0, 8, vv); //01 03 F24   
                dealsend2("FE", data, 8, "readPowerCB", comaddr, 0, 0, 0, 0);
            }
            function gettodaypowerCB(obj) {
                var data = Str2BytesH(obj.data);
                var v = "";
                for (var i = 0; i < data.length; i++) {

                    v = v + sprintf("%02x", data[i]) + " ";
                }
                var row = [];
                var z = 0;
                for (var i = 18; i < data.length - 2; i += 4)
                {
                    var sw = data[i + 3] >> 4 & 0x0f;
                    var w = data[i + 3] & 0x0f;
                    var q = data[i + 2] >> 4 & 0x0f;
                    var b = data[i + 2] & 0x0f;
                    var s = data[i + 1] >> 4 & 0x0f;
                    var g = data[i + 1] & 0x0f;
                    var sfw = data[i + 0] >> 4 & 0x0f;
                    var bfw = data[i + 0] & 0x0f;
                    var power = sprintf("%d%d%d%d%d%d.%d%d", sw, w, q, b, s, g, sfw, bfw);

                    var h = z * 15 / 60;
                    var m = z * 15 % 60;
                    var time = sprintf("%02d:%02d", h, m);
                    var ooo = {};
                    ooo.time = time;
                    ooo.power = power;
                    row.push(ooo);
                    z = z + 1;
                }
                var obj = {};
                obj.total = row.length;
                obj.row = row;
                console.log(obj);
                $("#powertable").bootstrapTable("load", row)
            }
            function  gettodaypower() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAC, num, 0, 502, vv); //01 03 F24   
                dealsend2("AC", data, 502, "gettodaypowerCB", comaddr, 0, 0, 0, 0);
            }
            function  resetCB(obj) {
                console.log(obj);
                if (obj.status = "success") {
                    layerAler("复位成功");
                }
            }
            function resetGayway() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x4, 0x01, num, 0, 1, vv); //01 03 F24   
                console.log(data);
                dealsend2("01", data, 1, "resetCB", comaddr, 0, 0, 0, 0);
            }
            function initdataCB(obj) {
                if (obj.status == "success") {
                    $.ajax({async: false, url: "gayway.GaywayForm.ClearData.action", type: "get", datatype: "JSON", data: {},
                        success: function (data) {

                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                    layerAler("初始化成功");
                }

            }
            function  initdata() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0x01, num, 0, 2, vv); //01 03 F24   
                dealsend2("01", data, 2, "initdataCB", comaddr, 0, 0, 0, 0);
            }

            function StartCheck() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                addlogon(u_name, "巡测", o_pid, "网关参数设置", "启动巡测任务", o.l_comaddr);
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 1, vv); //01 03 F24   
                dealsend2("A5", data, 1, "allCallBack", comaddr, 0, 0, 0, 0);
            }

            function StopCheck() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                addlogon(u_name, "巡测", o_pid, "网关参数设置", "结束巡测任务", o.l_comaddr);
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA5, num, 0, 2, vv); //01 03 F24   
                dealsend2("A5", data, 2, "allCallBack", comaddr, 0, 0, 0, 0);
            }


            function refleshgayway(obj) {
                var vv = [];
                var l_comaddr = "17020101";
                var num = randnum(0, 9) + 0x70;
                var data = ""
                dealsend2("CheckOnline", data, 1, "CheckOnline", l_comaddr, 0, 0, 0);
            }

            function readTrueTimeCB(obj) {
                if (obj.status == "success") {
                    var data = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < data.length; i++) {

                        v = v + sprintf("%02x", data[i]) + " ";
                    }

                    var yh = data[23] >> 4 & 0x0F;
                    var yl = data[23] & 0x0F;
                    var mh = data[22] >> 4 & 0x01;
                    var ml = data[22] & 0x0F;
                    var dh = data[21] >> 4 & 0x0F;
                    var dl = data[21] & 0x0F;
                    var hh = data[20] >> 4 & 0x0F;
                    var hl = data[20] & 0x0F;
                    var minh = data[19] >> 4 & 0x0F;
                    var minl = data[19] & 0x0F;
                    var sh = data[18] >> 4 & 0x0F;
                    var sl = data[18] & 0x0F;
                    var y = sprintf("20%d%d", yh, yl);
                    var m = sprintf("%d%d", mh, ml);
                    var d = sprintf("%d%d", dh, dl);
                    var h = sprintf("%d%d", hh, hl);
                    var min = sprintf("%d%d", minh, minl);
                    var s = sprintf("%d%d", sh, sl);
                    var timestr = sprintf("%s-%s-%s %s:%s:%s", y, m, d, h, min, s);
                    $("#gaytime").val(timestr);
                    console.log(timestr);
                }

            }
            function readTrueTime() {
                var o1 = $("#form1").serializeObject();
                var l_comaddr = o1.l_comaddr;
                var vv = [0];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(l_comaddr, 0x04, 0xAC, num, 0, 1, vv); //01 03
                dealsend2("AC", data, 1, "readTrueTimeCB", l_comaddr, 0, 0, 0);
            }

            function  setChgTimeCB(obj) {
                obj.id = obj.val;
                console.log(obj.domain)

                if (obj.status == "success") {
                    $.ajax({async: false, url: "param.param.updatesite.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                            var arrlist = data.rs;
                            if (arrlist.length == 1) {
                                layerAler(langs1[161][lang]); //读取站点信息成功
                                var opt = {
                                    url: "test1.f5.h1.action",
                                    silent: true,
                                    query: obj
                                };
                                $("#gravidaTable").bootstrapTable('refresh', opt);
                            }
                        },
                        error: function () {
                            alert("提交失败！");
                        }
                    });
                }

            }

            function allCallBack(obj) {
                if (obj.status == "success") {
                    //更换分组
                    if (obj.msg == "A4" && obj.fn == 110) {
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 1, l_groupe: obj.val};
                        // console.log(o);
                        $.ajax({async: false, url: "lamp.lampform.modifyAllgroup.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[162][lang]);   //更新灯具表组号失败
                                }

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[163][lang]); //更换分组成功

                    } else if (obj.msg == "A4" && obj.fn == 120) {
                        //更换工作方式
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 1, l_worktype: obj.val};
                        $.ajax({async: false, url: "lamp.lampform.modifyALLworktype.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[164][lang]); //更新灯具表工作模式失败
                                }
                                console.log(data);

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler("更换工作方式成功"); //更换工作方式
                    } else if (obj.msg == "A4" && obj.fn == 108) {
                        //删除所有灯配置
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 0};
                        $.ajax({async: false, url: "lamp.lampform.modifyAllDepayment.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[166][lang]); //更新灯具表部署状态失败
                                }
                                console.log(data);

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[167][lang]); //删除全部灯具信息成功
                    } else if (obj.msg == "A4" && obj.fn == 180) {
                        layerAler(langs1[168][lang]);  //删除全部灯时间表成功
                    } else if (obj.msg == "A4" && obj.fn == 340) {
                        //删除全部回路信息
                        var o = {l_comaddr: obj.comaddr, l_deplayment: 0};
                        $.ajax({async: false, url: "loop.loopForm.modifyAllDepayment.action", type: "get", datatype: "JSON", data: o,
                            success: function (data) {
                                if (data == null) {
                                    layerAler(langs1[169][lang]);  //更新回路表部署状态失败
                                }
                                console.log(data);

                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler(langs1[170][lang]);  //删除所有回路信息

                    } else if (obj.msg == "A4" && obj.fn == 402) {
                        layerAler(langs1[171][lang]);  //删除全部回路时间表成功
                    } else if (obj.msg == "FE" && obj.fn == 10) {
                        var data = Str2BytesH(obj.data);
                        var i = 18;
                        var wfw = data[i] & 0xf;
                        var qfw = data[i] >> 4 & 0xf;
                        var bfw = data[i + 1] & 0xf;
                        var sfw = data[i + 1] >> 4 & 0xf;
                        var gw = data[i + 2] & 0xf;
                        var sw = data[i + 2] >> 4 & 0xf;
                        var bw = data[i + 3] & 0xf;
                        var qw = data[i + 3] >> 4 & 0xf;
                        var jd = sprintf("%d%d%d%d.%d%d%d%d", qw, bw, sw, gw, sfw, bfw, qfw, wfw);
                        console.log(jd);
                        i = i + 4;
                        wfw = data[i] & 0xf;
                        qfw = data[i] >> 4 & 0xf;
                        bfw = data[i + 1] & 0xf;
                        sfw = data[i + 1] >> 4 & 0xf;
                        gw = data[i + 2] & 0xf;
                        sw = data[i + 2] >> 4 & 0xf;
                        bw = data[i + 3] & 0xf;
                        qw = data[i + 3] >> 4 & 0xf;
                        var wd = sprintf("%d%d%d%d.%d%d%d%d", qw, bw, sw, gw, sfw, bfw, qfw, wfw);
                        console.log(wd);
                        i = i + 4;
                        var outoffset = data[i];
                        var inoffset = data[i + 1];
                        i = i + 2;
                        var timezone1 = data[i];
                        var timezone2 = data[i + 1];
                        var str1 = sprintf("%02d", timezone2);
                        $("#Longitude").val(jd);
                        $("#latitude").val(wd);
                        $("#outoffset").val(inoffset);
                        $("#inoffset").val(inoffset);
                        $("#timezone").val(str1);
                        var str = timezone1 >> 4 & 0xf;
                        $("#areazone").combobox("select", str);
                    } else if (obj.msg == "FF") {
                        var val = obj.val;
                        var oo = {longitude: val.jd, latitude: val.wd, l_comaddr: obj.comaddr};
                        $.ajax({async: false, url: "loop.loopForm.editloopjwd1.action", type: "get", datatype: "JSON", data: oo,
                            success: function (data) {
                            },
                            error: function () {
                                alert("提交失败！");
                            }
                        });
                        layerAler("success");
                    }

                }
            }

            function readjwd() {

                var o = $("#form1").serializeObject();
                var comaddr = o.l_comaddr;
//                var obj = {};
//                obj.comaddr = comaddr;
//                $.ajax({async: false, url: "login.set.readTrueTime.action", type: "get", datatype: "JSON", data: obj,
//                    success: function (data) {
//                        var arrlist = data.rs;
//                        if (arrlist.length == 1) {
//                            var lgindex = arrlist[0].Longitude.indexOf("."); 
//                            var lglength = arrlist[0].Longitude.substring(0, lgindex);
//                            var lg0 = "";
//                            for (var i = 0; i < 4 - lglength.length; i++) {
//                                 lg0 =lg0+"0";
//                            }
//                            var lg1 = lg0 +arrlist[0].Longitude.substring(0, lgindex);
//                            var lg2 = arrlist[0].Longitude.substring(lgindex, lgindex+5);
//                            var lgstr = lg1+lg2;  //经度
//                            var laindex = arrlist[0].latitude.indexOf("."); 
//                            var lalength = arrlist[0].latitude.substring(0, laindex);
//                            var la0 = "";
//                            for (var i = 0; i < 4 - lalength.length; i++) {
//                                 la0 =la0+"0";
//                            }
//                            var la1 = la0 +arrlist[0].latitude.substring(0, laindex);
//                            var la2 = arrlist[0].latitude.substring(laindex, laindex+5);
//                            var lastr = la1+la2;  //纬度
//                            $("#Longitude").val(lgstr);
//                            $("#latitude").val(lastr);
//                        } else {
//                            layerAler("请到电子地图设置集控器的经纬度");
//                        }
//                    }
//                });
                // var obj = $("#form2").serializeObject();

                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFE, num, 0, 10, vv); //01 03 F24   
                dealsend2("FE", data, 10, "allCallBack", comaddr, 0, 0, 0);
            }
            function setjwd() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var long = obj.Longitude;
                var lati = obj.latitude;

                var oo = {jd: long, wd: lati};
                var longarr = long.split(".");
                var latiarr = lati.split(".");
                console.log(longarr.length);
                if (longarr.length != 2 || latiarr.length != 2) {
                    layerAler(langs1[480][lang]);    //经纬度错误输入格式
                    return;
                }
                if (longarr[0].length != 4 || longarr[1].length != 4) {
                    layerAler(langs1[481][lang]);   //经度是4位十进制数字
                    return;
                }
                if (latiarr[0].length != 4 || latiarr[1].length != 4) {
                    layerAler(langs1[482][lang]);  //纬度是4位十进制数字
                    return;
                }
                if (isNumber(longarr[0]) == false || isNumber(longarr[1]) == false) {
                    layerAler(langs1[481][lang]);   //经度是4位十进制数字
                    return;
                }
                if (isNumber(latiarr[0]) == false || isNumber(latiarr[1]) == false) {
                    layerAler(langs1[482][lang]);  //纬度是4位十进制数字
                    return;
                }
                if (isNumber(obj.timezone) == false) {
                    layerAler(langs1[483][lang]);  //时区应是数字
                    return;
                }
                if (isNumber(obj.outoffset) == false) {
                    layerAler(langs1[484][lang]);  //日出偏移应是数字
                    return;
                }
                if (isNumber(obj.inoffset) == false) {
                    layerAler(langs1[484][lang]);  //日出偏移应是数字
                    return;
                }
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                var longh = Str2BytesH(longarr[0]);
                var longl = Str2BytesH(longarr[1]);

                var latih = Str2BytesH(latiarr[0]);
                var latil = Str2BytesH(latiarr[1]);
                vv.push(longl[1]);
                vv.push(longl[0]);
                vv.push(longh[1]);
                vv.push(longh[0]);

                vv.push(latil[1]);
                vv.push(latil[0]);
                vv.push(latih[1]);
                vv.push(latih[0]);

                vv.push(parseInt(obj.inoffset)); //新组号  1字节      
                vv.push(parseInt(obj.outoffset)); //新组号  1字节    
                vv.push(parseInt(obj.areazone));
                vv.push(parseInt(obj.timezone));

                var comaddr = o.l_comaddr;
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置网关经纬度", o.l_comaddr);
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xff, num, 0, 10, vv); //01 03 F24   
                
                dealsend2("FF", data, 10, "allCallBack", comaddr, 0, 0, oo);
                //修改网关参数
                var uobj = {};
                uobj.comaddr = o.l_comaddr;
                uobj.Longitude = obj.Longitude;
                uobj.latitude = obj.latitude;
                uobj.outoffset = obj.outoffset;
                uobj.inoffset = obj.inoffset;
                $.ajax({async: false, url: "login.set.updatewg.action", type: "get", datatype: "JSON", data: uobj,
                    success: function (data) {
                        //var arrlist = data.rs;
                        
                    }
                });
            }

            function setGroupe() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();

                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_groupe)); //新组号  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 110, vv); //01 03 F24   
                addlogon(u_name, "跟换", o_pid, "网关参数设置", "更换组号", comaddr);
                dealsend2("A4", data, 110, "allCallBack", comaddr, 0, 0, obj.l_groupe);
            }

            function delAllplan() {
                var o = $("#form1").serializeObject();
                var vv = [];
                var comaddr = o.l_comaddr;
                addlogon(u_name, "删除", o_pid, "网关参数设置", "删除所有灯具时间表", o.l_comaddr);
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 180, vv); //01 03 F24    
                dealsend2("A4", data, 180, "allCallBack", comaddr, 0, 0, 0);
            }
            function delAllLoopPlan() {
                var o = $("#form1").serializeObject();
                var vv = [];
                addlogon(u_name, "删除", o_pid, "网关参数设置", "删除所有回路时间表", o.l_comaddr);
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 402, vv); //01 03 F24    
                dealsend2("A4", data, 402, "allCallBack", comaddr, 0, 0, 0);
            }
            function delAllLoop() {
                var o = $("#form1").serializeObject();
                var vv = [];
                addlogon(u_name, "删除", o_pid, "网关参数设置", "删除所有回路开关信息", o.l_comaddr);
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 340, vv); //01 03 F24    
                dealsend2("A4", data, 340, "allCallBack", comaddr, 0, 0, 0);
            }
            function delAllLamp() {

                var o = $("#form1").serializeObject();

                var vv = [];
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 108, vv); //01 03 F24    
                addlogon(u_name, "删除", o_pid, "网关参数设置", "删除全部灯具信息", comaddr);
                dealsend2("A4", data, 108, "allCallBack", comaddr, 0, 0, 0);
            }
            function setWowktype() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                console.log(obj);
                var vv = [];
                vv.push(1);
                vv.push(parseInt(obj.l_worktype)); //新工作方式  1字节            
                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 120, vv); //01 03 F24    
                addlogon(u_name, "更换", o_pid, "网关参数设置", "跟换工作方式", comaddr);
                dealsend2("A4", data, 120, "allCallBack", comaddr, 0, 0, obj.l_worktype);
            }

            $(function () {
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                var d = [];
                for (var i = 0; i < 18; i++) {
                    var o = {"id": i + 1, "text": i + 1};
                    d.push(o);
                }
                $("#l_groupe").combobox({data: d, onLoadSuccess: function (data) {
                        $(this).combobox("select", data[0].id);
                    }, });


                $('#time4').timespinner('setValue', '00:00');
                $('#time3').timespinner('setValue', '00:00');

                var myDate = new Date();//获取系统当前时
                var y = myDate.getFullYear();
                var m = myDate.getMonth() + 1;
                var d = myDate.getDate();
                var h = myDate.getHours();
                var mm = myDate.getMinutes();
                var s = myDate.getSeconds();

                var str = y + "-" + m + "-" + d + " " + h + ":" + mm + ":" + s;
                console.log(str);
                $('#nowtime').datetimebox('setValue', str);


            })

            function layerAler(str) {
                layer.alert(str, {
                    icon: 6,
                    offset: 'center'
                });
            }

            function readSiteCB(obj) {

                if (obj.status == "success") {

                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;
                    //dns解析的ip
                    var a = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var aport = src[z + 5] * 256 + src[z + 4];
                    console.log(a, aport);

                    //备用dns解析的ip
                    z = z + 6;
                    var b = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var bport = src[z + 5] * 256 + src[z + 4];
                    console.log(a, bport);
                    //主用ip
                    z = z + 6;
                    var c = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var cport = src[z + 5] * 256 + src[z + 4];
                    console.log(c, cport);

                    //备用ip
                    z = z + 6;
                    var d = sprintf("%d.%d.%d.%d", src[z], src[z + 1], src[z + 2], src[z + 3]);
                    var dport = src[z + 5] * 256 + src[z + 4];
                    console.log(d, dport);

                    z = z + 6;
                    var apn = "";
                    for (var i = z; i < z + 16; i++) {
                        var s = src[i] == 0 ? "" : String.fromCharCode(src[i]);
                        apn = apn + s;
                    }
                    console.log(apn);
                    z = z + 16;

                    var lenarea = src[i];
                    console.log(lenarea);

                    z = z + 1;
                    var area = "";
                    for (var i = z; i < z + lenarea; i++) {

                        area = area + String.fromCharCode(src[i]);
                    }
                    console.log(area);
                    $("#apn").val(apn);




                    if (lenarea > 0) {
                        $("#ip").val(area);
                        $("#port").val(aport);
                        $("#sitetype").combobox('select', 0);
                    } else if (lenarea == 0) {
                        $("#ip").val(c);
                        $("#port").val(cport);
                        $("#sitetype").combobox('select', 1);
                    }

                }
            }
            function readSite() {
                var obj = $("#form1").serializeObject();
                if (obj.l_comaddr == "") {
                    layerAler(langs1[172][lang]); //网关不能为空
                    return;
                }


                var comaddr = obj.l_comaddr;
                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 1, vv); //01 03 F24    
                dealsend2("AA", data, 1, "readSiteCB", comaddr, 0, 0, 0);
            }


            function readTimeCB(obj) {
                if (obj.status == "success") {

                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;

                    var s = src[z] >> 4 & 0x0f;
                    var g = src[z + 0] & 0x0f;
                    var sw = src[z + 1] >> 4 & 0x0f;
                    var gw = src[z + 1] & 0x0f;
                    var timechg = sprintf("%d%d:%d%d", s, g, sw, gw);
                    $('#time4').spinner('setValue', timechg);
                    z += 2;
                    var s2 = src[z] >> 4 & 0x0f;
                    var g2 = src[z + 0] & 0x0f;
                    var sw2 = src[z + 1] >> 4 & 0x0f;
                    var gw2 = src[z + 1] & 0x0f;
                    var timefloze = sprintf("%d%d:%d%d", s2, g2, sw2, gw2);
                    $('#time3').spinner('setValue', timefloze);
                    var timestr = sprintf("换日时间 time:%s 冻结时间:%s", timechg, timefloze);
                    console.log(timestr);

                }

            }
            function readTime() {
                var obj = $("#form1").serializeObject();
                console.log(obj);
                var comaddr = obj.l_comaddr;
                var vv = [];
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 4, vv); //01 03 F24    
                dealsend2("AA", data, 4, "readTimeCB", comaddr, 0, 0, 0);
            }

            function setSiteCB(obj) {

                console.log(obj);
                if (obj.status == "success") {
                    layer.confirm(langs1[173][lang], {//确定修改网关指向的域名？
                        btn: [langs1[146][lang], langs1[147][lang]], //确定、取消按钮
                        icon: 3,
                        offset: 'center',
                        title: langs1[174][lang]  //提示
                    }, function (index) {
                        var v1 = [];
                        var num = randnum(0, 9) + 0x70;
                        var data1 = buicode(obj.comaddr, 0x04, 0x00, num, 0, 1, v1); //01 03 F24    
                        dealsend2("00", data1, 1, "", obj.comaddr, 0, 0, 0);
                        layer.close(index);
                    });
                }

            }

            function setSite() {
                var obj = $("#form2").serializeObject();
                var obj1 = $("#form1").serializeObject();
                console.log(obj);
                if (isNumber(obj.port) == false) {
                    layerAler(langs1[175][lang]); //端口只能是数字
                    return;
                }

                if (obj.apn.length > 16) {
                    layerAler(langs1[176][lang]); //apn长度不能超过16
                    return;
                }
                var hexport = parseInt(obj.port);
                var u1 = hexport >> 8 & 0x00ff;
                var u2 = hexport & 0x000ff;
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置主站信息", obj1.l_comaddr);
                var vv = [];
                if (obj.sitetype == "1") {
                    if (isValidIP(obj.ip) == false) {
                        layerAler(langs1[177][lang]);  //不是合法ip
                        return;
                    }
                    for (var i = 0; i < 12; i++) {
                        vv.push(0);
                    }
                    var iparr = obj.ip.split(".");
                    for (var i = 0; i < iparr.length; i++) {
                        vv.push(parseInt(iparr[i]));
                    }
                    vv.push(u2);
                    vv.push(u1);

                    for (var i = 0; i < 6; i++) {
                        vv.push(0);
                    }


                    for (var i = 0; i < 16; i++) {
                        var apn = obj.apn;
                        var len = apn.length;
                        if (len <= i) {
                            vv.push(0);
                        } else {
                            var c = apn.charCodeAt(i);
                            vv.push(c);
                        }

                    }

                    vv.push(0);
                    var comaddr = obj1.l_comaddr;
                    var num = randnum(0, 9) + 0x70;
                    var data = buicode(comaddr, 0x04, 0xA4, num, 0, 1, vv); //01 03 F24    

                    dealsend2("A4", data, 1, "setSiteCB", comaddr, 0, 0, 0);

                } else if (obj.sitetype == "0") {



                    if (isValidIP(obj.ip) == true) {
                        layerAler(langs1[178][lang]);  // 请填写正确的域名
                        return;
                    }


                    if (obj.ip != "") {
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(0);
                        vv.push(u2);
                        vv.push(u1);

                        for (var i = 0; i < 18; i++) {
                            vv.push(0);
                        }

                        for (var i = 0; i < 16; i++) {
                            var apn = obj.apn.trim();
                            var len = apn.length;
                            if (len <= i) {
                                vv.push(0);
                            } else {
                                var c = apn.charCodeAt(i);
                                vv.push(c);
                            }

                        }

                        var ip = obj.ip.trim();
                        var len = ip.length;
                        vv.push(len);
                        for (var i = 0; i < len; i++) {
                            var c = ip.charCodeAt(i);
                            vv.push(c);
                        }
                        var comaddr = obj1.l_comaddr;
                        var num = randnum(0, 9) + 0x70;
                        var data = buicode(comaddr, 0x04, 0xA4, num, 0, 1, vv); //01 03 F24    

                        dealsend2("A4", data, 1, "setSiteCB", comaddr, 0, 0, 0);

                    }

                }

            }

            function setChgTimeCB(obj) {
                if (obj.status == "success") {
                    layerAler(langs1[179][lang]);  //设置换日时间和冻结时间成功
                }
            }

            function setChgTime() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var o4 = obj.time4;
                var o3 = obj.time3;
                var oo = {"o4": o4, "o3": o3};
                var a = o4.split(":");
                var b = o3.split(":");

                var h1 = parseInt(a[0], 16);
                var m1 = parseInt(a[1], 16);

                var h2 = parseInt(b[0], 16);
                var m2 = parseInt(b[1], 16);
                var vv = [];
                vv.push(h1);
                vv.push(m1);
                vv.push(h2);
                vv.push(m2);
                var comaddr = o.l_comaddr;
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置换日时间和冻结时间", comaddr);
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 4, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setChgTimeCB", comaddr, 0, oo, 0);
            }


            function setAPNCB(obj) {
                if (obj.status == "success") {
                    layerAler(langs1[180][lang]);  //设置运营商APN成功
                }
            }

            function setAPN() {
                var o = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                if (obj.apn == "") {
                    layerAler(langs1[181][lang]);  //apn不能为空
                    return;
                }
                if (obj.apn.length > 16) {
                    layerAler(langs1[176][lang]);
                    return;
                }
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置运营商APN", o.l_comaddr);
                var vv = [];
                for (var i = 0; i < 16; i++) {
                    var apn = obj.apn;
                    var len = apn.length;
                    if (len <= i) {
                        vv.push(0);
                    } else {
                        var c = apn.charCodeAt(i);
                        vv.push(c);
                    }

                }

                var comaddr = o.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 2, vv); //01 03 F24    
                dealsend2("A4", data, 4, "setAPNCB", comaddr, 0, apn, 0);
            }

            function setInspectcb(obj) {
                console.log(obj);
                if (obj.status == "success") {
                    layerAler(langs1[182][lang]);  //灯具通信失联巡检次数成功
                }
                if (obj.status == "fail") {
                    layerAler(langs1[183][lang]);  //灯具通信失联巡检次数失败
                }
            }
            function setInspect() {
                var obj1 = $("#form1").serializeObject();
                var obj = $("#form2").serializeObject();
                var o = obj.inspect;
                if (o == "") {
                    layerAler(langs1[184][lang]);  //请填写巡检次数
                    return;
                }
                var vv = [];
                vv.push(parseInt(o));

                var comaddr = obj1.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xA4, num, 0, 202, vv); //01 03 F24    
                dealsend2("A4", data, 202, "setInspectcb", comaddr, 0, 0, 0);
            }

            function readInspectcb(obj) {
                console.log(obj);
            }
            function readInspect() {
                var vv = [];
                var obj = $("#form1").serializeObject();
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xAA, num, 0, 202, vv); //01 03 F24    
                dealsend2("AA", data, 202, "readInspectcb", comaddr, 0, 0, 0);
            }


            function readAreaCb(obj) {
                if (obj.status == "success") {
                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;
                    //dns解析的ip
                    var area1 = sprintf("%02x%02x", src[z + 1], src[z]);
                    var area2 = sprintf("%02x%02x", src[z + 3], src[z + 2]);
                    $("#area").val(area1);
                    $("#addr").val(area2);
                    console.log(area1, area2);
                }

            }
            function readArea() {
                var vv = [];
                var obj = $("#form1").serializeObject();
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFE, num, 0, 1, vv); //01 03 F24    
                dealsend2("FE", data, 1, "readAreaCb", comaddr, 0, 0, 0);
            }
            function setAreaCB(obj) {
                if (obj.status == "success") {
                    var src = Str2BytesH(obj.data);
                    var v = "";
                    for (var i = 0; i < src.length; i++) {

                        v = v + sprintf("%02x", src[i]) + " ";
                    }
                    console.log(v);

                    var z = 18;

                }
            }
            function setArea() {
                addlogon(u_name, "设置", o_pid, "网关参数设置", "设置行政参数划码");
                var vv = [];
                var obj = $("#form1").serializeObject();
                var obj1 = $("#form2").serializeObject();
                if (!isNumber(obj1.area) || obj1.area.length != 4) {
                    layerAler(langs1[185][lang]); //区划码是2位字节4数字长度
                    return;
                }
                if (!isNumber(obj1.addr) || obj1.addr.length != 4) {
                    layerAler(langs1[185][lang]);
                    return;
                }

                var arr = Str2BytesH(obj1.area);
                vv.push(arr[1]);
                vv.push(arr[0]);

                arr = Str2BytesH(obj1.addr);
                vv.push(arr[1]);
                vv.push(arr[0]);


//                var h = area >> 8 && 0x00ff;
//                var l = area & 0x00ff;
//                vv.push(l);
//                vv.push(h);



//                var addr = parseInt(obj1.addr, 106);
//                var h1 = addr >> 8 && 0x0f;
//                var l1 = addr & 0x0f;
//                vv.push(l1);
//                vv.push(h1);

                console.log(area);
                console.log(obj1);
                var comaddr = obj.l_comaddr;
                var num = randnum(0, 9) + 0x70;
                var data = buicode(comaddr, 0x04, 0xFF, num, 0, 1, vv); //01 03 F24    
                dealsend2("FF", data, 1, "setAreaCB", comaddr, 0, 0, 0);
            }
            //检测时间
            function jcsj() {
                var obj = {};
                obj.jd = $("#Longitude").val();
                obj.wd = $("#latitude").val();
                if (obj.jd == "" || obj.wd == "") {
                    layerAler("请读取集控器经纬度");
                    return;
                }
                var outoffset = $("#outoffset").val(); //日出偏移
                var inoffset = $("#inoffset").val();  //日落偏移
                //parseFloat
                if (parseInt(outoffset).toString() == "NaN" || parseInt(inoffset).toString() == "NaN") {
                    layerAler("偏移量为数字类型");
                    return;
                }
                $.ajax({async: false, url: "login.rc.r.action", type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        var list = data.cl[0];
//                        var lgindex = arrlist[0].Longitude.indexOf(".");
//                        var lglength = arrlist[0].Longitude.substring(0, lgindex);
                        var rcindex = list.rc.indexOf(":");
                        var rcs = list.rc.substring(0, rcindex); //日出时
                        var rcf = list.rc.substring(rcindex + 1, list.rc.length); //日出分
                        var rlindex = list.rl.indexOf(":");
                        var rls = list.rl.substring(0, rlindex); //日落时
                        var rlf = list.rl.substring(rlindex + 1, list.rl.length); //日落分
                        //日落
                        if (parseInt(inoffset) > 0) {
                            rlf =parseInt(rlf) + parseInt(inoffset);
                            if (rlf >= 60) {
                                rlf = rlf - 60;
                                rls = parseInt(rls) + 1;
                            }
                            if (rls >= 24) {
                                rls = rls - 24;
                            }
                            if (rlf < 10) {
                                rlf = "0" + rlf.toString();
                            }

                            if (rls < 10) {
                                rls = "0" + rls.toString();
                            }
                        } else if (parseInt(inoffset) < 0) {
                            rlf = parseInt(rlf) - Math.abs(parseInt(inoffset));
                            if (rlf < 0) {
                                rls = parseInt(rls) - 1;
                                rlf = rlf + 60;
                            }
                            if (rls < 0) {
                                rls = rls + 24;
                            }
                            if (rlf < 10) {
                                rlf = "0" + rlf.toString();
                            }

                            if (rls < 10) {
                                rls = "0" + rls.toString();
                            }
                        }
                         //日出
                        if (parseInt(outoffset) > 0) {
                            rcf =parseInt(rcf) + parseInt(outoffset);
                            if (rcf >= 60) {
                                rcf = rcf - 60;
                                rcs = parseInt(rcs) + 1;
                            }
                            if (rcs >= 24) {
                                rcs = rcs - 24;
                            }
                            if (rcf < 10) {
                                rcf = "0" + rcf.toString();
                            }

                            if (rcs < 10) {
                                rcs = "0" + rcs.toString();
                            }
                        } else if (parseInt(outoffset) < 0) {
                            rcf = parseInt(rcf) - Math.abs(parseInt(outoffset));
                            if (rcf < 0) {
                                rcs = parseInt(rcs) - 1;
                                rcf = rcf + 60;
                            }
                            if (rcs < 0) {
                                rcs = rcs + 24;
                            }
                            if (rcf < 10) {
                                rcf = "0" + rcf.toString();
                            }

                            if (rcs < 10) {
                                rcs = "0" + rcs.toString();
                            }
                        }
                        $("#sunrise").val(rcs + ":" + rcf);  //日出
                        $("#sunset").val(rls + ":" + rlf);  //日落
                        $("#sunriseSunset").show();
                        console.log(data);

                    },
                    error: function () {
                        alert("提交失败！");
                    }
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

                $('#type').combobox({
                    onLoadSuccess: function (data) {
                        if (Array.isArray(data) && data.length > 0) {
                            $(this).combobox("select", data[0].id);
                        }
                    },
                    formatter: function (row) {
                        var lan = "${param.lang}";
                        var langid = row.id - 1 + 514;
                        row.text = langs1[langid][lan];
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    },
                    onSelect: function (record) {
                        var rowdiv = $(".row");
                        for (var i = 0; i < rowdiv.length; i++) {
                            var row = rowdiv[i];
                            if (i == 0) {
                                continue;
                            }
                            $(row).hide();
                        }

                        var v = parseInt(record.id);
                        if (v == 5) {
                            var o = $("#form1").serializeObject();
                            var comaddr = o.l_comaddr;
                            var obj = {};
                            obj.comaddr = comaddr;
                            $.ajax({async: false, url: "login.set.readTrueTime.action", type: "get", datatype: "JSON", data: obj,
                                success: function (data) {
                                    var arrlist = data.rs;
                                    if (arrlist.length == 1) {
                                        var lgindex = arrlist[0].Longitude.indexOf(".");
                                        var lglength = arrlist[0].Longitude.substring(0, lgindex);
                                        var lg0 = "";
                                        for (var i = 0; i < 4 - lglength.length; i++) {
                                            lg0 = lg0 + "0";
                                        }
                                        var lg1 = lg0 + arrlist[0].Longitude.substring(0, lgindex);
                                        var lg2 = arrlist[0].Longitude.substring(lgindex, lgindex + 5);
                                        var lgstr = lg1 + lg2;  //经度
                                        var laindex = arrlist[0].latitude.indexOf(".");
                                        var lalength = arrlist[0].latitude.substring(0, laindex);
                                        var la0 = "";
                                        for (var i = 0; i < 4 - lalength.length; i++) {
                                            la0 = la0 + "0";
                                        }
                                        var la1 = la0 + arrlist[0].latitude.substring(0, laindex);
                                        var la2 = arrlist[0].latitude.substring(laindex, laindex + 5);
                                        var lastr = la1 + la2;  //纬度
                                        $("#Longitude").val(lgstr);
                                        $("#latitude").val(lastr);
                                        var out = arrlist[0].outoffset;  //日出偏移
                                        var inoffset = arrlist[0].inoffset; //日落偏移
                                        if (out == null || out == "") {
                                            out = 0;
                                        }
                                        if (inoffset == null || inoffset == "") {
                                            inoffset = 0;
                                        }
                                        if(parseInt(arrlist[0].Longitude)>0){
                                            $('#areazone').combobox('setValue', 0);
                                            var num = (parseInt(arrlist[0].Longitude)/15).toFixed();
                                            if(num<10){
                                                num = "0"+num;
                                            }
                                            $("#timezone").val(num);
                                            
                                        }else{
                                            $('#areazone').combobox('setValue', 1);
                                             var num = (parseInt(arrlist[0].Longitude)/15).toFixed();
                                              if(num<10){
                                                num = "0"+num;
                                            }
                                             $("#timezone").val(num);
                                        }
                                        $("#outoffset").val(out);
                                        $("#inoffset").val(inoffset);
                                    }
                                }
                            });
                        }
                        $(rowdiv[v]).show();

                    }
                });

                var lang = "${param.lang}";

                $('#powertable').bootstrapTable({
                    columns: [
                        {
                            field: 'time',
                            title: langs1[526][lang], //时刻
                            width: 100,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'power',
                            title: langs1[527][lang], //能量
                            width: 100,
                            align: 'center',
                            valign: 'middle'
                        }
                    ],
                    paginationDetailHAlign: 'right',
                    data: [],
                    singleSelect: false,
                    locale: 'zh-CN', //中文支持,
                    pagination: true,
                    pageNumber: 1,
                    pageSize: 100,
                    pageList: [100, 200],

                });


                $('#areazone').combobox({
                    formatter: function (row) {
//                        console.log(row);

                        var lan = "${param.lang}";
                        var langid = parseInt(row.id) + 529;
                        row.text = langs1[langid][lan];
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    }
                });

                $('#sitetype').combobox({
                    formatter: function (row) {
                        var lan = "${param.lang}";
                        var langid = parseInt(row.id) + 532;
                        row.text = langs1[langid][lan];
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    }
                });

                $('#l_worktype').combobox({
                    formatter: function (row) {
                        var lan = "${param.lang}";
                        var langid = parseInt(row.id) + 534;
                        row.text = langs1[langid][lan];
                        var opts = $(this).combobox('options');
                        return row[opts.textField];
                    }
                });


            })


            function dateFormatter(value) {
                var date = new Date(value);
                var year = date.getFullYear().toString();
                var month = (date.getMonth() + 1);
                var day = date.getDate().toString();
                var hour = date.getHours().toString();
                var minutes = date.getMinutes().toString();
                var seconds = date.getSeconds().toString();
                if (month < 10) {
                    month = "0" + month;
                }
                if (day < 10) {
                    day = "0" + day;
                }
                if (hour < 10) {
                    hour = "0" + hour;
                }
                if (minutes < 10) {
                    minutes = "0" + minutes;
                }
                if (seconds < 10) {
                    seconds = "0" + seconds;
                }
                return year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds;
            }

//            function dateParser(s) {
//                var date = new Date(s);
//                var year = date.getFullYear().toString();
//                var month = (date.getMonth() + 1);
//                var day = date.getDate().toString();
//                var hour = date.getHours().toString();
//                var minutes = date.getMinutes().toString();
//                var seconds = date.getSeconds().toString();
//                if (month < 10) {
//                    month = "0" + month;
//                }
//                if (day < 10) {
//                    day = "0" + day;
//                }
//                if (hour < 10) {
//                    hour = "0" + hour;
//                }
//                if (minutes < 10) {
//                    minutes = "0" + minutes;
//                }
//                if (seconds < 10) {
//                    seconds = "0" + seconds;
//                }
//                var str = year + "-" + month + "-" + day + " " + hour + ":" + minutes + ":" + seconds;
//                return str;
//            }

        </script>
    </head>
    <body>


        <div class="panel panel-success" >
            <div class="panel-heading">
                <h3 class="panel-title"><span id="186" name="xxx">集控器参数设置</span></h3>
            </div>
            <div class="panel-body" >
                <div class="container" style=" height:400px;"  >



                    <div class="row" style=" padding-bottom: 20px;" >
                        <div class="col-xs-12">
                            <form id="form1">
                                <table style="border-collapse:separate;  border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>

                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="25">网关地址</span>&nbsp;

                                                <span class="menuBox">
                                                    <input id="l_comaddr" class="easyui-combobox" name="l_comaddr" style="width:150px; height: 30px" 
                                                           data-options="editable:true,valueField:'id', textField:'text' " />
                                                </span>  
                                            </td>
                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="187">功能选择</span>&nbsp;

                                                <span class="menuBox">
                                                    <select class="easyui-combobox" id="type" name="type" data-options="editable:false,valueField:'id', textField:'text' " style="width:200px; height: 30px">
                                                        <option value="1" >主站域名或IP设置</option>     
                                                        <option value="2">设置换日冻结时间参数</option>    
                                                        <option value="3">集控器行政区划码</option> 
                                                        <option value="4">集控器时间设置</option> 
                                                        <option value="5">设置经纬度</option>
                                                        <option value="6">设置巡测任务</option>
                                                        <option value="7">互感器变比设置</option>
                                                        <option value="8">请求今天的电能量</option> 
                                                        <option value="9">网关复位</option>
                                                        <option value="10">数据区初始化</option> 
                                                    </select>
                                                </span>  
                                            </td>
                                            <td>
                                                <button type="button"  onclick="refleshgayway()" class="btn  btn-success btn-sm" style="margin-left: 2px;">
                                                    <span   name="xxx" id="531">刷新集控器在线列表</span>
                                                </button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table> 
                            </form>
                        </div>
                    </div>

                    <form id="form2">
                        <div class="row" id="row1">
                            <div class="col-xs-12" >

                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="188">域名IP选择</span>
                                            </td>
                                            <td>

                                                <select class="easyui-combobox" id="sitetype" name="sitetype" data-options="editable:true,valueField:'id', textField:'text' " style="width:150px; height: 30px">
                                                    <option value="0">域名</option>
                                                    <option value="1">ip</option>            
                                                </select>   

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="189">主站ip或域名</span>
                                            </td>
                                            <td>
                                                <input id="ip"  class="form-control" name="ip"  style="width:150px; " placeholder="输入主站域名" type="text">
                                            </td>
                                        </tr>

                                        <tr >
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="190" >端口</span>
                                            <td>

                                                <input id="port"  class="form-control" name="port" style="width:150px;"  placeholder="输入端口" type="text">
                                            </td>

                                        </tr>                                   

                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="191" >运营商APN</span>
                                            </td>

                                            <td >
                                                <input id="apn" class="form-control" name="apn" value="cmnet" style="width:150px;" placeholder="输入APN" type="text">
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <button type="button"  onclick="setSite()" class="btn  btn-success btn-sm" style="margin-left: 2px;"><span name="xxx" id="192">设置主站信息</span></button>
                                                <button  type="button" onclick="readSite()" class="btn btn-success btn-sm"><span name="xxx" id="193">读取主站信息</span></button>
                                                <button  type="button"  onclick="setAPN()" class="btn btn-success btn-sm"><span name="xxx" id="194">设置运营商APN</span></button>
                                            </td>

                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row2" style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span  style="margin-left:10px;"  name="xxx" id="195">换日时间</span>
                                                <input id="time4" name="time4" style=" height: 30px; width: 100px;  "  class="easyui-timespinner">
                                                <span  style="margin-left:10px;"  name="xxx" id="196">冻结时间</span>
                                                <input id="time3" name="time3" style=" height: 30px; width: 100px;"  class="easyui-timespinner">
                                                &nbsp;
                                            </td>

                                        </tr>
                                        <tr><td></td></tr>
                                        <tr>
                                            <td>
                                                <button   type="button" onclick="setChgTime()" class="btn btn-success btn-sm"><span name="xxx" id="197">设置换日冻结时间</span></button>
                                                <button  type="button" onclick="readTime()" class="btn btn-success btn-sm"><span name="xxx" id="198">读取换日冻结时间</span></button>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>




                        <div class="row" id="row3" style=" display: none">
                            <div class="col-xs-12" >

                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629; ">
                                    <tbody>

                                        <tr >
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="204" >行政区域码</span>
                                            <td>

                                                <input id="area"  class="form-control" name="area" style="width:150px;"  placeholder="区域码" type="text">&nbsp;
                                            </td>

                                        </tr>                                   

                                        <tr>
                                            <td>
                                                <span  style=" float: right; margin-right: 2px;" name="xxx" id="25" >网关地址</span>
                                            </td>

                                            <td >
                                                <input id="addr" class="form-control" name="addr" value="" style="width:150px;" placeholder="终端地址" type="text">
                                                &nbsp;
                                            </td>

                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <button  type="button" onclick="readArea()" class="btn btn-success btn-sm"><span id="205" name="xxx">读取</span> </button>
                                                <button type="button"  onclick="setArea()" class="btn  btn-success btn-sm" style="margin-left: 2px;"><span id="49" name="xxx">设置</span></button>

                                            </td>

                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row4"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="511">当前时间</span>
                                                <span class="menuBox">
                                                    <input class="easyui-datetimebox" name="nowtime" id="nowtime"
                                                           data-options="formatter:dateFormatter,showSeconds:true" value="" style="width:180px">
                                                </span> 
                                                <button  type="button" onclick="setNowtime()"  class="btn btn-success btn-sm"><span name="xxx" id="513">获取当前时间</sspan>
                                                </button>&nbsp; 

                                                <button  style="float:right; margin-right: 5px;" type="button" onclick="setTimeNow()" class="btn btn-success btn-sm"><span name="xxx" id="49">设置</sspan></button>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>
                                                <span style="margin-left:10px; " name="xxx" id="202">网关终端时间</span>&nbsp;
                                                <input id="gaytime" readonly="true" class="form-control" name="gaytime" value="" style="width:150px;" placeholder="网关终端时间" type="text">
                                                <button  type="button" onclick="readTrueTime()" class="btn btn-success btn-sm"><span name="xxx" id="205">读取</span></button>&nbsp;
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row5"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style=" float: right; " name="xxx" id="59">经度</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="Longitude" name="Longitude"  value="" style="width:100px;" placeholder="经度" type="text">
                                            </td>
                                            <td>
                                                <span style="float: right; " name="xxx" id="60">纬度</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="latitude" name="latitude"  value="" style="width:100px;" placeholder="纬度" type="text">
                                            </td>


                                            <td>
                                                <span style="float: right; " name="xxx" id="486">时区范围:</span>&nbsp;


                                            </td>
                                            <td>
                                                <select class="easyui-combobox" id="areazone" name="areazone" data-options="editable:false,valueField:'id', textField:'text'" style="width:100px; height: 30px">
                                                    <option value="0" >东经</option>
                                                    <option value="1">西经</option>
                                                </select>

                                            </td>




                                            <td>
                                                <span style="float: right; " name="xxx" id="487">时区</span>&nbsp;
                                            </td>



                                            <td>
                                                <input id="timezone" name="timezone" value="" style="width:100px;" placeholder="时区" type="text">

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px; " name="xxx" id="488">日出偏移</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="outoffset" class="form-control" name="outoffset" value="" style="width:100px;" placeholder="日出偏移" type="text">
                                            </td>
                                            <td>
                                                <span style="margin-left:10px; " name="xxx" id="489">日落偏移</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="inoffset"  name="inoffset" value="" style="width:100px;" placeholder="日落偏移" type="text">
                                            </td> 
                                            <td >
                                                <button  type="button" onclick="readjwd()" class="btn btn-success btn-sm"><span>读取集控器信息</span> </button>
                                            </td>
                                            <td>     <button type="button"  onclick="setjwd()" class="btn  btn-success btn-sm" style="margin-left: 10px;"><span id="49" name="xxx">设置</span></button></td>
                                            <td>     <button type="button"  onclick="jcsj()" class="btn  btn-success btn-sm" style="margin-left: 0px;"><span id="485" name="xxx">检测时间</span></button></td>

                                        </tr>

                                        <tr id="sunriseSunset" style=" display: none">
                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="490">日出时间</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="sunrise" class="form-control" value="" style="width:100px;" placeholder="日出时间" type="text">
                                            </td>
                                            <td>
                                                <span style="margin-left:10px; " name="xxx" id="491">日落时间</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="sunset"   value="" style="width:100px;" placeholder="日落偏移" type="text">
                                            </td> 
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="row" id="row6"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="StartCheck()" class="btn btn-success btn-sm"><span id="415" name="xxx">启动巡测任务</span></button>&nbsp;
                                                <button  type="button" onclick="StopCheck()" class="btn btn-success btn-sm"><span id="416" name="xxx">结束巡测任务</span></button>&nbsp;
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>                   


                        <div class="row" id="row7"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style=" float: right; " name="xxx" id="421">电压超限值</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="voltage" name="voltage"  value="" style="width:80px;" placeholder="电压超限值" type="text">
                                            </td>
                                            <td style=" padding-left: 10px;">
                                                <span style="float: right; " name="xxx" id="422">电流超限值</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="electric" name="electric"  value="" style="width:80px;" placeholder="电流超限值" type="text"> &nbsp;
                                            </td>
                                            <td style=" padding-left: 5px;">
                                                <span style="float: right; " name="xxx" id="424">功率因数</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="powerfactor" name="powerfactor"  value="" style="width:80px;" placeholder="功率因数限值" type="text">
                                            </td>

                                            <td style=" padding-left: 10px;">
                                                <span style="float: right; " name="xxx" id="423">互感器变比</span>&nbsp;
                                            </td>
                                            <td>
                                                <input id="power" name="power"  value="" style="width:80px;" placeholder="互感器变比" type="text"> &nbsp;
                                            </td>
                                            <td colspan="2" style=" padding-left: 5px;">       
                                                <button  type="button" onclick="readpower()" class="btn btn-success btn-sm"><span id="205" name="xxx">读取</span></button>&nbsp;


                                            </td>
                                            <td colspan="2" style=" padding-left: 5px;">    
                                                <button  type="button" onclick="setPower()" class="btn btn-success btn-sm"><span id="49" name="xxx">设置</span></button>&nbsp;
                                            </td>
                                        </tr>
                                        <tr>


                                        </tr>
                                        <tr>

                                        </tr>
                                    </tbody>
                                </table>

                            </div>

                        </div>      

                        <div class="row" id="row8"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>

                                            <td colspan="2" style=" padding-left: 5px;">    
                                                <button  type="button" onclick="gettodaypower()" class="btn btn-success btn-sm"><span id="524" name="xxx">获取今天电能量</span></button>&nbsp;
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                                <div style=" width: 300px;">

                                    <table id="powertable" ></table>
                                </div>

                            </div>
                        </div>      

                        <div class="row" id="row9"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="resetGayway()" class="btn btn-success btn-sm"><span id="522" name="xxx">集控器复位</span></button>&nbsp;
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>                   

                        <div class="row" id="row10"  style=" display: none">
                            <div class="col-xs-12">
                                <table style="border-collapse:separate; border-spacing:0px 10px;border: 1px solid #16645629;">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="margin-left:10px;" name="xxx" id="206">灯具新组号</span>
                                                <span class="menuBox">
                                                    <input id="l_groupe" class="easyui-combobox" name="l_groupe" style="width:100px; height: 30px" 
                                                           data-options="editable:true,valueField:'id', textField:'text' " />
                                                </span> 
                                                <!-- <button  type="button" onclick="chgLampGroupe()" class="btn btn-success btn-sm">更换所有灯具的组号</button>&nbsp; -->
                                                <button  onclick="setGroupe()" style=" margin-left: 2px;" class="btn btn-success btn-sm" ><span name="xxx" id="207">更换</span></button>

                                                <span style=" margin-left: 10px;" name="xxx" id="208">灯具新工作方式</span>&nbsp;
                                                <span class="menuBox">
                                                    <select class="easyui-combobox" id="l_worktype" name="l_worktype" data-options="editable:false,valueField:'id', textField:'text'" style="width:100px; height: 30px">
                                                        <option value="0" >时间</option>
                                                        <option value="1">经纬度</option>
                                                        <option value="2">场景</option>           
                                                    </select>
                                                </span> 
                                                <button  onclick="setWowktype()" style=" margin-left: 2px;" class="btn btn-success btn-sm" ><span name="xxx" id="207">更换</span></button>
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <button  type="button" onclick="delAllLamp()" class="btn btn-success btn-sm"><span id="209" name="xxx">删除全部灯具信息</span></button>
                                                <button  style="float:right; margin-right: 5px;" type="button" onclick="delAllplan()" class="btn btn-success btn-sm"><span name="xxx" id="210">删除全部灯具时间表</span></button>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="delAllLoop()" class="btn btn-success btn-sm"><span id="211" name="xxx">删除全部回路开关信息</span></button>&nbsp;
                                                <button style="float:right; margin-right: 5px;"   type="button" onclick="delAllLoopPlan()" class="btn btn-success btn-sm"><span id="212" name="xxx">删除全部回路时间表</span></button>&nbsp;
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>       
                                                <button  type="button" onclick="initdata()" class="btn btn-success btn-sm"><span id="509" name="xxx">数据初始化</span></button>&nbsp;
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>  
                    </form>
                </div>



            </div>


    </body>
</html>
