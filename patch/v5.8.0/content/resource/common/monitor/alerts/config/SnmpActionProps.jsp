<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic" %>
<%@ include file="/common/replaceButton.jsp"%>
<script type="text/javascript">
window.onload = function() {
	setDefaultSnmpTrapOID();
	setSnmptrapOIDVisibility();
	setVariableBindings();
}

    function setVariableBindings(){
         var vbInput = document.forms[0].variableBindings;
         var vbOids = document.getElementsByName("snmpVarbindOID");
         var vbValues = document.getElementsByName("snmpVarbindValue");
         var paramsJason;
         var i = 0;
         
         /* parse variable bindings to JASON */
         paramsJason = JSON.parse(vbInput.value);
         for (var i = 0; i < paramsJason.length; i++) {
        	 addVariableBinding();
             vbOids[i].value = paramsJason[i].oid;
             vbValues[i].value = paramsJason[i].value;
         }
    }
      
    function setDefaultSnmpTrapOID() {
        var snmpTrapOid = document.forms[0].snmpTrapOID;
        var isDefaultSnmpTrapOID = document.forms[0].isDefaultSnmpTrapOID;
        
        if ((snmpTrapOid.value != null) && (snmpTrapOid.value.length > 0) && (snmpTrapOid.value != "")) {
        	isDefaultSnmpTrapOID.checked = false;
        	snmpTrapOid.disabled = false;
        } else {
        	isDefaultSnmpTrapOID.checked = true;
        	snmpTrapOid.value = "";
        	snmpTrapOid.disabled = true;
        }
    }
    
    function changeIsDefaultSnmpTrapOID(el) {
        var snmpTrapOid = document.forms[0].snmpTrapOID;
        
        if (el.checked) {
        	snmpTrapOid.value = "";
            snmpTrapOid.disabled = true;
        } else {
        	snmpTrapOid.disabled = false;
        }
    }
    
    function addVariableBinding() {
        var parentDiv = hqDojo.byId('snmpVarbindDiv');
        var vbDiv = document.createElement('div');
        var vbArray = document.getElementsByName("snmpVarbindOID");
        var vbDivNum = vbArray.length + 1; 
        
        /* Add index (array size +1) to variable id */
        vbDiv.id = "snmpVarbindDiv_" + vbDivNum;
        /* display OID and Value fields */
        vbDiv.innerHTML = '<br/>'
            + '<fmt:message key="alert.config.escalation.action.snmp.oid"/> <fmt:message key="inform.config.escalation.scheme.OID"/><br>'
            + '<input type=text name="snmpVarbindOID" style="width:250px"><br>'
            + '<fmt:message key="common.label.escalation.param.values"/><br>'
            + '<input type=text name="snmpVarbindValue" style="width:250px"><br>'
            + '<a href="javascript:removeVariableBinding(' + vbDivNum + ');"><fmt:message key="alert.config.escalation.action.snmp.varbinds.remove"/></a><br/>';
        /* Add OID and Value to div */
        parentDiv.appendChild(vbDiv);    
    }
    
    function removeVariableBinding(snmpVarbindIndex) {
        var vbDiv = hqDojo.byId('snmpVarbindDiv_' + snmpVarbindIndex);
    
        // remove element
        Element.remove(vbDiv);
        
        // update UI
        rebuildVariableBindings();
    }
    
    function rebuildVariableBindings() {
        //var vbInput = hqDojo.byId('variableBindingsInput');
        var vbInput = document.forms[0].variableBindings;
        var vbOids = document.getElementsByName("snmpVarbindOID");
        var vbValues = document.getElementsByName("snmpVarbindValue");
        
        var vbsArray = [];
        var vbsCount = 0;
        for (var s = 0; s < vbOids.length; s++) {
            if (vbOids[s].value.length > 0 && vbValues[s].value.length > 0) {
                vbsArray[vbsCount++] = {oid: vbOids[s].value, value: vbValues[s].value};
            }
        }
        vbInput.value = vbsArray.toJSON();
    }
    
    function changeSnmptrapOIDVisibility(el) {
        var trapDefaultDiv = hqDojo.byId('trapDefaultDiv');
        var trapOIDDiv = hqDojo.byId('trapOIDDiv');
        
        /* Check snmpNotificationMechanism value */
        if (el.value == "v1 Trap" ) {
        	trapDefaultDiv.style.display = "none";
        	trapOIDDiv.style.display = "none";
        } else {
        	trapDefaultDiv.style.display = "";
        	trapOIDDiv.style.display = "";
        }        
    }
    
    function setSnmptrapOIDVisibility() {
        var snmpNotificationMechanism = document.forms[0].snmpNotificationMechanism;
        
        /* Set SNMP Trap OID visibility */
        changeSnmptrapOIDVisibility(snmpNotificationMechanism);
    }
</script>

