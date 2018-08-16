
(function(global, jquery) {
	var utils = {};
	
	var isUndefinedOrNull = function (object) {
		return object == undefined || object == null;
	};
	
	utils.isUndefinedOrNull = isUndefinedOrNull;
	
	var isNotUndefinedOrNull = function (object) {
		return !isUndefinedOrNull(object);
	};
    
	utils.isNotUndefinedOrNull = isNotUndefinedOrNull;
	
	var isEmpty = function (object) {
		if (isUndefinedOrNull(object)) {
			return true;
		}
		if (typeof object == "string" && object == "") {
			return true;
		}
	};
	
	utils.isEmpty = isEmpty;
	
	var isNotEmpty = function(object) {
		return !isEmpty(object);
	}
	
	utils.isNotEmpty = isNotEmpty;
	
	if (isUndefinedOrNull(jquery)) {
		console.error("jQuery is missing");
		return;
	};
	
	var $ = jquery;
	
	/**
	 * 加载下拉select
	 * @param name
	 * @param action
	 * @param data
	 * @param idName
	 * @param fieldName
	 * @returns
	 */
	utils.loadSelectInput = function(selectId, action, data, idName, fieldName) {
		var select = $("#" + selectId);
		var options = '<option value=""> 全部 </option>';
		doSyncPostRequest(data, action, function(data) {
			$.each(data, function(i, e) {
				var key = e[idName];
				var value = e[fieldName];
				options += "<option value='" + key + "'>" + value + "</option>";
			});
			select.html(options);
		}, function(error) {
			alert(error.message);
		});
	};
	/**
	 * 获取分组编号
	 */
	utils.loadGroupId=function(groupId, action, data, groupId){
		var gId=$("#"+groupId);
		doSyncPostRequest(data, action, function(data) {
			gId.val(data);
		});
	}
	utils.loadSelectInputs = function(selectId, action, data, idName, fieldName) {
		var select = $("#" + selectId);
		var options = '<option value="">--请选择--</option>';
		doSyncPostRequest(data, action, function(data) {
			$.each(data, function(i, e) {
				var key = e[idName];
				var value = e[fieldName];
				options += "<option value='" + key + "'>" + value + "</option>";
			});
			select.html(options);
		}, function(error) {
			alert(error.message);
		});
	};
	
	//简单校验输入项(name - 校验字段描述信息, input - 校验字段值, 
	//regex -正则表达式, length - 长度限制 {minLength,maxLength}, 
	//isIncludeBlank - 是否允许包含空格(默认允许), isEmpty - 是否可以为空(默认不为空), message - 错误提示消息)
	//printError 回调用于处理错误消息
	utils.validateInput = function (validation, printError) {
		var name = validation.name;
		var input = validation.input;
		var regex = validation.regex;
		var length = validation.length;
		var isIncludeBlank = validation.isIncludeBlank;
		var isEmpty = validation.isEmpty;
		var message = validation.message;
		
		//提示错误信息
		var displayErrorMessage = function(message) {
			var errorMessage = isUndefinedOrNull(message) ? (name + "格式错误") : message;
			if (isNotUndefinedOrNull(printError)) {
				printError(errorMessage, validation);
			}
			else {
				alert(errorMessage);
			}
		}
		//是否可为空
		if (isNotUndefinedOrNull(isEmpty) && isEmpty && input == "") {
			return true;
		}
		//正则表达式校验
	    if(isNotEmpty(regex)) {
			if(!new RegExp(regex).test(input)) {
				displayErrorMessage(message);
				return false;
			}
		}
	    else {
	    	if( isNotUndefinedOrNull(isIncludeBlank) && !isIncludeBlank) {
	    		if (input.indexOf(" ") != -1) {
	    			displayErrorMessage(name + "不能包含空格");
	    			return false;
	    		}
	    	}
	    	if (isNotUndefinedOrNull(length) && (input.length < length.minLength
	    			|| input.length > length.maxLength)) {
	    		if (length.minLength != length.maxLength) {
	    			displayErrorMessage(name + "的长度须为" + length.minLength + "到" + length.maxLength + "个字符");
	    		}
	    		else {
	    			displayErrorMessage(name + "的长度须为" + length.minLength + "个字符");
	    		}
	    		return false;
	    	}
	    }
	    return true;
	};
	
	global.utils = utils;
	
}(window, jQuery));
