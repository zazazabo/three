<!DOCTYPE html>
<html>
    <head>
        <title></title>
        <link href="./bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
        <link href="./css/bootstrap-datetimepicker.min.css" rel="stylesheet" media="screen">


        <script type="text/javascript" src="./jquery/jquery-1.8.3.min.js" charset="UTF-8"></script>
        <script type="text/javascript" src="./bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="./js/bootstrap-datetimepicker.js" charset="UTF-8"></script>
        <script type="text/javascript" src="./js/locales/bootstrap-datetimepicker.zh-CN.js" charset="UTF-8"></script>
        <script>
//            $(".form_datetime").datetimepicker("setStartDate", "2017-03-01");

            function aaa() {
                alert("dddd");
            }
            var time1 = $("$dtp_input3").val();

//                $('.form_time').datetimepicker('update','2018-10-11');
            $('.form_time').datetimepicker('update');
        </script>
    </head>

    <body>








        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">
                <span style="font-size:20px ">×</span></button>
            <span class="glyphicon glyphicon-floppy-disk" style="font-size: 20px"></span>
            <h4 class="modal-title" style="display: inline;">??????</h4>
        </div>
        <form action="" method="POST" id="eqpTypeForm" onsubmit="return checkLoopAdd()">      
            <div class="modal-body">
            </div>
            <div class="modal-footer">
                <button id="tianjia1" type="submit" class="btn btn-primary"></button>
                <button type="button" class="btn btn-default" data-dismiss="modal"></button></div>
        </form>






        <div class="container">










            <!--
                        <form action="" class="form-horizontal"  role="form">
                            <fieldset>
                                <legend>Test</legend>
                                <div class="form-group">
                                    <label for="dtp_input1" class="col-md-2 control-label">DateTime Picking</label>
                                    <div class="input-group date form_datetime col-md-5" data-date="1979-09-16T05:25:07Z" data-date-format="dd MM yyyy - HH:ii p" data-link-field="dtp_input1">
                                        <input class="form-control" size="16" type="text" value="" readonly>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-th"></span></span>
                                    </div>
                                    <input type="hidden" id="dtp_input1" value="" /><br/>
                                </div>
                                <div class="form-group">
                                    <label for="dtp_input2" class="col-md-2 control-label">Date Picking</label>
                                    <div class="input-group date form_date col-md-5" data-date="" data-date-format="dd MM yyyy" data-link-field="dtp_input2" data-link-format="yyyy-mm-dd">
                                        <input class="form-control" size="16" type="text" value="" readonly>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                                    </div>
                                    <input type="hidden" id="dtp_input2" value="" /><br/>
                                </div>
                                <div class="form-group">
                                    <label for="dtp_input3" class="col-md-2 control-label">Time Picking</label>
                                    <div class="input-group date form_time col-md-5" data-date="" data-date-format="hh:ii" data-link-field="dtp_input3" data-link-format="hh:ii">
                                        <input class="form-control" size="16" type="text" value="" readonly>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                                        <span class="input-group-addon"><span class="glyphicon glyphicon-time"></span></span>
                                    </div>
                                    <input type="hidden" id="dtp_input3" value="" /><br/>
                                </div>
                            </fieldset>
                        </form>
                        <input value="dddddddd"  type="button" onclick="aaa()"/>
                    </div>
            
                    <script type="text/javascript">
                            $('.form_datetime').datetimepicker({
                                language: 'zh-CN',
                                format: 'yyyy-mm-dd hh:ii:ss',
                                weekStart: 1,
                                todayBtn: 1,
                                autoclose: 1,
                                todayHighlight: 1,
                                startView: 2,
                                forceParse: 0,
                                showMeridian: 1
                            });
                            $('.form_date').datetimepicker({
                                language: 'zh-CN',
                                format: 'yyyy-mm-dd',
                                weekStart: 1,
                                todayBtn: 1,
                                autoclose: 1,
                                todayHighlight: 1,
                                startView: 2,
                                minView: 2,
                                forceParse: 0
                            });
                            $('.form_time').datetimepicker({
                                language: 'zh-CN',
                                weekStart: 1,
                                todayBtn: 1,
                                autoclose: 1,
                                todayHighlight: 1,
                                startView: 1,
                                minView: 0,
                                maxView: 1,
                                forceParse: 0
                      
                            }
                            );
                    </script>-->

    </body>
</html>
