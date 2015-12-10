<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ include file="/common/replaceButton.jsp"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<link rel="stylesheet" href="<html:rewrite page="/css/HQ_40.css"/>" type="text/css"/>
<html>
	<head>
		<tiles:insert page="/common/Head.jsp"/>
		<title>Report Center</title>
	</head>
	<body style="background-color: #EEE;" class="tundra">
	<tiles:insert definition=".main.header"/>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
  		<tr>
  			<td colspan="100%">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="reportingTableContainer">
	  				<tr class="PageTitleBar"> 
	    				<td><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
					    <td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
					    <td width="34%"><div class="pageTitle"><fmt:message key="reporting.reporting.ReportCenterTitle"/></div></td>
					    <td width="33%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
					    <td width="32%"><html:img page="/images/spacer.gif" width="202" height="26" alt="" border="0"/></td>
	  				</tr>
	  				<tr>
	  					<td rowspan="99" class="PageTitle"><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
	    				<td valign="top" align="left" rowspan="99"></td>
	    				<td colspan="3"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
	  				</tr>
				</table>
			</td>
  		</tr>
    	<tr>
      		<td class="PageTitle"><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
      		<td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
			<td>
				<div id="wrapper">
					<div id="reportingContainer">
						<html:form method="post" action="/reporting/ReportCenter" styleId="ReprtingForm" onsubmit="javascript:return hyperic.hq.reporting.manager.preSubmit();">
							<html:hidden property="jsonData" styleId="jsonData"></html:hidden>
							<c:if test="${not empty ReportingForm.errorMessage}">
								<div class="messagePanel" id="messagePanel">
									<c:out value="${ReportingForm.errorMessage}"/>
								</div>
							</c:if>
							<fieldset>
	        <div class="fieldsetTitle"><label for="r_reports"><fmt:message key="reporting.reporting.Reports" /></label></div>
								<div class="fieldRow" style="height: 155px;">
									<label for="reports"><span class="fieldLabel required"><html:img width="9" height="9" border="0" src="/images/icon_required.gif" /><fmt:message key="reporting.reporting.SelectReports" /></span></label>
									<logic:messagesPresent property="reportSelected">
										<div class="fieldValue error">
											<html:select styleId="reports" size="10" property="reportSelected" onchange="javascript:selectedChanged(this);">
												<c:forEach items="${ReportingForm.listOfReports}" var="report">
													<option <c:if test="${report.name eq ReportingForm.reportSelected}"> selected="selected" </c:if> value="<c:out value="${report.name}"/>"><c:out value="${report.name}"/></option>
												</c:forEach>
											</html:select>
											<div>-&nbsp;<html:errors property="reportSelected"/></div>
										</div>
					<div class="selectDetails"><div class="selectDetailsTitle"><fmt:message key="reporting.reporting.ReportsDesc" />:</div><span id="reportDetails"><fmt:message key="reporting.reporting.ReportsMemo" /></span></div>
									</logic:messagesPresent>
									<logic:messagesNotPresent property="reportSelected">
										<div class="fieldValue">
											<html:select styleId="reports" size="10" property="reportSelected" onchange="javascript:selectedChanged(this);">
												<c:forEach items="${ReportingForm.listOfReports}" var="report">
													<option <c:if test="${report.name eq ReportingForm.reportSelected}"> selected="selected" </c:if> value="<c:out value="${report.name}"/>"><c:out value="${report.name}"/></option>
												</c:forEach>
											</html:select>
										</div>
										<div class="selectDetails"><div class="selectDetailsTitle">Report Description:</div><span id="reportDetails">Select a report to view its description.</span></div>
									</logic:messagesNotPresent>
								</div>
							</fieldset>
							<fieldset>
							<div class="fieldsetTitle"><label for="r_options"><fmt:message key="reporting.reporting.options" /></label></div>
								<div id="reportOptions"></div>
								<div class="fieldRow">
									<span class="fieldLabel required"><html:img width="9" height="9" border="0" src="/images/icon_required.gif" />Export the report as:</span>
									<logic:messagesPresent property="exportFormat">
										<c:set var="fieldValueClass" value="fieldValue error" />
									</logic:messagesPresent>
									<logic:messagesNotPresent>
										<c:set var="fieldValueClass" value="fieldValue"/>
									</logic:messagesNotPresent>
									<div class="${fieldValueClass}">
										<c:forEach items="${ReportingForm.availableExportFormats}" var="format">
					    					<html:radio property="exportFormat" styleId="${format.value}" value="${format.code}"></html:radio>
	                    					<label for="<c:out value="${format.value}"/>"> <span style="margin:0px 5px 0px 2px"><c:out value="${format.value}"/> </span></label>
										</c:forEach>
										<logic:messagesPresent property="exportFormat">
											<div>-&nbsp;<html:errors property="exportFormat"/></div>
										</logic:messagesPresent>
									</div>
								</div>
						</fieldset>
						<div class="buttonGroup">
							<html:image src="/images/fb_ok.gif" altKey="button.ok" property="ok" onmouseout="javscript:this.src='/images/fb_ok.gif'" onmouseover="javscript:this.src='/images/fb_ok_over.gif'" onmousedown="javascript:this.src='/images/fb_ok_down.gif'"></html:image>
							<html:image src="/images/fb_reset.gif" altKey="button.reset" styleClass="buttonSeparator" property="reset" onclick="javascript:resetForm(); return false;" onmouseout="javscript:this.src='/images/fb_reset.gif'" onmouseover="javscript:this.src='/images/fb_reset_over.gif'" onmousedown="javascript:this.src='/images/fb_reset_down.gif'"></html:image>
							<html:image src="/images/fb_cancel.gif" altKey="button.cancel" property="cancel" onclick="javscript:document.forms[0].onsubmit=null;" onmouseover="javscript:this.src='/images/fb_cancel_over.gif'" onmouseout="javscript:this.src='/images/fb_cancel.gif'" onmousedown="javascript:this.src='/images/fb_cancel_down.gif'"></html:image>
							<div class="buttonNote"><i><fmt:message key="reporting.button.generateAlerts" /></i></div>
						</div>
					</html:form>
					<c:forEach items="${ReportingForm.listOfReports}" var="report">
						<span id='<c:out value="${report.name}"/>' class="hidden"><c:out value="${report.description}"/></span>
					</c:forEach>
				</div>
			</div>
		<tiles:insert page="/common/Footer.jsp"/>
		<script type="text/javascript">
	    	var onloads = new Array();
	    	
	    	hqDojo.ready(function() {
	      		for ( var i = 0 ; i < onloads.length ; i++ )
	        		onloads[i]();
	    	});
	    	
	    	init_reporting();
		</script>			
	</body>
</html>