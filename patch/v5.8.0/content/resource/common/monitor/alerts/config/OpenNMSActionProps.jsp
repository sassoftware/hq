<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ include file="/common/replaceButton.jsp"%>

<html:form action="/alerts/SetOpenNMSAction">
	<table width="100%" cellpadding="0" cellspacing="0" border="0" class="TableBottomLine">
  		<logic:messagesPresent>
  			<tr>
    			<td colspan="4" align="left" class="ErrorField"><html:errors/></td>
  			</tr>
  		</logic:messagesPresent>
  		<tr>
    		<td class="BlockLabel"><fmt:message key="alert.config.edit.opennms.server"/></td>
    		<td class="BlockContent">
    		<logic:match name="OpenNMSForm" property="canModify" value="true">
	    		<html:text property="server"/>
	    	</logic:match>
	    	<logic:match name="OpenNMSForm" property="canModify" value="false">
	    		<html:text property="server" disabled="true" />
	    	</logic:match>
    		</td>
    		<td class="BlockLabel"><fmt:message key="alert.config.edit.opennms.port"/></td>
    		<td class="BlockContent">
    			<logic:match name="OpenNMSForm" property="canModify" value="true">
	    			<html:text property="port"/>
	    		</logic:match>
    			<logic:match name="OpenNMSForm" property="canModify" value="false">
	    			<html:text property="port" disabled="true"/>
	    		</logic:match>
    		</td>
  		</tr>
	</table>
	<html:hidden property="ad"/>
	<html:hidden property="id"/>
	<html:hidden property="aetid"/>
	<html:hidden property="eid"/>
	<logic:match name="OpenNMSForm" property="canModify" value="true">
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="ToolbarContent">
  			<tr>
  				<td align="center">
  					<html:image page="/images/tbb_set.gif" border="0" altKey="FormButtons.ClickToOk" property="ok" style="padding-right: 5px;"/>
    				<html:image page="/images/tbb_remove.gif" border="0" altKey="FormButtons.ClickToDelete" property="delete" style="padding-left: 5px;"/>
    			</td>
    		</tr>
		</table>
	</logic:match>
</html:form>
