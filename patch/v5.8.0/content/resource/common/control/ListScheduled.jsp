<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ taglib uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" prefix="owasp" %>

<tiles:importAttribute name="section" ignore="true"/>

<c:if test="${empty section}">
 <c:set var="section" value="server"/>
</c:if>
<jsu:importScript path="/js/listWidget.js" />
<c:set var="widgetInstanceName" value="listServerControl"/>
<jsu:script>
	var pageData = new Array();
	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
	widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');  
</jsu:script>
<c:set var="tmpTitle"> - <fmt:message key="resource.server.ControlSchedule.SubTitle"/></c:set>
<tiles:insert definition=".header.tab">
  <tiles:put name="tabKey" value="resource.server.ControlSchedule.Title"/>
  <tiles:put name="subTitle" beanName="tmpTitle"/>
</tiles:insert>

<html:form action="/resource/${section}/control/RemoveControlJobs">

<html:hidden property="eid" value="${Resource.entityId}"/>

<c:url var="selfAction" value="/resource/${section}/Control.do">
	<c:param name="mode" value="view"/>
	<c:param name="rid" value="${Resource.id}"/>
	<c:param name="type" value="${Resource.entityId.type}"/>
</c:url>
<c:url var="psAction" value="${selfAction}">
  <c:if test="${not empty param.pn}">
    <c:param name="pn" value="${param.pn}"/>
  </c:if>
  <c:if test="${not empty param.so}">
    <c:param name="so" value="${owasp:forUriComponent(param.so)}"/>
  </c:if>
  <c:if test="${not empty param.sc}">
    <c:param name="sc" value="${param.sc}"/>
  </c:if>
</c:url>

<c:url var="pnAction" value="${selfAction}">
  <c:if test="${not empty param.ps}">
    <c:param name="ps" value="${param.ps}"/>
  </c:if>
  <c:if test="${not empty param.so}">
    <c:param name="so" value="${owasp:forUriComponent(param.so)}"/>
  </c:if>
  <c:if test="${not empty param.sc}">
    <c:param name="sc" value="${param.sc}"/>
  </c:if>
</c:url>

<%-- now add the context path --%>

<%
   Object oal = request.getAttribute("ctrlActionsSrvAttr");
   if(oal!=null && oal instanceof java.util.ArrayList){
     //out.println(oal.getClass());
     java.util.ArrayList al = (java.util.ArrayList)oal;
     java.util.Locale locale1 = request.getLocale();
     for (java.util.Iterator it = al.iterator(); it.hasNext();){
      Object ohist = it.next();
     if(ohist instanceof org.hyperic.hq.control.server.session.ControlSchedule){
        org.hyperic.hq.control.server.session.ControlSchedule cs = (org.hyperic.hq.control.server.session.ControlSchedule)ohist ;
        cs.setLocale(locale1);     
     }
     }
   }
%>

<c:url var="selfActionUrl" value="${selfAction}"/>

<div id="listDiv">
  <display:table cellspacing="0" cellpadding="0" width="100%" action="${selfActionUrl}"
                  orderValue="so" order="${owasp:forUriComponent(param.so)}" sortValue="sc" sort="${param.sc}" pageValue="pn" 
                  page="${param.pn}" pageSizeValue="ps" pageSize="${param.ps}" items="${ctrlActionsSrvAttr}" var="sched" >
   <display:column width="1%" property="id" 
                    title="<input type=\"checkbox\" onclick=\"ToggleAll(this, widgetProperties)\" name=\"listToggleAll\">"  
		    isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox" >
    <display:checkboxdecorator name="controlJobs" onclick="ToggleSelection(this, widgetProperties)" styleClass="listMember"/>
   </display:column>
   <display:column width="20%" property="actionOnLocale" sort="true" sortAttr="9"
                   defaultSort="true" title="resource.server.ControlSchedule.ListHeader.Action"
                   href="/resource/${section}/Control.do?mode=edit&type=${Resource.entityId.type}&rid=${Resource.id}" paramId="bid" paramProperty="id" nowrap="true" />
   <display:column width="16%" property="nextFireTime" title="resource.server.ControlSchedule.ListHeader.NextFire"  nowrap="true" sort="true" sortAttr="15" defaultSort="false">
      <display:eventdatetimedecorator/>
   </display:column>
   <display:column width="30%" property="scheduleValue.scheduleString" title="resource.server.ControlSchedule.ListHeader.Sched"   
                   headerStyleClass="ListHeaderInactive" /> 
   <display:column width="33%" property="scheduleValue.description" title="common.header.Description" 
                   headerStyleClass="ListHeaderInactive" />
  </display:table>
</div>


<c:url var="newServerControlUrl" value="/resource/${section}/Control.do">
	<c:param name="mode" value="new"/>
	<c:param name="rid" value="${Resource.id}"/>
	<c:param name="type" value="${Resource.entityId.type}"/>
</c:url>
<tiles:insert definition=".toolbar.list">
  <tiles:put name="listNewUrl" beanName="newServerControlUrl"/>
  <tiles:put name="listItems" beanName="ctrlActionsSrvAttr"/>
  <tiles:put name="listSize" beanName="ctrlActionsSrvAttr" beanProperty="totalSize" />
  <tiles:put name="pageSizeAction" beanName="psAction" />
  <tiles:put name="pageNumAction" beanName="pnAction"/>    
  <tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
  <tiles:put name="defaultSortColumn" value="9"/>
</tiles:insert>

</html:form>
