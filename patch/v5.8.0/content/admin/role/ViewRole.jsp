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
<c:set var="userWidgetInstanceName" value="assignedUsers"/>
<c:set var="groupWidgetInstanceName" value="assignedGroups"/>
<jsu:script>
	var pageData = new Array();

	initializeWidgetProperties('<c:out value="${userWidgetInstanceName}"/>');
	userWidgetProperties = getWidgetProperties('<c:out value="${userWidgetInstanceName}"/>');
	initializeWidgetProperties('<c:out value="${groupWidgetInstanceName}"/>');
	groupWidgetProperties = getWidgetProperties('<c:out value="${groupWidgetInstanceName}"/>');
</jsu:script>
<c:url var="selfPnuAction" value="/admin/role/RoleAdmin.do">
  	<c:param name="mode" value="view"/>
  	<c:param name="r" value="${Role.id}"/>
  	<c:if test="${not empty param.psu}">
    	<c:param name="psu" value="${param.psu}"/>
  	</c:if>
  	<c:if test="${not empty param.sou}">
    	<c:param name="sou" value="${param.sou}"/>
  	</c:if>
  	<c:if test="${not empty param.scu}">
    	<c:param name="scu" value="${param.scu}"/>
  	</c:if>
  	<c:if test="${not empty param.psg}">
    	<c:param name="psg" value="${param.psg}"/>
  	</c:if>
  	<c:if test="${not empty param.png}">
    	<c:param name="png" value="${param.png}"/>
  	</c:if>
  	<c:if test="${not empty param.sog}">
    	<c:param name="sog" value="${param.sog}"/>
  	</c:if>
  	<c:if test="${not empty param.scg}">
    	<c:param name="scg" value="${param.scg}"/>
  	</c:if>
</c:url>
<c:url var="selfPngAction" value="/admin/role/RoleAdmin.do">
  	<c:param name="mode" value="view"/>
  	<c:param name="r" value="${Role.id}"/>
  	<c:if test="${not empty param.psu}">
    	<c:param name="psu" value="${param.psu}"/>
  	</c:if>
  	<c:if test="${not empty param.pnu}">
    	<c:param name="pnu" value="${param.pnu}"/>
  	</c:if>
  	<c:if test="${not empty param.sou}">
    	<c:param name="sou" value="${param.sou}"/>
  	</c:if>
  	<c:if test="${not empty param.scu}">
    	<c:param name="scu" value="${param.scu}"/>
  	</c:if>
  	<c:if test="${not empty param.psg}">
    	<c:param name="psg" value="${param.psg}"/>
  	</c:if>
  	<c:if test="${not empty param.sog}">
    	<c:param name="sog" value="${param.sog}"/>
  	</c:if>
  	<c:if test="${not empty param.scg}">
    	<c:param name="scg" value="${param.scg}"/>
  	</c:if>
</c:url>
<c:url var="selfPsuAction" value="/admin/role/RoleAdmin.do">
  	<c:param name="mode" value="view"/>
  	<c:param name="r" value="${Role.id}"/>
  	<c:if test="${not empty param.pnu}">
    	<c:param name="pnu" value="${param.pnu}"/>
  	</c:if>
  	<c:if test="${not empty param.sou}">
    	<c:param name="sou" value="${param.sou}"/>
  	</c:if>
  	<c:if test="${not empty param.scu}">
    	<c:param name="scu" value="${param.scu}"/>
  	</c:if>
  	<c:if test="${not empty param.png}">
    	<c:param name="png" value="${param.png}"/>
  	</c:if>
  	<c:if test="${not empty param.psg}">
    	<c:param name="psg" value="${param.psg}"/>
  	</c:if>
  	<c:if test="${not empty param.sog}">
    	<c:param name="sog" value="${param.sog}"/>
  	</c:if>
  	<c:if test="${not empty param.scg}">
    	<c:param name="scg" value="${param.scg}"/>
  	</c:if>
</c:url>
<c:url var="selfPsgAction" value="/admin/role/RoleAdmin.do">
  	<c:param name="mode" value="view"/>
  	<c:param name="r" value="${Role.id}"/>
  	<c:if test="${not empty param.pnu}">
    	<c:param name="pnu" value="${param.pnu}"/>
  	</c:if>
  	<c:if test="${not empty param.psu}">
    	<c:param name="psu" value="${param.psu}"/>
  	</c:if>
  	<c:if test="${not empty param.sou}">
    	<c:param name="sou" value="${param.sou}"/>
  	</c:if>
  	<c:if test="${not empty param.scu}">
    	<c:param name="scu" value="${param.scu}"/>
  	</c:if>
  	<c:if test="${not empty param.png}">
    	<c:param name="png" value="${param.png}"/>
  	</c:if>
  	<c:if test="${not empty param.sog}">
    	<c:param name="sog" value="${param.sog}"/>
  	</c:if>
  	<c:if test="${not empty param.scg}">
    	<c:param name="scg" value="${param.scg}"/>
  	</c:if>
