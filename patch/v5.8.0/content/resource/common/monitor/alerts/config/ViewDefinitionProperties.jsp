<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/sas.tld" prefix="sas" %>

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
<tiles:importAttribute name="mode" ignore="true"/>

<c:if test="${empty alertDef}">
  	<tiles:importAttribute name="alertDef" ignore="true"/>
</c:if>

<!-- Content Block Title: Properties -->
<tiles:insert definition=".header.tab">
  	<tiles:put name="tabKey" value="alert.config.props.PropertiesBox"/>
</tiles:insert>

<!-- Properties Content -->
<table width="100%" cellpadding="0" cellspacing="0" border="0" class="TableBottomLine">
  	<c:if test="${alertDef.parentId > 0}">
  		<tr>
    		<td colspan="4" class="BlockContent">
    			<span class="red" style="padding-left: 15px;"><fmt:message key="alerts.config.service.DefinitionList.isResourceAlert.false"/></span> <fmt:message key="alert.config.props.PB.IsTypeAlert"/>
			</td>
		</tr>
  	</c:if>
  	<tr>
    	<td colspan="4" class="BlockContent"><span style="height: 1px;"></span></td>
  	</tr>
  	<tr valign="top">
    	<td width="20%" class="BlockLabel"><fmt:message key="common.label.Name"/></td>
    	<td width="30%" class="BlockContent"><c:out value="${alertDef.name}"/>
	    	<c:if test="${canViewResourceTypeAlertTemplate}">
	    		<br/>
	        	<html:link action="/alerts/Config">
	        		<html:param name="mode" value="viewDefinition"/>
	        		<html:param name="aetid" value="${Resource.appdefResourceTypeValue.appdefTypeKey}"/>
	        		<html:param name="ad" value="${alertDef.parentId}"/>
	        		<fmt:message key="alert.config.props.PB.ViewTypeDef"/>
	        	</html:link>
	  		</c:if>
	    </td>
    	<td width="20%" class="BlockLabel"><fmt:message key="alert.config.props.PB.Priority"/></td>
    	<td width="30%" class="BlockContent">
      		<fmt:message key="${'alert.config.props.PB.Priority.'}${alertDef.priority}"/>
    	</td>
  	</tr>
  	<tr valign="top">
    	<td class="BlockLabel"><fmt:message key="common.label.Description"/></td>
    	<td class="BlockContent"><c:out value="${alertDef.description}"/></td>
    	<td class="BlockLabel"><fmt:message key="alert.config.props.PB.Active"/></td>
    	<tiles:insert page="/resource/common/monitor/alerts/config/AlertDefinitionActive.jsp">
      		<tiles:put name="alertDef" beanName="alertDef"/>
    	</tiles:insert>
  	</tr>
  	<tr valign="top">
    	<td class="BlockLabel" colspan="3"><fmt:message key="alert.config.props.PB.DateCreated"/></td>
    	<td class="BlockContent"><sas:evmEventDateTimeTag value="${alertDef.ctime}"/></td>
  	</tr>
  	<c:if test="${not empty alertDef.mtime}">
  		<tr valign="top">
    		<td class="BlockLabel" colspan="3"><fmt:message key="alert.config.props.PB.DateMod"/></td>
    		<td class="BlockContent"><sas:evmEventDateTimeTag value="${alertDef.mtime}"/></td>
  		</tr>
  	</c:if>
  	<tr>
    	<td colspan="4" class="BlockContent"><span style="height: 1px;"></span></td>
  	</tr>
</table>

<c:if test="${empty mode}">
  	<c:set var="mode" value="editProperties"/>
</c:if>

<c:if test="${canModify && not alertDef.deleted}">
	<c:choose>
  		<c:when test="${not empty Resource}">
  			<c:url var="editUrl" value="/alerts/Config.do">
		    	<c:param name="mode" value="${mode}" />
		    	<c:param name="eid" value="${Resource.entityId}" />
		    	<c:param name="ad" value="${alertDef.id}" />
		    </c:url>
		</c:when>
		<c:otherwise>
		  	<c:url var="editUrl" value="/alerts/Config.do">
		    	<c:param name="mode" value="${mode}" />
		    	<c:param name="aetid" value="${ResourceType.appdefTypeKey}" />
		    	<c:param name="ad" value="${alertDef.id}" />
		    </c:url>
		</c:otherwise>
	</c:choose>
		
	<tiles:insert definition=".toolbar.edit">
		<tiles:put name="editUrl" beanName="editUrl" />
	</tiles:insert>
</c:if>

<br/>