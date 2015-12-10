<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="/WEB-INF/tld/sas.tld" prefix="sas" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".
  
  Copyright (C) [2004-2009], Hyperic, Inc.
  This file is part of HQ.
  
  HQ is free software; you can redistribute it and/or modify
  it under the terms version 2 of the GNU General Public License as
  published by the Free Software Foundation. This program is distributed
  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE. See the GNU General Public License for more
  details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA.
 --%>

<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_PLATFORM" var="CONST_PLATFORM" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_SERVER" var="CONST_SERVER" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_SERVICE" var="CONST_SERVICE" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_APPLICATION" var="CONST_APPLICATION" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_GROUP" var="CONST_GROUP" />
<hq:constant
    classname="org.hyperic.hq.ui.Constants" 
    symbol="CONTROL_ENABLED_ATTR" var="CONST_CONTROLLABLE" /> 

<c:set var="canControl" value="${requestScope[CONST_CONTROLLABLE]}"/>
<jsu:importScript path="/js/listWidget.js" />
<jsu:importScript path="/js/schedule.js" />
<c:set var="widgetInstanceName" value="listAlerts"/>
<jsu:script>
  	var jsPath = "<html:rewrite page="/js/"/>";
  	var cssPath = "<html:rewrite page="/css/"/>";
  	var isMonitorSchedule = true;
  	var pageData = new Array();
	  alertTitlestr = '<fmt:message key='resoure.Alert.action.title'/>';
	  alertFixHintstr = '<fmt:message key='resoure.Alert.action.fixhint'/>';
	  alertFixPrevStr = '<fmt:message key='resoure.Alert.action.fixprevious'/>';
	  alertBtnFixed = '<fmt:message key='resoure.Alert.action.fix'/>';
	  alertactHintstr = '<fmt:message key='resoure.Alert.action.acthint'/>'; 
	  alertPauseEscStr = '<fmt:message key='resoure.Alert.action.pauseEscalation'/>'; 
	  alertBtnAct = '<fmt:message key='resoure.Alert.action.ack'/>';
    initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');

    widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');
</jsu:script>
<c:set var="entityId" value="${Resource.entityId}"/>
<c:set var="hyphenStr" value="--"/>

<c:url var="pnAction" value="/alerts/Alerts.do">
  	<c:param name="mode" value="list"/>
  	<c:param name="eid" value="${entityId.type}:${Resource.id}"/>
  	<c:if test="${not empty param.ps}">
    	<c:param name="ps" value="${param.ps}"/>
  	</c:if>
  	<c:if test="${not empty param.so}">
    	<c:param name="so" value="${param.so}"/>
  	</c:if>
  	<c:if test="${not empty param.sc}">
    	<c:param name="sc" value="${param.sc}"/>
  	</c:if>
  	<c:if test="${not empty param.year}">
    	<c:param name="year" value="${param.year}"/>
  	</c:if>
  	<c:if test="${not empty param.month}">
    	<c:param name="month" value="${param.month}"/>
  	</c:if>
  	<c:if test="${not empty param.day}">
    	<c:param name="day" value="${param.day}"/>
  	</c:if>
</c:url>
<c:url var="sortAction" value="/alerts/Alerts.do">
  	<c:param name="mode" value="list"/>
  	<c:param name="eid" value="${entityId.type}:${Resource.id}"/>
  	<c:if test="${not empty param.pn}">
    	<c:param name="pn" value="${param.pn}"/>
  	</c:if>
  	<c:if test="${not empty param.ps}">
    	<c:param name="ps" value="${param.ps}"/>
  	</c:if>
  	<c:if test="${not empty param.year}">
    	<c:param name="year" value="${param.year}"/>
  	</c:if>
  	<c:if test="${not empty param.month}">
    	<c:param name="month" value="${param.month}"/>
  	</c:if>
  	<c:if test="${not empty param.day}">
    	<c:param name="day" value="${param.day}"/>
  	</c:if>
</c:url>
<c:url var="psAction" value="/alerts/Alerts.do">
  	<c:param name="mode" value="list"/>
  	<c:param name="eid" value="${entityId.type}:${Resource.id}"/>
  	<c:if test="${not empty param.so}">
    	<c:param name="so" value="${param.so}"/>
  	</c:if>
  	<c:if test="${not empty param.sc}">
	    <c:param name="sc" value="${param.sc}"/>
  	</c:if>
  	<c:if test="${not empty param.year}">
    	<c:param name="year" value="${param.year}"/>
  	</c:if>
  	<c:if test="${not empty param.month}">
    	<c:param name="month" value="${param.month}"/>
  	</c:if>
  	<c:if test="${not empty param.day}">
    	<c:param name="day" value="${param.day}"/>
  	</c:if>
