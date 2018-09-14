$.fn.serializeObject = function () {
    var o = {};
    var a = this.serializeArray();
//    console.log(a);
    $.each(a, function () {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
}


String.prototype.trim = function () {
    return this.replace(/(^\s*)|(\s*$)/g, "");

}

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

function isJSON(str) {
    if (typeof str == 'string') {
        try {
            var obj = JSON.parse(str);
            if (typeof obj == 'object' && obj) {
                return true;
            } else {
                return false;
            }

        } catch (e) {
            console.log('error：' + str + '!!!' + e);
            return false;
        }
    }
    console.log('It is not a string!')
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

function Str2BytesH(str) {
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
        var v = parseInt(s, 16);
        hexA.push(v);
        pos += 2;
    }
    return hexA;
}





function checkModify()
{


    if (/^[0-9A-F]{8}$/.test($("#comaddr_").val().trim()) == false) {
        layer.alert('网关地址应为八位有效十六进制字符', {
            icon: 6,
            offset: 'center'
        });
        return false;
    }

    var name = $("#name_").val();
    var addr = $("#comaddr_").val();

    var model = $('#model_').combobox('getValue');
    var namesss = false;
    var jsondata = $("#modifyTypeForm").serializeObject();
//    console.log(jsondata);
//    return  false;
    var latitudemstr = jsondata.latitudem26d_ + "." + jsondata.latitudem26m_ + "." + jsondata.latitudem26s_;
    jsondata.latitude = latitudemstr;
    var longitudemstr = jsondata.longitudem26d_ + "." + jsondata.longitudem26m_ + "." + jsondata.longitudem26s_;
    jsondata.longitude = longitudemstr;
    console.log(jsondata);
    $.ajax({
        async: false,
        cache: false,
        url: "test1.gayway.modifyGateway.action",
        type: "GET",
        data: jsondata,
        success: function (data) {
            $("#gravidaTable").bootstrapTable('refresh');
            namesss = true;
        },
        error: function () {
            layer.alert('系统错误，刷新后重试', {
                icon: 6,
                offset: 'center'
            });
        }
    })
    return namesss;

}


function getComAddr(comaddr) {
    var addrArea = Str2Bytes(comaddr);
    var straddr = sprintf("%02d", addrArea[1]) + sprintf("%02d", addrArea[0]) + sprintf("%02d", addrArea[3]) + sprintf("%02d", addrArea[2]);
    return straddr;
}



function get2byte(num) {

    var ddd = parseInt(num);
    var str = ddd.toString(16);
    var str1 = sprintf("%04s", str);
    return str1;
}



function b2s(param) {
    var retstr;
    var s = param.toString(16);
    if (param < 16) {
        retstr = "0" + s;
    } else {
        retstr = s;
    }

    return retstr;
}


function randnum(n, m) {
    var c = m - n + 1;
    return Math.floor(Math.random() * c + n);

}


//地址域 字符串  控制域:整数   AFN:功能码 整数   SEQ:帧序列 整数 0x72    DA 整数  DT 整数  参数数组:
function  buicode(comaddr, C, AFN, SEQ, DA, DT, paraArr) {


    var addrArea = Str2BytesH(comaddr);

    var rda = sprintf("%04d", DA);
    var rdt = sprintf("%04d", DT);
    var datemp = Str2BytesH(rda);
    var dttemp = Str2BytesH(rdt);

    var hexData = new Array();
    hexData[0] = 0x68;
    hexData[5] = 0x68;
    hexData[6] = C;//0x4;   //控制域
    hexData[7] = addrArea[1]; //parseInt(sprintf("0x%02d", addrArea[1]), 16)             //地址域
    hexData[8] = addrArea[0];              //parseInt(sprintf("0x%02d", addrArea[0]), 16)   //地址域
    hexData[9] = addrArea[3];                           //parseInt(sprintf("0x%02d", addrArea[3]), 16)
    hexData[10] = addrArea[2];         //parseInt(sprintf("0x%02d", addrArea[2]), 16)
    hexData[11] = 0x02  //地址C  单地址或组地址
    hexData[12] = AFN;  //功能码
    hexData[13] = SEQ  //帧序列  

    hexData[14] = datemp[1]; //   DA1
    hexData[15] = datemp[0];

    hexData[16] = dttemp[1];
    hexData[17] = dttemp[0];

    for (var j = 0; j < paraArr.length; j++) {
        hexData.push(paraArr[j]);
    }

    var len1 = 18 - 6 + paraArr.length;   //18是固定长度  6报文头  
    var len2 = len1 << 2 | 2;

    var a = len2 >> 8 & 0x000F;
    var b = len2 & 0x00ff;



    hexData[1] = b               //len1 << 2 | 2;
    hexData[2] = a

    hexData[3] = b         //len1 << 2 | 2;
    hexData[4] = a

    var v1 = 0;
    for (var i = 6; i < hexData.length; i++) {
        //console.log(parseInt(hexData[i]));
        v1 = v1 + hexData[i];
    }
//    console.log(v1);
    hexData.push(v1 % 256);
    hexData.push(0x16);

    var ByteToSend = "";
    for (var i = 0; i < hexData.length; i++) {
        ByteToSend = ByteToSend + b2s(hexData[i]) + " ";
        //console.log(hexData[i].toString(16));
    }

    return ByteToSend;
}


function delendchar(str) {
    while (str.lastIndexOf('|') == str.length - 1) {
        if (str.lastIndexOf('|') == -1) {
            break;
        }
        str = str.substring(0, str.lastIndexOf('|'));
    }
    return str;
}


/**
 *  先把父亲节点取出来，放进一个数组dataArray
 * @param {Object} datas 所有数据
 */
function data2tree(datas) {
    var dataArray = [];
    datas.forEach(function (data) {
        var CATL_PARENT = data.m_parent;
        if (CATL_PARENT == '0') {
            var CATL_CODE = data.m_code;
            var CATL_NAME = data.m_title;
            var action = data.m_action;
            var icon = data.m_icon;
            var objTemp = {
                parent: CATL_PARENT,
                code: CATL_CODE,
                title: CATL_NAME,
                action: action,
                icon: icon
            }
            dataArray.push(objTemp);
        }
    });
    return data2treeDG(datas, dataArray);
}


/**
 * 
 * @param {Object} datas  所有数据
 * @param {Object} dataArray 父节点组成的数组
 */
function data2treeDG(datas, dataArray) {
    for (var j = 0; j < dataArray.length; j++) {
        var dataArrayIndex = dataArray[j];
        var childrenArray = [];
        var CATL_CODEP = dataArrayIndex.code;

        for (var i = 0; i < datas.length; i++) {
            var data = datas[i];
            var CATL_PARENT = data.m_parent;
            if (CATL_PARENT == CATL_CODEP) {//判断是否为儿子节点
                var CATL_CODE = data.m_code;
                var CATL_NAME = data.m_title;
                var action = data.m_action;
                var icon = data.m_icon;
                var objTemp = {
                    parent: CATL_PARENT,
                    code: CATL_CODE,
                    title: CATL_NAME,
                    action: action,
                    icon: icon
                }
                childrenArray.push(objTemp);
            }

        }
        dataArrayIndex.children = childrenArray;
        if (childrenArray.length > 0) {//有儿子节点则递归
            data2treeDG(datas, childrenArray);
        }

    }
    return dataArray;
}




function isNumber(val) {

    var regPos = /^\d+(\.\d+)?$/; //非负浮点数
    var regNeg = /^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$/; //负浮点数
    if (regPos.test(val) || regNeg.test(val)) {
        return true;
    } else {
        return false;
    }

}



