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
<jsu:importScript path="/js/listWidget.js" />
<jsu:script>
	var pageData = new Array();
</jsu:script>
<c:set var="entityId" value="${Resource.entityId}"/>
<c:url var="selfAction" value="/resource/service/Inventory.do">
	<c:param name="mode" value="view"/>
	<c:param name="rid" value="${Resource.id}"/>
	<c:param name="type" value="${entityId.type}"/>
</c:url>
<tiles:insert definition=".page.title.resource.service.full">
    <tiles:put name="resource" beanName="Resource"/>
    <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
    <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
    <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
</tiles:insert>

<hq:constant classname="org.hyperic.hq.ui.Constants" 
    symbol="CONTROL_ENABLED_ATTR" var="CONST_CONTROLLABLE" />

<c:set var="canControl" value="${requestScope[CONST_CONTROLLABLE]}"/>

<!-- CONTROL BAR -->
<c:choose>
<c:when test="${canControl}">
<tiles:insert definition=".tabs.resource.service.inventory">
    <tiles:put name="resource" beanName="Resource" />
    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
</tiles:insert>
</c:when>
<c:otherwise>
<tiles:insert definition=".tabs.resource.service.inventory.nocontrol">
    <tiles:put name="resource" beanName="Resource" />
    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
</tiles:insert>
</c:otherwise>
</c:choose>

<tiles:insert definition=".portlet.confirm"/>
<tiles:insert definition=".portlet.error"/>

<div id="panel1">
<div id="panelHeader" class="accordionTabTitleBar">
<!--  GENERAL PROPERTIES TITLE -->
  <fmt:message key="resource.common.inventory.props.GeneralPropertiesTab"/>
</div>
<div id="panelContent">
<tiles:insert page="/resource/service/inventory/ViewTypeAndHostProperties.jsp"/>
<tiles:insert definition=".resource.common.inventory.generalProperties.view">
  <tiles:put name="resource" beanName="Resource"/>
  <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
  <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
</tiles:insert>
</div>
</div>
<c:if test="${not empty Applications}">
<div id="panel2">
<div id="panelHeader" class="accordionTabTitleBar">
  <fmt:message key="resource.service.inventory.ApplicationsTab"/>
</div>
<div id="panelContent">
<tiles:insert definition=".resource.service.inventory.applications">
  <tiles:put name="service" beanName="Resource"/>
  <tiles:put name="applications" beanName="Applications"/>
  <tiles:put name="selfAction" beanName="selfAction"/>
</tiles:insert>
</div>
</div>
</c:if>

<div id="panel3">
<div id="panelHeader" class="accordionTabTitleBar">
  <fmt:message key="resource.common.inventory.groups.GroupsTab"/>
</div>
<div id="panelContent">
<html:form action="/resource/service/inventory/RemoveGroups">
<html:hidden property="rid"/>
<html:hidden property="type"/>
<tiles:insert definition=".resource.common.inventory.groups">
  <tiles:put name="resource" beanName="Resource"/>
  <tiles:put name="groups" beanName="AllResGrps"/>
  <tiles:put name="selfAction" beanName="selfAction"/>
</tiles:insert>
</div>
</div>

<div id="panel4">
<div id="panelHeader" class="accordionTabTitleBar">
  <fmt:message key="resource.common.inventory.configProps.ConfigurationPropertiesTab"/>
</div>
<div id="panelContent">
<tiles:insert definition=".resource.common.inventory.viewConfigProperties">
    <tiles:put name="resource" beanName="Resource"/>
    <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
    <tiles:put name="productConfigOptions" beanName="productConfigOptions"/>
    <tiles:put name="productConfigOptionsCount" beanName="productConfigOptionsCount"/>
    <tiles:put name="monitorConfigOptions" beanName="monitorConfigOptions"/>
    <tiles:put name="rtConfigOptions" beanName="rtConfigOptions"/>
    <tiles:put name="monitorConfigOptionsCount" beanName="monitorConfigOptionsCount"/>
    <tiles:put name="controlConfigOptions" beanName="controlConfigOptions"/>
    <tiles:put name="controlConfigOptionsCount" beanName="controlConfigOptionsCount"/>
</tiles:insert>    

</html:form>

</div>
</div>

<tiles:insert definition=".page.footer"/>
