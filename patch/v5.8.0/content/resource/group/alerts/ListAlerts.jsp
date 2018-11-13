<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
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

<c:set var="entityId" value="${Resource.entityId}" />
<hq:constant classname="org.hyperic.hq.ui.Constants"
  symbol="CONTROL_ENABLED_ATTR" var="CONST_CONTROLLABLE" />
<c:set var="canControl" value="${requestScope[CONST_CONTROLLABLE]}" />
<jsu:importScript path="/js/listWidget.js" />
<jsu:importScript path="/js/schedule.js" />
<c:set var="widgetInstanceName" value="listAlerts" />
<jsu:script>
  	var jsPath = "/js/";
  	var cssPath = "/css/";
  	var isMonitorSchedule = true;
  	alertTitlestr = '<fmt:message key='resoure.Alert.action.title'/>';
	alertFixHintstr = '<fmt:message key='resoure.Alert.action.fixhint'/>';
        alertFixPrevStr = '<fmt:message key='resoure.Alert.action.fixprevious'/>';
        alertBtnFixed = '<fmt:message key='resoure.Alert.action.fix'/>';
        alertactHintstr = '<fmt:message key='resoure.Alert.action.acthint'/>'; 
        alertPauseEscStr = '<fmt:message key='resoure.Alert.action.pauseEscalation'/>'; 
	alertBtnAct = '<fmt:message key='resoure.Alert.action.ack'/>';
  	var pageData = new Array();
  	var _hqu_<c:out value="${widgetInstanceName}"/>_refreshTimeout;
  	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
  	widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');

	function requestGroupAlerts() {
    <c:url var="alertsUrl" value="/alerts/group/List.do">
      <c:param name="rid" value="${entityId.id}"/>
      <c:param name="past" value="0"/>
      <c:param name="preventCache" value="{preventCache}"/>
      <c:if test="${not empty param.ps}">
         <c:param name="ps" value="${param.ps}"/>
      </c:if>
      <c:if test="${not empty param.pn}">
         <c:param name="pn" value="${param.pn}"/>
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
    	var alertsUrl = unescape("${alertsUrl}").replace("{preventCache}", (new Date()).getTime());
    	new Ajax.Request(alertsUrl, {method: 'get', onSuccess:showGroupAlerts});
	}

	function showGroupAlerts(originalRequest) {
  		var alrJson = eval('(' +  originalRequest.responseText + ')');
  		var alerts = alrJson.logs;
  		var tbody = hqDojo.byId('alertsTbody');
  		var header = hqDojo.byId('alertsHeader');
  		// Now clean out the old
  		var cursor = header.nextSibling;
  		while (cursor) {
    		var next = cursor.nextSibling;
    		tbody.removeChild(cursor);
    		cursor = next;
  		}

  		var i;
  		for (i = 0; i < alerts.length; i++) {
    var tr  = document.createElement('tr');
    var td0 = document.createElement('td');
    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    var td5 = document.createElement('td');
    var td6 = document.createElement('td');

    if (alerts[i].fixed || !alerts[i].canTakeAction) {
      td0.innerHTML = '&nbsp;';
    }
    else {
      // checkbox id is in the format: {portalName}|{appdefKey}|{alertId}|{maxPauseTime}
      var checkboxId = "<c:out value="${widgetInstanceName}"/>" 
      						+ "|" + "<c:out value="${entityId}"/>"
      						+ "|" + alerts[i].id 
      						+ "|" + alerts[i].maxPauseTime;

      var checkBox = document.createElement("input");
      checkBox.id = checkboxId;
      checkBox.setAttribute("type", "checkbox");
      checkBox.setAttribute("name", "alerts");
      checkBox.setAttribute("value", alerts[i].id);
      checkBox.onclick = new Function("MyAlertCenter.toggleAlertButtons(this)");
      if (alerts[i].acknowledgeable) {
          checkBox.className = "ackableAlert";
      } else {
          checkBox.className = "fixableAlert";
      }
      td0.appendChild(checkBox);
    }

    if (alerts[i].priority == 1) {
      td1.innerHTML = '<fmt:message key="alert.config.props.PB.Priority.1"/>';
    }
    else if (alerts[i].priority == 2) {
      td1.innerHTML = '<fmt:message key="alert.config.props.PB.Priority.2"/>';
    }
    else if (alerts[i].priority == 3) {
      td1.innerHTML = '<fmt:message key="alert.config.props.PB.Priority.3"/>';
    }

	<c:url var="viewAlertUrl" value="/alerts/Alerts.do">
		<c:param name="mode" value="viewAlert"/>
		<c:param name="eid" value="${entityId}"/>
		<c:param name="a" value="{alertId}"/>
	</c:url>
    td2.innerHTML = '<a href="' + unescape('${viewAlertUrl}').replace("{alertId}", alerts[i].id) + '">' + alerts[i].time + '</a>'; 
    
	<c:url var="viewGroupDefinitionUrl" value="/alerts/Config.do">
		<c:param name="mode" value="viewGroupDefinition"/>
		<c:param name="eid" value="${entityId}"/>
		<c:param name="ad" value="{alertDefId}"/>
	</c:url>    
    td3.innerHTML = '<a href="' + unescape('${viewGroupDefinitionUrl}').replace("{alertDefId}", alerts[i].defId) + '">' + alerts[i].name + '</a>'; 

    td4.innerHTML = alerts[i].reason;

    td5.setAttribute("align", "left");
    if (alerts[i].fixed) {
        td5.innerHTML = '<fmt:message key="Yes"/>';
    }
    else {
        td5.innerHTML = '<fmt:message key="No"/>';
    }

    td6.setAttribute("align", "left");
    if (alerts[i].acknowledgeable && alerts[i].canTakeAction) {
        var ackAnchor = document.createElement("a");
        td6.appendChild(ackAnchor);
        var imgNode = document.createElement('img');
        imgNode.setAttribute("src", "<html:rewrite page="/images/icon_ack.gif"/>");
        imgNode.setAttribute("border", "0");
        imgNode.setAttribute("alt", "<fmt:message key="alerts.alert.AlertList.ListHeader.Acknowledge"/>");
        ackAnchor.appendChild(imgNode);
        
       	<c:url var="acknowledgeUrl" value="/alerts/group/Acknowledge.do">
			<c:param name="buttonAction" value="ACKNOWLEDGE"/>
			<c:param name="eid" value="${entityId.appdefKey}"/>
			<c:param name="alerts" value="{alerts}"/>
		</c:url>    
        ackAnchor.setAttribute('href', unescape('${acknowledgeUrl}').replace("{alerts}", alerts[i].id));
    }
    else {
        td6.innerHTML = '<fmt:message key="nbsp"/>';
    }


    tr.setAttribute("class", "ListRow");
    td0.setAttribute("class", "ListCell");
    td1.setAttribute("class", "ListCell");
    td2.setAttribute("class", "ListCell");
    td3.setAttribute("class", "ListCell");
    td4.setAttribute("class", "ListCell");
    td5.setAttribute("class", "ListCell");
    td6.setAttribute("class", "ListCell");
    
    tr.appendChild(td0);
    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);
    tr.appendChild(td6);

    tbody.appendChild(tr, header.nextSibling);
  }
  
  // See if we can set the number
  var totalSpan = hqDojo.byId('pagingTotal');
  if (totalSpan) {
    totalSpan.innerHTML = alrJson.total;
  }    
}

