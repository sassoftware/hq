<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ taglib uri="https://www.owasp.org/index.php/OWASP_Java_Encoder_Project" prefix="owasp" %>

<jsu:importScript path="/js/listWidget.js" />
<c:set var="widgetInstanceName" value="listRoles"/>

<jsu:script>
	var pageData = new Array();
	initializeWidgetProperties('<c:out value="${widgetInstanceName}"/>');
	widgetProperties = getWidgetProperties('<c:out value="${widgetInstanceName}"/>');
</jsu:script>

<c:url var="pnAction" value="/admin/role/RoleAdmin.do">
  <c:param name="mode" value="list"/>
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
<c:url var="psAction" value="/admin/role/RoleAdmin.do">
  <c:param name="mode" value="list"/>
  <c:if test="${not empty param.ps}">
    <c:param name="pn" value="${param.pn}"/>
  </c:if>
  <c:if test="${not empty param.so}">
    <c:param name="so" value="${owasp:forUriComponent(param.so)}"/>
  </c:if>
  <c:if test="${not empty param.sc}">
    <c:param name="sc" value="${param.sc}"/>
  </c:if>
</c:url>
<c:url var="sortAction" value="/admin/role/RoleAdmin.do">
  <c:param name="mode" value="list"/>
  <c:if test="${not empty param.pn}">
    <c:param name="pn" value="${param.pn}"/>
  </c:if>
  <c:if test="${not empty param.ps}">
    <c:param name="ps" value="${param.ps}"/>
  </c:if>
</c:url>

<html:form method="POST" action="/admin/role/Remove">

<tiles:insert definition=".page.title.admin.role">
  <tiles:put name="titleKey" value="admin.role.ListRolesPageTitle"/>
</tiles:insert>

<tiles:insert definition=".portlet.error"/>
<tiles:insert definition=".portlet.confirm"/>

<tiles:insert definition=".admin.auth.functions"/>

<display:table items="${AllRoles}" var="role" action="${sortAction}" width="100%" cellspacing="0" cellpadding="0">
  <display:column width="1%" property="id" title="<input type=\"checkbox\" onclick=\"ToggleAll(this, widgetProperties)\" name=\"listToggleAll\">"  isLocalizedTitle="false" styleClass="ListCellCheckbox" headerStyleClass="ListHeaderCheckbox">
  	<display:checkboxdecorator name="r" onclick="ToggleSelection(this, widgetProperties)" styleClass="listMember"/>
	</display:column>
  <display:column width="25%" property="name" title="common.header.Name" href="/admin/role/RoleAdmin.do?mode=view" paramId="r" paramProperty="id" sort="true" sortAttr="1" defaultSort="true"/>
  <display:column width="25%" property="memberCount" title="admin.role.list.MembersTH"/>
  <display:column width="50%" property="description" title="common.header.Description" nulls="&nbsp;"/>
</display:table>

<c:url var="listNewUrl" value="/admin/role/RoleAdmin.do">
	<c:param name="mode" value="new"/>
</c:url>

<tiles:insert definition=".toolbar.list">
  <tiles:put name="listNewUrl" beanName="listNewUrl"/>
  <tiles:put name="deleteOnly"><c:out value="${!useroperations['createRole']}"/></tiles:put>
  <tiles:put name="listItems" beanName="AllRoles"/>
  <tiles:put name="listSize" beanName="AllRoles" beanProperty="totalSize"/>
  <tiles:put name="widgetInstanceName" beanName="widgetInstanceName"/>
  <tiles:put name="pageNumAction" beanName="pnAction"/>  
  <tiles:put name="pageSizeAction" beanName="psAction"/>
  <tiles:put name="defaultSortColumn" value="1"/>
</tiles:insert>

<tiles:insert definition=".page.footer"/>

</html:form>
