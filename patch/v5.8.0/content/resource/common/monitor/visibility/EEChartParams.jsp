<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ include file="/common/replaceButton.jsp"%>
<tiles:importAttribute name="multiResource" ignore="true"/>

<c:if test="${empty multiResource}">
	<c:set var="multiResource" value="false"/>
</c:if>

<hq:constant classname="org.hyperic.hq.ui.Constants" symbol="CONTROL_ENABLED_ATTR" var="CONST_CONTROLLABLE" />

<c:set var="canControl" value="${requestScope[CONST_CONTROLLABLE]}"/>

<html:hidden property="rid" value="${Resource.id}"/>
<html:hidden property="type" value="${Resource.entityId.type}"/>
<html:hidden property="ctype"/>
<html:hidden property="mode" value="${param.mode}"/>

<c:forEach var="mid" items="${ViewChartForm.origM}">
	<html:hidden property="origM" value="${mid}"/>
</c:forEach>

<table width="100%" cellpadding="3" cellspacing="0" border="0">
	<tr>
    	<td width="30" rowspan="4">
    		<html:img page="/images/spacer.gif" width="30" height="1" border="0"/>
    	</td>
    	<td width="125">
      		<html:hidden property="showValues"/>
      		<input type="checkbox" name="showValuesCB" <c:if test="${ViewChartForm.showValues}">checked</c:if> onclick="javascript:checkboxToggled('showValuesCB', 'showValues');">
      		<html:img page="/images/icon_actual.gif" width="11" height="11" border="0"/>
      		<fmt:message key="resource.common.monitor.visibility.chart.Actual"/>
    	</td>
    	<td width="125">
      		<html:hidden property="showPeak"/>
      		<input type="checkbox" name="showPeakCB" <c:if test="${ViewChartForm.showPeak}">checked</c:if> onclick="javascript:checkboxToggled('showPeakCB', 'showPeak');">
      		<html:img page="/images/icon_peak.gif" width="11" height="11" border="0"/> 
      		<fmt:message key="resource.common.monitor.visibility.chart.Peak"/>
    	</td>
    	<td width="125">
      		<html:hidden property="showHighRange"/>
      		<input type="checkbox" name="showHighRangeCB" <c:if test="${ViewChartForm.showHighRange}">checked</c:if> <c:if test="${empty ViewChartForm.highRange}">disabled</c:if> onclick="javascript:checkboxToggled('showHighRangeCB', 'showHighRange');">
      		<html:img page="/images/icon_highrange.gif" width="11" height="11" border="0"/> 
      		<fmt:message key="resource.common.monitor.visibility.chart.HighRange"/>
    	</td>
    	<td rowspan="4">
      		<html:img page="/images/spacer.gif" width="30" height="1" border="0"/>
    	</td>
    	<td rowspan="4" valign="top">
			<table border="0">
				<tr>
					<td class="LinkBox">
    					<c:if test="${not multiResource}">
      						<c:url var="alertLink" value="/alerts/Config.do">
        						<c:param name="mode" value="new"/>
        						<c:param name="rid" value="${Resource.id}"/>
        						<c:param name="type" value="${Resource.entityId.type}"/>
        						<c:if test="${not empty metric}">
          							<c:param name="metricId" value="${metric.id}"/>
          							<c:param name="metricName" value="${metric.template.name}"/>
        						</c:if>
      						</c:url>
      						<c:if test="${not empty metric}">
	      						<html:link href="${alertLink}">
	      							<fmt:message key="resource.common.monitor.visibility.NewAlertLink"/><html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
	      						</html:link>
	      						<br>
      						</c:if>
    					</c:if>
      					<html:hidden property="saveChart" value="false"/>
      					
      					<c:choose>
      						<c:when test="${not hasMultipleDashboard}">
		      					<html:link styleId="AddToCharts_Link" href="#" onclick="return MyMetricChart.saveToDashboard();">
		      						<fmt:message key="resource.common.monitor.visibility.SaveChartToDash"/>
		      						<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
		      					</html:link>      						
      						</c:when>
      						<c:otherwise>
		      					<html:link styleId="AddToCharts_Link" href="#" onclick="return MyMetricChart.saveToDashboard();">
		      						<fmt:message key="resource.common.monitor.visibility.SaveChartToMultipleDashboards"/>
		      						<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
		      					</html:link>
								<div id="AddToCharts_Dialog" style="display:none;">
									<div id="AddToCharts_Div" style="width:400px;">
										<div id="AddToCharts_DataDiv">
											<div style="height:240px; overflow-x:hidden; overflow-y:auto;">
												<table width="100%" cellpadding="0" cellspacing="0" border="0">
													<thead>
														<tr class="tableRowHeader">
															<th class="ListHeaderCheckbox" style="width:20px"><input type="checkbox" id="AddToCharts_CheckAllBox" /></td>
															<th class="ListHeader" style="width:99%"><fmt:message key="common.header.Name"/></td>
														</tr>
													</thead>
													<tbody id="AddToCharts_TableBody">
														<c:forEach items="${editableDashboards}" var="dash" varStatus="iteration">
															<tr style="background-color:<c:choose><c:when test="${(iteration.count % 2) == 0}">#EDEDED</c:when><c:otherwise>#FFF</c:otherwise></c:choose>;" >
																<td style="padding: 3px; padding-left: 4px;">
																	<input type="checkbox" id="AddToCharts_CheckBox<c:out value='${iteration.count}' />" name="dashboardId" value="<c:out value='${dash.id}' />" />
																</td>
																<td style="padding: 3px;">
																	<span><c:out value="${dash.name}" /></span>
																</td>
															</tr>
														</c:forEach>
													</tbody>
												</table>
											</div>
										</div>
										<div id="AddToCharts_ButtonDiv" style="padding-top:5px">
											<span style="whitespace:nowrap">
												<input type="button" id="AddToCharts_AddButton" 
												       value="<fmt:message key='common.label.Add' />" class="CompactButton" />
												&nbsp;
						  						<input type="button" id="AddToCharts_CancelButton" 
						  						       value="<fmt:message key='common.label.Cancel' />" class="CompactButton" />
						  					</span>
						  					<span id="AddToCharts_Progress" style="display:none">
						  						<img src="<html:rewrite page="/images/4.0/icons/ajax-loader-gray.gif" />" align="absMiddle" />
						  					</span>
						  					<span id="AddToCharts_SuccessMsg" style="display:none;" class="successDialogMsg">
						  						<fmt:message key="resource.common.DashboardUpdatedMessage" />
						  					</span>
						  					<span id="AddToCharts_ErrorMsg" style="display:none;" class="failureDialogMsg">
						  						<fmt:message key="resource.common.DashboardUpdatedError" />
						  					</span>
										</div>
									</div>
								</div>
								<jsu:importScript path="/js/addtodashboard.js" />
								<jsu:script onLoad="true">
									var config = {
							    		title : "<fmt:message key='resource.common.monitor.visibility.SaveChartToMultipleDashboards' />",
							    		dialogId : "AddToCharts_Dialog",
							    		callerId : "AddToCharts_Link",
							    		url : "<html:rewrite action='/resource/common/QuickCharts' />",
							    		addButtonId : "AddToCharts_AddButton",
							    		cancelButtonId : "AddToCharts_CancelButton",
							    		progressId : "AddToCharts_Progress",
							    		successMsgId : "AddToCharts_SuccessMsg",
							    		failureMsgId : "AddToCharts_ErrorMsg",
							    		checkboxAllId : "AddToCharts_CheckAllBox",
							    		checkboxIdPrefix : "AddToCharts_CheckBox",
							    		passthroughParams : function() {
											return MyMetricChart.generateChartParameters();
							    		}
							    	};
		
							    	AddToDashboard.initDialog(config);
							    </jsu:script>
							</c:otherwise>
						</c:choose>
		      			<br />
    					<c:if test="${not empty back}">
        					<html:link page="${back}">
        						<fmt:message key="resource.common.monitor.visibility.Back2Resource"/>
        						<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
        					</html:link>
        					<br>
    					</c:if>

    					<c:if test="${not empty metric}">
      						<a href="#" onclick="javascript:MyMetricChart.exportData(exportParam);">
      							<fmt:message key="resource.common.monitor.visibility.ExportLink"/>
      							<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
      						</a>
      						<br>
    					</c:if>

					</td>
				</tr>
			</table>
    	</td>
  	</tr>
  	<tr>
    	<td>
      		<c:if test="${canControl}">
      			<html:hidden property="showEvents"/>
      			<input type="checkbox" name="showEventsCB" <c:if test="${ViewChartForm.showEvents}">checked</c:if> 
      			       onclick="javascript:checkboxToggled('showEventsCB', 'showEvents');" />
      			<html:img page="/images/icon_controlactions.gif" width="11" height="11" border="0"/> 
      			<fmt:message key="resource.common.monitor.visibility.chart.ControlActions"/>
      		</c:if>
    	</td>
    	<td>
      		<html:hidden property="showAverage"/>
      		<input type="checkbox" name="showAverageCB" <c:if test="${ViewChartForm.showAverage}">checked</c:if> onclick="javascript:checkboxToggled('showAverageCB', 'showAverage');" />
      		<html:img page="/images/icon_average.gif" width="11" height="11" border="0"/> 
      		<fmt:message key="resource.common.monitor.visibility.chart.Average"/>
    	</td>
    	<td>
      		<html:hidden property="showBaseline"/>
      		<input type="checkbox" name="showBaselineCB" <c:if test="${ViewChartForm.showBaseline}">checked</c:if> <c:if test="${empty ViewChartForm.baseline}">disabled</c:if> onclick="javascript:checkboxToggled('showBaselineCB', 'showBaseline');" />
      		<html:img page="/images/icon_baseline.gif" width="11" height="11" border="0"/> 
      		<fmt:message key="resource.common.monitor.visibility.chart.Baseline"/>
    	</td>
  	</tr>
  	<tr>
    	<td>&nbsp;</td>
    	<td>
      		<html:hidden property="showLow"/>
      		<input type="checkbox" name="showLowCB" <c:if test="${ViewChartForm.showLow}">checked</c:if> onclick="javascript:checkboxToggled('showLowCB', 'showLow');" />
      		<html:img page="/images/icon_low.gif" width="11" height="11" border="0"/> 
      		<fmt:message key="resource.common.monitor.visibility.chart.Low"/>
    	</td>
    	<td>
      		<html:hidden property="showLowRange"/>
      		<input type="checkbox" name="showLowRangeCB" <c:if test="${ViewChartForm.showLowRange}">checked</c:if> <c:if test="${empty ViewChartForm.lowRange}">disabled</c:if> onclick="javascript:checkboxToggled('showLowRangeCB', 'showLowRange');" />
      		<html:img page="/images/icon_lowrange.gif" width="11" height="11" border="0"/> 
      		<fmt:message key="resource.common.monitor.visibility.chart.LowRange"/>
    	</td>
  	</tr>
  	<tr>
    	<td colspan="3">
      		<html:image page="/images/fb_redraw.gif" property="redraw" border="0" altKey="button.redraw"
      					onmouseover="imageSwap(this, imagePath + 'fb_redraw', '_over');"
      					onmouseout="imageSwap(this, imagePath +  'fb_redraw', '');"
      					onmousedown="imageSwap(this, imagePath +  'fb_redraw', '_down')" 
      					tabindex="1" accesskey="r" style="display: none;" styleId="redraw_new_id"/>
      					<input id="redraw_id" class="button42" type="button" value='<fmt:message key="button.redraw"/>' onclick="clickRedrawButton();"></input>
    	</td>
  	</tr>
</table>
<jsu:script>
    document.forms["ViewChartForm"].elements["showValuesCB"].focus();
	function clickRedrawButton(){
		var checked=false;
		var checkedCounts = 0;
		if(hqDojo.byId('listDiv')){
			var inputs = hqDojo.query("input[type=checkbox]",hqDojo.byId('listDiv'));
			if(inputs.length>0){
				for(var i=0;i<inputs.length;i++){
					if(inputs[i].checked){
						checked = true;
						checkedCounts++;
						if(checkedCounts>18){
							break;
						}
					}
				}	
			}else{
				checked = true;
			}					
		}
		if(checked){
			if(checkedCounts<=18){
				document.getElementById('redraw_new_id').click();
			}else{
				alert('<fmt:message key="resource.metric.redraw.moreSelection"/>');
			}			
		}else{
			alert('<fmt:message key="resource.metric.redraw.noSelection"/>');
		}		
	}
</jsu:script>