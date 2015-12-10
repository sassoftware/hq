<%@ page language="java" %>
<%@ page errorPage="/common/Error.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib tagdir="/WEB-INF/tags/jsUtils" prefix="jsu" %>

<!--  SNMP CONFIG PROPERTIES TITLE -->
<tiles:insert definition=".header.tab">  
  <tiles:put name="tabKey" value="admin.settings.SNMPConfigPropTab"/>  
</tiles:insert>
<!--  /  -->

<jsu:script>
  function initSNMPForm() {
	var form = document.forms['SystemConfigForm'];
    snmpVersionChange(form.snmpVersion);
  }

  function snmpVersionChange(e) {
    showSnmpDiv(e.value);
  }

  function showSnmpDiv(v) {
	var allDiv = document.getElementById('snmpopts');
	var v1Div  = document.getElementById('snmpv1opts');
	var v2Div  = document.getElementById('snmpv1v2opts');
	var v3Div  = document.getElementById('snmpv3opts');

    if (v == '') {
        v1Div.style.display  = 'none';
        v2Div.style.display  = 'none';
        v3Div.style.display  = 'none';
        allDiv.style.display = 'none';
        return;
    }

    allDiv.style.display = '';

    if (v == '3') {
        v2Div.style.display = 'none';
        v3Div.style.display = '';
    }
    else {
        v2Div.style.display = '';
        v3Div.style.display = 'none';
    }

    if (v == '1') {
        v1Div.style.display = '';
    }
    else {
        v1Div.style.display = 'none';
    }
  }
  function checksnmpEngineID(){
    var snmpDefaultNotificationMechanismCtrl = document.forms['SystemConfigForm'].snmpDefaultNotificationMechanism;
    var snmpEngineIDCtrl = document.forms['SystemConfigForm'].snmpEngineID;
    var selectedIndex = snmpDefaultNotificationMechanismCtrl.options.selectedIndex;
    var theValue = snmpDefaultNotificationMechanismCtrl.options[selectedIndex].value ;
    if(theValue=="Inform"){
     snmpEngineIDCtrl.value="";
     snmpEngineIDCtrl.readOnly = true ;
     snmpEngineIDCtrl.style.backgroundColor="#CCCCCC" ;
    }
    else{
     snmpEngineIDCtrl.readOnly = false ;
     snmpEngineIDCtrl.style.backgroundColor="" ;
    }
  }
</jsu:script>
<jsu:script onLoad="true">
	initSNMPForm();
	checksnmpEngineID();
</jsu:script>
<!--  SNMP CONFIG PROPERTIES CONTENTS -->
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="BlockLabel" align="right" width="20%"><fmt:message key="admin.settings.SNMPVersion"/></td>
     <td width="30%" class="BlockContent">
    <html:select property="snmpVersion" onchange="snmpVersionChange(this)">
      <html:option key="admin.settings.SNMPNone" value=""/>
      <html:option value="3"/>
      <html:option value="2c"/>
      <html:option value="1"/>
    </html:select>
    </td>
      <td class="BlockContent" colspan="2">&nbsp;</td>
  </tr>
</table>

<div id="snmpopts" style="position: relative;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td colspan="4" class="BlockBottomLine"><div style="width: 1px; height: 1px;"/></td>
  </tr>
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPTrapOID"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpTrapOID"/></td>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPDefaultNotificationMechanism" /></td>
    <td width="30%" class="BlockContent">
		<html:select property="snmpDefaultNotificationMechanism" onchange="checksnmpEngineID();">
	        <html:option value="v1 Trap"/>
	        <html:option value="v2c Trap"/>
	        <html:option value="Inform"/>
	    </html:select>
	</td>
  </tr>
</table>
</div>

<div id="snmpv3opts" style="position: relative;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPSecurityName"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpSecurityName"/></td>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPLocalEngineID"/></td>
    <td width="30%" class="BlockContent"><c:out value="${snmpLocalEngineID}"/></td>
  </tr>
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPAuthProtocol"/></td>
    <td width="30%" class="BlockContent">
      <html:select property="snmpAuthProtocol">
        <html:option value="" key="common.label.None"/>
        <html:option value="MD5"/>
        <html:option value="SHA"/>
      </html:select>
    </td>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPAuthPassphrase"/></td>
    <td width="30%" class="BlockContent"><html:password size="31" property="snmpAuthPassphrase" redisplay="true"/></td>
  </tr>
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPPrivProtocol"/></td>
    <td width="30%" class="BlockContent">
      <html:select property="snmpPrivacyProtocol">
        <html:option value="" key="common.label.None"/>
        <html:option value="DES" key="admin.settings.snmp.privacy.DES"/>
        <html:option value="3DES" key="admin.settings.snmp.privacy.3DES"/>
        <html:option value="AES" key="admin.settings.snmp.privacy.AES128"/>
        <html:option value="AES192" key="admin.settings.snmp.privacy.AES192"/>
        <html:option value="AES256" key="admin.settings.snmp.privacy.AES256"/>
      </html:select>
    </td>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPPrivPassphrase"/></td>
    <td width="30%" class="BlockContent"><html:password size="31" property="snmpPrivacyPassphrase" redisplay="true"/></td>
  </tr>
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPEngineID"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpEngineID"/></td>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPContextName"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpContextName"/></td>
  </tr>
</table>
</div>

<div id="snmpv1v2opts" style="position: relative;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPCommunity"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpCommunity"/></td>
    <td width="20%" class="BlockLabel">&nbsp;</td>
    <td width="30%" class="BlockContent">&nbsp;</td>
  </tr>
</table>
</div>

<div id="snmpv1opts" style="position: relative;">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPGenericID"/></td>
    
    <logic:messagesPresent property="snmpGenericID">
 		<c:set var="snmpGenericIDClassName" value="ErrorField" />
    </logic:messagesPresent>
    <logic:messagesNotPresent property="snmpGenericID">
    	<c:set var="snmpGenericIDClassName" value="BlockContent" />
    </logic:messagesNotPresent>
    
    <td width="30%" class="<c:out value='${snmpGenericIDClassName}' />"><html:text size="31" property="snmpGenericID"/>
    <logic:messagesPresent property="snmpGenericID">
    	<span class="ErrorFieldContent">- <html:errors property="snmpGenericID"/></span>
    </logic:messagesPresent>
    </td> 
    
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPSpecificID"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpSpecificID"/></td>
  </tr>
   
  <tr>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPEnterpriseOID"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpEnterpriseOID"/></td>
    <td width="20%" class="BlockLabel"><fmt:message key="admin.settings.SNMPAgentAddress"/></td>
    <td width="30%" class="BlockContent"><html:text size="31" property="snmpAgentAddress"/></td>
  </tr>
</table>
</div>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="BlockBottomLine"><div style="width: 1px; height: 1px;"/></td>
  </tr>
</table>
<!--  /  -->
