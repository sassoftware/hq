<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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

<div class="effectsPortlet">
<tiles:insert definition=".header.tab">
  <tiles:put name="tabKey" value="dash.home.RecentlyApproved"/>
  <tiles:put name="adminUrl" beanName="adminUrl" />
  <tiles:put name="portletName" beanName="portletName" />
</tiles:insert>

<tiles:importAttribute name="recentlyAdded"/>

<c:choose >
  <c:when test="${not empty recentlyAdded}">
    <table width="100%" cellpadding="0" cellspacing="0" border="0" class="portletLRBorder">
      <tr>
        <td width="70%" class="ListHeaderInactive"><fmt:message key="dash.home.TableHeader.ResourceName"/></td>
        <td width="30%" class="ListHeaderInactive" align="center"><fmt:message key="dash.home.TableHeader.TimeSinceApproved"/></td>
      </tr>
      <c:forEach items="${recentlyAdded}" var="platform">
      <tr class="ListRow">
        <td class="ListCell">
            <html:link action="/Resource">
            	<html:param name="eid" value="1:${platform.id}"/>
            	<c:out value="${platform.name}"/>&nbsp;
            </html:link>
        </td>
        <td class="ListCell" align="center">
        <c:set var="formattedTime">
        <hq:dateFormatter time="true" approx="true" value="${current - platform.CTime}"/>
        </c:set>
        <c:set var="myformattedTime">
                   
        </c:set>
        
        <c:choose>
                  <c:when test="${fn:endsWith(formattedTime, 'year')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'year', '')} <fmt:message key='dash.recentlyApproved.time.year' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'years')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'years', '')} <fmt:message key='dash.recentlyApproved.time.years' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'day')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'day', '')} <fmt:message key='dash.recentlyApproved.time.day' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'days')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'days', '')} <fmt:message key='dash.recentlyApproved.time.days' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'hour')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'hour', '')} <fmt:message key='dash.recentlyApproved.time.hour' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'hours')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'hours', '')} <fmt:message key='dash.recentlyApproved.time.hours' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'minute')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'minute', '')} <fmt:message key='dash.recentlyApproved.time.minute' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'minutes')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'minutes', '')} <fmt:message key='dash.recentlyApproved.time.minutes' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'second')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'second', '')} <fmt:message key='dash.recentlyApproved.time.second' />
                     </c:set>
                  </c:when>
                  <c:when test="${fn:endsWith(formattedTime, 'seconds')}">
                     <c:set var="myformattedTime">
                        ${fn:replace(formattedTime, 'seconds', '')} <fmt:message key='dash.recentlyApproved.time.seconds' />
                     </c:set>
                  </c:when>        
                  </c:choose>
                  
                  ${myformattedTime}
                              
                  
                  
        </td>
      </tr>
      </c:forEach> <!-- For each platform -->
    </table>
  </c:when>
  <c:otherwise>
    <table width="100%" cellpadding="0" cellspacing="0" border="0" class="portletLRBorder">
      <tr class="ListRow">
        <td class="ListCell"><fmt:message key="dash.home.no.resource.to.display"/></td>
      </tr>
    </table>
  </c:otherwise>
</c:choose>
</div>
