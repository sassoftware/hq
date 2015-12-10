<%@ page language="java"%>
<%@ page errorPage="/common/Error.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/tld/hq.tld" prefix="hq" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<%--
  NOTE: This copyright does *not* cover user programs that use HQ
  program services by normal system calls through the application
  program interfaces provided as part of the Hyperic Plug-in Development
  Kit or the Hyperic Client Development Kit - this is merely considered
  normal use of the program, and does *not* fall under the heading of
  "derived work".
  
  Copyright (C) [2004, 2005, 2006], Hyperic, Inc.
  This file is part of HQ.
  
  HQ is free software; you can redistribute it and/or modify
  it under the terms version 2 of the GNU General Public License as
  published by the Free Software Foundation. This program is distributed
  in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A
  PARTICULAR PURPOSE. See the GNU General Public License for more
  details.
  
  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  USA.
 --%>

<%-- Don't insert the sub-tiles if there is no alert and no alertDef. --%>
<c:if test="${not empty alert}">
	<c:set var="alertDef" value="${GroupAlertDefinitionForm}" />

	<html:form action="/alerts/Alerts">
		<input type=hidden name="a" value="<c:out value="${alert.id}"/>" />
		<input type=hidden name="mode" id="mode" value="" />
		<input type=hidden name="eid" value="<c:out value="${Resource.entityId}"/>" />

		<tiles:insert definition=".page.title.events">
			<tiles:put name="titleKey" value="alert.current.detail.PageTitle" />
		</tiles:insert>

		<tiles:insert definition=".events.alert.view.nav" flush="true" />
		<tiles:insert definition=".portlet.confirm" />
		<tiles:insert definition=".portlet.error" />

		<!-- Content Block Title: Properties -->
		<tiles:insert definition=".header.tab">
			<tiles:put name="tabKey" value="alert.current.detail.props.Title" />
		</tiles:insert>

		<!-- Properties Content -->
		<table width="100%" cellpadding="0" cellspacing="0" class="TableBottomLine">
			<tr>
				<td colspan="100%" class="BlockContent">
					<html:img page="/images/spacer.gif" width="1" height="1" border="0" />
				</td>
			</tr>
			<tr valign="top">
				<td width="20%" class="BlockLabel">
					<fmt:message key="common.label.Name" />
				</td>
				<td width="30%" class="BlockContent">
					<c:choose>
						<c:when test="${not empty Resource}">
							<html:link action="/alerts/Config" titleKey="alert.config.props.PB.ViewDef">
								<html:param name="mode" value="viewGroupDefinition"/>
								<html:param name="eid" value="${Resource.entityId.appdefKey}"/>
								<html:param name="ad" value="${alert.definition.id}"/>
								${alertDef.name}
							</html:link>
						</c:when>
						<c:otherwise>
							<c:out value="${alertDef.name}" />
						</c:otherwise>
					</c:choose>
				</td>
				<td width="20%" class="BlockLabel">
					<fmt:message key="alert.config.props.PB.Priority" />
				</td>
				<td width="30%" class="BlockContent">
					<fmt:message key="${'alert.config.props.PB.Priority.'}${alertDef.priority}" />
				</td>
			</tr>
			<tr valign="top">
				<td class="BlockLabel">
					<fmt:message key="common.label.Resource" />
				</td>
				<td class="BlockContent">
					<html:link action="/Resource" paramId="eid" paramName="Resource" paramProperty="entityId">
						<c:out value="${Resource.name}" />
					</html:link>
				</td>
				<td class="BlockLabel">
					<fmt:message key="alert.current.detail.props.AlertDate" />
				</td>
				<td class="BlockContent">
					<hq:dateFormatter time="false" value="${alert.timestamp}" />
				</td>
			</tr>
			<tr valign="top">
				<td class="BlockLabel">&nbsp;
					<c:if test="${not empty alertDef.description}">
						<fmt:message key="common.label.Description" />
					</c:if>
				</td>
				<td class="BlockContent">
					<c:out value="${alertDef.description}" />
				</td>
				<td class="BlockLabel">
					<fmt:message key="alert.config.props.PB.AlertStatus" />
				</td>
				<td width="30%" class="BlockContent">
					<!-- For now, the alert is fixed, or not fixed -->
					<c:choose>
						<c:when test="${alert.fixed}">
							<html:img page="/images/icon_fixed.gif" width="12" height="12" border="0" />
							<fmt:message key="resource.common.alert.action.fixed.label" />
						</c:when>
						<c:otherwise>
							<html:img page="/images/icon_available_red.gif" width="12" height="12" border="0" />
							<fmt:message key="resource.common.alert.action.notfixed.label" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr valign="top">
				<td class="BlockLabel">
					<fmt:message key="alert.view.details" />
				</td>
				<td class="BlockContent" colspan="3">
					<c:out value="${alert.longReason}" />
				</td>
			</tr>
			<c:forEach var="log" varStatus="status" items="${auxLogs}">
				<tr>
					<td class="BlockLabel">
						<span class="italicInfo">
							<hq:dateFormatter value="${log.timestamp}" /> <fmt:message key="common.label.Dash" />
						</span>
					</td>
					<td colspan="3" class="BlockContent">
						<c:out value="${log.description}" />
					</td>
				</tr>
			</c:forEach>
		</table>&nbsp;
		<br>

		<tiles:insert definition=".header.tab">
			<tiles:put name="tabKey" value="monitoring.events.MiniTabs.Escalation" />
		</tiles:insert>

		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<c:if test="${not empty escalation}">
				<tr>
					<td width="20%" class="BlockLabel">
						<fmt:message key="common.header.EscalationName" />
					</td>
					<td class="BlockContent" colspan="2">
						<c:out value="${escalation.name}" />
					</td>
				</tr>
				<tr>
					<td colspan="3" class="BlockContent">
						<tiles:insert page="/resource/common/monitor/alerts/config/ViewEscalation.jsp">
							<tiles:put name="chooseScheme" value="false" />
						</tiles:insert>
					</td>
				</tr>
			</c:if>
			<tr>
				<td width="20%" class="BlockLabel" style="padding-left: 4px;">
					<fmt:message key="common.label.EscalationActionLogs" />
				</td>
				<td class="BlockContent" colspan="2">&nbsp;</td>
			</tr>
			<c:forEach var="log" varStatus="status" items="${actionLogs}">
				<tr>
					<td class="BlockLabel">
						<span class="italicInfo">
							<hq:dateFormatter value="${log.timeStamp}" /> 
							<fmt:message key="common.label.Dash" />
						</span>
					</td>
					<td colspan="3" class="BlockContent">
						<c:out value="${log.detail}" />
					</td>
				</tr>
			</c:forEach>
			<c:if test="${not empty escalation && acknowledgeable && canTakeAction}">
	  			<tr>
	    			<td width="20%" class="BlockLabel" valign="top" align="right">
	    				<span class="BoldText"><fmt:message key="resource.common.alert.ackNote"/></span>
	    			</td>
	    			<td colspan="2" class="BlockContent">
	        			<html:textarea property="ackNote" cols="70" rows="4"/>	  
	    			</td>
	  			</tr>
	  			<tr>
	    			<td width="20%" class="BlockLabel">&nbsp;</td>
		    		<td width="80%" class="BlockContent">
				 		<c:if test="${escalation.pauseAllowed}">
					  		<div id="AlertEscalationOption" syle="text-align:left;">
					     		<input type="checkbox" name="pause" value="true" checked="checked" onclick="hqDojo.byId('pauseTimeSel').disabled = !this.checked;" />&nbsp;<fmt:message key="alert.escalation.pause"/>
					  		</div>	  
				  		</c:if>&nbsp;
		          		<div style="text-align:left;">
					  		<tiles:insert page="/common/components/ActionButton.jsp">
		  			     		<tiles:put name="labelKey" value="resource.common.alert.action.acknowledge.label"/>
		                 		<tiles:put name="buttonClick">hqDojo.byId('mode').setAttribute('value', '<fmt:message key="resource.common.alert.action.acknowledge.label"/>'); document.forms[0].submit();</tiles:put>
		              		</tiles:insert>
		          		</div>
		    		</td>
		  		</tr>
			</c:if>
		</table>
		<jsu:script>
	  		var isButtonClicked = false;
	  	  
	  		function checkSubmit() {
	    		if (isButtonClicked) {
	      			alert('<fmt:message key="error.PreviousRequestEtc"/>');
	     	 		return false;
	    		}
	  		}
	
	  		var escalationSpan = hqDojo.byId("AlertEscalationOption");
	
	  	  	if (escalationSpan != null) {
		  		escalationSpan.appendChild(hyperic.form.createEscalationPauseOptions({id: "pauseTimeSel", name: "pauseTime"}, <c:out value="${escalation.maxPauseTime}"/>));
	  		}
		</jsu:script>
		<c:if test="${canTakeAction}">
			<tiles:insert definition=".header.tab">
	  			<tiles:put name="tabKey" value="resource.common.alert.action.fix.header"/>
			</tiles:insert>                                                                                                                           
			<table cellpadding="10" cellspacing="0" border="0" width="100%" id="fixedSection">
				<tr>
					<c:choose>
						<c:when test="${not alert.fixed}">
							<c:if test="${not empty fixedNote}">
					  			<td class="BlockContent" align="right" valign="top" width="20%">
					    			<div class="BoldText"><fmt:message key="resource.common.alert.previousFix"/></div>
					    		</td>
					    		<td class="BlockContent" colspan="2" width="80%">    		
					       			<c:out value="${fixedNote}"/>
					       		</td>
					       	</tr>
					       	<tr>
					    	</c:if>
					    	
					    		<td class="BlockLabel" align="right" valign="top" width="20%"><fmt:message key="resource.common.alert.fixedNote"/></td>
					    		<td class="BlockContent" colspan="2" width="80%">
					    			<html:textarea property="fixedNote" cols="70" rows="5" />
					  			</td>
							</tr>
							<tr>
					  			<td class="BlockContent" width="20%" align="right">&nbsp;</td>
					  			<td class="BlockContent" width="5%" style="padding-top: 6px; padding-bottom: 6px;">
						</c:when>
						<c:when test="${not empty fixedNote}">
					  		<td class="BlockContent" width="20%" align="right">&nbsp;</td>
					  		<td class="BlockContent">
					  			<div style="padding: 4px; 0"><c:out value="${fixedNote}"/></div>
						</c:when>
						<c:otherwise>
							<td class="BlockContent" width="20%" align="right">&nbsp;</td>	
					  		<td class="BlockContent">
					  			<div style="padding: 4px 0;"><fmt:message key="resource.common.alert.beenFixed"/></div>
						</c:otherwise>
					</c:choose>
					<tiles:insert page="/common/components/ActionButton.jsp">
	  					<tiles:put name="labelKey" value="resource.common.alert.action.fixed.label"/>
	  					<tiles:put name="buttonClick">hqDojo.byId('mode').setAttribute('value', 'FIXED'); document.forms[0].submit();</tiles:put>
	  					<tiles:put name="icon"><html:img page="/images/icon_fixed.gif" alt="Click to mark as Fixed" align="middle"/></tiles:put>
	  					<c:choose>
					  	 <c:when test="${not alert.fixed}">
					     	<tiles:put name="disabled" value="false"/>
					     </c:when>
					     <c:otherwise>
					        <tiles:put name="hidden" value="true"/>
					     </c:otherwise>
					  	</c:choose>
					</tiles:insert>
	    			<c:if test="${not alert.fixed}">
	      				<td class="BlockContent">
	        				<fmt:message key="resource.common.alert.clickToFix"/>
	      				</td>
	    			</c:if>
	  			</td>
			</tr>
			</table>
		</c:if>
		<tiles:insert definition=".events.alert.view.nav" flush="true" />
		<tiles:insert definition=".page.footer" />
	</html:form>
</c:if>