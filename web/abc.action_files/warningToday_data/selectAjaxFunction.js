/**
 * 
 */

function loadSelect(obj, url, data, fieldId, fieldName) {
	var options = '<option value="">全部</option>';
	if((data != '') || (fieldId == 'adv_id') || (fieldId == 'uid')) {
		$.ajax({
			async: false,
			cache: false,
			type: "post",
			url: url,
			data: data,
			dataType: "json",
			success: function(data) {
				var v = '', text = '';
				$.each(data,function(i, item) {
					v = item[fieldId];
					text = item[fieldName];
					if(item["section_count"] != undefined) {
						options += "<option value='"+ v +"' section_count='" + item["section_count"] + "'>"+ text +"</option>";
					} else if(item["latitude"] != undefined) {
						options += "<option value='"+ v +"' longitude='" + item["longitude"] + "' latitude='" + item["latitude"] + "'>"+ text +"</option>";
					} else if(item["projectId"] != undefined) {
						options += "<option value='"+ v +"' projectId='" + item["projectId"] + "'>"+ text +"</option>";
					} else{
						options += "<option value='"+ v +"'>"+ text +"</option>";
					}
				});
				obj.html(options);
				if(text == undefined) {
					var timeLeft = 4;
					layer.open({content: '您长时间未进行任何操作，会话已超时哟!' + timeLeft + '秒后跳转至登录页', icon: 4, yes: function(index, layero) {
						var pathname = window.location.pathname;
				    	window.top.location.href = pathname.substring(0, pathname.substring(1).indexOf("/") + 1);
					}, success: function(layero, index) {
						setInterval(function() {
							timeLeft--;
							var iElement = $(layero).find('div:eq(1) i');
							$(layero).find('div:eq(1)').empty().append(iElement).append('您长时间未进行任何操作，会话已超时哟!' + timeLeft + '秒后跳转至登录页');
						}, 1000);
                        setTimeout(function() {
                        	var pathname = window.location.pathname;
    				    	window.top.location.href = pathname.substring(0, pathname.substring(1).indexOf("/") + 1);
                        }, 4000);
                    }});
				}
			},
			error: function() {
			}
		});
	}
}

function loadFormSelect(obj, url, data, fieldId, fieldName, form) {
	var options = '<option value="">全部</option>';
	if((data != '') || (fieldId == 'adv_id') || (fieldId == 'uid')) {
		$.ajax({
			async: false,
			cache: false,
			type: "post",
			url: url,
			data: data,
			dataType: "json",
			success: function(data) {
				var v = '', text = '';
				$.each(data,function(i, item) {
					v = item[fieldId];
					text = item[fieldName];
					if(item["section_count"] != undefined) {
						options += "<option value='"+ v +"' section_count='" + item["section_count"] + "'>"+ text +"</option>";
					} else if(item["latitude"] != undefined) {
						options += "<option value='"+ v +"' longitude='" + item["longitude"] + "' latitude='" + item["latitude"] + "'>"+ text +"</option>";
					} else if(item["projectId"] != undefined) {
						options += "<option value='"+ v +"' projectId='" + item["projectId"] + "'>"+ text +"</option>";
					} else{
						options += "<option value='"+ v +"'>"+ text +"</option>";
					}
				});
				obj.html(options);
				if(form){
					form.render('select');
				}
				if(text == undefined) {
					var timeLeft = 4;
					layer.open({content: '您长时间未进行任何操作，会话已超时哟!' + timeLeft + '秒后跳转至登录页', icon: 4, yes: function(index, layero) {
						var pathname = window.location.pathname;
				    	window.top.location.href = pathname.substring(0, pathname.substring(1).indexOf("/") + 1);
					}, success: function(layero, index) {
						setInterval(function() {
							timeLeft--;
							var iElement = $(layero).find('div:eq(1) i');
							$(layero).find('div:eq(1)').empty().append(iElement).append('您长时间未进行任何操作，会话已超时哟!' + timeLeft + '秒后跳转至登录页');
						}, 1000);
                        setTimeout(function() {
                        	var pathname = window.location.pathname;
    				    	window.top.location.href = pathname.substring(0, pathname.substring(1).indexOf("/") + 1);
                        }, 4000);
                    }});
				}
			},
			error: function() {
			}
		});
	}
}

