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


<tiles:importAttribute name="selectedIndex" ignore="true"/>
<tiles:importAttribute name="appdefResourceType" ignore="true"/>
<tiles:importAttribute name="entityType" ignore="true"/>

<tiles:importAttribute name="tabListName" ignore="true"/>
<c:choose>
  <c:when test="${'perf' == tabListName}">
    <tiles:useAttribute id="tabList" name="perf" ignore="true"/>
  </c:when>
  <c:when test="${'nometrics' == tabListName}">
    <tiles:useAttribute id="tabList" name="nometrics" ignore="true"/>
  </c:when>
  <c:otherwise>
    <tiles:useAttribute id="tabList" name="standard" ignore="true"/>
  </c:otherwise>
</c:choose>

<c:if test="${not empty tabList}">
  <tiles:importAttribute name="entityIds" ignore="true"/>
  <tiles:importAttribute name="autogroupResourceType" ignore="true"/>
  <%-- 
    backwards compatibility to support linking with the old
    style, i.e. with the "rid" and "type" parameters
  --%>
  <c:if test="${empty entityIds}">
    <tiles:importAttribute name="resourceId" ignore="true"/>
    <tiles:importAttribute name="resourceType" ignore="true"/>
  </c:if>
</c:if>
<tiles:importAttribute name="subTabList" ignore="true"/>
<c:if test="${not empty subTabList}">
  <tiles:importAttribute name="subTabUrl"/>
</c:if>

<c:if test="${empty selectedIndex}">
  <c:set var="selectedIndex" value="0"/>
</c:if>

<!-- MINI-TABS -->

<table border="0" cellspacing="0" cellpadding="0"  class="SASTableTab">
  <tr>
<c:forEach var="tab" items="${tabList}">
    
  <c:choose>
    <c:when test="${not empty tab.icon}">
      <fmt:message var="tabText" key="${tab.icon}"/>
    </c:when>
    <c:otherwise>
      <c:set var="tabText" value="${tab.name}"/>
    </c:otherwise>
  </c:choose>

  <c:choose>
    <c:when test="${tab.value == selectedIndex}">
      <!-- Table cell tags have to be right next to image, otherwise IE creates
           a space -->
      <td><span><fmt:message key="resource.common.tabs.${tab.icon}"/></span></td>
    </c:when>
    <c:otherwise>
      <c:url var="tabLink" value="/resource/${entityType}/monitor/Visibility.do">
        <c:choose>
          <c:when test="${not empty tab.mode}">
            <c:param name="mode" value="${tab.mode}"/>
          </c:when>
          <c:otherwise>
            <c:param name="mode" value="currentHealth"/>
          </c:otherwise>
        </c:choose>
        <c:choose>
          <c:when test="${not empty entityIds}">
            <c:forEach var="eid" items="${entityIds}">
              <c:param name="eid" value="${eid}"/>
            </c:forEach>
          </c:when>
          <c:otherwise>
             <c:if test="${not empty resourceId and not empty resourceType}">
               <c:param name="eid" value="${resourceType}:${resourceId}"/>
             </c:if>
          </c:otherwise>
        </c:choose>
        <c:if test="${not empty autogroupResourceType}">
          <%-- we should be using autogroup for all autogroups.  We are only fixing
               the application autogroups for 1.0.3 release.
          --%>
          <!-- AppdefEntityConstants.APPDEF_TYPE_APPLICATION-->
          <c:choose>
            <c:when test="${not empty appdefResourceType && appdefResourceType == 4}"> 
              <c:param name="autogrouptype" value="${autogroupResourceType}"/>
            </c:when>
            <c:otherwise>
	          <c:param name="ctype" value="${autogroupResourceType}"/>
            </c:otherwise>
          </c:choose>
        </c:if>
      </c:url>
      <td><a href="${tabLink}"><span><fmt:message key="resource.common.tabs.${tab.icon}"/></span></a></td>
    </c:otherwise>
  </c:choose>
</c:forEach>
  </tr>
</table>
<!-- / MINI-TABS -->