</c:url>
<c:url var="selfPuAction" value="/admin/role/RoleAdmin.do">
  	<c:param name="mode" value="view"/>
  	<c:param name="r" value="${Role.id}"/>
  	<c:if test="${not empty param.pnu}">
    	<c:param name="pnu" value="${param.pnu}"/>
  	</c:if>
  	<c:if test="${not empty param.psu}">
    	<c:param name="psu" value="${param.psu}"/>
  	</c:if>
  	<c:if test="${not empty param.png}">
    	<c:param name="png" value="${param.png}"/>
  	</c:if>
  	<c:if test="${not empty param.psg}">
    	<c:param name="psg" value="${param.psg}"/>
  	</c:if>
  	<c:if test="${not empty param.sog}">
    	<c:param name="sog" value="${param.sog}"/>
  	</c:if>
  	<c:if test="${not empty param.scg}">
    	<c:param name="scg" value="${param.scg}"/>
  	</c:if>
</c:url>
<c:url var="selfPgAction" value="/admin/role/RoleAdmin.do">
  	<c:param name="mode" value="view"/>
  	<c:param name="r" value="${Role.id}"/>
  	<c:if test="${not empty param.pnu}">
    	<c:param name="pnu" value="${param.pnu}"/>
  	</c:if>
  	<c:if test="${not empty param.psu}">
    	<c:param name="psu" value="${param.psu}"/>
  	</c:if>
  	<c:if test="${not empty param.sou}">
	    <c:param name="sou" value="${param.sou}"/>
  	</c:if>
  	<c:if test="${not empty param.scu}">
    	<c:param name="scu" value="${param.scu}"/>
  	</c:if>
  	<c:if test="${not empty param.png}">
    	<c:param name="png" value="${param.png}"/>
  	</c:if>
  	<c:if test="${not empty param.psg}">
    	<c:param name="psg" value="${param.psg}"/>
  	</c:if>
</c:url>
<tiles:insert definition=".page.title.admin.role">
	<tiles:put name="titleName">
  		<c:out value="${Role.name}" />
  	</tiles:put>
</tiles:insert>
<c:url var="listRoleUrl" value="/admin/role/RoleAdmin.do">
	<c:param name="mode" value="list"/>
</c:url>
<tiles:insert definition=".page.return">
  	<tiles:put name="returnUrl" beanName="listRoleUrl"/>
  	<tiles:put name="returnKey" value="admin.role.view.ReturnToRoles"/>
</tiles:insert>
<tiles:insert definition=".portlet.confirm"/>
<tiles:insert definition=".portlet.error"/>
<tiles:insert page="/admin/role/RolePropertiesForm.jsp">
  	<tiles:put name="mode" value="view"/>
  	<tiles:put name="role" beanName="Role"/>
</tiles:insert>
<html:form action="/admin/role/View">
	<tiles:insert page="/admin/role/RolePermissionsForm.jsp">
  		<tiles:put name="mode" value="view"/>
	</tiles:insert>
</html:form>
<c:if test="${Role.id != 0 && useroperations['modifyRole']}">
	<c:url var="editRoleUrl" value="/admin/role/RoleAdmin.do">
		<c:param name="mode" value="edit"/>
	</c:url>
	<tiles:insert definition=".toolbar.edit">
  		<tiles:put name="editUrl" beanName="editRoleUrl"/>
  		<tiles:put name="editParamName" value="r"/>
  		<tiles:put name="editParamValue" beanName="Role" beanProperty="id"/>
	</tiles:insert>
