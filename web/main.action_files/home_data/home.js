var myChart,myChart2,myChart3,myChart4,myChart5;
$(function(){
//	本月能耗分析
	$.ajax({
		 //async:false,
         cache:false,
		 url:"energyConsumptionOfTheMonth.action",
		 type:"POST",
		 data:{
			 
		 },
		 //dataType:"json",
		 success:function(data) {
		   $("#benyue").html(data[0]);
		   $("#shangyue").html(data[1]);
		   $("#qunian").html(data[2]);
		   $("#lastMonth").html(data[3] + "%");
		   $("#lastYearSameMonth").html(data[4] + "%");
		   var corrosionRatio;
		   var An;
		   
	       var dataX = ["当月能耗", "上月能耗", "去年同期"];
		   var dataY = [data[0], data[1], data[2]];
	       ech('echarts1','能耗分析','能耗',dataX,dataY,'bar','kW·h',"#68b928");
         },
         error:function() {
           layer.alert('系统错误，刷新后重试',{icon: 6,offset: 'center'});
         }
	});
	$.ajax({
		 //async:false,
         cache:false,
		 url:"energyConsumptionOfTheMonth1.action",
		 type:"POST",
		 data:{
			 
		 },
		 //dataType:"json",
		 success:function(data) {
		   $("#pingjun").html(data);
        },
        error:function() {
          layer.alert('系统错误，刷新后重试',{icon: 6,offset: 'center'});
        }
	});
	
    //用能计划
	$.ajax({
		 //async:false,
         cache:false,
		 url:"energySavingRate1.action",
		 type:"POST",
		 data:{
			 
		 },
		 dataType:"json",
		 success:function(data) {
			  $("#planValue").html(data[0].plan_value);
		 	  $("#month").html(data[0].Month);
		 	  $("#num").html(data[0].num);
		 	  //用能计划
		 	  var quanquanData=[{value:data[0].plan_value, name:'计划能耗'},{value:data[0].Month, name:'实际能耗'}];
		 	      quanquan("echarts2", "用能计划", quanquanData, "");
		 	     $(".energySavingRate:eq(0) span:eq(0)").html(data[0].energy + "%");
		 	     $("#planConsumption").html(data[0].plan_value);
		 	     $("#actualConsumption").html(data[0].Month);
		 	     $("#differenceConsumption").html(data[0].num);
		 	     $("#status").html(data[0].status);
         },
         error:function() {
           layer.alert('系统错误，刷新后重试',{icon: 6,offset: 'center'});
         }
	});
	
	//	横向能耗比
	$.ajax({
		//async:false,
		cache:false,
		url:"queryEveryMonth.action",
		type:"POST",
		data:{
				
		},
		dataType:"json",
		success:function(data){
            var dataTitleArray=[data[0].date1.toString(),data[0].date2.toString(),data[0].date3.toString()];
	        var echarts3DataX=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];
			var numberY0=data[0].thisYear1;
			var numberY1=data[0].thisYear2;
			var numberY2=data[0].thisYear3;
			//dataTitleArray=["2015","2016","2017"];
			echarts3("echarts3", "横向对比分析", dataTitleArray, echarts3DataX, dataTitleArray[0], numberY0, dataTitleArray[1], numberY1, dataTitleArray[2], numberY2, "kW·h");
		},  
		error:function(){
		    layer.alert('系统错误，刷新后重试',{icon: 6,offset: 'center'});
		}
	});
 
	//数据趋势
	$.ajax({
	 	 //async:false,
         cache:false,
	 	 url:"queryDataTrends.action",
	 	 type:"POST",
	 	 data:{
	 		 
	 	 },
	 	 dataType:"json",
	 	 success:function(data) {
	 		var echarts4DataX=[data[0].date1,data[0].date2,data[0].date3];
	 		var echarts4DataY=[data[0].thisYear1,data[0].thisYear2,data[0].thisYear3];
	 			ech4('echarts4','数据趋势','能耗',echarts4DataX,echarts4DataY,'bar','kW·h',"#0e62c7");
	 	 }, 
         error:function() {
            layer.alert('系统错误，刷新后重试',{icon: 6,offset: 'center'});
         }
	});
	
    //子项能耗排名
	$.ajax({
	 	//async:false,
        cache:false,
	 	url:"querySubConsumptionRanking.action",
	 	type:"POST",
	 	data:{
	 	},
	 	dataType:"json",
	 	success:function(data) {
	 		var echarts5DataX = ["", "", "", "", ""];
	 		var echarts5DataY = [0, 0, 0, 0, 0];
	 		$.each(data, function(i, item) {
	 			echarts5DataX[i] = item.name;
	 			echarts5DataY[i] = item.consumption;
	 		});
	 		ech5('echarts5', '子项能耗排名', '能耗', echarts5DataX, echarts5DataY, 'bar', 'kW·h', "#799daa");
	 	}, 
        error:function() {
            layer.alert('系统错误，刷新后重试',{icon: 6,offset: 'center'});
        }
	});
	
	window.onresize = function () {
			myChart.resize();
			myChart2.resize();
			myChart3.resize();
			myChart4.resize();
			myChart5.resize();
	}
/*	setTimeout(function(){
		myChart.resize();
		myChart2.resize();
		myChart3.resize();
		myChart4.resize();
		myChart5.resize();
	}, 300);*/
	
})