<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <logic:messagesPresent>
        <tr>
            <td colspan="4" align="left" class="ErrorField"><html:errors/></td>
        </tr>
    </logic:messagesPresent>
    <tr>
        <td width="20%" class="BlockContent" nowrap="true">&nbsp;</td>
        <td width="30%" class="BlockContent"><fmt:message key="inform.config.escalation.scheme.IPAddress"/></td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>
        <td width="20%" class="BlockLabel" nowrap="true"><fmt:message key="alert.config.edit.snmp.address"/></td>
        <td width="30%" class="BlockContent">
            <logic:match name="SnmpTrapForm" property="canModify" value="true">
                <html:text size="40" property="address"/>
            </logic:match>
            <logic:match name="SnmpTrapForm" property="canModify" value="false">
                <html:text size="40" property="address" disabled="true"/>
            </logic:match>
        </td>
        <td width="20%" class="BlockLabel" nowrap="true"><fmt:message key="alert.config.edit.snmp.notificationMechanism"/></td>
        <td width="30%" class="BlockContent">
            <logic:match name="SnmpTrapForm" property="canModify" value="true">
                <html:select property="snmpNotificationMechanism" onchange="changeSnmptrapOIDVisibility(this)">
                    <html:option value="v1 Trap"/>
                    <html:option value="v2c Trap"/>
                    <html:option value="Inform"/>
                </html:select>
            </logic:match>
            <logic:match name="SnmpTrapForm" property="canModify" value="false">
                <html:select property="snmpNotificationMechanism" disabled="true">
                    <html:option value="v1 Trap"/>
                    <html:option value="v2c Trap"/>
                    <html:option value="Inform"/>
                </html:select>          
            </logic:match>
        </td>
    </tr>
    <tr id="trapDefaultDiv">
        <td width="20%" class="BlockLabel"><fmt:message key="alert.config.edit.snmp.defaultTrapOid"/></td> 
        <td width="30%" class="BlockContent">
           <logic:match name="SnmpTrapForm" property="canModify" value="true">
                <html:checkbox property="isDefaultSnmpTrapOID" onclick="changeIsDefaultSnmpTrapOID(this)"/>
           </logic:match>
            <logic:match name="SnmpTrapForm" property="canModify" value="false">
                <html:checkbox property="isDefaultSnmpTrapOID" disabled="true"/>
            </logic:match>
        </td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr id="trapOIDDiv">
        <td width="20%" class="BlockLabel"><fmt:message key="alert.config.edit.snmp.trapOid"/></td>
        <td width="30%" class="BlockContent">
            <logic:match name="SnmpTrapForm" property="canModify" value="true">
                <html:text size="30" property="snmpTrapOID"/>
            </logic:match>
            <logic:match name="SnmpTrapForm" property="canModify" value="false">
                <html:text size="30" property="snmpTrapOID" disabled="true"/>
            </logic:match>
        </td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent"><fmt:message key="alert.config.escalation.action.snmp.varbinds"/><hr></td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent"><fmt:message key="inform.config.escalation.scheme.OID"/></td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>
        <td width="20%" class="BlockLabel"><fmt:message key="alert.config.edit.snmp.oid"/></td>
        <td width="30%" class="BlockContent">
            <logic:match name="SnmpTrapForm" property="canModify" value="true">
                <html:text size="30" property="oid"/>
            </logic:match>
            <logic:match name="SnmpTrapForm" property="canModify" value="false">
                <html:text size="30" property="oid" disabled="true"/>
            </logic:match>
        </td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent"><fmt:message key="alert.config.edit.snmp.oidValue"/></td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>   
        <td width="20%" class="BlockContent">     
        <td width="30%" class="BlockContent">
            <logic:match name="SnmpTrapForm" property="canModify" value="true">
                <html:text size="30" property="variableBindings" style="display: none; visibility: hidden;"/>
            </logic:match>
            <logic:match name="SnmpTrapForm" property="canModify" value="false">
                <html:text size="30" property="variableBindings" disabled="true" style="display: none; visibility: hidden;"/>
            </logic:match>
        </td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
    <tr>
        <td colspan="4" class="BlockBottomLine"><div style="width: 1px; height: 1px;"/></td>
    </tr>
    <tr>
        <td width="20%" class="BlockContent"></td>
        <td width="30%" class="BlockContent">
            <div id="snmpVarbindDiv"/></td>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
        <tr>
        <td width="20%" class="BlockContent"></td>
        <td width="30%" class="BlockContent">
            <html:link href="javascript:addVariableBinding()"><fmt:message key="alert.config.escalation.action.snmp.varbinds.add"/>
            </html:link>
        <td width="20%" class="BlockContent">&nbsp;</td>
        <td width="30%" class="BlockContent">&nbsp;</td>
    </tr>
</table>

                        
<logic:match name="SnmpTrapForm" property="canModify" value="true">
    <table width="100%" cellpadding="5" cellspacing="0" border="0" class="ToolbarContent">
        <tr>
            <td><html:image page="/images/tbb_set.gif" border="0" altKey="FormButtons.ClickToOk" property="ok" onclick="rebuildVariableBindings();"/></td>
            <td><html:image page="/images/tbb_remove.gif" border="0" altKey="FormButtons.ClickToDelete" property="delete"/></td>
            <td width="100%">&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4" class="BlockBottomLine"><div style="width: 1px; height: 1px;"/></td>
        </tr>
    </table>
</logic:match>

