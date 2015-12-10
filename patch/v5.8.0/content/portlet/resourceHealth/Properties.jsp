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
    <c:param name="mode" value="resourceHealth"/>
</c:url>
<script  src="<html:rewrite page="/js/prototype.js"/>" type="text/javascript"></script>
<script  src="<html:rewrite page="/js/scriptaculous.js"/>" type="text/javascript"></script>
<script  src="<html:rewrite page="/js/listWidget.js"/>" type="text/javascript"></script>
<jsu:script>
    var pageData = new Array();
    initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
    widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');  
    var help = '<hq:help/>';
</jsu:script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="PageTitle"> 
    <td rowspan="99"><html:img page="/images/spacer.gif" width="5" height="1" alt="" border="0"/></td>
    <td><html:img page="/images/spacer.gif" width="15" height="1" alt="" border="0"/></td>
    <td width="67%" class="PortletTitle" nowrap><fmt:message key="dash.home.ResourceHealth.Settings.Title"/></td>
    <td width="32%"><html:img page="/images/spacer.gif" width="2" height="32" alt="" border="0"/></td>
    <td width="1%"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
  </tr>
  <tr> 
    <td valign="top" align="left" rowspan="99"></td>
    <td colspan="3"><html:img page="/images/spacer.gif" width="1" height="10" alt="" border="0"/></td>
  </tr>
  <tr valign="top"> 
    <td colspan="2">
      <html:form action="/dashboard/ModifyResourceHealth" onsubmit="ResourceHealthForm.order.value=Sortable.serialize('resOrd')">
<div id="narrowlist_false">
      <tiles:insert definition=".header.tab">
        <tiles:put name="tabKey" value="dash.settings.SelectedResources"/>
      </tiles:insert>
</div>
    <table class="table" class="table" width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr class="tableRowHeader">
    <th width="1%" class="ListHeaderCheckbox">
        <c:choose>
        <c:when test="${not sessionScope.modifyDashboard}">
            <input type="checkbox" onclick="ToggleAll(this, widgetProperties, true)" name="listToggleAll" disabled="true">
        </c:when>
        <c:otherwise>
            <input type="checkbox" onclick="ToggleAll(this, widgetProperties, true)" name="listToggleAll">
        </c:otherwise>
        </c:choose>
    </th>
    <th class="tableRowInactive"><fmt:message key="dash.settings.ListHeader.Resource"/></th>
    </tr></table>

      <ul id="resOrd" class="boxy" >
      <c:forEach var="resource" items="${resourceHealthList}">
        <li class="tableCell" id="<c:out value="item_${resource.entityId}"/>">
        <span>
        <html:checkbox onclick="ToggleSelection(this, widgetProperties, true)" styleClass="listMember" property="ids" value="${resource.entityId}" disabled="${not sessionScope.modifyDashboard}"/>
        <c:out value="${resource.name}"/>
        <c:if test="${not empty resource.description}">
          <fmt:message key="parenthesis">
            <fmt:param>
                <c:out value="${resource.description}"/>
            </fmt:param>
          </fmt:message>
        </c:if></span>
        </li>
      </c:forEach>
      </ul>
      <script type="text/javascript">
        Sortable.create("resOrd",
          {dropOnEmpty:true,containment:["resOrd"],constraint:'vertical'});   
      </script>
        <c:choose>
              <c:when test="${not sessionScope.modifyDashboard}">
               
              </c:when>
              <c:otherwise>
                  <tiles:insert definition=".toolbar.addToList">
                      <tiles:put name="addToListUrl"
                                 value="/dashboard/Admin.do?mode=resourceHealthAddResources&key=.dashContent.resourcehealth.resources"/>
                      <tiles:put name="listItems" beanName="resourceHealthList"/>
                      <tiles:put name="listSize" beanName="resourceHealthList" beanProperty="totalSize"/>
                      <tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
                      <tiles:put name="showPagingControls" value="false"/>
                      <tiles:put name="pageSizeAction" beanName="selfAction"/>
                      <tiles:put name="pageNumAction" beanName="selfAction"/>
                      <tiles:put name="defaultSortColumn" value="1"/>
                  </tiles:insert>
              </c:otherwise>
          </c:choose>
      <html:hidden property="order"/>
      <tiles:insert definition=".form.buttons">
        <tiles:put name="noCancel" value="true"/>
        <tiles:put name="noReset" value="true"/>
      </tiles:insert>
      </html:form>

    </td>
  </tr>
  <tr> 
    <td colspan="3"><html:img page="/images/spacer.gif" width="1" height="13" alt="" border="0"/></td>
  </tr>
</table>