</c:url>
<c:url var="calAction" value="/alerts/Alerts.do">
  	<c:param name="mode" value="list"/>
  	<c:param name="eid" value="${entityId.type}:${Resource.id}"/>
  	<c:if test="${not empty param.pn}">
	    <c:param name="pn" value="${param.pn}"/>
  	</c:if>
  	<c:if test="${not empty param.ps}">
    	<c:param name="ps" value="${param.ps}"/>
  	</c:if>
</c:url>

<c:if test="${ CONST_PLATFORM == entityId.type}">
	<c:set var="entityId" value="${Resource.entityId}"/>
	<tiles:insert  definition=".page.title.events.list.platform">
	    <tiles:put name="resource" beanName="Resource"/>
	    <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
	    <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
	    <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
	</tiles:insert>
    <c:choose>
        <c:when test="${ canControl }">
			<tiles:insert definition =".tabs.resource.platform.alert.alerts">
			    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
			    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
			</tiles:insert>
        </c:when>
        <c:otherwise>
            <tiles:insert definition =".tabs.resource.platform.alert.alerts.nocontrol">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:otherwise>
    </c:choose>
</c:if>
<c:if test="${CONST_SERVER == entityId.type}">
	<tiles:insert  definition=".page.title.events.list.server">
	    <tiles:put name="resource" beanName="Resource"/>
	    <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
	    <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
	    <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
	</tiles:insert>
    <c:choose>
        <c:when test="${ canControl }">
            <tiles:insert definition =".tabs.resource.server.alert.alerts">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:when>
        <c:otherwise>
            <tiles:insert definition =".tabs.resource.server.alert.alerts.nocontrol">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:otherwise>
    </c:choose>
</c:if>
<c:if test="${CONST_SERVICE == entityId.type}">
<tiles:insert  definition=".page.title.events.list.service">
    <tiles:put name="resource" beanName="Resource"/>
    <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
    <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
    <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
</tiles:insert>
    <c:choose>
        <c:when test="${ canControl }">
            <tiles:insert definition =".tabs.resource.service.alert.alerts">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:when>
        <c:otherwise>
            <tiles:insert definition =".tabs.resource.service.alert.alerts.nocontrol">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:otherwise>
    </c:choose>
</c:if>
<c:if test="${CONST_APPLICATION == entityId.type}">
<tiles:insert  definition=".page.title.events.list.application">
    <tiles:put name="titleName" beanName="Resource" beanProperty="name"/>
    <tiles:put name="resource" beanName="Resource"/>
    <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
    <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
</tiles:insert>
<tiles:insert definition =".tabs.resource.application.monitor.alerts">
        <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
        <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
</tiles:insert>
</c:if>
<c:if test="${CONST_GROUP == entityId.type}">
    <tiles:insert  definition=".page.title.events.list.group">
        <tiles:put name="titleName" beanName="Resource" beanProperty="name"/>
        <tiles:put name="resource" beanName="Resource"/>
        <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
        <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
    </tiles:insert>
    <c:choose>
        <c:when test="${ canControl }">
            <tiles:insert definition =".tabs.resource.group.alert">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:when>
        <c:otherwise>
            <tiles:insert definition =".tabs.resource.group.alert.nocontrol">
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
            </tiles:insert>
        </c:otherwise>
    </c:choose>
</c:if>
<%@ page import="java.util.Locale" %>

<%
	String djLocaleString="";
	Locale locale = request.getLocale();
	String reqLocaleString = request.getLocale().toString();
	if(reqLocaleString.equalsIgnoreCase("zh_HANS_CN")){
		locale = new Locale("zh", "CN");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANT_TW")){
		locale = new Locale("zh", "TW");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANT_HK")){
		locale = new Locale("zh", "HK");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANS")){
		locale = new Locale("zh", "CN");
	}else if(reqLocaleString.equalsIgnoreCase("zh_HANT")){
		locale = new Locale("zh", "TW");
	}
	//dojo locale must use lower case string.
	djLocaleString = locale.toString().replaceAll("_","-").toLowerCase();
