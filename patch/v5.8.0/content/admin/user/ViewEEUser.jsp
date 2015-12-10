<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib uri="/WEB-INF/tld/display.tld" prefix="display" %>

<hq:pageSize var="pageSize"/>

<!--  PAGE TITLE -->
<c:set var="pagetmpname" value="${User.firstName} ${User.lastName}" />
<tiles:insert definition=".page.title.admin.user.view">
 <tiles:put name="titleName"  beanName="pagetmpname" />
</tiles:insert>
<!--  /  -->

<!-- USER PROPERTIES -->

<tiles:insert definition=".portlet.confirm" flush="true"/>
<tiles:insert definition=".portlet.error" flush="true"/>
<tiles:insert definition=".admin.user.ViewProperties"/>

<!-- USER ROLES -->
<tiles:insert definition=".admin.user.ViewRoles"/>
<c:url var="userListUrl" value="/admin/user/UserAdmin.do">
	<c:param name="mode" value="list"/>
</c:url>	
<tiles:insert definition=".page.return">
  <tiles:put name="returnUrl" beanName="userListUrl" />
  <tiles:put name="returnKey" value="admin.user.ReturnToUsers"/>
</tiles:insert>

<!--  Page footer -->
<tiles:insert definition=".page.footer"/>
<!--  /Page footer -->
