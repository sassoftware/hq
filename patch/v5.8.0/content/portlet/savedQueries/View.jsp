<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".
  
  Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
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
 
<% response.setHeader("Pragma","no-cache");%>
<% response.setHeader("Cache-Control","no-store");%>
<% response.setDateHeader("Expires",-1);%>
 
<tiles:importAttribute name="charts"/> <!-- data -->
<tiles:importAttribute name="tabName" ignore="true"/>
<tiles:importAttribute name="icon" ignore="true"/>
<tiles:importAttribute name="subTitle" ignore="true"/>
<tiles:importAttribute name="useFromSideBar" ignore="true"/>
<tiles:importAttribute name="useToSideBar" ignore="true"/>
<tiles:importAttribute name="adminUrl" ignore="true"/>
<tiles:importAttribute name="adminToken" ignore="true"/>
<tiles:importAttribute name="portletName" ignore="true"/>
<tiles:importAttribute name="rssBase" ignore="true"/>
<tiles:importAttribute name="enableDelete" ignore="true"/>
<tiles:importAttribute name="dragDrop" ignore="true"/>
<tiles:importAttribute name="cancelAdvanced" ignore="true"/>

<c:set var="enableDelete" value="${sessionScope.modifyDashboard}"/>
<c:set var="dragDrop" value="${sessionScope.modifyDashboard}"/>
<c:set var="selectedDashboardId" value="${sessionScope['.user.dashboard.selected.id']}"/>
<jsu:script>
    hqDojo.require('dojo.NodeList-fx');

    var chartKwArgs = {
	    tabName : 'chartWidget',
	    title : '<fmt:message key="dash.home.SavedQueries"/>', /*tab key*/
	    icon : '<c:out value="${icon}"/>',
	    subTitle : '<c:out value="${subTitle}"/>',
	    useFromSideBar : '<c:out value="${useFromSideBar}"/>',
	    useToSideBar : '<c:out value="${useToSideBar}"/>',
	    adminToken : '<c:out value="${adminToken}"/>',
	    portletName : '<c:out value="${portletName}"/>',
	    rssBase : '<c:out value="${rssBase}"/>',
	    enableDelete :'<c:out value="${enableDelete}"/>',
	    configureKey: '<fmt:message key="dash.Configure"/>',
	    url: '<html:rewrite page="/app/dashboard/${selectedDashboardId}/portlet/savedcharts"/>',
	    chartUrl: '<html:rewrite page="/app/dashboard/${selectedDashboardId}/portlet/savedcharts/chart/{rid}/{mtid}"/>',
	    ctypeChartUrl: '<html:rewrite page="/app/dashboard/${selectedDashboardId}/portlet/savedcharts/chart/{rid}/{mtid}/{ctype}"/>'
    };
</jsu:script>
<jsu:script onLoad="true">
    // initialize the chartwidget
    cw = new hyperic.dashboard.chartWidget(chartKwArgs);
</jsu:script>
<div class="effectsPortlet">
    <div class="widget" id="chartWidget">
        <div class="widgetTitle">
            <h2 class="widgetHandle"><fmt:message key="dash.home.SavedQueries"/></h2>
            <img src="<html:rewrite page="/images/4.0/icons/properties.gif" />" border="0" title="<fmt:message key='dash.home.ConfigureWidget' />" alt="<fmt:message key='dash.home.ConfigureWidget' />" class="config_btn">
            <img src="<html:rewrite page="/images/4.0/icons/cross.gif" />" border="0" title="<fmt:message key='dash.home.RemoveWidget' />" class="remove_btn">
        </div>
        <div class="loading">
            <fmt:message key="dash.home.loading"/><img src="<html:rewrite page="/images/4.0/icons/ajax-loader.gif" />" alt="">
        </div>
    		<div class="error_loading">
      			<fmt:message key="dash.home.SavedQueries.error.loading"/>
    		</div>
        <div class="instructions">
            <fmt:message key="dash.home.SavedQueries.instructions"/>
        </div>
        <div class="content">
            <form method="POST" action="">
            <input type="text" id="chartsearch" name="chartsearch" value="[ <fmt:message key="dash.home.SavedQueries.configure.search"/> ]"><br />
            <select id="chartselect" name="chart" size="10" value="0">
            </select>
            </form>
      
            <div id="chart_container">
            </div>
            <button id="chart_remove_btn" name="chart_remove_btn" class="btnGreenBlack"><span><fmt:message key="button.removeChart"/></span></button>
            <img src="<html:rewrite page="/images/4.0/icons/control_pause.png" />" border="0" alt="pause slideshow" class="pause_btn">
            <div class="last_updated"></div>
        </div>
        <div class="config">
            <form method="POST" action="">
                <fieldset>
                    <legend><fmt:message key="dash.home.configure.Title"/></legend>
                    <ol>
                        <li  style="vertical-align:middle">
                            <label for="chart_rotation"><fmt:message key="dash.home.SavedChart.Rotaton"/></label> 
                            <input type="checkbox" name="chart_rotation" id="chart_rotation">
                        </li>
                        <li>
                            <label for="chart_interval"><fmt:message key="dash.home.SavedChart.Interval"/></label>
                            <select name="chart_interval" id="chart_interval">
                                <option value="10">10 <fmt:message key="Content.unit.second"/></option>
                                <option value="30">30 <fmt:message key="Content.unit.second"/></option>
                                <option value="60">1 <fmt:message key="Content.unit.minute"/></option>
                                <option value="120">2 <fmt:message key="Content.unit.minute"/></option>
                                <option value="300">5 <fmt:message key="Content.unit.minute"/></option>
                            </select>
                        </li>
                        <li>
                            <label for="chart_range"><fmt:message key="dash.home.SavedChart.Range"/></label> 
                            <select name="chart_range" id="chart_range">
                                  <option value="1h">1 <fmt:message key="Content.unit.hour"/></option>
                                  <option value="6h">6 <fmt:message key="Content.unit.hour"/></option>
                                  <option value="1d">1 <fmt:message key="Content.unit.day"/></option>
                                  <option value="1w">1 <fmt:message key="Content.unit.week"/></option>
                                  <option value="1m">1 <fmt:message key="Content.unit.month"/></option>
                            </select>
                        </li>
                    </ol>
                </fieldset>
                <div style="text-align: right;">
                    <input type="submit" value="<fmt:message key="dash.home.SavedChart.Save"/>" class="save_btn">
                    <input type="submit" value="<fmt:message key="dash.home.SavedChart.Cancel"/>" class="cancel_btn">
                </div>
            </form>
        </div>
    </div>
</div>
