<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
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

<jsu:script>
	searchResstr = '<fmt:message key='resource.group.platform.search.keywords'/>';
</jsu:script>
<tiles:importAttribute name="resource" ignore="true"/>
<tiles:importAttribute name="NetworkServer" ignore="true"/>
<tiles:importAttribute name="FileServer" ignore="true"/>
<tiles:importAttribute name="WindowsServer" ignore="true"/>
<tiles:importAttribute name="ProcessServer" ignore="true"/>

<c:if test="${not empty resource}">

<hq:userResourcePermissions debug="false" resource="${Resource}"/>

<table border="0"><tr><td class="LinkBox">
    <c:if test="${canModify}">
            <html:link action="/resource/platform/Inventory">
            	<html:param name="mode" value="editConfig"/>
            	<html:param name="eid" value="${resource.entityId}"/>
            	<fmt:message key="resource.platform.inventory.link.Configure"/>
            	<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
            </html:link><br/>
    </c:if>
    <tiles:insert definition=".resource.common.quickDelete">
      <tiles:put name="resource" beanName="resource"/>
	  <tiles:put name="deleteMessage">
		<fmt:message key="resource.platform.inventory.link.DeletePlatform"/>
	  </tiles:put>
    </tiles:insert>
	<br>
    <c:choose>
        <c:when test="${canCreateChild}" >
            <html:link action="/resource/server/Inventory">
            	<html:param name="mode" value="new"/>
            	<html:param name="eid" value="${resource.entityId}"/>
            	<fmt:message key="resource.platform.inventory.NewServerLink"/>
            	<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
            </html:link><br/>
            <html:link action="/resource/service/Inventory">
            	<html:param name="mode" value="new"/>
            	<html:param name="eid" value="${resource.entityId}"/>
            	<fmt:message key="resource.platform.inventory.NewServiceLink"/>
            	<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
            </html:link><br/>
        </c:when>
        <c:otherwise>
            <fmt:message key="resource.platform.inventory.NewServerLink"/><html:img page="/images/tbb_new_locked.gif" alt="" border="0"/><br>
            <fmt:message key="resource.platform.inventory.NewServiceLink"/><html:img page="/images/tbb_new_locked.gif" alt="" border="0"/><br>
        </c:otherwise>
    </c:choose>
    <c:choose>
        <c:when test="${canModify && canCreateChild}" >            
            <html:link action="/resource/platform/AutoDiscovery">
            	<html:param name="mode" value="new"/>
            	<html:param name="rid" value="${resource.id}"/>
            	<html:param name="type" value="${resource.entityId.type}"/>
            	<fmt:message key="resource.platform.inventory.NewDiscoveryLink"/>
            	<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/>
            </html:link><br/>
        </c:when>
        <c:otherwise>
            <fmt:message key="resource.platform.inventory.NewDiscoveryLink"/><html:img page="/images/tbb_new_locked.gif" alt="" border="0"/><br>
        </c:otherwise>
    </c:choose>
    <c:choose>
    	<c:when test="${canModify}">
    		<html:link action="/alerts/EnableAlerts">
    			<html:param name="alertState" value="enabled"/>
    			<html:param name="eid" value="${resource.entityId.type}:${resource.id}"/>
        		<fmt:message key="resource.platform.alerts.EnableAllAlerts"/>
        	</html:link>
        	<html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/><br>
    		<html:link action="/alerts/EnableAlerts">
    			<html:param name="alertState" value="disabled"/>
    			<html:param name="eid" value="${resource.entityId.type}:${resource.id}"/>
    	    	<fmt:message key="resource.platform.alerts.DisableAllAlerts"/>
    	    </html:link>
	        <html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/><br>
    	</c:when>
    	<c:otherwise>
    		<fmt:message key="resource.platform.alerts.EnableAllAlerts"/><html:img page="/images/tbb_new_locked.gif" alt="" border="0"/><br/>
    		<fmt:message key="resource.platform.alerts.DisableAllAlerts"/><html:img page="/images/tbb_new_locked.gif" alt="" border="0"/><br/>
    	</c:otherwise>
    </c:choose>
    <tiles:insert definition=".resource.common.quickFavorites">
      <tiles:put name="resource" beanName="resource"/>
    </tiles:insert>
	<br />
	<html:link page="#" styleId="AddToGroupMenuLink"><fmt:message key="resource.group.AddToGroup.Title"/><html:img page="/images/title_arrow.gif" width="11" height="9" alt="" border="0"/></html:link>
</td></tr></table>

<jsu:script>
    hqDojo.require("dijit.dijit");
    hqDojo.require("dijit.form.Button");
    hqDojo.require("dijit.form.DateTextBox");
    hqDojo.require("dijit.form.TimeTextBox");
    hqDojo.require("dijit.Dialog");

</jsu:script>
<tiles:insert definition=".resource.common.addToGroup">
	<tiles:put name="resource" beanName="resource"/>
</tiles:insert>

<tiles:insert definition=".resource.common.scheduleDowntime">
	<tiles:put name="resource" beanName="resource"/>
</tiles:insert>

</c:if>
