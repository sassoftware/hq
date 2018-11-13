<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsu:script>
  baselinestr = '<fmt:message key='resource.common.config.baseline'/>';
  minvaluestr = '<fmt:message key='resource.common.config.minvalue'/>';
  maxvaluestr = '<fmt:message key='resource.common.config.maxvalue'/>';
</jsu:script>

<fmt:setBundle basename="controlAction" var="cap"/>

<tiles:importAttribute name="formName"/>
 <!--<input type="hidden" name="remove.x" id="remove.x"/>-->
<html:hidden property="numConditions"/>
<c:forEach var="i" begin="0" end="${numConditions - 1}">
<tr>
  <td width="20%" class="BlockLabel">
  <c:choose>
  <c:when test="${i == 0}">
    <html:img page="/images/icon_required.gif" width="9" height="9" border="0"/>
  </c:when>
  <c:otherwise>
    <html:select property="condition[${i}].required">
      <html:option value="true"><fmt:message key="alert.config.props.CB.And"/></html:option>
      <html:option value="false"><fmt:message key="alert.config.props.CB.Or"/></html:option>
    </html:select>&nbsp;
  </c:otherwise>
  </c:choose>
    <b><fmt:message key="alert.config.props.CB.IfCondition"/></b>
  </td>
  <logic:messagesPresent property="condition[${i}].metricId"><td width="80%" class="ErrorField"></logic:messagesPresent>
  <logic:messagesNotPresent property="condition[${i}].metricId"><td width="80%" class="BlockContent"></logic:messagesNotPresent>
    <html:radio property="condition[${i}].trigger" value="onMetric"/>
    <fmt:message key="alert.config.props.CB.Content.Metric"/>
    <c:set var="seldd"><fmt:message key="alert.dropdown.SelectOption"/></c:set>
    <html:select property="condition[${i}].metricId" onchange="javascript:resetNote(${i});selectMetric('condition[${i}].metricId', 'condition[${i}].metricName');changeDropDown('condition[${i}].metricId', 'condition[${i}].baselineOption', '${seldd}');">
    <html:option value="-1" key="alert.dropdown.SelectOption"/>
    <c:choose>
    <c:when test="${Resource.entityId.type != 5}"> <%-- group --%>
      <c:choose>
        <c:when test="${not empty ResourceType}">
          <html:optionsCollection property="metrics" label="name" value="id"/>
        </c:when>
        <c:otherwise>
          <html:optionsCollection property="metrics" label="template.name" value="id"/>
        </c:otherwise>
      </c:choose>
    </c:when>
    <c:otherwise>
    <html:optionsCollection property="metrics" label="name" value="id"/>
    </c:otherwise>
    </c:choose>
    </html:select>
    <logic:messagesPresent property="condition[${i}].metricId">
    <span class="ErrorFieldContent">- <html:errors property="condition[${i}].metricId"/></span>
    </logic:messagesPresent>
    <c:choose>
    <c:when test="${not empty param.metricName}">
      <html:hidden property="condition[${i}].metricName" value="${param.metricName}"/>
    </c:when>
    <c:otherwise>
      <html:hidden property="condition[${i}].metricName"/>
    </c:otherwise>
    </c:choose>
  </td>
