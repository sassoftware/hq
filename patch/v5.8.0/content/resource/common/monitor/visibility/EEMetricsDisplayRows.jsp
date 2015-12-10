<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<jsu:importScript path="/js/effects.js" />
<tiles:importAttribute name="rows" />
<tiles:importAttribute name="useChart" />
<tiles:importAttribute name="buttonMode" ignore="true" />
<tiles:importAttribute name="useCheckboxes" ignore="true" />
<tiles:importAttribute name="childResourceType" ignore="true" />
<tiles:importAttribute name="ctype" ignore="true" />
<c:if test="${empty useCheckboxes}">
	<c:set var="useCheckboxes" value="true" />
</c:if>
<hq:constant classname="org.hyperic.hq.ui.Constants" symbol="MODE_MON_CHART_SMSR" var="MODE_MON_CHART_SMSR" />
<hq:constant classname="org.hyperic.hq.ui.Constants" symbol="MODE_MON_CHART_SMMR" var="MODE_MON_CHART_SMMR" />
<hq:constant classname="org.hyperic.hq.ui.Constants" symbol="MODE_MON_CHART_MMSR" var="MODE_MON_CHART_MMSR" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="MAX_KEY" var="max" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="MIN_KEY" var="min" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="AVERAGE_KEY" var="average" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="LAST_KEY" var="last" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="BASELINE_KEY" var="baseline" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="HIGH_RANGE_KEY" var="high" />
<hq:constant classname="org.hyperic.hq.bizapp.shared.uibeans.MetricDisplayConstants" symbol="LOW_RANGE_KEY" var="low" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="COLL_TYPE_DYNAMIC" var="dynamic" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="COLL_TYPE_STATIC" var="static" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="COLL_TYPE_TRENDSUP" var="trendsup" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="COLL_TYPE_TRENDSDOWN" var="trendsdown" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="CAT_AVAILABILITY" var="availability" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="CAT_PERFORMANCE" var="performance" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="CAT_THROUGHPUT" var="throughput" />
<hq:constant classname="org.hyperic.hq.measurement.MeasurementConstants" symbol="CAT_UTILIZATION" var="utilization" />
<c:set var="eid" value="${Resource.entityId.type}:${Resource.id}" />
<c:choose>
	<c:when test="${NumChildResources <= 18}">
		<c:set var="metadataPopupHeight" value="${300 + 26 * NumChildResources}" />
	</c:when>
	<c:otherwise>
		<c:set var="metadataPopupHeight" value="758" />
	</c:otherwise>
</c:choose>

