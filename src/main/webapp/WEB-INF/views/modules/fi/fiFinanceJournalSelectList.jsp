<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>资金流水选择器</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
	    	$('#contentTable thead tr th input.i-checks').on('ifChecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('check');
	    	});
	    	$('#contentTable thead tr th input.i-checks').on('ifUnchecked', function(event){ //ifCreated 事件应该在插件初始化之前绑定 
	    		$('#contentTable tbody tr td input.i-checks').iCheck('uncheck');
	    	});
		});		
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
        	return false;
        }		
		function getSelectedItem(){
			var size = $("#contentTable tbody tr td input.i-checks:checked").size();
			if(size == 0 ){
				top.layer.alert('请至少选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}

			if(size > 1 ){
				top.layer.alert('只能选择一条数据!', {icon: 0, title:'警告'});
				return "-1";
			}
			var id =  $("#contentTable tbody tr td input.i-checks:checkbox:checked").attr("id");
			var label = $("#contentTable tbody tr td input.i-checks:checkbox:checked").parent().parent().parent().find(".codelabel").html();
			return id+"_item_"+label;
		}
	</script>
</head>
<body class="gray-bg">
<div class="wrapper-content">
		<div class="ibox">
			
			<div class="ibox-content">
			<sys:message content="${message}"/>
				
				<!-- 查询条件 -->
				<div class="row">
					<div class="col-sm-12">
						<form:form id="searchForm" modelAttribute="fiFinanceJournal" action="${ctx}/fi/fiFinanceJournal/selectList" method="post" class="form-inline">
							<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
							<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
							<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
								<div class="form-group"><span>结算账户：</span>
									<form:input path="fiaccount.id" htmlEscape="false" maxlength="30" class="form-control input-medium"/>
								</div>
								<div class="form-group"><span>交易类别：</span>
									<form:select path="dealType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('deal_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>业务日期：</span>
									<input name="beginDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiFinanceJournal.beginDealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/> - 
									<input name="endDealDate" type="text" readonly="readonly" maxlength="20" class="laydate-icon form-control input-medium"
										value="<fmt:formatDate value="${fiFinanceJournal.endDealDate}" pattern="yyyy-MM-dd HH:mm:ss"/>"
										onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',isShowClear:false});"/>
								</div>
								<div class="form-group"><span>资金类别：</span>
									<form:select path="moneyType" class="form-control input-medium">
										<form:option value="" label=""/>
										<form:options items="${fns:getDictList('money_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
									</form:select>
								</div>
								<div class="form-group"><span>操作人：</span>
									<sys:treeselect id="createBy" name="createBy.id" value="${fiFinanceJournal.createBy.id}" labelName="createBy.name" labelValue="${fiFinanceJournal.createBy.name}"
										title="用户" url="/sys/office/treeData?type=3" cssClass="form-control input-medium" allowClear="true" notAllowSelectParent="true"/>
								</div>
						</form:form>
					</div>
				</div>
				<!-- 工具栏 -->
				<div class="row">
					<div class="col-sm-12 m-b-sm">
						<div class="pull-left">
					       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
						</div>
						<div class="pull-right">
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-success btn-rounded btn-outline btn-sm " onclick="resetSearch()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
					
				<!-- 表格 -->
				<div class="table-responsive">
				<table id="contentTable" class="table table-bordered table-striped table-hover">
					<thead>
						<tr>
							<th><input type="checkbox" class="i-checks"></th>
							<th class="sort-column f.name">结算账户</th>
							<th class="sort-column a.deal_type">交易类别</th>
							<th class="sort-column a.deal_date">业务日期</th>
							<th class="sort-column a.money_type">资金类别</th>
							<th class="sort-column a.money">交易金额</th>
							<th class="sort-column a.notes">摘要</th>
							<th class="sort-column a.balance">当前余额</th>
							<th class="sort-column a.create_by">操作人</th>
							<th class="sort-column a.create_date">操作日期</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
					<c:forEach items="${page.list}" var="fiFinanceJournal">
						<tr>
							<td><input type="checkbox" id="${fiFinanceJournal.id}" class="i-checks"></td>
							<td>${fiFinanceJournal.fiaccount.name}</td>
							<td class="codelabel">${fns:getDictLabel(fiFinanceJournal.dealType, 'deal_type', '')}</td>
							<td><fmt:formatDate value="${fiFinanceJournal.dealDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>${fns:getDictLabel(fiFinanceJournal.moneyType, 'money_type', '')}</td>
							<td>${fiFinanceJournal.money}</td>
							<td>${fiFinanceJournal.notes}</td>
							<td>${fiFinanceJournal.balance}</td>
							<td>${fiFinanceJournal.createBy.name}</td>
							<td><fmt:formatDate value="${fiFinanceJournal.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
							<td>
								<shiro:hasPermission name="fi:fiFinanceJournal:view">
									<a href="#" onclick="openDialogView('查看资金流水', '${ctx}/fi/fiFinanceJournal/view?id=${fiFinanceJournal.id}','800px', '500px')" class="btn btn-info btn-xs" title="查看"><i class="fa fa-search-plus"></i> 查看</a>
								</shiro:hasPermission>
							</td>
						</tr>
					</c:forEach>
					</tbody>
				</table>
				<table:page page="${page}"></table:page>
				</div>
			</div>
		</div>
	</div>
</body>
</html>