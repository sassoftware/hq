<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<tiles:insert definition=".page.title.events">
	<tiles:put name="titleKey" value="alert.config.props.ViewDef.PageTitle"/>
</tiles:insert>

<tiles:insert definition=".portlet.error"/>
<tiles:insert definition=".portlet.confirm"/>
<tiles:insert definition=".events.config.view.nav"/>

<tiles:insert definition=".events.group.alert.config.view.properties">
  	<tiles:put name="alertDef" beanName="GroupAlertDefinitionForm"/>
</tiles:insert>

<tiles:insert page="/resource/group/alerts/config/ViewDefinitionConditions.jsp"/>

<c:if test="${not GroupAlertDefinitionForm.deleted}">
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
	
  <tbody>
  <tr><td width="100%">&nbsp;</td></tr>
  <tr><td width="100%" valign="middle" class="BlockTitle">
        <div class="widgetHandle">
<fmt:message key="monitoring.events.MiniTabs.Escalation"/>
      </div>
        </td>
    <td align="right" class="BlockTitle"><img width="1" height="1" border="0" src="/images/spacer.gif?org.apache.catalina.filters.CSRF_NONCE=C9599922E8615EF704209EFA8FFC96AC"></td>
  </tr>
</tbody></table>

	<tiles:insert definition=".events.config.view.notifications.escalation.details">
  		<tiles:put name="alertDef" beanName="GroupAlertDefinitionForm"/>
  		<tiles:put name="gad" value="true"/>
	</tiles:insert>
</c:if>
<br/><br/>
<tiles:insert definition=".events.config.view.nav"/>
<tiles:insert definition=".page.footer"/>