function _hqu_<c:out value="${widgetInstanceName}"/>_autoRefresh() {
    _hqu_<c:out value="${widgetInstanceName}"/>_refreshTimeout = setTimeout("_hqu_<c:out value="${widgetInstanceName}"/>_autoRefresh()", 60000);
    requestGroupAlerts();
}

hqDojo.require("dijit.dijit");
hqDojo.require("dijit.Dialog");
hqDojo.require("dijit.ProgressBar");
      	
var MyAlertCenter = null;
</jsu:script>
<jsu:script onLoad="true">
	MyAlertCenter = new hyperic.alert_center("<fmt:message key='alert.current.list.Title'/>");

	hqDojo.connect("requestGroupAlerts", function() { MyAlertCenter.resetAlertTable(hqDojo.byId('<c:out value="${widgetInstanceName}"/>_FixForm')); });

	_hqu_<c:out value="${widgetInstanceName}"/>_autoRefresh();
</jsu:script>
<c:set var="hyphenStr" value="--" />
<c:url var="pnAction" value="/alerts/Alerts.do">
  <c:param name="mode" value="list" />
  <c:param name="eid" value="${entityId}" />
  <c:if test="${not empty param.ps}">
    <c:param name="ps" value="${param.ps}" />
  </c:if>
  <c:if test="${not empty param.so}">
    <c:param name="so" value="${param.so}" />
  </c:if>
  <c:if test="${not empty param.sc}">
    <c:param name="sc" value="${param.sc}" />
  </c:if>
  <c:if test="${not empty param.year}">
    <c:param name="year" value="${param.year}" />
  </c:if>
  <c:if test="${not empty param.month}">
    <c:param name="month" value="${param.month}" />
  </c:if>
  <c:if test="${not empty param.day}">
    <c:param name="day" value="${param.day}" />
  </c:if>
