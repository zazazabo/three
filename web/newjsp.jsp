<%-- 
    Document   : newjsp
    Created on : 2018-6-19, 7:11:32
    Author     : Administrator
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%@include  file="jspf/newjsf.jspf" %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript">


            //设置登录窗口
            function openPwd() {
                $('#w').window({
                    title: '修改密码',
                    width: 300,
                    modal: true,
                    shadow: true,
                    closed: true,
                    height: 160,
                    resizable: false
                });
            }
            //关闭登录窗口
            function closePwd() {
                $('#w').window('close');
            }
            //修改密码
            function serverLogin() {
                var $newpass = $('#txtNewPass');
                var $rePass = $('#txtRePass');

                if ($newpass.val() == '') {
                    msgShow('系统提示', '请输入密码！', 'warning');
                    return false;
                }
                if ($rePass.val() == '') {
                    msgShow('系统提示', '请在一次输入密码！', 'warning');
                    return false;
                }

                if ($newpass.val() != $rePass.val()) {
                    msgShow('系统提示', '两次密码不一至！请重新输入', 'warning');
                    return false;
                }

                $.post('/ajax/editpassword.ashx?newpass=' + $newpass.val(), function (msg) {
                    msgShow('系统提示', '恭喜，密码修改成功！<br>您的新密码为：' + msg, 'info');
                    $newpass.val('');
                    $rePass.val('');
                    close();
                })

            }

            var index = 0;
            function addPanel() {
                index++;
                $('#tabs').tabs('add', {
                    title: 'Tab' + index,
                    content: '<div style="padding:10px">Content' + index + '</div>',
                    closable: true
                });
            }
            function removePanel() {
                var tab = $('#tabs').tabs('getSelected');
                if (tab) {
                    var index = $('#tt').tabs('getTabIndex', tab);
                    $('#tt').tabs('close', index);
                }
            }
            function b2s(param) {
                var retstr;
                var s = param.toString(16);
                if (param < 10) {
                    retstr = "0" + s;
                } else {
                    retstr = s;
                }

                return retstr;

            }

            $(function () {
                var ww = 07;


                $('#tt').tree({
                    data: [{
                            text: '集中器列表',
                            state: 'expand',
                            children: [{
                                    text: '1702|0101'
                                }, {
                                    text: '1702|0102'
                                }]
                        }], onClick: function (node) {
                        alert(node.text);
                    }, checkbox: true, lines: true,

                });

                var websocket = null;
                if ('WebSocket' in window) {
                    websocket = new WebSocket("ws://zhizhichun.eicp.net:18414/");
                } else {
                    alert('当前浏览器不支持websocket')
                }
//
//                // 连接成功建立的回调方法
                websocket.onopen = function (e) {
                    // 建立连接后，要根据页面的url得知发起会话的人是想给谁发，或者在那个群里发

                    // 这里是把发起会话的人的信息告诉服务器
                    // 发送消息

                    document.getElementById("btnlight").onclick = function () {
                        var lightval = $("#lightval").val();
                        var lighset = $("#lighset").val();


                        var nodes = $('#tt').tree('getChecked');
                        //  console.log("light:"+ nodes.length);


                        var len = 18;     //固定长度

                        for (var i = 0; i < nodes.length; i++) {
                            var obj = nodes[i];
                            var cnode = $("#tt").tree("getChildren", obj.target);
                            if (cnode.length == 0) {
//                                console.log("是个字节点");
//                                console.log(obj);
                                var txt = obj.text;
                                var arrtxt = txt.split("|");
//                                console.log(arrtxt[0]);                //集中器
                                var addrArea = Str2Bytes(arrtxt[0]);
                                var addrB = Str2Bytes(arrtxt[1]);
                                var hexData = new Array();
                                hexData[0] = 0x68;
                                hexData[5] = 0x68;
                                hexData[6] = 0x4;   //控制域
                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                hexData[11] = 0x2  //地址C  单地址或组地址
                                hexData[12] = 0xA5;  //功能码
                                hexData[13] = 0x72  //帧序列  

                                hexData[14] = 0  //   DA1
                                hexData[15] = 0  //    DA2
                                hexData[16] = 0x1  //  DT1
                                hexData[17] = 0x3  //   DT2
                                hexData[18] = parseInt(lighset, 16);// parseInt(lighset, 16);   //灯装置序号   DT2    
                                hexData[19] = 0;  //灯装置序号       2字节
                                hexData[20] = lightval;
                                var len1 = 18 - 6 + 2 + 1;   //18是固定长度
                                hexData[1] = len1 << 2 | 2;
                                hexData[2] = 0;
                                hexData[3] = len1 << 2 | 2;
                                hexData[4] = 0;

                                alert(hexData.length);
                                var v1 = 0;
                                for (var i = 6; i < hexData.length; i++) {
                                    //console.log(parseInt(hexData[i]));
                                    v1 = v1 + parseInt(hexData[i]);
                                }
                                console.log(v1);
                                hexData.push(v1 % 256);
                                hexData.push(0x16);

                                var ByteToSend = "";
                                for (var i = 0; i < hexData.length; i++) {
                                    ByteToSend = ByteToSend + b2s(hexData[i]) + " ";
                                    //console.log(hexData[i].toString(16));
                                }

                                var user = new Object();
                                user.msg = ByteToSend;
                                user.res = 1;

                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A

                                var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrB[1]) + sprintf("%02d", addrB[0]);
                                console.log(straddr);

                                user.addr = straddr;//"02170101";
                                $datajson = JSON.stringify(user);
                                console.log($datajson);
                                websocket.send($datajson);

                            }

                        }

                    }

                    document.getElementById("deleteswitch").onclick = function () {
                        var nodes = $('#tt').tree('getChecked');
                        var len = 18;     //固定长度
                        //
                        //删除所有主控开关
                        //68 72 00 72 00 68 04 02 17 01 01 02 A4 74 00 00 40 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7C 16
                        //alert("删除");
                        for (var i = 0; i < nodes.length; i++) {
                            var obj = nodes[i];
                            var cnode = $("#tt").tree("getChildren", obj.target);
                            if (cnode.length == 0) {
                                var txt = obj.text;
                                var arrtxt = txt.split("|");
                                var addrArea = Str2Bytes(arrtxt[0]);  //地址域
                                var addrB = Str2Bytes(arrtxt[1]);
                                var hexData = new Array();
                                hexData[0] = 0x68;
                                hexData[5] = 0x68;
                                hexData[6] = 0x04;   //控制域
                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                hexData[11] = 0x2  //地址C  单地址或组地址
                                hexData[12] = 0xA4;  //功能码
                                hexData[13] = 0x72  //帧序列  

                                hexData[14] = 0  //   DA1
                                hexData[15] = 0  //    DA2
                                hexData[16] = 0x40  //  DT1
                                hexData[17] = 0x03  //   DT2

                                var len1 = 18 - 6//18是固定长度
                                hexData[1] = len1 << 2 | 2;
                                hexData[2] = 0;
                                hexData[3] = len1 << 2 | 2;
                                hexData[4] = 0;

                                var v1 = 0;
                                for (var i = 6; i < hexData.length; i++) {
                                    //console.log(parseInt(hexData[i]));
                                    v1 = v1 + parseInt(hexData[i]);
                                }
                                console.log(v1);
                                hexData.push(v1 % 256);
                                hexData.push(0x16);

                                var ByteToSend = "";
                                for (var i = 0; i < hexData.length; i++) {
                                    ByteToSend = ByteToSend + b2s(hexData[i]) + " ";
                                    //console.log(hexData[i].toString(16));
                                }

                                var user = new Object();
                                user.msg = ByteToSend;
                                user.res = 1;

                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrB[1]) + sprintf("%02d", addrB[0]);
                                console.log(straddr);

                                user.addr = straddr;//"02170101";
                                $datajson = JSON.stringify(user);
                                console.log($datajson);
                                websocket.send($datajson);

                            }
                        }


                    }

                    document.getElementById("configswitch").onclick = function () {
                        var nodes = $('#tt').tree('getChecked');
                        var len = 18;     //固定长度
                        //
                        //删除所有主控开关
                        //68 72 00 72 00 68 04 02 17 01 01 02 A4 74 00 00 40 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7C 16
                        //alert("删除");
                        var mount = $("#mount").val();
                        var backsetindex = $("#backsetindex").val();
                        var Measuringpoint = $("#Measuringpoint").val();
                        var workgroupe = $("#workgroupe").val();
                        var workmode = $("#workmode").find("option:selected").val();
                        var mail_addr = $("#mail_addr").val();


                        for (var i = 0; i < nodes.length; i++) {
                            var obj = nodes[i];
                            var cnode = $("#tt").tree("getChildren", obj.target);
                            if (cnode.length == 0) {
                                var txt = obj.text;
                                var arrtxt = txt.split("|");
                                var addrArea = Str2Bytes(arrtxt[0]);  //地址域
                                var addrB = Str2Bytes(arrtxt[1]);
                                var hexData = new Array();
                                hexData[0] = 0x68;
                                hexData[5] = 0x68;
                                hexData[6] = 0x04;   //控制域
                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                hexData[11] = 0x2  //地址C  单地址或组地址
                                hexData[12] = 0xA4;  //功能码
                                hexData[13] = 0x71  //帧序列  

                                hexData[14] = 0  //   DA1
                                hexData[15] = 0  //    DA2
                                hexData[16] = 0x20  //  DT1
                                hexData[17] = 0x03  //   DT2
                                hexData[18] = parseInt(mount, 10);
                                hexData[19] = parseInt(backsetindex, 10);
                                hexData[20] = 0x0;
                                hexData[21] = parseInt(Measuringpoint, 10);
                                hexData[22] = 0x0;
                                hexData[23] = parseInt(mail_addr, 10);
                                hexData[24] = parseInt(workmode, 10);
                                hexData[25] = parseInt(workgroupe, 10);

                                var len1 = 18 - 6 + 1 + 2 + 2 + 1 + 1 + 1//18是固定长度  判断是否有长度
                                hexData[1] = len1 << 2 | 2;
                                hexData[2] = 0;
                                hexData[3] = len1 << 2 | 2;
                                hexData[4] = 0;

                                var v1 = 0;
                                for (var i = 6; i < hexData.length; i++) {
                                    //console.log(parseInt(hexData[i]));
                                    v1 = v1 + parseInt(hexData[i]);
                                }
                                console.log(v1);
                                hexData.push(v1 % 256);
                                hexData.push(0x16);

                                var ByteToSend = "";
                                for (var i = 0; i < hexData.length; i++) {
                                    ByteToSend = ByteToSend + b2s(hexData[i]) + " ";
                                    //console.log(hexData[i].toString(16));
                                }

                                var user = new Object();
                                user.msg = ByteToSend;
                                user.res = 1;

                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrB[1]) + sprintf("%02d", addrB[0]);
                                console.log(straddr);

                                user.addr = straddr;//"02170101";
                                $datajson = JSON.stringify(user);
                                console.log($datajson);
                                websocket.send($datajson);

                            }
                        }
                    }

                    document.getElementById("switchin").onclick = function () {
                        var nodes = $('#tt').tree('getChecked');
                        var setindex = $("#setindex").val();

                        var valswitch = $("#lightswitch").find("option:selected").val();


                        console.log("******************")
                        var len = 18;     //固定长度
                        for (var i = 0; i < nodes.length; i++) {
                            var obj = nodes[i];
                            var cnode = $("#tt").tree("getChildren", obj.target);
                            if (cnode.length == 0) {
                                var txt = obj.text;
                                var arrtxt = txt.split("|");
                                var addrArea = Str2Bytes(arrtxt[0]);  //地址域
                                var addrB = Str2Bytes(arrtxt[1]);
                                var hexData = new Array();
                                hexData[0] = 0x68;
                                hexData[5] = 0x68;
                                hexData[6] = 0x04;   //控制域
                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                hexData[11] = 0x2  //地址C  单地址或组地址
                                hexData[12] = 0xA5;  //功能码
                                hexData[13] = 0x72  //帧序列  

                                hexData[14] = 0  //   DA1
                                hexData[15] = 0  //    DA2
                                hexData[16] = 0x08  //  DT1
                                hexData[17] = 0x02  //   DT2
                                hexData[18] = parseInt(setindex, 10);
                                hexData[19] = 0x0;
                                hexData[20] = parseInt(valswitch, 10)

                                var len1 = 18 + 2 + 1 - 6//18是固定长度
                                hexData[1] = len1 << 2 | 2;
                                hexData[2] = 0;
                                hexData[3] = len1 << 2 | 2;
                                hexData[4] = 0;

                                var v1 = 0;
                                for (var i = 6; i < hexData.length; i++) {
                                    //console.log(parseInt(hexData[i]));
                                    v1 = v1 + parseInt(hexData[i]);
                                }
                                console.log(v1);
                                hexData.push(v1 % 256);
                                hexData.push(0x16);

                                var ByteToSend = "";
                                for (var i = 0; i < hexData.length; i++) {
                                    ByteToSend = ByteToSend + b2s(hexData[i]) + " ";
                                    //console.log(hexData[i].toString(16));
                                }

                                var user = new Object();
                                user.msg = ByteToSend;
                                user.res = 1;

                                hexData[7] = parseInt(addrArea[1].toString(10), 16)             //地址域
                                hexData[8] = parseInt(addrArea[0].toString(10), 16)   //地址域
                                hexData[9] = addrB[1]  //地址A
                                hexData[10] = addrB[0]  //地址A
                                var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrB[1]) + sprintf("%02d", addrB[0]);
                                console.log(straddr);

                                user.addr = straddr;//"02170101";
                                $datajson = JSON.stringify(user);
                                console.log($datajson);
                                websocket.send($datajson);

                            }
                        }
                    }

                }




                //接收到消息的回调方法
                websocket.onmessage = function (e) {

                    console.log(e.data);
                    var ArrData = JSON.parse(e.data);
                    var obj = ArrData[0];
                    if (obj.hasOwnProperty("msg")) {
                        alert(obj.msg);
                    }


                }

                //连接关闭的回调方法
                websocket.onclose = function () {
                    console.log("websocket close");
                    websocket.close();
                }


                //连接发生错误的回调方法
                websocket.onerror = function () {
                    console.log("Webscoket连接发生错误");
                }

                //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
                window.onbeforeunload = function () {
                    websocket.close();
                }

                openPwd();

                $('#editpass').click(function () {
                    $('#w').window('open');
                });

                $('#btnEp').click(function () {
                    serverLogin();
                })

                $('#btnCancel').click(function () {
                    closePwd();
                })

                $('#loginOut').click(function () {
                    $.messager.confirm('系统提示', '您确定要退出本次登录吗?', function (r) {

                        if (r) {
                            location.href = '/ajax/loginout.ashx';
                        }
                    });
                })
            });





            function str_repeat(i, m) {
                for (var o = []; m > 0; o[--m] = i)
                    ;
                return o.join('');
            }

            function sprintf() {
                var i = 0, a, f = arguments[i++], o = [], m, p, c, x, s = '';
                while (f) {
                    if (m = /^[^\x25]+/.exec(f)) {
                        o.push(m[0]);
                    } else if (m = /^\x25{2}/.exec(f)) {
                        o.push('%');
                    } else if (m = /^\x25(?:(\d+)\$)?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(f)) {
                        if (((a = arguments[m[1] || i++]) == null) || (a == undefined)) {
                            throw('Too few arguments.');
                        }
                        if (/[^s]/.test(m[7]) && (typeof (a) != 'number')) {
                            throw('Expecting number but found ' + typeof (a));
                        }
                        switch (m[7]) {
                            case 'b':
                                a = a.toString(2);
                                break;
                            case 'c':
                                a = String.fromCharCode(a);
                                break;
                            case 'd':
                                a = parseInt(a);
                                break;
                            case 'e':
                                a = m[6] ? a.toExponential(m[6]) : a.toExponential();
                                break;
                            case 'f':
                                a = m[6] ? parseFloat(a).toFixed(m[6]) : parseFloat(a);
                                break;
                            case 'o':
                                a = a.toString(8);
                                break;
                            case 's':
                                a = ((a = String(a)) && m[6] ? a.substring(0, m[6]) : a);
                                break;
                            case 'u':
                                a = Math.abs(a);
                                break;
                            case 'x':
                                a = a.toString(16);
                                break;
                            case 'X':
                                a = a.toString(16).toUpperCase();
                                break;
                        }
                        a = (/[def]/.test(m[7]) && m[2] && a >= 0 ? '+' + a : a);
                        c = m[3] ? m[3] == '0' ? '0' : m[3].charAt(1) : ' ';
                        x = m[5] - String(a).length - s.length;
                        p = m[5] ? str_repeat(c, x) : '';
                        o.push(s + (m[4] ? a + p : p + a));
                    } else {
                        throw('Huh ?!');
                    }
                    f = f.substring(m[0].length);
                }
                return o.join('');
            }



            function hexCharCodeToStr(hexCharCodeStr) {
                var trimedStr = hexCharCodeStr.trim();
                var rawStr =
                        trimedStr.substr(0, 2).toLowerCase() === "0x"
                        ?
                        trimedStr.substr(2)
                        :
                        trimedStr;
                var len = rawStr.length;
                if (len % 2 !== 0) {
                    alert("Illegal Format ASCII Code!");
                    return "";
                }
                var curCharCode;
                var resultStr = [];
                for (var i = 0; i < len; i = i + 2) {
                    curCharCode = parseInt(rawStr.substr(i, 2), 16); // ASCII Code Value
                    resultStr.push(String.fromCharCode(curCharCode));
                }
                return resultStr.join("");
            }
            function stringToByte(str) {
                var bytes = new Array();
                var len, c;
                len = str.length;
                for (var i = 0; i < len; i++) {
                    c = str.charCodeAt(i);
                    if (c >= 0x010000 && c <= 0x10FFFF) {
                        bytes.push(((c >> 18) & 0x07) | 0xF0);
                        bytes.push(((c >> 12) & 0x3F) | 0x80);
                        bytes.push(((c >> 6) & 0x3F) | 0x80);
                        bytes.push((c & 0x3F) | 0x80);
                    } else if (c >= 0x000800 && c <= 0x00FFFF) {
                        bytes.push(((c >> 12) & 0x0F) | 0xE0);
                        bytes.push(((c >> 6) & 0x3F) | 0x80);
                        bytes.push((c & 0x3F) | 0x80);
                    } else if (c >= 0x000080 && c <= 0x0007FF) {
                        bytes.push(((c >> 6) & 0x1F) | 0xC0);
                        bytes.push((c & 0x3F) | 0x80);
                    } else {
                        bytes.push(c & 0xFF);
                    }
                }
                return bytes;


            }

            function byteToString(arr) {
                if (typeof arr === 'string') {
                    return arr;
                }
                var str = '',
                        _arr = arr;
                for (var i = 0; i < _arr.length; i++) {
                    var one = _arr[i].toString(2),
                            v = one.match(/^1+?(?=0)/);
                    if (v && one.length == 8) {
                        var bytesLength = v[0].length;
                        var store = _arr[i].toString(2).slice(7 - bytesLength);
                        for (var st = 1; st < bytesLength; st++) {
                            store += _arr[st + i].toString(2).slice(2);
                        }
                        str += String.fromCharCode(parseInt(store, 2));
                        i += bytesLength - 1;
                    } else {
                        str += String.fromCharCode(_arr[i]);
                    }
                }
                return str;
            }
            function Str2Bytes(str) {
                var pos = 0;
                var len = str.length;
                if (len % 2 != 0)
                {
                    return null;
                }
                len /= 2;
                var hexA = new Array();
                for (var i = 0; i < len; i++)
                {
                    var s = str.substr(pos, 2);
                    var v = parseInt(s);
                    hexA.push(v);
                    pos += 2;
                }
                return hexA;
            }
        </script>
        <title>JSP Page</title>
    </head>
    <body  class="easyui-layout" style="overflow-y: hidden"  fit="true"   scroll="no">

        <!--        <div id="loading-mask" style="position:absolute;top:0px; left:0px; width:100%; height:100%; background:#D2E0F2; z-index:20000">
                    <div id="pageloading" style="position:absolute; top:50%; left:50%; margin:-120px 0px 0px -120px; text-align:center;  border:2px solid #8DB2E3; width:200px; height:40px;  font-size:14px;padding:10px; font-weight:bold; background:#fff; color:#15428B;"> 
                        <img src="images/loading.gif" align="absmiddle" /> 正在加载中,请稍候...</div>
                </div>-->

        <div region="north" split="true" border="false" style="overflow: hidden; height: 30px;
             line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
            <span style="float:right; padding-right:20px;" class="head">欢迎 疯狂秀才 <a href="#" id="editpass">修改密码</a> <a href="#" id="loginOut">安全退出</a></span>
            <span style="padding-left:10px; font-size: 16px; "> jQuery.EasyUI- 1.2.6 应用实例</span>
        </div>
        <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
            <div class="footer">By 疯狂秀才(QQ:1055818239) jQuery.Easy-UI QQ讨论群： 112044258、32994605、36534121、56271061</div>
        </div>
        <div region="west" split="true"  title="导航菜单" style="width:180px;" id="west">
            <div id="nav">
                <!--  导航内容 -->
                <ul id="tt"></ul>
            </div>

        </div>
        <div id="mainPanle" region="center" style="background: #eee; overflow-y:hidden">
            <div id="tabs" class="easyui-tabs" data-options="tools:'#tab-tools',tabWidth:112"  fit="true" border="false" >

                <div title="调光" style="padding: 20px;overflow: hidden; color: red;">
                    <label style="color: black">
                        调光值:
                    </label>
                    <input id="lightval" class="easyui-numberspinner" data-options="min:0,max:10" value="0" style="width:40px; padding: 3px;"></input>

                    <label style="color: black">
                        灯装置序号:
                    </label>
                    <input id="lighset" class="easyui-input"  value="38" style="width:40px; padding: 3px;"></input>           

                    <input id="btnlight" type="button" value="调光" />
                </div>

                <div title="配置回路" style="padding: 20px;overflow: hidden; color: red;">
                    <div style="width: 380px; border: 1px solid #38B1B9">
                        <table>
                            <tr>
                                <td><label style="color: black">本次数量:</label></td>
                                <td>  <input class="easyui-textbox" id="mount" name="mount" value="1" type="text"/></td>
                            </tr>
                            <tr>
                                <td><label style="color: black">回路装置序号:</label></td>
                                <td><input class="easyui-textbox" id="backsetindex" name="backsetindex" value="54" type="text"/></td>
                            </tr>
                            <tr>
                                <td><label style="color: black">测量点号:</label></td>
                                <td><input class="easyui-textbox" id="Measuringpoint" name="Measuringpoint" value="54" type="text"/></td>
                            </tr>
                            <tr><td><label style="color: black">通信地址:</label></td>
                                <td><input class="easyui-textbox" id="mail_addr" name="mail_addr" value="84" type="text"/></td>
                            </tr>
                            <tr><td><label style="color: black">工作方式:</label> </td>
                                <td>
                                    <select id="workmode"  name="workmode" style="width:100px;">
                                        <option value="0">时间</option>
                                        <option value="1">经纬度</option>

                                    </select>

                                </td>
                            </tr>

                            <tr>
                                <td><label style="color: black">回路所属的组号:</label></td>
                                <td><input class="easyui-textbox" id="workgroupe" name="workgroupe" value="1" type="text"/></td>
                            </tr>
                            <tr><td><input id="deleteswitch" type="button"  value="删除主控开关全部信息"  /> </td>
                                <td><input  id="configswitch" type="button"  value="配置主控开关"  /></td>
                            </tr>
                        </table>

                    </div>
                </div>


                <div title="跳合闸" style="padding: 20px;overflow: hidden; color: red;">
                    <div style="width: 380px; border: 1px solid #38B1B9">
                        <table>

                            <tr>
                                <td><label style="color: black">装置序号:</label></td>
                                <td><input class="easyui-textbox" id="setindex" name="backsetindex" value="54" type="text"/></td>
                            </tr>

                            <tr><td><label style="color: black">跳合闸:</label> </td>
                                <td>
                                    <select id="lightswitch"  name="lightswitch" style="width:100px;">
                                        <option value="85">开灯</option>
                                        <option value="170">关灯</option>
                                    </select>

                                </td>
                            </tr>

                            <tr><td><input id="switchin" type="button"  value="合闸"  /> </td>

                            </tr>
                        </table>

                    </div>
                </div>




            </div>
            <div id="tab-tools">
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'" onclick="addPanel()"></a>
                <a href="javascript:void(0)" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="removePanel()"></a>
            </div>


        </div>


    </body>
</html>
