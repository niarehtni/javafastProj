<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>借款单编辑</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		$(document).ready(function() {
			//$("#name").focus();
			validateForm=$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
	<div class="ibox">
		<div class="ibox-title">
			<h5>新建借款单</h5>
		</div>
		<div class="ibox-content">
		<sys:message content="${message}"/>
		<form:form id="inputForm" modelAttribute="oaCommonBorrow" action="${ctx}/oa/oaCommonBorrow/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>	
		<form:hidden path="oaCommonAudit.oaCommonFlowId"/>		
		
		<h4 class="page-header">基本信息</h4>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 标题</label>
						<div class="col-sm-10">
							<form:input path="oaCommonAudit.title" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"><font color="red">*</font> 内容</label>
						<div class="col-sm-10">
							<form:textarea path="oaCommonAudit.content" htmlEscape="false" rows="4" class="form-control required"/>
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label class="col-sm-2 control-label"> 附件</label>
						<div class="col-sm-10">
							<form:hidden id="files" path="oaCommonAudit.files" htmlEscape="false" maxlength="1000" class="form-control"/>
							<sys:ckfinder input="files" type="files" uploadPath="/file" selectMultiple="true"/>
						</div>
					</div>
				</div>
			</div>
			<h4 class="page-header">借款信息</h4>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 借款总额</label>
						<div class="col-sm-8">
							<form:input path="amount" htmlEscape="false" maxlength="8" class="form-control required number" min="0.01"/>
						</div>
					</div>
				</div>
				<div class="col-sm-6">
					<div class="form-group">
						<label class="col-sm-4 control-label"><font color="red">*</font> 借款时间</label>
						<div class="col-sm-8">
							<div class="input-group date datepicker">
		                     	<input name="borrowDate" type="text" readonly="readonly" class="form-control required" value="<fmt:formatDate value="${oaCommonBorrow.borrowDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:true});" >
		                     	<span class="input-group-addon">
		                             <span class="fa fa-calendar"></span>
		                     	</span>
					        </div>
						</div>
					</div>
				</div>
			</div>
			
			<div class="hr-line-dashed"></div>
			<div class="form-group">
            	<div class="col-sm-4 col-sm-offset-2">
                	<input id="btnSubmit" class="btn btn-success" type="submit" value="提 交"/>
                    <input id="btnCancel" class="btn btn-white" type="button" value="返 回" onclick="history.go(-1)"/>
                </div>
            </div>
			</form:form>
		</div>
	</div>
</div>
</body>
</html>