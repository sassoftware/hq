<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/sas.tld" prefix="sas" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<tiles:importAttribute name="problems" ignore="true"/>
<tiles:importAttribute name="ctype" ignore="true"/>
<tiles:importAttribute name="hideTools" ignore="true"/>

<!-- Toobar -->
<c:if test="${not hideTools}">
	<table width="100%" cellpadding="0" cellspacing="0" border="0" class="ToolbarContent">
  		<tr>
    		<td></td>
    		<td style="padding-top:3px;padding-bottom:5px;font-size:10px;">
    			<fmt:message key="inform.resource.common.monitor.visibility.SelectResources"/>
    		</td>
    		<td nowrap style="font-size:10px" width="90">
    			<tiles:insert page="/common/components/ActionButton.jsp">
          			<tiles:put name="labelKey" value="common.label.ViewMetrics"/>
          			<tiles:put name="buttonClick" value="document.ProblemMetricsDisplayForm.submit(); return false;"/>
        		</tiles:insert>
        		
        		<html:hidden property="fresh" value="false"/>
			</td>
    		<td style="padding-left:5px;padding-right:3px"> 
    			<html:img page="/images/icon_info2.gif" onmouseover="menuLayers.show('stepInfo', event)" onmouseout="menuLayers.hide()" border="0"/>
    		</td>
  		</tr>
	</table>
</c:if>

<div id="stepInfo" class="menu">
	<ul>
    	<li>
    		<div class="BoldText">
    			<fmt:message key="inform.resource.common.monitor.visibility.infoStep1"/>
    		</div>
    	</li>
    	<li>
    		<div class="BoldText">
    			<fmt:message key="inform.resource.common.monitor.visibility.infoStep2"/>
    		</div>
    	</li>
    	<li>
    		<div class="BoldText">
    			<fmt:message key="inform.resource.common.monitor.visibility.infoStep3"/>
    		</div>
    	</li>
  	</ul>
</div>

