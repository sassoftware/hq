<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<jsu:importScript path="/js/listWidget.js" />
<c:set var="widgetInstanceName" value="listUser"/>
<jsu:script>
 	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
 	userWidgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');
</jsu:script>
<c:url var="selfAction" value="/resource/group/Inventory.do">
  <c:param name="mode" value="view"/>
  <c:param name="eid" value="${Resource.entityId}"/>
  <c:if test="${not empty param.ps}">
    <c:param name="ps" value="${param.ps}"/>
  </c:if>
</c:url>

<c:url var="psAction" value="/resource/group/Inventory.do">
  <c:param name="mode" value="view"/>
  <c:param name="eid" value="${Resource.entityId}"/>
</c:url>

<hq:pageSize var="pageSize"/>

<html:form method="POST" action="/resource/group/inventory/RemoveRoles">
<input type="hidden" name="eid" value="<c:out value="${Resource.entityId}"/>" />

<display:table items="${roles}" action="${selfAction}" var="role"
               cellpadding="0" cellspacing="0" >
 <display:column property="id" 
		 title="<input type=\"checkbox\" onclick=\"ToggleAll(this, userWidgetProperties, true)\" name=\"listToggleAll\">"
   		 isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox" width="1%" >
   <display:checkboxdecorator name="roles" onclick="ToggleSelection(this, userWidgetProperties, true)" styleClass="listMember"/>
 </display:column>
 <display:column property="name" title="common.header.Name" 
                 href="/admin/role/RoleAdmin.do?mode=view" paramId="r" paramProperty="id"/>
 <display:column property="description" title="common.header.Description" defaultSort="false" />
</display:table>

<c:url var="addRolesUrl" value="/resource/group/Inventory.do">
	<c:param name="mode" value="addRoles"/>
</c:url>

<tiles:insert definition=".toolbar.addToList">
  <tiles:put name="showAddToListBtn"><c:out value="${not empty useroperations['modifyRole']}"/></tiles:put>
  <tiles:put name="showRemoveBtn"><c:out value="${not empty useroperations['modifyRole']}"/></tiles:put>
  <tiles:put name="addToListUrl" beanName="addRolesUrl"/>
  <tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
  <tiles:put name="addToListParamName" value="eid"/>
  <tiles:put name="addToListParamValue" beanName="Resource" beanProperty="entityId"/>
  <tiles:put name="listItems" beanName="roles"/>
  <tiles:put name="listSize" beanName="roles" beanProperty="totalSize"/>
  <tiles:put name="pageSizeAction" beanName="psAction"/>
  <tiles:put name="pageNumAction" beanName="selfAction"/>  
  <tiles:put name="defaultSortColumn" value="1"/>
</tiles:insert>


</html:form>