function loadSelectByRows(obj, url, data, fieldId, fieldName) {
	var options = '<option value="">全部</option>';
	$.ajax({
		type: "post",
		url: url,
		data: data,
		async: false,
		dataType: "json",
		success: function(data) {
			var v = '', text = '';
			$.each(data.rows, function(i, item) {
				v = item[fieldId];
				text = item[fieldName];
				if(item["projectId"] != undefined) {
					options += "<option value='"+ v +"' projectId='" + item["projectId"] + "' organizationId='" + item["organizationId"] + "' divisionId='" + item["divisionId"] + "'>"+ text +"</option>";
				} else{
					options += "<option value='"+ v +"'>"+ text +"</option>";
				}
			});
			if(text == undefined) {
				var timeLeft = 4;
				layer.open({content: '您长时间未进行任何操作，会话已超时哟!' + timeLeft + '秒后跳转至登录页', icon: 4, yes: function(index, layero) {
					var pathname = window.location.pathname;
					window.top.location.href = pathname.substring(0, pathname.substring(1).indexOf("/") + 1);
				}, success: function(layero, index) {
					setInterval(function() {
						timeLeft--;
						var iElement = $(layero).find('div:eq(1) i');
						$(layero).find('div:eq(1)').empty().append(iElement).append('您长时间未进行任何操作，会话已超时哟!' + timeLeft + '秒后跳转至登录页');
					}, 1000);
					setTimeout(function() {
						var pathname = window.location.pathname;
						window.top.location.href = pathname.substring(0, pathname.substring(1).indexOf("/") + 1);
					}, 4000);
				}});
			}
		},
		error: function() {
		}
	});
	obj.html(options);
}

function loadSelectDisabled(id, value) {
	$("#" + id + " option").each(function() {
		if($(this).attr("value") != value || $(this).attr("value") == "") {
			$(this).remove();
		}
	});
}

function loadSelectRows(obj, url, data_1, data_2, fieldId, fieldName) {
	var options = '<option value="">全部</option>';
	if((data_1 != '') || (data_2 != '')) {
		$.ajax({
			type: "post",
			url: url,
			data: {
				prj_id: data_1,
				gateway_id: data_2
			},
			async: false,
			dataType: "json",
			success: function(data) {
				$.each(data.rows,function(i, item) {
					var v = item[fieldId];
					var text = item[fieldName];
					options += "<option value='"+ v +"' type='" + ((item.attributes.temperature != undefined)?"temperature":(item.attributes.humidity != undefined)?"humidity":"lux") + "'>"+ text +"</option>";
				});
			},
			error: function() {
			}
		});
	}
	obj.html(options);
}

/*function loadSelect2(obj, url, data,data2,  fieldId,fieldName) {
	var options = '<option value="">全部</option>';
   	$.ajax({
       	type: "get",
       	url: url,
       	data: {
       		data,
       		data2
       	},
       	async: false,
       	dataType: "json",
       	success: function(data) {
	       	$.each(data,function(i, item) {
				var v = item[fieldId];
				var text = item[fieldName];
				options += "<option value='"+ v +"'>"+ text +"</option>";
	       	});
       	},
       	error: function() {
       		alert("数据错误");
       	}
	});
	obj.html(options);
}*/

