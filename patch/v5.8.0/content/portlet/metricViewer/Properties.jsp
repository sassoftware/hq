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
	<c:param name="mode" value="metricViewer"/>
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
			
			for (i = 0; i < field.form.elements.length; i++) {
				if (field == field.form.elements[i]) break;
			}
			
			return false;
		}
		
		return true;
	}

	function selectValidOption() {
    	var sels = document.getElementsByTagName('select');
    
    	for (var i=0; i < sels.length; i++) {
      		while (sels[i].options[sels[i].selectedIndex].value == "-1") {
        		sels[i].selectedIndex++;
      		}
    	}
	}

	function submitMetricViewerForm() {
    	selectValidOption();
    	MetricViewerForm.submit();
	}
</jsu:script>
<jsu:script onLoad="true">
	selectValidOption();
</jsu:script>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="PageTitle">
    <td rowspan="99"><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
    <td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
    <td width="35%" class="PageTitle" nowrap><fmt:message key="dash.home.MetricViewer.Title"/></td>
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
      <html:form action="/dashboard/ModifyMetricViewer" >

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
          <td class="BlockLabel" valign="center"><fmt:message key="dash.settings.metricViewer.range"/></td>
             <td class="BlockContent" colspan="3" valign="center">
                 
                 <c:choose>
                     <c:when test="${not sessionScope.modifyDashboard}">
                         <c:out value="${MetricViewerForm.numberToShow}"/>
                     </c:when>
                     <c:otherwise>
                         <html:select property="numberToShow">
                             <html:option value="5"/>
                             <html:option value="10"/>
                             <html:option value="20"/>
                             <html:option value="30"/>
                         </html:select>
                     </c:otherwise>
                 </c:choose>
                 
             </td>
        </tr>
        <tr valign="top">
          <td width="20%" class="BlockLabel" valign="center"><fmt:message key="dash.settings.FormLabel.ResourceType"/></td>
            <td width="80%" class="BlockContent" colspan="3" valign="center">
                <c:choose>
                    <c:when test="${not sessionScope.modifyDashboard}">
                        <c:out value="${MetricViewerForm.resourceType}"/>
                    </c:when>
                    <c:otherwise>
                        <html:select property="resourceType" onchange="submitMetricViewerForm()">
                            <html:option value="-1" disabled="true">
                                <fmt:message key="dash.settings.metricViewer.selectResourceType"/>
                            </html:option>
                            <html:option value="-1" disabled="true">
                                <fmt:message key="dash.settings.metricViewer.platformTypes"/>
                            </html:option>
                            <c:forEach var="type" items="${platformTypes}">
                                <html:option value="${type.appdefTypeKey}"> -
                                    <c:out value="${type.name}"/>
                                </html:option>
                            </c:forEach>
                            <html:option value="-1" disabled="true">&nbsp;</html:option>
                            <html:option value="-1" disabled="true">
                                <fmt:message key="dash.settings.metricViewer.serverTypes"/>
                            </html:option>
                            <c:forEach var="type" items="${serverTypes}">
                                <html:option value="${type.appdefTypeKey}"> -
                                    <c:out value="${type.name}"/>
                                </html:option>
                            </c:forEach>
                            <html:option value="-1" disabled="true">&nbsp;</html:option>
                            <html:option value="-1" disabled="true">
                                <fmt:message key="dash.settings.metricViewer.serviceTypes"/>
                            </html:option>
                            <c:forEach var="type" items="${serviceTypes}">
                                <html:option value="${type.appdefTypeKey}"> -
                                    <c:out value="${type.name}"/>
                                </html:option>
                            </c:forEach>
                        </html:select>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr valign="top">
          <td width="20%" class="BlockLabel" valign="center"><fmt:message key="dash.settings.FormLabel.Metric"/></td>
          <td width="80%" class="BlockContent" colspan="3" valign="center">
              <c:choose>
                  <c:when test="${not sessionScope.modifyDashboard}">
                      <c:out value="${MetricViewerForm.metric}"/>
                  </c:when>
                  <c:otherwise>
                      <html:select property="metric" onchange="submitMetricViewerForm()">
                          <html:option value="-1" disabled="true">
                              <fmt:message key="dash.settings.metricViewer.selectMetric"/>
                          </html:option>
                          <c:forEach var="metric" items="${metrics}">
                              <c:if test="${metric.defaultOn}">
                                  <html:option value="${metric.id}"> -
                                      <c:out value="${metric.name}"/>
                                  </html:option>
                              </c:if>
                          </c:forEach>
                      </html:select>
                  </c:otherwise>
              </c:choose>
          </td>
        </tr>
        <tr valign="top">
            <td width="20%" class="BlockLabel" valign="center"><fmt:message key="dash.settings.FormLabel.SortOrder"/></td>
            <td width="80%" class="BlockContent" colspan="3" valign="center">
                <c:choose>
                    <c:when test="${not sessionScope.modifyDashboard}">
                        <c:choose>
                        <c:when test="${MetricViewerForm.descending}">
                            <fmt:message key="dash.settings.metricViewer.descending"/>
                        </c:when>
                        <c:otherwise>
                            <fmt:message key="dash.settings.metricViewer.ascending"/>
                        </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <html:select property="descending">
                            <html:option value="true">
                                <fmt:message key="dash.settings.metricViewer.descending"/>
                            </html:option>
                            <html:option value="false">
                                <fmt:message key="dash.settings.metricViewer.ascending"/>
                            </html:option>
                        </html:select>
                    </c:otherwise>
                </c:choose>
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
                     pageSize="${pageSize}" items="${metricViewerList}" var="resource"  >

        <display:column width="1%" property="id" title="<input type=\"checkbox\" onclick=\"ToggleAll(this, widgetProperties, true)\" name=\"listToggleAll\">"  isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox">
          <display:checkboxdecorator name="ids" value="${resource.entityId.type}:${resource.id}" onclick="ToggleSelection(this, widgetProperties, true)" styleClass="listMember"/>
        </display:column>

        <display:column width="50%" property="name" sort="true" sortAttr="7"
                  defaultSort="true" title="dash.settings.ListHeader.Resource" />

        <display:column width="50%" property="description"
                        title="common.header.Description" />

      </display:table>


      <c:url var="addToListUrl" value="/Admin.do" context="/dashboard">
          <c:param name="mode" value="metricViewerAddResources"/>
          <c:if test="${not empty MetricViewerForm.token}">
            <c:param name="key" value=".dashContent.metricviewer.resources${MetricViewerForm.token}"/>
            <c:param name="token" value="${MetricViewerForm.token}"/>
          </c:if>
          <c:if test="${empty MetricViewerForm.token}">
            <c:param name="key" value=".dashContent.metricviewer.resources"/>
          </c:if>
          <c:param name="ff" value="${MetricViewerForm.appdefType}"/>
          <c:param name="ft" value="${MetricViewerForm.appdefTypeID}"/>
      </c:url>
      <c:choose>
          <c:when test="${not sessionScope.modifyDashboard}">
           
          </c:when>
          <c:otherwise>
              <tiles:insert definition=".toolbar.addToList">
                  <tiles:put name="addToListUrl" beanName="addToListUrl"/>
                  <tiles:put name="listItems" beanName="metricViewerList"/>
                  <tiles:put name="listSize" beanName="metricViewerList" beanProperty="totalSize"/>
                  <tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
                  <tiles:put name="pageSizeAction" beanName="selfAction"/>
                  <tiles:put name="pageNumAction" beanName="selfAction"/>
                  <tiles:put name="defaultSortColumn" value="1"/>
              </tiles:insert>
          </c:otherwise>
      </c:choose>
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