</tr>
<tr>
  <td class="BlockLabel">&nbsp;</td>
  <td class="BlockContent">
    
    <table width="100%" border="0" cellspacing="0" cellpadding="2">
      <tr> 
        <td nowrap="true"><div style="width: 60px; position: relative;"/><html:img page="/images/schedule_return.gif" width="17" height="21" border="0" align="right"/></td>
        <logic:messagesPresent property="condition[${i}].absoluteValue"><td width="100%" class="ErrorField"></logic:messagesPresent>
        <logic:messagesNotPresent property="condition[${i}].absoluteValue"><td width="100%"></logic:messagesNotPresent>
          <html:radio property="condition[${i}].thresholdType" value="absolute"/>
        
          
          <html:select property="condition[${i}].absoluteComparator">
            <hq:optionMessageList property="comparators" baseKey="alert.config.props.CB.Content.Comparator" filter="true"/>
          </html:select>
          <html:text property="condition[${i}].absoluteValue" size="8" maxlength="15"/>&nbsp;<fmt:message key="alert.config.props.CB.Content.AbsoluteValue"/>
          <logic:messagesPresent property="condition[${i}].absoluteValue">
          <br><span class="ErrorFieldContent">- <html:errors property="condition[${i}].absoluteValue"/></span>
          </logic:messagesPresent>
        </td>
      </tr>
      <tr> 
        <td>&nbsp;</td>
        <logic:messagesPresent property="condition[${i}].percentage"><c:set var="percentageErrs" value="true"/></logic:messagesPresent>
        <logic:messagesPresent property="condition[${i}].baselineOption"><c:set var="baselineOptionErrs" value="true"/></logic:messagesPresent>
        <c:choose>
        <c:when test="${percentageErrs || baselineOptionErrs}"><td width="100%" class="ErrorField"></c:when>
        <c:otherwise><td width="100%"></c:otherwise>
        </c:choose>
          <html:radio property="condition[${i}].thresholdType" value="percentage"/>
          
          <html:select property="condition[${i}].percentageComparator">
            <hq:optionMessageList property="comparators" baseKey="alert.config.props.CB.Content.Comparator" filter="true"/>
          </html:select>
          <html:text property="condition[${i}].percentage" size="6" maxlength="4"/>&nbsp;<fmt:message key="alert.config.props.CB.Content.Percent"/>&nbsp;
          <html:select property="condition[${i}].baselineOption" disabled="true" onclick="javascript:toggleNoBaselineMessage(this, ${i})">
          <html:option value="" key="alert.dropdown.SelectOption"/>
          </html:select><span id="baselineNotCalcMsg_${i}" style="display:none;background-color:#FFFD99"><fmt:message key="alert.config.props.CB.baselineNotCalculated"></fmt:message></span>
          <c:if test="${! empty EditAlertDefinitionConditionsForm.conditions[i].metricId }">
			<jsu:script>
				var baselineOption = '<c:out value="${EditAlertDefinitionConditionsForm.conditions[i].baselineOption}"/>';
          		changeDropDown('condition[<c:out value="${i}"/>].metricId', 'condition[<c:out value="${i}"/>].baselineOption', '<c:out value="${seldd}"/>', baselineOption);
			</jsu:script>
          </c:if>
          <c:if test="${! empty NewAlertDefinitionForm.conditions[i].metricId}">
			<jsu:script>
				var baselineOption = '<c:out value="${NewAlertDefinitionForm.conditions[i].baselineOption}"/>';
          		changeDropDown('condition[<c:out value="${i}"/>].metricId', 'condition[<c:out value="${i}"/>].baselineOption', '<c:out value="${seldd}"/>', baselineOption);
			</jsu:script>
          </c:if> 
          <c:if test="${percentageErrs || baselineOptionErrs}">
          <span class="ErrorFieldContent">
          <c:if test="${percentageErrs}"><br>- <html:errors property="condition[${i}].percentage"/></c:if>
          <c:if test="${baselineOptionErrs}"><br>- <html:errors property="condition[${i}].baselineOption"/></c:if>
          </span>
          </c:if>
          <c:set var="percentageErrs" value="false"/>
          <c:set var="baselineOptionErrs" value="false"/>
        </td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td width="100%">
          <html:radio property="condition[${i}].thresholdType" value="changed"/>
          <fmt:message key="alert.config.props.CB.Content.Changes"/>
        </td>
      </tr>
    </table>
    
  </td>
</tr>

<c:if test="${custPropsAvail}">
<tr>
  <td class="BlockLabel">&nbsp;</td>
  <logic:messagesPresent property="condition[${i}].customProperty">
  <c:set var="customPropertyErrs" value="true"/>
  </logic:messagesPresent>
  <c:choose>
  <c:when test="${customPropertyErrs}">
  <td class="ErrorField" nowrap>
  </c:when>
  <c:otherwise>
  <td class="BlockContent" nowrap>
  </c:otherwise>
  </c:choose>
    <html:radio property="condition[${i}].trigger" value="onCustProp"/>
    <fmt:message key="alert.config.props.CB.Content.CustomProperty"/>
    <html:select property="condition[${i}].customProperty">
      <html:option value="" key="alert.dropdown.SelectOption"/>
      <html:optionsCollection property="customProperties"/>
    </html:select>
    <fmt:message key="alert.config.props.CB.Content.Changes"/>
    <c:if test="${customPropertyErrs}">
    <br><span class="ErrorFieldContent">- <html:errors property="condition[${i}].customProperty"/></span>
    </c:if>
  </td>
</tr>
</c:if>