</c:if>
<br/>
<html:form method="POST" action="/admin/role/RemoveUsers">
	<tiles:insert definition=".header.tab">
  		<tiles:put name="tabKey" value="admin.role.users.AssignedUsersTab"/>
	</tiles:insert>
	<display:table items="${RoleUsers}" var="user" action="${selfPuAction}" orderValue="sou" order="${param.sou}" sortValue="scu" sort="${param.scu}" pageValue="pnu" page="${param.pnu}" pageSizeValue="psu" pageSize="${param.psu}" width="100%" cellpadding="0" cellspacing="0">
  		<display:column width="1%" property="id" title="<input type=\"checkbox\" onclick=\"ToggleAll(this, userWidgetProperties, true)\" name=\"listToggleAll\">" isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox" >
    		<display:checkboxdecorator name="u" onclick="ToggleSelection(this, userWidgetProperties, true)" styleClass="listMember" suppress="1"/>
  		</display:column>
  		<display:column href="/admin/user/UserAdmin.do?mode=view" paramId="u" paramProperty="id" width="25%" value="${user.name}" title="admin.role.users.UsernameTH" sort="true" sortAttr="3" defaultSort="true"/>
  		<display:column width="75%" property="firstName" title="admin.role.users.FirstNameTH"/> <!-- XXX: add new sortAttr for firstName -->
	</display:table>
	<c:url var="addToListUrl" value="/admin/role/RoleAdmin.do">
		<c:param name="mode" value="addUsers"/>
	</c:url>
	<tiles:insert definition=".toolbar.addToList">
  		<tiles:put name="showAddToListBtn"><c:out value="${(Role.id == 0 && isSubjectInRole && useroperations['modifyRole'] && useroperations['viewSubject']) || (Role.id != 0 && useroperations['modifyRole'] && useroperations['viewSubject'])}"/></tiles:put>
  		<tiles:put name="showRemoveBtn"><c:out value="${(Role.id == 0 && isSubjectInRole && useroperations['modifyRole'] !=null) || (Role.id != 0 && useroperations['modifyRole'] != null)}"/></tiles:put>
  		<tiles:put name="addToListUrl" beanName="addToListUrl"/>
		<tiles:put name="widgetInstanceName" beanName="userWidgetInstanceName"/>
  		<tiles:put name="addToListParamName" value="r"/>
  		<tiles:put name="addToListParamValue" beanName="Role" beanProperty="id"/>
  		<tiles:put name="listItems" beanName="RoleUsers"/>
  		<tiles:put name="listSize" beanName="RoleUsers" beanProperty="totalSize"/>
  		<tiles:put name="pageSizeParam" value="psu"/>
  		<tiles:put name="pageSizeAction" beanName="selfPsuAction"/>
  		<tiles:put name="pageNumParam" value="pnu"/>
  		<tiles:put name="pageNumAction" beanName="selfPnuAction"/>
	</tiles:insert>
	<html:hidden property="r"/>
</html:form>
<br/>
<c:if test="${not Role.system}">
	<html:form method="POST" action="/admin/role/RemoveResourceGroups">
		<tiles:insert definition=".header.tab">
  			<tiles:put name="tabKey" value="admin.role.groups.AssignedGroupsTab"/>
		</tiles:insert>
		<hq:constant classname="org.hyperic.hq.appdef.shared.AppdefEntityConstants" 
    				 symbol="APPDEF_TYPE_GROUP" var="CONST_GROUP_TYPE" />
		<display:table items="${RoleResGrps}" var="group" action="${selfPgAction}" orderValue="sog" order="${param.sog}" sortValue="scg" sort="${param.scg}" pageValue="png" page="${param.png}" pageSizeValue="psg" pageSize="${param.psg}" width="100%" cellpadding="0" cellspacing="0">
  			<display:column width="1%" property="id" title="<input type=\"checkbox\" onclick=\"ToggleAll(this, groupWidgetProperties, true)\" name=\"listToggleAll\">" isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox" >
    			<display:checkboxdecorator name="g" onclick="ToggleSelection(this, groupWidgetProperties, true)" styleClass="listMember"/>
  			</display:column>
  			<display:column width="25%" property="name" href="/Resource.do?rid=${group.id}&type=${CONST_GROUP_TYPE}" title="common.header.Group" sort="true" sortAttr="2" defaultSort="true"/>
  			<display:column width="75%" property="description" title="common.header.Description"/>
		</display:table>
		<c:url var="addGroupsRoleUrl" value="/admin/role/RoleAdmin.do">
			<c:param name="mode" value="addGroups"/>
		</c:url>
		<tiles:insert definition=".toolbar.addToList">
  			<tiles:put name="showAddToListBtn"><c:out value="${useroperations['modifyRole'] && useroperations['viewResourceGroup']}"/></tiles:put>
  			<tiles:put name="showRemoveBtn"><c:out value="${useroperations['modifyRole'] != null}"/></tiles:put>
  			<tiles:put name="addToListUrl" beanName="addGroupsRoleUrl"/>
  			<tiles:put name="widgetInstanceName" beanName="groupWidgetInstanceName"/>
  			<tiles:put name="addToListParamName" value="r"/>
  			<tiles:put name="addToListParamValue" beanName="Role" beanProperty="id"/>
  			<tiles:put name="listItems" beanName="RoleResGrps"/>
  			<tiles:put name="listSize" beanName="NumResGrps"/>
  			<tiles:put name="pageSizeParam" value="psg"/>
  			<tiles:put name="pageSizeAction" beanName="selfPsgAction"/>
  			<tiles:put name="pageNumParam" value="png"/>
  			<tiles:put name="pageNumAction" beanName="selfPngAction"/>  
		</tiles:insert>
		<html:hidden property="r"/>
	</html:form>
	<br/>
</c:if>
<tiles:insert page="RoleCalendar.jsp"/>
<tiles:insert definition=".page.return">
  	<tiles:put name="returnUrl" beanName="listRoleUrl"/>
  	<tiles:put name="returnKey" value="admin.role.view.ReturnToRoles"/>
</tiles:insert>
<tiles:insert definition=".page.footer"/>