<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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

<c:set var="portletErrorMessage">
	<html:errors property="org.apache.struts.action.GLOBAL_MESSAGE"/>
</c:set>

<c:if test="${empty portletErrorMessage}"> 
	<c:set var="portletErrorMessage">
		<html:errors/>
	</c:set>
</c:if>
<%
  Object obj = pageContext.getAttribute("portletErrorMessage");
  if(obj instanceof String){
   String pem = (String)obj;
   if(pem!=null){
     pem = pem.trim();
     String start = "Could not remove \"";
     String end = "\" because a downtime schedule exists.";
       if(pem.startsWith(start) && pem.endsWith(end)){
        String middleText = pem.replaceAll(start,"");
        middleText = middleText.replaceAll(end,"");
        String msg = java.util.ResourceBundle.getBundle("org.hyperic.hq.bizapp.Resources",request.getLocale()).getString("resource.groups.remove.error.downtime.exists");
        msg = java.text.MessageFormat.format(msg,new String[] { middleText });
        pageContext.setAttribute("portletErrorMessage",msg );      
       }
    
   }
   
  }
   
%>
<c:if test="${not empty portletErrorMessage}"> 
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="ErrorBlock"><html:img page="/images/tt_error.gif" width="10" height="11" alt="" border="0"/></td>
    <td class="ErrorBlock" width="100%"><c:out value="${portletErrorMessage}" escapeXml="false"/></td>
  </tr>
</table>
</c:if>