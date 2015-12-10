<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<tiles:importAttribute name="formName"/>
<tiles:importAttribute name="showDuration" ignore="true"/>
<jsu:script>
  baselinestr = '<fmt:message key='resource.common.config.baseline'/>';
  minvaluestr = '<fmt:message key='resource.common.config.minvalue'/>';
  maxvaluestr = '<fmt:message key='resource.common.config.maxvalue'/>';
</jsu:script>
<!--<input type="hidden" name="remove.x" id="remove.x"/>-->
<!-- Content Block Title -->
<tiles:insert definition=".header.tab">
	<tiles:put name="tabKey" value="alert.config.props.CondBox"/>
</tiles:insert>
<jsu:script>
	var baselines = {<c:forEach var="baseline" items="${baselines}">
	<c:out value="${baseline.value}"/>: new Array(<c:forEach var="lv" items="${baseline.relatedOptions}">{value: '<c:out value="${lv.value}"/>', label: '<c:out value="${lv.label}"/>'},</c:forEach>{ignore: 'ignore'}),</c:forEach>
	ignore: 'ignore'
	};
</jsu:script>
<jsu:importScript path="/js/alertConfigFunctions.js" />
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  	<logic:messagesPresent property="condition[0].trigger">
	  	<tr>
	    	<td colspan="2" class="ErrorField">
	      		<span class="ErrorFieldContent"><html:errors property="condition[0].trigger"/></span>
	    	</td>
	  	</tr>
  	</logic:messagesPresent>
  	<tiles:insert definition=".events.config.conditions.condition">
    	<tiles:put name="formName"><c:out value="${formName}"/></tiles:put>
  	</tiles:insert>
  	<c:if test="${numConditions < 3}">
  		<tiles:insert definition=".events.config.conditions.addlink">
    		<tiles:put name="formName"><c:out value="${formName}"/></tiles:put>
  		</tiles:insert>
  	</c:if>
  	<tiles:insert definition=".events.config.conditions.enablement">
    	<tiles:put name="showDuration" beanName="showDuration"/>
  	</tiles:insert>
</table>