/*function loadSubSelect(obj,url,data, tunnelName) {
	var options = '<option value="">全部</option>';
	$.ajax({
		type:"get",
		url:url,
		data:data,
		async:false,
		dataType:"json",
		success:function(data){
			$.each(data,function(i,item){
				var v = item["subSectionId"];
				var text = item["subSectionType"];
				options += "<option value='"+ v +"'>"+ tunnelName + ((text == "1")?"加强段":((text == "2")?"应急段":"基本段")) +"</option>";
			});
		},
		error:function(){
			alert("数据错误");
		}
	});
	obj.html(options);
}

function loadMapSelect(obj,url,data,fieldId,fieldName, longitude, latitude, OnLine) {
	var options = '<option value="">全部</option>';
   	$.ajax({
       	type:"get",
       	url:url,
       	data:data,
       	async:false,
       	dataType:"json",
       	success:function(data){
	       	$.each(data,function(i,item){
				var v= item[fieldId];
				var text = item[fieldName];
				options += "<option value='"+ v +"' lo='" + item[longitude] + "' la='" + item[latitude] + "' OnLine='" + item[OnLine] + "'>"+ text +"</option>";
	       	});
       	},
       	error:function(){
       		alert("数据错误");
       	}
	});
	obj.html(options);
}

function loadSubModifySelect(obj,url,data, tunnelName, select) {
	var options = '<option value="">全部</option>';
	$.ajax({
		type:"get",
		url:url,
		data:data,
		async:false,
		dataType:"json",
		success:function(data){
			$.each(data,function(i,item){
				var v = item["subSectionId"];
				var text = item["subSectionType"];
				if(v == select) {
					options += "<option value='" + v + "' selected='selected'>"+ tunnelName + ((text == "1")?"加强段":((text == "2")?"应急段":"基本段")) +"</option>";
				} else {
					options += "<option value='" + v + "'>"+ tunnelName + ((text == "1")?"加强段":((text == "2")?"应急段":"基本段")) +"</option>";
				}
			});
		},
		error:function(){
			alert("数据错误");
		}
	});
	obj.html(options);
}

function loadModifySelect(obj,url,data,fieldId,fieldName, select) {
	var options = '<option value="">全部</option>';
	$.ajax({
		type:"get",
		url:url,
		data:data,
		async:false,
		dataType:"json",
		success:function(data){
			$.each(data,function(i,item){
				var v = item[fieldId];
				var text = item[fieldName];
				if(v == select) {
					options += "<option value='" + v + "' selected='selected'>"+ text +"</option>";
				} else {
					options += "<option value='" + v + "'>"+ text +"</option>";
				}
			});
		},
		error:function(){
			alert("数据错误");
		}
	});
	obj.html(options);
}

function loadSortSelect(obj,url,data,fieldId,fieldName, gprsSort) {
	var options = '<option value="">全部</option>';
   	$.ajax({
       	type:"get",
       	url:url,
       	data:data,
       	async:false,
       	dataType:"json",
       	success:function(data){
	       	$.each(data,function(i,item){
				var v = item[fieldId];
				var text = item[fieldName];
				options += "<option value='"+ v +"' sort='" + item[gprsSort] + "'>"+ text +"</option>";
	       	});
       	},
       	error:function(){
       		alert("数据错误");
       	}
	});
	obj.html(options);
}
*/

function enforceInputFloat(id) {
	var val = document.getElementById(id).value;
    var reg = /^-?\d*\.?\d*$/;
    if(!reg.test(val)) {
    	layer.open({
            content: "只能输入数字!", icon: 5, yes: function(index, layero) {
                layer.close(index);
                document.getElementById(id).focus();
            }
        });
        return false;
    }
    return true;
}

function enforceInputLongitudeDegree(degree) {
	var degreeInt = parseInt(degree);
	if(degreeInt < -180 || degreeInt > 180) {
		layer.open({
			content: "经度数值无效!", icon: 5, yes: function(index, layero) {
				layer.close(index);
				document.getElementById(id).focus();
			}
		});
		return false;
	}
	return true;
}

function enforceInputLatitudeDegree(degree) {
	var degreeInt = parseInt(degree);
	if(degreeInt < -90 || degreeInt > 90) {
		layer.open({
			content: "纬度数值无效!", icon: 5, yes: function(index, layero) {
				layer.close(index);
				document.getElementById(id).focus();
			}
		});
		return false;
	}
	return true;
}