function ech(id,title,titleY,signXAxis,signYAxis,type,danwei,bg){
	
	 myChart = echarts.init(document.getElementById(id));
        var option = {          
	        		title: {
					        text: title
					    },
					    grid:{
					    		left:'90',
							　　x:50,                        
							　　x2:10,
							　　y2:30
							},
							tooltip: {
						        trigger: 'axis',
						        formatter: function (params) {
						            var tar = params[0];
						            return tar.name + ' : ' + tar.value + ' kW·h';
						        }
						   },
					    legend: {
				        	data:titleY
				    	},
	            toolbox: {
	            	show: true,
	            	feature: {
		            	 magicType: {type: ['line', 'bar']},
				            restore: {},
				            saveAsImage : {show: true,title :'保存为图片'}
	           		}
	            },
	            xAxis: {
					type : 'category',				 
	                 splitLine:{ 
	                     show:false, //去掉X轴辅助线
	                 },
			 		axisLabel:{
					    textStyle:{
					    fontSize:12, //刻度大小
							},
			        },            
					data: signXAxis
	            },
	            yAxis: {
	            	 type: 'value',
			         axisLabel: {
			            formatter: '{value} '+danwei
			         }
	            },
	            series: [{
	                itemStyle:{
						normal: {
						   color:bg
						}
					},
					name:titleY,
	                type: type,
	                data: signYAxis
	            }]
			  };        
       myChart.setOption(option);
}

//环状图
function quanquan(id,title,dataY,zongbi){
	myChart2 = echarts.init(document.getElementById(id));
	
	var option = {
				title: {
		        text: "",
		        subtext: zongbi,
		        x: 'center',
		        y: 'center',
		        subtextStyle:{
		        	fontSize:18,
		        	color:"skyblue"
		        }
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} kW·h ({d}%)"
		    },
		    legend: {
		       
		    },
		    color:["#4fcdfd","#fdd237"],
		    toolbox: {
		        show : true,
		        feature : {
		            mark : {show: true},
		            dataView : {show: true, readOnly: false},
		            magicType : {
		                show: true, 
		                type: ['pie', 'funnel'],
		                option: {
		                    funnel: {
		                        x: '25%',
		                        width: '50%',
		                        funnelAlign: 'center',
		                        max: 1548
		                    }
		                }
		            },
		            restore : {show: true},
		            saveAsImage : {show: true,title :'保存为图片'}
		        }
		    },
		    calculable : true,
		    series : [
		        {
		            name:'访问来源',
		            type:'pie',
		            radius : ['40%', '70%'],//圈圈的边框粗细
		            itemStyle : {
		                normal : {
		                    label : {
		                        show : false
		                    },
		                    labelLine : {
		                        show : false
		                    }
		                },
		                emphasis : {
		                }
		            },
		            data:dataY
		        }
		    ]
	};
        myChart2.setOption(option);
}

