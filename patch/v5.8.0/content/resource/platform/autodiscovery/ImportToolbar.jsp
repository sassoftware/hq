<%@ page language="java" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/replaceButton.jsp"%>
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


<!--  IMPORT TOOLBAR -->
<tiles:importAttribute name="ignoreFromImport" ignore="true"/>
<tiles:importAttribute name="includeInImport" ignore="true"/>

<table width="100%" cellpadding="5" cellspacing="0" border="0" class="ToolbarContent">
  <tr>
  <c:if test="${not empty ignoreFromImport}">
    <td><html:image property="ignoreForImport" page="/images/tbb_ignoreForImport.gif" /></td>
  </c:if>
  <c:if test="${not empty includeInImport}">
    <td width="100%"><html:image property="includeInImport" altKey="button.includeInImport" page="/images/tbb_includeInImport.gif" /></td>
  </c:if>
  </tr>
</table>
<!--  /  -->