function enforceInputLteSixty(degree) {
	var degreeInt = parseFloat(degree);
	if(degreeInt < 0 || degreeInt >= 60) {
		layer.open({
			content: "分或者秒数值无效!", icon: 5, yes: function(index, layero) {
				layer.close(index);
				document.getElementById(id).focus();
			}
		});
		return false;
	}
	return true;
}

function enforceInputPhone(id) {
	var val = document.getElementById(id).value;
	var reg = /^(\(\d{3,4}\)|\d{3,4}-)?\d{7,8}$/;
	var regmp = /^\d{11}$/;
	if(!reg.test(val) && !regmp.test(val)) {
		layer.open({
			content: "号码格式不合法!", icon: 1, yes: function(index, layero) {
				layer.close(index);
				document.getElementById(id).focus();
			}
		});
		return false;
	}
	return true;
}

function parseLongitudeLatitudeFloat(degree, minute, second) {
	return (degree + minute/60 + second/3600).toFixed(6);
}

function parseLongitudeLatitudeDMS(float) {
	var degree = parseInt(float);
	var decimal = float - degree;
	var decimalParseSecond = 3600 * decimal;
	var decimalParseSecondInteger = parseInt(decimalParseSecond);
	var minute = parseInt(decimalParseSecondInteger/60);
	var second = decimalParseSecondInteger % 60;
	return degree + ";" + Math.abs(minute) + ";" + Math.abs(second);
}

function UTCDateStrToLocaleDateStr(str, strLang, targetLang, hasT) {
	var ms_dateStr_or_year;
	var month;
	var day;
	var hour = str.substring(11, 13);
	var minute = str.substring(14, 16);
	var second = str.substring(17, 19);
	if(strLang == 'zh') {
		ms_dateStr_or_year = str.substring(0, 4);
		month = parseInt(str.substring(5, 7)) - 1;
		day = str.substring(8, 10);
	} else {
		ms_dateStr_or_year = str.substring(6, 10);
		month = parseInt(str.substring(0, 2)) - 1;
		day = str.substring(3, 5);
	}
	var date = new Date(ms_dateStr_or_year, month, day, hour, minute, second);
	var dateMilliSeconds = date.getTime();
	var dateLocale = new Date(dateMilliSeconds - new Date().getTimezoneOffset() * 60 * 1000);
	if(targetLang == 'zh') {
		return dateLocale.getFullYear() + '-' + ((dateLocale.getMonth() + 1 > 9)?(dateLocale.getMonth() + 1):'0' + (dateLocale.getMonth() + 1)) + '-' + 
		((dateLocale.getDate() > 9)?dateLocale.getDate():'0' + dateLocale.getDate()) + (hasT?'T':' ') + ((dateLocale.getHours() > 9)?dateLocale.getHours():'0' + dateLocale.getHours()) + ':' + 
		((dateLocale.getMinutes() > 9)?dateLocale.getMinutes():'0' + dateLocale.getMinutes()) + ':' + 
		((dateLocale.getSeconds() > 9)?dateLocale.getSeconds():'0' + dateLocale.getSeconds())
	} else {
		return ((dateLocale.getMonth() + 1 > 9)?(dateLocale.getMonth() + 1):'0' + (dateLocale.getMonth() + 1)) + '/' + 
		((dateLocale.getDate() > 9)?dateLocale.getDate():'0' + dateLocale.getDate()) + '/' + dateLocale.getFullYear() + ' ' + 
		((dateLocale.getHours() > 9)?dateLocale.getHours():'0' + dateLocale.getHours()) + ':' + ((dateLocale.getMinutes() > 9)?dateLocale.getMinutes():'0' + dateLocale.getMinutes()) + 
		':' + ((dateLocale.getSeconds() > 9)?dateLocale.getSeconds():'0' + dateLocale.getSeconds())
	}
}