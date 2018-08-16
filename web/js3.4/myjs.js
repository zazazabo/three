/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function formToJson(formObj) {
    var o = {};
    var a = formObj.serializeArray();
    $.each(a, function() {
        if (this.value) {
            if (o[this.name]) {
                if (!o[this.name].push) {
                    o[this.name] = [o[this.name]];
                }
                o[this.name].push(this.value || null);
            } else {
                if ($("[name='" + this.name + "']:checkbox", formObj).length) {
                    o[this.name] = [this.value];
                } else {
                    o[this.name] = this.value || null;
                }
            }
        }
    });
    return o;
}
/* url: 没带参数的url
 * param:参数a=2&b=6&u=9   form表单的话 $('fm1').serialize();
 * data: 返回值
 * 默认为post方式
 */
function getURLData(url, param,data) {
    $.ajax({
        url: url,
        data: param,
        type: "post",
        success: function(data) {
//            alert(data);
            return data;
        }
    });
}