</c:url>
<c:url var="sortAction" value="/alerts/Alerts.do">
  <c:param name="mode" value="list" />
  <c:param name="eid" value="${entityId}" />
  <c:if test="${not empty param.pn}">
    <c:param name="pn" value="${param.pn}" />
  </c:if>
  <c:if test="${not empty param.ps}">
    <c:param name="ps" value="${param.ps}" />
  </c:if>
  <c:if test="${not empty param.year}">
    <c:param name="year" value="${param.year}" />
  </c:if>
  <c:if test="${not empty param.month}">
    <c:param name="month" value="${param.month}" />
  </c:if>
  <c:if test="${not empty param.day}">
    <c:param name="day" value="${param.day}" />
  </c:if>
</c:url>
<c:url var="psAction" value="/alerts/Alerts.do">
  <c:param name="mode" value="list" />
  <c:param name="eid" value="${entityId}" />
  <c:if test="${not empty param.so}">
    <c:param name="so" value="${param.so}" />
  </c:if>
  <c:if test="${not empty param.sc}">
    <c:param name="sc" value="${param.sc}" />
  </c:if>
  <c:if test="${not empty param.year}">
    <c:param name="year" value="${param.year}" />
  </c:if>
  <c:if test="${not empty param.month}">
    <c:param name="month" value="${param.month}" />
  </c:if>
  <c:if test="${not empty param.day}">
    <c:param name="day" value="${param.day}" />
  </c:if>
</c:url>
<c:url var="calAction" value="/alerts/Alerts.do">
  <c:param name="mode" value="list" />
  <c:param name="eid" value="${entityId}" />
  <c:if test="${not empty param.pn}">
    <c:param name="pn" value="${param.pn}" />
  </c:if>
  <c:if test="${not empty param.ps}">
    <c:param name="ps" value="${param.ps}" />
  </c:if>
</c:url>

<tiles:insert definition=".page.title.resource.group.full">
  <tiles:put name="resource" beanName="Resource"/>
  <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
  <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
  <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
</tiles:insert>
  <c:choose>
    <c:when test="${ canControl }">
      <tiles:insert definition=".tabs.resource.group.alert.alerts">
        <tiles:put name="resourceId" beanName="Resource" beanProperty="id" />
        <tiles:put name="resourceType" beanName="entityId" beanProperty="type" />
      </tiles:insert>
    </c:when>
    <c:otherwise>
      <tiles:insert definition=".tabs.resource.group.alert.alerts.nocontrol">
        <tiles:put name="resourceId" beanName="Resource" beanProperty="id" />
        <tiles:put name="resourceType" beanName="entityId" beanProperty="type" />
      </tiles:insert>
    </c:otherwise>
  </c:choose>

	<c:url var="timeBoundCalAction" value="${calAction}">
	  	<c:param name="year" value="{year}"/>
	  	<c:param name="month" value="{month}"/>
  		<c:param name="day" value="{day}"/>
	</c:url>
	<jsu:script>
	  function nextDay() {
	    var tomorrow = new Date(<c:out value="${date}"/> + 86400000);
	    var url = unescape('${timeBoundCalAction}').replace("{year}", tomorrow.getFullYear())
	                            .replace("{month}", tomorrow.getMonth())
	                            .replace("{day}", tomorrow.getDate());
	    document.location = url;
	  }
	
	  function previousDay() {
	    var yesterday = new Date(<c:out value="${date}"/> - 86400000);
	    var url = unescape('${timeBoundCalAction}').replace("{year}", yesterday.getFullYear())
	                            .replace("{month}", yesterday.getMonth())
	                            .replace("{day}", yesterday.getDate());
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
    	writeCalNLV(weekArgs,today.getMonth(), today.getFullYear(),
             '<c:out value="${calAction}" escapeXml="false"/>');
  	}
	</jsu:script>