<c:forEach var="metricDisplaySummary" items="${rows}">
	<c:url var="metadataLink" value="/resource/common/monitor/Visibility.do">
		<c:param name="mode" value="metricMetadata" />
		<c:param name="m" value="${metricDisplaySummary.templateId}" />
		<c:param name="eid" value="${eid}" />
		<c:choose>
			<c:when test="${not empty childResourceType}">
				<c:param name="ctype" value="${ctype}" />
			</c:when>
		</c:choose>
	</c:url>
	<c:url var="chartLink" value="/resource/common/monitor/Visibility.do">
		<c:param name="type" value="${Resource.entityId.type}" />
		<c:param name="rid" value="${Resource.id}" />
		<c:param name="m" value="${metricDisplaySummary.templateId}" />

		<c:choose>
			<c:when test="${not empty childResourceType}">
				<c:param name="mode" value="${MODE_MON_CHART_SMMR}" />
				<c:param name="ctype" value="${ctype}" />
			</c:when>
			<c:when test="${Resource.entityId.group}">
				<c:param name="mode" value="${MODE_MON_CHART_SMMR}" />
			</c:when>
			<c:otherwise>
				<c:param name="mode" value="${MODE_MON_CHART_SMSR}" />
			</c:otherwise>
		</c:choose>
	</c:url>
	<tr class="ListRow">
		<c:if test="${useCheckboxes}">
			<td class="ListCellCheckbox">
				<html:multibox property="m"
							   onclick="ToggleSelectionTwoButtons(this, mdsWidgetProps, '${buttonMode}');"
							   value="${metricDisplaySummary.templateId}"
							   styleClass="availableListMember" />
			</td>
		</c:if>
		<c:if test="${useChart}">
			<td class="ListCellCheckbox">
				<c:choose>
					<c:when test="${not empty metricDisplaySummary.metrics}">
						<a href="<c:out value="${chartLink}" />">
							<html:img page="/images/icon_chart.gif" 
							          width="10" height="10" altKey="resource.common.monitor.visibility.metricdata.metric.type.showchart" titleKey="resource.common.monitor.visibility.metricdata.metric.type.showchart"
									  border="0" />
						</a>
					</c:when>
					<c:otherwise>&nbsp;</c:otherwise>
				</c:choose>
			</td>
		</c:if>
		<c:choose>
			<c:when test="${useChart}">
				<td class="ListCellPrimary" nowrap>
					<c:choose>
						<c:when test="${not empty metricDisplaySummary.metrics}">
							<a href="<c:out value="${chartLink}" />">
								<c:out value="${metricDisplaySummary.label}" />
							</a>
						</c:when>
						<c:otherwise>
							<c:out value="${metricDisplaySummary.label}" />
						</c:otherwise>
					</c:choose>
				</td>
			</c:when>
			<c:otherwise>
				<td class="ListCellPrimary" nowrap>
					<c:out value="${metricDisplaySummary.label}" />
				</td>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<%-- used for favorites --%>
			<c:when test="${MetricsDisplayForm.showMetricSource}">
				<td class="ListCellLeftLineNoPadding" align="center">
					<c:out value="${metricDisplaySummary.metricSource}" default="&nbsp;" escapeXml="false" />
				</td>
			</c:when>
			<c:otherwise>
				<!-- metric source not shown -->
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${MetricsDisplayForm.showNumberCollecting}">
				<td class="ListCellLeftLineNoPadding" align="center">
					<c:choose>
						<c:when test="${not empty metricDisplaySummary.availUp}">
							<c:out value="${metricDisplaySummary.availUp}" />
						</c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</td>
			</c:when>
			<c:otherwise>
				<!-- number collecting not shown -->
			</c:otherwise>
		</c:choose>
		<td class="ListCellRight" style="text-align: center;">
			<c:choose>
				<c:when test="${not empty metricDisplaySummary.metrics}">
					<span id="<c:out value="alertCount${metricDisplaySummary.templateId}"/>">
						<c:out value="${metricDisplaySummary.alertCount}" />
					</span>
				</c:when>
				<c:otherwise>
					<fmt:message key="common.label.Dash" />
				</c:otherwise>
			</c:choose>
		</td>
		<td class="ListCellRight" style="text-align: center;">
			<c:choose>
				<c:when test="${not empty metricDisplaySummary.metrics}">
					<span id="<c:out value="oobCount${metricDisplaySummary.templateId}"/>">
						<c:out value="${metricDisplaySummary.oobCount}" />
					</span>
				</c:when>
				<c:otherwise>
					<fmt:message key="common.label.Dash" />
				</c:otherwise>
			</c:choose>
		</td>
		<c:choose>
			<c:when test="${MetricsDisplayForm.showBaseline}">
				<td class="ListCellRight" nowrap>
					<span class="MonitorMetricsValue"> 
						<c:choose>
							<c:when test="${MetricsDisplayForm.displayBaseline}">
								<span id="<c:out value="baseline${metricDisplaySummary.templateId}"/>">
									<c:out value="${metricDisplaySummary.metrics[baseline].valueFmt}" />
								</span>
							</c:when>
							<c:when test="${MetricsDisplayForm.displayHighRange}">
								<span id="<c:out value="high${metricDisplaySummary.templateId}"/>">
									<c:out value="${metricDisplaySummary.metrics[high].valueFmt}" />
								</span>
							</c:when>
							<c:when test="${MetricsDisplayForm.displayLowRange}">
								<span id="<c:out value="low${metricDisplaySummary.templateId}"/>">
									<c:out value="${metricDisplaySummary.metrics[low].valueFmt}" />
								</span>
							</c:when>
						</c:choose> 
					</span>
				</td>
			</c:when>
			<c:otherwise>
				<!-- baseline not shown -->
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${metricDisplaySummary.label == 'Availability'}">
				<td class="ListCellRight" nowrap><fmt:message key="common.label.Dash" /></td>
				<td class="ListCellRight" nowrap>
					<c:choose>
						<c:when test="${empty metricDisplaySummary.metrics}">
							<fmt:message key="common.label.Dash" />
						</c:when>
						<c:otherwise>
							<span id="<c:out value="average${metricDisplaySummary.templateId}"/>">
								<c:out value="${metricDisplaySummary.metrics[average].valueFmt}" />&nbsp;
							</span>
						</c:otherwise>
					</c:choose>
				</td>
				<td class="ListCellRight" nowrap><fmt:message key="common.label.Dash" /></td>
				<td class="ListCellCheckboxLeftLine" nowrap>
					<span id="<c:out value="avail${metricDisplaySummary.templateId}"/>">
						<c:choose>
							<c:when test="${metricDisplaySummary.metrics[last].value == 1}">
								<html:img page="/images/icon_available_green.gif" 
								          width="12" height="12" alt="" 
								          border="0" align="absmiddle" />
							</c:when>
							<c:when test="${metricDisplaySummary.metrics[last].value == 0}">
								<html:img page="/images/icon_available_red.gif" 
										  width="12" height="12" alt="" 
										  border="0" align="absmiddle" />
							</c:when>
							<c:when test="${metricDisplaySummary.metrics[last].value == -0.01}">
								<html:img page="/images/icon_available_orange.gif" 
								          width="12" height="12" alt="" 
								          border="0" align="absmiddle" />
							</c:when>
							<c:when test="${metricDisplaySummary.metrics[last].value == -0.02}">
								<html:img page="/images/icon_available_black.gif" 
								          width="12" height="12" alt="" 
								          border="0" align="absmiddle" />
							</c:when>
							<c:otherwise>
								<html:img page="/images/icon_available_yellow.gif" 
								          width="12" height="12" alt="" 
								          border="0" align="absmiddle" />
							</c:otherwise>
						</c:choose> 
					</span>
				</td>
			</c:when>
			<c:when test="${not empty metricDisplaySummary.metrics && metricDisplaySummary.collectionType == dynamic}">
				<td class="ListCellRight" nowrap>
					<span id="<c:out value="min${metricDisplaySummary.templateId}"/>">
						<c:out value="${metricDisplaySummary.metrics[min].valueFmt}" />
					</span>
				</td>
				<td class="ListCellRight" nowrap>
					<span id="<c:out value="average${metricDisplaySummary.templateId}"/>">
						<c:out value="${metricDisplaySummary.metrics[average].valueFmt}" />
					</span>
				</td>
				<td class="ListCellRight" nowrap>
					<span id="<c:out value="max${metricDisplaySummary.templateId}"/>">
						<c:out value="${metricDisplaySummary.metrics[max].valueFmt}" />
					</span>
				</td>
				<td class="ListCellRight" nowrap>
					<span id="<c:out value="last${metricDisplaySummary.templateId}"/>">
						<c:out value="${metricDisplaySummary.metrics[last].valueFmt}" />
					</span>
				</td>
			</c:when>
			<c:otherwise>
				<td class="ListCellRight" nowrap>
					<fmt:message key="common.label.Dash" />
				</td>
				<td class="ListCellRight" nowrap>
					<fmt:message key="common.label.Dash" />
				</td>
				<td class="ListCellRight" nowrap>
					<fmt:message key="common.label.Dash" />
				</td>
				<td class="ListCellRight" nowrap>
					<c:choose>
						<c:when test="${not empty metricDisplaySummary.metrics}">
							<span id="<c:out value="last${metricDisplaySummary.templateId}"/>">
								&nbsp;
							</span>
						</c:when>
						<c:otherwise>
							<fmt:message key="common.label.Dash" />
						</c:otherwise>
					</c:choose>
				</td>
				<!-- baseline not shown -->
			</c:otherwise>
		</c:choose>
		<td class="ListCellRight" style="text-align: center;">
			<c:choose>
				<c:when test="${metricDisplaySummary.interval > 0}">
					<hq:dateFormatter value="${metricDisplaySummary.interval}" time="true" />
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${metricDisplaySummary.collecting}">
							<fmt:message key="resource.common.monitor.visibility.config.DIFFERENT" />
						</c:when>
						<c:otherwise>
							<fmt:message key="resource.common.monitor.visibility.config.NONE" />
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		</td>
		<td class="ListCellCheckbox">
			<c:choose>
				<c:when test="${not empty metricDisplaySummary.metrics}">
					<a href="" onclick="window.open('<c:out value="${metadataLink}" />','_metricMetadata','width=800,height=<c:out value="${metadataPopupHeight}" />,scrollbars=yes,toolbar=no,left=80,top=80,resizable=yes'); return false;">
						<html:img page="/images/icon_info.gif" 
								  width="11" height="11" altKey="resource.common.monitor.visibility.metricdata.metric.type.metricdetailsandmetadata" titleKey="resource.common.monitor.visibility.metricdata.metric.type.metricdetailsandmetadata" 
								  border="0" />
					</a>
				</c:when>
				<c:otherwise>&nbsp;</c:otherwise>
			</c:choose>
		</td>
	</tr>
</c:forEach>