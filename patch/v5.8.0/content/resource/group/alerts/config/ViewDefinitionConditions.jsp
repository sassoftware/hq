<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>


<tiles:insert definition=".header.tab">
<tiles:put name="tabKey" value="alert.config.props.CondBox"/>
</tiles:insert>

<c:set var="alertDef" value="${GroupAlertDefinitionForm}"/>

<table width="100%" border="0" cellspacing="0" cellpadding="4" class="TableBottomLine">
  <tr>
    <td width="20%" class=BlockLabel><fmt:message key="alert.config.props.CB.label.numberOfResourceMembers"/></td>
    <td width="50%" class="BlockContent">
        <c:out value="${alertDef.sizeComparatorLabel}"/>
        <c:out value="${alertDef.resourceCount}"/>
        <c:out value="${alertDef.percentOrAbsoluteLabel}"/>
        <html:img page="/images/icon_required.gif" height="9" width="9" border="0"/>
    </td>
    <td class=BlockLabel><html:img page="/images/icon_required.gif" height="9" width="9" border="0"/></td>
    <td width="10%" class="BlockContent" nowrap="true">
    <fmt:message key="resource.group.alerts.config.num.members">
      <fmt:param value="${alertDef.groupSize}"/>
    </fmt:message>
    </td>
  </tr>
  <tr>
    <td class=BlockLabel style="padding-bottom: 8px;"><fmt:message key="alert.config.props.CB.label.criteria"/></td>
    <td class="BlockContent" colspan="3" style="padding-bottom: 2px;">
        <c:out value="${alertDef.templateLabel}"/>
        <c:out value="${alertDef.operatorLabel}"/>
        <c:out value="${alertDef.metricVal}"/>
    </td>
  </tr>
  <c:if test="${alertDef.isNotReportingOffending}">
  <tr>
    <td class="BlockLabel">&nbsp;</td>
    <td class="BlockContent" colspan="3">
        <fmt:message key="alert.config.props.TriggerNotReportingEnabled"/>
    </td>
  </tr>
  </c:if>
</table>

<c:if test="${not alertDef.deleted}">
	<hq:userResourcePermissions debug="false" resource="${Resource}"/>
    <c:url var="editUrl" value="/alerts/Config.do">
    	<c:param name="mode" value="editGroupDefinition" />
	   	<c:param name="eid" value="${Resource.entityId.appdefKey}" />
	  	<c:param name="ad" value="${alertDef.id}" />
	</c:url>

	<c:if test="${canModify}">
		<tiles:insert definition=".toolbar.edit">
			<tiles:put name="editUrl" beanName="editUrl" />
		</tiles:insert>
	</c:if>
</c:if>

