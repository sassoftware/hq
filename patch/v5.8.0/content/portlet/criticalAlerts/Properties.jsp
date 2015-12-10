<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
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


<hq:pageSize var="pageSize"/>

<c:set var="widgetInstanceName" value="resources"/>
<c:url var="selfAction" value="/dashboard/Admin.do">
	<c:param name="mode" value="criticalAlerts"/>
  	<c:if test="${not empty param.token}">
    	<c:param name="token" value="${param.token}"/>
  	</c:if>
</c:url>
<jsu:importScript path="/js/listWidget.js" />
<jsu:script>
	var pageData = new Array();
	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
	widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');  
	var help = '<hq:help/>';

	/***********************************************/
	/* Disable "Enter" key in Form script- By Nurul Fadilah(nurul@REMOVETHISvolmedia.com)
	/* This notice must stay intact for use
	/* Visit http://www.dynamicdrive.com/ for full source code
	/***********************************************/
	
	function handleEnter (field, event) {
			var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
			if (keyCode == 13) {
				var i;
				for (i = 0; i < field.form.elements.length; i++)
					if (field == field.form.elements[i])
						break;
				//i = (i + 1) % field.form.elements.length;
				//field.form.elements[i].focus();
				return false;
			}
			else
			return true;
		}
</jsu:script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="PageTitle"> 
    <td rowspan="99"><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
    <td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
    <td width="35%" class="PageTitle" nowrap><fmt:message key="dash.home.RecentAlerts.Title"/></td>
    <td width="32%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
    <td width="32%"><html:img page="/images/spacer.gif" width="202" height="32" alt="" border="0"/></td>
    <td width="1%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
  </tr>
  <tr> 
    <td valign="top" align="left" rowspan="99"></td>
    <td ><html:img page="/images/spacer.gif" width="1" height="10" alt="" border="0"/></td>
  </tr>
  <tr valign="top"> 
    <td colspan='3'>
      <html:form action="/dashboard/ModifyCriticalAlerts" >

      <tiles:insert definition=".header.tab">
        <tiles:put name="tabKey" value="dash.settings.DisplaySettings"/>
      </tiles:insert>

      <tiles:insert definition=".dashContent.admin.generalSettings">
        <tiles:put name="portletName" beanName="portletName" />
      </tiles:insert>
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td colspan="4" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
         <tr valign="top">
          <td width="20%" class="BlockLabel" valign="center"><fmt:message key="common.label.Description"/></td>
          <td width="80%" class="BlockContent" colspan="3" valign="center">
              <html:text property="title" maxlength="50" onkeypress="return handleEnter(this, event);" disabled="${not sessionScope.modifyDashboard}"/>
          </td>
        </tr>
         <tr valign="top">
          <td class="BlockLabel" valign="center"><fmt:message key="dash.settings.criticalAlerts.number"/></td>
             <td class="BlockContent" colspan="3" valign="center">               
                 <html:select property="numberOfAlerts" disabled="${not sessionScope.modifyDashboard}">
                     <html:option value="5"/>
                     <html:option value="10"/>
                     <html:option value="20"/>
                     <html:option value="30"/>
                 </html:select>
             </td>
        </tr>
		<tr valign="top">
			<td class="BlockLabel" valign="center"><fmt:message key="dash.settings.criticalAlerts.priority"/></td>
             <td class="BlockContent" colspan="3" valign="center">                 
                 <html:select property="priority" disabled="${not sessionScope.modifyDashboard}">
                     <html:option value="3"><fmt:message key="alert.config.props.PB.Priority.3"/></html:option>
                     <html:option value="2"><fmt:message key="alert.config.props.PB.Priority.2"/></html:option>
                     <html:option value="1"><fmt:message key="alert.config.props.PB.Priority.1"/></html:option>
                     <html:option value="0"><fmt:message key="dash.settings.auto-disc.all"/></html:option>
                 </html:select>
             </td>
		</tr>
		<tr valign="top">
			<td class="BlockLabel" valign="center"><fmt:message key="dash.settings.criticalAlerts.timePeriod"/></td>
             <td class="BlockContent" colspan="3" valign="center">                 
                 <html:select property="past" disabled="${not sessionScope.modifyDashboard}">
                     <html:option value="1800000">30
                         <fmt:message key="admin.settings.Minutes"/>
                     </html:option>
                     <html:option value="3600000">1
                         <fmt:message key="admin.settings.Hour"/>
                     </html:option>
                     <html:option value="43200000">12
                         <fmt:message key="admin.settings.Hours"/>
                     </html:option>
                     <html:option value="86400000">1
                         <fmt:message key="admin.settings.Day"/>
                     </html:option>
                     <html:option value="604800000">1
                         <fmt:message key="admin.settings.Week"/>
                     </html:option>
                     <html:option value="2419200000">1
                         <fmt:message key="admin.settings.Month"/>
                     </html:option>
                 </html:select>
             </td>
		</tr>
		<tr valign="top">
			<td class="BlockLabel" valign="center"><fmt:message key="dash.settings.criticalAlerts.resources"/></td>
             <td class="BlockContent" colspan="3" valign="center">                 
                 <html:select property="selectedOrAll" disabled="${not sessionScope.modifyDashboard}">
                     <html:option value="selected"><fmt:message key="dash.settings.criticalAlerts.resource.selected"/></html:option>
                     <html:option value="all"><fmt:message key="dash.settings.criticalAlerts.resource.all"/></html:option>
                 </html:select>
             </td>
		</tr>
        <tr>
          <td colspan="4" class="BlockContent"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
        <tr>
          <td colspan="4" class="BlockBottomLine"><html:img page="/images/spacer.gif" width="1" height="1" border="0"/></td>
        </tr>
      </table>
      &nbsp;<br>
      <tiles:insert definition=".header.tab">
        <tiles:put name="tabKey" value="dash.settings.SelectedResources"/>
      </tiles:insert>

      <display:table cellspacing="0" cellpadding="0" width="100%" action="${selfAction}"
                     pageSize="${pageSize}" items="${criticalAlertsList}" var="resource"  >

        <display:column width="1%" property="id" title="<input type=\"checkbox\" onclick=\"ToggleAll(this, widgetProperties, true)\" name=\"listToggleAll\">"  isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox">          
          <display:checkboxdecorator name="ids" value="${resource.entityId.type}:${resource.id}" onclick="ToggleSelection(this, widgetProperties, true)" styleClass="listMember"/>
        </display:column>
      
        <display:column width="50%" property="name" sort="true" sortAttr="7"
                  defaultSort="true" title="dash.settings.ListHeader.Resource" /> 

        <display:column width="50%" property="description"
                        title="common.header.Description" /> 

      </display:table>

      <c:choose>
        <c:when test="${not empty CriticalAlertsForm.token}">
          <c:url var="addToListUrl" value="/dashboard/Admin.do">
          	<c:param name="mode" value="criticalAlertsAddResources"/>
          	<c:param name="key" value=".dashContent.criticalalerts.resources${CriticalAlertsForm.token}"/>
          	<c:param name="token" value="${CriticalAlertsForm.token}"/>
          </c:url> 
        </c:when>
        <c:otherwise>
          <c:url var="addToListUrl" value="/dashboard/Admin.do">
          	<c:param name="mode" value="criticalAlertsAddResources"/>
          	<c:param name="key" value=".dashContent.criticalalerts.resources"/>
          </c:url> 
        </c:otherwise>
      </c:choose>
      <c:if test="${sessionScope.modifyDashboard}">
          <tiles:insert definition=".toolbar.addToList">
              <tiles:put name="addToListUrl" beanName="addToListUrl"/>
              <tiles:put name="listItems" beanName="criticalAlertsList"/>
              <tiles:put name="listSize" beanName="criticalAlertsList" beanProperty="totalSize"/>
              <tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
              <tiles:put name="pageSizeAction" beanName="selfAction"/>
              <tiles:put name="pageNumAction" beanName="selfAction"/>
              <tiles:put name="defaultSortColumn" value="1"/>
          </tiles:insert>
      </c:if>
	  <tiles:insert definition=".form.buttons">
		 <c:if test='${not sessionScope.modifyDashboard}'>
		   <tiles:put name="cancelOnly" value="true"/>
        <tiles:put name="noReset" value="true"/>
		 </c:if>
	  </tiles:insert>
      <html:hidden property="token"/>
      </html:form>
      
    </td>
  </tr>
  <tr> 
    <td colspan="4"><html:img page="/images/spacer.gif" width="1" height="13" alt="" border="0"/></td>
  </tr>
</table>