%>
<input type="hidden" id="localeString" value="<%=djLocaleString%>" />
<input type="hidden" id="sundayLabel" value='<fmt:message key="common.alert.calendar.Sunday"/>' />
<input type="hidden" id="mondayLabel" value='<fmt:message key="common.alert.calendar.Monday"/>' />
<input type="hidden" id="tuesdayLabel" value='<fmt:message key="common.alert.calendar.Tuesday"/>' />
<input type="hidden" id="wednesdayLabel" value='<fmt:message key="common.alert.calendar.Wednesday"/>' />
<input type="hidden" id="thursdayLabel" value='<fmt:message key="common.alert.calendar.Thursday"/>' />
<input type="hidden" id="friddayLabel" value='<fmt:message key="common.alert.calendar.Friday"/>' />
<input type="hidden" id="staturdayLabel" value='<fmt:message key="common.alert.calendar.Saturday"/>' />
<input type="hidden" id="refreshCont" value="0" />
<jsu:script>
  	function nextDay() {
    	var tomorrow = new Date(<c:out value="${date}"/> + 86400000);
    	var url = '<c:out value="${calAction}" escapeXml="false"/>' +
              '&year=' + tomorrow.getFullYear() +
              '&month=' + tomorrow.getMonth() +
              '&day=' + tomorrow.getDate();
    	document.location = url;
  	}

  	function previousDay() {
    	var yesterday = new Date(<c:out value="${date}"/> - 86400000);
    	var url = '<c:out value="${calAction}" escapeXml="false"/>' +
              '&year=' + yesterday.getFullYear() +
              '&month=' + yesterday.getMonth() +
              '&day=' + yesterday.getDate();
    	document.location = url;
  	}

  	function popupCal() {	
	var monthArr = new Array(
					  '<fmt:message key="resource.control.schedule.jan"/>',
					  '<fmt:message key="resource.control.schedule.feb"/>',
					  '<fmt:message key="resource.control.schedule.mar"/>',
					  '<fmt:message key="resource.control.schedule.apr"/>',
					  '<fmt:message key="resource.control.schedule.may"/>',
					  '<fmt:message key="resource.control.schedule.jun"/>',
					  '<fmt:message key="resource.control.schedule.jul"/>',
					  '<fmt:message key="resource.control.schedule.aug"/>',
					  '<fmt:message key="resource.control.schedule.sep"/>',
					  '<fmt:message key="resource.control.schedule.oct"/>',
					  '<fmt:message key="resource.control.schedule.nov"/>',
					  '<fmt:message key="resource.control.schedule.dec"/>');
	var weekArgs = {
			sunday : '<fmt:message key="common.alert.calendar.Sunday"/>',
			monday : '<fmt:message key="common.alert.calendar.Monday"/>',
			tuesday : '<fmt:message key="common.alert.calendar.Tuesday"/>',
			wednesday : '<fmt:message key="common.alert.calendar.Wednesday"/>',
			thursday : '<fmt:message key="common.alert.calendar.Thursday"/>',
			friday : '<fmt:message key="common.alert.calendar.Friday"/>',
			saturday : '<fmt:message key="common.alert.calendar.Saturday"/>',
			monthArray : monthArr
		};
    	var today = new Date(<c:out value="${date}"/>);
    	writeCal(today.getMonth(), today.getFullYear(),
             '<c:out value="${calAction}" escapeXml="false"/>');
  	}
