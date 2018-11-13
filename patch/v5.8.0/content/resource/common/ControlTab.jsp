<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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


<%-- 
  Tabs Layout tile component.
  This layout allows to render several tiles in a tabs fashion.

  @see org.apache.struts.tiles.beans.MenuItem A value object class that holds name and urls.
  
  @param tabList       A list of available tabs. We use MenuItem as a value object to
		       carry data (name, body, icon, ...)
  @param subTabList    A list of available sub tabs. We use MenuItem as a value object to 
                       carry data (name, body, icon, ...)
  @param selectedIndex Index of default selected tab
--%>
<link rel="stylesheet" href="<html:rewrite page="/css/HQ_40.css"/>" type="text/css"/>

<tiles:useAttribute id="selectedIndexStr" name="selectedIndex" ignore="true" classname="java.lang.String" />
<tiles:useAttribute name="tabList" classname="java.util.List" />
<tiles:useAttribute name="subTabList" classname="java.util.List" ignore="true"/>
<tiles:useAttribute id="subSelectedIndexStr" name="subSelectedIndex" ignore="true"/>
<tiles:useAttribute name="subSectionName" ignore="true"/>
<tiles:useAttribute name="resourceId" ignore="true"/>
<tiles:useAttribute name="resourceType" ignore="true" />
<tiles:useAttribute name="autogroupResourceId" ignore="true" />
<tiles:useAttribute name="autogroupResourceType" ignore="true" />
<tiles:importAttribute name="entityIds" ignore="true"/>

<c:if test="${not empty autogroupResourceId}"> 
   <tiles:insert definition=".resource.common.navmap"/>
</c:if>

<c:if test="${empty resourceType}">
 <c:set var="resourceType" value="${Resource.entityId.type}"/>
</c:if>
<table class="SASTableTab" id="SASTableTab">
 <tr>
  <c:forEach var="tab" varStatus="status" items="${tabList}">
    <c:choose>
     <c:when test="${status.index == selectedIndexStr}">
      <td><span><fmt:message key="resource.common.tabs.${tab.value}"/></span></td>
     </c:when>
     <c:otherwise>
      <c:url var="tabLink" value="${tab.link}">
        <c:choose>
          <c:when test="${not empty tab.mode}">
            <c:param name="mode" value="${tab.mode}"/>
          </c:when>
          <c:otherwise>
            <c:param name="mode" value="view"/>
          </c:otherwise>
        </c:choose>
        <c:param name="eid" value="${resourceType}:${resourceId}"/>
      </c:url>
      <td><a href="${tabLink}" onfocus="if(hqDojo.byId('toolMenu')&&hqDojo.byId('toolMenu').shown){toggleMenu('toolMenu');}"><span><fmt:message key="resource.common.tabs.${tab.value}"/></span></a></td>
     </c:otherwise>
    </c:choose>
  </c:forEach>
  </tr>
  <tr> 
  <c:choose>
  <c:when test="${subTabList != null && not empty subTabList}">
   <td colspan="7">
    <table  class="SASTableTab" id="SubTableTab" border="0" cellspacing="0" cellpadding="0">
     <tr>
<c:forEach var="tab" varStatus="status" items="${subTabList}">
  <c:choose>
    <c:when test="${status.index == subSelectedIndexStr}">
       <td><span><fmt:message key="resource.common.tabs.sub.${tab.value}"/></span></td>
    </c:when>
    <c:otherwise>
    <c:choose>
      <c:when test="${tab.visible}">
      <c:url var="tabLink" value="${tab.link}">
        <c:choose>
          <c:when test="${not empty tab.mode}">
            <c:param name="mode" value="${tab.mode}"/>
          </c:when>
          <c:otherwise>
            <c:param name="mode" value="view"/>
          </c:otherwise>
        </c:choose>
        <c:param name="rid" value="${resourceId}"/>
        <c:param name="type" value="${resourceType}"/>
        <c:if test="${not empty entityIds}">
          <c:forEach var="eid" items="${entityIds}">
            <c:param name="eid" value="${eid}"/>
          </c:forEach>
        </c:if>
        <c:if test="${not empty autogroupResourceType}"> 
          <c:param name="ctype" value="${autogroupResourceType}"/>
        </c:if>
      </c:url>
       <td><a href="${tabLink}"><span><fmt:message key="resource.common.tabs.sub.${tab.value}"/></span></a></td>
    </c:when>
    <c:otherwise>
    </c:otherwise>
    </c:choose>
    </c:otherwise>
  </c:choose>
</c:forEach>
     </tr>
    </table>
   </td>
  </c:when>
  <c:otherwise>
       <td colspan="7" class="SubTabCell" id="SubTabTarget"><html:img page="/images/spacer.gif" width="1" height="1" alt="" border="0"/></td>
  </c:otherwise>
  </c:choose>
  </tr>
 </table>

