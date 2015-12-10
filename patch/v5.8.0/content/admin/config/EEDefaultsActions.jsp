<%@ page language="java" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<tiles:importAttribute name="typeName"/>
<tiles:importAttribute name="aetid"/>

<td class="ListCell" align="center" nowrap="true">
	<html:link action="/resource/${typeName}/monitor/Config">
		<html:param name="mode" value="configure"/>
		<html:param name="aetid" value="${aetid}"/>
		<fmt:message key="button.editmetrictemplate" />
	</html:link>
	<html:link action="/admin/alerts/Config">
		<html:param name="mode" value="list"/>
		<html:param name="aetid" value="${aetid}"/>
		<fmt:message key="button.editalerts" />
	</html:link>
</td>