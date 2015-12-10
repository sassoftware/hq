<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
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
  
  Copyright (C) [2004-2008], Hyperic, Inc.
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

<tiles:importAttribute name="form" ignore="true"/>
<tiles:importAttribute name="mode" ignore="true"/>
<tiles:importAttribute name="eid" ignore="true"/>
<tiles:importAttribute name="view" ignore="true"/>

<c:if test="${not empty mode}">
  <input type="hidden" name="mode" value="<c:out value="${mode}"/>"/>
</c:if>
<c:if test="${not empty eid}">
  <input type="hidden" name="eid" value="<c:out value="${eid}"/>"/>
</c:if>
<c:if test="${not empty view}">
  <input type="hidden" name="view" value="<c:out value="${view}"/>"/>
</c:if>

<c:choose>
  <c:when test="${not empty form}">
    <%-- used only for forms that are not MetricsDisplayForm --%>
    <tiles:importAttribute name="formName"/>
    <c:set var="readOnly" value="${form.readOnly}"/>
    <c:set var="rangeBegin" value="${form.rb}"/>
    <c:set var="rangeEnd" value="${form.re}"/>
    <c:set var="showBaseline" value="false"/>
  </c:when>
  <c:otherwise>
    <c:set var="formName" value="MetricsDisplayForm"/>
    <c:set var="readOnly" value="${MetricsDisplayForm.readOnly}"/>
    <c:set var="rangeBegin" value="${MetricsDisplayForm.rb}"/>
    <c:set var="rangeEnd" value="${MetricsDisplayForm.re}"/>
    <c:set var="highlighted" value="${MetricsDisplayForm.h}"/>
    <c:set var="showBaseline" value="${MetricsDisplayForm.showBaseline}"/>
  </c:otherwise>
</c:choose>

<hq:dateFormatter var="rb" value="${rangeBegin}"/>
<hq:dateFormatter var="re" value="${rangeEnd}"/>

<!-- Table Content -->
<table width="100%" cellspacing="0" border="0" class="MonitorToolbar">
<c:if test="${showBaseline}">
  <tr valign="middle">
    <td width="20%" align="right"><b><fmt:message key="resource.common.monitor.visibility.metricsToolbar.HighlightMetricsLabel"/></b></td>
    <td width="80%">
      <table width="100%" cellpadding="0" cellspacing="3" border="0">
        <tr>
          <td>
            <html:select styleClass="FilterFormText" property="hv">
              <html:option value=""/>
              <html:option value="1" key="resource.common.monitor.visibility.metricsToolbar.LowValue"/>
              <html:option value="2" key="resource.common.monitor.visibility.metricsToolbar.AverageValue"/>
              <html:option value="3" key="resource.common.monitor.visibility.metricsToolbar.PeakValue"/>
              <html:option value="4" key="resource.common.monitor.visibility.metricsToolbar.LastValue"/>
            </html:select>
          </td>
          <td><fmt:message key="resource.common.monitor.visibility.metricsToolbar.is"/></td>
          <td nowrap>
            <html:select styleClass="FilterFormText" property="hp">
              <html:option value=""/>
              <html:option value="5" key="resource.common.monitor.visibility.metricsToolbar.5%"/>
              <html:option value="10" key="resource.common.monitor.visibility.metricsToolbar.10%"/>
              <html:option value="20" key="resource.common.monitor.visibility.metricsToolbar.20%"/>
              <html:option value="30" key="resource.common.monitor.visibility.metricsToolbar.30%"/>
              <html:option value="40" key="resource.common.monitor.visibility.metricsToolbar.40%"/>
              <html:option value="50" key="resource.common.monitor.visibility.metricsToolbar.50%"/>
              <html:option value="60" key="resource.common.monitor.visibility.metricsToolbar.60%"/>
              <html:option value="70" key="resource.common.monitor.visibility.metricsToolbar.70%"/>
              <html:option value="80" key="resource.common.monitor.visibility.metricsToolbar.80%"/>
              <html:option value="90" key="resource.common.monitor.visibility.metricsToolbar.90%"/>
              <html:option value="100" key="resource.common.monitor.visibility.metricsToolbar.100%"/>
            </html:select> 
            <html:select styleClass="FilterFormText" property="ht">
              <html:option value=""/>
              <hq:optionMessageList property="highlightThresholdMenu" baseKey="resource.common.monitor.visibility.metricsToolbar" filter="true"/>
            </html:select>
          </td>
          <td><html:image property="highlight" page="/images/4.0/icons/accept.png" border="0" altKey="button.ok"/></td>

        </tr>
      </table>
    </td>
  </tr>
</c:if>
  
</table>
<div id="advancedAnchor" style="position: relative; visibility: hidden;"></div>
<div id="advancedContainer">
<div id="advancedDisplay" class="dialog" style="display: none;">
	<tiles:insert definition=".resource.common.monitor.visibility.embeddedMetricDisplayRange">
      	<c:if test="${not empty form}">
	    	<tiles:put name="form" beanName="form"/>
          	<tiles:put name="formName" beanName="formName"/>
        </c:if>
    </tiles:insert>
</div>
</div>
<jsu:script>
	var advancedDialog = null;
</jsu:script>
<jsu:script onLoad="true">	
	advancedDialog = new hqDijit.Dialog({
            id: 'advancedDisplay',
            refocus: true,
            autofocus: false,
            opacity: 0,
            title: "<fmt:message key="resource.common.monitor.visibility.metricsToolbar.EditRangeBtn" />"
    }, hqDojo.byId('advancedDisplay'));
		
	var showHolder = advancedDialog.show;
	var hideHolder = advancedDialog.hide;
	var toggleControl = function (id, enabled) {
		var obj = hqDojo.byId(id);
			
		if (obj) {
			obj.disabled = !enabled;
			
			if (enabled == true) {
				obj.style.visibility = "visible";
			} else {
				obj.style.visibility = "hidden";
			}
		}
	}
		
	advancedDialog.show = function() {
		toggleControl("simpleRn", false);
		toggleControl("simpleRu", false);
		showHolder.call(this);
	}
		
	advancedDialog.hide = function() {
		toggleControl("simpleRn", true);
		toggleControl("simpleRu", true);
		hideHolder.call(this);
	}
		
    hqDojo.place(hqDojo.byId('advancedDisplay'), hqDojo.byId('advancedContainer'), "last");
</jsu:script>