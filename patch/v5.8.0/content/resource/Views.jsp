<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
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
  
  Copyright (C) [2004, 2005, 2006, 2007], Hyperic, Inc.
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
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_GROUP_ADHOC_PSS" var="CONST_ADHOC_PSS" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_GROUP_ADHOC_GRP" var="CONST_ADHOC_GRP" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_GROUP_ADHOC_APP" var="CONST_ADHOC_APP" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_GROUP_COMPAT_PS" var="CONST_COMPAT_PS" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_PLATFORM" var="CONST_PLATFORM" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_SERVER" var="CONST_SERVER" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_SERVICE" var="CONST_SERVICE" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_APPLICATION" var="CONST_APPLICATION" />
<hq:constant
    classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    symbol="APPDEF_TYPE_GROUP" var="CONST_GROUP" />
<hq:constant
    classname="org.hyperic.hq.ui.Constants" 
    symbol="CONTROL_ENABLED_ATTR" var="CONST_CONTROLLABLE" />

<c:set var="canControl" value="${requestScope[CONST_CONTROLLABLE]}"/> 
<c:set var="entityId" value="${Resource.entityId}"/>
<jsu:importScript path="/js/listWidget.js" />
<jsu:script>
	var pageData = new Array();
</jsu:script>
<c:choose>
	<c:when test="${CONST_APPLICATION == entityId.type}">
	 
	   <tiles:insert definition=".page.title.resource.application.full">
		  <tiles:put name="resource" beanName="Resource"/>
		  <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
		  <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
		  <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
		</tiles:insert>

		<tiles:insert definition=".tabs.resource.application.views">
	      <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
	      <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
	    </tiles:insert>
	    
	</c:when>
	<c:when test="${CONST_GROUP == entityId.type}">
		
		<tiles:insert definition=".page.title.resource.group.full">
		  <tiles:put name="resource" beanName="Resource"/>
		  <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
		  <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
		  <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
		</tiles:insert>
		<c:choose>
		   <c:when test="${Resource.groupType == CONST_ADHOC_PSS ||
                           Resource.groupType == CONST_ADHOC_GRP ||
                           Resource.groupType == CONST_ADHOC_APP }"> 
                <tiles:insert definition=".tabs.resource.group.views.inventoryonly">
                    <tiles:put name="resource" beanName="Resource" />
                    <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
                </tiles:insert>
            </c:when>
		    <c:when test="${ canControl }">
		        <tiles:insert definition=".tabs.resource.group.views">
		          <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
		          <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
		        </tiles:insert>
		    </c:when>
		    <c:otherwise>
		        <tiles:insert definition=".tabs.resource.group.views.nocontrol">
		          <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
		          <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
		        </tiles:insert>
		    </c:otherwise>
		</c:choose>    
		
	</c:when>
  <c:otherwise>
    <c:choose>
	    <c:when test="${CONST_PLATFORM == entityId.type}">
        <c:set var="fullDef" value=".page.title.resource.platform.full"/>
		<c:choose>
		      <c:when test="${canControl}">
		        <c:set var="viewsDef" value=".tabs.resource.platform.views"/>
		      </c:when>
		      <c:otherwise>
		        <c:set var="viewsDef" value=".tabs.resource.platform.views.nocontrol"/>
		      </c:otherwise>
        </c:choose>
	    </c:when>
	    <c:when test="${CONST_SERVER == entityId.type}">
        <c:set var="fullDef" value=".page.title.resource.server.full"/>
		<c:choose>
		      <c:when test="${canControl}">
            <c:set var="viewsDef" value=".tabs.resource.server.views"/>
		      </c:when>
		      <c:otherwise>
            <c:set var="viewsDef" value=".tabs.resource.server.views.nocontrol"/>
		      </c:otherwise>
        </c:choose>
      </c:when>
      <c:when test="${CONST_SERVICE == entityId.type}">
        <c:set var="fullDef" value=".page.title.resource.service.full"/>
 		    <c:choose>
		      <c:when test="${ canControl }">
            <c:set var="viewsDef" value=".tabs.resource.service.views"/>
		      </c:when>
		      <c:otherwise>
            <c:set var="viewsDef" value=".tabs.resource.service.views.nocontrol"/>
		      </c:otherwise>
		    </c:choose>
     </c:when>
    </c:choose>

	   <tiles:insert beanName="fullDef">
		  <tiles:put name="resource" beanName="Resource"/>
		  <tiles:put name="resourceOwner" beanName="ResourceOwner"/>
		  <tiles:put name="resourceModifier" beanName="ResourceModifier"/>
		  <tiles:put name="eid" beanName="entityId" beanProperty="appdefKey" />
		</tiles:insert>
		
 		<tiles:insert beanName="viewsDef">
		  <tiles:put name="resourceId" beanName="Resource" beanProperty="id"/>
		  <tiles:put name="resourceType" beanName="entityId" beanProperty="type"/>
		</tiles:insert>

	 </c:otherwise>
</c:choose>

<tiles:insert definition=".portlet.error"/>
<tiles:insert definition=".portlet.confirm"/>

<tiles:insert page="/portal/AttachTabBody.jsp">
</tiles:insert>