<input type="hidden" id="calendarTitle" value="<fmt:message key='common.alert.calendar.title'/>"/>
	
<!-- FORM -->
<html:form styleId="${widgetInstanceName}_FixForm" method="POST" action="/alerts/group/Acknowledge">
  <html:hidden property="eid" value="${entityId}" />
  <c:if test="${not empty param.year}">
    <input type="hidden" name="year" value='<c:out value="${param.year}"/>' />
  </c:if>
  <c:if test="${not empty param.month}">
    <input type="hidden" name="month" value='<c:out value="${param.month}"/>' />
  </c:if>
  <c:if test="${not empty param.day}">
    <input type="hidden" name="day" value='<c:out value="${param.day}"/>' />
  </c:if>

  <tiles:insert definition=".portlet.confirm" />
  <tiles:insert definition=".portlet.error" />

  <table width="100%">
    <tr>
      <td><a href="javascript:previousDay()"><html:img
        page="/images/schedule_left.gif" border="0" altKey="button.prevDay" titleKey="button.prevDay"/></a></td>
      <td nowrap="true" class="BoldText"><hq:dateFormatter value="${date}"
        showTime="false" /></td>
      <td><a href="javascript:nextDay()"><html:img
        page="/images/schedule_right.gif" border="0" altKey="button.nextDay" titleKey="button.nextDay"/></a></td>
      <td><html:link href="javascript:popupCal()">
        <html:img page="/images/schedule_iconCal.gif" width="19" height="17"
          altKey="button.popupCalendar" border="0" />
      </html:link></td>
      <td class="ButtonCaptionText" width="100%">
          <c:url var="path" value="/images/icon_ack.gif"/>
          <fmt:message key="dash.settings.criticalAlerts.ack.instruction">
          <fmt:param value="${path}"/>
          </fmt:message>
      </td>
    </tr>
  </table>

  <table class="table" cellspacing="0" cellpadding="0" width="100%">
    <tbody id="alertsTbody">
      <tr id="alertsHeader" class="tableRowHeader">
        <th width="1%" class="ListHeaderCheckbox">
            <input type="checkbox" onclick="MyAlertCenter.toggleAll(this)" id="<c:out value="${widgetInstanceName}"/>_CheckAllBox" name="listToggleAll"></th>
        <th class="tableRowSorted">
          <fmt:message key="alert.current.list.Priority" /></th>
        <th class="tableRowSorted">
          <fmt:message key="alerts.alert.AlertList.ListHeader.AlertDate" /></th>
        <th class="tableRowSorted">
          <fmt:message key="alerts.alert.AlertList.ListHeader.AlertDefinition" /></th>
        <th class="tableRowSorted">
          <fmt:message key="alerts.alert.AlertList.ListHeader.AlertCondition" /></th>
        <th class="tableRowSorted" align="left">
          <fmt:message key="alerts.alert.AlertList.ListHeader.Fixed" /></th>
        <th class="tableRowSorted" align="left">
          <fmt:message key="alerts.alert.AlertList.ListHeader.Acknowledge" /></th>
      </tr>
    </tbody>
  </table>

	<c:if test="${canTakeAction}">
  		<tiles:insert definition=".toolbar.list">
    		<tiles:put name="listItems" beanName="Alerts" />
    		<tiles:put name="listSize" beanName="listSize" />
    		<tiles:put name="noButtons" value="true"/>
    		<tiles:put name="alerts" value="true"/>
    		<tiles:put name="pageNumAction" beanName="pnAction" />
    		<tiles:put name="pageSizeAction" beanName="psAction" />
    		<tiles:put name="defaultSortColumn" value="2" />
    		<tiles:put name="widgetInstanceName" beanName="widgetInstanceName" />
  		</tiles:insert>
  	</c:if>
  	
  <div id="HQAlertCenterDialog" style="display:none;"></div>
  <tiles:insert definition=".page.footer">
  </tiles:insert>
</html:form>
<!-- /  -->