<c:choose>
	<c:when test="${not empty problems}">   
    	<c:set var="eid" value="${Resource.entityId.appdefKey}" />

    	<c:forEach var="metric" items="${problems}" varStatus="status">
      		<c:set var="resourceType" value="${metric.type}"/>
      		<c:set var="appdefKey" value="${metric.appdefKey}" />
      		
      		<c:url var="metadataLink" value="/resource/common/monitor/Visibility.do">
        		<c:param name="mode" value="metricMetadata"/>
        		<c:param name="m" value="${metric.templateId}"/>
        		<c:param name="eid" value="${eid}"/>
        		
        		<c:choose>
          			<c:when test="${not empty ctype}">
            			<c:param name="ctype" value="${ctype}"/>
          			</c:when>
          			<c:otherwise>
            			<c:if test="${eid != metric.appdefKey}">
              				<c:param name="ctype" value="${metric.appdefKey}"/>
            			</c:if>
          			</c:otherwise>
        		</c:choose>
      		</c:url>
			
			<c:choose>
        		<c:when test="${metric.entityCount <= 18}">
          			<c:set var="metadataPopupHeight" value="${300 + 26 * count}"/>
        		</c:when>
        		<c:otherwise>
          			<c:set var="metadataPopupHeight" value="326"/>
        		</c:otherwise>
      		</c:choose>

    		<!-- Here are the menu layers. Give each a unique id and a class of menu -->
      		<div id="metric_menu_<c:out value="${metric.templateId}"/>" class="menu">
        		<ul>
          			<li>
            			<div class="BoldText">
            				<c:choose>
              					<c:when test="${metric.single}">
                					<fmt:message key="resource.common.monitor.visibility.problemMetric.Type">
                  						<fmt:param value="${metric.type}"/>
                					</fmt:message>
              					</c:when>
              					<c:otherwise>
                					<fmt:message key="resource.common.monitor.visibility.problemMetric.TypeCount">
                  						<fmt:param value="${metric.type}"/>
                  						<fmt:param value="${metric.entityCount}"/>
                					</fmt:message>
              					</c:otherwise>
            				</c:choose>
          				</div>
        			</li>
        			<c:if test="${metric.earliest > 0}">
  	      				<li>
  	      					<div class="BoldText">
  	      						<fmt:message key="resource.common.monitor.visibility.problemMetric.Began"/>
  	      					</div>
          				
          					<sas:evmTimelineTag value="${metric.earliest}"/>
          				</li>
        			</c:if>
        			<li><hr /></li>
        				
        			<c:url var="chartLink" value="/resource/common/monitor/Visibility.do">
          				<c:param name="m" value="${metric.templateId}"/>
          				<c:choose>
            				<c:when test="${Resource.entityId.group}">
              					<c:param name="mode" value="chartSingleMetricMultiResource"/>
              					<c:param name="eid" value="${Resource.entityId}"/>
            				</c:when>
            				<c:when test="${metric.single}">
              					<c:param name="mode" value="chartSingleMetricSingleResource"/>
              					<c:param name="eid" value="${metric.appdefKey}"/>
            				</c:when>
            				<c:otherwise>
              					<c:param name="mode" value="chartSingleMetricMultiResource"/>
					            <c:param name="eid" value="${eid}"/>
					            <c:param name="ctype" value="${metric.appdefKey}"/>
            				</c:otherwise>
          				</c:choose>
        			</c:url>
        				
        			<c:choose>
          				<c:when test="${metric.single}">
            				<c:set var="scriptUrl" value="javascript:menuLayers.hide();addMetric('${metric.appdefKey},${metric.templateId}')"/>
          				</c:when>
          				<c:otherwise>
            				<c:set var="scriptUrl" value="javascript:menuLayers.hide();addMetric('${eid},${metric.templateId},${metric.appdefKey}')"/>
          				</c:otherwise>
        			</c:choose>
        
        			<li>
        				<a href="<c:out value="${scriptUrl}"/>">
        					<fmt:message key="resource.common.monitor.visibility.problemMetric.ChartMetric"/>
        				</a>
  	    				<html:link href="${chartLink}">
  	    					<fmt:message key="resource.common.monitor.visibility.problemMetric.FullChart"/>
  	    				</html:link>
        			</li>
        			<li><hr /></li>
  	    			<li>
  	    				<html:link href="" onclick="window.open('${metadataLink}','_metricMetadata','width=800,height=${metadataPopupHeight},scrollbars=yes,toolbar=no,left=80,top=80,resizable=yes'); return false;">
        					<fmt:message key="resource.common.monitor.visibility.problemMetric.MetricData"/>
          				</html:link>
          			</li>
      			</ul>
    		</div>
    			
    		<c:set var="count" value="${status.count}"/>
  		</c:forEach>

  		<c:if test="${count > 7}">
    		<div id="metricsDiv" class="scrollable">
    			<jsu:script>
					function setMetricsHeight() {
        				var metricsDiv = hqDojo.byId('metricsDiv');
        				var bottom = overlay.findPosY(hqDojo.byId('timetop'));
        				var top = overlay.findPosY(metricsDiv);

        				metricsDiv.style.height = (bottom - top) + 'px';
      				}
				</jsu:script>
				<jsu:script onLoad="true">
   					setMetricsHeight();
      			</jsu:script>
		</c:if>

		<table width="100%" border="0" cellpadding="1" cellspacing="0">
    		<tr class="tableRowHeader">
      			<th class="ListHeaderInactive">
        			<html:select property="showType" onchange="document.ProblemMetricsDisplayForm.submit()">
          				<html:option value="1">
          					<fmt:message key="resource.common.monitor.visibility.MiniTab.Problems"/>
          				</html:option>
          				<html:option value="2">
          					<fmt:message key="resource.common.monitor.visibility.MiniTab.All"/>
          				</html:option>
        			</html:select>
      			</th>
      			<th class="ListHeaderInactive" width="15%">
      				<fmt:message key="resource.common.monitor.visibility.MiniTab.OOB"/>
      			</th>
      			<th class="ListHeaderInactive" width="15%">
      				<fmt:message key="resource.common.monitor.visibility.MiniTab.Alerts"/>
      			</th>
      			<th class="ListHeaderInactive" width="28" colspan="2">
      				<fmt:message key="nbsp"/>
      			</th>
    		</tr>
  
  			<c:forEach var="metric" items="${problems}">
    			<c:choose>
      				<c:when test="${metric.single}">
        				<c:set var="scriptUrl" value="javascript:menuLayers.hide();addMetric('${metric.appdefKey},${metric.templateId}');menuLayers.hide()"/>
      				</c:when>
    				<c:otherwise>
      					<c:set var="scriptUrl" value="javascript:menuLayers.hide();addMetric('${eid},${metric.templateId},${metric.appdefKey}')"/>
    				</c:otherwise>
    			</c:choose>

				<c:if test="${resourceType != metric.type}">
      				<c:set var="resourceType" value="${metric.type}"/>
      				
      				<tr>
        				<td class="ListCellSelected" colspan="5">
        					<c:out value="${resourceType}"/>
        				</td>
      				</tr>
    			</c:if>
    			
    			<c:if test="${appdefKey != metric.appdefKey && not empty ProblemMetricsDisplayAction_resourceNames}">
    				<c:set var="appdefKey" value="${metric.appdefKey}" />
    				
    				<tr>
    					<td class="emphasizedCell" colspan="5">
    						<c:out value="${ProblemMetricsDisplayAction_resourceNames[appdefKey]}" />
    					</td>
    				</tr>
    			</c:if>
    			
				<tr>
      				<td class="ListCell">
      					<c:out value="${metric.name}"/>
      				</td>
					<td class="ListCell" align="center">
						<c:out value="${metric.oobCount}" />
					</td>
					<td class="ListCell" align="center">
						<c:out value="${metric.alertCount}"/>
					</td>
			        <td width="14" class="ListCell">
			    	    <img src="/images/comment.gif" onmouseover="menuLayers.show('metric_menu_<c:out value="${metric.templateId}" />', event)" 
			    	    onmouseout="menuLayers.hide(10)"/>
					</td>
					<td width="14" class="ListCell addMetricIcon" onclick="<c:out value="${scriptUrl}"/>"></td>
    			</tr>
  			</c:forEach>
  		</table>
  
  		<c:if test="${count > 7}">
    		</div>
  		</c:if>
  	</c:when>
  	<c:otherwise>
    	<table class="table" width="100%" border="0" cellspacing="0" cellpadding="1">
      		<tr class="tableRowHeader">
        		<th class="ListHeaderInactive">
          			<html:select property="showType" onchange="document.ProblemMetricsDisplayForm.submit()">
            			<html:option value="1">
            				<fmt:message key="resource.common.monitor.visibility.MiniTab.Problems"/>
            			</html:option>
            			<html:option value="2">
            				<fmt:message key="resource.common.monitor.visibility.MiniTab.All"/>
            			</html:option>
          			</html:select>
        		</th>
      		</tr>
      		<tr class="ListRow">
        		<td class="ListCell">
        			<fmt:message key="resource.common.monitor.visibility.no.problems.to.display"/>
        		</td>
      		</tr>
    	</table>
  	</c:otherwise>
</c:choose>