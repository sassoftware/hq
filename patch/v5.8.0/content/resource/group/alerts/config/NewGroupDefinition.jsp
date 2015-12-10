<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<c:choose>
  <c:when test="${GroupAlertDefinitionForm.ad != 0}">
    <c:set var="actionUrl" value="/alerts/EditGroup"/>
  </c:when>
  <c:otherwise>
    <c:set var="actionUrl" value="/alerts/NewGroup"/>
  </c:otherwise>
</c:choose>

<html:form action="${actionUrl}">

<tiles:insert definition=".page.title.events">
  <c:choose>
    <c:when test="${GroupAlertDefinitionForm.ad != 0}">
      <tiles:put name="titleKey" value="alert.config.props.ViewDef.PageTitle"/>
    </c:when>
    <c:otherwise>
      <tiles:put name="titleKey" value="alert.config.edit.NewAlertDef.PageTitle"/>
    </c:otherwise>
  </c:choose>
</tiles:insert>

<tiles:insert definition=".portlet.error"/>

<html:hidden property="eid"/>
<c:if test="${not empty param.ad}">
<html:hidden property="ad"/>
</c:if>

<tiles:insert definition=".events.config.new.properties"/>

<tiles:insert definition=".header.tab">
<tiles:put name="tabKey" value="alert.config.props.CondBox"/>
</tiles:insert>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td width="20%" class=BlockLabel><html:img page="/images/icon_required.gif" height="9" width="9" border="0"/>
    </td>
    <td class="BlockContent">
    <fmt:message key="resource.group.alerts.config.num.members">
      <fmt:param value="${GroupAlertDefinitionForm.groupSize}"/>
    </fmt:message>
    </td>
  </tr>
  <tr>
    <td class=BlockLabel><fmt:message key="alert.config.props.CB.label.numberOfResourceMembers"/></td>
    <td class="BlockContent">
<html:select property="sizeComparator">
   <html:option value="0">&lt;</html:option>
   <html:option value="1">&gt;</html:option>
</html:select>

<html:text size="5" maxlength="5" property="resourceCount"/>

<html:select property="percentOrAbsolute">
   <html:option value="0"><fmt:message key="alert.config.props.CB.ByPercentage"/></html:option>
   <html:option value="1"><fmt:message key="alert.config.props.CB.ByAbsoluteValue"/></html:option>
</html:select>
     
    </td>
  </tr>
  <tr>
    <td class=BlockLabel><fmt:message key="alert.config.props.CB.label.criteria"/></td>
    <logic:messagesPresent property="metricVal"><td class="ErrorField"></logic:messagesPresent>
    <logic:messagesNotPresent property="metricVal"><td class="BlockContent"></logic:messagesNotPresent>

<html:select property="template">
  <html:optionsCollection property="templates"/>
</html:select>

<html:select property="operator">
  <html:optionsCollection property="operators"/>
</html:select> 

<html:text size="8" maxlength="25" property="metricVal"/>
    <logic:messagesPresent property="metricVal">
    <span class="ErrorFieldContent">- <html:errors property="metricVal"/></span>
    </logic:messagesPresent>
    </td>
  </tr>
  <tr>
    <td class="BlockLabel"></td>
    <td class="BlockContent">
        <html:checkbox property="isNotReportingOffending"><fmt:message key="alert.config.props.TriggerNotReporting"/></html:checkbox>
    </td>
  </tr>
  <tr>
    <td colspan="2" class="BlockContent"><img src="<html:rewrite page="/images/spacer.gif" />" height="1" width="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="2" class="BlockBottomLine"><img src="<html:rewrite page="/images/spacer.gif" />" height="1" width="1" border="0"></td>
  </tr>
</table>

<c:if test="${empty param.ad}">
<br/>

<tiles:insert definition=".header.tab">
<tiles:put name="tabKey" value="alert.current.detail.notify.Tab"/>
</tiles:insert>

<table width="100%" border="0" cellspacing="0" cellpadding="4">
  <tr>
    <td colspan="2" class="BlockContent"><img src="<html:rewrite page="/images/spacer.gif" />" height="1" width="1" border="0"></td>
  </tr>
  <tr>
    <td class=BlockLabel width="20%"><fmt:message key="alert.config.escalation.scheme"/></td>
    <td class="BlockContent">
	    <select name="escId" id="escIdSel">
	    </select>
		<jsu:script>
	    	function addOption(sel, val, txt) {
		        var o = document.createElement('option');
	    	    var t = document.createTextNode(txt);
	
	        	o.setAttribute('value',val);
	
		        sel.appendChild(o);
	    	    o.appendChild(document.createTextNode(txt));
		    }
	
			var escJson = eval( '( { "escalations":<c:out value="${escalations}" escapeXml="false"/> })' );
			var schemes = escJson.escalations;
	  		var escalationSel = hqDojo.byId('escIdSel');
	  
	  		for (var i = 0; i < schemes.length; i++) {
	    		addOption(escalationSel , schemes[i].id, schemes[i].name);
	  		}
		</jsu:script>
    </td>
  </tr>
  <tr>
    <td colspan="2" class="BlockContent"><img src="<html:rewrite page="/images/spacer.gif" />" height="1" width="1" border="0"></td>
  </tr>
  <tr>
    <td colspan="2" class="BlockBottomLine"><img src="<html:rewrite page="/images/spacer.gif" />" height="1" width="1" border="0"></td>
  </tr>
</table>
</c:if>

<tiles:insert definition=".events.config.form.buttons"/>

<tiles:insert definition=".page.footer"/>

</html:form>

