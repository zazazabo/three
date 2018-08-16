
/**
 * 发送 ajax请求
 * @param data
 * @param action 请求链接
 * @param type 请求类型
 * @param async 是否是异步请求
 * @param callback 正确回调
 * @param failCallback 异常回调
 * @param errorCallback 错误回调
 * @returns
 */
function doXMLHttpRequest(data, action, type, async, callback, failCallback, errorCallback) {
	var submitData = data;
	if (typeof data != "string") {
		submitData = JSON.stringify(data);
	}
	else {
		JSON.parse(data);
	}
	$.ajax({
		url:action,
		type:type,
		contentType:"application/json",
		data:submitData,
		dataType:"json",
		async:async,
		success:function(result, status, xhr) {
			if (utils.isNotUndefinedOrNull(result.status) && result.status == 0 &&
				utils.isNotUndefinedOrNull(failCallback)) {
				failCallback(result, result, status, xhr);
				return;
			}
			if(utils.isNotUndefinedOrNull(callback)) {
				callback(result, status, xhr);	
		   }
		},
		error:function(xhr, status, error) {
			if(utils.isNotUndefinedOrNull(errorCallback)){
				errorCallback(xhr, status, error);
				return;
			}
			alert("服务器内部错误或通讯异常");
		}
	});
}

/**
 * jquery ajax全局错误处理
 */
/*$(document).ajaxError(function(event, xhr, options, exc) {
	if (xhr.status = 403) {
	   window.location.href = event.target.baseURI + "sessionError.jsp";
	}
});*/

/**
 * 异步 post ajax 请求
 */
function doPostRequest(data, action, callback, failCallback, errorCallback) {
	doXMLHttpRequest(data, action, "post", true, callback, failCallback, errorCallback);
}

/**
 * 同步 post ajax 请求
 * @returns
 */
function doSyncPostRequest(data, action, callback, failCallback, errorCallback) {
	doXMLHttpRequest(data, action, "post", false, callback, failCallback, errorCallback);
}

/**
 * post ajax 提交form表单
 * @param submitform
 * @param action
 * @param callback
 * @param failCallback
 * @param errorCallback
 * @returns
 */
function submitFormByAjax(submitform, action, callback, failCallback, errorCallback) {
	var form = $(submitform).serializeArray();
    var data = {};
    for (var i = 0; i < form.length; i++) {
    	var e = form[i];
    	data[e.name] = data.hasOwnProperty(e.name) ? 
    			(data[e.name] + "," + e.value.toString()) : e.value.toString();
    }
    doPostRequest(data, action, callback, failCallback, errorCallback);
}
