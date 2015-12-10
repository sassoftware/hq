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
<tiles:importAttribute name="portlet"/>
<tiles:importAttribute name="portletName"/>
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

<jsu:script>
	searchstr = '<fmt:message key='dash.home.AlertSummary.configure.searchGroup'/>';
</jsu:script>
<c:set var="enableDelete" value="${sessionScope.modifyDashboard}"/>
<c:set var="dragDrop" value="${sessionScope.modifyDashboard}"/>
<c:set var="selectedDashboardId" value="${sessionScope['.user.dashboard.selected.id']}"/>
<jsu:script>
    hqDojo.require('dojo.NodeList-fx');

    var summaryKwArgs = {
	    tabName : 'summaryWidget',
	    title : '<fmt:message key="dash.home.AlertSummary.Title"/>', /*tab key*/
	    icon : '<c:out value="${icon}"/>',
	    subTitle : '<c:out value="${subTitle}"/>',
	    useFromSideBar : '<c:out value="${useFromSideBar}"/>',
	    useToSideBar : '<c:out value="${useToSideBar}"/>',
	    adminToken : '<c:out value="${adminToken}"/>',
	    portletName : '<c:out value="${portletName}"/>',
	    rssBase : '<c:out value="${rssBase}"/>',
	    enableDelete :'<c:out value="${enableDelete}"/>',
	    configureKey: '<fmt:message key="dash.Configure"/>',
	    url: '<html:rewrite page="/app/dashboard/${selectedDashboardId}/portlet/groupalertsummary"/>'
    };
</jsu:script>
<jsu:script onLoad="true">
    // initialize the chartwidget
    groupAlertFailure='<fmt:message key="group.alert.failure"/>';
    groupAlertWarning='<fmt:message key="group.alert.warning"/>';
    groupAlertOK='<fmt:message key="group.alert.ok"/>';
    groupAlertNoData='<fmt:message key="group.alert.nodata"/>';
    sw = new hyperic.dashboard.summaryWidget(summaryKwArgs);   
</jsu:script>

<div class="effectsPortlet">
    <div class="widget" id="summaryWidget">
        <div class="widgetTitle">
            <h2 class="widgetHandle"><fmt:message key="dash.home.AlertSummary.Title"/></h2>
            <a href="<html:rewrite page="/dashboard/Admin.do?mode=alertSummary" />" title="<fmt:message key='dash.home.ConfigureWidget'/>" onblur="focusOff(this);" onfocus="focusOn(this);"><img src="<html:rewrite page="/images/4.0/icons/properties.gif" />" class="config_btn" width="16" height="16" border="0"/></a>
		    <a href="<html:rewrite page="/dashboard/Admin.do?mode=alertSummary" />" title="<fmt:message key='dash.home.RemoveWidget'/>" onblur="focusOff(this);" onfocus="focusOn(this);"><img src="<html:rewrite page="/images/4.0/icons/cross.gif" />" class="remove_btn" width="16" height="16" border="0"/></a>
		</div>
        <div class="loading">
            <fmt:message key="dash.home.loading"/><img src="<html:rewrite page="/images/4.0/icons/ajax-loader.gif" />" alt="">
        </div>
        <div class="error_loading">
            <fmt:message key="dash.home.AlertSummary.error.loading"/>
        </div>
        <div class="instructions">
        	<c:url var="path" value="/images/4.0/icons/properties.gif" />
            <fmt:message key="dash.home.AlertSummary.instructions">
            	<fmt:param value="${path}"/>
            </fmt:message>
        </div>
        <div class="content">
            <table width="100%">
                <tr>
                    <td width="50%" class="lcol">
                        <table border="0" cellspacing="0" cellpadding="4" style="border-collapse: collapse;">
                            <thead>
                                <tr class="head">
                                    <th><fmt:message key="portlet.galertsummary.groupname"/></th>
                                    <th><fmt:message key="portlet.galertsummary.resalerts"/></th>
                                    <th><fmt:message key="portlet.galertsummary.groupalerts"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr style="display: none;"><th scope="row"></th><td></td><td></td></tr>
                            </tbody>
                        </table>
                    </td>
                    <td width="50%" class="rcol">
                        <table border="0" cellspacing="0" cellpadding="4" style="border-collapse: collapse;">
                            <thead>
                                <tr class="head">
                                    <th><fmt:message key="portlet.galertsummary.groupname"/></th>
                                    <th><fmt:message key="portlet.galertsummary.resalerts"/></th>
                                    <th><fmt:message key="portlet.galertsummary.groupalerts"/></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr style="display: none;"><th scope="row"></th><td></td><td></td></tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </table>
            <div class="last_updated"></div>
        </div>
        <div class="config">
            <form method="POST" action="" style="margin: 0px;">
                <fieldset style="margin: 0px;">
                    <legend><fmt:message key="dash.home.AlertSummary.Title"/> <fmt:message key="dash.home.configure.Title"/></legend>
                    <table width="480" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td colspan="3" style="text-align: center;">
                                    <input type="text" id="groupsearch" name="groupsearch" value="[ <fmt:message key='dash.home.AlertSummary.configure.searchGroup'/> ]">
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right;">
                                    <label for="available_alert_groups"><fmt:message key="dash.home.AlertSummary.configure.availGroup"/></label> <br>
                                    <select name="available_alert_groups" id="available_alert_groups" size="10" multiple="multiple"></select>
                                </td>
                                <td style="text-align: center; width: 50px">
                                    <img src="<html:rewrite page="/images/4.0/buttons/arrow_select.gif" />" title="<fmt:message key='dash.home.AlertSummary.configure.select'/>" class="enable_alert_btn"><br/>
                                    <img src="<html:rewrite page="/images/4.0/buttons/arrow_deselect.gif" />" title="<fmt:message key='dash.home.AlertSummary.configure.deselect'/>" class="disable_alert_btn">
                                </td>
                                <td style="text-align: left;">
                                    <label for="enabled_alert_groups"><fmt:message key="dash.home.AlertSummary.configure.enbaledGroup"/></label> <br>
                                    <select name="enabled_alert_groups" id="enabled_alert_groups" size="10" multiple="multiple"></select>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" style="text-align: right;">
                                    <input type="submit" value="<fmt:message key="common.label.Save"/>" class="save_btn">
                                    <input type="submit" value="<fmt:message key="common.label.Cancel"/>" class="cancel_btn">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </fieldset>
            </form>
        </div>
    </div>
</div>