<c:if test="${controlEnabled}">
<tr>
  <td class="BlockLabel">&nbsp;</td>
  <logic:messagesPresent property="condition[${i}].controlAction">
  <c:set var="controlActionErrs" value="true"/>
  </logic:messagesPresent>
  <logic:messagesPresent property="condition[${i}].controlActionStatus">
  <c:set var="controlActionStatusErrs" value="true"/>
  </logic:messagesPresent>
  <c:choose>
  <c:when test="${controlActionErrs or controlActionStatusErrs}">
  <td class="ErrorField">
  </c:when>
  <c:otherwise>
  <td class="BlockContent">
  </c:otherwise>
  </c:choose>
    <html:radio property="condition[${i}].trigger" value="onEvent"/>
    <fmt:message key="alert.config.props.CB.Content.ControlAction"/>&nbsp;
    <html:select property="condition[${i}].controlAction">
    <html:option value="" key="alert.dropdown.SelectOption"/>
    <c:if test="${EditAlertDefinitionConditionsForm!=null}">
    <c:forEach var="myIndex" items="${EditAlertDefinitionConditionsForm.controlActions}">
      <c:set var="theLowerKey" value="${fn:toLowerCase(myIndex)}" />
      <fmt:message key="ca-${theLowerKey}" var="matchedKey" bundle="${cap}" />
      <c:choose>
         <c:when test="${fn:startsWith(matchedKey,'???')}">
          <html:option value="${myIndex}"><c:out value="${myIndex}"/></html:option>
         </c:when>
      
         <c:otherwise>
          <html:option value="${myIndex}"><fmt:message key="${matchedKey}" /></html:option>
         </c:otherwise>
      
      </c:choose>    
    </c:forEach>
    </c:if>
    
    <c:if test="${NewAlertDefinitionForm!=null}">
    <c:forEach var="myIndex" items="${NewAlertDefinitionForm.controlActions}">
      <c:set var="theLowerKey" value="${fn:toLowerCase(myIndex)}" />
      <fmt:message key="ca-${theLowerKey}" var="matchedKey" bundle="${cap}" />
      <c:choose>
         <c:when test="${fn:startsWith(matchedKey,'???')}">
          <html:option value="${myIndex}"><c:out value="${myIndex}"/></html:option>
         </c:when>
      
         <c:otherwise>
          <html:option value="${myIndex}"><fmt:message key="${matchedKey}" /></html:option>
         </c:otherwise>
      
      </c:choose>    
    </c:forEach>
    </c:if>
    
    </html:select>
    &nbsp;<fmt:message key="alert.config.props.CB.Content.Comparator.="/>&nbsp;
    <html:select property="condition[${i}].controlActionStatus">
    <html:option value="" key="alert.dropdown.SelectOption"/>
    <html:options property="controlActionStatuses"/>
    </html:select>
    <c:if test="${controlActionErrs}">
    <br><span class="ErrorFieldContent">- <html:errors property="condition[${i}].controlAction"/></span>
    </c:if>
    <c:if test="${controlActionStatusErrs}">
    <br><span class="ErrorFieldContent">- <html:errors property="condition[${i}].controlActionStatus"/></span>
    </c:if>
  </td>
</tr>
</c:if>

<c:if test="${logTrackEnabled}">
<tr>
  <td class="BlockLabel">&nbsp;</td>
  <td class="BlockContent" nowrap>
    <html:radio property="condition[${i}].trigger" value="onLog"/>
    <fmt:message key="alert.config.props.CB.Content.Log"/>
    <html:select property="condition[${i}].logLevel">
      <html:option value="-1" key="any"/>
      <html:option value="3" key="resource.common.monitor.label.events.Error"/>
      <html:option value="4" key="resource.common.monitor.label.events.Warn"/>
      <html:option value="6" key="resource.common.monitor.label.events.Info"/>
      <html:option value="7" key="resource.common.monitor.label.events.Debug"/>
    </html:select>
    <fmt:message key="alert.config.props.CB.Content.MatchSubstring"/>
    <html:text property="condition[${i}].logMatch" size="10" maxlength="150"/>
  </td>
</tr>
<tr>
  <td class="BlockLabel">&nbsp;</td>
  <td class="BlockContent" nowrap>
    <html:radio property="condition[${i}].trigger" value="onCfgChg"/>
    <fmt:message key="alert.config.props.CB.Content.FileMatch"/>
    <html:text property="condition[${i}].fileMatch" size="10" maxlength="150"/>
  </td>
</tr>
</c:if>

<c:if test="${numConditions != 1}">
<tiles:insert definition=".events.config.conditions.condition.deletelink">
  <tiles:put name="formName"><c:out value="${formName}"/></tiles:put> <%-- this is lame --%>
  <tiles:put name="i"><c:out value="${i}"/></tiles:put> <%-- this is lame --%>
</tiles:insert>
</c:if>
</c:forEach>
<script type="text/javascript">
						hqDojo.require("dijit.dijit");
			      hqDojo.require("dijit.Dialog");
			      hqDojo.require("dijit.ProgressBar");
</script>
<script type="text/javascript">
    function updateSelectOption() {
        var actStart = hqDojo.query("option[value='start']");
        for (var x = 0; x < actStart.length; x++) {
		  actStart[x].innerHTML = "<fmt:message key="resource.control.action.cmd.start"/>"
	    }
        var actStop = hqDojo.query("option[value='stop']");
        for (var x = 0; x < actStop.length; x++) {
	      actStop[x].innerHTML = "<fmt:message key="resource.control.action.cmd.stop"/>"
	    }
        var actRestart = hqDojo.query("option[value='restart']");
        for (var x = 0; x < actRestart.length; x++) {
	      actRestart[x].innerHTML = "<fmt:message key="resource.control.action.cmd.restart"/>"
	    }
        
        var statusInprocess = hqDojo.query("option[value='In Progress']");
        for (var x = 0; x < statusInprocess.length; x++) {
	      statusInprocess[x].innerHTML = "<fmt:message key="resource.control.action.status.inprogress"/>"  
	    }
        var statusInprocess1 = hqDojo.query("option[value='Completed']");
        for (var x = 0; x < statusInprocess1.length; x++) {
	      statusInprocess1[x].innerHTML = "<fmt:message key="resource.control.action.status.completed"/>"  
	    }
        var statusInprocess2 = hqDojo.query("option[value='Failed']");
        for (var x = 0; x < statusInprocess2.length; x++) {
	      statusInprocess2[x].innerHTML = "<fmt:message key="resource.control.action.status.failed"/>"  
        }	
}
window.onload= setTimeout(updateSelectOption ,199);   
</script>