//折线图
function echarts3(id,title,dataTitle,dataX,title0,number0,title1,number1,title2,number2,danwei){
			myChart3 = echarts.init(document.getElementById(id));

        var option = {
            title: {
                text: ""
            },
             
            grid:{
	            containLabel: true ,
	            x:50,                        
					　　x2:30,
					　　y2:20
	       		},
            tooltip: {
			        trigger: 'axis',
			        formatter: function (params) {
			            return params[0].seriesName + '-' + params[0].name + ' : ' + params[0].value + ' kW·h' + '<br/>' +
			            + params[1].seriesName + '-' + params[1].name + ' : ' + params[1].value + ' kW·h' + '<br/>' +
			            + params[2].seriesName + '-' + params[2].name + ' : ' + params[2].value + ' kW·h';
			        }
			    	},
            toolbox: {   
				        show: true,
				        feature: {
				            magicType: {type: ['line', 'bar']},
				            saveAsImage : {show: true,title :'保存为图片'}
				        }
				    },
            legend: {
                data:dataTitle
            },
            xAxis: {
                data:dataX
            },
            yAxis: {
            	type: 'value',
			        axisLabel: {
			            formatter: '{value} '+ danwei
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

function ech4(id,title,titleY,signXAxis,signYAxis,type,danwei,bg){
	 myChart4 = echarts.init(document.getElementById(id));
        var option = {          
        		title: {
			        text: title
			    },
			    grid:{
			    	   left: '90',
					　　x:50,                        
					　　x2:10,
					　　y2:30
				},
				tooltip: {
			        trigger: 'axis',
			        formatter: function (params) {
			            var tar = params[0];
			            return tar.seriesName + "</br>" + tar.name + ' : ' + tar.value + ' kW·h';
			        }
			   },
			    legend: {
		        	data:titleY
		    	},
	            toolbox: {
	            	show: true,
	            	feature: {
		            	 magicType: {type: ['line', 'bar']},
				            restore: {},
				            saveAsImage : {show: true,title :'保存为图片'}
	           		}
	            },
	            xAxis: {
					type : 'category',				 
	                 splitLine:{ 
	                     show:false, //去掉X轴辅助线
	                 },
			 		axisLabel:{
					    textStyle:{
					    	fontSize:12, //刻度大小
						},
			        },            
					data: signXAxis
	            },
	            yAxis: {
	            	 type: 'value',
					        axisLabel: {
					            formatter: '{value} '+danwei
					        }
	            },
	            series: [{
	                itemStyle:{
						normal: {
						   color:bg
						}
					},
					name:titleY,
	                type: type,
	                data: signYAxis
	            }]
			  };        
       myChart4.setOption(option);
}

function ech5(id,title,titleY,signXAxis,signYAxis,type,danwei,bg){
	 myChart5 = echarts.init(document.getElementById(id));
        var option = {          
	        		title: {
					        text: title
					    },
					    grid:{
					    	   left:'90',
							　　x:50,                        
							　　x2:10,
							　　y2:30
						},
						tooltip: {
					        trigger: 'axis',
					        formatter: function (params) {
					            var tar = params[0];
					            return tar.seriesName + "</br>" + tar.name + ' : ' + tar.value + ' kW·h';
					        }
					    },
					    legend: {
				        	data:titleY
				    	},
	            toolbox: {
	            	show: true,
	            	feature: {
		            	 magicType: {type: ['line', 'bar']},
			            restore: {},
			            saveAsImage : {show: true,title :'保存为图片'}
	           		}
	            },
	            xAxis: {
						type : 'category',				 
		                 splitLine:{ 
		                     show:false, //去掉X轴辅助线
		                 },
				 		axisLabel:{
						    textStyle:{
						    	fontSize:12, //刻度大小
							},
			            },            
						data: signXAxis
	            },
	            yAxis: {
	            	 type: 'value',
			        axisLabel: {
			            formatter: '{value} '+danwei
			        }
	            },
	            series: [{
	                itemStyle:{
						normal: {
						   color:bg
						}
					},
					name:titleY,
	                type: type,
	                data: signYAxis
	            }]
			  };        
       myChart5.setOption(option);
}