</jsu:script>
<!-- FORM -->
<html:form styleId="${widgetInstanceName}_FixForm" method="POST" action="/alerts/RemoveAlerts">
	<html:hidden property="eid" value="${Resource.entityId}"/>
  	<c:if test="${not empty param.year}">
    	<input type="hidden" name="year" value="<c:out value="${param.year}"/>"/>
  	</c:if>
  	<c:if test="${not empty param.month}">
    	<input type="hidden" name="month" value="<c:out value="${param.month}"/>"/>
  	</c:if>
  	<c:if test="${not empty param.day}">
    	<input type="hidden" name="day" value="<c:out value="${param.day}"/>"/>
  	</c:if>
	
	<tiles:insert definition=".portlet.confirm"/>
	<tiles:insert definition=".portlet.error"/>
	<jsu:script>
		hqDojo.require("dijit.dijit");	
		hqDojo.require("dijit.Dialog");
  		hqDojo.require("dijit.ProgressBar");
          	
		var MyAlertCenter = null;
	</jsu:script>
	<jsu:script onLoad="true">
		MyAlertCenter = new hyperic.alert_center("Alerts");          		
	</jsu:script>
	<table width="100%">
		<tr>
			<td>
				<a href="javascript:previousDay()"><html:img page="/images/schedule_left.gif" border="0" altKey="button.prevDay"/></a>
			</td>
			<td nowrap="true" class="BoldText"><sas:evmServerDateTag value="${date}"/></td>
			<td><a href="javascript:nextDay()"><html:img page="/images/schedule_right.gif" border="0" altKey="button.nextDay"/></a></td>
			<td>
			<html:link href="javascript:popupCal()">
			<html:img page="/images/schedule_iconCal.gif" width="19" height="17" altKey="button.popupCalendar" titleKey="button.popupCalendar" border="0"/>
			</html:link>
			<input type="hidden"
			</td>
			<td class="ButtonCaptionText" width="100%">
    			<c:url var="path" value="/images/icon_ack.gif"/>
    			<fmt:message key="dash.settings.criticalAlerts.ack.instruction">
      				<fmt:param value="${path}"/>
    			</fmt:message>
			</td>
		</tr>
	</table>
	<c:choose>
  		<c:when test="${not empty param.so}">
    		<c:set var="so" value="${param.so}"/>
  		</c:when>
  		<c:otherwise>
    		<c:set var="so" value="dec"/>
  		</c:otherwise>
	</c:choose>
	<display:table cellspacing="0" cellpadding="0" width="100%" order="${so}" action="${sortAction}" items="${Alerts}" var="Alert">
		<display:column width="1%" property="id" 
	                title="<input type=\"checkbox\" onclick=\"MyAlertCenter.toggleAll(this)\" id=\"${widgetInstanceName}_CheckAllBox\">" 
	                isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox">
			<display:alertcheckboxdecorator name="alerts" onclick="MyAlertCenter.toggleAlertButtons(this)"
		                                elementId="${widgetInstanceName}|${Resource.entityId.appdefKey}|${Alert.id}|${Alert.maxPauseTime}"
										fixable="${!Alert.fixed}" acknowledgeable="${Alert.acknowledgeable}" styleClass="listMember"/> 
		</display:column>
		<display:column width="10%" property="priority" title="alerts.alert.AlertList.ListHeader.Priority">
			<display:prioritydecorator flagKey="alerts.alert.alertlist.listheader.priority"/>
		</display:column>
		<display:column width="20%" property="ctime" sort="true" sortAttr="2" defaultSort="true" 
	                title="alerts.alert.AlertList.ListHeader.AlertDate" 
	                href="/alerts/Alerts.do?mode=viewAlert&eid=${Resource.entityId.appdefKey}" 
	                paramId="a" paramProperty="id">
	    	<display:eventdatetimedecorator/>
		</display:column>
	    	
		<display:column width="20%" property="name" sort="true" sortAttr="1" defaultSort="false" 
	                title="alerts.alert.AlertList.ListHeader.AlertDefinition">
			<display:conditionallinkdecorator test="${Alert.viewable}"
					                      href="/alerts/Config.do?mode=viewDefinition&eid=${Resource.entityId.appdefKey}&ad=${Alert.alertDefId}" />
		</display:column>
		<display:column width="20%" property="conditionFmt" title="alerts.alert.AlertList.ListHeader.AlertCondition"/>
		<display:column width="12%" property="value" title="alerts.alert.AlertList.ListHeader.ActualValue" />
		<display:column width="7%" property="fixed" title="alerts.alert.AlertList.ListHeader.Fixed">
  			<display:booleandecorator flagKey="yesno"/>
		</display:column>
		<display:column width="11%" property="acknowledgeableAndCanTakeAction" title="alerts.alert.AlertList.ListHeader.Acknowledge"
                    href="/alerts/RemoveAlerts.do?eid=${Resource.entityId.appdefKey}&alerts=${Alert.id}&buttonAction=ACKNOWLEDGE">
  			<display:booleandecorator flagKey="acknowledgeable"/>
		</display:column>
	</display:table>

	<c:if test="${canTakeAction}">
		<tiles:insert definition=".toolbar.list">
  			<tiles:put name="listItems" beanName="Alerts"/>
  			<tiles:put name="noButtons" value="true"/>
	  		<tiles:put name="alerts" value="true"/>
	  		<tiles:put name="listSize" beanName="listSize"/>
	  		<tiles:put name="pageNumAction" beanName="pnAction"/>
	  		<tiles:put name="pageSizeAction" beanName="psAction"/>
	  		<tiles:put name="defaultSortColumn" value="2"/>
	  		<tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
		</tiles:insert>
	</c:if>
	<div id="HQAlertCenterDialog" style="display:none;"></div>
	<tiles:insert definition=".page.footer"></tiles:insert>
</html:form>
