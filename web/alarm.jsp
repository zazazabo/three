<%-- 
    Document   : alarm1
    Created on : 2018-11-12, 16:09:37
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="js.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="js/genel.js"></script>
        <script type="text/javascript"  src="js/getdate.js"></script>
        <script>
            var eventobj = {
                "ERC44": {
                    "status1": {
                        "0": "灯具故障",
                        "1": "温度故障",
                        "2": "超负荷故障",
                        "3": "功率因数过低故障",
                        "4": "时钟故障",
                        "5": "",
                        "6": "灯珠故障",
                        "7": "电源故障"
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC43": {
                    "status1": {
                        "0": "灯杆倾斜",
                        "1": "",
                        "2": "温度预警",
                        "3": "漏电流预警",
                        "4": "相位不符",
                        "5": "线路不符",
                        "6": "台区不符",
                        "7": "使用寿命到期"
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC46": {
                    "status1": {
                        "0": "A相超限",
                        "1": "B相超限",
                        "2": "C相超限",
                        "3": "A相过载",
                        "4": "A相欠载",
                        "5": "B相过载",
                        "6": "B相欠载",
                        "7": "C相过载"
                    },
                    "status2": {
                        "0": "C相欠载",
                        "1": "A相功率因数过低",
                        "2": "B相功率因数过低",
                        "3": "C相功率因数过低",
                        "4": "D相功率因数过低",
                        "5": "",
                        "6": "",
                        "7": ""
                    }
                },
                "ERC47": {
                    "status1": {
                        "0": "配电箱后门开",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }
                },
                "ERC48": {
                    "status1": {
                        "0": "PM2.5设备通信故障",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }

                },
                "ERC51": {
                    "status1": {
                        "0": "线路负荷突增",
                        "1": "线路缺相",
                        "2": "",
                        "3": "",
                        "4": "",
                        "5": "",
                        "6": "",
                        "7": ""
                    },
                    "status2": {
                        "0": "",
                        "1": "",
                        "2": "",
                        "3": "",
                        "4": "",
                        "6": "",
                        "7": "",
                    }

                }
            };
            var pid;
            var username;
            var lang = '${param.lang}';//'zh_CN';
            var langs1 = parent.parent.getLnas();
            $(function () {
                pid = parent.parent.getpojectId();
                username = parent.parent.getusername();
                var aaa = $("span[name=xxx]");
                for (var i = 0; i < aaa.length; i++) {
                    var d = aaa[i];
                    var e = $(d).attr("id");
                    $(d).html(langs1[e][lang]);
                }
                $("#comaddrlist").combobox({
                    url: "login.map.getallcomaddr.action?pid=" + pid
//                    onLoadSuccess: function (data) {
//                        $(this).combobox("select", data[0].id);
//                        $(this).val(data[0].text);
//                    }
                });
                $('#fauttable').bootstrapTable({
                    url: 'login.main.faultInfo.action',
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
                            field: 'f_comaddr',
                            title: langs1[120][lang], //设备名称 o[120][lang]
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'f_day',
                            title: langs1[82][lang], //时间 o[82][lang]
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value) {
                                var date = new Date(value);
                                var year = date.getFullYear();
                                var month = date.getMonth() + 1; //月份是从0开始的 
                                var day = date.getDate(), hour = date.getHours();
                                var min = date.getMinutes(), sec = date.getSeconds();
                                var preArr = Array.apply(null, Array(10)).map(function (elem, index) {
                                    return '0' + index;
                                });////开个长度为10的数组 格式为 00 01 02 03 
                                var newTime = year + '-' + (preArr[month] || month) + '-' + (preArr[day] || day) + ' ' + (preArr[hour] || hour) + ':' + (preArr[min] || min) + ':' + (preArr[sec] || sec);
                                return newTime;
                            }
                        }, {
                            field: 'f_comment',
                            title: langs1[123][lang], //异常说明 o[123][lang]
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        }, {
                            field: 'l_factorycode',
                            title: langs1[292][lang], //灯具编号  o[292][lang]
                            width: 25,
                            align: 'center',
                            valign: 'middle'
                        },
                        {
                            field: 'f_detail',
                            title:  langs1[402][lang], //详情
                            width: 25,
                            align: 'center',
                            valign: 'middle',
                            formatter: function (value, row, index, field) {
                                //console.log(row);
                                var str = "";
                                var info = eventobj[row.f_type];
                                if (typeof info == "object") {
                                    var s1 = info.status1;
                                    var s2 = info.status2;
                                    for (var i = 0; i < 8; i++) {
                                        var temp = Math.pow(2, i);
                                        if ((row.f_status1 & temp) == temp) {
                                            if (s1[i] != "") {
                                                str = str + s1[i] + "|";
                                            }

                                        }
                                    }

                                    for (var i = 0; i < 8; i++) {
                                        var temp = Math.pow(2, i);
                                        if ((row.f_status2 & temp) == temp) {
                                            if (s1[i] != "") {
                                                str = str + s1[i] + "|";
                                            }

                                        }
                                    }

                                    return str.substr(0, str.length - 1);
                                } else {
                                    return  value;
                                }
                            }
                        }],
                    clickToSelect: true,
                    singleSelect: false, //设置单选还是多选，true为单选 false为多选
                    sortName: 'id',
                    locale: 'zh-CN', //中文支持,
                    showColumns: true,
                    sortOrder: 'desc',
                    pagination: true,
                    sidePagination: 'server',
                    pageNumber: 1,
                    pageSize: 8,
                    showRefresh: true,
                    showToggle: true,
                    // 设置默认分页为 50
                    pageList: [5, 10, 15, 20, 25],
                    onLoadSuccess: function () {  //加载成功时执行  表格加载完成时 获取集中器在线状态
//                        console.info("加载成功");
                    },

                    //服务器url
                    queryParams: function (params)  {   //配置参数     
                        var temp  =   {    //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的 
                            search: params.search,
                            skip: params.offset,
                            limit: params.limit,
                            type_id: "1",
                            pageSize: params.limit,
                            f_comaddr: "", // = $("#comaddrlist").val();
                            l_factorycode: "", // = $("#l_factorycode").val();
                            pid: pid
                        };      
                        return temp;  
                    }
                });
            });
            //查询
            function select() {
                var obj2 = {};
                obj2.pid = pid;
                if ($("#comaddrlist").val() != "") {
                    obj2.f_comaddr = $("#comaddrlist").val();
                }
                if ($("#l_factorycode").val() != "") {
                    obj2.l_factorycode = $("#l_factorycode").val();
                }
                var opt = {
                    method: "post",
                    contentType: "application/x-www-form-urlencoded",
                    url: "login.main.faultInfo.action",
                    silent: true,
                    query: obj2
                };
                $("#fauttable").bootstrapTable('refresh', opt);
            }

            //查看警异常信息总数
            function fualtCount() {
                var obj = {};
                obj.pid = pid;
                //obj.f_day = d.toLocaleDateString();
                $.ajax({url: "login.main.fualtCount.action", async: false, type: "get", datatype: "JSON", data: obj,
                    success: function (data) {
                        if (data.rs[0].number == 0) {
                            $("#alarmNumber", window.parent.parent.document).html("0");
                            $("#alarmNumber", window.parent.parent.document).css("color", "white");
                        } else {
                            $("#alarmNumber", window.parent.parent.document).html(data.rs[0].number);
                            $("#alarmNumber", window.parent.parent.document).css("color", "red");

                        }
                    },
                    error: function () {
                        alert("出现异常！");
                    }
                });
            }

            //处理异常
            function handle() {
                var checks = $("#fauttable").bootstrapTable('getSelections');
                if (checks.length < 1) {
                    layerAler(langs1[73][lang]);//请勾选表格数据
                    return;
                }
                for (var i = 0; i < checks.length; i++) {
                    //console.log(checks[i].id);
                    var obj = {};
                    obj.id = checks[i].id;
                    obj.f_handlep = username;  //处理人
                    obj.f_handletime = getNowFormatDate2();//处理时间
                    $.ajax({async: false, url: "login.main.updfualt.action", type: "get", datatype: "JSON", data: obj,
                        success: function (data) {
                        }
                    });
                    if (checks[i].l_factorycode != "" && checks[i].l_factorycode != null) {
                        var lobj = {};
                        lobj.l_comaddr = checks[i].f_comaddr;
                        lobj.l_factorycode = checks[i].l_factorycode;
                        $.ajax({async: false, url: "login.main.updlampfualt.action", type: "get", datatype: "JSON", data: lobj,
                            success: function (data) {
                            }
                        });
                    }

                }

                var obj2 = {};
                obj2.pid = pid;
                var opt = {
                    method: "post",
                    contentType: "application/x-www-form-urlencoded",
                    url: "login.main.faultInfo.action",
                    silent: true,
                    query: obj2
                };
                $("#fauttable").bootstrapTable('refresh', opt);
                addlogon(username, "处理报警信息", pid, "报警处理", "处理异常");
                fualtCount();
            }
        </script>
    </head>
    <body>
        <div>
            <table>
                <tbody>
                    <tr>
                        <td>
                            <span style="margin-left:10px;">                                     
                                <span id="25" name="xxx">集控器地址</span>
                                &nbsp;</span>
                            <input id="comaddrlist" data-options='editable:true,valueField:"id", textField:"text"' class="easyui-combobox"/>
                        </td>
                        <td>
                            <span style="margin-left:20px;" id="292" name="xxx">
                                灯具编号
                            </span>&nbsp;
                            <input type="text" id ="l_factorycode" style="width:150px; height: 30px;">
                        </td>
                        <td>
                            <button class="btn btn-sm btn-success" onclick="select()" style="margin-left:10px;"><span id="34" name="xxx">搜索</span></button>
                        </td>
                    </tr>
                </tbody>
            </table>
            <hr>
            <div class="btn-group zuheanniu" id="zuheanniu" style="float:left;position:relative;z-index:100;margin:12px 0 0 10px;">
                <button class="btn btn-success"  onclick="handle()">
                    <span name="xxx" id="455">处理报警</span>
                </button>
            </div>
            <table id="fauttable"></table>
        </div>
    </body>
</html>
