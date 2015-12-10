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
<c:set var="location" scope="request"><tiles:getAsString name="location"/></c:set>
  <c:choose>
  <c:when test="${location eq 'resources'}">
    <c:forEach var="attachment" items="${mastheadResourceAttachments}">
       <li><a href="<html:rewrite page="/mastheadAttach.do?typeId=${attachment.attachment.id}"/>"><c:out value="${attachment.HTML}"/></a></li>	   
    </c:forEach>
  </c:when>
  <c:when test="${location eq 'tracking'}">
    <!-- 
    <c:if test="${useroperations['administerCAM']}">
       <li><a href="<html:rewrite page="/reporting/ReportCenter.do"/>"><fmt:message key="header.reporting"/></a></li>
    </c:if>
    -->
    <c:forEach var="attachment" items="${mastheadTrackerAttachments}">
       <li><a href="<html:rewrite page="/mastheadAttach.do?typeId=${attachment.attachment.id}"/>"><c:out value="${attachment.HTML}"/></a></li>
    </c:forEach>
  </c:when>
    <c:when test="${location eq 'sas'}">
        <c:if test="${empty sasMap}">
  	    <%@page import="java.io.InputStream" %> 
  	    <%@page import="java.util.Properties" %> 
  	    <%@page import="java.util.HashMap" %> 
  	    <%@page import="java.util.Map" %> 
  	    <% 
  		InputStream stream = application.getResourceAsStream("/sas/sas.properties"); 
  		Properties props = new Properties(); 
  		props.load(stream); 
  		Map<String, String> sasMap = new HashMap<String, String>((Map) props);
  	    %>
  	    <c:set var="sasMap" scope="session" value="<%=sasMap%>"/>
  	</c:if>
  	<c:forEach var="item" items="${sasMap}">
  	     <li><a href="${item.value}"><fmt:message key="${item.key}"/></a></li>
  	</c:forEach>
    </c:when>

  </c:choose>
