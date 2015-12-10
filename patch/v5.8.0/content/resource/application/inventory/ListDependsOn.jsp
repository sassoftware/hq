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


<form name="dependsOnForm">
<!--  DEPENDS ON TITLE -->
<tiles:insert definition=".header.tab">
	<tiles:put name="tabKey" value="\"www.hyperic.com\" resource.application.DependsOnTab"/>
</tiles:insert>
<!--  /  -->



<!--  DEPENDS ON CONTENTS -->
<div id="listDiv">
	<table width="100%" cellpadding="0" cellspacing="0" border="0" id="listTable">
		<tr>
			<td width="1%" class="ListHeaderCheckbox"><input type="checkbox" onclick="ToggleAll(this, widgetProperties)" name="listToggleAll"></td>
			<td width="10%" class="ListHeaderInactive"><div align="center"><fmt:message key="resource.application.DependenciesTH"/></div></td>
			<td width="30%" class="ListHeaderSorted"><html:link href="#" title="Click to sort by this Attribute" styleClass="ListHeaderLink"><fmt:message key="resource.application.ServiceTH"/></html:link> <html:link href="#"><html:img page="/images/tb_sortup.gif" width="9" height="9" border="0"/></html:link></td>
			<td width="30%" class="ListHeader"><html:link href="#" title="Click to sort by this Attribute" styleClass="ListHeaderLink"><fmt:message key="resource.application.TypeTH"/></html:link></td>
			<td width="30%" class="ListHeader"><html:link href="#" title="Click to sort by this Attribute" styleClass="ListHeaderLink"><fmt:message key="resource.application.HostServerTH"/></html:link></td>
		</tr>
		<tr class="ListRow">
			<td class="ListCellCheckbox"><input type="checkbox" onclick="ToggleSelection(this, widgetProperties)" name="" class="listMember"></td>
			<td class="ListCell" align="center"><fmt:message key="button.view"/></td>
			<td class="ListCell"><html:link href="#">SomeWebApp</html:link></td>
			<td class="ListCell">Web Application</td>
			<td class="ListCell"><html:link href="#">WS_0045</html:link></td>
		</tr>
		<tr class="ListRow">
			<td class="ListCellCheckbox"><input type="checkbox" onclick="ToggleSelection(this, widgetProperties)" name="" class="listMember"></td>
			<td class="ListCell" align="center"><fmt:message key="button.view"/></td>
			<td class="ListCell"><html:link href="#">SomeWebApp</html:link></td>
			<td class="ListCell">Web Application</td>
			<td class="ListCell"><html:link href="#">WS_0045</html:link></td>
		</tr>
	</table>
</div>
<!--  /  -->

<tiles:insert page="/common/components/AddToListToolbar.jsp"/>
</form>
